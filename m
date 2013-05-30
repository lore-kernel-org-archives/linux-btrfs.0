Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from amber.ccs.neu.edu ([129.10.116.51]:51743 "EHLO
	amber.ccs.neu.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754244Ab3E3SaP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 30 May 2013 14:30:15 -0400
References: <10857957.2218421369882515345.JavaMail.root@zimbra> <23702077.2218441369882531514.JavaMail.root@zimbra> <20130530125238.GB9829@localhost.localdomain>
Mime-Version: 1.0 (1.0)
In-Reply-To: <20130530125238.GB9829@localhost.localdomain>
Content-Type: text/plain;
	charset=us-ascii
Message-Id: <89612378-A290-48E6-B558-EAF933ECE166@ccs.neu.edu>
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
From: Alex Marquez <nam@ccs.neu.edu>
Subject: Re: Btrfs metadata corruption; unmountable FS
Date: Thu, 30 May 2013 14:30:07 -0400
To: Josef Bacik <jbacik@fusionio.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Oh, I see... Well at least now I know. Thanks!

I'll probably go for the "safer" route of using 3.10... Though I'd like to know how stable the current RC is wrt btrfs, if instead I should wait for the release.

~Alex

On May 30, 2013, at 8:52 AM, Josef Bacik <jbacik@fusionio.com> wrote:

> On Wed, May 29, 2013 at 08:55:31PM -0600, Alex Marquez wrote:
>> I'm not entirely sure what went completely wrong.  Three possibilities are most likely, and they're listed below.
>> For reference, here are supplemental materials split out into their own pastebins:
>> * btrfs-debug-tree -R log http://pastebin.com/7ePy9sin
>> * dmesg log http://pastebin.com/s1sdJRyd
>> (btrfs tools are git head)
>> Mounting with "recovery,ro" is no use.
>> I've also taken a metadata dump with btrfs-image, though it completed with errors, so the dump may be incomplete.  It's also 5 GBs, but I'm more than willing to make it publicly downloadable if it would help the cause.
>> 
>> ************** 1
>> Firstly, I have a raid1 (and, as I'll explain, partially raid10) array of 8 raw drives.  A couple experience a controller error every once in a while.  So it /may/ be the case that the hardware itself caused this problem, but I find it less likely than the following other two possibilities.  (However, in part 3's log there is some mention of sdf giving IO errors...)
>> 
>> ************** 2
>> A couple of months ago I was doing a balance, trying to convert from raid10 to raid1.  At the time, it was on the 3.6 kernel.
>> 
>> I kept getting enospc errors (even with plenty of space), so I went from doing a soft conversion to a hard one.  Of course, in the process my server was hard-rebooted by accident.  When back online, I used btrfsck and it showed a bunch of extent vs. csum problems, which I used --repair to attempt to deal with. 
>> 
>> Though I can't recall the problems exactly, I do remember that it triggered an odd check regarding csums existing for extents that were freed.
>> The commit which introduced this printf was https://git.kernel.org/cgit/linux/kernel/git/mason/btrfs-progs.git/commit/?id=580ccf9e2ef4607f5b67b531190e7842c4b2b0db
>> 
>> Since then, every once in a while I would do another balance (sometimes soft, sometimes hard) in an attempt to complete the conversion -- to no avail, but seemingly to no harm.
>> 
>> ************** 3
>> Now, 2 weeks ago I (foolishly) thought I'd try the new skinny extents feature (mistaking it as available in 3.9) in order to see if it might alleviate the issues I've had with trying to finish that conversion.  I enabled it via btrfstune, but quickly noted that my 3.9 kernel wouldn't mount the filesystem anymore (because of the incompatible feature).
>> 
>> However, nothing had changed on-disk (given I wasn't running 3.10) but the flag...  So I looked into clearing that flag, but btrfstune provided me no recourse.  So I did something very dangerous and foolish:  I went into btrfstune.c and changed the setting of the flag to clear the flag instead, then reran it.  I mounted again, fingers crossed, and lo and behold, it was fine!
>> 
>> Unfortunately, after some use, the filesystem failed and went read-only.  That's when I got scared and decided it was time to stop trying to fix things myself (of course, far too late).
>> 
>> The actual log is at http://pastebin.com/s1sdJRyd
>> On line 85 you can see where I tried to mount it
>> Line 87 is where I remounted after my btrfstune hack
> 
> May 17 18:13:25 norman kernel: [ 1677.876008]   item 1 key (51401449938944 a9 0) itemoff 3911 itemsize 33
> 
> So it did actually get a skinny extent in there, thats the skinny extent item
> key.  You'll have to reset the flag and move to btrfs-next/3.10.  Seems like you
> are smart enough to do basic things so if don't like that option you can just
> fix btrfsck to go through and delete any extent entry that has
> BTRFS_METADATA_ITEM_KEY and then --repair should put them back normally.  If you
> want to do option #2 you don't need to reset the flag, leave it unset and then
> add a function to cmds-check.c right before check_extents() and have it just go
> through the extent tree and delete any entries with that key, and then
> check_extents() will take care of the rest.  This is a bit dangerous though so
> I'd really recommend option #1.  Thanks,
> 
> Josef
