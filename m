Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.19]:53789 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752873AbdL1DdW (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 27 Dec 2017 22:33:22 -0500
Subject: Re: [PATCH] Btrfs: enchanse raid1/10 balance heuristic for non
 rotating devices
To: Timofey Titovets <nefelim4ag@gmail.com>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
References: <20171227223931.7878-1-nefelim4ag@gmail.com>
 <4bc00e2e-7a46-b02c-a97b-90947fc242d9@gmx.com>
 <CAGqmi77=vfULMxVUsCSqE3DAYoddwBMaPLoCjMEntQbKUF+C=Q@mail.gmail.com>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <e819835e-33db-44d9-4321-f0162aa9e060@gmx.com>
Date: Thu, 28 Dec 2017 11:33:16 +0800
MIME-Version: 1.0
In-Reply-To: <CAGqmi77=vfULMxVUsCSqE3DAYoddwBMaPLoCjMEntQbKUF+C=Q@mail.gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="Fmz2sVGC4BF1M1Wgf8PmtixxySuOgFBdc"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--Fmz2sVGC4BF1M1Wgf8PmtixxySuOgFBdc
Content-Type: multipart/mixed; boundary="1txjQyvOnvem8HV8IniHW8JQhwPcAbobu";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: Timofey Titovets <nefelim4ag@gmail.com>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
Message-ID: <e819835e-33db-44d9-4321-f0162aa9e060@gmx.com>
Subject: Re: [PATCH] Btrfs: enchanse raid1/10 balance heuristic for non
 rotating devices
References: <20171227223931.7878-1-nefelim4ag@gmail.com>
 <4bc00e2e-7a46-b02c-a97b-90947fc242d9@gmx.com>
 <CAGqmi77=vfULMxVUsCSqE3DAYoddwBMaPLoCjMEntQbKUF+C=Q@mail.gmail.com>
In-Reply-To: <CAGqmi77=vfULMxVUsCSqE3DAYoddwBMaPLoCjMEntQbKUF+C=Q@mail.gmail.com>

--1txjQyvOnvem8HV8IniHW8JQhwPcAbobu
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2017=E5=B9=B412=E6=9C=8828=E6=97=A5 10:32, Timofey Titovets wrote:
> 2017-12-28 3:44 GMT+03:00 Qu Wenruo <quwenruo.btrfs@gmx.com>:
>>
>>
>> On 2017=E5=B9=B412=E6=9C=8828=E6=97=A5 06:39, Timofey Titovets wrote:
>>> Currently btrfs raid1/10 balancer blance requests to mirrors,
>>> based on pid % num of mirrors.
>>>
>>> Update logic and make it understood if underline device are non rotat=
ional.
>>>
>>> If one of mirrors are non rotational, then all read requests will be =
moved to
>>> non rotational device.
>>>
>>> If both of mirrors are non rotational, calculate sum of
>>> pending and in flight request for queue on that bdev and use
>>> device with least queue leght.
>>>
>>> P.S.
>>> Inspired by md-raid1 read balancing
>>>
>>> Signed-off-by: Timofey Titovets <nefelim4ag@gmail.com>
>>> ---
>>>  fs/btrfs/volumes.c | 59 ++++++++++++++++++++++++++++++++++++++++++++=
++++++++++
>>>  1 file changed, 59 insertions(+)
>>>
>>> diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
>>> index 9a04245003ab..98bc2433a920 100644
>>> --- a/fs/btrfs/volumes.c
>>> +++ b/fs/btrfs/volumes.c
>>> @@ -5216,13 +5216,30 @@ int btrfs_is_parity_mirror(struct btrfs_fs_in=
fo *fs_info, u64 logical, u64 len)
>>>       return ret;
>>>  }
>>>
>>> +static inline int bdev_get_queue_len(struct block_device *bdev)
>>> +{
>>> +     int sum =3D 0;
>>> +     struct request_queue *rq =3D bdev_get_queue(bdev);
>>> +
>>> +     sum +=3D rq->nr_rqs[BLK_RW_SYNC] + rq->nr_rqs[BLK_RW_ASYNC];
>>> +     sum +=3D rq->in_flight[BLK_RW_SYNC] + rq->in_flight[BLK_RW_ASYN=
C];
>>> +
>>> +     /*
>>> +      * Try prevent switch for every sneeze
>>> +      * By roundup output num by 2
>>> +      */
>>> +     return ALIGN(sum, 2);
>>> +}
>>> +
>>>  static int find_live_mirror(struct btrfs_fs_info *fs_info,
>>>                           struct map_lookup *map, int first, int num,=

>>>                           int optimal, int dev_replace_is_ongoing)
>>>  {
>>>       int i;
>>>       int tolerance;
>>> +     struct block_device *bdev;
>>>       struct btrfs_device *srcdev;
>>> +     bool all_bdev_nonrot =3D true;
>>>
>>>       if (dev_replace_is_ongoing &&
>>>           fs_info->dev_replace.cont_reading_from_srcdev_mode =3D=3D
>>> @@ -5231,6 +5248,48 @@ static int find_live_mirror(struct btrfs_fs_in=
fo *fs_info,
>>>       else
>>>               srcdev =3D NULL;
>>>
>>> +     /*
>>> +      * Optimal expected to be pid % num
>>> +      * That's generaly ok for spinning rust drives
>>> +      * But if one of mirror are non rotating,
>>> +      * that bdev can show better performance
>>> +      *
>>> +      * if one of disks are non rotating:
>>> +      *  - set optimal to non rotating device
>>> +      * if both disk are non rotating
>>> +      *  - set optimal to bdev with least queue
>>> +      * If both disks are spinning rust:
>>> +      *  - leave old pid % nu,
>>
>> And I'm wondering why this case can't use the same bdev queue length?
>>
>> Any special reason spinning disk can't benifit from a shorter queue?
>>
>> Thanks,
>> Qu
>=20
> I didn't have spinning rust to test it,
> But i expect that queue based balancing will kill sequential io balanci=
ng.
>=20
> (Also, it's better to balance by avg Latency per request, i think,
> but we just didn't have that property and need much more calculation)
>=20
> i.e. with spinning rust "true way" (in theory),
> is just trying to calculate where head at now.
> As example:
> based on last queryes,
> and send request to hdd which have a shorter path to blocks.
>=20
> That in theory will show best random read and sequential read, from
> hdd raid1 array.
>=20
> But for that we need some tracking of io queue:
>  - Write it own, as done in mdraid
>    and just believe no-one else will touch our disk
>  - Make some analisys
>    of queue linked to bdev, not sure if we have another way.
>=20
> In theory, user with that patch just can switch rotational to 0 on
> spinning rust,
> but that can lead to misbehaving of io scheduler.. so may be it's a
> bad idea to test that by flags.

Makes sense.

But this reminds me that, Adam Bahe reported for his large 20 HDDs setup
where he uses RAID10 for performance reason, mainly because RAID1
doesn't provide good enough read performance (around 80Mbytes/s RAID1
read vs 125Mbytes/s raw device).

So I'm more interested in enhancing RAID1 read performance on HDD, but
just as you mentioned, it's never an easy work.

Thanks,
Qu
>=20
> ---
> About benchmarks:
> Sorry, didn't have a real hardware to test,
> so i don't think it's representative, but:
>=20
> Fio config:
> [global]
> ioengine=3Dlibaio
> buffered=3D0
> direct=3D1
> bssplit=3D32k/100
> size=3D1G
> directory=3D/mnt/
> iodepth=3D16
> time_based
> runtime=3D60
>=20
> [test-fio]
> rw=3Drandread
>=20
> VM KVM:
>  - Debian 9.3
>  - Scheduler: noop
>  - Image devid 1 on Notebook SSD.
>  - Image devid 2 on Fast Enough USB Stick.
>  - Both formatted to btrfs raid1.
>  - Kernel patched 4.15-rc3 from misc-next kdave (that i have compiled..=
)
>  - (I see same on backported 4.13 debian kernel)
> ---
> Pid choice image on SSD:
> test-fio: (g=3D0): rw=3Drandread, bs=3D32K-32K/32K-32K/32K-32K,
> ioengine=3Dlibaio, iodepth=3D16
> fio-2.16
> Starting 1 process
> Jobs: 1 (f=3D1): [r(1)] [100.0% done] [157.4MB/0KB/0KB /s] [5025/0/0
> iops] [eta 00m:00s]
> test-fio: (groupid=3D0, jobs=3D1): err=3D 0: pid=3D1217: Thu Dec 28 04:=
57:38 2017
>  read : io=3D10001MB, bw=3D170664KB/s, iops=3D5333, runt=3D 60008msec
>    slat (usec): min=3D7, max=3D13005, avg=3D25.58, stdev=3D83.45
>    clat (usec): min=3D3, max=3D41567, avg=3D2971.16, stdev=3D4456.01
>     lat (usec): min=3D251, max=3D41609, avg=3D2997.21, stdev=3D4457.03
>    clat percentiles (usec):
>     |  1.00th=3D[  278],  5.00th=3D[  298], 10.00th=3D[  310], 20.00th=3D=
[  338],
>     | 30.00th=3D[  362], 40.00th=3D[  390], 50.00th=3D[  430], 60.00th=3D=
[  540],
>     | 70.00th=3D[ 1020], 80.00th=3D[ 9280], 90.00th=3D[10816], 95.00th=3D=
[11456],
>     | 99.00th=3D[14528], 99.50th=3D[16320], 99.90th=3D[20608], 99.95th=3D=
[23168],
>     | 99.99th=3D[29824]
>    lat (usec) : 4=3D0.01%, 100=3D0.01%, 250=3D0.02%, 500=3D57.53%, 750=3D=
8.93%
>    lat (usec) : 1000=3D3.34%
>    lat (msec) : 2=3D3.57%, 4=3D2.13%, 10=3D8.34%, 20=3D16.01%, 50=3D0.1=
2%
>  cpu          : usr=3D2.57%, sys=3D15.69%, ctx=3D249390, majf=3D0, minf=
=3D135
>  IO depths    : 1=3D0.1%, 2=3D0.1%, 4=3D0.1%, 8=3D0.1%, 16=3D100.0%, 32=
=3D0.0%, >=3D64=3D0.0%
>     submit    : 0=3D0.0%, 4=3D100.0%, 8=3D0.0%, 16=3D0.0%, 32=3D0.0%, 6=
4=3D0.0%, >=3D64=3D0.0%
>     complete  : 0=3D0.0%, 4=3D100.0%, 8=3D0.0%, 16=3D0.1%, 32=3D0.0%, 6=
4=3D0.0%, >=3D64=3D0.0%
>     issued    : total=3Dr=3D320037/w=3D0/d=3D0, short=3Dr=3D0/w=3D0/d=3D=
0, drop=3Dr=3D0/w=3D0/d=3D0
>     latency   : target=3D0, window=3D0, percentile=3D100.00%, depth=3D1=
6
>=20
> Run status group 0 (all jobs):
>   READ: io=3D10001MB, aggrb=3D170663KB/s, minb=3D170663KB/s,
> maxb=3D170663KB/s, mint=3D60008msec, maxt=3D60008msec
> ---
> Pid choice USB Stick:
> test-fio: (g=3D0): rw=3Drandread, bs=3D32K-32K/32K-32K/32K-32K,
> ioengine=3Dlibaio, iodepth=3D16
> fio-2.16
> Starting 1 process
> Jobs: 1 (f=3D1): [r(1)] [100.0% done] [51891KB/0KB/0KB /s] [1621/0/0
> iops] [eta 00m:00s]
> test-fio: (groupid=3D0, jobs=3D1): err=3D 0: pid=3D668: Thu Dec 28 04:4=
6:16 2017
>  read : io=3D3131.3MB, bw=3D53430KB/s, iops=3D1669, runt=3D 60012msec
>    slat (usec): min=3D7, max=3D12463, avg=3D60.39, stdev=3D97.64
>    clat (usec): min=3D11, max=3D116362, avg=3D9513.58, stdev=3D5797.06
>     lat (usec): min=3D274, max=3D116423, avg=3D9575.25, stdev=3D5800.91=

>    clat percentiles (usec):
>     |  1.00th=3D[  306],  5.00th=3D[  362], 10.00th=3D[  430], 20.00th=3D=
[  932],
>     | 30.00th=3D[10176], 40.00th=3D[11584], 50.00th=3D[11840], 60.00th=3D=
[12096],
>     | 70.00th=3D[12480], 80.00th=3D[12992], 90.00th=3D[14272], 95.00th=3D=
[16192],
>     | 99.00th=3D[21888], 99.50th=3D[25216], 99.90th=3D[32128], 99.95th=3D=
[36096],
>     | 99.99th=3D[52480]
>    lat (usec) : 20=3D0.01%, 250=3D0.01%, 500=3D12.44%, 750=3D4.88%, 100=
0=3D3.43%
>    lat (msec) : 2=3D3.45%, 4=3D3.47%, 10=3D2.12%, 20=3D68.61%, 50=3D1.5=
8%
>    lat (msec) : 100=3D0.01%, 250=3D0.01%
>  cpu          : usr=3D1.81%, sys=3D11.42%, ctx=3D89411, majf=3D0, minf=3D=
135
>  IO depths    : 1=3D0.1%, 2=3D0.1%, 4=3D0.1%, 8=3D0.1%, 16=3D100.0%, 32=
=3D0.0%, >=3D64=3D0.0%
>     submit    : 0=3D0.0%, 4=3D100.0%, 8=3D0.0%, 16=3D0.0%, 32=3D0.0%, 6=
4=3D0.0%, >=3D64=3D0.0%
>     complete  : 0=3D0.0%, 4=3D100.0%, 8=3D0.0%, 16=3D0.1%, 32=3D0.0%, 6=
4=3D0.0%, >=3D64=3D0.0%
>     issued    : total=3Dr=3D100201/w=3D0/d=3D0, short=3Dr=3D0/w=3D0/d=3D=
0, drop=3Dr=3D0/w=3D0/d=3D0
>     latency   : target=3D0, window=3D0, percentile=3D100.00%, depth=3D1=
6
>=20
> Run status group 0 (all jobs):
>   READ: io=3D3131.3MB, aggrb=3D53429KB/s, minb=3D53429KB/s, maxb=3D5342=
9KB/s,
> mint=3D60012msec, maxt=3D60012msec
> ---
> Rotational 1 0 - Force use USB Stick:
> test-fio: (g=3D0): rw=3Drandread, bs=3D32K-32K/32K-32K/32K-32K,
> ioengine=3Dlibaio, iodepth=3D16
> fio-2.16
> Starting 1 process
> Jobs: 1 (f=3D1): [r(1)] [100.0% done] [41824KB/0KB/0KB /s] [1307/0/0
> iops] [eta 00m:00s]
> test-fio: (groupid=3D0, jobs=3D1): err=3D 0: pid=3D2007: Thu Dec 28 05:=
20:37 2017
>  read : io=3D2401.1MB, bw=3D40981KB/s, iops=3D1280, runt=3D 60017msec
>    slat (usec): min=3D9, max=3D10397, avg=3D57.82, stdev=3D76.46
>    clat (usec): min=3D893, max=3D49568, avg=3D12427.70, stdev=3D2740.99=

>     lat (usec): min=3D921, max=3D49752, avg=3D12486.61, stdev=3D2747.34=

>    clat percentiles (usec):
>     |  1.00th=3D[ 2224],  5.00th=3D[10816], 10.00th=3D[11712], 20.00th=3D=
[11840],
>     | 30.00th=3D[11968], 40.00th=3D[11968], 50.00th=3D[12224], 60.00th=3D=
[12480],
>     | 70.00th=3D[12736], 80.00th=3D[12992], 90.00th=3D[14016], 95.00th=3D=
[15808],
>     | 99.00th=3D[22144], 99.50th=3D[25728], 99.90th=3D[31104], 99.95th=3D=
[32384],
>     | 99.99th=3D[40704]
>    lat (usec) : 1000=3D0.01%
>    lat (msec) : 2=3D0.21%, 4=3D3.12%, 10=3D0.98%, 20=3D94.06%, 50=3D1.6=
2%
>  cpu          : usr=3D1.58%, sys=3D8.68%, ctx=3D75492, majf=3D0, minf=3D=
137
>  IO depths    : 1=3D0.1%, 2=3D0.1%, 4=3D0.1%, 8=3D0.1%, 16=3D100.0%, 32=
=3D0.0%, >=3D64=3D0.0%
>     submit    : 0=3D0.0%, 4=3D100.0%, 8=3D0.0%, 16=3D0.0%, 32=3D0.0%, 6=
4=3D0.0%, >=3D64=3D0.0%
>     complete  : 0=3D0.0%, 4=3D100.0%, 8=3D0.0%, 16=3D0.1%, 32=3D0.0%, 6=
4=3D0.0%, >=3D64=3D0.0%
>     issued    : total=3Dr=3D76862/w=3D0/d=3D0, short=3Dr=3D0/w=3D0/d=3D=
0, drop=3Dr=3D0/w=3D0/d=3D0
>     latency   : target=3D0, window=3D0, percentile=3D100.00%, depth=3D1=
6
>=20
> Run status group 0 (all jobs):
>   READ: io=3D2401.1MB, aggrb=3D40981KB/s, minb=3D40981KB/s, maxb=3D4098=
1KB/s,
> mint=3D60017msec, maxt=3D60017msec
> ---
> Rotational 0 1 - Force use Notebook SSD:
> test-fio: (g=3D0): rw=3Drandread, bs=3D32K-32K/32K-32K/32K-32K,
> ioengine=3Dlibaio, iodepth=3D16
> fio-2.16
> Starting 1 process
> Jobs: 1 (f=3D1): [r(1)] [100.0% done] [403.6MB/0KB/0KB /s] [12.9K/0/0
> iops] [eta 00m:00s]
> test-fio: (groupid=3D0, jobs=3D1): err=3D 0: pid=3D1945: Thu Dec 28 05:=
18:50 2017
>  read : io=3D24476MB, bw=3D417710KB/s, iops=3D13053, runt=3D 60002msec
>    slat (usec): min=3D6, max=3D10812, avg=3D22.81, stdev=3D70.05
>    clat (usec): min=3D163, max=3D40433, avg=3D1200.02, stdev=3D867.99
>     lat (usec): min=3D322, max=3D40453, avg=3D1223.28, stdev=3D871.33
>    clat percentiles (usec):
>     |  1.00th=3D[  532],  5.00th=3D[  708], 10.00th=3D[  788], 20.00th=3D=
[  876],
>     | 30.00th=3D[  924], 40.00th=3D[  972], 50.00th=3D[  996], 60.00th=3D=
[ 1048],
>     | 70.00th=3D[ 1112], 80.00th=3D[ 1256], 90.00th=3D[ 1656], 95.00th=3D=
[ 2288],
>     | 99.00th=3D[ 5216], 99.50th=3D[ 6944], 99.90th=3D[10048], 99.95th=3D=
[11456],
>     | 99.99th=3D[16512]
>    lat (usec) : 250=3D0.01%, 500=3D0.66%, 750=3D6.78%, 1000=3D43.18%
>    lat (msec) : 2=3D42.73%, 4=3D4.97%, 10=3D1.56%, 20=3D0.10%, 50=3D0.0=
1%
>  cpu          : usr=3D4.30%, sys=3D34.59%, ctx=3D507897, majf=3D0, minf=
=3D136
>  IO depths    : 1=3D0.1%, 2=3D0.1%, 4=3D0.1%, 8=3D0.1%, 16=3D100.0%, 32=
=3D0.0%, >=3D64=3D0.0%
>     submit    : 0=3D0.0%, 4=3D100.0%, 8=3D0.0%, 16=3D0.0%, 32=3D0.0%, 6=
4=3D0.0%, >=3D64=3D0.0%
>     complete  : 0=3D0.0%, 4=3D100.0%, 8=3D0.0%, 16=3D0.1%, 32=3D0.0%, 6=
4=3D0.0%, >=3D64=3D0.0%
>     issued    : total=3Dr=3D783233/w=3D0/d=3D0, short=3Dr=3D0/w=3D0/d=3D=
0, drop=3Dr=3D0/w=3D0/d=3D0
>     latency   : target=3D0, window=3D0, percentile=3D100.00%, depth=3D1=
6
>=20
> Run status group 0 (all jobs):
>   READ: io=3D24476MB, aggrb=3D417710KB/s, minb=3D417710KB/s,
> maxb=3D417710KB/s, mint=3D60002msec, maxt=3D60002msec
> ---
> Rotational 0 0:
> test-fio: (g=3D0): rw=3Drandread, bs=3D32K-32K/32K-32K/32K-32K,
> ioengine=3Dlibaio, iodepth=3D16
> fio-2.16
> Starting 1 process
> Jobs: 1 (f=3D1): [r(1)] [100.0% done] [393.1MB/0KB/0KB /s] [12.7K/0/0
> iops] [eta 00m:00s]
> test-fio: (groupid=3D0, jobs=3D1): err=3D 0: pid=3D2188: Thu Dec 28 05:=
25:49 2017
>  read : io=3D22535MB, bw=3D384563KB/s, iops=3D12017, runt=3D 60006msec
>    slat (usec): min=3D7, max=3D13287, avg=3D22.39, stdev=3D74.68
>    clat (usec): min=3D91, max=3D265780, avg=3D1306.16, stdev=3D2148.92
>     lat (usec): min=3D276, max=3D265853, avg=3D1328.99, stdev=3D2150.68=

>    clat percentiles (usec):
>     |  1.00th=3D[  394],  5.00th=3D[  438], 10.00th=3D[  462], 20.00th=3D=
[  490],
>     | 30.00th=3D[  516], 40.00th=3D[  540], 50.00th=3D[  572], 60.00th=3D=
[  620],
>     | 70.00th=3D[  684], 80.00th=3D[  884], 90.00th=3D[ 5216], 95.00th=3D=
[ 5984],
>     | 99.00th=3D[ 9024], 99.50th=3D[10944], 99.90th=3D[15296], 99.95th=3D=
[16768],
>     | 99.99th=3D[21376]
>    lat (usec) : 100=3D0.01%, 250=3D0.01%, 500=3D24.00%, 750=3D51.25%, 1=
000=3D6.88%
>    lat (msec) : 2=3D5.03%, 4=3D2.09%, 10=3D10.05%, 20=3D0.69%, 50=3D0.0=
1%
>    lat (msec) : 250=3D0.01%, 500=3D0.01%
>  cpu          : usr=3D4.21%, sys=3D31.78%, ctx=3D476317, majf=3D0, minf=
=3D137
>  IO depths    : 1=3D0.1%, 2=3D0.1%, 4=3D0.1%, 8=3D0.1%, 16=3D100.0%, 32=
=3D0.0%, >=3D64=3D0.0%
>     submit    : 0=3D0.0%, 4=3D100.0%, 8=3D0.0%, 16=3D0.0%, 32=3D0.0%, 6=
4=3D0.0%, >=3D64=3D0.0%
>     complete  : 0=3D0.0%, 4=3D100.0%, 8=3D0.0%, 16=3D0.1%, 32=3D0.0%, 6=
4=3D0.0%, >=3D64=3D0.0%
>     issued    : total=3Dr=3D721127/w=3D0/d=3D0, short=3Dr=3D0/w=3D0/d=3D=
0, drop=3Dr=3D0/w=3D0/d=3D0
>     latency   : target=3D0, window=3D0, percentile=3D100.00%, depth=3D1=
6
>=20
> Run status group 0 (all jobs):
>   READ: io=3D22535MB, aggrb=3D384562KB/s, minb=3D384562KB/s,
> maxb=3D384562KB/s, mint=3D60006msec, maxt=3D60006msec
> ---
>=20
> Not sure why we see so big difference, for 0 1, 1 0 and pid choice mod,=

> as i see in iostat on pid choice i see parasitic load on usb stick,
> when ssd in testing,
> may be some kernel threads re-read meta date and that cause noise... No=
 idea.
>=20
> Thanks..
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>=20


--1txjQyvOnvem8HV8IniHW8JQhwPcAbobu--

--Fmz2sVGC4BF1M1Wgf8PmtixxySuOgFBdc
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQFLBAEBCAA1FiEELd9y5aWlW6idqkLhwj2R86El/qgFAlpEZfwXHHF1d2VucnVv
LmJ0cmZzQGdteC5jb20ACgkQwj2R86El/qgIIgf+JA7JQICy8QkjA7cUF3Y5xevq
5lTovY4Hg4p3F3wLDeCSDpHOMTQJ7KYoDHwVcKWGZxe/u8uPRVSYC02f76XoOaFt
mAGq/O8qV0t4EKHzppObpDfYZNoYbhJwsGZWqXjF9Bbuby6hYaD0vwUNFtW6DXGP
Jw95UAYz+3xpxmP+vGeQ1eDskmbEqm4QtbsfScekxBXaSjhEVZNubW1g06l0XaBr
uU3vy7PSQrvyhedl9f5YnKdOk3mkT+2bDbw8asGMiHfiiSlQS76Ni7FwNHTbSdmt
0/9fidkiO9Wptucu6pCneXFxS4KDNlakkPF7n9QUI4gQocBa2o30Utlkm0QM0Q==
=hQ43
-----END PGP SIGNATURE-----

--Fmz2sVGC4BF1M1Wgf8PmtixxySuOgFBdc--
