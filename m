Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:48607 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751263AbbEFLEs (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 6 May 2015 07:04:48 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1Ypx8A-0005o8-MK
	for linux-btrfs@vger.kernel.org; Wed, 06 May 2015 13:04:46 +0200
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Wed, 06 May 2015 13:04:46 +0200
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Wed, 06 May 2015 13:04:46 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: 3.19.6: __btrfs_free_extent:5987: errno=-2 No such entry, did
 btrfs check --repair break it?
Date: Wed, 6 May 2015 11:04:41 +0000 (UTC)
Message-ID: <pan$a2a67$3e7e2090$a73a1a0d$778571d0@cox.net>
References: <4306bc25fe19b7dd623c8e724292d7bb@admin.virtall.com>
	<1409745869.21602.21.camel@localhost> <20140824000720.GN3875@merlins.org>
	<20140926214821.GX13219@merlins.org> <20150502141102.GB1809@merlins.org>
	<20150501210013.GH13624@merlins.org> <20150429232130.GA23814@merlins.org>
	<20150502163010.GK13624@merlins.org> <20150505063215.GA28387@merlins.org>
	<20150505195610.GE23216@merlins.org> <20150505210209.GG23216@merlins.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Marc MERLIN posted on Tue, 05 May 2015 14:02:09 -0700 as excerpted:

> Please let me know what I can do for you if anything, before I wipe the
> filesystem and recreate it (I'm assuming that running btrfs check
> --repair a 2nd time won't help).

FWIW... I had a second /similar/ case here, but I didn't report it, as I 
thought it related to a relocated-sector count bump I saw on one of the 
ssds at about the same time.  My case may well have indeed been relocated-
sector-triggered, but reading your case, it's similar enough that I 
thought I'd mention it.

Like you I noticed a problem that didn't seem to have too much real-world 
effect, in my case, simply an apparently empty directory that would 
trigger a "directory not empty" error on attempt to delete.  Having read 
about others having such problems, I immediately used their solution, 
simply rename the directory out of the way, for the time being, after 
which it didn't seem to cause any harm, just annoyance as I still 
couldn't delete it.

But, with scrub fixing a couple corruptions and further scrubs finding 
nothing more, yet I still couldn't delete the dir, again like you, I 
decided to try a btrfs check, first read-only, which reported a few 
problems (which I didn't save), then with --repair, which /seemed/ to 
work just fine.

And finally, like you, a few hours later, actually in my case after a 
shutdown and reboot with successful error-free remount... suddenly that 
filesystem went read-only!

That's the end of the similarities, but as you can see, they're striking 
enough to think it might be the same issue (1) relatively minor initial 
problem, (2) btrfs check --repair apparently fixes it, (3) a few hours 
later the filesystem goes read-only, and immediate efforts to fix it fail.

What follows is how I recovered...

Well, I have my system on multiple independent btrfs for a reason, and 
that was /home, with / a totally independent btrfs mounted read-only by 
default, and mounted read-only at the time.

So I quit X and logged out of my normal user, logged in as root at the 
CLI, did a systemctl emergency to stop all normal services, and a
umount -a to unmount all filesystems that could unmount.

Then I went to work trying to fix the bad btrfs, still running from the 
unaffected read-only /, of course.

Long story short, nothing I tried (mounting with recovery, the new 
integrated btrfs rescue zero-log, btrfs check --repair...) seemed to fix 
it.  =:^(  So I got to use the new btrfs-progs v4.0 metadata-restoration 
option in btrfs restore, updating my previous btrfs restore experience 
from nearly a year ago. =:^)

The good news: btrfs restore worked without having to do the manual find-
root thing, and the metadata-restore options are very nice indeed!  I 
seem to have gotten my files back, and didn't have to resort to my backup
(which was out of date, but I'd have used it and been happy if I had to, 
I just didn't have to). =:^)

The bad news: restore's dry-run option doesn't work well with metadata-
restore, giving metadata unavailable errors on the dry-run that aren't 
there on an actual write-it-out restore.  Also, the old too many loops on 
the same dir warning and abort, no longer affects a write-out run, but 
still affects a dry-run.  So the dry-run provides /some/ idea what you'll 
get, but it's not really an accurate literal dry-run, going thru all the 
motions but effectively /dev/nulling the output.  =:^(

Also, I guess the symlink restore patch didn't make it in time for progs 
4.0.  Hopefully for 4.0.1 or at least 4.1...  So my symlinks weren't 
restored and I still had to recreate them manually.  But the experience 
was markedly better than last year, since I didn't have to: (1) rerun 
restore repeatedly until I no longer got the looping errors, (2) manually 
fix ownership/perms.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

