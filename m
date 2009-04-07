From: "Morten P.D. Stevens" <mstevens@win-professional.com>
Subject: Re: btrfs vs ext4 benchmark
Date: Tue, 7 Apr 2009 13:47:45 +0200
Message-ID: <897274600904070447s276a53c7teb5afbfb6ff95783@mail.gmail.com>
References: <001001c9b52a$8ef00bc0$acd02340$@com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <001001c9b52a$8ef00bc0$acd02340$@com>
List-ID: <linux-btrfs.vger.kernel.org>

Update:

And here the compilebench with options -i 90 and -r 150 (the same as or=
acle)

btrfs:

=2E/compilebench -D /btrfs/work2 -i 90 -r 150

run complete:
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D
intial create total runs 90 avg 45.18 MB/s (user 0.84s sys 2.89s)
create total runs 20 avg 13.30 MB/s (user 0.88s sys 2.93s)
patch total runs 24 avg 5.94 MB/s (user 0.34s sys 2.56s)
compile total runs 23 avg 37.04 MB/s (user 0.19s sys 1.60s)
clean total runs 14 avg 71.36 MB/s (user 0.03s sys 0.83s)
read tree total runs 17 avg 7.02 MB/s (user 0.75s sys 3.26s)
read compiled tree total runs 8 avg 16.27 MB/s (user 0.86s sys 4.83s)
delete tree total runs 14 avg 21.51 seconds (user 0.45s sys 4.07s)
delete compiled tree total runs 6 avg 29.23 seconds (user 0.57s sys 4.6=
6s)
stat tree total runs 14 avg 15.99 seconds (user 0.41s sys 1.31s)
stat compiled tree total runs 10 avg 19.68 seconds (user 0.41s sys 1.51=
s)


ext4:

=2E/compilebench -D /mnt/work2 -i 90 -r 150


run complete:
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D
intial create total runs 90 avg 92.42 MB/s (user 0.76s sys 1.38s)
create total runs 20 avg 52.06 MB/s (user 0.73s sys 1.26s)
patch total runs 24 avg 17.28 MB/s (user 0.37s sys 0.96s)
compile total runs 23 avg 85.64 MB/s (user 0.17s sys 1.05s)
clean total runs 14 avg 887.53 MB/s (user 0.02s sys 0.11s)
read tree total runs 17 avg 13.60 MB/s (user 0.79s sys 1.34s)
read compiled tree total runs 8 avg 24.65 MB/s (user 0.95s sys 2.07s)
delete tree total runs 14 avg 2.26 seconds (user 0.39s sys 0.78s)
delete compiled tree total runs 6 avg 2.82 seconds (user 0.43s sys 0.91=
s)
stat tree total runs 14 avg 1.71 seconds (user 0.38s sys 0.33s)
stat compiled tree total runs 10 avg 1.99 seconds (user 0.42s sys 0.33s=
)


I=B4m a little disappointed about the btrfs results.
I was hopefully that btrfs is faster than ext4....

-

Morten


2009/4/4 Morten P.D. Stevens <mstevens@win-professional.com>:
> Hi,
>
> here are some tests on an IBM server with btrfs vs. ext4.
>
> Kernel: 2.6.29.1
> Benchmark software: compilerbench with options -i 10 -r 30
> CPU: Intel Xeon Quadcore E5310
> Chipset: Intel 5000
> Memory: 4 GB FB-DIMM DDR2-667
> HDDs: 2x WD6400AAKS @ Raid0
> Storage Controller: IBM Serveraid 8k
>
> btrfs Result:
>
> intial create total runs 10 avg 50.89 MB/s (user 0.85s sys 2.59s)
> create total runs 5 avg 23.62 MB/s (user 0.82s sys 2.55s)
> patch total runs 4 avg 11.35 MB/s (user 0.38s sys 2.22s)
> compile total runs 7 avg 66.33 MB/s (user 0.19s sys 1.32s)
> clean total runs 4 avg 195.76 MB/s (user 0.03s sys 0.50s)
> read tree total runs 2 avg 11.99 MB/s (user 0.66s sys 2.59s)
> read compiled tree total runs 1 avg 30.14 MB/s (user 0.88s sys 3.64s)
> delete tree total runs 2 avg 10.79 seconds (user 0.43s sys 3.39s)
> no runs for delete compiled tree
> stat tree total runs 4 avg 9.62 seconds (user 0.41s sys 1.03s)
> stat compiled tree total runs 1 avg 10.51 seconds (user 0.49s sys 1.1=
9s)
>
> ext4 Result:
>
> intial create total runs 10 avg 96.09 MB/s (user 0.77s sys 1.34s)
> create total runs 5 avg 50.84 MB/s (user 0.82s sys 1.20s)
> patch total runs 4 avg 20.17 MB/s (user 0.28s sys 1.04s)
> compile total runs 7 avg 94.39 MB/s (user 0.17s sys 1.07s)
> clean total runs 4 avg 959.66 MB/s (user 0.03s sys 0.11s)
> read tree total runs 2 avg 14.67 MB/s (user 0.78s sys 1.26s)
> read compiled tree total runs 1 avg 31.96 MB/s (user 0.87s sys 2.31s)
> delete tree total runs 2 avg 2.14 seconds (user 0.34s sys 0.81s)
> no runs for delete compiled tree
> stat tree total runs 4 avg 1.82 seconds (user 0.40s sys 0.35s)
> stat compiled tree total runs 1 avg 1.83 seconds (user 0.35s sys 0.33=
s)
>
> Best regards,
>
> Morten
>
>
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
