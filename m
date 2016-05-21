Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:55727 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751209AbcEUOSI (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 21 May 2016 10:18:08 -0400
Date: Sat, 21 May 2016 10:18:00 -0400
From: Chris Mason <clm@fb.com>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        btrfs <linux-btrfs@vger.kernel.org>
Subject: [GIT PULL] Btrfs
Message-ID: <20160521141800.ltid3ll6m6ligy4h@floor.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Linus,

My for-linus-4.7 branch:

git://git.kernel.org/pub/scm/linux/kernel/git/mason/linux-btrfs.git for-linus-4.7

Has our merge window series of cleanups and fixes.  These target a wide
range of issues, but do include some important fixes for qgroups,
O_DIRECT, and fsync handling.   Jeff Mahoney moved around a few
definitions to make them easier for userland to consume.

Also whiteout support is included now that issues with overlayfs have
been cleared up.

I have one more fix pending for page faults during btrfs_copy_from_user,
but I wanted to get this bulk out the door first.

David Sterba (28) commits (+343/-247):
    btrfs: introduce raid-type to error-code table, for minimum device constraint (+16/-1)
    btrfs: switch to common message helpers in open_ctree, adjust messages (+50/-52)
    btrfs: reuse existing variable in scrub_stripe, reduce stack usage (+9/-10)
    btrfs: send: use vmalloc only as fallback for clone_sources_tmp (+8/-5)
    btrfs: pass number of devices to btrfs_check_raid_min_devices (+20/-15)
    btrfs: use dynamic allocation for root item in create_subvol (+37/-28)
    btrfs: use existing device constraints table btrfs_raid_array (+9/-14)
    btrfs: clone: use vmalloc only as fallback for nodesize bufer (+8/-5)
    btrfs: send: use temporary variable to store allocation size (+8/-6)
    btrfs: make find_workspace warn if there are no workspaces (+14/-0)
    btrfs: rename and document compression workspace members (+19/-16)
    btrfs: send: use vmalloc only as fallback for clone_roots (+7/-4)
    btrfs: add read-only check to sysfs handler of features (+3/-0)
    btrfs: send: use vmalloc only as fallback for read_buf (+7/-4)
    btrfs: send: use vmalloc only as fallback for send_buf (+7/-4)
    btrfs: ioctl: reorder exclusive op check in RM_DEV (+11/-12)
    btrfs: ioctl: reorder exclusive op check in RM_DEV (+11/-12)
    btrfs: add write protection to SET_FEATURES ioctl (+13/-3)
    btrfs: kill unused writepage_io_hook callback (+16/-24)
    btrfs: rename btrfs_find_device_by_user_input (+13/-10)
    btrfs: build fixup for qgroup_account_snapshot (+5/-0)
    btrfs: sysfs: protect reading label by lock (+7/-1)
    btrfs: make find_workspace always succeed (+12/-8)
    btrfs: preallocate compression workspaces (+16/-0)
    btrfs: add check to sysfs handler of label (+3/-0)
    btrfs: rename __check_raid_min_devices (+2/-2)
    btrfs: GFP_NOFS does not GFP_HIGHMEM (+4/-4)
    btrfs: rename flags for vol args v2 (+8/-7)

Anand Jain (20) commits (+449/-381):
    btrfs: fix lock dep warning, move scratch dev out of device_list_mutex and uuid_mutex (+12/-5)
    btrfs: fix lock dep warning move scratch super outside of chunk_mutex (+5/-4)
    btrfs: make use of btrfs_scratch_superblocks() in btrfs_rm_device() (+13/-64)
    btrfs: enhance btrfs_find_device_by_user_input() to check device path (+3/-4)
    btrfs: cleanup assigning next active device with a check (+48/-22)
    btrfs: create helper function __check_raid_min_devices() (+32/-19)
    btrfs: create helper btrfs_find_device_by_user_input() (+23/-23)
    btrfs: clean up and optimize __check_raid_min_device() (+19/-24)
    btrfs: create a helper function to read the disk super (+52/-35)
    btrfs: rename btrfs_std_error to btrfs_handle_fs_error (+31/-31)
    btrfs: pass the right error code to the btrfs_std_error (+2/-2)
    btrfs: make use of btrfs_find_device_by_user_input() (+37/-63)
    btrfs: move error handling code together in ctree.h (+40/-38)
    btrfs: refactor btrfs_dev_replace_start for reuse (+41/-23)
    btrfs: s_bdev is not null after missing replace (+6/-3)
    btrfs: remove unused function btrfs_assert() (+0/-1)
    btrfs: introduce device delete by devid (+73/-5)
    btrfs: optimize check for stale device (+2/-1)
    btrfs: remove save_error_info() (+6/-10)
    btrfs: use fs_info directly (+4/-4)

Filipe Manana (13) commits (+404/-180):
    Btrfs: fix race between fsync and direct IO writes for prealloc extents (+37/-6)
    Btrfs: fix empty symlink after creating symlink and fsync parent dir (+1/-1)
    Btrfs: add semaphore to synchronize direct IO writes with fsync (+77/-118)
    Btrfs: fix inode leak on failure to setup whiteout inode in rename (+6/-6)
    Btrfs: fix for incorrect directory entries after fsync log replay (+8/-5)
    Btrfs: fix race between block group relocation and nocow writes (+81/-1)
    Btrfs: fix number of transaction units for renames with whiteout (+8/-1)
    Btrfs: don't wait for unrelated IO to finish before relocation (+38/-19)
    Btrfs: pin logs earlier when doing a rename exchange operation (+4/-4)
    Btrfs: don't do unnecessary delalloc flushes when relocating (+79/-7)
    Btrfs: unpin logs if rename exchange operation fails (+36/-2)
    Btrfs: unpin log if rename operation fails (+27/-1)
    Btrfs: pin log earlier when renaming (+2/-9)

Jeff Mahoney (8) commits (+1161/-1090):
    btrfs: uapi/linux/btrfs.h migration, move struct btrfs_ioctl_defrag_range_args (+37/-32)
    btrfs: uapi/linux/btrfs_tree.h migration, item types and defines (+967/-948)
    btrfs: uapi/linux/btrfs.h migration, document subvol flags (+14/-3)
    btrfs: uapi/linux/btrfs.h migration, move BTRFS_LABEL_SIZE (+1/-1)
    btrfs: uapi/linux/btrfs.h migration, move balance flags (+64/-46)
    btrfs: uapi/linux/btrfs.h migration, move feature flags (+31/-25)
    btrfs: uapi/linux/btrfs.h migration, qgroup limit flags (+21/-9)
    btrfs: uapi/linux/btrfs_tree.h, use __u8 and __u64 (+26/-26)

Liu Bo (4) commits (+39/-15):
    Btrfs: make mapping->writeback_index point to the last written page (+26/-6)
    Btrfs: do not create empty block group if we have allocated data (+8/-1)
    Btrfs: cleanup error handling in extent_write_cached_pages (+2/-5)
    Btrfs: fix divide error upon chunk's stripe_len (+3/-3)

Luis de Bethencourt (3) commits (+25/-11):
    btrfs: fix mixed block count of available space (+13/-3)
    btrfs: avoid overflowing f_bfree (+5/-1)
    btrfs: fix typos in comments (+7/-7)

Scott Talbert (1) commits (+2/-0):
    btrfs: fix memory leak during RAID 5/6 device replacement

Adam Borowski (1) commits (+1/-1):
    btrfs: fix int32 overflow in shrink_delalloc().

Luke Dashjr (1) commits (+24/-2):
    btrfs: bugfix: handle FS_IOC32_{GETFLAGS,SETFLAGS,GETVERSION} in btrfs_ioctl

Satoru Takeuchi (1) commits (+3/-3):
    btrfs: Simplify conditions about compress while mapping btrfs flags to inode flags

Ashish Samant (1) commits (+1/-1):
    btrfs: Fix BUG_ON condition in scrub_setup_recheck_block()

Zygo Blaxell (1) commits (+15/-3):
    btrfs: don't force mounts to wait for cleaner_kthread to delete one or more subvolumes

Vincent Stehlé (1) commits (+1/-1):
    Btrfs: fix fspath error deallocation

Qu Wenruo (1) commits (+105/-24):
    btrfs: qgroup: Fix qgroup accounting when creating snapshot

Dan Carpenter (1) commits (+6/-0):
    btrfs: send: silence an integer overflow warning

Geert Uytterhoeven (1) commits (+20/-21):
    Btrfs: Refactor btrfs_lock_cluster() to kill compiler warning

Josef Bacik (1) commits (+16/-2):
    Btrfs: remove BUG_ON()'s in btrfs_map_block

Chandan Rajendra (1) commits (+3/-1):
    Btrfs: __btrfs_buffered_write: Pass valid file offset when releasing delalloc space

Dan Fuhry (1) commits (+257/-7):
    btrfs: add support for RENAME_EXCHANGE and RENAME_WHITEOUT

Austin S. Hemmelgarn (1) commits (+2/-4):
    btrfs: allow balancing to dup with multi-device

Total: (90) commits (+2877/-1994)

 fs/btrfs/backref.c              |    2 +-
 fs/btrfs/btrfs_inode.h          |   10 +
 fs/btrfs/compression.c          |   85 ++-
 fs/btrfs/ctree.c                |    6 +-
 fs/btrfs/ctree.h                | 1123 +++------------------------------------
 fs/btrfs/delayed-inode.c        |    2 +-
 fs/btrfs/dev-replace.c          |  101 ++--
 fs/btrfs/dev-replace.h          |    4 +-
 fs/btrfs/disk-io.c              |  130 ++---
 fs/btrfs/extent-tree.c          |  167 +++++-
 fs/btrfs/extent_io.c            |   82 +--
 fs/btrfs/extent_io.h            |    1 -
 fs/btrfs/file.c                 |    6 +-
 fs/btrfs/inode-item.c           |    2 +-
 fs/btrfs/inode.c                |  466 +++++++++++++---
 fs/btrfs/ioctl.c                |  198 +++++--
 fs/btrfs/ordered-data.c         |   26 +-
 fs/btrfs/ordered-data.h         |    6 +-
 fs/btrfs/relocation.c           |   13 +-
 fs/btrfs/root-tree.c            |    4 +-
 fs/btrfs/scrub.c                |   25 +-
 fs/btrfs/send.c                 |   62 ++-
 fs/btrfs/super.c                |   60 ++-
 fs/btrfs/sysfs.c                |   14 +-
 fs/btrfs/transaction.c          |  138 ++++-
 fs/btrfs/tree-log.c             |   74 +--
 fs/btrfs/volumes.c              |  454 +++++++++-------
 fs/btrfs/volumes.h              |   57 +-
 include/uapi/linux/btrfs.h      |  188 ++++++-
 include/uapi/linux/btrfs_tree.h |  966 +++++++++++++++++++++++++++++++++
 30 files changed, 2678 insertions(+), 1794 deletions(-)
