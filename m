Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:51744 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932944AbaFKP7N (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 11 Jun 2014 11:59:13 -0400
Message-ID: <53987D5B.2030004@fb.com>
Date: Wed, 11 Jun 2014 12:01:31 -0400
From: Chris Mason <clm@fb.com>
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: [GIT PULL] Btrfs for 3.16
Content-Type: text/plain; charset="ISO-8859-1"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Linus,

Please pull my for-linus branch:

git://git.kernel.org/pub/scm/linux/kernel/git/mason/linux-btrfs.git for-linus

The biggest change here is Josef's rework of the btrfs quota accounting,
which improves the in-memory tracking of delayed extent operations.

I had been working on Btrfs stack usage for a while, mostly because it
had become impossible to do long stress runs with slab, lockdep and
pagealloc debugging turned on without blowing the stack.  Even though
you upgraded us to a nice king sized stack, I kept most of the patches.

We also have some very hard to find corruption fixes, an awesome sysfs
use after free, and the usual assortment of optimizations, cleanups and
other fixes.

Filipe Manana (24) commits (+630/-249):
    Btrfs: send, account for orphan directories when building path strings (+9/-24)
    Btrfs: fix clone to deal with holes when NO_HOLES feature is enabled (+83/-25)
    Btrfs: read inode size after acquiring the mutex when punching a hole (+2/-1)
    Btrfs: update commit root on snapshot creation after orphan cleanup (+29/-0)
    Btrfs: fix hang on error (such as ENOSPC) when writing extent pages (+11/-5)
    Btrfs: don't release invalid page in btrfs_page_exists_in_range() (+1/-0)
    Btrfs: fix leaf corruption caused by ENOSPC while hole punching (+19/-1)
    Btrfs: set dead flag on the right root when destroying snapshot (+6/-6)
    Btrfs: send, use the right limits for xattr names and values (+23/-7)
    Btrfs: send, don't error in the presence of subvols/snapshots (+4/-0)
    Btrfs: check if items are ordered when a leaf is marked dirty (+6/-0)
    Btrfs: send, avoid unnecessary inode item lookup in the btree (+7/-6)
    Btrfs: avoid visiting all extent items when cloning a range (+22/-4)
    Btrfs: don't access non-existent key when csum tree is empty (+1/-1)
    Btrfs: send, remove dead code from __get_cur_name_and_parent (+0/-6)
    Btrfs: ioctl, don't re-lock extent range when not necessary (+7/-2)
    Btrfs: ensure readers see new data after a clone operation (+31/-5)
    Btrfs: send, fix more issues related to directory renames (+96/-94)
    Btrfs: make sure we retry if page is a retriable exception (+3/-1)
    Btrfs: make sure we retry if we couldn't get the page (+3/-1)
    Btrfs: implement inode_operations callback tmpfile (+98/-20)
    Btrfs: make fsync work after cloning into a file (+155/-38)
    Btrfs: ensure btrfs_prev_leaf doesn't miss 1 item (+11/-1)
    Btrfs: fix transaction leak during fsync call (+3/-1)

David Sterba (9) commits (+145/-39):
    btrfs: assert that send is not in progres before root deletion (+1/-13)
    btrfs: balance filter: add limit of processed chunks (+27/-2)
    btrfs: remove newline from inode cache kthread name (+1/-1)
    btrfs: protect snapshots from deleting during send (+53/-2)
    btrfs: remove stale newlines from log messages (+14/-14)
    btrfs: make DEV_INFO ioctl available to anyone (+0/-3)
    btrfs: make FS_INFO ioctl available to anyone (+0/-3)
    btrfs: retrieve more info from FS_INFO ioctl (+9/-1)
    btrfs: export more from FS_INFO to sysfs (+40/-0)

Liu Bo (6) commits (+54/-21):
    Btrfs: fix scrub_print_warning to handle skinny metadata extents (+24/-15)
    Btrfs: mark mapping with error flag to report errors to userspace (+2/-0)
    Btrfs: fix NULL pointer crash of deleting a seed device (+8/-4)
    Btrfs: fix leaf corruption after __btrfs_drop_extents (+18/-0)
    Btrfs: do not increment on bio_index one by one (+1/-1)
    Btrfs: use right type to get real comparison (+1/-1)

Chris Mason (6) commits (+500/-264):
    Btrfs: break up __btrfs_write_out_cache to cut down stack usage (+191/-117)
    Btrfs: split up __extent_writepage to lower stack usage (+194/-138)
    Btrfs: cut down stack usage in btree_write_cache_pages (+5/-4)
    Btrfs: fix double free in find_lock_delalloc_range (+1/-0)
    Btrfs: convert smp_mb__{before,after}_clear_bit (+2/-2)
    Btrfs: async delayed refs (+107/-3)

Gui Hecheng (4) commits (+20/-3):
    btrfs: add dev maxs limit for __btrfs_alloc_chunk in kernel space (+16/-0)
    btrfs: replace EINVAL with EOPNOTSUPP for dev_replace raid56 (+1/-1)
    btrfs: replace EINVAL with ERANGE for resize when ULLONG_MAX (+1/-1)
    btrfs: fix wrong max system array size check in kernel space (+2/-1)

Josef Bacik (4) commits (+1748/-518):
    Btrfs: add sanity tests for new qgroup accounting code (+700/-37)
    Btrfs: don't check nodes for extent items (+3/-2)
    Btrfs: free tmp ulist for qgroup rescan (+1/-0)
    Btrfs: rework qgroup accounting (+1044/-479)

Miao Xie (4) commits (+261/-124):
    Btrfs: use bitfield instead of integer data type for the some variants in btrfs_root (+109/-94)
    Btrfs: output warning instead of error when loading free space cache failed (+2/-2)
    Btrfs: use helpers for last_trans_log_full_commit instead of opencode (+36/-27)
    Btrfs: reclaim the reserved metadata space at background (+114/-1)

Wang Shilong (3) commits (+14/-3):
    Btrfs: make sure there are not any read requests before stopping workers (+5/-0)
    Btrfs: fix joining same transaction handle more than twice (+9/-2)
    Btrfs: set right total device count for seeding support (+0/-1)

Qu Wenruo (3) commits (+152/-23):
    btrfs: Avoid trucating page or punching hole in a already existed hole. (+98/-14)
    btrfs: Add check to avoid cleanup roots already in fs_info->dead_roots. (+30/-7)
    btrfs: Add ctime/mtime update for btrfs device add/remove. (+24/-2)

Zach Brown (3) commits (+28/-33):
    btrfs: return errno instead of -1 from compression (+20/-20)
    btrfs: return ptr error from compression workspace (+3/-3)
    btrfs: fix inline compressed read err corruption (+5/-10)

Jeff Mahoney (2) commits (+41/-18):
    btrfs: free delayed node outside of root->inode_lock (+5/-2)
    btrfs: allocate raid type kobjects dynamically (+36/-16)

Anand Jain (2) commits (+32/-4):
    btrfs: usage error should not be logged into system log (+1/-4)
    btrfs: btrfs_rm_device() should zero mirror SB as well (+31/-0)

ZhangZhen (2) commits (+3/-9):
    btrfs: replace simple_strtoull() with kstrtoull() (+3/-2)
    btrfs: remove useless ACL check (+0/-7)

Antonio Ospite (1) commits (+2/-2):
    trivial: fs/btrfs/ioctl.c: fix typo s/substract/subtract/

Alex Gartrell (1) commits (+71/-7):
    btrfs: Drop EXTENT_UPTODATE check in hole punching and direct locking

Daeseok Youn (1) commits (+1/-2):
    btrfs: remove redundant null check in btrfs_dentry_release()

Tobias Klauser (1) commits (+2/-2):
    btrfs: Remove unnecessary check for NULL

Rickard Strandqvist (1) commits (+3/-2):
    fs: btrfs: volumes.c: Fix for possible null pointer dereference

Stefan Behrens (1) commits (+4/-1):
    btrfs: check_int: propagate out-of-memory error upwards

Tsutomu Itoh (1) commits (+1/-0):
    Btrfs: fix possible memory leak in btrfs_create_tree()

Guangliang Zhao (1) commits (+7/-0):
    Btrfs: remove OPT_acl parse when acl disabled

Total: (80)

 fs/btrfs/Makefile             |   2 +-
 fs/btrfs/acl.c                |   7 -
 fs/btrfs/backref.c            |  41 +-
 fs/btrfs/backref.h            |   8 +-
 fs/btrfs/btrfs_inode.h        |   2 +
 fs/btrfs/check-integrity.c    |   5 +-
 fs/btrfs/compression.c        |   6 +-
 fs/btrfs/ctree.c              | 104 ++---
 fs/btrfs/ctree.h              | 143 +++----
 fs/btrfs/delayed-inode.c      |   7 +-
 fs/btrfs/delayed-ref.c        |  39 +-
 fs/btrfs/delayed-ref.h        |  24 +-
 fs/btrfs/dev-replace.c        |   2 +-
 fs/btrfs/disk-io.c            | 113 +++--
 fs/btrfs/disk-io.h            |   1 +
 fs/btrfs/extent-tree.c        | 470 ++++++++++++++++-----
 fs/btrfs/extent_io.c          | 401 +++++++++++-------
 fs/btrfs/extent_io.h          |   2 +
 fs/btrfs/file-item.c          |  80 +++-
 fs/btrfs/file.c               | 152 +++++--
 fs/btrfs/free-space-cache.c   | 312 ++++++++------
 fs/btrfs/inode-map.c          |   2 +-
 fs/btrfs/inode.c              | 293 +++++++++----
 fs/btrfs/ioctl.c              | 396 +++++++++++++++---
 fs/btrfs/lzo.c                |  14 +-
 fs/btrfs/ordered-data.c       |   2 +-
 fs/btrfs/qgroup.c             | 937 +++++++++++++++++++++++++++++++-----------
 fs/btrfs/qgroup.h             | 107 +++++
 fs/btrfs/relocation.c         |  21 +-
 fs/btrfs/root-tree.c          |   2 +-
 fs/btrfs/scrub.c              |   9 +-
 fs/btrfs/send.c               | 290 ++++++-------
 fs/btrfs/super.c              |  13 +-
 fs/btrfs/sysfs.c              |  50 ++-
 fs/btrfs/tests/btrfs-tests.c  |  97 +++++
 fs/btrfs/tests/btrfs-tests.h  |   9 +
 fs/btrfs/tests/inode-tests.c  |  35 +-
 fs/btrfs/tests/qgroup-tests.c | 468 +++++++++++++++++++++
 fs/btrfs/transaction.c        | 113 ++---
 fs/btrfs/transaction.h        |   1 +
 fs/btrfs/tree-defrag.c        |   2 +-
 fs/btrfs/tree-log.c           |  49 +--
 fs/btrfs/tree-log.h           |  16 +
 fs/btrfs/volumes.c            | 122 +++++-
 fs/btrfs/volumes.h            |   1 +
 fs/btrfs/zlib.c               |  26 +-
 include/uapi/linux/btrfs.h    |   9 +-
 47 files changed, 3700 insertions(+), 1305 deletions(-)
