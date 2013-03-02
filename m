Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:27251 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751487Ab3CBPnf (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sat, 2 Mar 2013 10:43:35 -0500
Date: Sat, 2 Mar 2013 23:41:53 +0800
From: Liu Bo <bo.li.liu@oracle.com>
To: Chris Mason <chris.mason@fusionio.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [GIT PULL] Btrfs
Message-ID: <20130302154149.GA7352@liubo>
Reply-To: bo.li.liu@oracle.com
References: <20130302151535.GD28634@shiny.masoncoding.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20130302151535.GD28634@shiny.masoncoding.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, Mar 02, 2013 at 10:15:35AM -0500, Chris Mason wrote:
> Hi everyone,
> 
> Our set of btrfs features, fixes and cleanups are in my for-linus
> branch:
> 
> git://git.kernel.org/pub/scm/linux/kernel/git/mason/linux-btrfs.git for-linus
> 
> There is a conflict in fs/btrfs/extent-tree.c, which I merged here:
> 
> git://git.kernel.org/pub/scm/linux/kernel/git/mason/linux-btrfs.git for-linus-merged
> 
> The merge is basically combining da633a42170165cbf20a2d3886c7480ccc832ec3 from
> my tree with the new writeback_inodes_sb function from the writeback
> tree.
> 
> The biggest feature in the pull is the new (and still experimental)
> raid56 code that David Woodhouse started long ago.  I'm still working
> on the parity logging setup that will avoid inconsistent parity after a
> crash, so this is only for testing right now.  But, I'd really like to
> get it out to a broader audience to hammer out any performance issues or
> other problems.
> 
> scrub does not yet correct errors on raid5/6 either.
> 
> Josef has another pass at fsync performance.  The big change here is to
> combine waiting for metadata with waiting for data, which is a big
> latency win.  It is also step one toward using atomics from the hardware
> during a commit.
> 
> Mark Fasheh has a new way to use btrfs send/receive to send only the
> metadata changes.  SUSE is using this to make snapper more efficient at
> finding changes between snapshosts.
> 
> Otherwise we have a large number of fixes and cleanups.  Eric Sandeen
> wins the award for removing the most lines, and I'm hoping we steal this
> idea from XFS over and over again.

To people who cares about snapshot-aware defrag, this feature is also included
in the pull.

thanks,
liubo

> 
> Miao Xie (35) commits (+958/-427):
>     Btrfs: use seqlock to protect fs_info->avail_{data, metadata, system}_alloc_bits (+49/-32)
>     Btrfs: remove unnecessary dget_parent/dput when creating the pending snapshot (+8/-8)
>     Btrfs: cleanup unnecessary clear when freeing a transaction or a trans handle (+0/-2)
>     Btrfs: fix missing release of qgroup reservation in commit_transaction() (+8/-0)
>     Btrfs: fix the deadlock between the transaction start/attach and commit (+16/-1)
>     Btrfs: fix wrong reserved space in qgroup during snap/subv creation (+105/-36)
>     Btrfs: fix wrong reserved space when deleting a snapshot/subvolume (+19/-2)
>     Btrfs: check the return value of btrfs_run_ordered_operations() (+2/-2)
>     Btrfs: fix lots of orphan inodes when the space is not enough (+85/-17)
>     Btrfs: check the return value of btrfs_start_delalloc_inodes() (+8/-2)
>     Btrfs: use the inode own lock to protect its delalloc_bytes (+37/-13)
>     Btrfs: fix the qgroup reserved space is released prematurely (+2/-1)
>     Btrfs: don't traverse the ordered operation list repeatedly (+5/-14)
>     Btrfs: fix wrong outstanding_extents when doing DIO write (+9/-11)
>     Btrfs: flush all dirty inodes if writeback can not start (+31/-9)
>     Btrfs: use percpu counter for fs_info->delalloc_bytes (+26/-11)
>     Btrfs: fix the race between bio and btrfs_stop_workers (+1/-2)
>     Btrfs: fix memory leak of pending_snapshot->inherit (+7/-11)
>     Btrfs: use percpu counter for dirty metadata count (+42/-40)
>     Btrfs: use slabs for delayed reference allocation (+115/-21)
>     Btrfs: serialize unlocked dio reads with truncate (+40/-2)
>     Btrfs: traverse and flush the delalloc inodes once (+1/-8)
>     Btrfs: make delayed ref lock logic more readable (+38/-18)
>     Btrfs: fix trivial error in btrfs_ioctl_resize() (+7/-6)
>     Btrfs: cleanup similar code in delayed inode (+37/-46)
>     Btrfs: use common work instead of delayed work (+4/-4)
>     Btrfs: add a comment for fs_info->max_inline (+6/-0)
>     Btrfs: make raid attr array more readable (+59/-20)
>     Btrfs: use bit operation for ->fs_state (+14/-12)
>     Btrfs: fix deadlock due to unsubmitted (+43/-41)
>     Btrfs: implement unlocked dio write (+23/-12)
>     Btrfs: protect fs_info->alloc_start (+14/-0)
>     Btrfs: fix uncompleted transaction (+37/-3)
>     Btrfs: fix remount vs autodefrag (+45/-2)
>     Btrfs: use wrapper page_offset (+15/-18)
> 
> Josef Bacik (21) commits (+480/-135):
>     Btrfs: if we aren't committing just end the transaction if we error out (+12/-6)
>     Btrfs: do not overcommit if we don't have enough space for global rsv (+19/-2)
>     Revert "Btrfs: fix permissions of empty files not affected by umask" (+0/-6)
>     Btrfs: rework the overcommit logic to be based on the total size (+12/-3)
>     Btrfs: fix freeing delayed ref head while still holding its mutex (+5/-3)
>     Btrfs: steal from global reserve if we are cleaning up orphans (+16/-5)
>     Btrfs: fix how we discard outstanding ordered extents on abort (+7/-26)
>     Btrfs: delete inline extents when we find them during logging (+18/-0)
>     Btrfs: wait on ordered extents at the last possible moment (+247/-9)
>     Btrfs: place ordered operations on a per transaction list (+34/-21)
>     Btrfs: unreserve space if our ordered extent fails to work (+13/-1)
>     Btrfs: copy everything if we've created an inline extent (+1/-0)
>     Btrfs: account for orphan inodes properly during cleanup (+1/-0)
>     Btrfs: handle errors in compression submission path (+28/-10)
>     Btrfs: remove extent mapping if we fail to add chunk (+12/-2)
>     Btrfs: relax the block group size limit for bitmaps (+9/-3)
>     Btrfs: cleanup orphan reservation if truncate fails (+2/-0)
>     Btrfs: make sure NODATACOW also gets NODATASUM set (+2/-1)
>     Btrfs: don't re-enter when allocating a chunk (+9/-0)
>     Btrfs: remove unused extent io tree ops V2 (+11/-27)
>     Btrfs: fix chunk allocation error handling (+22/-10)
> 
> Liu Bo (14) commits (+796/-109):
>     Btrfs: kill unused argument of btrfs_pin_extent_for_log_replay (+3/-6)
>     Btrfs: fix cleaner thread not working with inode cache option (+8/-1)
>     Btrfs: use token to avoid times mapping extent buffer (+35/-28)
>     Btrfs: extend the checksum item as much as possible (+46/-21)
>     Btrfs: fix NULL pointer after aborting a transaction (+7/-1)
>     Btrfs: use reserved space for creating a snapshot (+2/-0)
>     Btrfs: kill unused argument of update_block_group (+5/-7)
>     Btrfs: kill unused arguments of cache_block_group (+5/-8)
>     Btrfs: do not change inode flags in rename (+0/-25)
>     Btrfs: record first logical byte in memory (+20/-1)
>     Btrfs: fix memory leak of log roots (+9/-2)
>     Btrfs: remove deprecated comments (+0/-6)
>     Btrfs: snapshot-aware defrag (+654/-0)
>     Btrfs: save us a read_lock (+2/-3)
> 
> Eric Sandeen (11) commits (+58/-108):
>     btrfs: ensure we don't overrun devices_info[] in __btrfs_alloc_chunk (+5/-1)
>     btrfs: remove unused "item" in btrfs_insert_delayed_item() (+0/-2)
>     btrfs: remove unused fs_info from btrfs_decode_error() (+4/-5)
>     btrfs: remove cache only arguments from defrag path (+32/-82)
>     btrfs: remove unnecessary DEFINE_WAIT() declarations (+0/-2)
>     btrfs: annotate intentional switch case fallthroughs (+2/-0)
>     btrfs: add missing break in btrfs_print_leaf() (+1/-0)
>     btrfs: remove unused fd in btrfs_ioctl_send() (+0/-3)
>     btrfs: handle null fs_info in btrfs_panic() (+7/-4)
>     btrfs: fix varargs in __btrfs_std_error (+7/-7)
>     btrfs: list_entry can't return NULL (+0/-2)
> 
> Chris Mason (7) commits (+561/-30):
>     Btrfs: reduce CPU contention while waiting for delayed extent operations (+70/-5)
>     Btrfs: remove conflicting check for minimum number of devices in raid56 (+0/-8)
>     Btrfs: reduce lock contention on extent buffer locks (+16/-0)
>     Btrfs: add a plugging callback to raid56 writes (+124/-4)
>     Btrfs: fix cluster alignment for mount -o ssd (+6/-1)
>     Btrfs: fix max chunk size on raid5/6 (+21/-4)
>     Btrfs: Add a stripe cache to raid56 (+324/-8)
> 
> Wang Shilong (6) commits (+78/-68):
>     Btrfs: remove reduplicate check about root in the function btrfs_clean_quota_tree (+0/-3)
>     Btrfs: cleanup to make the function btrfs_delalloc_reserve_metadata more logic (+38/-44)
>     Btrfs: return ENOMEM rather than use BUG_ON when btrfs_alloc_path fails (+9/-3)
>     Btrfs: don't call btrfs_qgroup_free if just btrfs_qgroup_reserve fails (+6/-5)
>     Btrfs: fix missing deleted items in btrfs_clean_quota_tree (+21/-13)
>     Btrfs: fix missing check before disabling quota (+4/-0)
> 
> David Sterba (6) commits (+131/-42):
>     btrfs: access superblock via pagecache in scan_one_device (+64/-6)
>     btrfs: put some enospc messages under enospc_debug (+15/-11)
>     btrfs: try harder to allocate raid56 stripe cache (+26/-7)
>     btrfs: use only inline_pages from extent buffer (+7/-17)
>     btrfs: remove a printk from scan_one_device (+0/-1)
>     btrfs: add cancellation points to defrag (+19/-0)
> 
> Zach Brown (2) commits (+9/-12):
>     btrfs: limit fallocate extent reservation to 256MB (+4/-3)
>     btrfs: define BTRFS_MAGIC as a u64 value (+5/-9)
> 
> David Woodhouse (2) commits (+2294/-113):
>     Btrfs: add rw argument to merge_bio_hook() (+11/-11)
>     Btrfs: RAID5 and RAID6 (+2283/-102)
> 
> Ilya Dryomov (2) commits (+6/-6):
>     Btrfs: allow for selecting only completely empty chunks (+1/-1)
>     Btrfs: eliminate a use-after-free in btrfs_balance() (+5/-5)
> 
> jeff.liu (2) commits (+67/-0):
>     Btrfs: Add a new ioctl to get the label of a mounted file system (+23/-0)
>     Btrfs: set/change the label of a mounted file system (+44/-0)
> 
> Filipe Brandenburger (1) commits (+19/-11):
>     Btrfs: move fs/btrfs/ioctl.h to include/uapi/linux/btrfs.h
> 
> Mark Fasheh (1) commits (+54/-4):
>     btrfs: add "no file data" flag to btrfs send ioctl
> 
> Alexandre Oliva (1) commits (+3/-3):
>     clear chunk_alloc flag on retryable failure
> 
> Thomas Gleixner (1) commits (+1/-0):
>     btrfs: Init io_lock after cloning btrfs device struct
> 
> Paul Gortmaker (1) commits (+1/-4):
>     btrfs: fixup/remove module.h usage as required
> 
> Tomasz Torcz (1) commits (+1/-0):
>     Btrfs: select XOR_BLOCKS in Kconfig
> 
> Jan Schmidt (1) commits (+1/-4):
>     Btrfs: fix backref walking race with tree deletions
> 
> Qu Wenruo (1) commits (+25/-38):
>     btrfs: cleanup for open-coded alignment
> 
> Kusanagi Kouichi (1) commits (+1/-1):
>     Btrfs: Check CAP_DAC_READ_SEARCH for BTRFS_IOC_INO_PATHS
> 
> Arne Jansen (1) commits (+1/-1):
>     Btrfs: fix crash in log replay with qgroups enabled
> 
> Total: (118) commits
> 
>  fs/btrfs/Kconfig            |    3 +
>  fs/btrfs/Makefile           |    2 +-
>  fs/btrfs/backref.c          |    5 +-
>  fs/btrfs/backref.h          |    2 +-
>  fs/btrfs/btrfs_inode.h      |   20 +
>  fs/btrfs/check-integrity.c  |    3 +-
>  fs/btrfs/compression.c      |    4 +-
>  fs/btrfs/ctree.c            |   68 +-
>  fs/btrfs/ctree.h            |  150 +++-
>  fs/btrfs/delayed-inode.c    |  147 ++-
>  fs/btrfs/delayed-inode.h    |    1 +
>  fs/btrfs/delayed-ref.c      |   82 +-
>  fs/btrfs/delayed-ref.h      |   52 +-
>  fs/btrfs/dev-replace.c      |    6 +-
>  fs/btrfs/disk-io.c          |  227 +++--
>  fs/btrfs/disk-io.h          |    7 +
>  fs/btrfs/extent-tree.c      |  591 ++++++++----
>  fs/btrfs/extent_io.c        |  138 ++-
>  fs/btrfs/extent_io.h        |    8 +-
>  fs/btrfs/extent_map.c       |    1 -
>  fs/btrfs/file-item.c        |   67 +-
>  fs/btrfs/file.c             |   57 +-
>  fs/btrfs/free-space-cache.c |   62 +-
>  fs/btrfs/inode.c            | 1064 ++++++++++++++++++----
>  fs/btrfs/ioctl.c            |  211 ++++-
>  fs/btrfs/ioctl.h            |  502 -----------
>  fs/btrfs/locking.c          |    5 +-
>  fs/btrfs/ordered-data.c     |   98 +-
>  fs/btrfs/ordered-data.h     |   14 +-
>  fs/btrfs/print-tree.c       |    1 +
>  fs/btrfs/qgroup.c           |   55 +-
>  fs/btrfs/raid56.c           | 2099 +++++++++++++++++++++++++++++++++++++++++++
>  fs/btrfs/raid56.h           |   51 ++
>  fs/btrfs/relocation.c       |    2 +-
>  fs/btrfs/scrub.c            |   10 +-
>  fs/btrfs/send.c             |   53 +-
>  fs/btrfs/send.h             |    1 +
>  fs/btrfs/super.c            |   89 +-
>  fs/btrfs/sysfs.c            |    1 -
>  fs/btrfs/transaction.c      |  151 +++-
>  fs/btrfs/transaction.h      |    8 +-
>  fs/btrfs/tree-defrag.c      |   19 +-
>  fs/btrfs/tree-log.c         |  166 +++-
>  fs/btrfs/ulist.c            |    2 +-
>  fs/btrfs/volumes.c          |  636 ++++++++++---
>  fs/btrfs/volumes.h          |   11 +-
>  include/linux/btrfs.h       |    6 +
>  include/uapi/linux/Kbuild   |    1 +
>  include/uapi/linux/btrfs.h  |  514 +++++++++++
>  49 files changed, 5950 insertions(+), 1523 deletions(-)
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
