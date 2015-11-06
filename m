Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:47402 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752991AbbKFSox (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 6 Nov 2015 13:44:53 -0500
Date: Fri, 6 Nov 2015 13:44:48 -0500
From: Chris Mason <clm@fb.com>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        linux-btrfs <linux-btrfs@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: [GIT PULL] Btrfs
Message-ID: <20151106184448.GA26661@ret.masoncoding.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Linus,

Please pull my for-linus-4.4 branch:

git://git.kernel.org/pub/scm/linux/kernel/git/mason/linux-btrfs.git for-linus-4.4

My branch was based on 4.3-rc5, and it ended up with a minor conflict
against the btrfs changes sent in for a later rc.  I put a sample merge
resolution up here:

git://git.kernel.org/pub/scm/linux/kernel/git/mason/linux-btrfs.git for-linus-4.4-merged

The only non-obvious part of all this is in fs/btrfs/volumes.h.  Both
sides of the merge ended up creating the BTRFS_BALANCE_ARGS_MASK
definition, which was my fault (sorry) for letting a duplicate patch in
the mix.  When you merge, please keep the longer of the two definitions,
since we added to it later in the for-linus-4.4 branch.

I'm happy to redo things merged with 4.3-final if you don't want to
bother with this, sorry for the hassle.

On to the fun part, we have a lot of subvolume quota improvements in here,
along with big piles of cleanups from Dave Sterba and Anand Jain and
others.

Josef pitched in a batch of allocator fixes based on production use here
at FB.  We found that mount -o ssd_spread greatly improved our
performance on hardware raid5/6, but it exposed some CPU bottlenecks in
the allocator.  These patches make a huge difference.

Qu Wenruo (24) commits (+1031/-375):
    btrfs: extent-tree: Add new version of btrfs_check_data_free_space and btrfs_free_reserved_data_space. (+79/-9)
    btrfs: extent-tree: Switch to new check_data_free_space and free_reserved_data_space (+27/-19)
    btrfs: qgroup: Avoid calling btrfs_free_reserved_data_space in clear_bit_hook (+22/-12)
    btrfs: delayed_ref: Add new function to record reserved space into delayed ref (+43/-0)
    btrfs: extent-tree: Add new version of btrfs_delalloc_reserve/release_space (+61/-0)
    btrfs: extent_io: Introduce needed structure for recoding set/clear bits (+12/-0)
    btrfs: qgroup: Introduce functions to release/free qgroup reserve data (+62/-0)
    btrfs: extent-tree: Switch to new delalloc space reserve and release (+38/-25)
    btrfs: delayed_ref: release and free qgroup reserved at proper timing (+34/-4)
    btrfs: qgroup: Fix a race in delayed_ref which leads to abort trans (+32/-21)
    btrfs: extent_io: Introduce new function clear_record_extent_bits() (+42/-11)
    btrfs: qgroup: Fix a rebase bug which will cause qgroup double free (+0/-4)
    btrfs: extent_io: Introduce new function set_record_extent_bits (+56/-18)
    btrfs: qgroup: Introduce new functions to reserve/free metadata (+48/-0)
    btrfs: qgroup: Don't copy extent buffer to do qgroup rescan (+16/-10)
    btrfs: qgroup: Add new trace point for qgroup data reserve (+130/-2)
    btrfs: qgroup: Introduce btrfs_qgroup_reserve_data function (+52/-0)
    btrfs: fallocate: Add support to accurate qgroup reserve (+117/-44)
    btrfs: qgroup: Check if qgroup reserved space leaked (+34/-0)
    btrfs: qgroup: Cleanup old inaccurate facilities (+60/-156)
    btrfs: qgroup: Add handler for NOCOW and inline (+21/-1)
    btrfs: qgroup: Use new metadata reservation. (+13/-36)
    btrfs: Fix a data space underflow warning (+8/-3)
    btrfs: Add handler for invalidate page (+24/-0)

David Sterba (17) commits (+393/-112):
    btrfs: introduce ratelimited _in_rcu variants of message printing functions (+38/-0)
    btrfs: remove waitqueue_active check from btrfs_rm_dev_replace_unblocked (+1/-2)
    btrfs: add balance filters limits, stripes and usage to supported mask (+4/-1)
    btrfs: comment the rest of implicit barriers before waitqueue_active (+22/-0)
    btrfs: introduce ratelimited variants of message printing functions (+21/-0)
    btrfs: switch message printers to ratelimited _in_rcu variants (+16/-16)
    btrfs: introduce _in_rcu variants of message printing functions (+29/-0)
    btrfs: extend balance filter usage to take minimum and maximum (+60/-4)
    btrfs: extend balance filter limit to take minimum and maximum (+67/-3)
    btrfs: add barrier for waitqueue_active in clear_btree_io_tree (+6/-0)
    btrfs: add comments to barriers before waitqueue_active (+16/-2)
    btrfs: switch message printers to ratelimited variants (+31/-33)
    btrfs: check unsupported filters in balance arguments (+13/-0)
    btrfs: switch message printers to _in_rcu variants (+27/-27)
    btrfs: remove extra barrier before waitqueue_active (+6/-2)
    btrfs: comment waitqueue_active implied by locks (+11/-1)
    btrfs: switch more printks to our helpers (+25/-21)

Anand Jain (14) commits (+205/-184):
    Btrfs: __btrfs_std_error() logic should be consistent w/out CONFIG_PRINTK defined (+5/-22)
    Btrfs: use BTRFS_ERROR_DEV_MISSING_NOT_FOUND when missing device is not found (+2/-4)
    Btrfs: kernel operation should come after user input has been verified (+13/-13)
    Btrfs: enhance btrfs_scratch_superblock to scratch all superblocks (+27/-13)
    Btrfs: rename btrfs_kobj_add_device to btrfs_sysfs_add_device_link (+5/-5)
    Btrfs: rename btrfs_sysfs_remove_one to btrfs_sysfs_remove_mounted (+5/-5)
    Btrfs: rename btrfs_kobj_rm_device to btrfs_sysfs_rm_device_link (+8/-8)
    Btrfs: add btrfs_read_dev_one_super() to read one specific SB (+35/-20)
    Btrfs: SB read failure should return EIO for __bread failure (+19/-7)
    Btrfs: rename btrfs_sysfs_add_one to btrfs_sysfs_add_mounted (+3/-3)
    Btrfs: consolidate btrfs_error() to btrfs_std_error() (+26/-33)
    Btrfs: don't log error from btrfs_get_bdev_and_sb (+0/-1)
    Btrfs: add helper for closing one device (+37/-30)
    Btrfs: rename super_kobj to fsid_kobj (+20/-20)

Josef Bacik (12) commits (+468/-132):
    Btrfs: don't keep trying to build clusters if we are fragmented (+82/-24)
    Btrfs: don't continue setting up space cache when enospc (+20/-0)
    Btrfs: fix prealloc under heavy fragmentation conditions (+9/-0)
    Btrfs: change how we wait for pending ordered extents (+60/-64)
    Btrfs: don't do extra bitmap search in one bit case (+15/-13)
    Btrfs: keep track of max_extent_size per space_info (+34/-1)
    Btrfs: keep track of largest extent in bitmaps (+39/-1)
    Btrfs: cut down on loops through the allocator (+36/-3)
    Btrfs: add a flags field to btrfs_transaction (+16/-18)
    Btrfs: don't loop in allocator for space cache (+1/-1)
    Btrfs: add fragment=* debug mount option (+150/-7)
    Btrfs: fix qgroup sanity tests (+6/-0)

Alexandru Moise (8) commits (+30/-46):
    btrfs: use a single if() statement for one outcome in get_block_rsv() (+3/-7)
    btrfs: declare rsv_count as unsigned int instead of int (+1/-1)
    btrfs: change num_items type from u64 to unsigned int (+8/-6)
    btrfs: cleanup btrfs_balance profile validity checks (+12/-9)
    btrfs: trimming some start_transaction() code away (+1/-14)
    btrfs: memset cur_trans->delayed_refs to zero (+2/-6)
    btrfs: Fixed dsize and last_off declarations (+2/-2)
    btrfs: Fixed declaration of old_len (+1/-1)

Filipe Manana (7) commits (+583/-220):
    Btrfs: fix file corruption and data loss after cloning inline extents (+152/-43)
    Btrfs: send, fix file corruption due to incorrect cloning operations (+173/-27)
    Btrfs: fix regression running delayed references when using qgroups (+44/-134)
    Btrfs: fix double range unlock of hole region when reading page (+6/-2)
    Btrfs: fix hole punching when using the no-holes feature (+13/-0)
    Btrfs: fix truncation of compressed and inlined extents (+68/-14)
    Btrfs: fix regression when running delayed references (+127/-0)

Byongho Lee (4) commits (+55/-56):
    btrfs: compress: put variables defined per compress type in struct to make cache friendly (+48/-46)
    btrfs: replace unnecessary list_for_each_entry_safe to list_for_each_entry (+1/-2)
    btrfs: cleanup iterating over prop_handlers array (+6/-7)
    btrfs: remove unnecessary list_del (+0/-1)

Zhao Lei (3) commits (+125/-98):
    btrfs: use btrfs_raid_array for btrfs_get_num_tolerated_disk_barrier_failures() (+30/-13)
    btrfs: use btrfs_raid_array in btrfs_reduce_alloc_profile (+22/-26)
    btrfs: Move btrfs_raid_array to public (+73/-59)

Luis de Bethencourt (2) commits (+7/-5):
    btrfs: check-integrity: Fix returned errno codes (+2/-2)
    btrfs: reada: Fix returned errno code (+5/-3)

chandan (1) commits (+6/-1):
    Btrfs: find_free_extent: Do not erroneously skip LOOP_CACHING_WAIT state

Liu Bo (1) commits (+4/-4):
    Btrfs: move kobj stuff out of dev_replace lock range

Shan Hai (1) commits (+0/-3):
    btrfs/file.c: remove an unsed varialbe first_index

Chris Mason (1) commits (+3/-5):
    btrfs: fix use after free iterating extrefs

Robin Ruede (1) commits (+8/-2):
    btrfs: fix resending received snapshot with parent

Geliang Tang (1) commits (+1/-1):
    btrfs: fix a comment typo

Jiri Kosina (1) commits (+1/-0):
    btrfs: clear PF_NOFREEZE in cleaner_kthread()

Gabríel Arthúr Pétursson (1) commits (+37/-2):
    btrfs: add balance filter for stripes

Chandan Rajendra (1) commits (+2/-2):
    Btrfs: btrfs_submit_bio_hook: Use btrfs_wq_endio_type values instead of integer constants

Total: (100) commits (+2959/-1248)

 fs/btrfs/backref.c                |  14 +-
 fs/btrfs/check-integrity.c        |   8 +-
 fs/btrfs/compression.c            |  97 ++++---
 fs/btrfs/ctree.c                  |  10 +-
 fs/btrfs/ctree.h                  | 180 ++++++++++--
 fs/btrfs/delayed-inode.c          |   4 +
 fs/btrfs/delayed-ref.c            | 190 +++++++++++--
 fs/btrfs/delayed-ref.h            |  23 +-
 fs/btrfs/dev-replace.c            |  55 ++--
 fs/btrfs/disk-io.c                | 166 ++++++-----
 fs/btrfs/disk-io.h                |   2 +
 fs/btrfs/extent-tree.c            | 572 ++++++++++++++++++++++++++++----------
 fs/btrfs/extent_io.c              | 155 ++++++++---
 fs/btrfs/extent_io.h              |  19 ++
 fs/btrfs/file.c                   | 228 ++++++++++-----
 fs/btrfs/free-space-cache.c       |  79 ++++--
 fs/btrfs/free-space-cache.h       |   1 +
 fs/btrfs/inode-item.c             |   2 +-
 fs/btrfs/inode-map.c              |   6 +-
 fs/btrfs/inode.c                  | 194 ++++++++++---
 fs/btrfs/ioctl.c                  | 285 +++++++++++--------
 fs/btrfs/locking.c                |  12 +
 fs/btrfs/ordered-data.c           |  70 ++++-
 fs/btrfs/ordered-data.h           |   2 +
 fs/btrfs/props.c                  |  13 +-
 fs/btrfs/qgroup.c                 | 229 +++++++++++++--
 fs/btrfs/qgroup.h                 |  31 ++-
 fs/btrfs/raid56.c                 |   6 +-
 fs/btrfs/reada.c                  |   8 +-
 fs/btrfs/relocation.c             |  26 +-
 fs/btrfs/root-tree.c              |  11 +-
 fs/btrfs/scrub.c                  |  42 +--
 fs/btrfs/send.c                   | 212 ++++++++++++--
 fs/btrfs/super.c                  |  57 ++--
 fs/btrfs/sysfs.c                  |  52 ++--
 fs/btrfs/sysfs.h                  |   4 +-
 fs/btrfs/tests/free-space-tests.c |  22 +-
 fs/btrfs/transaction.c            | 129 +++------
 fs/btrfs/transaction.h            |  20 +-
 fs/btrfs/tree-log.c               |  24 +-
 fs/btrfs/volumes.c                | 427 ++++++++++++++++++----------
 fs/btrfs/volumes.h                |  24 +-
 include/trace/events/btrfs.h      | 113 ++++++++
 include/uapi/linux/btrfs.h        |  31 ++-
 44 files changed, 2783 insertions(+), 1072 deletions(-)
