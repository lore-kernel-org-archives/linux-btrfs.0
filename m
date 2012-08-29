Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.fusionio.com ([66.114.96.31]:37942 "EHLO mx2.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752456Ab2H2QAg (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 29 Aug 2012 12:00:36 -0400
Date: Wed, 29 Aug 2012 12:00:22 -0400
From: Chris Mason <chris.mason@fusionio.com>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Btrfs List <linux-btrfs@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Message-ID: <20120829160022.GB4697@shiny.sheraton.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Linus,

I've split out the big send/receive update from my last pull request and
now have just the fixes in my for-linus branch:

git://git.kernel.org/pub/scm/linux/kernel/git/mason/linux-btrfs.git for-linus

For anyone who wants send/receive updates, they are maintained as well.
But it is has enough cleanups (without fixes) that we shouldn't be asking
Linus to take it right now.  The send/recv branch will wander over to
linux-next shortly though.

git://git.kernel.org/pub/scm/linux/kernel/git/mason/linux-btrfs.git send-recv

The largest patches in this pull are Josef's patches to fix DIO locking
problems and his patch to fix a crash during balance.
They are both well tested.

The rest are smaller fixes that we've had queued.  The last rc came out
while I was hacking new and exciting ways to recover from a misplaced rm
-rf on my dev box, so these missed rc3.

Josef Bacik (9) commits (+322/-216):
    Btrfs: don't allocate a seperate csums array for direct reads (+19/-32)
    Btrfs: do not use missing devices when showing devname (+2/-0)
    Btrfs: fix enospc problems when deleting a subvol (+1/-1)
    Btrfs: increase the size of the free space cache (+7/-8)
    Btrfs: lock extents as we map them in DIO (+127/-129)
    Btrfs: fix deadlock with freeze and sync V2 (+9/-4)
    Btrfs: allow delayed refs to be merged (+142/-27)
    Btrfs: do not strdup non existent strings (+5/-3)
    Btrfs: barrier before waitqueue_active (+10/-12)

Stefan Behrens (5) commits (+16/-77):
    Btrfs: fix that repair code is spuriously executed for transid failures (+6/-2)
    Btrfs: revert checksum error statistic which can cause a BUG() (+2/-39)
    Btrfs: fix a misplaced address operator in a condition (+1/-1)
    Btrfs: remove superblock writing after fatal error (+5/-33)
    Btrfs: fix that error value is changed by mistake (+2/-2)

Dan Carpenter (4) commits (+16/-8):
    Btrfs: unlock on error in btrfs_delalloc_reserve_metadata() (+3/-1)
    Btrfs: fix some error codes in btrfs_qgroup_inherit() (+6/-2)
    Btrfs: fix some endian bugs handling the root times (+4/-4)
    Btrfs: checking for NULL instead of IS_ERR (+3/-1)

Liu Bo (2) commits (+25/-6):
    Btrfs: fix ordered extent leak when failing to start a transaction (+5/-2)
    Btrfs: fix a dio write regression (+20/-4)

Arne Jansen (2) commits (+38/-73):
    Btrfs: fix deadlock in wait_for_more_refs (+21/-73)
    Btrfs: fix race in run_clustered_refs (+17/-0)

Chris Mason (1) commits (+3/-0):
    Btrfs: don't run __tree_mod_log_free_eb on leaves

Fengguang Wu (1) commits (+3/-2):
    btrfs: fix second lock in btrfs_delete_delayed_items()

Miao Xie (1) commits (+1/-0):
    Btrfs: fix wrong mtime and ctime when creating snapshots

Total: (25) commits (+424/-382)

 fs/btrfs/backref.c       |   4 +-
 fs/btrfs/compression.c   |   1 +
 fs/btrfs/ctree.c         |   9 +-
 fs/btrfs/ctree.h         |   3 +-
 fs/btrfs/delayed-inode.c |  12 +-
 fs/btrfs/delayed-ref.c   | 163 +++++++++++++++++++-----
 fs/btrfs/delayed-ref.h   |   4 +
 fs/btrfs/disk-io.c       |  53 ++------
 fs/btrfs/disk-io.h       |   2 +-
 fs/btrfs/extent-tree.c   | 123 +++++++++---------
 fs/btrfs/extent_io.c     |  17 +--
 fs/btrfs/file-item.c     |   4 +-
 fs/btrfs/inode.c         | 326 ++++++++++++++++++++++++-----------------------
 fs/btrfs/ioctl.c         |   2 +-
 fs/btrfs/locking.c       |   2 +-
 fs/btrfs/qgroup.c        |  12 +-
 fs/btrfs/root-tree.c     |   4 +-
 fs/btrfs/super.c         |  15 ++-
 fs/btrfs/transaction.c   |   3 +-
 fs/btrfs/volumes.c       |  33 +----
 fs/btrfs/volumes.h       |   2 -
 21 files changed, 418 insertions(+), 376 deletions(-)
