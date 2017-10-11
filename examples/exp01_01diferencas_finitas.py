import numpy as np
import matplotlib.pyplot as plt

dx = 0.1
x = np.arange(0, np.pi, dx)

f = np.sin(x)
df_a1 = np.cos(x)
df2_a = -np.sin(x)

# jmax = x.shape[0]

df_ava = np.zeros_like(x)
df_ret = np.zeros_like(x)
df_cen = np.zeros_like(x)
df2 = np.zeros_like(x)

# computing derivatives
df_ava[:-1] = (f[1:] - f[:-1]) / dx
df_ret[1:] = (f[1:] - f[:-1]) / dx
df_cen[1:-1] = (f[2:] - f[:-2]) / 2 / dx
df2[1:-1] = (f[2:] - 2 * f[1:-1] + f[:-2]) / dx / dx

# print f[1:].shape
# print f[:-1].shape
plt.plot(x, f)
plt.plot(x, df_a1)
plt.plot(x[:-1], df_ava[:-1])
plt.plot(x[1:], df_ret[1:])
plt.plot(x[1:-1], df_cen[1:-1])
plt.show()
plt.plot(x, f)
plt.plot(x, df2_a)
plt.plot(x[1:-1], df2[1:-1])
plt.show()
