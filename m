Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f170.google.com ([209.85.223.170]:32779 "EHLO
	mail-io0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754669AbbJVKMD (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 22 Oct 2015 06:12:03 -0400
Received: by iodv82 with SMTP id v82so85923650iod.0
        for <linux-btrfs@vger.kernel.org>; Thu, 22 Oct 2015 03:12:02 -0700 (PDT)
MIME-Version: 1.0
Reply-To: fdmanana@gmail.com
In-Reply-To: <n0acdp$p4d$1@ger.gmane.org>
References: <1445503918-22398-1-git-send-email-fdmanana@kernel.org>
	<n0acdp$p4d$1@ger.gmane.org>
Date: Thu, 22 Oct 2015 11:12:01 +0100
Message-ID: <CAL3q7H7yAqzDR-7TOX9VCWz-7osAR2NzO3NASkr+M=YF64Pnyw@mail.gmail.com>
Subject: Re: [PATCH] Btrfs: fix regression when running delayed references
From: Filipe Manana <fdmanana@gmail.com>
To: Koen Kooi <koen@dominion.thruhere.net>
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Oct 22, 2015 at 11:05 AM, Koen Kooi <koen@dominion.thruhere.net> wrote:
> Op 22-10-15 om 10:47 schreef fdmanana@kernel.org:
>> From: Filipe Manana <fdmanana@suse.com>
>>
>> In the kernel 4.2 merge window we had a refactoring/rework of the delayed
>> references implementation in order to fix certain problems with qgroups.
>> However that rework introduced one more regression that leads to the
>> following trace when running delayed references for metadata:
>>
>> [35908.064664] kernel BUG at fs/btrfs/extent-tree.c:1832!
>> [35908.065201] invalid opcode: 0000 [#1] PREEMPT SMP DEBUG_PAGEALLOC
>> [35908.065201] Modules linked in: dm_flakey dm_mod btrfs crc32c_generic xor raid6_pq nfsd auth_rpcgss oid_registry nfs_acl nfs lockd grace fscache sunrpc loop fuse parport_pc psmouse i2
>> [35908.065201] CPU: 14 PID: 15014 Comm: kworker/u32:9 Tainted: G        W       4.3.0-rc5-btrfs-next-17+ #1
>> [35908.065201] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS rel-1.8.1-0-g4adadbd-20150316_085822-nilsson.home.kraxel.org 04/01/2014
>> [35908.065201] Workqueue: btrfs-extent-refs btrfs_extent_refs_helper [btrfs]
>> [35908.065201] task: ffff880114b7d780 ti: ffff88010c4c8000 task.ti: ffff88010c4c8000
>> [35908.065201] RIP: 0010:[<ffffffffa04928b5>]  [<ffffffffa04928b5>] insert_inline_extent_backref+0x52/0xb1 [btrfs]
>> [35908.065201] RSP: 0018:ffff88010c4cbb08  EFLAGS: 00010293
>> [35908.065201] RAX: 0000000000000000 RBX: ffff88008a661000 RCX: 0000000000000000
>> [35908.065201] RDX: ffffffffa04dd58f RSI: 0000000000000001 RDI: 0000000000000000
>> [35908.065201] RBP: ffff88010c4cbb40 R08: 0000000000001000 R09: ffff88010c4cb9f8
>> [35908.065201] R10: 0000000000000000 R11: 000000000000002c R12: 0000000000000000
>> [35908.065201] R13: ffff88020a74c578 R14: 0000000000000000 R15: 0000000000000000
>> [35908.065201] FS:  0000000000000000(0000) GS:ffff88023edc0000(0000) knlGS:0000000000000000
>> [35908.065201] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
>> [35908.065201] CR2: 00000000015e8708 CR3: 0000000102185000 CR4: 00000000000006e0
>> [35908.065201] Stack:
>> [35908.065201]  ffff88010c4cbb18 0000000000000f37 ffff88020a74c578 ffff88015a408000
>> [35908.065201]  ffff880154a44000 0000000000000000 0000000000000005 ffff88010c4cbbd8
>> [35908.065201]  ffffffffa0492b9a 0000000000000005 0000000000000000 0000000000000000
>> [35908.065201] Call Trace:
>> [35908.065201]  [<ffffffffa0492b9a>] __btrfs_inc_extent_ref+0x8b/0x208 [btrfs]
>> [35908.065201]  [<ffffffffa0497117>] ? __btrfs_run_delayed_refs+0x4d4/0xd33 [btrfs]
>> [35908.065201]  [<ffffffffa049773d>] __btrfs_run_delayed_refs+0xafa/0xd33 [btrfs]
>> [35908.065201]  [<ffffffffa04a976a>] ? join_transaction.isra.10+0x25/0x41f [btrfs]
>> [35908.065201]  [<ffffffffa04a97ed>] ? join_transaction.isra.10+0xa8/0x41f [btrfs]
>> [35908.065201]  [<ffffffffa049914d>] btrfs_run_delayed_refs+0x75/0x1dd [btrfs]
>> [35908.065201]  [<ffffffffa04992f1>] delayed_ref_async_start+0x3c/0x7b [btrfs]
>> [35908.065201]  [<ffffffffa04d4b4f>] normal_work_helper+0x14c/0x32a [btrfs]
>> [35908.065201]  [<ffffffffa04d4e93>] btrfs_extent_refs_helper+0x12/0x14 [btrfs]
>> [35908.065201]  [<ffffffff81063b23>] process_one_work+0x24a/0x4ac
>> [35908.065201]  [<ffffffff81064285>] worker_thread+0x206/0x2c2
>> [35908.065201]  [<ffffffff8106407f>] ? rescuer_thread+0x2cb/0x2cb
>> [35908.065201]  [<ffffffff8106407f>] ? rescuer_thread+0x2cb/0x2cb
>> [35908.065201]  [<ffffffff8106904d>] kthread+0xef/0xf7
>> [35908.065201]  [<ffffffff81068f5e>] ? kthread_parkme+0x24/0x24
>> [35908.065201]  [<ffffffff8147d10f>] ret_from_fork+0x3f/0x70
>> [35908.065201]  [<ffffffff81068f5e>] ? kthread_parkme+0x24/0x24
>> [35908.065201] Code: 6a 01 41 56 41 54 ff 75 10 41 51 4d 89 c1 49 89 c8 48 8d 4d d0 e8 f6 f1 ff ff 48 83 c4 28 85 c0 75 2c 49 81 fc ff 00 00 00 77 02 <0f> 0b 4c 8b 45 30 8b 4d 28 45 31
>> [35908.065201] RIP  [<ffffffffa04928b5>] insert_inline_extent_backref+0x52/0xb1 [btrfs]
>> [35908.065201]  RSP <ffff88010c4cbb08>
>> [35908.310885] ---[ end trace fe4299baf0666457 ]---
>
> Would this also solve this:

No, what you get is a totally different and unrelated problem.

>
> Oct 22 12:03:20 beast kernel: WARNING: CPU: 5 PID: 323 at lib/list_debug.c:62
> __list_del_entry+0x5a/0x98()
> Oct 22 12:03:20 beast kernel: list_del corruption. next->prev should be
> ffff88033f864500, but was ffff88033f8642c0
> Oct 22 12:03:20 beast kernel: Modules linked in: arc4 md4 nls_utf8 cifs
> dns_resolver fscache ipt_MASQUERADE nf_nat_masquerade_ipv4 iptable_nat
> nf_conntrack_ipv4 nf_defrag_ipv4 nf_nat_ipv4 nf_nat nf_conntrack veth loop b43
> mac80211 cfg80211 ssb mmc_core kvm_intel kvm crct10dif_pclmul crc32_pclmul
> ghash_clmulni_intel serio_raw sb_edac edac_core i2c_i801 btusb btrtl btintel
> btbcm bluetooth joydev bcma rfkill cp210x tpm_infineon tpm_tis tpm
> sch_fq_codel radeon crc32c_intel ttm drm_kms_helper
> Oct 22 12:03:20 beast kernel: CPU: 5 PID: 323 Comm: kworker/u16:12 Tainted: G
>        W       4.2.2 #50
> Oct 22 12:03:20 beast kernel: Hardware name: System manufacturer System
> Product Name/X79-DELUXE, BIOS 0901 06/20/2014
> Oct 22 12:03:20 beast kernel: Workqueue: btrfs-delalloc btrfs_delalloc_helper
> Oct 22 12:03:20 beast kernel:  0000000000000009 ffff88013993fb98
> ffffffff8170b663 0000000000000006
> Oct 22 12:03:20 beast kernel:  ffff88013993fbe8 ffff88013993fbd8
> ffffffff8106aa40 ffff88013993fc78
> Oct 22 12:03:20 beast kernel:  ffffffff813392c3 ffff88033f864480
> ffff88033f864500 ffff880ba968d510
> Oct 22 12:03:20 beast kernel: Call Trace:
> Oct 22 12:03:20 beast kernel:  [<ffffffff8170b663>] dump_stack+0x45/0x57
> Oct 22 12:03:20 beast kernel:  [<ffffffff8106aa40>] warn_slowpath_common+0xa1/0xbb
> Oct 22 12:03:20 beast kernel:  [<ffffffff813392c3>] ? __list_del_entry+0x5a/0x98
> Oct 22 12:03:20 beast kernel:  [<ffffffff8106aaa0>] warn_slowpath_fmt+0x46/0x48
> Oct 22 12:03:20 beast kernel:  [<ffffffff811699ba>] ? kmem_cache_alloc+0x56/0x10b
> Oct 22 12:03:20 beast kernel:  [<ffffffff813392c3>] __list_del_entry+0x5a/0x98
> Oct 22 12:03:20 beast kernel:  [<ffffffff8127063d>]
> remove_extent_mapping+0x4d/0x65
> Oct 22 12:03:20 beast kernel:  [<ffffffff8126d38f>]
> btrfs_drop_extent_cache+0x34f/0x388
> Oct 22 12:03:20 beast kernel:  [<ffffffff8124edb5>] ?
> btrfs_reserve_extent+0x75/0x120
> Oct 22 12:03:20 beast kernel:  [<ffffffff81264380>]
> submit_compressed_extents+0x1c8/0x430
> Oct 22 12:03:20 beast kernel:  [<ffffffff8126466f>] async_cow_submit+0x87/0x8c
> Oct 22 12:03:20 beast kernel:  [<ffffffff81284fe2>] normal_work_helper+0x125/0x1c5
> Oct 22 12:03:20 beast kernel:  [<ffffffff812850a8>]
> btrfs_delalloc_helper+0x12/0x14
> Oct 22 12:03:20 beast kernel:  [<ffffffff8107d91c>] process_one_work+0x165/0x29a
> Oct 22 12:03:20 beast kernel:  [<ffffffff8107ded4>] worker_thread+0x1ef/0x29a
> Oct 22 12:03:20 beast kernel:  [<ffffffff8107dce5>] ? rescuer_thread+0x265/0x265
> Oct 22 12:03:20 beast kernel:  [<ffffffff8107dce5>] ? rescuer_thread+0x265/0x265
> Oct 22 12:03:20 beast kernel:  [<ffffffff810820e1>] kthread+0xb7/0xbf
> Oct 22 12:03:20 beast kernel:  [<ffffffff8108202a>] ? kthread_parkme+0x24/0x24
> Oct 22 12:03:20 beast kernel:  [<ffffffff817121cf>] ret_from_fork+0x3f/0x70
> Oct 22 12:03:20 beast kernel:  [<ffffffff8108202a>] ? kthread_parkme+0x24/0x24
> Oct 22 12:03:20 beast kernel: ---[ end trace 395ca73acb05ecbc ]---
>
> Using the following kernel: Linux beast 4.2.2 #50 SMP Wed Sep 30 13:42:29 CEST
> 2015 x86_64 GNU/Linux
>
> The above trace shows up every few minutes, basically during every rsync.
>
> regards,
>
> Koen
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



-- 
Filipe David Manana,

"Reasonable men adapt themselves to the world.
 Unreasonable men adapt the world to themselves.
 That's why all progress depends on unreasonable men."
