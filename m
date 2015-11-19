Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ig0-f180.google.com ([209.85.213.180]:33880 "EHLO
	mail-ig0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752185AbbKSNQn (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 19 Nov 2015 08:16:43 -0500
Received: by igvg19 with SMTP id g19so10672488igv.1
        for <linux-btrfs@vger.kernel.org>; Thu, 19 Nov 2015 05:16:42 -0800 (PST)
MIME-Version: 1.0
Reply-To: fdmanana@gmail.com
In-Reply-To: <20151119130827.GC31035@twin.jikos.cz>
References: <1446835002-11751-1-git-send-email-jmaggard@netgear.com>
	<20151119130827.GC31035@twin.jikos.cz>
Date: Thu, 19 Nov 2015 13:16:42 +0000
Message-ID: <CAL3q7H4vJKPKArZL1JWghHQU+JKqgXA8b0C5fr9+19TPHJKH1Q@mail.gmail.com>
Subject: Re: [PATCH] btrfs: qgroup: fix quota disable during rescan
From: Filipe Manana <fdmanana@gmail.com>
To: "dsterba@suse.cz" <dsterba@suse.cz>, Justin Maggard <jmaggard10@gmail.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
        Justin Maggard <jmaggard@netgear.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Nov 19, 2015 at 1:08 PM, David Sterba <dsterba@suse.cz> wrote:
> Hi,
>
> On Fri, Nov 06, 2015 at 10:36:42AM -0800, Justin Maggard wrote:
>> There's a race condition that leads to a NULL pointer dereference if you
>> disable quotas while a quota rescan is running.  To fix this, we just need
>> to wait for the quota rescan worker to actually exit before tearing down
>> the quota structures.
>
> I see a reproducible crash in btrfs/115 (the fstest for this patch).
> This is with 4.4-rc1, so the patch is included:

That's the expected crash, the patch isn't in 4.4-rc1.

>
> [ 5080.190396] run fstests btrfs/115
> [ 5081.340201] BTRFS: device fsid d5b249fe-94a7-4c82-ab6c-bd03710ef9c1 devid 1 transid 3 /dev/sdb1
> [ 5081.405560] BTRFS info (device sdb1): disk space caching is enabled
> [ 5081.413720] BTRFS: has skinny extents
> [ 5081.419244] BTRFS: flagging fs with big metadata feature
> [ 5081.428893] BTRFS: detected SSD devices, enabling SSD mode
> [ 5081.435774] BTRFS: creating UUID tree
> [ 5219.923981] 115 (24870): drop_caches: 3
> [ 5220.824915] BUG: unable to handle kernel NULL pointer dereference at 00000000000001f0
> [ 5220.833608] IP: [<ffffffffa003e145>] start_transaction+0x35/0x5c0 [btrfs]
> [ 5220.841277] PGD 0
> [ 5220.844155] Oops: 0000 [#1] SMP DEBUG_PAGEALLOC
> [ 5220.849664] Modules linked in: dm_flakey rpcsec_gss_krb5 loop btrfs
> [ 5220.856831] CPU: 1 PID: 23308 Comm: kworker/u4:0 Tainted: G        W       4.4.0-rc1-default+ #286
> [ 5220.866612] Hardware name: Intel Corporation SandyBridge Platform/To be filled by O.E.M., BIOS ASNBCPT1.86C.0031.B00.1006301607 06/30/2010
> [ 5220.880689] Workqueue: btrfs-qgroup-rescan btrfs_qgroup_rescan_helper [btrfs]
> [ 5220.888660] task: ffff8800a0812780 ti: ffff8800a0d80000 task.ti: ffff8800a0d80000
> [ 5220.896963] RIP: 0010:[<ffffffffa003e145>]  [<ffffffffa003e145>] start_transaction+0x35/0x5c0 [btrfs]
> [ 5220.907054] RSP: 0018:ffff8800a0d839b8  EFLAGS: 00010297
> [ 5220.913219] RAX: ffff8800a0812780 RBX: 0000000000000001 RCX: 0000000000000002
> [ 5220.921192] RDX: 0000000000000201 RSI: 0000000000000001 RDI: 0000000000000000
> [ 5220.929163] RBP: ffff8800a0d83a58 R08: 0000000000000000 R09: 0000000000000000
> [ 5220.937125] R10: 0000000000000001 R11: 0000000000000004 R12: 0000000000000000
> [ 5220.945093] R13: 0000000000000201 R14: 00000000fffffffc R15: ffff8801470e0000
> [ 5220.953056] FS:  0000000000000000(0000) GS:ffff880148e00000(0000) knlGS:0000000000000000
> [ 5220.961989] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [ 5220.968562] CR2: 00000000000001f0 CR3: 000000000220a000 CR4: 00000000000406e0
> [ 5220.976530] Stack:
> [ 5220.979381]  0000000000000000 ffff8800a0d83a68 0000000000000000 ffffffff81b1bde6
> [ 5220.987680]  0000000000000246 0000000000000000 0000000000000000 ffff8801470e22c0
> [ 5220.995967]  0000000000000000 ffffffff81b1bf5e 0000000000000001 0000000000000000
> [ 5221.004277] Call Trace:
> [ 5221.007578]  [<ffffffff81b1bde6>] ? __mutex_unlock_slowpath+0xb6/0x170
> [ 5221.014962]  [<ffffffff81b1bf5e>] ? mutex_unlock+0xe/0x10
> [ 5221.021203]  [<ffffffffa003ea69>] ? btrfs_start_transaction+0x9/0x20 [btrfs]
> [ 5221.029108]  [<ffffffffa003ea78>] btrfs_start_transaction+0x18/0x20 [btrfs]
> [ 5221.036912]  [<ffffffffa00b1345>] btrfs_qgroup_rescan_worker+0x375/0x540 [btrfs]
> [ 5221.045142]  [<ffffffff810d708e>] ? do_raw_spin_unlock+0xe/0xa0
> [ 5221.051901]  [<ffffffffa0072b73>] normal_work_helper+0xa3/0x5b0 [btrfs]
> [ 5221.059334]  [<ffffffff811409c6>] ? stack_trace_call+0x46/0x70
> [ 5221.065981]  [<ffffffff81b2125b>] ? ftrace_call+0x5/0x34
> [ 5221.072113]  [<ffffffffa0073289>] ? btrfs_qgroup_rescan_helper+0x9/0x20 [btrfs]
> [ 5221.080243]  [<ffffffffa0073292>] btrfs_qgroup_rescan_helper+0x12/0x20 [btrfs]
> [ 5221.088299]  [<ffffffff8109be65>] process_one_work+0x215/0x6a0
> [ 5221.094966]  [<ffffffff8109bdca>] ? process_one_work+0x17a/0x6a0
> [ 5221.101792]  [<ffffffff810d703d>] ? do_raw_spin_trylock+0xd/0x50
> [ 5221.108612]  [<ffffffff8109c7e6>] worker_thread+0x66/0x540
> [ 5221.114921]  [<ffffffffa000006b>] ? 0xffffffffa000006b
> [ 5221.120852]  [<ffffffff810c5e3d>] ? complete+0x4d/0x60
> [ 5221.126799]  [<ffffffff810a8fda>] ? finish_task_switch+0xba/0x220
> [ 5221.133672]  [<ffffffff81b1ed50>] ? _raw_spin_unlock_irq+0x30/0x40
> [ 5221.140654]  [<ffffffff81b1eda0>] ? _raw_spin_unlock_irqrestore+0x40/0x60
> [ 5221.148242]  [<ffffffff810a2cc2>] ? __kthread_parkme+0x12/0xa0
> [ 5221.154873]  [<ffffffff81b189ee>] ? schedule+0xe/0x90
> [ 5221.160721]  [<ffffffff810a2cc2>] ? __kthread_parkme+0x12/0xa0
> [ 5221.167339]  [<ffffffff8109c780>] ? rescuer_thread+0x450/0x450
> [ 5221.173948]  [<ffffffff810a38ff>] kthread+0xef/0x110
> [ 5221.179686]  [<ffffffff810af92e>] ? schedule_tail+0x1e/0xd0
> [ 5221.186027]  [<ffffffff810a3810>] ? flush_kthread_worker+0x1b0/0x1b0
> [ 5221.193122]  [<ffffffff81b1f33f>] ret_from_fork+0x3f/0x70
> [ 5221.199252]  [<ffffffff810a3810>] ? flush_kthread_worker+0x1b0/0x1b0
> [ 5221.206325] Code: 41 54 53 48 83 ec 78 e8 ca 30 ae e1 65 48 8b 04 25 00 af 00 00 48 83 b8 18 12 00 00 01 49 89 fc 89 f3 41 89 d5 0f 84 06 05 00 00 <49> 8b 84 24 f0 01 00 00 48 8b 90 48 23 00 00
> [ 5221.227853] RIP  [<ffffffffa003e145>] start_transaction+0x35/0x5c0 [btrfs]
> [ 5221.235505]  RSP <ffff8800a0d839b8>
> [ 5221.239737] CR2: 00000000000001f0
> [ 5221.246665] ---[ end trace f99504dd70773300 ]---
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



-- 
Filipe David Manana,

"Reasonable men adapt themselves to the world.
 Unreasonable men adapt the world to themselves.
 That's why all progress depends on unreasonable men."
