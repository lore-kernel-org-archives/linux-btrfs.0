From: "Niraj kumar" <niraj17@gmail.com>
Subject: Re: [PATCH] fix lockdep warnings
Date: Fri, 31 Oct 2008 09:22:17 +0530
Message-ID: <b82a89170810302052k4c310318l1c86988ca18722d9@mail.gmail.com>
References: <20081030143243.GA31107@unused.rdu.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-btrfs@vger.kernel.org
To: "Josef Bacik" <jbacik@redhat.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20081030143243.GA31107@unused.rdu.redhat.com>
List-ID: <linux-btrfs.vger.kernel.org>

Josef,

I saw this yesterday, but not sure how to reproduce it.
Is this the same warning that this patch fixes ?

---------------------------------

Btrfs loaded
device fsid 51464cf7df326b76-8d5a548c72c2aaa9 devid 1 transid 13 /dev/sdb1
SELinux: initialized (dev sdb1, type btrfs), not configured for labeling

=======================================================
[ INFO: possible circular locking dependency detected ]
2.6.27 #2
-------------------------------------------------------
btrfs-transacti/2651 is trying to acquire lock:
 (&cache->alloc_mutex){--..}, at: [<e0b92387>]
btrfs_add_free_space+0x1c/0x65 [btrfs]

but task is already holding lock:
 (&fs_info->pinned_mutex){--..}, at: [<e0b662fe>]
btrfs_finish_extent_commit+0x20/0xf9 [btrfs]

which lock already depends on the new lock.


the existing dependency chain (in reverse order) is:

-> #1 (&fs_info->pinned_mutex){--..}:
       [<c0447cbb>] validate_chain+0x7fe/0xa43
       [<c0448574>] __lock_acquire+0x674/0x6da
       [<c0448635>] lock_acquire+0x5b/0x81
       [<c064c039>] mutex_lock_nested+0xd1/0x259
       [<e0b62aa6>] add_new_free_space+0x27/0xd3 [btrfs]
       [<e0b62d71>] cache_block_group+0x21f/0x29d [btrfs]
       [<e0b64d25>] find_free_extent+0x239/0x519 [btrfs]
       [<e0b651a1>] __btrfs_reserve_extent+0x19c/0x33b [btrfs]
       [<e0b656c6>] btrfs_alloc_extent+0x40/0xa5 [btrfs]
       [<e0b6577b>] btrfs_alloc_free_block+0x50/0x7a [btrfs]
       [<e0b5d925>] __btrfs_cow_block+0x1bb/0x65d [btrfs]
       [<e0b5e330>] btrfs_cow_block+0x19d/0x1a8 [btrfs]
       [<e0b6099f>] btrfs_search_slot+0x281/0x627 [btrfs]
       [<e0b6c8dd>] btrfs_lookup_inode+0x28/0x86 [btrfs]
       [<e0b7408f>] btrfs_update_inode+0x3d/0xa4 [btrfs]
       [<e0b7488b>] btrfs_dirty_inode+0x3c/0x4b [btrfs]
       [<c04a844f>] __mark_inode_dirty+0x26/0x13f
       [<c04a007a>] touch_atime+0xb6/0xbc
       [<c04992c6>] vfs_readdir+0x7b/0x94
       [<c049933d>] sys_getdents64+0x5e/0xa0
       [<c0403973>] sysenter_do_call+0x12/0x3f
       [<ffffffff>] 0xffffffff

-> #0 (&cache->alloc_mutex){--..}:
       [<c0447a44>] validate_chain+0x587/0xa43
       [<c0448574>] __lock_acquire+0x674/0x6da
       [<c0448635>] lock_acquire+0x5b/0x81
       [<c064c039>] mutex_lock_nested+0xd1/0x259
       [<e0b92387>] btrfs_add_free_space+0x1c/0x65 [btrfs]
       [<e0b66390>] btrfs_finish_extent_commit+0xb2/0xf9 [btrfs]
       [<e0b71d01>] btrfs_commit_transaction+0x512/0x65d [btrfs]
       [<e0b6e8d2>] transaction_kthread+0x164/0x1dc [btrfs]
       [<c043a8f8>] kthread+0x3b/0x63
       [<c0404717>] kernel_thread_helper+0x7/0x10
       [<ffffffff>] 0xffffffff

other info that might help us debug this:

3 locks held by btrfs-transacti/2651:
 #0:  (&fs_info->transaction_kthread_mutex){--..}, at: [<e0b6e81e>]
transaction_kthread+0xb0/0x1dc [btrfs]
 #1:  (&fs_info->tree_reloc_mutex){--..}, at: [<e0b71a94>]
btrfs_commit_transaction+0x2a5/0x65d [btrfs]
 #2:  (&fs_info->pinned_mutex){--..}, at: [<e0b662fe>]
btrfs_finish_extent_commit+0x20/0xf9 [btrfs]

stack backtrace:
Pid: 2651, comm: btrfs-transacti Not tainted 2.6.27 #2
 [<c04474b2>] print_circular_bug_tail+0x9b/0xa6
 [<c0447a44>] validate_chain+0x587/0xa43
 [<c0444caa>] ? trace_hardirqs_off+0xb/0xd
 [<c0448574>] __lock_acquire+0x674/0x6da
 [<c0448635>] lock_acquire+0x5b/0x81
 [<e0b92387>] ? btrfs_add_free_space+0x1c/0x65 [btrfs]
 [<c064c039>] mutex_lock_nested+0xd1/0x259
 [<e0b92387>] ? btrfs_add_free_space+0x1c/0x65 [btrfs]
 [<e0b92387>] ? btrfs_add_free_space+0x1c/0x65 [btrfs]
 [<e0b92387>] btrfs_add_free_space+0x1c/0x65 [btrfs]
 [<e0b66390>] btrfs_finish_extent_commit+0xb2/0xf9 [btrfs]
 [<e0b71d01>] btrfs_commit_transaction+0x512/0x65d [btrfs]
 [<c043a9b9>] ? autoremove_wake_function+0x0/0x30
 [<e0b6e8d2>] transaction_kthread+0x164/0x1dc [btrfs]
 [<c041f6be>] ? complete+0x34/0x3e
 [<e0b6e76e>] ? transaction_kthread+0x0/0x1dc [btrfs]
 [<c043a8f8>] kthread+0x3b/0x63
 [<c043a8bd>] ? kthread+0x0/0x63
 [<c0404717>] kernel_thread_helper+0x7/0x10
 =======================
device fsid 51464cf7df326b76-8d5a548c72c2aaa9 devid 1 transid 20 /dev/sdb1


On Thu, Oct 30, 2008 at 8:02 PM, Josef Bacik <jbacik@redhat.com> wrote:
> Hello,
>
> There is a lockdep warning that pops up complaining about grabbing the
> block_group->alloc_mutex while holding the fs_info->pinned_mutex.  This is
> because in cache_block_group we grabe the pinned_mutex while holding the
> alloc_mutex.  This patch fixes this particular complaint by adding a cache_mutex
> that will be held when caching the block group and no other time.  This will
> keep the lockdep warning from happening, and is a little cleaner.  I also added
> a test to see if the block group is cached before calling cache_block_group in
> find_free_extent to keep us from checking the block group needlessly, since
> really you are only going to need to call cache_block_group once, and every time
> after that you will be fine.  Thank you,
