Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:39097 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1762304AbdDSLfm (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 19 Apr 2017 07:35:42 -0400
From: David Sterba <dsterba@suse.com>
To: clm@fb.com
Cc: David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org
Subject: [PULL] Btrfs, updates for 4.12
Date: Wed, 19 Apr 2017 13:35:34 +0200
Message-Id: <cover.1492601450.git.dsterba@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

this is the main part of my 4.12 pull, condensed changelog below. I might send
another pull with low-risk patches, mostly cleanups, but so far I'm done with
base testing now. We had a high-churn cycle last time, so this could be small
one and we can concentrate on testing & fixing the raid56 updates.

The qgroup patches have been in for-next but I haven't seen any new review for
the core part.

Updates:
* raid56:
  * fix mirror name in warning message after repair
  * scrub fixes: calculate parity correctly
  * scrub recheck and dev replace race fix
  * enabled auto-repair during read
  * fix warnings during recovery, due to races, bogus reports can appear
* switch to refcount_t where atomic_t was used for plain refcounting
* new and updated tracepoints
* split __btrfs_map_block, clean up
* minor qgroup fixes
* usual cleanups

----------------------------------------------------------------
The following changes since commit 4f7d029b9bf009fbee76bb10c0c4351a1870d2f3:

  Linux 4.11-rc7 (2017-04-16 13:00:18 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/kdave/linux.git for-chris-4.12

for you to fetch changes up to c2a9c7ab475bc3aaf06521a39ac65bc48c8cad4f:

  btrfs: check if the device is flush capable (2017-04-18 16:13:27 +0200)

----------------------------------------------------------------
Adam Borowski (1):
      btrfs: fix a bogus warning when converting only data or metadata

Anand Jain (3):
      btrfs: use q which is already obtained from bdev_get_queue
      btrfs: delete unused member nobarriers
      btrfs: check if the device is flush capable

Dan Carpenter (1):
      Btrfs: handle only applicable errors returned by btrfs_get_extent

David Sterba (12):
      btrfs: preallocate radix tree node for readahead
      btrfs: preallocate radix tree node for global readahead tree
      btrfs: remove redundant parameter from btree_readahead_hook
      btrfs: remove redundant parameter from reada_find_zone
      btrfs: remove redundant parameter from reada_start_machine_dev
      btrfs: remove local blocksize variable in reada_find_extent
      btrfs: remove unused qgroup members from btrfs_trans_handle
      btrfs: track exclusive filesystem operation in flags
      btrfs: sink GFP flags parameter to tree_mod_log_insert_move
      btrfs: sink GFP flags parameter to tree_mod_log_insert_root
      btrfs: drop redundant parameters from btrfs_map_sblock
      btrfs: use clear_page where appropriate

Deepa Dinamani (1):
      btrfs: Use ktime_get_real_ts for root ctime

Dmitry V. Levin (1):
      MAINTAINERS: add btrfs file entries for include directories

Edmund Nadolski (2):
      btrfs: provide enumeration for __merge_refs mode argument
      btrfs: replace hardcoded value with SEQ_LAST macro

Elena Reshetova (16):
      btrfs: convert btrfs_bio.refs from atomic_t to refcount_t
      btrfs: convert btrfs_transaction.use_count from atomic_t to refcount_t
      btrfs: convert extent_map.refs from atomic_t to refcount_t
      btrfs: convert btrfs_ordered_extent.refs from atomic_t to refcount_t
      btrfs: convert btrfs_caching_control.count from atomic_t to refcount_t
      btrfs: convert btrfs_delayed_ref_node.refs from atomic_t to refcount_t
      btrfs: convert btrfs_delayed_node.refs from atomic_t to refcount_t
      btrfs: convert btrfs_delayed_item.refs from atomic_t to refcount_t
      btrfs: convert btrfs_root.refs from atomic_t to refcount_t
      btrfs: convert extent_state.refs from atomic_t to refcount_t
      btrfs: convert compressed_bio.pending_bios from atomic_t to refcount_t
      btrfs: convert scrub_recover.refs from atomic_t to refcount_t
      btrfs: convert scrub_block.refs from atomic_t to refcount_t
      btrfs: convert scrub_parity.refs from atomic_t to refcount_t
      btrfs: convert scrub_ctx.refs from atomic_t to refcount_t
      btrfs: convert btrfs_raid_bio.refs from atomic_t to refcount_t

Goldwyn Rodrigues (2):
      btrfs: No need to check !(flags & MS_RDONLY) twice
      btrfs: qgroups: Retry after commit on getting EDQUOT

Hans van Kranenburg (1):
      Btrfs: consistent usage of types in balance_args

Liu Bo (15):
      Btrfs: remove ASSERT in btrfs_truncate_inode_items
      Btrfs: add file item tracepoints
      Btrfs: create a helper for getting chunk map
      Btrfs: separate DISCARD from __btrfs_map_block
      Btrfs: introduce a function to get extra mirror from replace
      Btrfs: handle operations for device replace separately
      Btrfs: do not add extra mirror when dev_replace target dev is not available
      Btrfs: helper for ops that requires full stripe
      Btrfs: convert BUG_ON to WARN_ON
      Btrfs: update comments in cache_save_setup
      Btrfs: set scrub page's io_error if failing to submit io
      Btrfs: fix wrong failed mirror_num of read-repair on raid56
      Btrfs: enable repair during read for raid56 profile
      Btrfs: update scrub_parity to use u64 stripe_len
      Btrfs: switch to div64_u64 if with a u64 divisor

Qu Wenruo (8):
      btrfs: qgroup: Add trace point for qgroup reserved space
      btrfs: qgroup: Re-arrange tracepoint timing to co-operate with reserved space tracepoint
      btrfs: scrub: Don't append on-disk pages for raid56 scrub
      btrfs: Wait for in-flight bios before freeing target device for raid56
      btrfs: Prevent scrub recheck from racing with dev replace
      btrfs: qgroup: Fix qgroup corruption caused by inode_cache mount option
      btrfs: scrub: Introduce full stripe lock for RAID56
      btrfs: scrub: Fix RAID56 recovery race condition

 MAINTAINERS                  |   2 +
 fs/btrfs/backref.c           |  41 ++-
 fs/btrfs/compression.c       |  18 +-
 fs/btrfs/ctree.c             |  20 +-
 fs/btrfs/ctree.h             |  34 +-
 fs/btrfs/delayed-inode.c     |  46 +--
 fs/btrfs/delayed-inode.h     |   6 +-
 fs/btrfs/delayed-ref.c       |   8 +-
 fs/btrfs/delayed-ref.h       |   8 +-
 fs/btrfs/dev-replace.c       |   9 +-
 fs/btrfs/disk-io.c           |  15 +-
 fs/btrfs/disk-io.h           |   4 +-
 fs/btrfs/extent-tree.c       |  35 +-
 fs/btrfs/extent_io.c         |  59 +--
 fs/btrfs/extent_io.h         |   3 +-
 fs/btrfs/extent_map.c        |  10 +-
 fs/btrfs/extent_map.h        |   3 +-
 fs/btrfs/file.c              |  16 +-
 fs/btrfs/free-space-cache.c  |   2 +-
 fs/btrfs/inode.c             |  47 +--
 fs/btrfs/ioctl.c             |  33 +-
 fs/btrfs/ordered-data.c      |  20 +-
 fs/btrfs/ordered-data.h      |   2 +-
 fs/btrfs/qgroup.c            | 102 ++----
 fs/btrfs/qgroup.h            |  51 ++-
 fs/btrfs/raid56.c            |  38 +-
 fs/btrfs/reada.c             |  37 +-
 fs/btrfs/root-tree.c         |   3 +-
 fs/btrfs/scrub.c             | 331 +++++++++++++++--
 fs/btrfs/super.c             |   3 +-
 fs/btrfs/tests/btrfs-tests.c |   1 -
 fs/btrfs/transaction.c       |  48 ++-
 fs/btrfs/transaction.h       |   6 +-
 fs/btrfs/tree-log.c          |   2 +-
 fs/btrfs/volumes.c           | 856 +++++++++++++++++++++++--------------------
 fs/btrfs/volumes.h           |   8 +-
 include/trace/events/btrfs.h | 187 +++++++++-
 include/uapi/linux/btrfs.h   |  10 +-
 38 files changed, 1354 insertions(+), 770 deletions(-)
