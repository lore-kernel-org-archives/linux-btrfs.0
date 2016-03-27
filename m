Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.22]:55184 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751391AbcC0Nqq (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 27 Mar 2016 09:46:46 -0400
Subject: Re: csum errors in VirtualBox VDI files
To: Kai Krakow <hurikhan77@gmail.com>, linux-btrfs@vger.kernel.org
References: <20160322090342.595fefac@jupiter.sol.kaishome.de>
 <56F1068E.6050806@cn.fujitsu.com>
 <20160322194854.161e9c4c@jupiter.sol.kaishome.de>
 <56F21898.3020101@cn.fujitsu.com>
 <20160326203035.4b876a04@jupiter.sol.kaishome.de>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <56F7E43F.5070008@gmx.com>
Date: Sun, 27 Mar 2016 21:46:39 +0800
MIME-Version: 1.0
In-Reply-To: <20160326203035.4b876a04@jupiter.sol.kaishome.de>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 03/27/2016 03:30 AM, Kai Krakow wrote:
> Am Wed, 23 Mar 2016 12:16:24 +0800
> schrieb Qu Wenruo <quwenruo@cn.fujitsu.com>:
>
>> Kai Krakow wrote on 2016/03/22 19:48 +0100:
>>> Am Tue, 22 Mar 2016 16:47:10 +0800
>>> schrieb Qu Wenruo <quwenruo@cn.fujitsu.com>:
>>>
>>>> Hi,
>>>>
>>>> Kai Krakow wrote on 2016/03/22 09:03 +0100:
>>   [...]
>>>>
>>>> When it goes RO, it must have some warning in kernel log.
>>>> Would you please paste the kernel log?
>>>
>>> Apparently, that system does not boot now due to errors in bcache
>>> b-tree. That being that, it may well be some bcache error and not
>>> btrfs' fault. Apparently I couldn't catch the output, I've been in a
>>> hurry. It said "write error" and had some backtrace. I will come to
>>> this back later.
>>>
>>> Let's go to the system I currently care about (that one with the
>>> always breaking VDI file):
>>>
>>   [...]
>>>> Does btrfs check report anything wrong?
>>>
>>> After the error occured?
>>>
>>> Yes, some text about the extent being compressed and btrfs repair
>>> doesn't currently handle that case (I tried --repair as I'm having a
>>> backup). I simply decided not to investigate that further at that
>>> point but delete and restore the affected file from backup.
>>> However, this is the message from dmesg (tho, I didn't catch the
>>> backtrace):
>>>
>>> btrfs_run_delayed_refs:2927: errno=-17 Object already exists
>>
>> That's nice, at least we have some clue.
>>
>> It's almost sure, it's a bug either in btrfs kernel which doesn't
>> handle delayed refs well(low possibility), or, corrupted fs which
>> create something kernel can't handle(I bet that's the case).
>
> [kernel 4.5.0 gentoo, btrfs-progs 4.4.1]
>
> Well, this time it hit me on the USB backup drive which uses no bcache
> and no other fancy options except compress-force=zlib. Apparently, I've
> only got a (real) screenshot which I'm going to link here:
>
> https://www.dropbox.com/s/9qbc7np23y8lrii/IMG_20160326_200033.jpg?dl=0

Nothing new.
The needed thing is not the warning/error part, but the info part.

Which will output the extent tree leaf with what run_delayed_refs is 
going to do.

>
> The same drive has no problems except "bad metadata crossing stripe
> boundary" - but a lot of them. This drive was never converted, it was
> freshly generated several months ago.
>
> ---8<---
> $ sudo btrfsck /dev/disk/by-label/usb-backup
> Checking filesystem on /dev/disk/by-label/usb-backup
> UUID: 1318ec21-c421-4e36-a44a-7be3d41f9c3f
> checking extents
> bad metadata [156041216, 156057600) crossing stripe boundary
> bad metadata [181403648, 181420032) crossing stripe boundary
> bad metadata [392167424, 392183808) crossing stripe boundary
> bad metadata [783482880, 783499264) crossing stripe boundary
> bad metadata [784924672, 784941056) crossing stripe boundary
> bad metadata [130151612416, 130151628800) crossing stripe boundary
> bad metadata [162826813440, 162826829824) crossing stripe boundary
> bad metadata [162927083520, 162927099904) crossing stripe boundary
> bad metadata [619740659712, 619740676096) crossing stripe boundary
> bad metadata [619781947392, 619781963776) crossing stripe boundary
> bad metadata [619795644416, 619795660800) crossing stripe boundary
> bad metadata [619816091648, 619816108032) crossing stripe boundary
> bad metadata [620011388928, 620011405312) crossing stripe boundary
> bad metadata [890992459776, 890992476160) crossing stripe boundary
> bad metadata [891022737408, 891022753792) crossing stripe boundary
> bad metadata [891101773824, 891101790208) crossing stripe boundary
> bad metadata [891301199872, 891301216256) crossing stripe boundary
> [...]
> --->8---

Normally false alert, just old btrfs-progs.
Or your fs is converted from ext*.

Update to latest btrfs-progs to see what it output now.
>
> My main drive (which this thread was about) has a huge amount of
> different problems according to btrfsck. Repair doesn't work:

Don't use --repair until you know the meaning of the error.

I just found your full fsck output, and will comment there.

Thanks,
Qu

> it says
> something about overlapping extents and that it needs a careful
> thought. I wanted to catch the output when the above problem occured. So
> I'd like to defer that until later and first fix my backup drive. If I
> lose my main drive, I simply restore from backup. It is very old anyway
> (still using 4k node size). Only downside it takes 24+ hours to restore.
>
