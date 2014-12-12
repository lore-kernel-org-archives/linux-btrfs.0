Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:32238 "EHLO
	mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932399AbaLLTHj (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 12 Dec 2014 14:07:39 -0500
Date: Fri, 12 Dec 2014 14:07:31 -0500
From: Chris Mason <clm@fb.com>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        <linux-btrfs@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>
Subject: [GIT PULL] Btrfs for 3.19-rc
Message-ID: <20141212190731.GB23804@ret.masoncoding.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Linus,

Please pull my for-linus branch:

git://git.kernel.org/pub/scm/linux/kernel/git/mason/linux-btrfs.git for-linus

>From a feature point of view, most of the code here comes from Miao Xie
and others at Fujitsu to implement scrubbing and replacing devices on
raid56.  This has been in development for a while, and it's a big
improvement.

Filipe and Josef have a great assortment of fixes, many of which solve
problems corruptions either after a crash or in error conditions.  I
still have a round two from Filipe for next week that solves corruptions
with discard and block group removal.

This was based on 3.18-rc5 but does have a merge with rc6 because I
wanted to make sure testers had the use-after-free fix you pulled in
from the networking tree.

Filipe Manana (30) commits (+804/-272):
    Btrfs: fix snapshot inconsistency after a file write followed by truncate (+60/-24)
    Btrfs: make btrfs_abort_transaction consider existence of new block groups (+4/-3)
    Btrfs: report error after failure inlining extent in compressed write path (+4/-0)
    Btrfs: fix race between fs trimming and block group remove/allocation (+140/-21)
    Btrfs: deal with convert_extent_bit errors to avoid fs corruption (+76/-18)
    Btrfs: fix freeing used extents after removing empty block group (+10/-11)
    Btrfs: collect only the necessary ordered extents on ranged fsync (+17/-5)
    Btrfs: fix invalid block group rbtree access after bg is removed (+13/-0)
    Btrfs: avoid returning -ENOMEM in convert_extent_bit() too early (+10/-1)
    Btrfs: fix freeing used extent after removing empty block group (+11/-2)
    Btrfs: fix race between writing free space cache and trimming (+71/-6)
    Btrfs: correctly flush compressed data before/after direct IO (+24/-4)
    Btrfs: make find_first_extent_bit be able to cache any state (+15/-4)
    Btrfs: don't leak pages and memory on compressed write error (+19/-9)
    Btrfs: set page and mapping error on compressed write failure (+8/-1)
    Btrfs: process all async extents on compressed write failure (+1/-5)
    Btrfs: ensure ordered extent errors aren't missed on fsync (+37/-0)
    Btrfs: make inode.c:submit_compressed_extents() return void (+2/-5)
    Btrfs: ensure send always works on roots without orphans (+49/-29)
    Btrfs: fix unprotected deletion from pending_chunks list (+7/-1)
    Btrfs: make inode.c:compress_file_range() return void (+2/-5)
    Btrfs: fix memory leak after block remove + trimming (+6/-0)
    Btrfs: avoid premature -ENOMEM in clear_extent_bit() (+7/-2)
    Btrfs: don't ignore compressed bio write errors (+12/-6)
    Btrfs: fix crash caused by block group removal (+28/-0)
    Btrfs: don't ignore log btree writeback errors (+15/-6)
    Btrfs: make xattr replace operations atomic (+102/-65)
    Btrfs: add helper btrfs_fdatawrite_range (+34/-39)
    Btrfs: fix hang on compressed write error (+14/-0)
    Btrfs: fix fs mapping extent map leak (+6/-0)

David Sterba (8) commits (+122/-44):
    btrfs: switch inode_cache option handling to pending changes (+18/-15)
    btrfs: fix wrong accounting of raid1 data profile in statfs (+1/-1)
    btrfs: do commit in sync_fs if there are pending changes (+11/-3)
    btrfs: move commit out of sysfs when changing features (+5/-8)
    btrfs: move commit out of sysfs when changing label (+8/-13)
    btrfs: add support for processing pending changes (+69/-0)
    btrfs: fix typos in btrfs_check_super_valid (+4/-4)
    btrfs: introduce pending action: commit (+6/-0)

Miao Xie (7) commits (+1556/-150):
    Btrfs, raid56: fix use-after-free problem in the final device replace procedure on raid56 (+45/-20)
    Btrfs, scrub: repair the common data on RAID5/6 if it is corrupted (+235/-33)
    Btrfs, replace: write raid56 parity into the replace target device (+24/-1)
    Btrfs, replace: write dirty pages into the replace target device (+97/-43)
    Btrfs, raid56: use a variant to record the operation type (+17/-14)
    Btrfs, raid56: support parity scrub on raid56 (+1115/-20)
    Btrfs, raid56: don't change bbio and raid_map (+23/-19)

Josef Bacik (6) commits (+141/-63):
    Btrfs: make sure logged extents complete in the current transaction V3 (+72/-6)
    Btrfs: make sure we wait on logged extents when fsycning two subvols (+1/-1)
    Btrfs: don't take the chunk_mutex/dev_list mutex in statfs V2 (+47/-25)
    Btrfs: make get_caching_control unconditionally return the ctl (+4/-6)
    Btrfs: move read only block groups onto their own list V2 (+17/-23)
    Btrfs: do not move em to modified list when unpinning (+0/-2)

Zhao Lei (3) commits (+2/-10):
    Btrfs: remove unnecessary code of stripe_index assignment in __btrfs_map_block (+1/-3)
    Btrfs: remove noused bbio_ret in __btrfs_map_block in condition (+1/-2)
    Btrfs, replace: enable dev-replace for raid56 (+0/-5)

Stefan Behrens (2) commits (+53/-93):
    Btrfs: check-int: don't complain about balanced blocks (+42/-38)
    Btrfs: check_int: use the known block location (+11/-55)

Shilong Wang (2) commits (+19/-13):
    Btrfs: fix allocationg memory failure for btrfsic_state structure (+11/-5)
    Btrfs: fix incorrect compression ratio detection (+8/-8)

Chris Mason (1) commits (+1/-0):
    Btrfs: include vmalloc.h in check-integrity.c

Gui Hecheng (1) commits (+60/-30):
    btrfs: fix dead lock while running replace and defrag concurrently

Eryu Guan (1) commits (+10/-3):
    Btrfs: return failure if btrfs_dev_replace_finishing() failed

Qu Wenruo (1) commits (+18/-9):
    btrfs: Fix a lockdep warning when running xfstest.

Total: (62) commits (+2786/-687)

 fs/btrfs/check-integrity.c  | 163 ++++----
 fs/btrfs/compression.c      |  18 +-
 fs/btrfs/ctree.c            |   2 +-
 fs/btrfs/ctree.h            |  85 ++++-
 fs/btrfs/dev-replace.c      |  32 +-
 fs/btrfs/dir-item.c         |  10 +-
 fs/btrfs/disk-io.c          |  49 ++-
 fs/btrfs/extent-tree.c      | 211 ++++++++---
 fs/btrfs/extent_io.c        |  41 +-
 fs/btrfs/extent_io.h        |   1 +
 fs/btrfs/extent_map.c       |   2 -
 fs/btrfs/file.c             |  51 ++-
 fs/btrfs/free-space-cache.c | 117 +++++-
 fs/btrfs/free-space-cache.h |   2 +
 fs/btrfs/inode-map.c        |   4 +-
 fs/btrfs/inode.c            | 152 ++++++--
 fs/btrfs/ioctl.c            |  36 +-
 fs/btrfs/ordered-data.c     |  49 ++-
 fs/btrfs/ordered-data.h     |  12 +-
 fs/btrfs/raid56.c           | 763 +++++++++++++++++++++++++++++++++----
 fs/btrfs/raid56.h           |  16 +-
 fs/btrfs/scrub.c            | 893 +++++++++++++++++++++++++++++++++++++++++---
 fs/btrfs/send.c             |  49 +++
 fs/btrfs/super.c            |  94 +++--
 fs/btrfs/sysfs.c            |  34 +-
 fs/btrfs/transaction.c      | 166 ++++++--
 fs/btrfs/transaction.h      |   6 +-
 fs/btrfs/tree-log.c         |  50 ++-
 fs/btrfs/volumes.c          |  90 +++--
 fs/btrfs/volumes.h          |  32 +-
 fs/btrfs/xattr.c            | 150 +++++---
 include/uapi/linux/btrfs.h  |   1 +
 32 files changed, 2740 insertions(+), 641 deletions(-)
