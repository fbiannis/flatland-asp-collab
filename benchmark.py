import time
benchmarking = True
def benchmark(flatlandASP):
    #solve 100 times and take the average time
    solvetimes = []
    for i in range(100):
        # Ground the program
        starttime = time.time()
        flatlandASP.clingo_control.solve(
                on_model=lambda x: flatlandASP._on_clingo_model(x))
        endtime = time.time()
        solvetimes.append(endtime-starttime)

    avg = sum(solvetimes)/len(solvetimes)

    with open("bm_results.txt", 'w') as f:
        f.write("{}\n".format(avg))
    f.close
