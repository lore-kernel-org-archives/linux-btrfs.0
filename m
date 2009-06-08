From: Chris Mason <chris.mason@oracle.com>
Subject: New new format branch ready for testing
Date: Mon, 8 Jun 2009 16:58:48 -0400
Message-ID: <20090608205848.GB4130@think>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hello everyone,

Yan Zheng sent along an update for the new format patch today, and it
slightly changed the disk format for backrefs used when balancing space
across drives.  We decided against supporting an intermediate format
that was only a week old, and his update makes a few important features
much much easier (snapshot deletion for one).

If you've tried the newformat branch and run btrfs-vol -b or run
btrfs-vol -r, you'll have to backup your data and reformat before
switching to the newest code.

If this is a problem for any testers of the newformat branch, please
don't hesitate to send me an email.  We'll find a way to help you
transition to the new code.  The main reason I'm willing to make this
format switch is because these commands are not commonly run, and I
doubt there has been a huge number of people trying out the newformat
code.

If you've tried the newformat branch and haven't run btrfs-vol -b or
btrfs-vol -r, you can safely switch to the updated code without any
extra steps.

If you're not sure if you've run these commands, pull down the new code
just for btrfs-progs, and run btrfsck.  It will print an error if it
finds any of the unsupported disk items.

I didn't want people to accidentally pull the new new format on top of
the old new format without reading this email, so I gave the new new
format a new branch name (newformat2).

For the kernel (still at 2.6.30-rc7, rebased today):

git pull git://git.kernel.org/pub/scm/linux/kernel/git/mason/btrfs-unstable.git newformat2

For the progs (also rebased today):

git://git.kernel.org/pub/scm/linux/kernel/git/mason/btrfs-progs-unstable.git newformat2

I deleted the newformat branch.  Only newformat2 should be used for new
testing now.

Since this is working well in testing so far, we plan on asking Linus to
pull it for 2.6.31.  We don't plan on any more format changes for this
code.

-chris

