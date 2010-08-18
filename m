From: "Morten P.D. Stevens" <mstevens@imt-systems.com>
Subject: RE: Poor creat/delete files performance
Date: Wed, 18 Aug 2010 12:49:05 +0200
Message-ID: <7222A6B8ACA37D4AA1AC37810C43E8A80F5FC5C5@mail.corp.imt-systems.com>
References: <4C6BB21E.3000809@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Cc: "miaox@cn.fujitsu.com" <miaox@cn.fujitsu.com>
To: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4C6BB21E.3000809@cn.fujitsu.com>
List-ID: <linux-btrfs.vger.kernel.org>

2010/8/18 Miao Xie <miaox@cn.fujitsu.com>:
> Hi,
>
> We did some performance test and found the create/delete files perfor=
mance
> of btrfs is very poor.
>
> The test is that we create 50000 files and measure the file-create ti=
me
> first, and then delete these 50000 files and measure the file-delete =
time.
> (The attached file is the reproduce program)
>
> The result is following:
> (Unit: second)
> =A0Create file performance
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0BtrFS =A0 =A0 =A0 =A0 =A0 Ext4
> =A0Total times: =A02.462625 =A0 =A0 =A0 =A01.449550
> =A0Average: =A0 =A0 =A00.000049 =A0 =A0 =A0 =A00.000029
>
> =A0Delete file performance
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0BtrFS =A0 =A0 =A0 =A0 =A0 Ext4
> =A0Total times: =A03.312796 =A0 =A0 =A0 =A00.997946
> =A0Average: =A0 =A0 =A00.000066 =A0 =A0 =A0 =A00.000020
>
> The results were measured on a x86_64 server with 4 cores and 2 SAS d=
isks.
> By debuging, we found the btrfs spent a lot of time on searching and
> inserting/removing items in the ctree.
>
> Is anyone looking at this issue?
>
> Regards
> Miao Xie

Hi,

i can confirm this issue with poor create and delete performance.

=46or example with unpacking and deleting the linux kernel:

Btrfs:

[root@fc13 btrfs]# time tar xfj linux-2.6.36-rc1.tar.bz2

real    0m18.794s
user    0m12.045s
sys     0m8.241s
[root@fc13 btrfs]# time rm -rf linux-2.6.36-rc1

real    0m2.156s
user    0m0.028s
sys     0m2.118s

ext4:

[root@fc13 ext4]# time tar xfj linux-2.6.36-rc1.tar.bz2

real    0m13.140s
user    0m9.074s
sys     0m6.327s
[root@fc13 ext4]# time rm -rf linux-2.6.36-rc1

real    0m0.781s
user    0m0.031s
sys     0m0.735s

In all of our benchmarks, ext4 is still faster than btrfs.

Best regards,

Morten

--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
