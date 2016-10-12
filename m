Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from arcturus.aphlor.org ([188.246.204.175]:46044 "EHLO
        arcturus.aphlor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754987AbcJLOkT (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 12 Oct 2016 10:40:19 -0400
Date: Wed, 12 Oct 2016 10:40:12 -0400
From: Dave Jones <davej@codemonkey.org.uk>
To: Chris Mason <clm@fb.com>, Al Viro <viro@ZenIV.linux.org.uk>,
        Josef Bacik <jbacik@fb.com>, David Sterba <dsterba@suse.com>,
        linux-btrfs@vger.kernel.org,
        Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: btrfs bio linked list corruption.
Message-ID: <20161012144012.7vvfehceoykswmun@codemonkey.org.uk>
References: <20161011144507.okg6baqvodn2m2lh@codemonkey.org.uk>
 <d61af3b4-4209-3fee-a201-e7847c340583@fb.com>
 <20161012134717.n74tww5eywc7dqp7@codemonkey.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20161012134717.n74tww5eywc7dqp7@codemonkey.org.uk>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Oct 12, 2016 at 09:47:17AM -0400, Dave Jones wrote:
 > On Tue, Oct 11, 2016 at 11:54:09AM -0400, Chris Mason wrote:
 >  > 
 >  > 
 >  > On 10/11/2016 10:45 AM, Dave Jones wrote:
 >  > > This is from Linus' current tree, with Al's iovec fixups on top.
 >  > > 
 >  > > ------------[ cut here ]------------
 >  > > WARNING: CPU: 1 PID: 3673 at lib/list_debug.c:33 __list_add+0x89/0xb0
 >  > > list_add corruption. prev->next should be next (ffffe8ffff806648), but was ffffc9000067fcd8. (prev=ffff880503878b80).
 >  > > CPU: 1 PID: 3673 Comm: trinity-c0 Not tainted 4.8.0-think+ #13 
 >  > >  ffffc90000d87458 ffffffff8d32007c ffffc90000d874a8 0000000000000000
 >  > >  ffffc90000d87498 ffffffff8d07a6c1 0000002100000246 ffff88050388e880
 > 
 > I hit this again overnight, it's the same trace, the only difference
 > being slightly different addresses in the list pointers:
 > 
 > [42572.777196] list_add corruption. prev->next should be next (ffffe8ffff806648), but was ffffc90000647cd8. (prev=ffff880503a0ba00).
 > 
 > I'm actually a little surprised that ->next was the same across two
 > reboots on two different kernel builds.  That might be a sign this is
 > more repeatable than I'd thought, even if it does take hours of runtime
 > right now to trigger it.  I'll try and narrow the scope of what trinity
 > is doing to see if I can make it happen faster.

.. and of course the first thing that happens is a completely different
btrfs trace..


WARNING: CPU: 1 PID: 21706 at fs/btrfs/transaction.c:489 start_transaction+0x40a/0x440 [btrfs]
CPU: 1 PID: 21706 Comm: trinity-c16 Not tainted 4.8.0-think+ #14 
 ffffc900019076a8 ffffffffb731ff3c 0000000000000000 0000000000000000
 ffffc900019076e8 ffffffffb707a6c1 000001e9f5806ce0 ffff8804f74c4d98
 0000000000000801 ffff880501cfa2a8 000000000000008a 000000000000008a

Call Trace:
 [<ffffffffb731ff3c>] dump_stack+0x4f/0x73
 [<ffffffffb707a6c1>] __warn+0xc1/0xe0
 [<ffffffffb707a7e8>] warn_slowpath_null+0x18/0x20
 [<ffffffffc01d312a>] start_transaction+0x40a/0x440 [btrfs]
 [<ffffffffc01a6215>] ? btrfs_alloc_path+0x15/0x20 [btrfs]
 [<ffffffffc01d31b2>] btrfs_join_transaction+0x12/0x20 [btrfs]
 [<ffffffffc01d92cf>] cow_file_range_inline+0xef/0x830 [btrfs]
 [<ffffffffc01d9d75>] cow_file_range.isra.64+0x365/0x480 [btrfs]
 [<ffffffffb77c24cc>] ? _raw_spin_unlock+0x2c/0x50
 [<ffffffffc01f229f>] ? release_extent_buffer+0x9f/0x110 [btrfs]
 [<ffffffffc01da299>] run_delalloc_nocow+0x409/0xbd0 [btrfs]
 [<ffffffffb70c6109>] ? get_lock_stats+0x19/0x50
 [<ffffffffc01dadea>] run_delalloc_range+0x38a/0x3e0 [btrfs]
 [<ffffffffc01f4aba>] writepage_delalloc.isra.47+0x10a/0x190 [btrfs]
 [<ffffffffc01f7678>] __extent_writepage+0xd8/0x2c0 [btrfs]
 [<ffffffffc01f7b2e>] extent_write_cache_pages.isra.44.constprop.63+0x2ce/0x430 [btrfs]
 [<ffffffffb733e497>] ? debug_smp_processor_id+0x17/0x20
 [<ffffffffb70c6109>] ? get_lock_stats+0x19/0x50
 [<ffffffffc01f8278>] extent_writepages+0x58/0x80 [btrfs]
 [<ffffffffc01d7a80>] ? btrfs_releasepage+0x40/0x40 [btrfs]
 [<ffffffffc01d4a63>] btrfs_writepages+0x23/0x30 [btrfs]
 [<ffffffffb7162e9c>] do_writepages+0x1c/0x30
 [<ffffffffb71550f1>] __filemap_fdatawrite_range+0xc1/0x100
 [<ffffffffb71551ee>] filemap_fdatawrite_range+0xe/0x10
 [<ffffffffc01eb2fb>] btrfs_fdatawrite_range+0x1b/0x50 [btrfs]
 [<ffffffffc01f0820>] btrfs_wait_ordered_range+0x40/0x100 [btrfs]
 [<ffffffffc01eb5d5>] btrfs_sync_file+0x285/0x390 [btrfs]
 [<ffffffffb7207626>] vfs_fsync_range+0x46/0xa0
 [<ffffffffb72076d8>] do_fsync+0x38/0x60
 [<ffffffffb720795b>] SyS_fsync+0xb/0x10
 [<ffffffffb700259c>] do_syscall_64+0x5c/0x170
 [<ffffffffb77c2e4b>] entry_SYSCALL64_slow_path+0x25/0x25
