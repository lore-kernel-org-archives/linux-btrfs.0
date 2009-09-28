From: Tobias Oetiker <tobi@oetiker.ch>
Subject: Benchmarking btrfs on HW Raid ... BAD
Date: Mon, 28 Sep 2009 10:06:07 +0200 (CEST)
Message-ID: <alpine.DEB.2.00.0909280955400.11292@sebohet.brgvxre.pu>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

List,

I have done some benchmarking of different file systems on a HW raid
(areca RAID6 with 7 disks). My test focuses on the behaviour of the
system under competing read and write workloads.

My benchmark runs 3 writer and 3 reader  processes in parallel each
reader gets its own artificial 5 GB home-directory-filetree while
the writers create a similar tree.

Running this on a single disk, I get the quite acceptable results.
When running on-top of a Areca HW Raid6 (lvm partitioned)
then both read and write performance go down by at least 2
magnitudes.

I am not on this list, so please cc me on any replies.

My Test Software is here:

    http://oss.oetiker.ch/optools/wiki/FsOpBench

And these are the results:

2.6.31 - btrfs - cfq - single sata disk
######################################################################

1 readers (30s)
----------------------------------------------------------------------
A read dir        cnt  56400    min    0.001 ms    max   96.106 ms    mean    0.053 ms    stdev   0.973
B lstat file      cnt  52652    min    0.006 ms    max   34.721 ms    mean    0.057 ms    stdev   0.680
C open file       cnt  41411    min    0.014 ms    max    0.277 ms    mean    0.017 ms    stdev   0.003
D rd 1st byte     cnt  41412    min    0.019 ms    max   51.501 ms    mean    0.327 ms    stdev   1.774
E read rate     164.741 MB/s (data)  44.940 MB/s (readdir + open + 1st byte + data)

3 readers (30s)
----------------------------------------------------------------------
A read dir        cnt  21322    min    0.001 ms    max   72.704 ms    mean    0.073 ms    stdev   1.544
B lstat file      cnt  19881    min    0.006 ms    max  103.878 ms    mean    0.145 ms    stdev   2.055
C open file       cnt  15558    min    0.014 ms    max    0.109 ms    mean    0.018 ms    stdev   0.003
D rd 1st byte     cnt  15558    min    0.020 ms    max 2528.137 ms    mean    1.312 ms    stdev  21.358
E read rate     106.851 MB/s (data)  15.778 MB/s (readdir + open + 1st byte + data)

3 readers, 3 writers (30s)
----------------------------------------------------------------------
F write open      cnt  15428    min    0.057 ms    max  898.478 ms    mean    0.390 ms    stdev  13.349
G wr 1st byte     cnt  15428    min    0.006 ms    max   15.889 ms    mean    0.009 ms    stdev   0.147
H write close     cnt  15428    min    0.016 ms    max  533.088 ms    mean    0.222 ms    stdev   9.099
I mkdir           cnt   1350    min    0.031 ms    max   77.956 ms    mean    0.127 ms    stdev   2.218
J write rate     30.738 MB/s (data)  23.177 MB/s (open + 1st byte + data)

A read dir        cnt   3382    min    0.001 ms    max 1586.615 ms    mean    0.831 ms    stdev  29.901
B lstat file      cnt   3158    min    0.007 ms    max  427.770 ms    mean    0.390 ms    stdev   9.328
C open file       cnt   2489    min    0.014 ms    max    2.644 ms    mean    0.020 ms    stdev   0.071
D rd 1st byte     cnt   2489    min    0.021 ms    max 2033.881 ms    mean    8.327 ms    stdev  68.468
E read rate      11.927 MB/s (data)   2.169 MB/s (readdir + open + 1st byte + data)

2.6.31 - btrfs - cfq - areca raid6 (7 disks) lvm partitioned
######################################################################

1 readers (30s)
----------------------------------------------------------------------
A read dir        cnt  78845    min    0.001 ms    max   29.713 ms    mean    0.027 ms    stdev   0.421
B lstat file      cnt  73600    min    0.006 ms    max   21.639 ms    mean    0.038 ms    stdev   0.273
C open file       cnt  57862    min    0.013 ms    max    0.100 ms    mean    0.017 ms    stdev   0.003
D rd 1st byte     cnt  57861    min    0.014 ms    max   70.214 ms    mean    0.209 ms    stdev   0.919
E read rate     185.464 MB/s (data)  63.842 MB/s (readdir + open + 1st byte + data)

3 readers (30s)
----------------------------------------------------------------------
A read dir        cnt  41222    min    0.001 ms    max  169.195 ms    mean    0.056 ms    stdev   1.113
B lstat file      cnt  38447    min    0.006 ms    max   79.977 ms    mean    0.064 ms    stdev   0.746
C open file       cnt  30122    min    0.013 ms    max    0.042 ms    mean    0.018 ms    stdev   0.003
D rd 1st byte     cnt  30122    min    0.014 ms    max  597.264 ms    mean    0.535 ms    stdev   6.646
E read rate     124.144 MB/s (data)  31.197 MB/s (readdir + open + 1st byte + data)

3 readers, 3 writers (30s)
----------------------------------------------------------------------
F write open      cnt    107    min    0.063 ms    max   70.593 ms    mean    0.760 ms    stdev   6.784
G wr 1st byte     cnt    107    min    0.006 ms    max    0.014 ms    mean    0.007 ms    stdev   0.002
H write close     cnt    107    min    0.017 ms    max 1784.192 ms    mean   20.830 ms    stdev 176.474
I mkdir           cnt      9    min    0.049 ms    max    9.184 ms    mean    1.079 ms    stdev   2.865
J write rate      0.200 MB/s (data)   0.199 MB/s (open + 1st byte + data)

A read dir        cnt   1215    min    0.001 ms    max 2661.328 ms    mean    4.008 ms    stdev  81.513
B lstat file      cnt   1144    min    0.007 ms    max  377.476 ms    mean    1.827 ms    stdev  18.844
C open file       cnt    928    min    0.014 ms    max    1.596 ms    mean    0.021 ms    stdev   0.056
D rd 1st byte     cnt    928    min    0.015 ms    max 1936.262 ms    mean   25.187 ms    stdev 123.755
E read rate       9.199 MB/s (data)   0.792 MB/s (readdir + open + 1st byte + data)



-- 
Tobi Oetiker, OETIKER+PARTNER AG, Aarweg 15 CH-4600 Olten, Switzerland
http://it.oetiker.ch tobi@oetiker.ch ++41 62 775 9902 / sb: -9900
