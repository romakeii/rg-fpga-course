import numpy as np
import os

WIDTH = 8
AMOUNT_OF_DATA = 16
AMOUNT_OF_PACKET = 4


def main():

    print('fifo_mult_stream_acc model')

    max_val = 2**(WIDTH - 1) - 1
    min_val = -2**(WIDTH - 1)
    data_out = np.zeros(AMOUNT_OF_DATA, np.int32)

    data_in1 = np.random.randint(min_val, max_val, (AMOUNT_OF_PACKET, AMOUNT_OF_DATA))
    data_in2 = np.random.randint(min_val, max_val, (AMOUNT_OF_PACKET, AMOUNT_OF_DATA))
    data_fifo_mult = np.array(data_in1 * data_in2)

    np.savetxt(os.path.dirname(__file__) + os.sep + "data_mult.txt", np.reshape(data_fifo_mult, AMOUNT_OF_PACKET * AMOUNT_OF_DATA), fmt='%d')

    for i in range(AMOUNT_OF_PACKET):
        data_out = np.array(data_out + data_fifo_mult[i])

    np.savetxt(os.path.dirname(__file__) + os.sep  + "data_in1.txt", np.reshape(data_in1, AMOUNT_OF_PACKET * AMOUNT_OF_DATA), fmt='%d')
    np.savetxt(os.path.dirname(__file__) + os.sep  + "data_in2.txt", np.reshape(data_in2, AMOUNT_OF_PACKET * AMOUNT_OF_DATA), fmt='%d')
    np.savetxt(os.path.dirname(__file__) + os.sep  + "data_ref.txt", data_out, fmt='%d')


main()
test = 2
