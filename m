Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.22]:53391 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750762AbcBUBg4 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 20 Feb 2016 20:36:56 -0500
Subject: Re: [bug] unable to handle kernel paging request when running
 btrfs/011
To: Anand Jain <anand.jain@oracle.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
References: <56C71B9C.8090700@oracle.com>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <56C914AC.6030107@gmx.com>
Date: Sun, 21 Feb 2016 09:36:44 +0800
MIME-Version: 1.0
In-Reply-To: <56C71B9C.8090700@oracle.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 02/19/2016 09:41 PM, Anand Jain wrote:
>
>
>   Saw below warn leading to bug when running btrfs/011, not
>   reproducible. Any idea ?
>
Seems like another wq_destroy race.

But it's hard to locate which wq is the cause from backtrace only.

What's the wq btrfs_stop_all_workers+0xcd is going to free?
And what's the wq end_workqueue_bio+0x85 is going to add?

Thanks,
Qu
> ------
> static void  __queue_work(..)
> {
> ::
>        /* if draining, only works from the same workqueue are allowed */
>          if (unlikely(wq->flags & __WQ_DRAINING) &&
>              WARN_ON_ONCE(!is_chained_work(wq)))       <---
>                  return;
>
> and then btrfs reported..
>    BUG: unable to handle kernel paging request
>
> (gdb) list *btrfs_destroy_workqueue+0x1f
> 0x6a43f is in btrfs_destroy_workqueue (fs/btrfs/async-thread.c:350).
> 345    }
> 346
> 347    static inline void
> 348    __btrfs_destroy_workqueue(struct __btrfs_workqueue *wq)
> 349    {
> 350        destroy_workqueue(wq->normal_wq); <---
> 351        trace_btrfs_workqueue_destroy(wq);
> 352        kfree(wq);
> 353    }
> 354
> ------
>
>
> Thanks, Anand
>
>
> [   61.038867] ------------[ cut here ]------------
> [   61.038876] WARNING: CPU: 0 PID: 117 at kernel/workqueue.c:1381
> __queue_work+0x37f/0x470()
> [   61.038878] Modules linked in: btrfs xor raid6_pq cfg80211 rfkill
> ppdev pcspkr psmouse serio_raw evdev joydev mousedev mac_hid
> acpi_cpufreq processor e1000 battery intel_agp intel_gtt video
> parport_pc parport ac button sch_fq_codel nfs lockd grace sunrpc fscache
> sr_mod cdrom sd_mod ata_generic pata_acpi hid_generic usbhid hid atkbd
> libps2 ata_piix ahci libahci ohci_pci ohci_hcd usbcore usb_common libata
> scsi_mod i8042 serio [last unloaded: xor]
> [   61.038908] CPU: 0 PID: 117 Comm: kworker/u2:5 Not tainted
> 4.5.0-rc3asj+ #10
> [   61.038909] Hardware name: innotek GmbH VirtualBox/VirtualBox, BIOS
> VirtualBox 12/01/2006
> [   61.038931] Workqueue: btrfs-readahead btrfs_readahead_helper [btrfs]
> [   61.038933]  0000000000000086 00000000bc179d46 ffff88011f403c40
> ffffffff813a2651
> [   61.038935]  0000000000000000 ffffffff817f7268 ffff88011f403c78
> ffffffff81079892
> [   61.038937]  0000000000000246 0000000000000080 ffff8800da4fcb20
> ffff88011a59db90
> [   61.038939] Call Trace:
> [   61.038941]  <IRQ>  [<ffffffff813a2651>] dump_stack+0x63/0x82
> [   61.038946]  [<ffffffff81079892>] warn_slowpath_common+0x82/0xc0
> [   61.038948]  [<ffffffff810799da>] warn_slowpath_null+0x1a/0x20
> [   61.038949]  [<ffffffff810910ef>] __queue_work+0x37f/0x470
> [   61.038951]  [<ffffffff81091207>] queue_work_on+0x27/0x40
> [   61.038964]  [<ffffffffa00933a0>] btrfs_queue_work+0x90/0xe0 [btrfs]
> [   61.038974]  [<ffffffffa0056785>] end_workqueue_bio+0x85/0xe0 [btrfs]
> [   61.038978]  [<ffffffff8136c4af>] bio_endio+0x3f/0x60
> [   61.038990]  [<ffffffffa008d075>] btrfs_end_bio+0x95/0x140 [btrfs]
> [   61.038992]  [<ffffffff8136c4af>] bio_endio+0x3f/0x60
> [   61.038995]  [<ffffffff8137390b>] blk_update_request+0x8b/0x310
> [   61.039002]  [<ffffffffa016ab43>] scsi_end_request+0x33/0x1d0 [scsi_mod]
> [   61.039008]  [<ffffffffa016d26a>] scsi_io_completion+0xba/0x5f0
> [scsi_mod]
> [   61.039012]  [<ffffffffa0164fae>] scsi_finish_command+0xbe/0xf0
> [scsi_mod]
> [   61.039017]  [<ffffffffa016cbc8>] scsi_softirq_done+0xf8/0x120
> [scsi_mod]
> [   61.039019]  [<ffffffff8137b36b>] blk_done_softirq+0x8b/0xb0
> [   61.039021]  [<ffffffff8107dadf>] __do_softirq+0xcf/0x290
> [   61.039023]  [<ffffffff8107de13>] irq_exit+0xa3/0xb0
> [   61.039026]  [<ffffffff815f2bc4>] do_IRQ+0x54/0xd0
> [   61.039028]  [<ffffffff815f0d42>] common_interrupt+0x82/0x82
> [   61.039028]  <EOI>  [<ffffffffa00c09d8>] ?
> reada_extent_put+0x128/0x1a0 [btrfs]
> [   61.039043]  [<ffffffff81387101>] ? set_task_ioprio+0x21/0xb0
> [   61.039054]  [<ffffffffa00c1b18>]
> reada_start_machine_worker+0x228/0x360 [btrfs]
> [   61.039065]  [<ffffffffa0092df7>] btrfs_scrubparity_helper+0x77/0x2f0
> [btrfs]
> [   61.039076]  [<ffffffffa00930ce>] btrfs_readahead_helper+0xe/0x10
> [btrfs]
> [   61.039078]  [<ffffffff8109223e>] process_one_work+0x14e/0x440
> [   61.039080]  [<ffffffff81092578>] worker_thread+0x48/0x4e0
> [   61.039081]  [<ffffffff81092530>] ? process_one_work+0x440/0x440
> [   61.039083]  [<ffffffff810980c8>] kthread+0xd8/0xf0
> [   61.039085]  [<ffffffff81097ff0>] ? kthread_worker_fn+0x180/0x180
> [   61.039087]  [<ffffffff815f060f>] ret_from_fork+0x3f/0x70
> [   61.039089]  [<ffffffff81097ff0>] ? kthread_worker_fn+0x180/0x180
> [   61.039090] ---[ end trace 1531237816dde88b ]---
> [   61.039119] BUG: unable to handle kernel paging request at
> 0000000100000000
> [   61.039121] IP: [<ffffffffa009340f>]
> btrfs_destroy_workqueue+0x1f/0xf0 [btrfs]
> [   61.039140] PGD 116827067 PUD 0
> [   61.039143] Oops: 0000 [#1] PREEMPT SMP DEBUG_PAGEALLOC
> [   61.039145] Modules linked in: btrfs xor raid6_pq cfg80211 rfkill
> ppdev pcspkr psmouse serio_raw evdev joydev mousedev mac_hid
> acpi_cpufreq processor e1000 battery intel_agp intel_gtt video
> parport_pc parport ac button sch_fq_codel nfs lockd grace sunrpc fscache
> sr_mod cdrom sd_mod ata_generic pata_acpi hid_generic usbhid hid atkbd
> libps2 ata_piix ahci libahci ohci_pci ohci_hcd usbcore usb_common libata
> scsi_mod i8042 serio [last unloaded: xor]
> [   61.039163] CPU: 0 PID: 11203 Comm: umount Tainted: G        W
> 4.5.0-rc3asj+ #10
> [   61.039164] Hardware name: innotek GmbH VirtualBox/VirtualBox, BIOS
> VirtualBox 12/01/2006
> [   61.039166] task: ffff8800d8d82ac0 ti: ffff8800be6a0000 task.ti:
> ffff8800be6a0000
> [   61.039167] RIP: 0010:[<ffffffffa009340f>]  [<ffffffffa009340f>]
> btrfs_destroy_workqueue+0x1f/0xf0 [btrfs]
> [   61.039178] RSP: 0018:ffff8800be6a3d70  EFLAGS: 00010206
> [   61.039179] RAX: ffff8800da4fcf01 RBX: ffff8800d9372000 RCX:
> 000000000011b080
> [   61.039180] RDX: 000000000011b000 RSI: ffff88011f418a40 RDI:
> ffff8800da4fcf90
> [   61.039181] RBP: ffff8800be6a3d88 R08: 0000000000018a40 R09:
> ffffffffa0093447
> [   61.039182] R10: ffffea0003693f00 R11: ffff8800da31d700 R12:
> ffff8800da4fcf90
> [   61.039183] R13: 0000000100000000 R14: 0000000000000000 R15:
> ffff8800d8d82ac0
> [   61.039185] FS:  00007f28c0315780(0000) GS:ffff88011f400000(0000)
> knlGS:0000000000000000
> [   61.039186] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [   61.039187] CR2: 0000000100000000 CR3: 0000000119b0f000 CR4:
> 00000000000406f0
> [   61.039190] Stack:
> [   61.039191]  ffff8800d9372000 ffff8800d9372b58 ffff8800daf04800
> ffff8800be6a3da0
> [   61.039193]  ffffffffa0057d6d ffff8800d9372000 ffff8800be6a3df8
> ffffffffa005b8f2
> [   61.039194]  ffff8800daf06800 ffff8800daf06e00 ffff8800be6a4000
> ffff8800be6a3dc8
> [   61.039196] Call Trace:
> [   61.039207]  [<ffffffffa0057d6d>] btrfs_stop_all_workers+0xcd/0xf0
> [btrfs]
> [   61.039218]  [<ffffffffa005b8f2>] close_ctree+0x182/0x360 [btrfs]
> [   61.039225]  [<ffffffffa002ec69>] btrfs_put_super+0x19/0x20 [btrfs]
> [   61.039231]  [<ffffffff811f695a>] generic_shutdown_super+0x6a/0xf0
> [   61.039233]  [<ffffffff811f6c72>] kill_anon_super+0x12/0x20
> [   61.039241]  [<ffffffffa002e908>] btrfs_kill_super+0x18/0x110 [btrfs]
> [   61.039243]  [<ffffffff811f6e13>] deactivate_locked_super+0x43/0x70
> [   61.039244]  [<ffffffff811f79fc>] deactivate_super+0x5c/0x60
> [   61.039247]  [<ffffffff8121328f>] cleanup_mnt+0x3f/0x90
> [   61.039248]  [<ffffffff81213322>] __cleanup_mnt+0x12/0x20
> [   61.039250]  [<ffffffff810963a3>] task_work_run+0x73/0x90
> [   61.039252]  [<ffffffff8100369e>] exit_to_usermode_loop+0xae/0xb0
> [   61.039254]  [<ffffffff81003b9e>] syscall_return_slowpath+0x4e/0x60
> [   61.039256]  [<ffffffff815f040c>] int_ret_from_sys_call+0x25/0x8f
> [   61.039257] Code: ff e8 2a fc f6 e0 eb a1 0f 1f 40 00 0f 1f 44 00 00
> 48 85 ff 74 53 55 48 89 e5 41 55 41 54 53 4c 8b 6f 08 49 89 fc 4d 85 ed
> 74 16 <49> 8b 7d 00 e8 d8 e4 ff e0 0f 1f 44 00 00 4c 89 ef e8 0b 06 14
> [   61.039276] RIP  [<ffffffffa009340f>]
> btrfs_destroy_workqueue+0x1f/0xf0 [btrfs]
> [   61.039287]  RSP <ffff8800be6a3d70>
> [   61.039288] CR2: 0000000100000000
> [   61.039290] ---[ end trace 1531237816dde88c ]---
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
