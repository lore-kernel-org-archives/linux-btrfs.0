Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:6550 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754240Ab3AaFzi (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 31 Jan 2013 00:55:38 -0500
Message-ID: <510A0756.40206@redhat.com>
Date: Wed, 30 Jan 2013 23:55:34 -0600
From: Eric Sandeen <sandeen@redhat.com>
MIME-Version: 1.0
To: Tsutomu Itoh <t-itoh@jp.fujitsu.com>
CC: Linux Btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: [BUG] kernel BUG at fs/btrfs/async-thread.c:605!
References: <5109E70D.3010005@jp.fujitsu.com>
In-Reply-To: <5109E70D.3010005@jp.fujitsu.com>
Content-Type: text/plain; charset=ISO-2022-JP
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 1/30/13 9:37 PM, Tsutomu Itoh wrote:
> Hi,
> 
> In kernel 3.8-rc5, the following panics occurred when the mount was done
> by the degraded option.
> 
> # btrfs fi sh /dev/sdc8
> Label: none  uuid: fc63cd80-5ae2-4fbe-8795-2d526c937a56
>         Total devices 3 FS bytes used 20.98GB
>         devid    1 size 9.31GB used 9.31GB path /dev/sdd8
>         devid    2 size 9.31GB used 9.31GB path /dev/sdc8
>         *** Some devices missing
> 
> Btrfs v0.20-rc1-37-g91d9eec
> # mount -o degraded /dev/sdc8 /test1
> 
>  564 static struct btrfs_worker_thread *find_worker(struct btrfs_workers *workers)
>  565 {
> ...

I'm new at this so just taking a guess, but maybe a patch below.  :)

Hm, so we can't get here unless:

	worker = next_worker(workers);

returned NULL.  And it can't return NULL unless idle_list is empty,
and we are not at the maximum nr. of threads, or the current worker
list is empty.

So it's possible to return NULL from next_worker() if 
idle_list and worker_list are both empty, I think.

> ...
>  595 fallback:
>  596         fallback = NULL;
>  597         /*
>  598          * we have failed to find any workers, just
>  599          * return the first one we can find.
>  600          */
>  601         if (!list_empty(&workers->worker_list))
>  602                 fallback = workers->worker_list.next;

it's possible that we got here *because* the worker_list was
empty...

>  603         if (!list_empty(&workers->idle_list))

... and that when we were called, this list was empty too.

>  604                 fallback = workers->idle_list.next;
>  605         BUG_ON(!fallback);              <---------------------- this !


Seems quite possible that there are no worker threads at all at this point.
How could that happen...

>  606         worker = list_entry(fallback,
>  607                   struct btrfs_worker_thread, worker_list);
> 
> -Tsutomu
> 
> ===================================================================================
> 
> [ 7913.075890] btrfs: allowing degraded mounts
> [ 7913.075893] btrfs: disk space caching is enabled
> [ 7913.092031] Btrfs: too many missing devices, writeable mount is not allowed

so this was supposed to fail the mount in open_ctree; it jumps to shutting down
the worker threads.  Which might result in no threads available.

> [ 7913.092297] ------------[ cut here ]------------
> [ 7913.092313] kernel BUG at fs/btrfs/async-thread.c:605!
> [ 7913.092326] invalid opcode: 0000 [#1] SMP
> [ 7913.092342] Modules linked in: btrfs zlib_deflate crc32c libcrc32c nfsd lockd nfs_acl auth_rpcgss sunrpc 8021q garp stp llc cpufreq_ondemand cachefiles fscache ipv6 ext3 jbd dm_mirror dm_region_hash dm_log dm_mod uinput ppdev iTCO_wdt iTCO_vendor_support parport_pc parport sg acpi_cpufreq freq_table mperf coretemp kvm pcspkr i2c_i801 i2c_core lpc_ich mfd_core tg3 ptp pps_core shpchp pci_hotplug i3000_edac edac_core ext4 mbcache jbd2 crc16 sr_mod cdrom sd_mod crc_t10dif pata_acpi ata_piix libata megaraid_sas scsi_mod floppy [last unloaded: microcode]
> [ 7913.092575] CPU 0
> [ 7913.092584] Pid: 3673, comm: btrfs-endio-wri Not tainted 3.8.0-rc5 #1 FUJITSU-SV      PRIMERGY            /D2399
> [ 7913.092608] RIP: 0010:[<ffffffffa04670ef>]  [<ffffffffa04670ef>] btrfs_queue_worker+0x10e/0x236 [btrfs]

but this is already trying to do work, and has no workers to handle it.

The place we jump to is fail_block_groups, and before it is this comment:

        /*      
         * make sure we're done with the btree inode before we stop our
         * kthreads
         */
        filemap_write_and_wait(fs_info->btree_inode->i_mapping);
        invalidate_inode_pages2(fs_info->btree_inode->i_mapping);
                                               
fail_block_groups:
        btrfs_free_block_groups(fs_info);

if you move the fail_block_groups: target above the comment, does that fix it?
(although I don't know yet what started IO . . . )

like this:

From: Eric Sandeen <sandeen@redhat.com>

Make sure that we are always done with the btree_inode's mapping
before we shut down the worker threads in open_ctree() error
cases.

Signed-off-by: Eric Sandeen <sandeen@redhat.com> 

diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index d89da40..1e2abda 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -2689,6 +2689,7 @@ fail_trans_kthread:
 fail_cleaner:
 	kthread_stop(fs_info->cleaner_kthread);
 
+fail_block_groups:
 	/*
 	 * make sure we're done with the btree inode before we stop our
 	 * kthreads
@@ -2696,7 +2697,6 @@ fail_cleaner:
 	filemap_write_and_wait(fs_info->btree_inode->i_mapping);
 	invalidate_inode_pages2(fs_info->btree_inode->i_mapping);
 
-fail_block_groups:
 	btrfs_free_block_groups(fs_info);
 
 fail_tree_roots:

Just a guess; but I don't know what would have started writes already...

-Eric

> [ 7913.092663] RSP: 0018:ffff88019fc03c10  EFLAGS: 00010046
> [ 7913.092676] RAX: 0000000000000000 RBX: ffff8801967b8a58 RCX: 0000000000000000
> [ 7913.092894] RDX: 0000000000000000 RSI: ffff8801961239b8 RDI: ffff8801967b8ab8
> [ 7913.093116] RBP: ffff88019fc03c50 R08: 0000000000000000 R09: ffff880198801180
> [ 7913.093247] R10: ffffffffa045fda7 R11: 0000000000000003 R12: 0000000000000000
> [ 7913.093247] R13: ffff8801961239b8 R14: ffff8801967b8ab8 R15: 0000000000000246
> [ 7913.093247] FS:  0000000000000000(0000) GS:ffff88019fc00000(0000) knlGS:0000000000000000
> [ 7913.093247] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
> [ 7913.093247] CR2: ffffffffff600400 CR3: 000000019575d000 CR4: 00000000000007f0
> [ 7913.093247] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> [ 7913.093247] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
> [ 7913.093247] Process btrfs-endio-wri (pid: 3673, threadinfo ffff8801939ca000, task ffff880195795b00)

This was started by 

        btrfs_init_workers(&fs_info->endio_write_workers, "endio-write",
                           fs_info->thread_pool_size,
                           &fs_info->generic_worker);

via open_ctree() before we jumped to fail_block_groups.

> [ 7913.093247] Stack:
> [ 7913.093247]  ffff8801967b8a88 ffff8801967b8a78 ffff88003fa0a600 ffff8801965ad0c0
> [ 7913.093247]  ffff88003fa0a600 0000000000000000 0000000000000000 0000000000000000
> [ 7913.096183]  ffff88019fc03c60 ffffffffa043e357 ffff88019fc03c70 ffffffff811526aa
> [ 7913.096183] Call Trace:
> [ 7913.096183]  <IRQ>
> [ 7913.096183]
> [ 7913.096183]  [<ffffffffa043e357>] end_workqueue_bio+0x79/0x7b [btrfs]
> [ 7913.096183]  [<ffffffff811526aa>] bio_endio+0x2d/0x2f
> [ 7913.096183]  [<ffffffffa045fdb2>] btrfs_end_bio+0x10b/0x122 [btrfs]
> [ 7913.096183]  [<ffffffff811526aa>] bio_endio+0x2d/0x2f
> [ 7913.096183]  [<ffffffff811c5e3f>] req_bio_endio+0x96/0x9f
> [ 7913.096183]  [<ffffffff811c601d>] blk_update_request+0x1d5/0x3a4
> [ 7913.096183]  [<ffffffff811c620c>] blk_update_bidi_request+0x20/0x6f
> [ 7913.096183]  [<ffffffff811c7a59>] blk_end_bidi_request+0x1f/0x5d
> [ 7913.096183]  [<ffffffff811c7ad3>] blk_end_request+0x10/0x12
> [ 7913.096183]  [<ffffffffa001db50>] scsi_io_completion+0x207/0x4f3 [scsi_mod]
> [ 7913.096183]  [<ffffffffa0016df9>] scsi_finish_command+0xec/0xf5 [scsi_mod]
> [ 7913.096183]  [<ffffffffa001df50>] scsi_softirq_done+0xff/0x108 [scsi_mod]
> [ 7913.096183]  [<ffffffff811ccb3a>] blk_done_softirq+0x7a/0x8e
> [ 7913.096183]  [<ffffffff810475c3>] __do_softirq+0xd7/0x1ed
> [ 7913.096183]  [<ffffffff813ead9c>] call_softirq+0x1c/0x30
> [ 7913.096183]  [<ffffffff81010ab6>] do_softirq+0x46/0x83
> [ 7913.096183]  [<ffffffff81047363>] irq_exit+0x49/0xb7
> [ 7913.096183]  [<ffffffff813eafd5>] do_IRQ+0x9d/0xb4
> [ 7913.096183]  [<ffffffffa0467217>] ? btrfs_queue_worker+0x236/0x236 [btrfs]
> [ 7913.096183]  [<ffffffff813e2a2d>] common_interrupt+0x6d/0x6d
> [ 7913.096183]  <EOI>
> [ 7913.096183]
> [ 7913.096183]  [<ffffffff81069a5e>] ? sched_move_task+0x12e/0x13d
> [ 7913.096183]  [<ffffffff8104a131>] ? ptrace_put_breakpoints+0x1/0x1e
> [ 7913.096183]  [<ffffffff81044fc2>] ? do_exit+0x3d7/0x89d
> [ 7913.096183]  [<ffffffffa0467217>] ? btrfs_queue_worker+0x236/0x236 [btrfs]
> [ 7913.096183]  [<ffffffffa0467217>] ? btrfs_queue_worker+0x236/0x236 [btrfs]
> [ 7913.096183]  [<ffffffff8105ca20>] kthread+0xbd/0xbd
> [ 7913.096183]  [<ffffffff8105c963>] ? kthread_freezable_should_stop+0x65/0x65
> [ 7913.096183]  [<ffffffff813e99ec>] ret_from_fork+0x7c/0xb0
> [ 7913.096183]  [<ffffffff8105c963>] ? kthread_freezable_should_stop+0x65/0x65
> [ 7913.096183] Code: 49 89 c7 0f 84 5f ff ff ff 48 8b 43 20 48 3b 45 c8 ba 00 00 00 00 4c 8b 63 30 48 0f 44 c2 4c 3b 65 c0 4c 0f 44 e0 4d 85 e4 75 04 <0f> 0b eb fe 49 83 ec 28 49 8d 44 24 40 48 89 45 c8 f0 41 ff 44
> [ 7913.096183] RIP  [<ffffffffa04670ef>] btrfs_queue_worker+0x10e/0x236 [btrfs]
> [ 7913.096183]  RSP <ffff88019fc03c10>
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

