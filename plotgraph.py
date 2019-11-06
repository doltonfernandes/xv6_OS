import matplotlib.pyplot as plt

f = open("./graph.txt","r");
inp = f.read().split("\n");
f.close()

graph = [ [ [] , [] ] , [ [] , [] ] , [ [] , [] ] ]

for i in range(3):
	graph[i][0].append(0)
	graph[i][1].append(1)

maxil=-1
maxir=-1

mapp = {}
mapp[5] = 0
mapp[7] = 1
mapp[8] = 2

for i in inp:
	j = i.split(" ")
	if (int(j[0])!=5 and int(j[0])!=8 and int(j[0])!=7) or len(j)!=3:
		continue;
	graph[mapp[int(j[0])]][0].append(int(j[1]));
	graph[mapp[int(j[0])]][1].append(int(j[2]));
	maxil=max(maxil,int(j[1]))
	maxir=max(maxir,int(j[2]))

maxil += 100;
maxir += 1;

plt.xlabel("Ticks")
plt.ylabel("Queue")

plt.title("Comparison Chart")

print(graph)

plt.plot([0],[0])
plt.plot(graph[0][0], graph[0][1], marker='o', linewidth=2, markersize=10,label = 'FCFS')
plt.plot(graph[1][0], graph[1][1], marker='^', linewidth=2, markersize=10,label = 'PBS')
plt.plot(graph[2][0], graph[2][1], marker='s', linewidth=2, markersize=10,label = 'MLFQ')
plt.plot([maxil],[maxir])
plt.legend(loc='best')
plt.show()