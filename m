Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:49843 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751053AbbLMGvO (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 13 Dec 2015 01:51:14 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
	id 1a80Uy-0004aO-HY
	for linux-btrfs@vger.kernel.org; Sun, 13 Dec 2015 07:51:12 +0100
Received: from ip98-167-165-199.ph.ph.cox.net ([98.167.165.199])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sun, 13 Dec 2015 07:51:12 +0100
Received: from 1i5t5.duncan by ip98-167-165-199.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sun, 13 Dec 2015 07:51:12 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: Will "btrfs check --repair" fix the mounting problem?
Date: Sun, 13 Dec 2015 06:51:07 +0000 (UTC)
Message-ID: <pan$b4f0c$bec57257$c0c1d11d$1f0adfb3@cox.net>
References: <566b0cff.pXiyzYE4dYIOt31+%sivan606@gmail.com>
	<CAJCQCtTLrGin24rFGdvYV-JcegEgGEE7qK3gAYSd8K_SXFeu=g@mail.gmail.com>
	<CAMG9ccx6ahFfnsq3DHUzemYjQwuTHD46nL1SqPsjeDNL4KTRWg@mail.gmail.com>
	<CAJCQCtTckg3dA-YiswCHGo0rH7UQtObLCHb=H=mERG256SdjyQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Chris Murphy posted on Sat, 12 Dec 2015 13:16:41 -0700 as excerpted:

> On Sat, Dec 12, 2015 at 3:34 AM, Ivan Sizov <sivan606@gmail.com> wrote:
>> 2015-12-11 21:24 GMT+03:00 Chris Murphy <lists@colorremedies.com>:
>>> I would not repair it if the risk of it getting worse is bad for your
>>> data.
>>>
>>> Note the wiki says this feature is not well tested and is reported to
>>> not work reliably.
>>> https://btrfs.wiki.kernel.org/index.php/Conversion_from_Ext3
>>>
>>> Qu is working on patches to fix some of these problems, I don't know
>>> the status of any of that. I just did a conversion myself the other
>>> day with kernel 4.4.0rc3 and btrfs-progs 4.3.1 and that worked without
>>> error. But there were also no big files at all (it was just a clean OS
>>> installation). I immediately took a snapshot of that, and btrfs
>>> send/receive it to a new Btrfs volume, and then discarded the
>>> converted one entirely.
>>>
>>> The trace looks like it's mounting read-only? If it can be mounted
>>> read only, get the important data off the volume if it's not already
>>> backed up, and then blow it away. I personally wouldn't bother with
>>> repairing it.
>>
>> What is the better way to get data? send/receive works only with RO
>> snapshots. Is there another way to preserve subvolumes and CoW
>> structure (a lot of files was copied between subvols using "cp
>> --reflink=always")? Or just rsync'ing files is all what I can do?
> 
> cp -a or rsync -a is all I can think of. To start to get it back to
> normal, you can use duperemove. While that doesn't create subvolumes,
> it'll at least find duplicate extents and use reflinks for those. So
> it's in effect the same thing you have now, just lacking the subvolume
> structure.

I can also suggest btrfs restore, on the /unmounted/ btrfs, to get data 
off it to some other normally mounted filesystem (btrfs or other).

Note that it has options for subvolume restore or not, metadata restore 
or not, restore by path regex... some reasonably advanced stuff.  It's 
designed for use when the filesystem won't mount at all, but it can even 
be used on a healthy btrfs, as long as it is unmounted.

I've not used the restore subvolume functionality at all as my use-case 
doesn't involve subvolumes, but between that and the path-regex options, 
it should be possible to restore from subvolumes separately, altho as 
normal files in normal subdirs, since it's designed to restore to other 
filesystems as well as to btrfs.

And if the damage is mostly in subvolumes, it's very possible you can 
restore the data from more of them than you could otherwise access 
without crashing the filesystem and possibly the system, since restore 
works from userspace on an unmounted filesystem and thus should at least 
not have as high a risk of taking the entire system down when it hits 
those errors, as operating on a mounted filesystem could do due to 
triggering the error in kernelspace.

No it won't get you the subvolume structure on the restore-to 
destination, so it's not /too/ much better than cp -a or rsync -a, but if 
those end up crashing without restoring what you want, restore just might 
get you more of that otherwise inaccessible due to crashes, data, 
including what's on the subvolumes if you want it.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

