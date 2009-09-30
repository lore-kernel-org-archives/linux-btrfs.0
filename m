From: Tobias Oetiker <tobi@oetiker.ch>
Subject: Re: Benchmarking btrfs on HW Raid ... BAD
Date: Wed, 30 Sep 2009 20:44:22 +0200 (CEST)
Message-ID: <alpine.DEB.2.00.0909302038040.7806@sebohet.brgvxre.pu>
References: <alpine.DEB.2.00.0909280955400.11292@sebohet.brgvxre.pu>  <82tyynxz2g.fsf@mid.bfk.de> <6278d2220909280219h5b38577eqc1bee1a26cbc93e1@mail.gmail.com> <alpine.DEB.2.00.0909281124410.11292@sebohet.brgvxre.pu> <4AC36CAB.5000208@redhat.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Daniel J Blueman <daniel.blueman@gmail.com>,
	Florian Weimer <fweimer@bfk.de>, linux-btrfs@vger.kernel.org,
	Roman Plessl <rplessl@oetiker.ch>
To: Ric Wheeler <rwheeler@redhat.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4AC36CAB.5000208@redhat.com>
List-ID: <linux-btrfs.vger.kernel.org>

Hi Ric,

Today Ric Wheeler wrote:

> I would be more suspicious of the barrier/flushes being issued. If your write
> cache is non-volatile, we really do not want to send them down to this type of
> device. Flushing this type of cache could certainly be very, very expensive
> and slow.
>
> Try "mount -o nobarrier" and see if your performance (write cache still
> enabled on the controller) is back to expected levels,

wow, indeed ...

without special mount options I get the following from my RAID6 with non volatile cache:
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


mounting with -o nobarrier I get ...
######################################################################

1 readers (30s)
----------------------------------------------------------------------
A read dir        cnt  78876    min    0.001 ms    max   19.803 ms    mean    0.013 ms    stdev   0.228
B lstat file      cnt  73624    min    0.006 ms    max   18.032 ms    mean    0.034 ms    stdev   0.210
C open file       cnt  57868    min    0.014 ms    max    0.041 ms    mean    0.017 ms    stdev   0.003
D rd 1st byte     cnt  57869    min    0.019 ms    max  417.725 ms    mean    0.225 ms    stdev   2.459
E read rate     177.779 MB/s (data)  63.375 MB/s (readdir + open + 1st byte + data)

3 readers (30s)
----------------------------------------------------------------------
A read dir        cnt  38209    min    0.001 ms    max   26.745 ms    mean    0.025 ms    stdev   0.472
B lstat file      cnt  35624    min    0.006 ms    max   26.019 ms    mean    0.048 ms    stdev   0.410
C open file       cnt  27874    min    0.014 ms    max    1.257 ms    mean    0.017 ms    stdev   0.008
D rd 1st byte     cnt  27874    min    0.020 ms    max 3197.520 ms    mean    0.626 ms    stdev  20.279
E read rate      98.242 MB/s (data)  27.763 MB/s (readdir + open + 1st byte + data)

3 readers, 3 writers (30s)
----------------------------------------------------------------------
F write open      cnt   5957    min    0.061 ms    max  591.787 ms    mean    0.457 ms    stdev   9.956
G wr 1st byte     cnt   5956    min    0.006 ms    max    0.136 ms    mean    0.007 ms    stdev   0.002
H write close     cnt   5957    min    0.017 ms    max 1340.145 ms    mean    0.818 ms    stdev  22.442
I mkdir           cnt    574    min    0.034 ms    max   11.094 ms    mean    0.083 ms    stdev   0.543
J write rate      9.766 MB/s (data)   8.705 MB/s (open + 1st byte + data)

A read dir        cnt  15183    min    0.001 ms    max  439.260 ms    mean    0.130 ms    stdev   4.150
B lstat file      cnt  14199    min    0.006 ms    max  200.212 ms    mean    0.152 ms    stdev   3.420
C open file       cnt  11250    min    0.014 ms    max    6.641 ms    mean    0.019 ms    stdev   0.084
D rd 1st byte     cnt  11250    min    0.021 ms    max 1649.488 ms    mean    1.715 ms    stdev  19.472
E read rate      52.022 MB/s (data)  10.858 MB/s (readdir + open + 1st byte + data)

amazing effect ...

unfortunately the system also crashes quite often when running this
test, so I guess we have to wait a bit more for this to run
primetime ...

a further observation is that both the RAID as well the SATA case
show max latency values way over 1 second ... which is a bit much
... not that other filesystems were much better, but then again it
would be cool if btrfs could best the others ...

cheers
tobi

-- 
Tobi Oetiker, OETIKER+PARTNER AG, Aarweg 15 CH-4600 Olten, Switzerland
http://it.oetiker.ch tobi@oetiker.ch ++41 62 775 9902 / sb: -9900
