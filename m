From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: btrfs-raid questions I couldn't find an answer to on the wiki
Date: Wed, 1 Feb 2012 06:59:26 +0000 (UTC)
Message-ID: <pan.2012.02.01.06.59.25@cox.net>
References: <pan.2012.01.26.15.41.32@cox.net>
	<201201291223.40161.kreijack@inwind.it>
	<COL113-W485767962008EF29E7E27EB08D0@phx.gbl>
	<pan.2012.01.31.05.55.47@cox.net>
	<COL113-DS1406F918FEA81D38635AA3B0730@phx.gbl>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Kyle Gates posted on Tue, 31 Jan 2012 18:22:51 -0600 as excerpted:

> I don't think I specifically enabled mixed chunk support when I created
> this filesystem. It was done on a 2.6 kernel sometime in the middle of
> 2011 iirc.

Yeah, I'd guess that was before mixed-chunk, or at least before it became 
the default for <=1GiB filesystems, so even if it was supported it 
wouldn't have been the default.

Meaning there's still an open question as to whether grub-1.99 supports 
mixed-chunk.

It looks like I might get more time to play with it this coming week than 
I had this past week.  I might try some of my own experiments... and 
whether grub groks mixed-chunk will certainly be among them if I do.

As for those recommending something other than btrfs for /boot, yes, 
that's a possibility, but I strongly prefer to standardize on a single 
filesystem type.  Right now, that's reiserfs for everything except flash-
based USB and legacy floppies (both of which I use ext4 without 
journaling for, except for the floppies I used to update my BIOS, before 
my 2003 era mainboard got EOLed; those were freedos images), and 
ultimately, I hope it'll be btrfs for everything including flash-based 
(tho perhaps not for legacy floppies, but it has been awhile since I used 
one of them for anything, after that last BIOS update...).

Of course I'm going to keep reiserfs on my backups, even if I use btrfs 
for my working system, for the time being since btrfs is still in heavy 
development, but ultimately, I want to go all btrfs just as I'm all 
reiserfs now, and that would include both /boot 2-spindle raid-1s.

Tho if btrfs doesn't work well for that ATM, I can keep /boot as reiserfs 
for the time being, since I'm already keeping it for the backups, for the 
time being.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

