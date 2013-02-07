Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from dkim2.fusionio.com ([66.114.96.54]:52512 "EHLO
	dkim2.fusionio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758099Ab3BGAN3 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 6 Feb 2013 19:13:29 -0500
Received: from mx2.fusionio.com (unknown [10.101.1.160])
	by dkim2.fusionio.com (Postfix) with ESMTP id 3BD119A0415
	for <linux-btrfs@vger.kernel.org>; Wed,  6 Feb 2013 17:13:29 -0700 (MST)
Date: Wed, 6 Feb 2013 19:13:26 -0500
From: Chris Mason <chris.mason@fusionio.com>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: [GIT PULL] Btrfs fixes
Message-ID: <20130207001326.GA21679@shiny>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

[ sorry, my lbdb seems to really like linux-kernel@vger.kerrnel.org,
fixed for real this time ]

Hi Linus,

Please pull my for-linus branch:

git://git.kernel.org/pub/scm/linux/kernel/git/mason/linux-btrfs.git for-linus

We've got corner cases for updating i_size that ceph was hitting, error
handling for quotas when we run out of space, a very subtle snapshot
deletion race, a crash while removing devices, and one deadlock between
subvolume creation and the sb_internal code (thanks lockdep).

Josef Bacik (3) commits (+12/-4):
    Btrfs: do not merge logged extents if we've removed them from the tree (+2/-1)
    Btrfs: fix possible stale data exposure (+1/-1)
    Btrfs: fix missing i_size update (+9/-2)

Miao Xie (2) commits (+21/-9):
    Btrfs: fix missing release of the space/qgroup reservation in start_transaction() (+19/-8)
    Btrfs: fix wrong sync_writers decrement in btrfs_file_aio_write() (+2/-1)

Jan Schmidt (1) commits (+10/-12):
    Btrfs: fix EDQUOT handling in btrfs_delalloc_reserve_metadata

Liu Bo (1) commits (+38/-9):
    Btrfs: fix race between snapshot deletion and getting inode

Chris Mason (1) commits (+4/-1):
    Btrfs: move d_instantiate outside the transaction during mksubvol

Eric Sandeen (1) commits (+2/-1):
    btrfs: don't try to notify udev about missing devices

Total: (9) commits

 fs/btrfs/extent-tree.c  | 22 ++++++++++------------
 fs/btrfs/extent_map.c   |  3 ++-
 fs/btrfs/file.c         | 25 ++++++++++++++++++++-----
 fs/btrfs/ioctl.c        |  5 ++++-
 fs/btrfs/ordered-data.c | 13 ++++++++++---
 fs/btrfs/scrub.c        | 25 ++++++++++++++++++++-----
 fs/btrfs/transaction.c  | 27 +++++++++++++++++++--------
 fs/btrfs/volumes.c      |  3 ++-
 8 files changed, 87 insertions(+), 36 deletions(-)
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
