From: Chris Mason <chris.mason@oracle.com>
Subject: Btrfs git repos available
Date: Wed, 24 Sep 2008 15:02:43 -0400
Message-ID: <1222282963.7160.210.camel@think.oraclecorp.com>
Mime-Version: 1.0
Content-Type: text/plain
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hello everyone,

As part of moving toward mainline, I've changed the Btrfs repositories
over to git.  So far I've only converted the unstable repositories
(thanks to some help from David Woodhouse, who already had -git forms of
things).

The progs-unstable repo is a direct clone of David's git repo.  The
kernel one has btrfs grafted into fs/btrfs.  All compatibility code for
older kernels has been removed.

I'll construct repos in git of btrfs as a stand alone module, and that
will include the compatibility code.

These git repos are not yet final, I may rebase them or redo them.  But,
all new patches are going into them instead of the mercurial repos.

Please give them a look and let me know if I've messed up the
conversion:

Kernel:

http://git.kernel.org/?p=linux/kernel/git/mason/btrfs-unstable.git;a=summary

Progs:

http://git.kernel.org/?p=linux/kernel/git/mason/btrfs-progs-unstable.git;a=summary

-chris


