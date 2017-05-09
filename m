Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:39122 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1750805AbdEIR4u (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 9 May 2017 13:56:50 -0400
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
From: Chris Mason <clm@fb.com>
Subject: [GIT PULL] Btrfs
Message-ID: <88747a65-7407-fcc5-4111-962440c082c8@fb.com>
Date: Tue, 9 May 2017 13:56:40 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Linus,

My for-linus-4.12 branch:

git://git.kernel.org/pub/scm/linux/kernel/git/mason/linux-btrfs.git for-linus-4.12

Has fixes and cleanups Dave Sterba collected for the merge window.

The biggest functional fixes are between btrfs raid5/6 and scrub, and
raid5/6 and device replacement.  Some of our pending qgroup fixes are
included as well while I bash on the rest in testing.

We also have the usual set of cleanups, including one that
__btrfs_map_block() much more maintainable, and conversions from
atomic_t to refcount_t.

Elena Reshetova (16) commits (+141/-135):
    btrfs: convert btrfs_delayed_ref_node.refs from atomic_t to refcount_t (+14/-12)
    btrfs: convert btrfs_transaction.use_count from atomic_t to refcount_t (+16/-14)
    btrfs: convert compressed_bio.pending_bios from atomic_t to refcount_t (+9/-9)
    btrfs: convert btrfs_caching_control.count from atomic_t to refcount_t (+8/-7)
    btrfs: convert btrfs_ordered_extent.refs from atomic_t to refcount_t (+11/-11)
    btrfs: convert btrfs_delayed_item.refs from atomic_t to refcount_t (+10/-10)
    btrfs: convert btrfs_delayed_node.refs from atomic_t to refcount_t (+16/-16)
    btrfs: convert btrfs_raid_bio.refs from atomic_t to refcount_t (+9/-10)
    btrfs: convert scrub_recover.refs from atomic_t to refcount_t (+4/-4)
    btrfs: convert scrub_parity.refs from atomic_t to refcount_t (+4/-4)
    btrfs: convert extent_state.refs from atomic_t to refcount_t (+9/-8)
    btrfs: convert extent_map.refs from atomic_t to refcount_t (+12/-11)
    btrfs: convert scrub_block.refs from atomic_t to refcount_t (+5/-5)
    btrfs: convert btrfs_root.refs from atomic_t to refcount_t (+4/-4)
    btrfs: convert scrub_ctx.refs from atomic_t to refcount_t (+5/-5)
    btrfs: convert btrfs_bio.refs from atomic_t to refcount_t (+5/-5)

Liu Bo (15) commits (+640/-425):
    Btrfs: do not add extra mirror when dev_replace target dev is not available (+4/-3)
    Btrfs: introduce a function to get extra mirror from replace (+89/-72)
    Btrfs: fix wrong failed mirror_num of read-repair on raid56 (+5/-0)
    Btrfs: set scrub page's io_error if failing to submit io (+6/-2)
    Btrfs: handle operations for device replace separately (+98/-81)
    Btrfs: enable repair during read for raid56 profile (+27/-13)
    Btrfs: separate DISCARD from __btrfs_map_block (+175/-114)
    Btrfs: remove ASSERT in btrfs_truncate_inode_items (+0/-7)
    Btrfs: switch to div64_u64 if with a u64 divisor (+7/-7)
    Btrfs: update scrub_parity to use u64 stripe_len (+4/-4)
    Btrfs: helper for ops that requires full stripe (+10/-8)
    Btrfs: create a helper for getting chunk map (+57/-111)
    Btrfs: update comments in cache_save_setup (+2/-1)
    Btrfs: add file item tracepoints (+154/-0)
    Btrfs: convert BUG_ON to WARN_ON (+2/-2)

David Sterba (12) commits (+72/-86):
    btrfs: remove redundant parameter from reada_start_machine_dev (+3/-4)
    btrfs: remove unused qgroup members from btrfs_trans_handle (+0/-20)
    btrfs: preallocate radix tree node for global readahead tree (+8/-1)
    btrfs: sink GFP flags parameter to tree_mod_log_insert_root (+5/-5)
    btrfs: sink GFP flags parameter to tree_mod_log_insert_move (+5/-5)
    btrfs: remove local blocksize variable in reada_find_extent (+2/-4)
    btrfs: remove redundant parameter from btree_readahead_hook (+5/-6)
    btrfs: drop redundant parameters from btrfs_map_sblock (+6/-9)
    btrfs: track exclusive filesystem operation in flags (+25/-26)
    btrfs: remove redundant parameter from reada_find_zone (+3/-3)
    btrfs: preallocate radix tree node for readahead (+8/-1)
    btrfs: use clear_page where appropriate (+2/-2)

Qu Wenruo (10) commits (+510/-96):
    btrfs: qgroup: Re-arrange tracepoint timing to co-operate with reserved space tracepoint (+6/-10)
    btrfs: qgroup: Fix qgroup corruption caused by inode_cache mount option (+18/-7)
    btrfs: Wait for in-flight bios before freeing target device for raid56 (+21/-0)
    btrfs: Fix metadata underflow caused by btrfs_reloc_clone_csum error (+39/-12)
    btrfs: Handle delalloc error correctly to avoid ordered extent hang (+48/-15)
    btrfs: qgroup: Add trace point for qgroup reserved space (+96/-44)
    btrfs: Prevent scrub recheck from racing with dev replace (+9/-4)
    btrfs: scrub: Don't append on-disk pages for raid56 scrub (+0/-4)
    btrfs: scrub: Introduce full stripe lock for RAID56 (+251/-0)
    btrfs: scrub: Fix RAID56 recovery race condition (+22/-0)

Filipe Manana (5) commits (+192/-41):
    Btrfs: fix incorrect space accounting after failure to insert inline extent (+4/-2)
    Btrfs: fix invalid attempt to free reserved space on failure to cow range (+45/-18)
    Btrfs: send, fix file hole not being preserved due to inline extent (+21/-2)
    Btrfs: fix extent map leak during fallocate error path (+3/-1)
    Btrfs: fix reported number of inode blocks (+119/-18)

Anand Jain (3) commits (+7/-8):
    btrfs: use q which is already obtained from bdev_get_queue (+3/-4)
    btrfs: check if the device is flush capable (+4/-0)
    btrfs: delete unused member nobarriers (+0/-4)

Edmund Nadolski (2) commits (+25/-20):
    btrfs: provide enumeration for __merge_refs mode argument (+13/-10)
    btrfs: replace hardcoded value with SEQ_LAST macro (+12/-10)

Goldwyn Rodrigues (2) commits (+24/-3):
    btrfs: qgroups: Retry after commit on getting EDQUOT (+23/-1)
    btrfs: No need to check !(flags & MS_RDONLY) twice (+1/-2)

Chris Mason (1) commits (+2/-2):
    btrfs: fix the gfp_mask for the reada_zones radix tree

Adam Borowski (1) commits (+9/-3):
    btrfs: fix a bogus warning when converting only data or metadata

Deepa Dinamani (1) commits (+2/-1):
    btrfs: Use ktime_get_real_ts for root ctime

Dan Carpenter (1) commits (+15/-26):
    Btrfs: handle only applicable errors returned by btrfs_get_extent

Dmitry V. Levin (1) commits (+2/-0):
    MAINTAINERS: add btrfs file entries for include directories

Hans van Kranenburg (1) commits (+5/-5):
    Btrfs: consistent usage of types in balance_args

Total: (71) commits

 MAINTAINERS                  |   2 +
 fs/btrfs/backref.c           |  41 ++-
 fs/btrfs/btrfs_inode.h       |   7 +
 fs/btrfs/compression.c       |  18 +-
 fs/btrfs/ctree.c             |  20 +-
 fs/btrfs/ctree.h             |  34 +-
 fs/btrfs/delayed-inode.c     |  46 +--
 fs/btrfs/delayed-inode.h     |   6 +-
 fs/btrfs/delayed-ref.c       |   8 +-
 fs/btrfs/delayed-ref.h       |   8 +-
 fs/btrfs/dev-replace.c       |   9 +-
 fs/btrfs/disk-io.c           |  13 +-
 fs/btrfs/disk-io.h           |   4 +-
 fs/btrfs/extent-tree.c       |  35 +-
 fs/btrfs/extent_io.c         |  59 +--
 fs/btrfs/extent_io.h         |   8 +-
 fs/btrfs/extent_map.c        |  10 +-
 fs/btrfs/extent_map.h        |   3 +-
 fs/btrfs/file.c              |  82 ++++-
 fs/btrfs/free-space-cache.c  |   2 +-
 fs/btrfs/inode.c             | 289 +++++++++++----
 fs/btrfs/ioctl.c             |  33 +-
 fs/btrfs/ordered-data.c      |  20 +-
 fs/btrfs/ordered-data.h      |   2 +-
 fs/btrfs/qgroup.c            | 102 ++----
 fs/btrfs/qgroup.h            |  51 ++-
 fs/btrfs/raid56.c            |  38 +-
 fs/btrfs/reada.c             |  37 +-
 fs/btrfs/root-tree.c         |   3 +-
 fs/btrfs/scrub.c             | 331 +++++++++++++++--
 fs/btrfs/send.c              |  23 +-
 fs/btrfs/super.c             |   3 +-
 fs/btrfs/tests/btrfs-tests.c |   1 -
 fs/btrfs/transaction.c       |  48 ++-
 fs/btrfs/transaction.h       |   6 +-
 fs/btrfs/tree-log.c          |   2 +-
 fs/btrfs/volumes.c           | 854 +++++++++++++++++++++++--------------------
 fs/btrfs/volumes.h           |   8 +-
 include/trace/events/btrfs.h | 187 +++++++++-
 include/uapi/linux/btrfs.h   |  10 +-
 40 files changed, 1629 insertions(+), 834 deletions(-)
