Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:33005 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932466AbaH1KEQ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 28 Aug 2014 06:04:16 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1XMwYw-0003hf-KS
	for linux-btrfs@vger.kernel.org; Thu, 28 Aug 2014 12:04:14 +0200
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Thu, 28 Aug 2014 12:04:14 +0200
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Thu, 28 Aug 2014 12:04:14 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: Undelete files / directory
Date: Thu, 28 Aug 2014 10:04:04 +0000 (UTC)
Message-ID: <pan$2ed7a$1001c22e$8c89f27e$d20dc522@cox.net>
References: <53FE1DB2.8040900@sysnux.pf>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Jean-Denis Girard posted on Wed, 27 Aug 2014 08:04:34 -1000 as excerpted:

> Two days ago I mistakenly deleted a directory on a btrfs file system. As
> soon as I realized, I cleanly unmounted the partition, and have not
> touched it since then. I have no snapshot and no backup; I was on
> vacations with my laptop, and the directory deleted contained ~3 weeks
> of photos.
> 
> I found this script:
> http://comments.gmane.org/gmane.comp.file-systems.btrfs/22560 but the
> commands have probably changed, and it no longer runs.
> 
> So is there a way to recover a deleted directory on btrfs? Just to make
> things clear, this is not a broken file system, just a normally deleted
> directory.
> 
> I'm on Fedora 20, with kernel 3.15.10-200.fc20.x86_64, and
> btrfs-progs-3.14.2-3.fc20.x86_64.

Were you trying to use that script as-posted without understanding what 
it did?  You realize how easy it'd be for someone to post some script 
claiming to do something great, that instead did a rm -rf /* or some 
such, right?

Anyway, looks like line 67 needs changed.

The command is now btrfs-find-root not just find-root, and the script 
assumes it's being run from the same directory as the find-root command, 
which isn't likely to be the case, so you can remove the "$dir"/ bit and 
just let the normal path do the searching.  You can read the btrfs-find-
root manpage and experiment with running the command on its own a bit to 
see what it does.

Then, it looks like he hard-coded the device-path for the filesystem as 
/dev/mapper/queen-home.  You'll need to fix that.  Looks like you can 
replace it with "$dev".

So line 67 should look like this:

btrfs-find-root "$dev" 2>&1 \

Line 84, the command should be btrfs restore.  Again, kill the $dir/ bit 
along with the quote around the command, and you can read about it in the 
btrfs-restore manpage.

Finally, at least as I'm seeing it here, line 103 is a bunch of 
corruption at the end of the file and can simply be deleted.

At a quick glance that's all that immediately jumps out at me as needing 
changed, but I neither examined the output of btrfs-find-root too closely 
to see if lines 68 and 69 need changed at all, nor the command-line 
options to see if they changed.  Presumably you can do that yourself -- 
thus the mentions of the manpages and experimenting with the btrfs-find-
root command.

Also, while nothing immediately jumps out at me as bad about the script, 
keep in mind that something simply posted to a list isn't a trusted 
source already checked for at least the worst system-eating mistakes like 
your distro's packages should be, and you'll need to run it as root for 
device access.  I've not gone thru it looking for stuff that might go 
wrong if fed the wrong parameters, etc.  Understand what it actually does 
before attempting to run it as root, as if he screwed up something and/or 
you mistype the parameters you're feeding it, I don't expect you want it 
deleting all your files as a result!

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

