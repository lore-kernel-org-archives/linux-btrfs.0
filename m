Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from dkim2.fusionio.com ([66.114.96.54]:49346 "EHLO
	dkim2.fusionio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751874Ab3EROad convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 18 May 2013 10:30:33 -0400
Received: from mx1.fusionio.com (unknown [10.101.1.160])
	by dkim2.fusionio.com (Postfix) with ESMTP id 2059F9A0425
	for <linux-btrfs@vger.kernel.org>; Sat, 18 May 2013 08:30:33 -0600 (MDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>,
        lkml <linux-kernel@vger.kernel.org>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
Message-ID: <20130518143030.4173.81638@localhost.localdomain>
From: Chris Mason <chris.mason@fusionio.com>
Subject: [GIT PULL] Btrfs updates
Date: Sat, 18 May 2013 10:30:30 -0400
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Linus,

Please pull my for-linus branch:

git://git.kernel.org/pub/scm/linux/kernel/git/mason/linux-btrfs.git for-linus

Miao Xie has been very busy, fixing races and enospc problems and many
other small but important pieces.

Alexandre Oliva discovered some problems with how our error handling was
interacting with the block layer and for now has disabled our partial
handling of sub-page writes.  The real sub-page work is in a series of
patches from IBM that we still need to integrate and test.  The code
Alexandre has turned off was really incomplete.

Josef has more error handling fixes and an important fix for the new
skinny extent format.

This also has my fix for the tracepoint crash from late in 3.9.  It's
the first stage in a larger clean up to get rid of btrfs_bio and make
a proper bioset for all the items we need to tack into the bio.  For now
the bioset only holds our mirror_num and stripe_index, but for the next
merge window I'll shuffle more in.

Miao Xie (10) commits (+87/-69):
    Btrfs: don't steal the reserved space from the global reserve if their space type is different (+4/-2)
    Btrfs: don't abort the current transaction if there is no enough space for inode cache (+2/-1)
    Btrfs: don't invoke btrfs_invalidate_inodes() in the spin lock context (+6/-0)
    Btrfs: don't use global block reservation for inode cache truncation (+34/-22)
    Btrfs: fix unprotected root node of the subvolume's inode rb-tree (+3/-4)
    Btrfs: remove BUG_ON() in btrfs_read_fs_tree_no_radix() (+0/-1)
    Btrfs: pause the space balance when remounting to R/O (+1/-0)
    Btrfs: optimize the error handle of use_block_rsv() (+28/-37)
    Btrfs: update the global reserve if it is empty (+8/-1)
    Btrfs: fix accessing a freed tree root (+1/-1)

Josef Bacik (4) commits (+35/-32):
    Btrfs: make sure roots are assigned before freeing their nodes (+21/-18)
    Btrfs: handle running extent ops with skinny metadata (+12/-10)
    Btrfs: remove warn on in free space cache writeout (+1/-3)
    Btrfs: don't null pointer deref on abort (+1/-1)

Stefan Behrens (3) commits (+8/-1):
    Btrfs: explicitly use global_block_rsv for quota_tree (+2/-0)
    Btrfs: fix possible memory leak in replace_path() (+1/-1)
    Btrfs: don't allow device replace on RAID5/RAID6 (+5/-0)

Liu Bo (2) commits (+8/-4):
    Btrfs: return errno if possible when we fail to allocate memory (+6/-2)
    Btrfs: fix off-by-one in fiemap (+2/-2)

Gabriel de Perthuis (1) commits (+5/-5):
    btrfs: don't stop searching after encountering the wrong item

Alexandre Oliva (1) commits (+30/-55):
    btrfs: do away with non-whole_page extent I/O

Chris Mason (1) commits (+120/-72):
    Btrfs: use a btrfs bioset instead of abusing bio internals

David Sterba (1) commits (+4/-4):
    btrfs: annotate quota tree for lockdep

Wang Shilong (1) commits (+2/-1):
    Btrfs: fix possible memory leak in the find_parent_nodes()

Andreas Philipp (1) commits (+6/-7):
    Correct allowed raid levels on balance.

Total: (25) commits (+305/-250)

 fs/btrfs/backref.c          |   3 +-
 fs/btrfs/check-integrity.c  |   2 +-
 fs/btrfs/ctree.c            |   4 +-
 fs/btrfs/ctree.h            |   8 +--
 fs/btrfs/delayed-ref.h      |   1 +
 fs/btrfs/dev-replace.c      |   5 ++
 fs/btrfs/disk-io.c          |  52 ++++++++++-------
 fs/btrfs/extent-tree.c      |  94 ++++++++++++++++--------------
 fs/btrfs/extent_io.c        | 138 +++++++++++++++++++++++---------------------
 fs/btrfs/extent_io.h        |   2 +
 fs/btrfs/free-space-cache.c |  43 +++++++-------
 fs/btrfs/free-space-cache.h |   2 +
 fs/btrfs/inode-map.c        |   8 ++-
 fs/btrfs/inode.c            |  81 +++++++++++++++++---------
 fs/btrfs/ioctl.c            |  10 ++--
 fs/btrfs/raid56.c           |   2 +-
 fs/btrfs/relocation.c       |   7 ++-
 fs/btrfs/scrub.c            |  10 ++--
 fs/btrfs/super.c            |   1 +
 fs/btrfs/volumes.c          |  54 ++++-------------
 fs/btrfs/volumes.h          |  20 +++++++
 21 files changed, 301 insertions(+), 246 deletions(-)
