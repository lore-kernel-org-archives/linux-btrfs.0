Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:59765 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932187AbaKMIta (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 13 Nov 2014 03:49:30 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1Xoq5o-00013r-7Q
	for linux-btrfs@vger.kernel.org; Thu, 13 Nov 2014 09:49:28 +0100
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Thu, 13 Nov 2014 09:49:28 +0100
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Thu, 13 Nov 2014 09:49:28 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: BTRFS Raid5/6 Recovery Problem after accidentially hibernation
Date: Thu, 13 Nov 2014 08:49:12 +0000 (UTC)
Message-ID: <pan$c311$b2fd7185$d23e610e$c84330fe@cox.net>
References: <5461EF65.4040206@automatix.de>
	<pan$9e48b$dee08040$a812fe40$6995150@cox.net>
	<54639860.7030206@automatix.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Juergen Sauer posted on Wed, 12 Nov 2014 18:26:56 +0100 as excerpted:

> Current Status:
> # root@pc6:~# btrfs fi show /dev/sda1
> # parent transid verify failed on 209362944 wanted 293924 found 293922
> # parent transid verify failed on 209362944 wanted 293924 found 293922

> What does "parent transid verify failed on 209362944 wanted 293924 found
> 293922" really mean?


The wanted 293924 found 293922 bit is simple enough, once you understand 
what it's doing.

The basis of it is this:  Every full btrfs commit, all the way up to the 
root node, is called a generation.  These are sequential, counting 
upward, with transaction ID or transid being another term meaning exactly 
the same thing as generation number.  You'll see the two terms used 
interchangeably in btrfs documentation and log output.

So what that's saying is that it wanted transid/generation 293924, but 
what it found was from two commit transactions earlier, 293922.

I believe the 209362944 is the bytenr, basically the address in the 
filesystem.

You can use btrfs-show-super to see what the value of the current root 
generation as stored in the superblocks, thus getting some idea how far 
back this damage appears to be taking you.  With commits every 30 seconds 
by default if there's data being written, going back two commits as the 
above seems to indicate isn't bad.  If it's going back a few thousand, 
things begin to look much worse.

The Restore wiki page might be of some help at this point.  It discusses 
find-root (now btrfs-find-root I believe) as well, which can be used to 
see what's going on with these root generations and if the one is 
corrupt, to find a usable earlier generation.  Note that while general 
idea remains, the way the tools work and what they output has changed a 
bit from when it was written.

https://btrfs.wiki.kernel.org/index.php/Restore

As covered on that page, what restore does is let you attempt to retrieve 
files off an unmounted filesystem that's too damaged to mount read-only 
and copy them off properly.  The files are restored to another (mounted) 
filesystem, which does mean you need enough room on this other filesystem 
in ordered to store them.  If the current root is corrupted beyond help, 
you can go back in time to previous roots, trying to find a good one, 
using the output from find-root.

As NOT covered or not covered well on that page, partly because it's 
outdated and some of this didn't exist when it was written...

1) Restore's -D|--dry-run option can be very helpful, giving you some 
idea of how many files it looks like it can restore when pointed at a 
particular root.

2) The -l option, list tree roots, is also very helpful.  This is the way 
you actually see those filesystem trees that the wiki page discusses, 
saying pick the latest tree root with all or most filesystem trees 
available -- this is how you see what's available!  (This part was quite 
confusing to me when I was trying to use the page, until I discovered the 
-l option.  Then it all made sense!)

3) Be aware, when the files are restored, you do get your file data, but 
they're written to the new location using the user (root) you're doing 
the recovery as, using standard umask permissions.  So you lose ownership 
and permissions metadata on all restored files, and will need to go thru 
and change it back to what you want/need, as necessary.

(Luckily when I did it, I had a backup; it just wasn't current.  So I was 
able to quickly hack up a script that used a for loop to match all the 
restored filenames against those in the backup, and if they matched, do a 
chown and a chmod using the backup file as a reference.  So the only ones 
I had to correct manually were the new ones that weren't in the backup.)

4) Similarly, when I did my restore, no symlinks were restored at all.  I 
had to recreate them manually, and I do make fair use of symlinks, so I 
had a fair number to recreate manually, and a somewhat broken setup until 
I got all the ones I normally use recreated.

5) A different user reported that when he used restore some time ago, he 
lost his real small files, too.  He believed restore only restored files 
that actually had extent data, while btrfs folds really small files (a 
few KiB max, the exact size limit depends on certain variables set at 
filesystem creation) directly into the metadata so they don't actually 
have data extents.  However, I didn't see any of that on my restore, so 
either it has been fixed, or perhaps one of my mount options (autodefrag 
or compress=lzo, most likely) saved me, or perhaps I simply didn't notice 
them, tho I doubt that as I think many of the smallest files would have 
been config files and I customize heavily, and didn't notice missing 
settings afterward.

6) On large directories, the restore will think it got caught in a loop.  
Back a few kernel and userspace cycles ago when I did my restore, it 
would just bail out at that point, and I had to redo the same restore 
command several times, writing to the same location (without overwrites), 
in ordered to get all files.  When I stopped seeing that error and it 
wouldn't restore any more files I knew I had what I was going to get.  
However, I think the behavior is changed now, and it simply asks if it 
should continue or not, instead of bailing out without asking, now.  
There's supposed to be an option to tell it to just keep continuing, 
instead of asking every few minutes, as well, tho I've not actually used 
it so I don't know how it ends up working in practice.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

