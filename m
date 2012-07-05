Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.fusionio.com ([66.114.96.31]:33819 "EHLO mx2.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751062Ab2GETzQ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 5 Jul 2012 15:55:16 -0400
Date: Thu, 5 Jul 2012 15:55:13 -0400
From: Chris Mason <chris.mason@fusionio.com>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Btrfs mailing list <linux-btrfs@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: [GIT PULL] Btrfs updates
Message-ID: <20120705195513.GD7159@shiny>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Linus

I held off on my rc5 pull because I hit an oops during log recovery
after a crash.  I wanted to make sure it wasn't a regression because
we have some logging fixes in here.

It turns out that a commit during the merge window just made it much
more likely to trigger directory logging instead of full commits, which
exposed an old bug.

Please grab my for-linus branch:

git://git.kernel.org/pub/scm/linux/kernel/git/mason/linux-btrfs.git for-linus

The new backref walking code got some additional fixes.  This should
be the final set of them.

Josef fixed up a corner where our O_DIRECT writes and buffered reads
could expose old file contents (not stale, just not the most recent).
He and Liu Bo fixed crashes during tree log recover as well.

Ilya fixed errors while we resume disk balancing operations on readonly
mounts.

Jan Schmidt (7) commits (+50/-36):
    Btrfs: leave critical region in btrfs_find_all_roots as soon as possible (+1/-2)
    Btrfs: always put insert_ptr modifications into the tree mod log (+7/-7)
    Btrfs: resolve tree mod log locking issue in btrfs_next_leaf (+12/-0)
    Btrfs: fix tree mod log for root replacements at leaf level (+15/-13)
    Btrfs: support root level changes in __resolve_indirect_ref (+8/-4)
    Btrfs: avoid waiting for delayed refs when we must not (+6/-5)
    Btrfs: fix tree mod log rewind of ADD operations (+1/-5)

Josef Bacik (3) commits (+116/-111):
    Btrfs: hold a ref on the inode during writepages (+14/-0)
    Btrfs: fix tree log remove space corner case (+52/-93)
    Btrfs: fix dio write vs buffered read race (+50/-18)

Ilya Dryomov (2) commits (+73/-43):
    Btrfs: resume balance on rw (re)mounts properly (+47/-18)
    Btrfs: restore restriper state on all mounts (+26/-25)

Stefan Behrens (1) commits (+12/-10):
    Btrfs: don't count I/O statistic read errors for missing devices

Liu Bo (1) commits (+1/-1):
    Btrfs: fix wrong check during log recovery

Alexander Block (1) commits (+1/-1):
    Btrfs: use _IOR for BTRFS_IOC_SUBVOL_GETFLAGS

Chris Mason (1) commits (+6/-0):
    Btrfs: run delayed directory updates during log replay

Total: (16) commits (+259/-202)

 fs/btrfs/backref.c          |  15 +++--
 fs/btrfs/ctree.c            |  60 ++++++++++--------
 fs/btrfs/disk-io.c          |  34 +++++++----
 fs/btrfs/extent-tree.c      |  11 ++--
 fs/btrfs/extent_io.c        |  14 +++++
 fs/btrfs/file.c             |  13 ----
 fs/btrfs/free-space-cache.c | 145 ++++++++++++++++----------------------------
 fs/btrfs/inode.c            |  57 +++++++++++++++--
 fs/btrfs/ioctl.h            |   2 +-
 fs/btrfs/super.c            |   4 ++
 fs/btrfs/tree-log.c         |   6 ++
 fs/btrfs/volumes.c          |  95 +++++++++++++++++------------
 fs/btrfs/volumes.h          |   3 +-
 13 files changed, 258 insertions(+), 201 deletions(-)
