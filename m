Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:50013 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756181AbaCLBn3 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 11 Mar 2014 21:43:29 -0400
Message-ID: <531FBBBD.9000109@linux.intel.com>
Date: Tue, 11 Mar 2014 18:43:25 -0700
From: Saul Wold <sgw@linux.intel.com>
MIME-Version: 1.0
To: "quwenruo@cn.fujitsu.com" <quwenruo@cn.fujitsu.com>,
        Zach Brown <zab@zabbo.net>
CC: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
        "dg77.kim@samsung.com" <dg77.kim@samsung.com>
Subject: Re: Building a brtfs filesystem < 70M?
References: <531E4A02.5010404@linux.intel.com> <20140311163700.GQ2069@lenny.home.zabbo.net> <531FB42C.5000101@cn.fujitsu.com>
In-Reply-To: <531FB42C.5000101@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 03/11/2014 06:10 PM, quwenruo@cn.fujitsu.com wrote:
> On Tue, 11 Mar 2014 09:37:00 -0700, Zach Brown wrote:
>>> There seems to be an issue if we try to build a btrfs based FS that
>>> is less than 70M, we get the following assertion failure:
>>>
>>> mkfs.btrfs: extent-tree.c:2682: btrfs_reserve_extent: Assertion
>>> `!(ret)' failed.
>>> mkfs.btrfs -b 104857600 -r rootfs rootfs.btrfs
>> Honestly, the path of least resistance is probably to avoid the -r
>> option all together.  As you've found, it's not reliable.
>>
>> I'd take the time to roll the infrastrcture to populate the image by
>> writing to a mounted image with the kernel code.
>>
>> - z
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>
> I although agree with the mount + cp(kernel) way to populate the filesystem.
> Also I think the implement of "-r" should be somewhat like mount+cp
> other than the current way,
> since the userland implement is noticeably slow than kernel way.
>
> Cc:Donggeun Kim
> I also wonder why "-r" option is needed, since IMO the "-r" options is
> only needed
> if the filesystem is full readonly and must be populated on
> initialization like squashfs.
> And since btrfs is a filesystem that can be read and write,
> the "-r" option is not somewhat needed.
>
> So I prefer to remove the "-r" option.
>
Please dont remove the -r option, as you point out above it's used from 
userland.  The Yocto Project / OE-Core uses this option to build a put a 
rootfs into a filesystem image in userland without requiring root 
permissions, we use something call pseudo (it a smarter version of 
fakeroot) to lay down a root filesytem.

The patch from Gui worked well for our purposes, we are no longer 
failing to build the filesystem image.

Thanks

Sau!

>
> Thanks
> Qu
>
