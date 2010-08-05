From: Daniel J Blueman <daniel.blueman@gmail.com>
Subject: Re: Poor read performance on high-end server
Date: Thu, 5 Aug 2010 23:13:03 +0100
Message-ID: <AANLkTikNJ3S0FZXzWMrfny=d7jzGjrNLU28VtmaKVBjx@mail.gmail.com>
References: <4C5AC52D.9030906@sara.nl>
	<20100805145138.GJ29846@think>
	<4C5B2B42.3030407@sara.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-2
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
	"axboe@kernel.dk" <axboe@kernel.dk>
To: Freek Dijkstra <Freek.Dijkstra@sara.nl>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4C5B2B42.3030407@sara.nl>
List-ID: <linux-btrfs.vger.kernel.org>

On 5 August 2010 22:21, Freek Dijkstra <Freek.Dijkstra@sara.nl> wrote:
> Chris, Daniel and Mathieu,
>
> Thanks for your constructive feedback!
>
>> On Thu, Aug 05, 2010 at 04:05:33PM +0200, Freek Dijkstra wrote:
>>> =A0 =A0 =A0 =A0 =A0 =A0 =A0ZFS =A0 =A0 =A0 =A0 =A0 =A0 BtrFS
>>> 1 SSD =A0 =A0 =A0256 MiByte/s =A0 =A0 256 MiByte/s
>>> 2 SSDs =A0 =A0 505 MiByte/s =A0 =A0 504 MiByte/s
>>> 3 SSDs =A0 =A0 736 MiByte/s =A0 =A0 756 MiByte/s
>>> 4 SSDs =A0 =A0 952 MiByte/s =A0 =A0 916 MiByte/s
>>> 5 SSDs =A0 =A01226 MiByte/s =A0 =A0 986 MiByte/s
>>> 6 SSDs =A0 =A01450 MiByte/s =A0 =A0 978 MiByte/s
>>> 8 SSDs =A0 =A01653 MiByte/s =A0 =A0 932 MiByte/s
>>> 16 SSDs =A0 2750 MiByte/s =A0 =A0 919 MiByte/s
>>>
> [...]
>>> The above results were for Ubuntu 10.04.1 server, with BtrFS v0.19,
>>
>> Which kernels are those?
>
> For BtrFS: Linux 2.6.32-21-server #32-Ubuntu SMP x86_64 GNU/Linux
> For ZFS: FreeBSD 8.1-RELEASE (GENERIC)
>
> (Note that we can currently not upgrade easily due to binary drivers =
for
> the SAS+SATA controllers :(. I'd be happy to push the vendor though, =
if
> you think it makes a difference.)
>
>
> Daniel J Blueman wrote:
>
>> Perhaps create a new filesystem and mount with 'nodatasum'
>
> I get an improvement: 919 MiByte/s just became 1580 MiByte/s. Not as
> fast as it can, but most certainly an improvement.
>
>> existing extents which were previously created will be checked, so
>> need to start fresh.
>
> Indeed, also the other way around. I created two test files, while
> mounted with and without the -o nodatasum option:
> write w/o nodatasum; read w/o nodatasum: =A0919 =B1 43 MiByte/s
> write w/o nodatasum; read w/ =A0nodatasum: =A0922 =B1 72 MiByte/s
> write w/ =A0nodatasum; read w/o nodatasum: 1082 =B1 46 MiByte/s
> write w/ =A0nodatasum; read w/ =A0nodatasum: 1586 =B1 126 MiByte/s
>
> So even if I remount the disk in the normal way, and read a file crea=
ted
> without checksums, I still get a small improvement :)
>
> (PS: the above tests were repeated 4 times, the last even 8 times. As
> you can see from the standard deviation, the results are not always v=
ery
> accurate. The cause is unknown; CPU load is low.)
>
>
> Chris Mason wrote:
>
>> Basically we have two different things to tune. =A0First the block l=
ayer
>> and then btrfs.
>
>
>> And then we need to setup a fio job file that hammers on all the ssd=
s at
>> once. =A0I'd have it use adio/dio and talk directly to the drives.
>>
>> [global]
>> size=3D32g
>> direct=3D1
>> iodepth=3D8
>> bs=3D20m
>> rw=3Dread
>>
>> [f1]
>> filename=3D/dev/sdd
>> [f2]
>> filename=3D/dev/sde
>> [f3]
>> filename=3D/dev/sdf
> [...]
>> [f16]
>> filename=3D/dev/sds
>
> Thanks. First one disk:
>
>> f1: (groupid=3D0, jobs=3D1): err=3D 0: pid=3D6273
>> =A0 read : io=3D32780MB, bw=3D260964KB/s, iops=3D12, runt=3D128626ms=
ec
>> =A0 =A0 clat (usec): min=3D74940, max=3D80721, avg=3D78449.61, stdev=
=3D923.24
>> =A0 =A0 bw (KB/s) : min=3D240469, max=3D269981, per=3D100.10%, avg=3D=
261214.77, stdev=3D2765.91
>> =A0 cpu =A0 =A0 =A0 =A0 =A0: usr=3D0.01%, sys=3D2.69%, ctx=3D1747, m=
ajf=3D0, minf=3D5153
>> =A0 IO depths =A0 =A0: 1=3D100.0%, 2=3D0.0%, 4=3D0.0%, 8=3D0.0%, 16=3D=
0.0%, 32=3D0.0%, >=3D64=3D0.0%
>> =A0 =A0 =A0submit =A0 =A0: 0=3D0.0%, 4=3D100.0%, 8=3D0.0%, 16=3D0.0%=
, 32=3D0.0%, 64=3D0.0%, >=3D64=3D0.0%
>> =A0 =A0 =A0complete =A0: 0=3D0.0%, 4=3D100.0%, 8=3D0.0%, 16=3D0.0%, =
32=3D0.0%, 64=3D0.0%, >=3D64=3D0.0%
>> =A0 =A0 =A0issued r/w: total=3D1639/0, short=3D0/0
>>
>> =A0 =A0 =A0lat (msec): 100=3D100.00%
>>
>> Run status group 0 (all jobs):
>> =A0 =A0READ: io=3D32780MB, aggrb=3D260963KB/s, minb=3D267226KB/s, ma=
xb=3D267226KB/s, mint=3D128626msec, maxt=3D128626msec
>>
>> Disk stats (read/write):
>> =A0 sdd: ios=3D261901/0, merge=3D0/0, ticks=3D10135270/0, in_queue=3D=
10136460, util=3D99.30%
>
> So 255 MiByte/s.
> Out of curiousity, what is the distinction between the reported figur=
es
> of 260964 kiB/s, 261214.77 kiB/s, 267226 kiB/s and 260963 kiB/s?
>
>
> Now 16 disks (abbreviated):
>
>> ~/fio# ./fio ssd.fio
>> Starting 16 processes
>> f1: (groupid=3D0, jobs=3D1): err=3D 0: pid=3D4756
>> =A0 read : io=3D32780MB, bw=3D212987KB/s, iops=3D10, runt=3D157600ms=
ec
>> =A0 =A0 clat (msec): min=3D75, max=3D138, avg=3D96.15, stdev=3D 4.47
>> =A0 =A0 =A0lat (msec): min=3D75, max=3D138, avg=3D96.15, stdev=3D 4.=
47
>> =A0 =A0 bw (KB/s) : min=3D153121, max=3D268968, per=3D6.31%, avg=3D2=
13181.15, stdev=3D9052.26
>> =A0 cpu =A0 =A0 =A0 =A0 =A0: usr=3D0.00%, sys=3D1.71%, ctx=3D2737, m=
ajf=3D0, minf=3D5153
>> =A0 IO depths =A0 =A0: 1=3D100.0%, 2=3D0.0%, 4=3D0.0%, 8=3D0.0%, 16=3D=
0.0%, 32=3D0.0%, >=3D64=3D0.0%
>> =A0 =A0 =A0submit =A0 =A0: 0=3D0.0%, 4=3D100.0%, 8=3D0.0%, 16=3D0.0%=
, 32=3D0.0%, 64=3D0.0%, >=3D64=3D0.0%
>> =A0 =A0 =A0complete =A0: 0=3D0.0%, 4=3D100.0%, 8=3D0.0%, 16=3D0.0%, =
32=3D0.0%, 64=3D0.0%, >=3D64=3D0.0%
>> =A0 =A0 =A0issued r/w: total=3D1639/0, short=3D0/0
>>
>> =A0 =A0 =A0lat (msec): 100=3D97.99%, 250=3D2.01%
>
> [..similar for f2 to f16..]
>
>> f1: =A0 =A0 =A0read : io=3D32780MB, bw=3D212987KB/s, iops=3D10, runt=
=3D157600msec
>> =A0 =A0 bw (KB/s) : min=3D153121, max=3D268968, per=3D6.31%, avg=3D2=
13181.15, stdev=3D9052.26
>> f2: =A0 =A0 =A0read : io=3D32780MB, bw=3D213873KB/s, iops=3D10, runt=
=3D156947msec
>> =A0 =A0 bw (KB/s) : min=3D151143, max=3D251508, per=3D6.33%, avg=3D2=
13987.34, stdev=3D8958.86
>> f3: =A0 =A0 =A0read : io=3D32780MB, bw=3D214613KB/s, iops=3D10, runt=
=3D156406msec
>> =A0 =A0 bw (KB/s) : min=3D149216, max=3D219037, per=3D6.35%, avg=3D2=
14779.89, stdev=3D9332.99
>> f4: =A0 =A0 =A0read : io=3D32780MB, bw=3D214388KB/s, iops=3D10, runt=
=3D156570msec
>> =A0 =A0 bw (KB/s) : min=3D148675, max=3D226298, per=3D6.35%, avg=3D2=
14576.51, stdev=3D8985.03
>> f5: =A0 =A0 =A0read : io=3D32780MB, bw=3D213848KB/s, iops=3D10, runt=
=3D156965msec
>> =A0 =A0 bw (KB/s) : min=3D144479, max=3D241414, per=3D6.33%, avg=3D2=
13935.81, stdev=3D10023.68
>> f6: =A0 =A0 =A0read : io=3D32780MB, bw=3D213514KB/s, iops=3D10, runt=
=3D157211msec
>> =A0 =A0 bw (KB/s) : min=3D141730, max=3D264990, per=3D6.32%, avg=3D2=
13656.75, stdev=3D10871.71
>> f7: =A0 =A0 =A0read : io=3D32780MB, bw=3D213431KB/s, iops=3D10, runt=
=3D157272msec
>> =A0 =A0 bw (KB/s) : min=3D148137, max=3D254635, per=3D6.32%, avg=3D2=
13493.12, stdev=3D9319.08
>> f8: =A0 =A0 =A0read : io=3D32780MB, bw=3D213099KB/s, iops=3D10, runt=
=3D157517msec
>> =A0 =A0 bw (KB/s) : min=3D143467, max=3D267962, per=3D6.31%, avg=3D2=
13267.60, stdev=3D11224.35
>> f9: =A0 =A0 =A0read : io=3D32780MB, bw=3D211254KB/s, iops=3D10, runt=
=3D158893msec
>> =A0 =A0 bw (KB/s) : min=3D149489, max=3D267962, per=3D6.25%, avg=3D2=
11257.05, stdev=3D9370.64
>> f10: =A0 =A0 read : io=3D32780MB, bw=3D212251KB/s, iops=3D10, runt=3D=
158146msec
>> =A0 =A0 bw (KB/s) : min=3D150865, max=3D225882, per=3D6.28%, avg=3D2=
12300.50, stdev=3D8431.06
>> f11: =A0 =A0 read : io=3D32780MB, bw=3D212988KB/s, iops=3D10, runt=3D=
157599msec
>> =A0 =A0 bw (KB/s) : min=3D149489, max=3D221007, per=3D6.31%, avg=3D2=
13123.72, stdev=3D9569.27
>> f12: =A0 =A0 read : io=3D32780MB, bw=3D212788KB/s, iops=3D10, runt=3D=
157747msec
>> =A0 =A0 bw (KB/s) : min=3D154274, max=3D218647, per=3D6.30%, avg=3D2=
12957.41, stdev=3D8233.52
>> f13: =A0 =A0 read : io=3D32780MB, bw=3D212315KB/s, iops=3D10, runt=3D=
158099msec
>> =A0 =A0 bw (KB/s) : min=3D153696, max=3D256000, per=3D6.29%, avg=3D2=
12482.68, stdev=3D9203.34
>> f14: =A0 =A0 read : io=3D32780MB, bw=3D212033KB/s, iops=3D10, runt=3D=
158309msec
>> =A0 =A0 bw (KB/s) : min=3D150588, max=3D267962, per=3D6.28%, avg=3D2=
12198.76, stdev=3D9572.31
>> f15: =A0 =A0 read : io=3D32780MB, bw=3D211720KB/s, iops=3D10, runt=3D=
158543msec
>> =A0 =A0 bw (KB/s) : min=3D146024, max=3D268968, per=3D6.27%, avg=3D2=
11846.40, stdev=3D10341.58
>> f16: =A0 =A0 read : io=3D32780MB, bw=3D211637KB/s, iops=3D10, runt=3D=
158605msec
>> =A0 =A0 bw (KB/s) : min=3D148945, max=3D261605, per=3D6.26%, avg=3D2=
11618.40, stdev=3D9240.64
>>
>> Run status group 0 (all jobs):
>> =A0 =A0READ: io=3D524480MB, aggrb=3D3301MB/s, minb=3D216323KB/s, max=
b=3D219763KB/s, mint=3D156406msec, maxt=3D158893msec
>>
>> Disk stats (read/write):
>> =A0 sdd: ios=3D261902/0, merge=3D0/0, ticks=3D12531810/0, in_queue=3D=
12532910, util=3D99.46%
>> =A0 sde: ios=3D262221/0, merge=3D0/0, ticks=3D12494200/0, in_queue=3D=
12495300, util=3D99.50%
>> =A0 sdf: ios=3D261867/0, merge=3D0/0, ticks=3D12427000/0, in_queue=3D=
12430530, util=3D99.47%
>> =A0 sdg: ios=3D261983/0, merge=3D0/0, ticks=3D12462320/0, in_queue=3D=
12466060, util=3D99.62%
>> =A0 sdh: ios=3D262184/0, merge=3D0/0, ticks=3D12487350/0, in_queue=3D=
12489960, util=3D99.49%
>> =A0 sdi: ios=3D262193/0, merge=3D0/0, ticks=3D12524400/0, in_queue=3D=
12526580, util=3D99.47%
>> =A0 sdj: ios=3D262044/0, merge=3D0/0, ticks=3D12511850/0, in_queue=3D=
12513840, util=3D99.50%
>> =A0 sdk: ios=3D262055/0, merge=3D0/0, ticks=3D12526560/0, in_queue=3D=
12527890, util=3D99.50%
>> =A0 sdl: ios=3D261789/0, merge=3D0/0, ticks=3D12609230/0, in_queue=3D=
12610400, util=3D99.54%
>> =A0 sdm: ios=3D261787/0, merge=3D0/0, ticks=3D12579000/0, in_queue=3D=
12581050, util=3D99.44%
>> =A0 sdn: ios=3D261941/0, merge=3D0/0, ticks=3D12524530/0, in_queue=3D=
12525790, util=3D99.48%
>> =A0 sdo: ios=3D262100/0, merge=3D0/0, ticks=3D12554650/0, in_queue=3D=
12555820, util=3D99.58%
>> =A0 sdp: ios=3D261877/0, merge=3D0/0, ticks=3D12572220/0, in_queue=3D=
12574610, util=3D99.54%
>> =A0 sdq: ios=3D261956/0, merge=3D0/0, ticks=3D12601480/0, in_queue=3D=
12603770, util=3D99.62%
>> =A0 sdr: ios=3D261991/0, merge=3D0/0, ticks=3D12599680/0, in_queue=3D=
12602190, util=3D99.49%
>> =A0 sds: ios=3D261852/0, merge=3D0/0, ticks=3D12624070/0, in_queue=3D=
12626580, util=3D99.58%
>
> So, the maximum for these 16 disks is 3301 MiByte/s.
>
> I also tried hardware RAID (2 sets of 8 disks), and got a similar res=
ult:
>
>> Run status group 0 (all jobs):
>> =A0 =A0READ: io=3D65560MB, aggrb=3D3024MB/s, minb=3D1548MB/s, maxb=3D=
1550MB/s, mint=3D21650msec, maxt=3D21681msec
>
>
>
>> fio should be able to push these devices up to the line speed. =A0If=
 it
>> doesn't I would suggest changing elevators (deadline, cfq, noop) and
>> bumping the max request size to the max supported by the device.
>
> 3301 MiByte/s seems like a reasonable number, given the theoretic
> maximum of 16 times the single disk performance of 16*256 MiByte/s =3D
> 4096 MiByte/s.
>
> Based on this, I have not looked at tuning. Would you recommend that =
I do?
>
> Our minimal goal is 2500 MiByte/s; that seems achievable as ZFS was a=
ble
> to reach 2750 MiByte/s without tuning.
>
>> When we have a config that does so, we can tune the btrfs side of th=
ings
>> as well.
>
> Some files are created in the root folder of the mount point, but I g=
et
> errors instead of results:
>
>> ~/fio# ./fio btrfs16.fio
>> btrfs: (g=3D0): rw=3Dread, bs=3D20M-20M/20M-20M, ioengine=3Dsync, io=
depth=3D8
>> Starting 16 processes
>> btrfs: Laying out IO file(s) (1 file(s) / 32768MB)
>> btrfs: Laying out IO file(s) (1 file(s) / 32768MB)
> [...]
>
>> btrfs: Laying out IO file(s) (1 file(s) / 32768MB)
>> fio: first direct IO errored. File system may not support direct IO,=
 or iomem_align=3D is bad.
>> fio: first direct IO errored. File system may not support direct IO,=
 or iomem_align=3D is bad.
>> fio: first direct IO errored. File system may not support direct IO,=
 or iomem_align=3D is bad.
>> fio: pid=3D5958, err=3D22/file:engines/sync.c:62, func=3Dxfer, error=
=3DInvalid argument
>> fio: pid=3D5961, err=3D22/file:engines/sync.c:62, func=3Dxfer, error=
=3DInvalid argument
>> fio: pid=3D5962, err=3D22/file:engines/sync.c:62, func=3Dxfer, error=
=3DInvalid argument
>> fio: first direct IO errored. File system may not support direct IO,=
 or iomem_align=3D is bad.
> [...]
>>
>> btrfs: (groupid=3D0, jobs=3D1): err=3D22 (file:engines/sync.c:62, fu=
nc=3Dxfer, error=3DInvalid argument): pid=3D5956
>> =A0 cpu =A0 =A0 =A0 =A0 =A0: usr=3D0.00%, sys=3D0.00%, ctx=3D1, majf=
=3D0, minf=3D52
>> =A0 IO depths =A0 =A0: 1=3D100.0%, 2=3D0.0%, 4=3D0.0%, 8=3D0.0%, 16=3D=
0.0%, 32=3D0.0%, >=3D64=3D0.0%
>> =A0 =A0 =A0submit =A0 =A0: 0=3D0.0%, 4=3D100.0%, 8=3D0.0%, 16=3D0.0%=
, 32=3D0.0%, 64=3D0.0%, >=3D64=3D0.0%
>> =A0 =A0 =A0complete =A0: 0=3D50.0%, 4=3D50.0%, 8=3D0.0%, 16=3D0.0%, =
32=3D0.0%, 64=3D0.0%, >=3D64=3D0.0%
>> =A0 =A0 =A0issued r/w: total=3D1/0, short=3D0/0
> [no results]
>
> What could be going on here?
> (I get the same result from the github version of fio, fio 1.42, as w=
ell
> as the one that came with Ubuntu, fio 1.33.1).

If you are using 2.6.32 (as above), BTRFS on this release doesn't
support direct I/O. It is supported on 2.6.35, so you could retry with
(eg):
http://kernel.ubuntu.com/~kernel-ppa/mainline/v2.6.35-maverick/linux-im=
age-2.6.35-020635-generic_2.6.35-020635_amd64.deb
--=20
Daniel J Blueman
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
