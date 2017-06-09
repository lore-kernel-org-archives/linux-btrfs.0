Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pg0-f51.google.com ([74.125.83.51]:35851 "EHLO
        mail-pg0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751392AbdFIAGx (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Thu, 8 Jun 2017 20:06:53 -0400
Received: by mail-pg0-f51.google.com with SMTP id a70so20846214pge.3
        for <linux-btrfs@vger.kernel.org>; Thu, 08 Jun 2017 17:06:53 -0700 (PDT)
Date: Thu, 8 Jun 2017 17:06:49 -0700
From: Omar Sandoval <osandov@osandov.com>
To: Chris Murphy <lists@colorremedies.com>, Christoph Hellwig <hch@lst.de>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>, David Sterba <dsterba@suse.cz>
Subject: Re: status of swapfiles on Btrfs
Message-ID: <20170609000649.GA32051@vader>
References: <CAJCQCtTJYsYXChwochYocJN-uo-OG-BFfogMwkhQuN9X__1z6A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CAJCQCtTJYsYXChwochYocJN-uo-OG-BFfogMwkhQuN9X__1z6A@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Jun 08, 2017 at 03:35:10PM -0600, Chris Murphy wrote:
> What's the status?

I rebased the patches on v4.9 back in November and ran into a circular
locking issue between mmap_sem and i_rwsem. I never figured out how to
resolve that. Christoph was the last one that I talked to about this,
maybe he has some ideas. Latest code rebased on v4.12-rc4 is here:
https://github.com/osandov/linux/tree/btrfs-swap.

[  991.245632] ======================================================
[  991.246493] WARNING: possible circular locking dependency detected
[  991.246590] 4.12.0-rc4-00006-g0e2e3e2ba974 #3 Not tainted
[  991.246590] ------------------------------------------------------
[  991.246590] swapme/626 is trying to acquire lock:
[  991.246590]  (&sb->s_type->i_mutex_key#16){++++++}, at: [<ffffffffa02804ee>] nfs_start_io_direct+0x1e/0x70 [nfs]
[  991.246590]
[  991.246590] but task is already holding lock:
[  991.246590]  (&mm->mmap_sem){++++++}, at: [<ffffffff8105bb0a>] __do_page_fault+0x17a/0x550
[  991.246590]
[  991.246590] which lock already depends on the new lock.
[  991.246590]
[  991.246590]
[  991.246590] the existing dependency chain (in reverse order) is:
[  991.246590]
[  991.246590] -> #1 (&mm->mmap_sem){++++++}:
[  991.246590]        lock_acquire+0xa5/0x250
[  991.246590]        __might_fault+0x68/0x90
[  991.246590]        copy_page_to_iter+0xc4/0x310
[  991.246590]        generic_file_read_iter+0x325/0x7d0
[  991.246590]        nfs_file_read+0x7c/0xa0 [nfs]
[  991.246590]        __vfs_read+0xe1/0x130
[  991.246590]        vfs_read+0xa8/0x150
[  991.246590]        SyS_read+0x58/0xd0
[  991.246590]        entry_SYSCALL_64_fastpath+0x1f/0xbe
[  991.246590]
[  991.246590] -> #0 (&sb->s_type->i_mutex_key#16){++++++}:
[  991.246590]        __lock_acquire+0x15e1/0x1940
[  991.246590]        lock_acquire+0xa5/0x250
[  991.246590]        down_read+0x3e/0x70
[  991.246590]        nfs_start_io_direct+0x1e/0x70 [nfs]
[  991.246590]        nfs_file_direct_write+0x1b6/0x290 [nfs]
[  991.246590]        nfs_file_write+0x169/0x1f0 [nfs]
[  991.246590]        __swap_writepage+0x121/0x2f0
[  991.246590]        swap_writepage+0x34/0x90
[  991.246590]        pageout.isra.18+0xf8/0x3c0
[  991.246590]        shrink_page_list+0x779/0xac0
[  991.246590]        shrink_inactive_list+0x200/0x580
[  991.246590]        shrink_node_memcg+0x367/0x750
[  991.246590]        shrink_node+0xf7/0x2f0
[  991.246590]        do_try_to_free_pages+0xd7/0x350
[  991.246590]        try_to_free_mem_cgroup_pages+0x111/0x390
[  991.246590]        try_charge+0x14b/0xa20
[  991.246590]        mem_cgroup_try_charge+0x87/0x480
[  991.246590]        __handle_mm_fault+0xbc0/0x11b0
[  991.246590]        handle_mm_fault+0x174/0x340
[  991.246590]        __do_page_fault+0x290/0x550
[  991.246590]        trace_do_page_fault+0x9a/0x260
[  991.246590]        do_async_page_fault+0x4f/0x70
[  991.246590]        async_page_fault+0x28/0x30
[  991.246590]
[  991.246590] other info that might help us debug this:
[  991.246590]
[  991.246590]  Possible unsafe locking scenario:
[  991.246590]
[  991.246590]        CPU0                    CPU1
[  991.246590]        ----                    ----
[  991.246590]   lock(&mm->mmap_sem);
[  991.246590]                                lock(&sb->s_type->i_mutex_key#16);
[  991.246590]                                lock(&mm->mmap_sem);
[  991.246590]   lock(&sb->s_type->i_mutex_key#16);
[  991.246590]
[  991.246590]  *** DEADLOCK ***
[  991.246590]
[  991.246590] 1 lock held by swapme/626:
[  991.246590]  #0:  (&mm->mmap_sem){++++++}, at: [<ffffffff8105bb0a>] __do_page_fault+0x17a/0x550
[  991.246590]
[  991.246590] stack backtrace:
[  991.246590] CPU: 2 PID: 626 Comm: swapme Not tainted 4.12.0-rc4-00006-g0e2e3e2ba974 #3
[  991.246590] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.10.2-20170228_101828-anatol 04/01/2014
[  991.246590] Call Trace:
[  991.246590]  dump_stack+0x8e/0xcd
[  991.246590]  print_circular_bug+0x1f8/0x2e0
[  991.246590]  __lock_acquire+0x15e1/0x1940
[  991.246590]  lock_acquire+0xa5/0x250
[  991.246590]  ? lock_acquire+0xa5/0x250
[  991.246590]  ? nfs_start_io_direct+0x1e/0x70 [nfs]
[  991.246590]  down_read+0x3e/0x70
[  991.246590]  ? nfs_start_io_direct+0x1e/0x70 [nfs]
[  991.246590]  nfs_start_io_direct+0x1e/0x70 [nfs]
[  991.246590]  nfs_file_direct_write+0x1b6/0x290 [nfs]
[  991.246590]  nfs_file_write+0x169/0x1f0 [nfs]
[  991.246590]  ? SyS_madvise+0x870/0x870
[  991.246590]  __swap_writepage+0x121/0x2f0
[  991.246590]  swap_writepage+0x34/0x90
[  991.246590]  pageout.isra.18+0xf8/0x3c0
[  991.246590]  shrink_page_list+0x779/0xac0
[  991.246590]  shrink_inactive_list+0x200/0x580
[  991.246590]  ? mark_lock+0x5d0/0x670
[  991.246590]  shrink_node_memcg+0x367/0x750
[  991.246590]  ? mem_cgroup_iter+0x1c1/0x760
[  991.246590]  shrink_node+0xf7/0x2f0
[  991.246590]  ? shrink_node+0xf7/0x2f0
[  991.246590]  do_try_to_free_pages+0xd7/0x350
[  991.246590]  try_to_free_mem_cgroup_pages+0x111/0x390
[  991.246590]  try_charge+0x14b/0xa20
[  991.246590]  ? get_mem_cgroup_from_mm+0xfc/0x2d0
[  991.246590]  mem_cgroup_try_charge+0x87/0x480
[  991.246590]  __handle_mm_fault+0xbc0/0x11b0
[  991.246590]  handle_mm_fault+0x174/0x340
[  991.246590]  __do_page_fault+0x290/0x550
[  991.246590]  trace_do_page_fault+0x9a/0x260
[  991.246590]  do_async_page_fault+0x4f/0x70
[  991.246590]  async_page_fault+0x28/0x30
[  991.246590] RIP: 0033:0x400b72
[  991.246590] RSP: 002b:00007fffa3a2ed60 EFLAGS: 00010206
[  991.246590] RAX: 00007f78598cf000 RBX: 00007f78598cf000 RCX: 00007f787969fa8a
[  991.246590] RDX: 0000000000000000 RSI: 0000000000001000 RDI: 0000000000000000
[  991.246590] RBP: 0000000000001000 R08: ffffffffffffffff R09: 0000000000000000
[  991.246590] R10: 0000000000000022 R11: 0000000000000246 R12: 0000000000040000
[  991.246590] R13: 00007f78598d0000 R14: 00000000000001ff R15: 000000000001fee5
