Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:38293 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752357AbcJKPqO (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 11 Oct 2016 11:46:14 -0400
Date: Tue, 11 Oct 2016 11:46:10 -0400
From: Chris Mason <clm@fb.com>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: [GIT PULL] Btrfs
Message-ID: <20161011154610.pq7jjus5ghrczydf@floor.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Linus,

My for-linus-4.9 has our merge window pull:

git://git.kernel.org/pub/scm/linux/kernel/git/mason/linux-btrfs.git for-linus-4.9

This is later than normal because I was tracking down a use-after-free
during btrfs/101 in xfstests.  I had hoped to fix up the offending
patch, but wasn't happy with the size of the changes at this point in
the merge window.

The use-after-free was enough of a corner case that I didn't want to
rebase things out at this point.  So instead the top of the pull is my
revert, and the rest of these were prepped by Dave Sterba (thanks Dave!).  

This is a big variety of fixes and cleanups.  Liu Bo continues to fixup
fuzzer related problems, and some of Josef's cleanups are prep for his
bigger extent buffer changes (slated for v4.10).

Liu Bo (13) commits (+207/-36):
    Btrfs: remove unnecessary btrfs_mark_buffer_dirty in split_leaf (+5/-1)
    Btrfs: return gracefully from balance if fs tree is corrupted (+17/-6)
    Btrfs: improve check_node to avoid reading corrupted nodes (+28/-4)
    Btrfs: add error handling for extent buffer in print tree (+7/-0)
    Btrfs: memset to avoid stale content in btree node block (+11/-0)
    Btrfs: bail out if block group has different mixed flag (+14/-0)
    Btrfs: memset to avoid stale content in btree leaf (+28/-19)
    Btrfs: fix memory leak in reading btree blocks (+9/-0)
    Btrfs: fix memory leak of block group cache (+75/-0)
    Btrfs: kill BUG_ON in run_delayed_tree_ref (+7/-1)
    Btrfs: remove BUG_ON in start_transaction (+1/-4)
    Btrfs: fix memory leak in do_walk_down (+1/-0)
    Btrfs: remove BUG() in raid56 (+4/-1)

Jeff Mahoney (7) commits (+849/-902):
    btrfs: btrfs_debug should consume fs_info when DEBUG is not defined (+10/-4)
    btrfs: clean the old superblocks before freeing the device (+11/-27)
    btrfs: convert send's verbose_printk to btrfs_debug (+38/-27)
    btrfs: convert printk(KERN_* to use pr_* calls (+205/-275)
    btrfs: convert pr_* to btrfs_* where possible (+231/-177)
    btrfs: unsplit printed strings (+324/-391)
    btrfs: add dynamic debug support (+30/-1)

Josef Bacik (5) commits (+178/-156):
    Btrfs: kill the start argument to read_extent_buffer_pages (+15/-28)
    Btrfs: kill BUG_ON()'s in btrfs_mark_extent_written (+33/-8)
    Btrfs: add a flags field to btrfs_fs_info (+99/-109)
    Btrfs: don't leak reloc root nodes on error (+4/-0)
    Btrfs: don't BUG() during drop snapshot (+27/-11)

Goldwyn Rodrigues (3) commits (+3/-18):
    btrfs: Do not reassign count in btrfs_run_delayed_refs (+0/-1)
    btrfs: Remove already completed TODO comment (+0/-2)
    btrfs: parent_start initialization cleanup (+3/-15)

Luis Henriques (2) commits (+0/-4):
    btrfs: Fix warning "variable ‘blocksize’ set but not used" (+0/-2)
    btrfs: Fix warning "variable ‘gen’ set but not used" (+0/-2)

Eric Sandeen (1) commits (+1/-1):
    btrfs: fix perms on demonstration debugfs interface

Anand Jain (1) commits (+20/-6):
    btrfs: fix a possible umount deadlock

Lu Fengqi (1) commits (+369/-10):
    btrfs: fix check_shared for fiemap ioctl

Chris Mason (1) commits (+15/-11):
    Revert "btrfs: let btrfs_delete_unused_bgs() to clean relocated bgs"

Masahiro Yamada (1) commits (+8/-28):
    btrfs: squash lines for simple wrapper functions

Qu Wenruo (1) commits (+37/-25):
    btrfs: extend btrfs_set_extent_delalloc and its friends to support in-band dedupe and subpage size patchset

Arnd Bergmann (1) commits (+7/-10):
    btrfs: fix btrfs_no_printk stub helper

David Sterba (1) commits (+9/-0):
    btrfs: create example debugfs file only in debugging build

Naohiro Aota (1) commits (+11/-15):
    btrfs: let btrfs_delete_unused_bgs() to clean relocated bgs

Total: (39) commits (+1714/-1222)

 fs/btrfs/backref.c            | 409 ++++++++++++++++++++++++++++++++++++++----
 fs/btrfs/btrfs_inode.h        |  11 --
 fs/btrfs/check-integrity.c    | 342 +++++++++++------------------------
 fs/btrfs/compression.c        |   6 +-
 fs/btrfs/ctree.c              |  56 ++----
 fs/btrfs/ctree.h              | 116 ++++++++----
 fs/btrfs/delayed-inode.c      |  25 ++-
 fs/btrfs/delayed-ref.c        |  15 +-
 fs/btrfs/dev-replace.c        |  21 ++-
 fs/btrfs/dir-item.c           |   7 +-
 fs/btrfs/disk-io.c            | 237 ++++++++++++++++--------
 fs/btrfs/disk-io.h            |   2 +
 fs/btrfs/extent-tree.c        | 198 +++++++++++---------
 fs/btrfs/extent_io.c          | 170 +++++++++++-------
 fs/btrfs/extent_io.h          |   4 +-
 fs/btrfs/file.c               |  43 ++++-
 fs/btrfs/free-space-cache.c   |  21 ++-
 fs/btrfs/free-space-cache.h   |   6 +-
 fs/btrfs/free-space-tree.c    |  20 ++-
 fs/btrfs/inode-map.c          |  31 ++--
 fs/btrfs/inode.c              |  70 +++++---
 fs/btrfs/ioctl.c              |  14 +-
 fs/btrfs/lzo.c                |   6 +-
 fs/btrfs/ordered-data.c       |   4 +-
 fs/btrfs/print-tree.c         |  93 +++++-----
 fs/btrfs/qgroup.c             |  77 ++++----
 fs/btrfs/raid56.c             |   5 +-
 fs/btrfs/reada.c              |  32 ++--
 fs/btrfs/relocation.c         |  47 +++--
 fs/btrfs/root-tree.c          |  18 +-
 fs/btrfs/scrub.c              |  58 +++---
 fs/btrfs/send.c               |  79 ++++----
 fs/btrfs/super.c              |  62 ++++---
 fs/btrfs/sysfs.c              |  19 +-
 fs/btrfs/tests/inode-tests.c  |  12 +-
 fs/btrfs/tests/qgroup-tests.c |   2 +-
 fs/btrfs/transaction.c        |  49 +++--
 fs/btrfs/transaction.h        |   1 +
 fs/btrfs/tree-log.c           |  12 +-
 fs/btrfs/uuid-tree.c          |  27 +--
 fs/btrfs/volumes.c            | 197 ++++++++++----------
 fs/btrfs/volumes.h            |   2 +-
 fs/btrfs/zlib.c               |   8 +-
 43 files changed, 1563 insertions(+), 1071 deletions(-)
