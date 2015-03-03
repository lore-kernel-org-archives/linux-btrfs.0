Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:28332 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751828AbbCCGhd (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 3 Mar 2015 01:37:33 -0500
Date: Tue, 3 Mar 2015 14:37:26 +0800
From: Liu Bo <bo.li.liu@oracle.com>
To: Marcel Ritter <ritter.marcel@gmail.com>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: Regression: kernel 4.0.0-rc1 - soft lockups
Message-ID: <20150303063725.GC30093@localhost.localdomain>
Reply-To: bo.li.liu@oracle.com
References: <CADurGxwyW0=BvyBC27qbGDZHn0ANdDARjvpsTwWN1Qpiiw2P8w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CADurGxwyW0=BvyBC27qbGDZHn0ANdDARjvpsTwWN1Qpiiw2P8w@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Mar 03, 2015 at 07:02:01AM +0100, Marcel Ritter wrote:
> Hi,
> 
> yesterday I did a kernel update on my btrfs test system (Ubuntu
> 14.04.2) from custom-build kernel 3.19-rc6 to 4.0.0-rc1.
> 
> Almost instantly after starting my test script, the system got stuck
> with soft lockups (the machine was running the very same test for
> weeks on the old kernel without problems,
> basically doing massive streaming i/o on a raid6 btrfs volume):
> 
> I found 2 types of messages in the logs:
> 
> one btrfs related:
> 
> [34165.540004] INFO: rcu_sched detected stalls on CPUs/tasks: { 3 7}
> (detected by 6, t=6990777 jiffies, g=67455, c=67454, q=0)
> [34165.540004] Task dump for CPU 3:
> [34165.540004] mount           D ffff8803ed266000     0 15156  15110 0x00000000
> [34165.540004]  0000000000000158 0000000000000014 ffff8803ecc13718
> ffff8803ecc136d8
> [34165.540004]  ffffffff8106075a 0000000000000000 0000000000000002
> 0000000000000000
> [34165.540004]  00000000ecc13728 ffff8803eb603128 0000000000000000
> 0000000000000000
> [34165.540004] Call Trace:
> [34165.540004]  [<ffffffff8106075a>] ? __do_page_fault+0x2fa/0x440
> [34165.540004]  [<ffffffff810608d1>] ? do_page_fault+0x31/0x70
> [34165.540004]  [<ffffffff81792778>] ? page_fault+0x28/0x30
> [34165.540004]  [<ffffffff810ae2ce>] ? pick_next_task_fair+0x53e/0x880
> [34165.540004]  [<ffffffff810ae2ce>] ? pick_next_task_fair+0x53e/0x880
> [34165.540004]  [<ffffffff8109707c>] ? dequeue_task+0x5c/0x80
> [34165.540004]  [<ffffffff8178b9a3>] ? __schedule+0xf3/0x960
> [34165.540004]  [<ffffffff8178c247>] ? schedule+0x37/0x90
> [34165.540004]  [<ffffffffa0896375>] ?
> btrfs_start_ordered_extent+0xd5/0x110 [btrfs]
> [34165.540004]  [<ffffffff810b3cb0>] ? prepare_to_wait_event+0x110/0x110
> [34165.540004]  [<ffffffffa0896884>] ?
> btrfs_wait_ordered_range+0xc4/0x120 [btrfs]
> [34165.540004]  [<ffffffffa08c0c18>] ?
> __btrfs_write_out_cache+0x378/0x470 [btrfs]
> [34165.540004]  [<ffffffffa08c104a>] ? btrfs_write_out_cache+0x9a/0x100 [btrfs]
> [34165.540004]  [<ffffffffa086af79>] ?
> btrfs_write_dirty_block_groups+0x159/0x560 [btrfs]
> [34165.540004]  [<ffffffffa08f2aa6>] ? commit_cowonly_roots+0x18d/0x2a4 [btrfs]
> [34165.540004]  [<ffffffffa087bd31>] ?
> btrfs_commit_transaction+0x521/0xa50 [btrfs]
> [34165.540004]  [<ffffffffa08a3fbe>] ? btrfs_create_uuid_tree+0x5e/0x110 [btrfs]
> [34165.540004]  [<ffffffffa087963f>] ? open_ctree+0x1dff/0x2200 [btrfs]
> [34165.540004]  [<ffffffffa084f7ce>] ? btrfs_mount+0x75e/0x8f0 [btrfs]
> [34165.540004]  [<ffffffff811ecbf9>] ? mount_fs+0x39/0x180
> [34165.540004]  [<ffffffff81192405>] ? __alloc_percpu+0x15/0x20
> [34165.540004]  [<ffffffff812082bb>] ? vfs_kern_mount+0x6b/0x120
> [34165.540004]  [<ffffffff8120afe4>] ? do_mount+0x204/0xb30
> [34165.540004]  [<ffffffff8120bc0b>] ? SyS_mount+0x8b/0xe0
> [34165.540004]  [<ffffffff817905ed>] ? system_call_fastpath+0x16/0x1b
> [34165.540004] Task dump for CPU 7:
> [34165.540004] kworker/u16:1   R  running task        0 14518      2 0x00000008
> [34165.540004] Workqueue: btrfs-freespace-write
> btrfs_freespace_write_helper [btrfs]
> [34165.540004]  0000000000000200 ffff8803eac6fdf8 ffffffffa08ac242
> ffff8803eac6fe48
> [34165.540004]  ffffffff8108b64f 00000000f1091400 0000000000000000
> ffff8803eca58000
> [34165.540004]  ffff8803ea9ed3c0 ffff8803f1091418 ffff8803f1091400
> ffff8803eca58000
> [34165.540004] Call Trace:
> [34165.540004]  [<ffffffffa08ac242>] ?
> btrfs_freespace_write_helper+0x12/0x20 [btrfs]
> [34165.540004]  [<ffffffff8108b64f>] ? process_one_work+0x14f/0x420
> [34165.540004]  [<ffffffff8108be08>] ? worker_thread+0x118/0x510
> [34165.540004]  [<ffffffff8108bcf0>] ? rescuer_thread+0x3d0/0x3d0
> [34165.540004]  [<ffffffff81091212>] ? kthread+0xd2/0xf0
> [34165.540004]  [<ffffffff81091140>] ? kthread_create_on_node+0x180/0x180
> [34165.540004]  [<ffffffff8179053c>] ? ret_from_fork+0x7c/0xb0
> [34165.540004]  [<ffffffff81091140>] ? kthread_create_on_node+0x180/0x180
> 
> 
> and one general (related to "native_flush_tlb_other":
> 
> [34152.604004] NMI watchdog: BUG: soft lockup - CPU#6 stuck for 23s!
> [rs:main Q:Reg:490]
> [34152.604004] Modules linked in: btrfs(E) xor(E) radeon(E) ttm(E)
> drm_kms_helper(E) kvm(E) drm(E) raid6_pq(E) i2c_algo_bit(E) ipmi_si
> (E) amd64_edac_mod(E) serio_raw(E) hpilo(E) hpwdt(E) edac_core(E)
> shpchp(E) k8temp(E) mac_hid(E) edac_mce_amd(E) nfsd(E) auth_rpcgss(E
> ) nfs_acl(E) nfs(E) lockd(E) grace(E) sunrpc(E) fscache(E) lp(E)
> parport(E) hpsa(E) pata_acpi(E) hid_generic(E) psmouse(E) usbhid(E) b
> nx2(E) cciss(E) hid(E) pata_amd(E)
> [34152.604004] CPU: 6 PID: 490 Comm: rs:main Q:Reg Tainted: G      D W
>   EL  4.0.0-rc1-custom #1
> [34152.604004] Hardware name: HP ProLiant DL585 G2   , BIOS A07 05/02/2011
> [34152.604004] task: ffff8803eecd9910 ti: ffff8803ecb30000 task.ti:
> ffff8803ecb30000
> [34152.604004] RIP: 0010:[<ffffffff810f1e3a>]  [<ffffffff810f1e3a>]
> smp_call_function_many+0x20a/0x270
> [34152.604004] RSP: 0018:ffff8803ecb33cf8  EFLAGS: 00000202
> [34152.604004] RAX: 0000000000000000 RBX: ffffffff81cdd140 RCX: ffff8803ffc19700
> [34152.604004] RDX: 0000000000000000 RSI: 0000000000000100 RDI: 0000000000000000
> [34152.604004] RBP: ffff8803ecb33d38 R08: ffff8803ffd961c8 R09: 0000000000000004
> [34152.604004] R10: 0000000000000004 R11: 0000000000000246 R12: 0000000000000000
> [34152.604004] R13: ffff880300000040 R14: ffff8803ecb33ca0 R15: ffff8803ecb33ca8
> [34152.604004] FS:  00007f9cf6dae700(0000) GS:ffff8803ffd80000(0000)
> knlGS:0000000000000000
> [34152.672920] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [34152.672920] CR2: 00007f9ce80091a8 CR3: 00000003e50fe000 CR4: 00000000000007e0
> [34152.672920] Stack:
> [34152.672920]  00000001ecb33de8 0000000000016180 00007f9cf0024fff
> ffff8803eb726900
> [34152.672920]  ffff8803eb726bd0 00007f9cf0025000 00007f9cf0021000
> 0000000000000004
> [34152.672920]  ffff8803ecb33d68 ffffffff8106722e ffff8803ecb33d68
> ffff8803eb726900
> [34152.672920] Call Trace:
> [34152.672920]  [<ffffffff8106722e>] native_flush_tlb_others+0x2e/0x30
> [34152.672920]  [<ffffffff81067354>] flush_tlb_mm_range+0x64/0x170
> [34152.672920]  [<ffffffff8119e66e>] tlb_flush_mmu_tlbonly+0x7e/0xe0
> [34152.672920]  [<ffffffff8119eed4>] tlb_finish_mmu+0x14/0x50
> [34152.672920]  [<ffffffff811a0cea>] zap_page_range+0xca/0x100
> [34152.672920]  [<ffffffff811b3993>] SyS_madvise+0x363/0x790
> [34152.672920]  [<ffffffff817905ed>] system_call_fastpath+0x16/0x1b
> [34152.672920] Code: 9d 5c 2b 00 3b 05 7b b2 c2 00 89 c2 0f 8d 83 fe
> ff ff 48 98 49 8b 4d 00 48 03 0c c5 40 b1 d1 81 f6 41 18 01 74 cb
>  0f 1f 00 f3 90 <f6> 41 18 01 75 f8 eb be 0f b6 4d c4 4c 89 fa 4c 89 f6 44 89 ef
> 
> So I'm not totally sure if this is a btrfs problem, or something else
> got broken in 4.0.0-rc1.
> 
> Maybe someone can have a look.
> 
> If you need more information just let me know.

Is it reproducible?

>From the stacks about btrfs, it's been stopped at mount stage, so it's likely to
be unrelated to btrfs.

Thanks,

-liubo

> 
> Bye,
>    Marcel
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
