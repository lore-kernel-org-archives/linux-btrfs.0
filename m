Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.fusionio.com ([66.114.96.31]:57307 "EHLO mx2.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750933Ab3AYFgN (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 25 Jan 2013 00:36:13 -0500
Date: Fri, 25 Jan 2013 00:36:05 -0500
From: Chris Mason <chris.mason@fusionio.com>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        linux-btrfs <linux-btrfs@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: [GIT PULL] Btrfs fixes (v2)
Message-ID: <20130125053605.GA23255@shiny>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Linus,

My for-linus branch has our batch of btrfs fixes:

git://git.kernel.org/pub/scm/linux/kernel/git/mason/linux-btrfs.git for-linus

It turns out that we had two crc bugs when running fsx-linux in a
loop.  Many thanks to Josef, Miao Xie, and Dave Sterba for nailing it
all down.  Miao also has a new OOM fix in this v2 pull as well.

Ilya fixed a regression Liu Bo found in the balance ioctls for pausing
and resuming a running balance across drives.

Josef's orphan truncate patch fixes an obscure corruption we'd see
during xfstests.

Arne's patches address problems with subvolume quotas.  If the user
destroys quota groups incorrectly the FS will refuse to mount.

The rest are smaller fixes and plugs for memory leaks.

Miao Xie (8) commits (+76/-24):
    Btrfs: fix missing write access release in btrfs_ioctl_resize() (+1/-0)
    Btrfs: do not delete a subvolume which is in a R/O subvolume (+5/-5)
    Btrfs: Add ACCESS_ONCE() to transaction->abort accesses (+3/-2)
    Btrfs: fix wrong max device number for single profile (+1/-1)
    Btrfs: fix repeated delalloc work allocation (+41/-14)
    Btrfs: fix missed transaction->aborted check (+16/-0)
    Btrfs: fix resize a readonly device (+4/-2)
    Btrfs: disable qgroup id 0 (+5/-0)

Ilya Dryomov (6) commits (+94/-32):
    Btrfs: reorder locks and sanity checks in btrfs_ioctl_defrag (+9/-8)
    Btrfs: fix "mutually exclusive op is running" error code (+4/-4)
    Btrfs: fix a regression in balance usage filter (+8/-1)
    Btrfs: bring back balance pause/resume logic (+71/-17)
    Btrfs: fix unlock order in btrfs_ioctl_rm_dev (+1/-1)
    Btrfs: fix unlock order in btrfs_ioctl_resize (+1/-1)

Liu Bo (5) commits (+23/-7):
    Btrfs: fix a bug when llseek for delalloc bytes behind prealloc extents (+14/-6)
    Btrfs: use right range to find checksum for compressed extents (+5/-0)
    Btrfs: let allocation start from the right raid type (+1/-1)
    Btrfs: reset path lock state to zero (+2/-0)
    Btrfs: fix off-by-one in lseek (+1/-0)

Josef Bacik (5) commits (+69/-29):
    Btrfs: do not allow logged extents to be merged or removed (+16/-3)
    Btrfs: add orphan before truncating pagecache (+38/-15)
    Btrfs: set flushing if we're limited flushing (+1/-1)
    Btrfs: put csums on the right ordered extent (+2/-2)
    Btrfs: fix panic when recovering tree log (+12/-8)

Arne Jansen (2) commits (+19/-1):
    Btrfs: prevent qgroup destroy when there are still relations (+12/-1)
    Btrfs: ignore orphan qgroup relations (+7/-0)

Zach Brown (1) commits (+1/-0):
    btrfs: fix btrfs_cont_expand() freeing IS_ERR em

Lukas Czerner (1) commits (+1/-1):
    btrfs: get the device in write mode when deleting it

Eric Sandeen (1) commits (+14/-3):
    btrfs: update timestamps on truncate()

Tsutomu Itoh (1) commits (+3/-1):
    Btrfs: fix memory leak in name_cache_insert()

Total: (30) commits (+300/-98)

 fs/btrfs/extent-tree.c      |   6 +-
 fs/btrfs/extent_map.c       |  13 ++++-
 fs/btrfs/extent_map.h       |   1 +
 fs/btrfs/file-item.c        |   4 +-
 fs/btrfs/file.c             |  10 +++-
 fs/btrfs/free-space-cache.c |  20 ++++---
 fs/btrfs/inode.c            | 137 +++++++++++++++++++++++++++++++++-----------
 fs/btrfs/ioctl.c            | 129 ++++++++++++++++++++++++++++++-----------
 fs/btrfs/qgroup.c           |  20 ++++++-
 fs/btrfs/send.c             |   4 +-
 fs/btrfs/super.c            |   2 +-
 fs/btrfs/transaction.c      |  19 +++++-
 fs/btrfs/tree-log.c         |  10 +++-
 fs/btrfs/volumes.c          |  23 ++++++--
 14 files changed, 300 insertions(+), 98 deletions(-)
