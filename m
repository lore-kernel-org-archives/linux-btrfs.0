From: Chris Mason <chris.mason@oracle.com>
Subject: Re: Poor creat/delete files performance
Date: Wed, 18 Aug 2010 08:09:41 -0400
Message-ID: <20100818120941.GM5854@think>
References: <4C6BB21E.3000809@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Yan Zheng <zheng.yan@oracle.com>,
	Linux Btrfs <linux-btrfs@vger.kernel.org>
To: Miao Xie <miaox@cn.fujitsu.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4C6BB21E.3000809@cn.fujitsu.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Aug 18, 2010 at 06:12:46PM +0800, Miao Xie wrote:
> Hi,
> 
> We did some performance test and found the create/delete files performance
> of btrfs is very poor.
> 
> The test is that we create 50000 files and measure the file-create time
> first, and then delete these 50000 files and measure the file-delete time. 
> (The attached file is the reproduce program)
> 
> The result is following:
> (Unit: second)
>   Create file performance
> 		BtrFS		Ext4
>   Total times:	2.462625	1.449550
>   Average:	0.000049	0.000029
> 
>   Delete file performance
> 		BtrFS		Ext4
>   Total times:	3.312796	0.997946
>   Average:	0.000066	0.000020
> 
> The results were measured on a x86_64 server with 4 cores and 2 SAS disks.
> By debuging, we found the btrfs spent a lot of time on searching and
> inserting/removing items in the ctree.
> 
> Is anyone looking at this issue?

I'm looking at it now, which kernel were you on?  We do spend some CPU
time on the btree but it shouldn't be a big bottleneck compared to the
disk.

This should be very similar to the performance regression that Steve
Pratt hit.  Our deletion time has always been slower than ext4, but the
creation time should be the same or faster.

-chris

