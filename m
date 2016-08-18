Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:61403 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751442AbcHRRVt (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 18 Aug 2016 13:21:49 -0400
Date: Thu, 18 Aug 2016 11:03:46 -0400
From: Chris Mason <clm@fb.com>
To: <fdmanana@kernel.org>
CC: <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH v2] Btrfs: fix file/data loss caused by fsync after
 rename and new inode
Message-ID: <20160818150345.GA24208@clm-mbp.thefacebook.com>
References: <1459330710-3181-1-git-send-email-fdmanana@kernel.org>
 <1459377441-3609-1-git-send-email-fdmanana@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; format=flowed
In-Reply-To: <1459377441-3609-1-git-send-email-fdmanana@kernel.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Mar 30, 2016 at 11:37:21PM +0100, fdmanana@kernel.org wrote:
>From: Filipe Manana <fdmanana@suse.com>
>
>If we rename an inode A (be it a file or a directory), create a new
>inode B with the old name of inode A and under the same parent directory,
>fsync inode B and then power fail, at log tree replay time we end up
>removing inode A completely. If inode A is a directory then all its files
>are gone too.

I bisected a crash with dbench down to this patch.  The reproduction 
was:

mkfs.btrfs -m single -f /dev/vdb
mount /dev/vdb /btrfs
cd /btrfs
mkdir clients
for x in `seq 0 100` ; do btrfs subvol create clients/client$x ; done
sync
dbench 100

In other words, run dbench with a subvol per dbench thread.  It crashes 
immediately, most often with an invalid access in copy_from_user during 
file_write.  The pattern of crashes and location just show general 
memory corruption and the actual stack trace wasn't very useful.

With this patch reverted the runs last much much longer, but we still 
hit a crash eventually.  It's not clear to me if this is two different 
bugs or if Filipe's patch just makes the corruption much easier to hit.  
I'm still digging through it all, but here's a common backtrace with
this patch reverted:

BUG: unable to handle kernel paging request at 0000000000017298
IP: [<ffffffff810ad8b9>] queued_spin_lock_slowpath+0x139/0x200
PGD 7df68a067 PUD 7df68b067 PMD 0
Oops: 0002 [#1] PREEMPT SMP
Modules linked in: crc32c_intel i2c_piix4 aesni_intel i2c_core 
aes_x86_64 glue_helper virtio_net serio_raw lrw floppy pcspkr gf128mul 
ablk_helper button cryptd sch_fq_codel autofs4 virtio_blk
CPU: 6 PID: 1125 Comm: dbench Not tainted 4.7.0-00001-g00cc018 #220
Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.9.0-1.fc24 
04/01/2014
task: ffff88072c918e40 ti: ffff88072cf50000 task.ti: ffff88072cf50000
RIP: 0010:[<ffffffff810ad8b9>]  [<ffffffff810ad8b9>] queued_spin_lock_slowpath+0x139/0x200
RSP: 0018:ffff8807eff83ac8  EFLAGS: 00010002
RAX: 000000000000263d RBX: ffff8807eff97290 RCX: 00000000001d0000
RDX: 0000000000017298 RSI: ffff8807eff83b58 RDI: ffff8807540702fc
RBP: ffff8807eff83b88 R08: 0000000000000000 R09: 000000000001a228
R10: ffff88080fffad80 R11: 000000000000005a R12: 0000000000010000
R13: 0000000000000000 R14: ffff8807eff83d48 R15: 0000000000000003
FS:  00007fb2b8810700(0000) GS:ffff8807eff80000(0000) 
knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000000000017298 CR3: 00000007df689000 CR4: 00000000000406e0
Stack:
 0000000000000000 ffff8807540702fc ffff8807ec37a918 0000000100000000
 ffff8807ec37a900 ffff8807ec37a980 ffff8807eff97290 ffffffff810961da
 000000000000003c ffff8800ba864dd8 ffff880798f94189 ffff8807ef89a000
Call Trace:
 <IRQ>
 [<ffffffff810961da>] ? select_idle_sibling+0x2a/0x120
 [<ffffffff81091385>] ? wake_up_process+0x15/0x20
 [<ffffffff81079c00>] ? wake_up_worker+0x30/0x40
 [<ffffffff8107c6c8>] ? insert_work+0x78/0xc0
 [<ffffffff8197421e>] _raw_spin_lock_irqsave+0x4e/0x50
 [<ffffffff81090f5c>] try_to_wake_up+0x3c/0x410
 [<ffffffff81973e76>] ? _raw_spin_unlock+0x16/0x40
 [<ffffffff8107c8c0>] ? __queue_work+0x1b0/0x530
 [<ffffffff8109bfcf>] ? update_cfs_shares+0xcf/0x110
 [<ffffffff81091342>] default_wake_function+0x12/0x20
 [<ffffffff810a5d56>] autoremove_wake_function+0x16/0x40
 [<ffffffff810a5df4>] wake_bit_function+0x34/0x40
 [<ffffffff810a5c06>] __wake_up_common+0x56/0x90
 [<ffffffff810a61f8>] __wake_up+0x48/0x70
 [<ffffffff810a6268>] __wake_up_bit+0x48/0x50
 [<ffffffff8115d1f1>] end_page_writeback+0x81/0xa0
 [<ffffffff813e9cb9>] end_bio_extent_writepage+0x79/0xe0
 [<ffffffff814a17eb>] bio_endio+0x6b/0x80
 [<ffffffff813f2d32>] btrfs_end_bio+0x102/0x190
 [<ffffffff814a17eb>] bio_endio+0x6b/0x80
 [<ffffffff814a6778>] blk_update_request+0x1e8/0x330
 [<ffffffff814b434a>] blk_mq_end_request+0x1a/0x40
 [<ffffffffa0000431>] virtblk_request_done+0x71/0xe0 [virtio_blk]
 [<ffffffff814b3420>] ? blkdev_issue_zeroout+0x1d0/0x1d0
 [<ffffffff814b3433>] __blk_mq_complete_request_remote+0x13/0x20
 [<ffffffff810df62b>] flush_smp_call_function_queue+0x8b/0x180
 [<ffffffff814f2ad7>] ? debug_smp_processor_id+0x17/0x20
 [<ffffffff810df733>] generic_smp_call_function_single_interrupt+0x13/0x20
 [<ffffffff810406b7>] smp_call_function_single_interrupt+0x27/0x40
 [<ffffffff8197564f>] call_function_single_interrupt+0x7f/0x90
 <EOI>
 [<ffffffff810ad8cc>] ? queued_spin_lock_slowpath+0x14c/0x200
 [<ffffffff810ad841>] ? queued_spin_lock_slowpath+0xc1/0x200
 [<ffffffff81973e2e>] ? _raw_spin_unlock_irqrestore+0xe/0x40
 [<ffffffff810af1f5>] queued_write_lock_slowpath+0x95/0xa0
 [<ffffffff810a5faf>] ? finish_wait+0x6f/0x90
 [<ffffffff8108feb8>] ? preempt_count_add+0xb8/0xd0
 [<ffffffff81974142>] _raw_write_lock+0x32/0x40
 [<ffffffff81409246>] btrfs_tree_lock+0x146/0x2c0
 [<ffffffff810a5d40>] ? woken_wake_function+0x20/0x20
 [<ffffffff8108feb8>] ? preempt_count_add+0xb8/0xd0
 [<ffffffff8197418e>] ? _raw_read_lock+0x3e/0x40
 [<ffffffff81409708>] ? btrfs_tree_read_lock+0x78/0x170
 [<ffffffff810a5d40>] ? woken_wake_function+0x20/0x20
 [<ffffffff810a5d56>] ? autoremove_wake_function+0x16/0x40
 [<ffffffff81396aaf>] ? btrfs_root_node+0x4f/0x90
 [<ffffffff81396c44>] btrfs_lock_root_node+0x34/0x50
 [<ffffffff8139f3d9>] btrfs_search_slot+0x769/0x9c0
 [<ffffffff8140909c>] ? btrfs_tree_unlock+0x6c/0xd0
 [<ffffffff813b8129>] btrfs_del_csums+0x239/0x330
 [<ffffffff813affaf>] __btrfs_free_extent+0x73f/0xe00
 [<ffffffff811c924d>] ? kmem_cache_free+0x22d/0x240
 [<ffffffff813b1237>] __btrfs_run_delayed_refs+0xbc7/0x1300
 [<ffffffff8115f2bf>] ? find_get_pages_tag+0x18f/0x2f0
 [<ffffffff813efd2d>] ? extent_write_cache_pages.clone.0+0x3dd/0x460
 [<ffffffff813b19fa>] btrfs_run_delayed_refs+0x8a/0x2b0
 [<ffffffff813c6c21>] btrfs_commit_transaction+0x51/0xcb0
 [<ffffffff8115d6ab>] ? __filemap_fdatawait_range+0x9b/0x170
 [<ffffffff8108feb8>] ? preempt_count_add+0xb8/0xd0
 [<ffffffff81973df7>] ? _raw_spin_unlock_irq+0x17/0x40
 [<ffffffff813e62d7>] ? btrfs_lookup_first_ordered_extent+0x97/0xd0
 [<ffffffff813e6401>] ? btrfs_wait_ordered_range+0xf1/0x130
 [<ffffffff813dc34e>] btrfs_sync_file+0x3ce/0x4b0
 [<ffffffff81102040>] ? __audit_syscall_entry+0xb0/0x110
 [<ffffffff8121d8cc>] vfs_fsync_range+0x4c/0xb0
 [<ffffffff810026ab>] ? syscall_trace_enter_phase1+0xfb/0x120
 [<ffffffff8121d94c>] vfs_fsync+0x1c/0x20
 [<ffffffff8121d98d>] do_fsync+0x3d/0x70
 [<ffffffff8121d9f0>] SyS_fsync+0x10/0x20
 [<ffffffff81002d97>] do_syscall_64+0x57/0xb0
 [<ffffffff81002531>] ? prepare_exit_to_usermode+0x31/0x40
 [<ffffffff819744bc>] entry_SYSCALL64_slow_path+0x25/0x25
Code: 48 89 9d 70 ff ff ff 48 89 c2 48 8d 75 d0 48 c1 ea 0c c1 e8 12 83 
e2 30 ff c8 48 81 c2 80 72 01 00 48 98 48 03 14 c5 c0 ba f3 81 <48> 89 
1a 48 8d 53 08 8b 43 08 89 45 d0 85 c0 75 0a f3 90 8b 02
RIP  [<ffffffff810ad8b9>] queued_spin_lock_slowpath+0x139/0x200
 RSP <ffff8807eff83ac8>
CR2: 0000000000017298
---[ end trace b53934847871f7b8 ]---
Kernel panic - not syncing: Fatal exception in interrupt

-chris
