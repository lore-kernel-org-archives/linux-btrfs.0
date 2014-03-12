Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:8404 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755989AbaCLBKG (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 11 Mar 2014 21:10:06 -0400
From: "quwenruo@cn.fujitsu.com" <quwenruo@cn.fujitsu.com>
To: Zach Brown <zab@zabbo.net>, Saul Wold <sgw@linux.intel.com>
CC: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
        "dg77.kim@samsung.com" <dg77.kim@samsung.com>
Subject: Re: Building a brtfs filesystem < 70M?
Date: Wed, 12 Mar 2014 01:10:04 +0000
Message-ID: <531FB42C.5000101@cn.fujitsu.com>
References: <531E4A02.5010404@linux.intel.com>
 <20140311163700.GQ2069@lenny.home.zabbo.net>
In-Reply-To: <20140311163700.GQ2069@lenny.home.zabbo.net>
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, 11 Mar 2014 09:37:00 -0700, Zach Brown wrote:
>> There seems to be an issue if we try to build a btrfs based FS that
>> is less than 70M, we get the following assertion failure:
>>
>> mkfs.btrfs: extent-tree.c:2682: btrfs_reserve_extent: Assertion
>> `!(ret)' failed.
>> mkfs.btrfs -b 104857600 -r rootfs rootfs.btrfs
> Honestly, the path of least resistance is probably to avoid the -r
> option all together.  As you've found, it's not reliable.
>
> I'd take the time to roll the infrastrcture to populate the image by
> writing to a mounted image with the kernel code.
>
> - z
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
I although agree with the mount + cp(kernel) way to populate the filesystem.
Also I think the implement of "-r" should be somewhat like mount+cp 
other than the current way,
since the userland implement is noticeably slow than kernel way.

Cc:Donggeun Kim
I also wonder why "-r" option is needed, since IMO the "-r" options is 
only needed
if the filesystem is full readonly and must be populated on 
initialization like squashfs.
And since btrfs is a filesystem that can be read and write,
the "-r" option is not somewhat needed.

So I prefer to remove the "-r" option.


Thanks
Quÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±ı»k~ÏâØ^n‡r¡ö¦zËëh™¨è­Ú&£ûàz¿äz¹Ş—ú+€Ê+zf£¢·hšˆ§~†­†Ûiÿÿïêÿ‘êçz_è®æj:+v‰¨ş)ß£øm
