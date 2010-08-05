From: Daniel J Blueman <daniel.blueman@gmail.com>
Subject: Re: Poor read performance on high-end server
Date: Thu, 5 Aug 2010 15:54:49 +0100
Message-ID: <AANLkTi=i0kMz2v1iGynphmCqeJMN11sVHNbadTFoNzYD@mail.gmail.com>
References: <4C5AC52D.9030906@sara.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-btrfs@vger.kernel.org
To: Freek Dijkstra <Freek.Dijkstra@sara.nl>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4C5AC52D.9030906@sara.nl>
List-ID: <linux-btrfs.vger.kernel.org>

On 5 August 2010 15:05, Freek Dijkstra <Freek.Dijkstra@sara.nl> wrote:
> Hi,
>
> We're interested in getting the highest possible read performance on =
a
> server. To that end, we have a high-end server with multiple solid st=
ate
> disks (SSDs). Since BtrFS outperformed other Linux filesystem, we cho=
ose
> that. Unfortunately, there seems to be an upper boundary in the
> performance of BtrFS of roughly 1 GiByte/s read speed. Compare the
> following results with either BTRFS on Ubuntu versus ZFS on FreeBSD:
>
> =A0 =A0 =A0 =A0 =A0 =A0 ZFS =A0 =A0 =A0 =A0 =A0 =A0 BtrFS
> 1 SSD =A0 =A0 =A0256 MiByte/s =A0 =A0 256 MiByte/s
> 2 SSDs =A0 =A0 505 MiByte/s =A0 =A0 504 MiByte/s
> 3 SSDs =A0 =A0 736 MiByte/s =A0 =A0 756 MiByte/s
> 4 SSDs =A0 =A0 952 MiByte/s =A0 =A0 916 MiByte/s
> 5 SSDs =A0 =A01226 MiByte/s =A0 =A0 986 MiByte/s
> 6 SSDs =A0 =A01450 MiByte/s =A0 =A0 978 MiByte/s
> 8 SSDs =A0 =A01653 MiByte/s =A0 =A0 932 MiByte/s
> 16 SSDs =A0 2750 MiByte/s =A0 =A0 919 MiByte/s
>
> The results were originally measured on a Dell PowerEdge T610, but we=
re
> repeated using a SuperMicro machine with 4 independent SAS+SATA
> controllers. We made sure that the PCI-e slots where not the bottlene=
ck.
> The above results were for Ubuntu 10.04.1 server, with BtrFS v0.19,
> although earlier tests with Ubuntu 9.10 showed the same results.
>
> Apparently, the limitation is not in the hardware (the same hardware
> with ZFS did scale near linear). We also tested both hardware RAID-0,
> software RAID-0 (md), and using the btrfs built-in software RAID-0, b=
ut
> the differences were small (<10%) (md-based software RAID was margina=
lly
> slower on Linux; RAIDZ was marginally faster on FreeBSD). So we presu=
me
> that the bottleneck is somewhere in the BtrFS (or kernel) software.
>
> Are there suggestions how to tune the read performance? We like to sc=
ale
> this up to 32 solid state disks. The -o ssd option did not improve
> overall performance, although it did gave more stable results (less
> fluctuation in repeated tests).
>
> Note that the write speeds did scale fine. In the scenario with 16 so=
lid
> state disks, the write speed is 1596 MiByte/s (1.7 times as fast as t=
he
> read speed! Suffice to say that for a single disk, write is much slow=
er
> than read...).
>
> Here are the exact settings:
> ~# mkfs.btrfs -d raid0 /dev/sdd /dev/sde /dev/sdf /dev/sdg \
> =A0 =A0 /dev/sdh /dev/sdi /dev/sdj /dev/sdk /dev/sdl /dev/sdm \
> =A0 =A0 /dev/sdn /dev/sdo /dev/sdp /dev/sdq /dev/sdr /dev/sds
> nodesize 4096 leafsize 4096 sectorsize 4096 size 2.33TB
> Btrfs Btrfs v0.19
> ~# mount -t btrfs -o ssd /dev/sdd /mnt/ssd6
> ~# iozone -s 32G -r 1024 -i 0 -i 1 -w -f /mnt/ssd6/iozone.tmp
> =A0 =A0 =A0 =A0 =A0 =A0 =A0KB =A0reclen =A0 write rewrite =A0 =A0read=
 =A0 =A0reread
> =A0 =A0 =A0 =A033554432 =A0 =A01024 1628475 1640349 =A0 943416 =A0 95=
1135

Perhaps create a new filesystem and mount with 'nodatasum' - existing
extents which were previously created will be checked, so need to
start fresh.

Daniel
--=20
Daniel J Blueman
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
