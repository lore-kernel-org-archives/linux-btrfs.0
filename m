From: Miao Xie <miaox@cn.fujitsu.com>
Subject: Re: [PATCH] btrfs-progs: add mounted-checking for btrfs-vol
Date: Wed, 03 Feb 2010 10:11:21 +0800
Message-ID: <4B68DB49.4070905@cn.fujitsu.com>
References: <4B67E646.4050001@cn.fujitsu.com> <20100202090813.GC4080@laptop.oracle.com>
Reply-To: miaox@cn.fujitsu.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Chris Mason <chris.mason@oracle.com>,
	Linux Btrfs <linux-btrfs@vger.kernel.org>
To: Wengang Wang <wen.gang.wang@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20100202090813.GC4080@laptop.oracle.com>
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

on 2010-2-2 17:08, Wengang Wang wrote:
[snip]
>>  		devfd = open(device, O_RDWR);
>>  		if (!devfd) {
> I think open() returning -1 means an error. So it should be
> 		if (devfd < 0)
> instead of 
> 		if (!devfd)

Yes, you are right. 
Thanks for your comment. I'll remake a patch.

Regards
Miao

> 
> regards,
> wengang.
>>  			fprintf(stderr, "Unable to open device %s\n", device);
>> +			exit(1);
>>  		}
>>  		ret = fstat(devfd, &st);
>>  		if (ret) {
> 
> 
> 


