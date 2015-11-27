Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:40751 "EHLO
	mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755258AbbK0VNI (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 27 Nov 2015 16:13:08 -0500
Date: Fri, 27 Nov 2015 16:13:02 -0500
From: Chris Mason <clm@fb.com>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        linux-btrfs <linux-btrfs@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: [GIT PULL] Btrfs
Message-ID: <20151127211302.GC2162@ret.masoncoding.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Linus,

I have a few fixes ready in my for-linus-4.4 branch.

git://git.kernel.org/pub/scm/linux/kernel/git/mason/linux-btrfs.git for-linus-4.4

This has Mark Fasheh's patches to fix quota accounting during subvol
deletion, which we've been working on for a while now.  The patch is
pretty small but it's a key fix.

Otherwise it's a random assortment.

Filipe Manana (5) commits (+146/-49):
    Btrfs: fix the number of transaction units needed to remove a block group (+38/-5)
    Btrfs: use global reserve when deleting unused block group after ENOSPC (+52/-26)
    Btrfs: fix scrub preventing unused block groups from being deleted (+24/-1)
    Btrfs: fix race between cleaner kthread and space cache writeout (+16/-13)
    Btrfs: fix race between scrub and block group deletion (+16/-4)

David Sterba (3) commits (+10/-8):
    btrfs: fix clashing number of the enhanced balance usage filter (+1/-1)
    btrfs: fix signed overflows in btrfs_sync_file (+7/-3)
    btrfs: fix rcu warning during device replace (+2/-4)

Zhaolei (1) commits (+18/-2):
    btrfs: Continue replace when set_block_ro failed

Mark Fasheh (1) commits (+42/-7):
    btrfs: qgroup: account shared subtree during snapshot delete

Justin Maggard (1) commits (+2/-1):
    btrfs: qgroup: fix quota disable during rescan

Holger Hoffstätte (1) commits (+2/-2):
    btrfs: fix balance range usage filters in 4.4-rc

Dan Carpenter (1) commits (+3/-1):
    Btrfs: tests: checking for NULL instead of IS_ERR()

Josef Bacik (1) commits (+1/-1):
    Btrfs: use btrfs_get_fs_root in resolve_indirect_ref

Total: (14) commits (+224/-71)

 fs/btrfs/backref.c                |   2 +-
 fs/btrfs/ctree.h                  |   4 ++
 fs/btrfs/extent-tree.c            | 123 +++++++++++++++++++++++++++++++-------
 fs/btrfs/file.c                   |  10 +++-
 fs/btrfs/inode.c                  |  24 +-------
 fs/btrfs/qgroup.c                 |   5 +-
 fs/btrfs/scrub.c                  |  62 +++++++++++++++++--
 fs/btrfs/tests/free-space-tests.c |   4 +-
 fs/btrfs/transaction.c            |  32 ++++++++++
 fs/btrfs/transaction.h            |   4 ++
 fs/btrfs/volumes.c                |  13 ++--
 fs/btrfs/volumes.h                |   2 +-
 12 files changed, 219 insertions(+), 66 deletions(-)
