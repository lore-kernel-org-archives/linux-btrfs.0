Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:6383 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S934165AbcHDTMi (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 4 Aug 2016 15:12:38 -0400
Date: Thu, 4 Aug 2016 15:12:32 -0400
From: Chris Mason <clm@fb.com>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: [GIT PULL] Btrfs
Message-ID: <20160804191232.jmzrcmreu4feh64n@floor.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Linus,

This is part two of my btrfs pull, which is some cleanups and a batch of
fixes.  

Most of the code here is from Jeff Mahoney, making the pointers
we pass around internally more consistent and less confusing overall.  I
noticed a small problem right before I sent this out yesterday, so I
fixed it up and re-tested overnight.

Please pull my for-linus-4.8 branch:

git://git.kernel.org/pub/scm/linux/kernel/git/mason/linux-btrfs.git for-linus-4.8

There are some minor conflicts against Mike Christie's changes in
your tree.  I've put the conflict resolution I used for testing here:

git://git.kernel.org/pub/scm/linux/kernel/git/mason/linux-btrfs.git for-linus-4.8-merged

Jeff Mahoney (14) commits (+754/-669):
    btrfs: tests, use BTRFS_FS_STATE_DUMMY_FS_INFO instead of dummy root (+19/-21)
    btrfs: btrfs_relocate_chunk pass extent_root to btrfs_end_transaction (+1/-1)
    btrfs: btrfs_test_opt and friends should take a btrfs_fs_info (+135/-130)
    btrfs: cleanup, remove prototype for btrfs_find_root_ref (+0/-3)
    btrfs: btrfs_abort_transaction, drop root parameter (+147/-152)
    btrfs: convert nodesize macros to static inlines (+33/-15)
    btrfs: tests, move initialization into tests/ (+48/-77)
    btrfs: add btrfs_trans_handle->fs_info pointer (+6/-4)
    btrfs: copy_to_sk drop unused root parameter (+2/-3)
    btrfs: simpilify btrfs_subvol_inherit_props (+3/-3)
    btrfs: prefix fsid to all trace events (+186/-158)
    btrfs: tests, require fs_info for root (+103/-61)
    btrfs: plumb fs_info into btrfs_work (+63/-31)
    btrfs: introduce BTRFS_MAX_ITEM_SIZE (+8/-10)

Liu Bo (10) commits (+149/-49):
    Btrfs: change BUG_ON()'s to ASSERT()'s in backref_cache_cleanup() (+6/-6)
    Btrfs: error out if generic_bin_search get invalid arguments (+8/-0)
    Btrfs: check inconsistence between chunk and block group (+16/-1)
    Btrfs: fix unexpected balance crash due to BUG_ON (+24/-4)
    Btrfs: fix eb memory leak due to readpage failure (+22/-3)
    Btrfs: fix BUG_ON in btrfs_submit_compressed_write (+8/-2)
    Btrfs: fix read_node_slot to return errors (+52/-21)
    Btrfs: fix panic in balance due to EIO (+4/-0)
    Btrfs: cleanup BUG_ON in merge_bio (+6/-3)
    Btrfs: fix double free of fs root (+3/-9)

Nikolay Borisov (4) commits (+49/-20):
    btrfs: Ratelimit "no csum found" info message (+1/-1)
    btrfs: Handle uninitialised inode eviction (+8/-1)
    btrfs: Add ratelimit to btrfs printing (+24/-2)
    btrfs: Fix slab accounting flags (+16/-16)

Wang Xiaoguang (3) commits (+45/-13):
    btrfs: expand cow_file_range() to support in-band dedup and subpage-blocksize (+41/-11)
    btrfs: add missing bytes_readonly attribute file in sysfs (+2/-0)
    btrfs: fix free space calculation in dump_space_info() (+2/-2)

Anand Jain (2) commits (+40/-36):
    btrfs: make sure device is synced before return (+5/-0)
    btrfs: reorg btrfs_close_one_device() (+35/-36)

David Sterba (2) commits (+4/-3):
    btrfs: remove obsolete part of comment in statfs (+0/-3)
    btrfs: hide test-only member under ifdef (+4/-0)

Ashish Samant (1) commits (+35/-37):
    btrfs: Cleanup compress_file_range()

Chris Mason (1) commits (+3/-2):
    Btrfs: fix __MAX_CSUM_ITEMS

Chandan Rajendra (1) commits (+1/-1):
    Btrfs: subpage-blocksize: Rate limit scrub error message

Salah Triki (1) commits (+1/-2):
    btrfs: Replace -ENOENT by -ERANGE in btrfs_get_acl()

Hans van Kranenburg (1) commits (+1/-1):
    Btrfs: use the correct struct for BTRFS_IOC_LOGICAL_INO

Total: (40) commits (+1082/-833)

 fs/btrfs/acl.c                         |   3 +-
 fs/btrfs/async-thread.c                |  31 +++-
 fs/btrfs/async-thread.h                |   6 +-
 fs/btrfs/backref.c                     |   4 +-
 fs/btrfs/compression.c                 |  10 +-
 fs/btrfs/ctree.c                       |  91 ++++++----
 fs/btrfs/ctree.h                       | 101 ++++++-----
 fs/btrfs/dedupe.h                      |  24 +++
 fs/btrfs/delayed-inode.c               |   4 +-
 fs/btrfs/delayed-ref.c                 |  17 +-
 fs/btrfs/dev-replace.c                 |   4 +-
 fs/btrfs/disk-io.c                     | 101 +++++------
 fs/btrfs/disk-io.h                     |   3 +-
 fs/btrfs/extent-tree.c                 | 124 ++++++++------
 fs/btrfs/extent_io.c                   |  30 +++-
 fs/btrfs/extent_map.c                  |   2 +-
 fs/btrfs/file-item.c                   |   4 +-
 fs/btrfs/file.c                        |  12 +-
 fs/btrfs/free-space-cache.c            |   8 +-
 fs/btrfs/free-space-tree.c             |  16 +-
 fs/btrfs/inode-map.c                   |  16 +-
 fs/btrfs/inode.c                       | 218 ++++++++++++------------
 fs/btrfs/ioctl.c                       |  40 ++---
 fs/btrfs/ordered-data.c                |   2 +-
 fs/btrfs/props.c                       |   6 +-
 fs/btrfs/qgroup.c                      |  25 +--
 fs/btrfs/qgroup.h                      |   9 +-
 fs/btrfs/relocation.c                  |  20 ++-
 fs/btrfs/root-tree.c                   |  10 +-
 fs/btrfs/scrub.c                       |  12 +-
 fs/btrfs/super.c                       | 218 +++++++++++-------------
 fs/btrfs/sysfs.c                       |   2 +
 fs/btrfs/tests/btrfs-tests.c           |  67 +++++++-
 fs/btrfs/tests/btrfs-tests.h           |  36 +---
 fs/btrfs/tests/extent-buffer-tests.c   |  23 ++-
 fs/btrfs/tests/free-space-tests.c      |  14 +-
 fs/btrfs/tests/free-space-tree-tests.c |  18 +-
 fs/btrfs/tests/inode-tests.c           |  46 ++---
 fs/btrfs/tests/qgroup-tests.c          |  23 +--
 fs/btrfs/transaction.c                 |  37 +++--
 fs/btrfs/transaction.h                 |   1 +
 fs/btrfs/tree-log.c                    |  22 ++-
 fs/btrfs/volumes.c                     | 138 ++++++++-------
 include/trace/events/btrfs.h           | 295 ++++++++++++++++++---------------
 include/uapi/linux/btrfs.h             |   2 +-
 45 files changed, 1072 insertions(+), 823 deletions(-)
