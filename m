Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mondschein.lichtvoll.de ([194.150.191.11]:47623 "EHLO
	mail.lichtvoll.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751624Ab2GOLUQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 15 Jul 2012 07:20:16 -0400
From: Martin Steigerwald <Martin@lichtvoll.de>
To: linux-btrfs@vger.kernel.org
Subject: Re: Can't mount, power failure - recoverable?
Date: Sun, 15 Jul 2012 13:20:14 +0200
Cc: Skylar Burtenshaw <DaninFuchs@gmail.com>
References: <loom.20120317T051243-551@post.gmane.org> <201207131638.34771.Martin@lichtvoll.de> <loom.20120714T025232-591@post.gmane.org> (sfid-20120714_135305_721346_B7DB9E09)
In-Reply-To: <loom.20120714T025232-591@post.gmane.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Message-Id: <201207151320.14620.Martin@lichtvoll.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Am Samstag, 14. Juli 2012 schrieb Skylar Burtenshaw:
> Martin Steigerwald <Martin <at> lichtvoll.de> writes:
> > > > Since I didn´t found any explicit mention on it:
> > > > Did you try btrfs-zero-log on the partition prior to mounting it?
> 
> I had tried that previously, yes. Approximately the date of my first
> post. Unless something significant has changed in that tool, it seems
> to not be the answer in this case.
> 
> > > > All of my BTRFS will not mount after sudden write interruption
> > > > cases have been solved by it. Except one with a BTRFS RAID 0
> > > > with lots of 2 TB drives at a time where I didn´t know about
> > > > btrfs-zero-log. Maybe it would have helped there, too.
> 
> Actually, I have about two dozen drives ranging from 250gb to 2tb, but
> I don't think size plays much in this one - I'm obviously just
> guessing here, though.
> 
> > Yes.
> > 
> > But why would it write some stuff then on mounting?
> > 
> > Could it be that it tries to update some of its caches (inode or
> > space)? But then that also does not seem to be in the trace.
> 
> I agree with you. I noticed it was trying to write, myself. I have no
> idea what it was doing when the power dropped, I wasn't even present,
> so I can't even say if it was doing some massive database culling or
> just idling.
> 
> I noticed there've been some recent (since I last looked at least)
> updates including fsck and such, however I haven't run anything
> git-based since the last time I pulled the btrfs tools, and I had to
> dig for ages to find info on how to get the RECENT stuff from the
> CORRECT source. I can find a dozen Google results that seem relevant,
> but can someone give me a definitive answer on which tree to pull down
> (and how) to test the new tools on my mess?

Hehe, I looked for myself quite some time for it.

Last time I used:

martin@merkaba:~/Linux/Kernel/BTRFS/btrfs-progs> git remote -v
origin  git://git.kernel.org/pub/scm/linux/kernel/git/mason/btrfs-
progs.git (fetch)
origin  git://git.kernel.org/pub/scm/linux/kernel/git/mason/btrfs-
progs.git (push)
martin@merkaba:~/Linux/Kernel/BTRFS/btrfs-progs> git branch -a
* dangerdonteveruse
  master
  remotes/origin/HEAD -> origin/master
  remotes/origin/dangerdonteveruse
  remotes/origin/integration-scrub
  remotes/origin/master
  remotes/origin/parser
  remotes/origin/recovery-beta

But last change in it is:

commit 1957076ab4fefa47b6efed3da541bc974c83eed7
Author: Chris Mason <chris.mason@oracle.com>
Date:   Wed Mar 28 12:05:27 2012 -0400

    Add incompat flag for big metadata blocks
    
    Signed-off-by: Chris Mason <chris.mason@oracle.com>


Hmmm, master branch seems to be quite current:

commit 8935d8436147f86dfbda3d8b8175a77b654b8abc
Author: David Sterba <dsterba@suse.cz>
Date:   Fri Jul 6 10:11:10 2012 -0400

    btrfs-progs: mkfs: add option to skip trim
    
    Signed-off-by: Chris Mason <chris.mason@fusionio.com>

Ciao,
-- 
Martin 'Helios' Steigerwald - http://www.Lichtvoll.de
GPG: 03B0 0D6C 0040 0710 4AFA  B82F 991B EAAC A599 84C7
