Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.fusionio.com ([66.114.96.30]:42771 "EHLO mx1.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757033Ab2FOSKB (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 15 Jun 2012 14:10:01 -0400
Date: Fri, 15 Jun 2012 14:09:57 -0400
From: Chris Mason <chris.mason@fusionio.com>
To: <torvalds@linux-foundation.org>, <linux-btrfs@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: [GIT PULL] Btrfs updates
Message-ID: <20120615180957.GE19150@shiny>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Linus,

Please pull my for-linus branch:

git://git.kernel.org/pub/scm/linux/kernel/git/mason/linux-btrfs.git for-linus

The dates look like I had to rebase this morning because there was a compiler
warning for a printk arg that I had missed earlier.

These are all fixes, including one to prevent using stale pointers for
device names, and lots of fixes around transaction abort cleanups
(Josef, Liu Bo).

Jan Schmidt also sent in a number of fixes for the new reference number
tracking code.

Liu Bo beat me to updating the MAINTAINERS file.  Since he thought to
also fix the git url, I kept his commit.

Josef Bacik (10) commits (+303/-102):
    Btrfs: pass locked_page into extent_clear_unlock_delalloc if theres an error (+2/-2)
    Btrfs: unlock everything properly in the error case for nocow (+35/-2)
    Btrfs: wake up transaction waiters when aborting a transaction (+7/-6)
    Btrfs: call filemap_fdatawrite twice for compression (+31/-7)
    Btrfs: fix locking in btrfs_destroy_delayed_refs (+17/-13)
    Btrfs: keep inode pinned when compressing writes (+6/-2)
    Btrfs: abort the transaction if the commit fails (+8/-2)
    Btrfs: use rcu to protect device->name (+162/-64)
    Btrfs: fix btrfs_destroy_marked_extents (+2/-4)
    Btrfs: implement ->show_devname (+33/-0)

Jan Schmidt (6) commits (+72/-37):
    Btrfs: remove obsolete btrfs_next_leaf call from __resolve_indirect_ref (+1/-9)
    Btrfs: remove call to btrfs_header_nritems with no effect (+0/-3)
    Btrfs: fix return value for __tree_mod_log_oldest_root (+20/-13)
    Btrfs: use btrfs_read_lock_root_node in get_old_root (+16/-4)
    Btrfs: fix race in tree mod log addition (+19/-4)
    Btrfs: add btrfs_next_old_leaf (+16/-4)

Liu Bo (5) commits (+29/-5):
    Btrfs: avoid memory leak of extent state in error handling routine (+2/-0)
    Btrfs: make sure that we've made everything in pinned tree clean (+11/-0)
    Btrfs: update MAINTAINERS info for BTRFS FILE SYSTEM (+2/-2)
    Btrfs: fix missing inherited flag in rename (+6/-3)
    Btrfs: do not resize a seeding device (+8/-0)

Li Zefan (2) commits (+50/-49):
    Btrfs: fix incompat flags setting (+1/-1)
    Btrfs: fix defrag regression (+49/-48)

Miao Xie (1) commits (+27/-0):
    Btrfs: destroy the items of the delayed inodes in error handling routine

Total: (24) commits (+481/-193)

 MAINTAINERS                |    4 +-
 fs/btrfs/backref.c         |   17 ++-----
 fs/btrfs/btrfs_inode.h     |    1 +
 fs/btrfs/check-integrity.c |   16 +++---
 fs/btrfs/ctree.c           |   86 +++++++++++++++++++++++---------
 fs/btrfs/ctree.h           |    2 +
 fs/btrfs/delayed-inode.c   |   18 +++++++
 fs/btrfs/delayed-inode.h   |    3 ++
 fs/btrfs/disk-io.c         |   76 +++++++++++++++++-----------
 fs/btrfs/extent_io.c       |    7 +--
 fs/btrfs/inode.c           |   73 +++++++++++++++++++++------
 fs/btrfs/ioctl.c           |  118 +++++++++++++++++++++++++-------------------
 fs/btrfs/ordered-data.c    |   22 ++++++++-
 fs/btrfs/rcu-string.h      |   56 +++++++++++++++++++++
 fs/btrfs/scrub.c           |   30 ++++++-----
 fs/btrfs/super.c           |   33 +++++++++++++
 fs/btrfs/transaction.c     |   14 +++++-
 fs/btrfs/volumes.c         |   92 +++++++++++++++++++++-------------
 fs/btrfs/volumes.h         |    2 +-
 19 files changed, 479 insertions(+), 191 deletions(-)
