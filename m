Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qk0-f182.google.com ([209.85.220.182]:33184 "EHLO
	mail-qk0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752482AbcACWdH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sun, 3 Jan 2016 17:33:07 -0500
Received: by mail-qk0-f182.google.com with SMTP id p186so43078188qke.0
        for <linux-btrfs@vger.kernel.org>; Sun, 03 Jan 2016 14:33:05 -0800 (PST)
Content-Type: text/plain;
	charset=utf-8
Mime-Version: 1.0 (1.0)
Subject: Re: btrfs scrub failing
From: John Center <jlcenter15@gmail.com>
In-Reply-To: <2304914.ebMOxPbdB3@merkaba>
Date: Sun, 3 Jan 2016 17:33:03 -0500
Cc: Duncan <1i5t5.duncan@cox.net>, linux-btrfs <linux-btrfs@vger.kernel.org>
Message-Id: <650A2729-5234-4088-AF10-89D27FE9DC25@gmail.com>
References: <CAPgWCbQ9HS1N=JCbbHuT9yyTz3JPAizA+DvOAR7_GX73CVix0g@mail.gmail.com> <CAPgWCbTPMqCDx99vBXqFsCAjLzCsnxvCwFQnRfSymbD-_RssMA@mail.gmail.com> <CAPgWCbRZOT-LvECuqgbaHSKWE8mYiO5R9kvk-8BeL-9Lb85fVA@mail.gmail.com> <2304914.ebMOxPbdB3@merkaba>
To: Martin Steigerwald <martin@lichtvoll.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Martin,

One thing I forgot, I did run btrfs-image & it appears to have successfully completed afaict. Do you think it would be useful to someone for future troubleshooting?

Thanks.

    -John

Sent from my iPhone

> On Jan 3, 2016, at 5:06 AM, Martin Steigerwald <martin@lichtvoll.de> wrote:
> 
> Am Sonntag, 3. Januar 2016, 02:02:12 CET schrieb John Center:
>> Hi Martin & Duncan,
> 
> Hi John,
> 
>> Since I had a backup of my data, I first ran "btrfs check -p" on the
>> unmounted array.  It first found 3 parent transid errors:
>> 
>> root@ubuntu:~# btrfs check -p /dev/md126p2
>> Checking filesystem on /dev/md126p2
>> UUID: 9b5a6959-7df1-4455-a643-d369487d24aa
>> parent transid verify failed on 97763328 wanted 33736296 found 181864
>> ...
>> Ignoring transid failure
>> parent transid verify failed on 241287168 wanted 33554449 found 17
>> ...
>> Ignoring transid failure
>> parent transid verify failed on 1016217600 wanted 33556071 found 1639
>> ...
>> Ignoring transid failure
>> 
>> Then a huge number of bad extent mismatches:
>> 
>> bad extent [29360128, 29376512), type mismatch with chunk
>> bad extent [29376512, 29392896), type mismatch with chunk
>> ...
>> bad extent [1039947448320, 1039947464704), type mismatch with chunk
>> bad extent [1039948005376, 1039948021760), type mismatch with chunk
> 
> Due to these I recommend you redo the BTRFS filesystem using your backup. See 
> the other thread where Duncan explained the situation that this may be a sign 
> of a filesystem corruption introduced by a faulty mkfs.btrfs version.
> 
> I had this yesterday with one of my BTRFS filesystems and these type mismatch 
> things didn´t go away with btrfs check --repair from btrfs-tools 4.3.1.
> 
> Also
> 
>> Next:
>> 
>> Couldn't find free space inode 1
>> checking free space cache [o]
>> parent transid verify failed on 241287168 wanted 33554449 found 17
>> Ignoring transid failure
>> checkingunresolved ref dir 418890 index 0 namelen 15 name umq-onetouch.ko
>> filetype 1 errors 6, no dir index, no inode ref
>>    unresolved ref dir 418890 index 8 namelen 15 name ums-onetouch.ko
>> filetype 1 errors 1, no dir item
> 
> the further errors and
> 
> […]
>> Once it finished, I tried a recovery mount, which went ok.  Since I already
>> had a backup of my data, I tried to run btrfs repair:
>> […]
>> Then it got stuck on the same error as before.  It appears to be a loop:
>> 
>> parent transid verify failed on 1016217600 wanted 33556071 found 1639
>> Ignoring transid failure
>> parent transid verify failed on 1016217600 wanted 33556071 found 1639
>> Ignoring transid failure
>> ...
> […]
>> It's been running this way for over an hour now, never moving on from the
>> same errors & the same couple of files.  I'm going to let it run overnight,
>> but I don't have a lot of confidence that it will ever exit this loop.  Any
>> recommendations as what I should do next?
> 
> is a clear sign to me that it likely is more effective to just redo the 
> filesystem from scratch than trying to repair it with the limited capabilities 
> of current btrfs check command.
> 
> So when you have a good backup of your data and want to be confident of a 
> sound structure of the filesytem, redo it from scratch with latest btrfs-tools 
> 4.3.1.
> 
> Thats at least my take on this.
> 
> Thanks,
> -- 
> Martin
