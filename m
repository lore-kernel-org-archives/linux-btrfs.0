Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from [195.159.176.226] ([195.159.176.226]:47787 "EHLO
        blaine.gmane.org" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
        with ESMTP id S1750718AbdA1Gqn (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 28 Jan 2017 01:46:43 -0500
Received: from list by blaine.gmane.org with local (Exim 4.84_2)
        (envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
        id 1cXMmB-0001xb-Et
        for linux-btrfs@vger.kernel.org; Sat, 28 Jan 2017 07:46:19 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: File system is oddly full after kernel upgrade, balance doesn't
 help
Date: Sat, 28 Jan 2017 06:46:10 +0000 (UTC)
Message-ID: <pan$bea71$c88f268f$3fe2f55a$caf61eb5@cox.net>
References: <CAE8gLhk=Gf7Qejs6zit+hGdFNeNSPexJZ=jgCY1CADt6xoNHhA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

MegaBrutal posted on Fri, 27 Jan 2017 19:45:00 +0100 as excerpted:

> Hi,
> 
> Not sure if it caused by the upgrade, but I only encountered this
> problem after I upgraded to Ubuntu Yakkety, which comes with a 4.8
> kernel.
> Linux vmhost 4.8.0-34-generic #36-Ubuntu SMP Wed Dec 21 17:24:18 UTC
> 2016 x86_64 x86_64 x86_64 GNU/Linux
> 
> This is the 2nd file system which showed these symptoms, so I thought
> it's more than happenstance. I don't remember what I did with the first
> one, but I somehow managed to fix it with balance, if I remember
> correctly, but it doesn't help with this one.
> 
> FS state before any attempts to fix:
> Filesystem      1M-blocks   Used Available Use% Mounted on
> [...]curlybrace      1024   1024         0 100% /tmp/mnt/curlybrace
> 
> Resized LV, run „btrfs filesystem resize max /tmp/mnt/curlybrace”:
> [...]curlybrace      2048   1303         0 100% /tmp/mnt/curlybrace
> 
> Notice how the usage magically jumped up to 1303 MB, and despite the FS
> size is 2048 MB, the usage is still displayed as 100%.
> 
> Tried full balance (other options with -dusage had no result):
> root@vmhost:~# btrfs balance start -v /tmp/mnt/curlybrace

> Starting balance without any filters.
> ERROR: error during balancing '/tmp/mnt/curlybrace':
> No space left on device

> No space left on device? How?
> 
> But it changed the situation:
> [...]curlybrace      2048   1302       190  88% /tmp/mnt/curlybrace
> 
> This is still not acceptable. I need to recover at least 50% free space
> (since I increased the FS to the double).
> 
> A 2nd balance attempt resulted in this:
> [...]curlybrace      2048   1302       162  89% /tmp/mnt/curlybrace
> 
> So... it became slightly worse.
> 
> What's going on? How can I fix the file system to show real data?

Something seems off, yes, but...

https://btrfs.wiki.kernel.org/index.php/FAQ

Reading the whole thing will likely be useful, but especially 1.3/1.4 and 
4.6-4.9 discussing the problem of space usage, reporting, and (primarily 
in some of the other space related FAQs beyond the specific ones above) 
how to try and fix it when space runes out, on btrfs.

If you read them before, read them again, because you didn't post the 
btrfs free-space reports covered in 4.7, instead posting what appears to 
be the standard (non-btrfs) df report, which for all the reasons 
explained in the FAQ, is at best only an estimate on btrfs.  That 
estimate is obviously behaving unexpectedly in your case, but without the 
btrfs specific reports, it's nigh impossible to even guess with any 
chance at accuracy what's going on, or how to fix it.

A WAG would be that part of the problem might be that you were into 
global reserve before the resize, so after the filesystem got more space 
to use, the first thing it did was unload that global reserve usage, 
thereby immediately upping apparent usage.  That might explain that 
initial jump in usage after the resize.  But that's just a WAG.  Without 
at least btrfs filesystem usage, or btrfs filesystem df plus btrfs 
filesystem show, from before the resize, after, and before and after the 
balances, a WAG is what it remains.  And again, without those reports, 
there's no way to say whether balance can be expected to help, or not.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

