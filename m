Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:51989 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752369AbbELGeD (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 12 May 2015 02:34:03 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1Ys3lQ-0000Ls-Sl
	for linux-btrfs@vger.kernel.org; Tue, 12 May 2015 08:34:01 +0200
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Tue, 12 May 2015 08:34:00 +0200
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Tue, 12 May 2015 08:34:00 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: Kernel Dump scanning directory
Date: Tue, 12 May 2015 06:33:55 +0000 (UTC)
Message-ID: <pan$ba5ab$7425ee79$be56580$95eebd8d@cox.net>
References: <C42E48E9-4DA9-442D-8FAC-B1982EA5DF4B@plack.net>
	<4B045A3B-60E2-4151-86E7-029E79585886@plack.net>
	<60DA4BA3-C4FE-4A61-9D5C-399122FA2B96@plack.net>
	<EAC2F414-3D41-4458-9AF4-8533B1925C96@plack.net>
	<20150508211850.GN18480@carfax.org.uk>
	<A54EAF29-BF4C-4CCA-BFBF-FEDFF2A01C73@plack.net>
	<20150508223723.GO18480@carfax.org.uk>
	<0C98D842-9A04-4267-B3E3-B8C65DB756D0@plack.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Anthony Plack posted on Mon, 11 May 2015 12:30:40 -0500 as excerpted:

> So the transaction has failed, and therefore the drive is in an unknown
> state, but at some point, we need to make a decision about that
> transaction.
> 
> Either we:
> 1. Accept fact that the transaction has failed, revert the data back to
> the earlier stated, and continue.
> 2. Backup the entire data set, and reset the transaction log
> 3. Flush the disk, recreate from scratch and hope our backup
> is good and current.
> 4. ????

FWIW, 4 would be btrfs restore, offline-restore any files that can be 
read from the unmounted filesystem, to some other mounted (not necessary 
btrfs) filesystem of sufficient size to contain them, using btrfs-find-
root if restore can't find a good root to work with on its own.

I've used that a couple times, a year or so apart, when one of my btrfs 
crapped out.  I have backups, as by definition anyone has if they value 
the data more than the (relatively trivial) time necessary to do the 
backup (if they don't, by definition they don't value the data to that 
level, regardless of what they claim), but they aren't always current -- 
the risk of total loss that restore can't deal with is low enough that by 
definition based on my behavior, I don't consider the incremental risk 
worth the hassle, and am willing to take the relatively low risk of 
having to fall back to relatively old backups, if restore won't do it for 
me.

Luckily, I keep relatively small btrfs (all on SSD), with my much larger 
media partition reiserfs on spinning rust, and I can mount it and use a 
subdir there as a destination for the restored files.

But btrfs restore... isn't exactly non-tech-user friendly... and it 
/does/ require someplace to restore all those files to, thus at least 
doubling the effective space requirements. =:^(

> Regardless, I still don't get not handling the error.  Yes, there is an
> error.  All fsck programs have to deal with errors.  btrfsck just ends.
> No repair, no options.
> 
> It seems that in BTRFS we just crash.  The transaction has an error,
> well dump the kernel and set the volume to read only.  There is no
> repair tool to help the user make these decisions. There isn't even a
> good explanation other than -5 kernel dump.
> 
> "Just recreate the volume from scratch and restore you backup is all we
> can do" does not seem to be a long term viable solution.
> 
> If the code understands enough to know that the transaction is damaged,
> why can the code not walk the admin through the repair?  It seems that
> we need to get to that point before we can even call this a viable beta
> file system.

Too bad.  I agree, but the warnings are removed and despite all the 
evidence to the contrary, forget about beta, btrfs is being billed as 
stable and ready for ordinary use, even shipping as the default in 
mainstream distros, these days. =:^(

Yes, btrfs is very nice for the tech-and-admin-literate user to play 
with, and in the hands of someone who can manage a restore with btrfs-
find-root and/or is an absolutely perfectly programmed robot with the 
backups, it's extremely powerful and stable /enough/, but stable for the 
masses... hardly.

> If I understood more of the transaction issue, I might just write the
> code to help btrfsck actually become a real program regarding
> transactions. Maybe that is where I need to start...

Given what I've seen restore able to do, perhaps looking at how it 
handles this sort of issue and coding a perhaps optional btrfs check mode 
to do the same (at least to the restore-only level, without resorting to 
find-root), would be useful.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

