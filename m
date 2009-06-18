From: Markus Trippelsdorf <markus@trippelsdorf.de>
Subject: Read errors while benchmarking
Date: Thu, 18 Jun 2009 10:24:26 +0200
Message-ID: <q6apg6-5d2.ln1@phenom2.trippelsdorf.de>
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

I'm running the latest git kernel and git btrfs-progs. 
When I try to run some benchmarks on my btrfs partition I always get
read errors:

phenom2 ~ # iozone -I -a -s 100M -r 4k -i 0 -i 1 -i 2
        Iozone: Performance Test of File I/O
                Version $Revision: 3.321 $
                Compiled for 64 bit mode.
                Build: linux-AMD64

        Contributors:William Norcott, Don Capps, Isom Crawford, Kirby Collins
                     Al Slater, Scott Rhine, Mike Wisner, Ken Goss
                     Steve Landherr, Brad Smith, Mark Kelly, Dr. Alain CYR,
                     Randy Dunlap, Mark Montague, Dan Million, Gavin Brebner,
                     Jean-Marc Zucconi, Jeff Blomberg, Benny Halevy,
                     Erik Habbinga, Kris Strecker, Walter Wong, Joshua Root.

        Run began: Thu Jun 18 10:18:06 2009

        O_DIRECT feature enabled
        Auto Mode
        File size set to 102400 KB
        Record Size 4 KB
        Command line used: iozone -I -a -s 100M -r 4k -i 0 -i 1 -i 2
        Output is in Kbytes/sec
        Time Resolution = 0.000001 seconds.
        Processor cache size set to 1024 Kbytes.
        Processor cache line size set to 32 bytes.
        File stride size set to 17 * record size.
                                                            random  random    bkwd   record   stride
              KB  reclen   write rewrite    read    reread    read   write    read  rewrite     read   fwrite frewrite   fread  freread
          102400       4    7540    5981
Error reading block 0 ef000000
read: Invalid argument

phenom2 /tmp # sysbench  --file-extra-flags=direct  --num-threads=16 --test=fileio --file-total-size=100M --file-test-mode=rndrd prepare             sysbench 0.4.10:  multi-threaded system evaluation benchmark

128 files, 800Kb each, 100Mb total
Creating files for the test...
phenom2 /tmp # sysbench  --file-extra-flags=direct  --num-threads=16 --test=fileio --file-total-size=100M --file-test-mode=rndrd run
sysbench 0.4.10:  multi-threaded system evaluation benchmark

Running the test with following options:
Number of threads: 16

Extra file open flags: 16384
128 files, 800Kb each
100Mb total file size
Block size 16Kb
Number of random requests for random IO: 10000
Read/Write ratio for combined random IO test: 1.50
Periodic FSYNC enabled, calling fsync() each 100 requests.
Calling fsync() at the end of test, Enabled.
Using synchronous I/O mode
Doing random read test
Threads started!
FATAL: Failed to read file! file: 3 pos: 196608 errno = 22 ()
FATAL: Failed to read file! file: 13 pos: 524288 errno = 22 ()
FATAL: Failed to read file! file: 48 pos: 180224 errno = 22 ()
FATAL: Failed to read file! file: 96 pos: 262144 errno = 22 ()
FATAL: Failed to read file! file: 26 pos: 311296 errno = 22 ()
FATAL: Failed to read file! file: 26 pos: 507904 errno = 22 ()
FATAL: Failed to read file! file: 127 pos: 589824 errno = 22 ()
FATAL: Failed to read file! file: 3 pos: 0 errno = 22 ()
FATAL: Failed to read file! file: 119 pos: 262144 errno = 22 ()
FATAL: Failed to read file! file: 9 pos: 688128 errno = 22 ()
FATAL: Failed to read file! file: 62 pos: 557056 errno = 22 ()
FATAL: Failed to read file! file: 87 pos: 655360 errno = 22 ()
FATAL: Failed to read file! file: 113 pos: 425984 errno = 22 ()
FATAL: Failed to read file! file: 20 pos: 344064 errno = 22 ()
FATAL: Failed to read file! file: 17 pos: 294912 errno = 22 ()
FATAL: Failed to read file! file: 16 pos: 0 errno = 22 ()
Done.

-- 
Markus

