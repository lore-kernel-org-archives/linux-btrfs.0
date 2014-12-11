Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-yk0-f181.google.com ([209.85.160.181]:62476 "EHLO
	mail-yk0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932600AbaLKJzV (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 11 Dec 2014 04:55:21 -0500
Received: by mail-yk0-f181.google.com with SMTP id 142so2023548ykq.40
        for <linux-btrfs@vger.kernel.org>; Thu, 11 Dec 2014 01:55:20 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <548958FE.7090607@pobox.com>
References: <CAA7pwKNH-Cbd+_D+sCEJxxdervLC=_3_AzaywSE3mXi8MLydxw@mail.gmail.com>
	<20141122222606.GO8916@merlins.org>
	<CAA7pwKOSbdxaiN=_ERSQLnoPNBfO0cyzamuv=xsWtvpro-+JJg@mail.gmail.com>
	<20141123000503.GQ32735@carfax.org.uk>
	<20141123010742.GA16599@merlins.org>
	<pan$5df6$ab571fd5$d428faeb$f4fcc034@cox.net>
	<CAA7pwKOAvTNAprN+pebZ3Qow-U2SBjLP_XbVXcVKY4NeFS_qRQ@mail.gmail.com>
	<pan$1cbab$ed4a0087$b6b58a81$490b38ad@cox.net>
	<CAA7pwKNPV3PCLP3s_MzoMG2da6Rfsy9HM=b8o8u87QqDV5WB+w@mail.gmail.com>
	<CAA7pwKOtOeCL-40EjqmEZ=NR=7Nfz_1Kzx2X4O105ndKGJMkrA@mail.gmail.com>
	<54878210.8030807@pobox.com>
	<CAA7pwKPYwq73m4j-1-rf+-2owEvrDAaUJgxrGaY9uLm16Gs__Q@mail.gmail.com>
	<548839EE.6080404@pobox.com>
	<CAA7pwKMsHdbKLz77kFKYD7cymOwpWL42kqzOU8cb3LEyJ0PDSg@mail.gmail.com>
	<548958FE.7090607@pobox.com>
Date: Thu, 11 Dec 2014 10:55:20 +0100
Message-ID: <CAA7pwKOMqTmSDDB_whOzKK3d092sumB_FN_LcRAVuc=wfKR9Cw@mail.gmail.com>
Subject: Re: Fixing Btrfs Filesystem Full Problems typo?
From: Patrik Lundquist <patrik.lundquist@gmail.com>
To: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 11 December 2014 at 09:42, Robert White <rwhite@pobox.com> wrote:
> On 12/10/2014 05:36 AM, Patrik Lundquist wrote:
>>
>> On 10 December 2014 at 13:17, Robert White <rwhite@pobox.com> wrote:
>>>
>>> On 12/09/2014 11:19 PM, Patrik Lundquist wrote:
>>>>
>>>>
>>> BUT FIRST UNDERSTAND: you do _not_ need to balance a newly converted
>>> filesystem. That is, the recommended balance (and recursive defrag) is
>>> _not_
>>> a useability issue, its an efficiency issue.
>>
>>
>> But if I can't start with an efficient filesystem I'd rather start
>> over now/soon. I intend to add four more old disks for a RAID1 and it
>> will be problematic to start over later on (I'd have to buy new, large
>> disks).
>
>
> Nope, not an issue.
>
> When you add the space and rebalance with the conversions by adding all
> those other disks and such it will _completely_ _obliterate_ the current
> balance.

But if the issue is too large extents, why would they fit on any added
btrfs space?


> You are cleaning the house before the maid comes.

Indeed, as a health check. And the patient is slightly ill.


> If you are going to add four more volumes, if those volumes are big enough
> just make a new filesystem on them then copy the files over.

As it looks now, I will, but I also think there's a bug which I'm
trying to zero in on.


>> I deleted the subvolume after being satisfied with the conversion,
>> defragged recursively, and balanced. In that order.
>
> Yea, but your file system is full and you are out of space so get on with
> the adding space.

I don't think it is full. balance -musage=100 -dusage=99 completes
with ~1.5TB free space. The remaining unbalanced data is using full or
close to full blocks. Still can't speak for contiguous space though.


> (looking back through my mail spool) You haven't sent the output of /bin/df
> or btrfs fi df yet, I'd like to see what those two commands say.

I have posted these before, but not /bin/df (no access at the moment).

btrfs fi show
Label: none  uuid: 770fe01d-6a45-42b9-912e-
e8f8b413f6a4
    Total devices 1 FS bytes used 1.35TiB
    devid    1 size 2.73TiB used 1.36TiB path /dev/sdc1


btrfs fi df /mnt
Data, single: total=1.35TiB, used=1.35TiB
System, single: total=32.00MiB, used=112.00KiB
Metadata, single: total=3.00GiB, used=1.55GiB
GlobalReserve, single: total=512.00MiB, used=0.00B


btrfs check /dev/sdc1
Checking filesystem on /dev/sdc1
UUID: 770fe01d-6a45-42b9-912e-e8f8b413f6a4
found 825003219475 bytes used err is 0
total csum bytes: 1452612464
total tree bytes: 1669943296
total fs tree bytes: 39600128
total extent tree bytes: 52903936
btree space waste bytes: 79921034
file data blocks allocated: 1487627730944
 referenced 1487627730944



>>> This would
>>> be quadruply true if you'd tweaked the block group ratios when you made
>>> the original file system.
>>
>> Ext4 created with defaults, but I think it has been completely full at one
>> time.
>
> Did you use e4defrag before you did the conversion or is this the result of
> converting chaos most profound?

Didn't use e4defrag.



>>> Think of the time and worry you'd have saved if you'd copied the thing in
>>> the first place. 8-)
>>
>> But then I wouldn't learn as much. :-)
>
> Learning not to cut corners is a lesson... 8-)

This is more of an experiment than cutting corners, but yeah.


> TRUTH BE TOLD :: After two very "eventful" conversions not too long ago I
> just don't do those any more. The total amount of time I "saved" by not
> copying the files was in the negative numbers before I just copied the files
> onto an external media and reformatted and restored.

Conversion probably should be discouraged on the wiki then.


> It's like a choose-your-own-adventure book! 8-)

I like that! :-)
