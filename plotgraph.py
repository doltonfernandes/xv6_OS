import matplotlib.pyplot as plt

f = open("./graph.txt","r");
inp = f.read().split("\n");
f.close()

graph = [ [ [] , [] ] , [ [] , [] ] , [ [] , [] ] ]

for i in range(3):
	graph[i][0].append(0)
	graph[i][1].append(0)

i = 0

cnt = 0

for i in inp:
	if i == '.':
		cnt+=1
		if cnt == 3:
			break;
		continue
	j = i.split(";")
	graph[cnt][0].append(int(j[0]));
	graph[cnt][1].append(int(j[1]));

plt.xlabel("Ticks")
plt.ylabel("Queue")

plt.title("Comparison Chart")

# plt.plot(graph[0][0],graph[0][1],"bo",label = 'FCFS')

print(graph)

plt.plot(graph[0][0], graph[0][1], marker='o', linewidth=2, markersize=15,label = 'FCFS')
plt.plot(graph[1][0], graph[1][1], marker='^', linewidth=2, markersize=15,label = 'PBS')
plt.plot(graph[2][0], graph[2][1], marker='s', linewidth=2, markersize=15,label = 'MLFQ')
plt.legend(loc='best')
plt.show()