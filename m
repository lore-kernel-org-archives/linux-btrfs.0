Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from dkim2.fusionio.com ([66.114.96.54]:40928 "EHLO
	dkim2.fusionio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751647Ab3IVUuF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 22 Sep 2013 16:50:05 -0400
Received: from mx2.fusionio.com (unknown [10.101.1.160])
	by dkim2.fusionio.com (Postfix) with ESMTP id 66D6C9A0371
	for <linux-btrfs@vger.kernel.org>; Sun, 22 Sep 2013 14:50:04 -0600 (MDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>,
        <linux-btrfs@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Message-ID: <20130922205002.29199.88359@localhost.localdomain>
From: Chris Mason <chris.mason@fusionio.com>
Subject: [GIT PULL] Btrfs
Date: Sun, 22 Sep 2013 16:50:02 -0400
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Linus,

Please pull my for-linus branch:

git://git.kernel.org/pub/scm/linux/kernel/git/mason/linux-btrfs.git for-linus

These are mostly bug fixes and a two small performance fixes.  The most
important of the bunch are Josef's fix for a snapshotting regression and
Mark's update to fix compile problems on arm.

These are on top of 3.11 + my first pull, but they were also tested
against your master as of last night.

Josef Bacik (13) commits (+219/-102):
    Btrfs: check roots last log commit when checking if an inode has been logged (+4/-1)
    Revert "Btrfs: rework the overcommit logic to be based on the total size" (+3/-12)
    Btrfs: kill delay_iput arg to the wait_ordered functions (+14/-33)
    Btrfs: drop dir i_size when adding new names on replay (+27/-0)
    Btrfs: replay dir_index items before other items (+12/-3)
    Btrfs: fix worst case calculator for space usage (+1/-1)
    Btrfs: actually log directory we are fsync()'ing (+9/-1)
    Btrfs: actually limit the size of delalloc range (+5/-3)
    Btrfs: fixup error handling in btrfs_reloc_cow (+32/-22)
    Btrfs: remove space_info->reservation_progress (+0/-12)
    Btrfs: create the uuid tree on remount rw (+10/-0)
    Btrfs: improve replacing nocow extents (+98/-14)
    Btrfs: iput inode on allocation failure (+4/-0)

Stefan Behrens (2) commits (+4/-0):
    btrfs: show compiled-in config features at module load time (+3/-0)
    Btrfs: add the missing mutex unlock in write_all_supers() (+1/-0)

Filipe David Borba Manana (2) commits (+7/-7):
    Btrfs: don't leak transaction in btrfs_sync_file() (+2/-2)
    Btrfs: more efficient inode tree replace operation (+5/-5)

David Sterba (2) commits (+8/-0):
    btrfs: add lockdep and tracing annotations for uuid tree (+2/-0)
    btrfs: refuse to remount read-write after abort (+6/-0)

Guangyu Sun (1) commits (+2/-0):
    Btrfs: dir_inode_operations should use btrfs_update_time also

Mark Fasheh (1) commits (+45/-31):
    btrfs: change extent-same to copy entire argument struct

Ilya Dryomov (1) commits (+2/-1):
    Btrfs: do not add replace target to the alloc_list

Frank Holton (1) commits (+2/-2):
    btrfs: Add btrfs: prefix to kernel log output

chandan (1) commits (+1/-1):
    Btrfs: btrfs_ioctl_default_subvol: Revert back to toplevel subvolume when arg is 0

Miao Xie (1) commits (+74/-31):
    Btrfs: allocate the free space by the existed max extent size when ENOSPC

Total: (25) commits

 fs/btrfs/btrfs_inode.h       |   5 +-
 fs/btrfs/ctree.c             |   7 ++-
 fs/btrfs/ctree.h             |  17 ++-----
 fs/btrfs/dev-replace.c       |   4 +-
 fs/btrfs/disk-io.c           |   2 +
 fs/btrfs/extent-tree.c       |  57 +++++++++++-----------
 fs/btrfs/extent_io.c         |   8 ++--
 fs/btrfs/file.c              |   4 +-
 fs/btrfs/free-space-cache.c  |  67 ++++++++++++++++++--------
 fs/btrfs/free-space-cache.h  |   5 +-
 fs/btrfs/inode.c             |  16 +++++--
 fs/btrfs/ioctl.c             |  80 ++++++++++++++++++-------------
 fs/btrfs/ordered-data.c      |  24 ++--------
 fs/btrfs/ordered-data.h      |   5 +-
 fs/btrfs/relocation.c        |  43 ++++++++++-------
 fs/btrfs/scrub.c             | 112 +++++++++++++++++++++++++++++++++++++------
 fs/btrfs/super.c             |  21 +++++++-
 fs/btrfs/transaction.c       |   2 +-
 fs/btrfs/tree-log.c          |  52 ++++++++++++++++++--
 fs/btrfs/volumes.c           |   7 +--
 include/trace/events/btrfs.h |   1 +
 21 files changed, 364 insertions(+), 175 deletions(-)
