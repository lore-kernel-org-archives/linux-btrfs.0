Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:46922 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756024AbaDHMLM (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 8 Apr 2014 08:11:12 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1WXUrt-0007eK-4x
	for linux-btrfs@vger.kernel.org; Tue, 08 Apr 2014 14:11:09 +0200
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Tue, 08 Apr 2014 14:11:09 +0200
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Tue, 08 Apr 2014 14:11:09 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: error 2001, no inode item
Date: Tue, 8 Apr 2014 12:10:56 +0000 (UTC)
Message-ID: <pan$5202e$e473aa9d$bec69d4b$f69d4a7c@cox.net>
References: <53433170.5030806@lbl.gov>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Arun Persaud posted on Mon, 07 Apr 2014 16:14:56 -0700 as excerpted:

> my HD recently started crashing, so I rescued all files to a new one and
> thought that this might be a good time to convert from ext4 to btrfs.

Welcome. =:^)  If you haven't already done so, please spend some time 
reviewing the wiki user documentation pages at

https://btrfs.wiki.kernel.org

That could save you some needless pain... including possibly two bits I 
see below, altho hopefully it's fine, and should familiarize you with 
things a bit as well.

> I
> copied all the files from my old HD using dd, converted and then resized
> the file system. However, my old drive already had some errors.

There's a page on the wiki specifically covering conversion.  Please read 
it carefully and follow the recommendations, as the post-ext4-subvolume-
delete defrag and balance it recommends can prevent problems later.

https://btrfs.wiki.kernel.org/index.php/Conversion_from_Ext3

It's /possible/ the problem you mention below is related to that, tho I 
can't say for sure.  We did have one person report later issues after NOT 
doing that defrag and rebalance, as he had some very large files, larger 
than the 1 GiB size of btrfs' data chunks, that could be read just fine 
but that gave him problems with later rebalances and conversion to btrfs 
raidX, when he tried that.  If he had done the immediate defrag and 
rebalance, either that would have fixed the problem immediately, or at 
minimum, he'd have had less ADDITIONAL files piled on to go thru when he 
DID experience the issue, later.

> Currently I have one file that I can't rm or overwrite (stale file
> handle). Here is what I get when running btrfs check:
> 
>> btrfs check /dev/sda4

[snip the output]

I'm just a user and list regular, not a dev, so some of the more 
technical output doesn't mean much to me.  I CAN however say that the 
generation mismatch, invalidating space cache, warning, is reasonably 
routine and nothing to worry about.  But the missing inode stuff will 
take someone with a bit more knowledge.

> Btrfs v3.12+20131125

FWIW, there's a new btrfs-progs v3.14 version available.  Given btrfs 
still relatively rapid development, the latest stable kernel (now 3.14.0) 
if not the development kernel (tho I recommend waiting until -rc2 or so) 
is recommended.  And the btrfs-progs master branch in git is always kept 
release-ready -- development and testing happen in other branches -- so 
that's actually recommended as well.  Btrfs-progs v3.14 (kernel version 
synced altho they sometimes skip versions -- there was no v3.13, for 
instance) was just freshly tagged a few days ago.  I build from git, so 
couldn't tell you whether there's even a tarball for it yet, but v3.14 is 
definitely available in git, and that's what I'm running here.

> the file is a git object, so that's why the name looks like a hash ;)

=:^)

>> uname -a
> Linux apersaud 3.14.0-23.gfa168d7-desktop #1 SMP PREEMPT Tue Apr 1
> 12:54:08 UTC 2014 (fa168d7) x86_64 x86_64 x86_64 GNU/Linux

Looks like you're up on the kernel, anyway. =:^)

> I'm running opensuse/Tumbleweed.

Cool.  Gentoo/~amd64 here, with upstream git versions of some packages, 
including btrfs-progs and kde4-head (not yet tried kde5/frameworks, but 
thinking about it).  So I appreciate rolling releases. =:^)

> Any idea how I can fix the above? check --repair doesn't seem to help.
> Any suggestions would be highly appreciated.
 
One more potentially critical thing that I do not believe has made it to 
the wiki yet, tho it's common knowledge on this list:

Don't run btrfs check --repair unless you're either told to do so by a 
dev after examining the errors you are seeing, or it's the last desperate 
step before you scrap the filesystem and mkfs anyway, so there's nothing 
to lose.  btrfs check --repair doesn't yet understand everything that can 
go wrong, and can sometimes make problems worse instead of better.  There 
are other options (like a balance) to try first if you have problems.  
That said, running it without the repair option is fine and can be 
informative (or not), since it's read-only without that option.  Just 
don't believe it's the end of the world if it sees errors, because it may 
simply not understand what it's seeing.

However, with a bit of luck you've not made your particular problem 
worse, and in any case, now that it's done, you can't undo it, and your 
report should help the devs make btrfs check work better than it does now.

And one more thing as a hint to save you some trouble.  Strongly consider 
both the noatime (mainly performance) and the autodefrag mount options, 
and if you have any large (gig-plus) databases or VM images (anything 
that's large and frequently internal-file rewritten, not just append-
only), they're a potential (performance and snapshotting) sore spot.  You 
might want to spend some time reading the list for how to deal with them, 
or ask, if you have that type of files to deal with.

Good luck and keep your backups current, because btrfs is still not 
entirely stable, tho it's considerably more so than it was in the past, 
and is getting very close for traditional filesystem type stuff.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

