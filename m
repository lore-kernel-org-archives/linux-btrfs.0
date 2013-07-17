Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-vc0-f176.google.com ([209.85.220.176]:64779 "EHLO
	mail-vc0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934600Ab3GQXB1 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 17 Jul 2013 19:01:27 -0400
Received: by mail-vc0-f176.google.com with SMTP id ha12so1808698vcb.21
        for <linux-btrfs@vger.kernel.org>; Wed, 17 Jul 2013 16:01:26 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <51E7044C.2030805@giantdisaster.de>
References: <CABZ+qqnM4g9H1d4dCw9Ao3Kj7tKGJ7M1_oPkGjFKcheMrD=HMQ@mail.gmail.com>
	<CABZ+qqmm4X7FEWr=BuPwF_uPJ8Rdg9Le3d-iLnYfB+if3N-mzQ@mail.gmail.com>
	<51E7044C.2030805@giantdisaster.de>
Date: Thu, 18 Jul 2013 09:01:26 +1000
Message-ID: <CA+WRLO98iTCTSXLR5UqHY+8Az8BEdHsu=QbmNgGwfwF76bfdLw@mail.gmail.com>
Subject: Re: unfinished convert to raid6, enospc
From: Gareth Pye <gareth@cerberos.id.au>
To: Stefan Behrens <sbehrens@giantdisaster.de>
Cc: Dan van der Ster <dan@vanderster.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

So I'm reading:

* Progs support for parity rebuild.  Missing drives upset the progs
today, but the kernel does rebuild parity properly.


wrong? As that sounds like the programs will bork but it can be
mounted and it'll rebuild.

On Thu, Jul 18, 2013 at 6:53 AM, Stefan Behrens
<sbehrens@giantdisaster.de> wrote:
> On 07/17/2013 21:56, Dan van der Ster wrote:
>>
>> Well, I'm trying a balance again with -dconvert=raid6 -dusage=5 this
>> time. Will report back...
>>
>> On Wed, Jul 17, 2013 at 3:34 PM, Dan van der Ster <dan@vanderster.com>
>> wrote:
>>>
>>> Hi,
>>> Two days ago I decided to throw caution to the wind and convert my
>>> raid1 array to raid6, for the space and redundancy benefits. I did
>>>
>>> # btrfs fi balance start -dconvert=raid6 /media/btrfs
>>>
>>> Eventually today the balance finished, but the conversion to raid6 was
>>> incomplete:
>>>
>>> # btrfs fi df /media/btrfs
>>> Data, RAID1: total=693.00GB, used=690.47GB
>>> Data, RAID6: total=6.36TB, used=4.35TB
>>> System, RAID1: total=32.00MB, used=1008.00KB
>>> System: total=4.00MB, used=0.00
>>> Metadata, RAID1: total=8.00GB, used=6.04GB
>>>
>>> A recent btrfs balance status (before finishing) said:
>>>
>>> # btrfs balance status /media/btrfs
>>> Balance on '/media/btrfs' is running
>>> 4289 out of about 5208 chunks balanced (4988 considered),  18% left
>>>
>>> and at the end I have:
>>>
>>> [164935.053643] btrfs: 693 enospc errors during balance
>>>
>>> Here is the array:
>>>
>>> # btrfs fi show /dev/sdb
>>> Label: none  uuid: 743135d0-d1f5-4695-9f32-e682537749cf
>>> Total devices 7 FS bytes used 5.04TB
>>> devid    2 size 2.73TB used 2.73TB path /dev/sdh
>>> devid    1 size 2.73TB used 2.73TB path /dev/sdg
>>> devid    5 size 1.36TB used 1.31TB path /dev/sde
>>> devid    6 size 1.36TB used 1.31TB path /dev/sdf
>>> devid    4 size 1.82TB used 1.82TB path /dev/sdd
>>> devid    3 size 1.82TB used 1.82TB path /dev/sdc
>>> devid    7 size 1.82TB used 1.82TB path /dev/sdb
>>>
>>>
>>> I'm running latest stable, plus the patch "free csums when we're done
>>> scrubbing an extent" (otherwise I get OOM when scrubbing).
>>>
>>> # uname -a
>>> Linux dvanders-webserver 3.10.1+ #1 SMP Mon Jul 15 17:07:19 CEST 2013
>>> x86_64 x86_64 x86_64 GNU/Linux
>>>
>>> I still have plenty of free space:
>>>
>>> # df -h /media/btrfs
>>> Filesystem      Size  Used Avail Use% Mounted on
>>> /dev/sdd         14T  5.8T  2.2T  74% /media/btrfs
>>>
>>> Any idea how I can get out of this? Thanks!
>
>
> You know the limitations of the current Btrfs RAID5/6 implementation, don't
> you? No protection against power loss or disk failures. No support for
> scrub. These limits are explained very explicitly in the commit message:
>
> http://lwn.net/Articles/536038/
>
> I'd recommend Btrfs RAID1 for the time being.
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



-- 
Gareth Pye
Level 2 Judge, Melbourne, Australia
Australian MTG Forum: mtgau.com
gareth@cerberos.id.au - www.rockpaperdynamite.wordpress.com
"Dear God, I would like to file a bug report"
