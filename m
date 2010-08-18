From: Leonidas Spyropoulos <artafinde@gmail.com>
Subject: Re: Poor creat/delete files performance
Date: Wed, 18 Aug 2010 11:49:16 +0100
Message-ID: <AANLkTiktGxrm7KqhCUtts8h_jiX0UGCSygKxi06FpRn=@mail.gmail.com>
References: <4C6BB21E.3000809@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Chris Mason <chris.mason@oracle.com>,
	Yan Zheng <zheng.yan@oracle.com>,
	Linux Btrfs <linux-btrfs@vger.kernel.org>
To: miaox@cn.fujitsu.com
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4C6BB21E.3000809@cn.fujitsu.com>
List-ID: <linux-btrfs.vger.kernel.org>

Have you tried umounting and mounting before the second test to
eliminate any caching?
Which kernel you use?

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
>



--=20
Caution: breathing may be hazardous to your health.
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
