#!/home/subhankar/anaconda3/envs/ml/bin/python
# -*- coding: utf-8 -*-
"""
Created on Wed Jul 22 14:25:59 2020

@author: subhankar
"""


import numpy as np
from networkx.generators.random_graphs import erdos_renyi_graph
import matplotlib.pyplot as plt
import time
import networkx as nx
from tqdm import tqdm

def metropolis_weights(g):
    n_nodes = len(g.nodes())
    metropolis_weights = np.zeros((n_nodes, n_nodes))
    for i in range(n_nodes):
        for j in range(i):
            if ((i, j) in g.edges()) or ((j, i) in g.edges()):
                metropolis_weights[i, j] = 1/(1+max(g.degree(i), g.degree(j)))
                metropolis_weights[j, i] = 1/(1+max(g.degree(i), g.degree(j)))
    for i in range(n_nodes):
        neighbors = [n for n in g.neighbors(i)]
        count = 0
        for neighbor in neighbors:
            count += metropolis_weights[i, neighbor]
        metropolis_weights[i, i] = 1-count

    return metropolis_weights


def generate_random_graph(n_nodes, edge_probability):
    return erdos_renyi_graph(n_nodes, edge_probability)


if __name__ == "__main__":
    error = 1e8
    threshold = 1e-10
    m = 5
    m_range = 20
    m_vals = np.arange(m_range)+2
    pc = 0.5
    scale_factor = 100
    x_init_bias = 50
    highest_a_val = 50
    lowest_a_val = 0
    a_val_bias = 10
    x_old = np.random.rand(m)*scale_factor-x_init_bias
    x_new = x_old.copy()
    lambda_old = np.random.rand(m)
    lambda_new = lambda_old.copy()
    x_hist = x_old.copy()
    lambda_hist = lambda_old.copy()
    a = np.random.randint(lowest_a_val, highest_a_val, size=m)-10
    alpha = .01
    times = np.zeros(len(m_vals))
    iterations = np.zeros(len(m_vals))
    
    print("Starting for a random generation of a")
    start = time.time()
    while error > threshold:
        graph = generate_random_graph(m, pc)
        adjacency_mat = metropolis_weights(graph)
        for i in range(m):
            x_new[i] = max(0, x_old[i] - alpha*(2*(x_old[i]-a[i])+np.sum(adjacency_mat[i].reshape(-1, 1)*(
                x_old[i]-x_old))+np.sum(adjacency_mat[i].reshape(-1, 1)*(lambda_old[i]-lambda_old))))
        for i in range(m):
            lambda_new[i] = lambda_old[i]+alpha * \
                np.sum(adjacency_mat[i].reshape(-1, 1)*(x_new[i]-x_new))
        x_hist = np.vstack((x_hist, x_new))
        lambda_hist = np.vstack((lambda_hist, lambda_new))
        error = np.max(np.abs(x_old-x_new))
        x_old = x_new.copy()
        lambda_old = lambda_new.copy()

    time_taken = time.time() - start
    legend = []
    for i in range(m):
        legend.append("x"+str(i+1))

    for i in range(m):
        plt.plot(x_hist[:, i])
    plt.legend(legend)
    plt.title(f"Convergence plot pc {pc} and epsilon = {threshold}")
    plt.xlabel("Number of iterations")
    plt.ylabel("Value of x")
    plt.grid(True)
    plt.show()

    expected_value_of_x = np.ones(m)*np.mean(a) if np.sum(a)>=0 else np.zeros(m)
    print("A values:\t", a)
    print("Initial value of x at each node:\t", x_hist[0])
    print("Learning rate:\t", alpha)
    print("Epsilon suboptimality:\t", threshold)
    print("Number of nodes:\t", m)
    print("probability of each edge:\t", pc)
    print("Final value of x at each node:\t", x_hist[-1])
    print("Correct optimal value of x at each node:\t", expected_value_of_x)
    print("MSE betweem final value and correct value:\t",
          np.mean((expected_value_of_x-x_hist[-1])**2))
    print("Iterations takes:\t", len(x_hist))
    print("Time taken in seconds:\t", time_taken)

    for j in tqdm(range(len(m_vals))):
        m = m_vals[j]
        error = 1e8
        x_old = np.random.rand(m)*scale_factor-x_init_bias
        x_new = x_old.copy()
        lambda_old = np.random.rand(m)
        lambda_new = lambda_old.copy()
        x_hist = x_old.copy()
        lambda_hist = lambda_old.copy()
        a = np.random.randint(lowest_a_val, highest_a_val, size=m)-10
        start = time.time()

        while error > threshold:
            graph = generate_random_graph(m, pc)
            adjacency_mat = metropolis_weights(graph)
            for i in range(m):
                x_new[i] = max(0, x_old[i] - alpha*(2*(x_old[i]-a[i])+np.sum(adjacency_mat[i].reshape(-1, 1)*(
                    x_old[i]-x_old))+np.sum(adjacency_mat[i].reshape(-1, 1)*(lambda_old[i]-lambda_old))))
            for i in range(m):
                lambda_new[i] = lambda_old[i]+alpha * \
                    np.sum(adjacency_mat[i].reshape(-1, 1)*(x_new[i]-x_new))
            x_hist = np.vstack((x_hist, x_new))
            lambda_hist = np.vstack((lambda_hist, lambda_new))
            error = np.max(np.abs(x_old-x_new))
            x_old = x_new.copy()
            lambda_old = lambda_new.copy()

        time_taken = time.time() - start
        times[j] = time_taken
        n_iters = len(x_hist)
    
    plt.plot(m_vals, times)
    plt.xlabel("Nodes in the graph")
    plt.title("Speed of convergence analysis")
    plt.ylabel("Time taken in seconds")
    plt.grid(True)
    plt.show()