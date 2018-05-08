Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:39016 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750745AbeEHFQj (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 8 May 2018 01:16:39 -0400
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 71651AECD
        for <linux-btrfs@vger.kernel.org>; Tue,  8 May 2018 05:16:38 +0000 (UTC)
Subject: Re: [PATCH 0/5] Fix delalloc inodes leaking on btrfs unmount
To: dsterba@suse.cz, linux-btrfs@vger.kernel.org
References: <1524820914-30864-1-git-send-email-nborisov@suse.com>
 <20180507225822.GG6649@twin.jikos.cz>
From: Nikolay Borisov <nborisov@suse.com>
Message-ID: <366832e3-26c1-55a2-e1ab-be5efdb99b7c@suse.com>
Date: Tue, 8 May 2018 08:16:37 +0300
MIME-Version: 1.0
In-Reply-To: <20180507225822.GG6649@twin.jikos.cz>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On  8.05.2018 01:58, David Sterba wrote:
> On Fri, Apr 27, 2018 at 12:21:49PM +0300, Nikolay Borisov wrote:
>> After investigating crashes on generic/176 it turned that the culprit in fact
>> is the random failure induced by generic/019. As it happens, if on unmount the 
>> filesystem is in BTRFS_FS_STATE_ERROR then btrfs_error_commit_super is called. 
>> This unveiled 2 bugs:
>>  1. btrfs_destroy_delalloc_inodes's implementation was completely bogus, since
>>  it only called btrfs_invalidate_inodes which only pruned dentries and didn't 
>>  do anything to free any inodes with pending delalloc bytes. Once this is fixed 
>>  with the use of invalide_inode_pages2 the second bug transpired. 
>>  2. The last call ot run_delayed_iputs is made before btrfs_cleanup_transaction
>>  is called. The latter in turn could queue up more delayed iputs resulting from 
>>  invalidates_inode_pages2. 
>>
>> This series fixes the problem by first fixing btrfs_destroy_delalloc_inode to 
>> properly cleanup delalloc inodes and as a result cleans up the code a bit. 
>>
>> I've given it a good bashing through xfstest (4 full xfstest cycles + 100 
>> iterations of generic/475 since it was hitting some early assertion failures,
>> which are fixed in the final version) so am pretty confident in the change. 
> 
> One qemu testmachine complains.
> 
> The branch was ext/nikbor/delalloc-invalidate in my github repo. Other
> tests seem "fine", unlikely to be related to this patchset.
> 
> The error here is a null pointer deref in end bio callback, which
> matches a use-after-free scenario, so I think there's still something
> left to fix.
> 
> generic/335             [22:34:50]

How easy is to repro this on this particular test? Like every other run
or is it spurious?

> [26281.970322] run fstests generic/335 at 2018-05-07 22:34:50
> [26282.440728] BUG: unable to handle kernel NULL pointer dereference at0000000000000000
> [26282.445060] PGD 0 P4D 0
> [26282.446526] Oops: 0000 [#1] PREEMPT SMP
> [26282.448562] Modules linked in: btrfs libcrc32c xor zstd_decompresszstd_compress xxhash raid6_pq loop af_packet [last unloaded: libcrc32c]
> [26282.454384] CPU: 2 PID: 30005 Comm: btrfs-endio-met Tainted: GW         4.17.0-rc4-default+ #73
> [26282.457247] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996),BIOS 1.0.0-prebuilt.qemu-project.org 04/01/2014
> [26282.459386] RIP: 0010:__queue_work+0x189/0x3f0
> [26282.460342] RSP: 0018:ffff8ea47fd03f00 EFLAGS: 00010046
> [26282.461506] RAX: 0000000000000000 RBX: 0000000000000000 RCX:0000000000000000
> [26282.463061] RDX: ffff8ea47fbda640 RSI: 000000007fffffff RDI:ffff8ea47fbda640
> [26282.464606] RBP: 000000000000000d R08: 0000000000000000 R09:0000000000000001
> [26282.466169] R10: 0000000000001000 R11: ffff8ea469244000 R12:ffff8ea40819c800
> [26282.467697] R13: 0000000000000002 R14: 0000000000000200 R15:ffff8ea47fbda640
> [26282.469205] FS:  0000000000000000(0000) GS:ffff8ea47fd00000(0000)knlGS:0000000000000000
> [26282.470971] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [26282.472173] CR2: 0000000000000000 CR3: 0000000042ed4000 CR4:00000000000006e0
> [26282.473674] Call Trace:
> [26282.474300]  <IRQ>
> [26282.474848]  queue_work_on+0x34/0x40
> [26282.475717]  btrfs_end_bio+0x71/0x110 [btrfs]
> [26282.476750]  blk_update_request+0x78/0x2d0
> [26282.477675]  blk_mq_end_request+0x18/0x70
> [26282.478599]  flush_smp_call_function_queue+0x6f/0xe0
> [26282.479690]  smp_call_function_single_interrupt+0x2c/0xe0
> [26282.480825]  call_function_single_interrupt+0xf/0x20
> [26282.481888]  </IRQ>
> [26282.482423] RIP: 0010:exit_shm+0x0/0x1c0
> [26282.483281] RSP: 0018:ffffa9a1c4787ea0 EFLAGS: 00000292 ORIG_RAX:ffffffffffffff04
> [26282.484944] RAX: ffffffffb2e37960 RBX: ffff8ea47ccc1c00 RCX:0000000000000000
> [26282.486423] RDX: ffff8ea413270e40 RSI: 0000000000000282 RDI:ffff8ea47ccc1c00
> [26282.487870] RBP: 0000000000000000 R08: ffff8ea413297630 R09:0000000000000000
> [26282.489104] R10: 0000000000000000 R11: 0000000000000256 R12:0000000000000000
> [26282.490306] R13: ffff8ea47ccc2301 R14: 0000000000000001 R15:ffff8ea47ccc1c00
> [26282.491500]  do_exit+0x274/0xb00
> [26282.492198]  ? rescuer_thread+0x2be/0x310
> [26282.492990]  ? worker_thread+0x380/0x380
> [26282.493795]  kthread+0xe0/0x130
> [26282.494443]  ? kthread_create_worker_on_cpu+0x50/0x50
> [26282.495395]  ret_from_fork+0x1f/0x30
> [26282.499564] RIP: __queue_work+0x189/0x3f0 RSP: ffff8ea47fd03f00
> [26282.500614] CR2: 0000000000000000
> [26282.501248] ---[ end trace f7e701988bc2b82f ]---
> [26282.502141] Kernel panic - not syncing: Fatal exception in interrupt
> [26282.503419] Kernel Offset: 0x31000000 from 0xffffffff81000000
> (relocation range: 0xffffffff80000000-0xffffffffbfffffff)
> [26282.505348] Rebooting in 90 seconds..
> 
