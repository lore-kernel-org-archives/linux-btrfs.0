Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-it0-f68.google.com ([209.85.214.68]:36063 "EHLO
        mail-it0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1437728AbdDZPGb (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 26 Apr 2017 11:06:31 -0400
Received: by mail-it0-f68.google.com with SMTP id x188so839126itb.3
        for <linux-btrfs@vger.kernel.org>; Wed, 26 Apr 2017 08:06:31 -0700 (PDT)
MIME-Version: 1.0
Reply-To: fdmanana@gmail.com
In-Reply-To: <cover.1492601450.git.dsterba@suse.com>
References: <cover.1492601450.git.dsterba@suse.com>
From: Filipe Manana <fdmanana@gmail.com>
Date: Wed, 26 Apr 2017 16:06:29 +0100
Message-ID: <CAL3q7H6dNZ1SShz6iaHYeqMQ+PCAKPzetMuRm+8MVA-8h2E0MA@mail.gmail.com>
Subject: Re: [PULL] Btrfs, updates for 4.12
To: David Sterba <dsterba@suse.com>
Cc: Chris Mason <clm@fb.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Apr 19, 2017 at 12:35 PM, David Sterba <dsterba@suse.com> wrote:
> Hi,
>
> this is the main part of my 4.12 pull, condensed changelog below. I might send
> another pull with low-risk patches, mostly cleanups, but so far I'm done with
> base testing now. We had a high-churn cycle last time, so this could be small
> one and we can concentrate on testing & fixing the raid56 updates.
>
> The qgroup patches have been in for-next but I haven't seen any new review for
> the core part.
>
> Updates:
> * raid56:
>   * fix mirror name in warning message after repair
>   * scrub fixes: calculate parity correctly
>   * scrub recheck and dev replace race fix
>   * enabled auto-repair during read
>   * fix warnings during recovery, due to races, bogus reports can appear
> * switch to refcount_t where atomic_t was used for plain refcounting
> * new and updated tracepoints
> * split __btrfs_map_block, clean up
> * minor qgroup fixes
> * usual cleanups
>
> ----------------------------------------------------------------
> The following changes since commit 4f7d029b9bf009fbee76bb10c0c4351a1870d2f3:
>
>   Linux 4.11-rc7 (2017-04-16 13:00:18 -0700)
>
> are available in the git repository at:
>
>   git://git.kernel.org/pub/scm/linux/kernel/git/kdave/linux.git for-chris-4.12
>
> for you to fetch changes up to c2a9c7ab475bc3aaf06521a39ac65bc48c8cad4f:
>
>   btrfs: check if the device is flush capable (2017-04-18 16:13:27 +0200)
>
> ----------------------------------------------------------------
> Adam Borowski (1):
>       btrfs: fix a bogus warning when converting only data or metadata
>
> Anand Jain (3):
>       btrfs: use q which is already obtained from bdev_get_queue
>       btrfs: delete unused member nobarriers
>       btrfs: check if the device is flush capable
>
> Dan Carpenter (1):
>       Btrfs: handle only applicable errors returned by btrfs_get_extent
>
> David Sterba (12):
>       btrfs: preallocate radix tree node for readahead
>       btrfs: preallocate radix tree node for global readahead tree
>       btrfs: remove redundant parameter from btree_readahead_hook
>       btrfs: remove redundant parameter from reada_find_zone
>       btrfs: remove redundant parameter from reada_start_machine_dev
>       btrfs: remove local blocksize variable in reada_find_extent
>       btrfs: remove unused qgroup members from btrfs_trans_handle
>       btrfs: track exclusive filesystem operation in flags
>       btrfs: sink GFP flags parameter to tree_mod_log_insert_move
>       btrfs: sink GFP flags parameter to tree_mod_log_insert_root
>       btrfs: drop redundant parameters from btrfs_map_sblock
>       btrfs: use clear_page where appropriate

Hi,

Did you actually ran xfstests with those readahead patches to
preallocate radix tree nodes?

With those 2 patches applied (Chris' for-linus.4,12 branch) this
breaks things and many btrfs specific tests (at least, since I can't
get pass them) result in tons of traces like the following in a debug
kernel:

[ 8180.696804] BUG: sleeping function called from invalid context at
mm/slab.h:432
[ 8180.703584] in_atomic(): 1, irqs_disabled(): 0, pid: 28583, name: btrfs
[ 8180.724146] 2 locks held by btrfs/28583:
[ 8180.726427]  #0:  (sb_writers#12){.+.+.+}, at: [<ffffffff811c1e33>]
mnt_want_write_file+0x25/0x4d
[ 8180.736742]  #1:  (&(&fs_info->reada_lock)->rlock){+.+.+.}, at:
[<ffffffffa02306eb>] reada_add_block+0x2fe/0x6cd [btrfs]
[ 8180.766321] Preemption disabled at:
[ 8180.766326] [<ffffffff8107ac54>] preempt_count_add+0x65/0x68
[ 8180.794837] CPU: 5 PID: 28583 Comm: btrfs Tainted: G        W
4.11.0-rc8-btrfs-next-39+ #1
[ 8180.798818] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996),
BIOS rel-1.9.1-0-gb3ef39f-prebuilt.qemu-project.org 04/01/2014
[ 8180.798818] Call Trace:
[ 8180.798818]  dump_stack+0x68/0x92
[ 8180.798818]  ? preempt_count_add+0x65/0x68
[ 8180.798818]  ___might_sleep+0x20f/0x226
[ 8180.798818]  __might_sleep+0x77/0x7e
[ 8180.798818]  slab_pre_alloc_hook+0x32/0x4f
[ 8180.798818]  kmem_cache_alloc+0x39/0x233
[ 8180.798818]  ? radix_tree_node_alloc.constprop.12+0x9d/0xdf
[ 8180.798818]  radix_tree_node_alloc.constprop.12+0x9d/0xdf
[ 8180.798818]  __radix_tree_create+0xc3/0x143
[ 8180.798818]  __radix_tree_insert+0x32/0xc0
[ 8180.798818]  reada_add_block+0x318/0x6cd [btrfs]
[ 8180.798818]  btrfs_reada_add+0xf5/0x122 [btrfs]
[ 8180.798818]  scrub_stripe+0x34b/0xdf0 [btrfs]
[ 8180.798818]  ? __lock_acquire+0x69b/0xf38
[ 8180.798818]  ? scrub_chunk+0x48/0x13b [btrfs]
[ 8180.798818]  scrub_chunk+0x10b/0x13b [btrfs]
[ 8180.798818]  ? scrub_chunk+0x10b/0x13b [btrfs]
[ 8180.798818]  scrub_enumerate_chunks+0x31e/0x59b [btrfs]
[ 8180.798818]  ? add_wait_queue+0x44/0x44
[ 8180.798818]  btrfs_scrub_dev+0x2e3/0x494 [btrfs]
[ 8180.798818]  ? __mnt_want_write+0x65/0x7c
[ 8180.798818]  btrfs_ioctl+0x1498/0x1fb9 [btrfs]
[ 8180.798818]  vfs_ioctl+0x21/0x38
[ 8180.945015]  ? vfs_ioctl+0x21/0x38
[ 8180.945015]  do_vfs_ioctl+0x611/0x645
[ 8180.945015]  ? rcu_read_unlock+0x5b/0x5d
[ 8180.945015]  ? __fget+0x6d/0x79
[ 8180.945015]  SyS_ioctl+0x57/0x7b
[ 8180.945015]  entry_SYSCALL_64_fastpath+0x18/0xad
[ 8180.945015] RIP: 0033:0x7f2b83eefc47
[ 8180.945015] RSP: 002b:00007f2b82e0bd68 EFLAGS: 00000246 ORIG_RAX:
0000000000000010
[ 8180.945015] RAX: ffffffffffffffda RBX: ffffffff8109612f RCX: 00007f2b83eefc47
[ 8180.945015] RDX: 00000000008a4df0 RSI: 00000000c400941b RDI: 0000000000000003
[ 8181.012957] RBP: ffffc90003613f98 R08: 00007f2b82e0c700 R09: 0000000000000000
[ 8181.012957] R10: 00007f2b82e0c700 R11: 0000000000000246 R12: 0000000000000046
[ 8181.012957] R13: ffffc90003613f78 R14: 0000000000000000 R15: 00007f2b84e75040

thanks

>
> Deepa Dinamani (1):
>       btrfs: Use ktime_get_real_ts for root ctime
>
> Dmitry V. Levin (1):
>       MAINTAINERS: add btrfs file entries for include directories
>
> Edmund Nadolski (2):
>       btrfs: provide enumeration for __merge_refs mode argument
>       btrfs: replace hardcoded value with SEQ_LAST macro
>
> Elena Reshetova (16):
>       btrfs: convert btrfs_bio.refs from atomic_t to refcount_t
>       btrfs: convert btrfs_transaction.use_count from atomic_t to refcount_t
>       btrfs: convert extent_map.refs from atomic_t to refcount_t
>       btrfs: convert btrfs_ordered_extent.refs from atomic_t to refcount_t
>       btrfs: convert btrfs_caching_control.count from atomic_t to refcount_t
>       btrfs: convert btrfs_delayed_ref_node.refs from atomic_t to refcount_t
>       btrfs: convert btrfs_delayed_node.refs from atomic_t to refcount_t
>       btrfs: convert btrfs_delayed_item.refs from atomic_t to refcount_t
>       btrfs: convert btrfs_root.refs from atomic_t to refcount_t
>       btrfs: convert extent_state.refs from atomic_t to refcount_t
>       btrfs: convert compressed_bio.pending_bios from atomic_t to refcount_t
>       btrfs: convert scrub_recover.refs from atomic_t to refcount_t
>       btrfs: convert scrub_block.refs from atomic_t to refcount_t
>       btrfs: convert scrub_parity.refs from atomic_t to refcount_t
>       btrfs: convert scrub_ctx.refs from atomic_t to refcount_t
>       btrfs: convert btrfs_raid_bio.refs from atomic_t to refcount_t
>
> Goldwyn Rodrigues (2):
>       btrfs: No need to check !(flags & MS_RDONLY) twice
>       btrfs: qgroups: Retry after commit on getting EDQUOT
>
> Hans van Kranenburg (1):
>       Btrfs: consistent usage of types in balance_args
>
> Liu Bo (15):
>       Btrfs: remove ASSERT in btrfs_truncate_inode_items
>       Btrfs: add file item tracepoints
>       Btrfs: create a helper for getting chunk map
>       Btrfs: separate DISCARD from __btrfs_map_block
>       Btrfs: introduce a function to get extra mirror from replace
>       Btrfs: handle operations for device replace separately
>       Btrfs: do not add extra mirror when dev_replace target dev is not available
>       Btrfs: helper for ops that requires full stripe
>       Btrfs: convert BUG_ON to WARN_ON
>       Btrfs: update comments in cache_save_setup
>       Btrfs: set scrub page's io_error if failing to submit io
>       Btrfs: fix wrong failed mirror_num of read-repair on raid56
>       Btrfs: enable repair during read for raid56 profile
>       Btrfs: update scrub_parity to use u64 stripe_len
>       Btrfs: switch to div64_u64 if with a u64 divisor
>
> Qu Wenruo (8):
>       btrfs: qgroup: Add trace point for qgroup reserved space
>       btrfs: qgroup: Re-arrange tracepoint timing to co-operate with reserved space tracepoint
>       btrfs: scrub: Don't append on-disk pages for raid56 scrub
>       btrfs: Wait for in-flight bios before freeing target device for raid56
>       btrfs: Prevent scrub recheck from racing with dev replace
>       btrfs: qgroup: Fix qgroup corruption caused by inode_cache mount option
>       btrfs: scrub: Introduce full stripe lock for RAID56
>       btrfs: scrub: Fix RAID56 recovery race condition
>
>  MAINTAINERS                  |   2 +
>  fs/btrfs/backref.c           |  41 ++-
>  fs/btrfs/compression.c       |  18 +-
>  fs/btrfs/ctree.c             |  20 +-
>  fs/btrfs/ctree.h             |  34 +-
>  fs/btrfs/delayed-inode.c     |  46 +--
>  fs/btrfs/delayed-inode.h     |   6 +-
>  fs/btrfs/delayed-ref.c       |   8 +-
>  fs/btrfs/delayed-ref.h       |   8 +-
>  fs/btrfs/dev-replace.c       |   9 +-
>  fs/btrfs/disk-io.c           |  15 +-
>  fs/btrfs/disk-io.h           |   4 +-
>  fs/btrfs/extent-tree.c       |  35 +-
>  fs/btrfs/extent_io.c         |  59 +--
>  fs/btrfs/extent_io.h         |   3 +-
>  fs/btrfs/extent_map.c        |  10 +-
>  fs/btrfs/extent_map.h        |   3 +-
>  fs/btrfs/file.c              |  16 +-
>  fs/btrfs/free-space-cache.c  |   2 +-
>  fs/btrfs/inode.c             |  47 +--
>  fs/btrfs/ioctl.c             |  33 +-
>  fs/btrfs/ordered-data.c      |  20 +-
>  fs/btrfs/ordered-data.h      |   2 +-
>  fs/btrfs/qgroup.c            | 102 ++----
>  fs/btrfs/qgroup.h            |  51 ++-
>  fs/btrfs/raid56.c            |  38 +-
>  fs/btrfs/reada.c             |  37 +-
>  fs/btrfs/root-tree.c         |   3 +-
>  fs/btrfs/scrub.c             | 331 +++++++++++++++--
>  fs/btrfs/super.c             |   3 +-
>  fs/btrfs/tests/btrfs-tests.c |   1 -
>  fs/btrfs/transaction.c       |  48 ++-
>  fs/btrfs/transaction.h       |   6 +-
>  fs/btrfs/tree-log.c          |   2 +-
>  fs/btrfs/volumes.c           | 856 +++++++++++++++++++++++--------------------
>  fs/btrfs/volumes.h           |   8 +-
>  include/trace/events/btrfs.h | 187 +++++++++-
>  include/uapi/linux/btrfs.h   |  10 +-
>  38 files changed, 1354 insertions(+), 770 deletions(-)
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



-- 
Filipe David Manana,

“Whether you think you can, or you think you can't — you're right.”
