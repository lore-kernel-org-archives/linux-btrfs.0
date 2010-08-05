From: Freek Dijkstra <Freek.Dijkstra@sara.nl>
Subject: Re: Poor read performance on high-end server
Date: Thu, 05 Aug 2010 23:21:06 +0200
Message-ID: <4C5B2B42.3030407@sara.nl>
References: <4C5AC52D.9030906@sara.nl> <20100805145138.GJ29846@think>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
	"axboe@kernel.dk" <axboe@kernel.dk>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20100805145138.GJ29846@think>
List-ID: <linux-btrfs.vger.kernel.org>

Chris, Daniel and Mathieu,

Thanks for your constructive feedback!

> On Thu, Aug 05, 2010 at 04:05:33PM +0200, Freek Dijkstra wrote:
>>              ZFS             BtrFS
>> 1 SSD      256 MiByte/s     256 MiByte/s
>> 2 SSDs     505 MiByte/s     504 MiByte/s
>> 3 SSDs     736 MiByte/s     756 MiByte/s
>> 4 SSDs     952 MiByte/s     916 MiByte/s
>> 5 SSDs    1226 MiByte/s     986 MiByte/s
>> 6 SSDs    1450 MiByte/s     978 MiByte/s
>> 8 SSDs    1653 MiByte/s     932 MiByte/s
>> 16 SSDs   2750 MiByte/s     919 MiByte/s
>>
[...]
>> The above results were for Ubuntu 10.04.1 server, with BtrFS v0.19,
>=20
> Which kernels are those?

=46or BtrFS: Linux 2.6.32-21-server #32-Ubuntu SMP x86_64 GNU/Linux
=46or ZFS: FreeBSD 8.1-RELEASE (GENERIC)

(Note that we can currently not upgrade easily due to binary drivers fo=
r
the SAS+SATA controllers :(. I'd be happy to push the vendor though, if
you think it makes a difference.)


Daniel J Blueman wrote:

> Perhaps create a new filesystem and mount with 'nodatasum'

I get an improvement: 919 MiByte/s just became 1580 MiByte/s. Not as
fast as it can, but most certainly an improvement.

> existing extents which were previously created will be checked, so
> need to start fresh.

Indeed, also the other way around. I created two test files, while
mounted with and without the -o nodatasum option:
write w/o nodatasum; read w/o nodatasum:  919 =B1 43 MiByte/s
write w/o nodatasum; read w/  nodatasum:  922 =B1 72 MiByte/s
write w/  nodatasum; read w/o nodatasum: 1082 =B1 46 MiByte/s
write w/  nodatasum; read w/  nodatasum: 1586 =B1 126 MiByte/s

So even if I remount the disk in the normal way, and read a file create=
d
without checksums, I still get a small improvement :)

(PS: the above tests were repeated 4 times, the last even 8 times. As
you can see from the standard deviation, the results are not always ver=
y
accurate. The cause is unknown; CPU load is low.)


Chris Mason wrote:

> Basically we have two different things to tune.  First the block laye=
r
> and then btrfs.


> And then we need to setup a fio job file that hammers on all the ssds=
 at
> once.  I'd have it use adio/dio and talk directly to the drives.
>=20
> [global]
> size=3D32g
> direct=3D1
> iodepth=3D8
> bs=3D20m
> rw=3Dread
>=20
> [f1]
> filename=3D/dev/sdd
> [f2]
> filename=3D/dev/sde
> [f3]
> filename=3D/dev/sdf
[...]
> [f16]
> filename=3D/dev/sds

Thanks. First one disk:

> f1: (groupid=3D0, jobs=3D1): err=3D 0: pid=3D6273
>   read : io=3D32780MB, bw=3D260964KB/s, iops=3D12, runt=3D128626msec
>     clat (usec): min=3D74940, max=3D80721, avg=3D78449.61, stdev=3D92=
3.24
>     bw (KB/s) : min=3D240469, max=3D269981, per=3D100.10%, avg=3D2612=
14.77, stdev=3D2765.91
>   cpu          : usr=3D0.01%, sys=3D2.69%, ctx=3D1747, majf=3D0, minf=
=3D5153
>   IO depths    : 1=3D100.0%, 2=3D0.0%, 4=3D0.0%, 8=3D0.0%, 16=3D0.0%,=
 32=3D0.0%, >=3D64=3D0.0%
>      submit    : 0=3D0.0%, 4=3D100.0%, 8=3D0.0%, 16=3D0.0%, 32=3D0.0%=
, 64=3D0.0%, >=3D64=3D0.0%
>      complete  : 0=3D0.0%, 4=3D100.0%, 8=3D0.0%, 16=3D0.0%, 32=3D0.0%=
, 64=3D0.0%, >=3D64=3D0.0%
>      issued r/w: total=3D1639/0, short=3D0/0
>=20
>      lat (msec): 100=3D100.00%
>=20
> Run status group 0 (all jobs):
>    READ: io=3D32780MB, aggrb=3D260963KB/s, minb=3D267226KB/s, maxb=3D=
267226KB/s, mint=3D128626msec, maxt=3D128626msec
>=20
> Disk stats (read/write):
>   sdd: ios=3D261901/0, merge=3D0/0, ticks=3D10135270/0, in_queue=3D10=
136460, util=3D99.30%

So 255 MiByte/s.
Out of curiousity, what is the distinction between the reported figures
of 260964 kiB/s, 261214.77 kiB/s, 267226 kiB/s and 260963 kiB/s?


Now 16 disks (abbreviated):

> ~/fio# ./fio ssd.fio
> Starting 16 processes
> f1: (groupid=3D0, jobs=3D1): err=3D 0: pid=3D4756
>   read : io=3D32780MB, bw=3D212987KB/s, iops=3D10, runt=3D157600msec
>     clat (msec): min=3D75, max=3D138, avg=3D96.15, stdev=3D 4.47
>      lat (msec): min=3D75, max=3D138, avg=3D96.15, stdev=3D 4.47
>     bw (KB/s) : min=3D153121, max=3D268968, per=3D6.31%, avg=3D213181=
=2E15, stdev=3D9052.26
>   cpu          : usr=3D0.00%, sys=3D1.71%, ctx=3D2737, majf=3D0, minf=
=3D5153
>   IO depths    : 1=3D100.0%, 2=3D0.0%, 4=3D0.0%, 8=3D0.0%, 16=3D0.0%,=
 32=3D0.0%, >=3D64=3D0.0%
>      submit    : 0=3D0.0%, 4=3D100.0%, 8=3D0.0%, 16=3D0.0%, 32=3D0.0%=
, 64=3D0.0%, >=3D64=3D0.0%
>      complete  : 0=3D0.0%, 4=3D100.0%, 8=3D0.0%, 16=3D0.0%, 32=3D0.0%=
, 64=3D0.0%, >=3D64=3D0.0%
>      issued r/w: total=3D1639/0, short=3D0/0
>=20
>      lat (msec): 100=3D97.99%, 250=3D2.01%

[..similar for f2 to f16..]

> f1:      read : io=3D32780MB, bw=3D212987KB/s, iops=3D10, runt=3D1576=
00msec
>     bw (KB/s) : min=3D153121, max=3D268968, per=3D6.31%, avg=3D213181=
=2E15, stdev=3D9052.26
> f2:      read : io=3D32780MB, bw=3D213873KB/s, iops=3D10, runt=3D1569=
47msec
>     bw (KB/s) : min=3D151143, max=3D251508, per=3D6.33%, avg=3D213987=
=2E34, stdev=3D8958.86
> f3:      read : io=3D32780MB, bw=3D214613KB/s, iops=3D10, runt=3D1564=
06msec
>     bw (KB/s) : min=3D149216, max=3D219037, per=3D6.35%, avg=3D214779=
=2E89, stdev=3D9332.99
> f4:      read : io=3D32780MB, bw=3D214388KB/s, iops=3D10, runt=3D1565=
70msec
>     bw (KB/s) : min=3D148675, max=3D226298, per=3D6.35%, avg=3D214576=
=2E51, stdev=3D8985.03
> f5:      read : io=3D32780MB, bw=3D213848KB/s, iops=3D10, runt=3D1569=
65msec
>     bw (KB/s) : min=3D144479, max=3D241414, per=3D6.33%, avg=3D213935=
=2E81, stdev=3D10023.68
> f6:      read : io=3D32780MB, bw=3D213514KB/s, iops=3D10, runt=3D1572=
11msec
>     bw (KB/s) : min=3D141730, max=3D264990, per=3D6.32%, avg=3D213656=
=2E75, stdev=3D10871.71
> f7:      read : io=3D32780MB, bw=3D213431KB/s, iops=3D10, runt=3D1572=
72msec
>     bw (KB/s) : min=3D148137, max=3D254635, per=3D6.32%, avg=3D213493=
=2E12, stdev=3D9319.08
> f8:      read : io=3D32780MB, bw=3D213099KB/s, iops=3D10, runt=3D1575=
17msec
>     bw (KB/s) : min=3D143467, max=3D267962, per=3D6.31%, avg=3D213267=
=2E60, stdev=3D11224.35
> f9:      read : io=3D32780MB, bw=3D211254KB/s, iops=3D10, runt=3D1588=
93msec
>     bw (KB/s) : min=3D149489, max=3D267962, per=3D6.25%, avg=3D211257=
=2E05, stdev=3D9370.64
> f10:     read : io=3D32780MB, bw=3D212251KB/s, iops=3D10, runt=3D1581=
46msec
>     bw (KB/s) : min=3D150865, max=3D225882, per=3D6.28%, avg=3D212300=
=2E50, stdev=3D8431.06
> f11:     read : io=3D32780MB, bw=3D212988KB/s, iops=3D10, runt=3D1575=
99msec
>     bw (KB/s) : min=3D149489, max=3D221007, per=3D6.31%, avg=3D213123=
=2E72, stdev=3D9569.27
> f12:     read : io=3D32780MB, bw=3D212788KB/s, iops=3D10, runt=3D1577=
47msec
>     bw (KB/s) : min=3D154274, max=3D218647, per=3D6.30%, avg=3D212957=
=2E41, stdev=3D8233.52
> f13:     read : io=3D32780MB, bw=3D212315KB/s, iops=3D10, runt=3D1580=
99msec
>     bw (KB/s) : min=3D153696, max=3D256000, per=3D6.29%, avg=3D212482=
=2E68, stdev=3D9203.34
> f14:     read : io=3D32780MB, bw=3D212033KB/s, iops=3D10, runt=3D1583=
09msec
>     bw (KB/s) : min=3D150588, max=3D267962, per=3D6.28%, avg=3D212198=
=2E76, stdev=3D9572.31
> f15:     read : io=3D32780MB, bw=3D211720KB/s, iops=3D10, runt=3D1585=
43msec
>     bw (KB/s) : min=3D146024, max=3D268968, per=3D6.27%, avg=3D211846=
=2E40, stdev=3D10341.58
> f16:     read : io=3D32780MB, bw=3D211637KB/s, iops=3D10, runt=3D1586=
05msec
>     bw (KB/s) : min=3D148945, max=3D261605, per=3D6.26%, avg=3D211618=
=2E40, stdev=3D9240.64
>=20
> Run status group 0 (all jobs):
>    READ: io=3D524480MB, aggrb=3D3301MB/s, minb=3D216323KB/s, maxb=3D2=
19763KB/s, mint=3D156406msec, maxt=3D158893msec
>=20
> Disk stats (read/write):
>   sdd: ios=3D261902/0, merge=3D0/0, ticks=3D12531810/0, in_queue=3D12=
532910, util=3D99.46%
>   sde: ios=3D262221/0, merge=3D0/0, ticks=3D12494200/0, in_queue=3D12=
495300, util=3D99.50%
>   sdf: ios=3D261867/0, merge=3D0/0, ticks=3D12427000/0, in_queue=3D12=
430530, util=3D99.47%
>   sdg: ios=3D261983/0, merge=3D0/0, ticks=3D12462320/0, in_queue=3D12=
466060, util=3D99.62%
>   sdh: ios=3D262184/0, merge=3D0/0, ticks=3D12487350/0, in_queue=3D12=
489960, util=3D99.49%
>   sdi: ios=3D262193/0, merge=3D0/0, ticks=3D12524400/0, in_queue=3D12=
526580, util=3D99.47%
>   sdj: ios=3D262044/0, merge=3D0/0, ticks=3D12511850/0, in_queue=3D12=
513840, util=3D99.50%
>   sdk: ios=3D262055/0, merge=3D0/0, ticks=3D12526560/0, in_queue=3D12=
527890, util=3D99.50%
>   sdl: ios=3D261789/0, merge=3D0/0, ticks=3D12609230/0, in_queue=3D12=
610400, util=3D99.54%
>   sdm: ios=3D261787/0, merge=3D0/0, ticks=3D12579000/0, in_queue=3D12=
581050, util=3D99.44%
>   sdn: ios=3D261941/0, merge=3D0/0, ticks=3D12524530/0, in_queue=3D12=
525790, util=3D99.48%
>   sdo: ios=3D262100/0, merge=3D0/0, ticks=3D12554650/0, in_queue=3D12=
555820, util=3D99.58%
>   sdp: ios=3D261877/0, merge=3D0/0, ticks=3D12572220/0, in_queue=3D12=
574610, util=3D99.54%
>   sdq: ios=3D261956/0, merge=3D0/0, ticks=3D12601480/0, in_queue=3D12=
603770, util=3D99.62%
>   sdr: ios=3D261991/0, merge=3D0/0, ticks=3D12599680/0, in_queue=3D12=
602190, util=3D99.49%
>   sds: ios=3D261852/0, merge=3D0/0, ticks=3D12624070/0, in_queue=3D12=
626580, util=3D99.58%

So, the maximum for these 16 disks is 3301 MiByte/s.

I also tried hardware RAID (2 sets of 8 disks), and got a similar resul=
t:

> Run status group 0 (all jobs):
>    READ: io=3D65560MB, aggrb=3D3024MB/s, minb=3D1548MB/s, maxb=3D1550=
MB/s, mint=3D21650msec, maxt=3D21681msec



> fio should be able to push these devices up to the line speed.  If it
> doesn't I would suggest changing elevators (deadline, cfq, noop) and
> bumping the max request size to the max supported by the device.

3301 MiByte/s seems like a reasonable number, given the theoretic
maximum of 16 times the single disk performance of 16*256 MiByte/s =3D
4096 MiByte/s.

Based on this, I have not looked at tuning. Would you recommend that I =
do?

Our minimal goal is 2500 MiByte/s; that seems achievable as ZFS was abl=
e
to reach 2750 MiByte/s without tuning.

> When we have a config that does so, we can tune the btrfs side of thi=
ngs
> as well.

Some files are created in the root folder of the mount point, but I get
errors instead of results:

> ~/fio# ./fio btrfs16.fio=20
> btrfs: (g=3D0): rw=3Dread, bs=3D20M-20M/20M-20M, ioengine=3Dsync, iod=
epth=3D8
> Starting 16 processes
> btrfs: Laying out IO file(s) (1 file(s) / 32768MB)
> btrfs: Laying out IO file(s) (1 file(s) / 32768MB)
[...]

> btrfs: Laying out IO file(s) (1 file(s) / 32768MB)
> fio: first direct IO errored. File system may not support direct IO, =
or iomem_align=3D is bad.
> fio: first direct IO errored. File system may not support direct IO, =
or iomem_align=3D is bad.
> fio: first direct IO errored. File system may not support direct IO, =
or iomem_align=3D is bad.
> fio: pid=3D5958, err=3D22/file:engines/sync.c:62, func=3Dxfer, error=3D=
Invalid argument
> fio: pid=3D5961, err=3D22/file:engines/sync.c:62, func=3Dxfer, error=3D=
Invalid argument
> fio: pid=3D5962, err=3D22/file:engines/sync.c:62, func=3Dxfer, error=3D=
Invalid argument
> fio: first direct IO errored. File system may not support direct IO, =
or iomem_align=3D is bad.
[...]
>=20
> btrfs: (groupid=3D0, jobs=3D1): err=3D22 (file:engines/sync.c:62, fun=
c=3Dxfer, error=3DInvalid argument): pid=3D5956
>   cpu          : usr=3D0.00%, sys=3D0.00%, ctx=3D1, majf=3D0, minf=3D=
52
>   IO depths    : 1=3D100.0%, 2=3D0.0%, 4=3D0.0%, 8=3D0.0%, 16=3D0.0%,=
 32=3D0.0%, >=3D64=3D0.0%
>      submit    : 0=3D0.0%, 4=3D100.0%, 8=3D0.0%, 16=3D0.0%, 32=3D0.0%=
, 64=3D0.0%, >=3D64=3D0.0%
>      complete  : 0=3D50.0%, 4=3D50.0%, 8=3D0.0%, 16=3D0.0%, 32=3D0.0%=
, 64=3D0.0%, >=3D64=3D0.0%
>      issued r/w: total=3D1/0, short=3D0/0
[no results]

What could be going on here?
(I get the same result from the github version of fio, fio 1.42, as wel=
l
as the one that came with Ubuntu, fio 1.33.1).

> My first guess is just that your IOs are not large enough w/btrfs.  T=
he
> iozone command below is doing buffered reads, so our performance is
> going to be limited by the kernel readahead buffer size.
>=20
> If you use a much larger IO size (the fio job above reads in 20M chun=
ks)
> and aio/dio instead, you can have more control over how the IO goes d=
own
> to the device.

I don't quite understand (I must warn you that I'm a novice here; I'm a
networking expert by origin, not a storage expert).

I reran the first fio test with other "bs" settings:

> 1 disk, 1M buffer:
>    READ: io=3D32768MB, aggrb=3D247817KB/s, minb=3D253764KB/s, maxb=3D=
253764KB/s, mint=3D135400msec, maxt=3D135400msec
>=20
> 1 disk, 20M buffer:
>    READ: io=3D32780MB, aggrb=3D260963KB/s, minb=3D267226KB/s, maxb=3D=
267226KB/s, mint=3D128626msec, maxt=3D128626msec
>=20
> 1 disk, 100M buffer:
>    READ: io=3D32800MB, aggrb=3D263776KB/s, minb=3D270107KB/s, maxb=3D=
270107KB/s, mint=3D127332msec, maxt=3D127332msec
>=20
> 16 disk, 1M buffer:
>    READ: io=3D524288MB, aggrb=3D3265MB/s, minb=3D213983KB/s, maxb=3D2=
15761KB/s, mint=3D159249msec, maxt=3D160572msec
>=20
> 16 disk, 20M buffer:
>    READ: io=3D524480MB, aggrb=3D3301MB/s, minb=3D216323KB/s, maxb=3D2=
19763KB/s, mint=3D156406msec, maxt=3D158893msec
>=20
> 16 disk, 100M buffer:
>    READ: io=3D524800MB, aggrb=3D3272MB/s, minb=3D214443KB/s, maxb=3D2=
16446KB/s, mint=3D158900msec, maxt=3D160384msec

However, the buffer size does not seem to make that much of a
difference. Or am I adjusting the wrong buffers here?



Mathieu Chouquet-Stringer wrote:

> Don't you need to stripe metadata too (with -m raid0)?  Or you may
> be limited by your metadata drive?

I presume that if this were the case, we would see good performance for
hardware RAID and mdadm based software RAID, and poor performance for
BtrFS. However, we saw poor performance for all three options.

Of course, seeing is believing.

Without metadata striping:

# mkfs.btrfs -d raid0 -m raid0 /dev/sdd ... /dev/sds
# mount -t btrfs -o ssd /dev/sdd /mnt/ssd6
# iozone -s 32G -r 1024 -i 0 -i 1 -w -f /mnt/ssd6/iozone.tmp
              KB  reclen   write rewrite    read    reread
        33554432    1024 1628475 1640349   943416   951135

With metadata striping:

# mkfs.btrfs -d raid0 /dev/sdd ... /dev/sds
# mount -t btrfs -o ssd /dev/sdd /mnt/ssd6
# iozone -s 32G -r 1024 -i 0 -i 1 -w -f /mnt/ssd6/iozone.tmp
              KB  reclen   write rewrite    read    reread
        33554432    1024 1631833 1564137   950405   954434



Unfortunately, no noticeable difference.


With kind regards,
=46reek Dijkstra
SARA High Performance Networking- and Computing

--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
