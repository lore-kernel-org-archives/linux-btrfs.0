Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:33809 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753879AbcHEPMx (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 5 Aug 2016 11:12:53 -0400
From: Chris Mason <clm@fb.com>
Subject: Re: Crash in btrfs_uuid_tree_iterate during mount
To: Nikolay Borisov <kernel@kyup.com>, <linux-btrfs@vger.kernel.org>
References: <57A473B0.2040203@kyup.com>
CC: SiteGround Operations <operations@siteground.com>
Message-ID: <657b7978-1d08-f052-8ebc-f061ecb542d0@fb.com>
Date: Fri, 5 Aug 2016 11:12:42 -0400
MIME-Version: 1.0
In-Reply-To: <57A473B0.2040203@kyup.com>
Content-Type: text/plain; charset="utf-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


On 08/05/2016 07:08 AM, Nikolay Borisov wrote:
> Hello,
>
> Recently I started getting the following crashes on some servers,
> running btrfs:
>
> [340435.480338] BTRFS info (device loop7): disk space caching is enabled
> [340435.480509] BTRFS: has skinny extents
> [340441.716174] BTRFS: checking UUID tree
> [340441.912070] BUG: unable to handle kernel NULL pointer dereference at 0000000000000098
> [340441.912463] IP: [<ffffffffa081f774>] btrfs_uuid_tree_iterate+0xf4/0x2d0 [btrfs]
> [340441.912823] PGD 0
> [340441.913035] Oops: 0000 [#1] SMP
> [340441.913302] Modules linked in:
> [340441.916996] CPU: 10 PID: 24990 Comm: btrfs-uuid Tainted: P        W  O    4.4.14-clouder1 #55
> [340441.917287] Hardware name: Supermicro X9DRD-iF/LF/X9DRD-iF, BIOS 3.2 01/16/2015
> [340441.917573] task: ffff8801b95c1b80 ti: ffff88034e504000 task.ti: ffff88034e504000
> [340441.917859] RIP: 0010:[<ffffffffa081f774>]  [<ffffffffa081f774>] btrfs_uuid_tree_iterate+0xf4/0x2d0 [btrfs]
> [340441.918212] RSP: 0018:ffff88034e507e20  EFLAGS: 00010246
> [340441.918382] RAX: 0000000000000000 RBX: 0000160000000000 RCX: ffff880000000000
> [340441.918665] RDX: 0000000000000001 RSI: ffff8801e3abd140 RDI: ffff88046f027f00
> [340441.918952] RBP: ffff88034e507ea8 R08: 000060fb80001760 R09: ffffffffa07ac1de
> [340441.919236] R10: ffffe8ffffd41760 R11: ffffea00078eaf40 R12: ffff8801b98ab750
> [340441.919521] R13: 00000000fffffffe R14: ffff8801e3abd140 R15: ffff880049586000
> [340441.919810] FS:  0000000000000000(0000) GS:ffff88047fd40000(0000) knlGS:0000000000000000
> [340441.920097] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [340441.920267] CR2: 0000000000000098 CR3: 0000000001c0a000 CR4: 00000000000406e0
> [340441.920554] Stack:
> [340441.920717]  ffff880049586000 ffff8801b98ab750 00003f7b00014fc0 ffff8803711dec08
> [340441.921186]  ffffffffa07d0c40 ffff880332342000 0000000000000114 1b7088046d7612f8
> [340441.921655]  8cfb42689378e508 70157e0ade97f5d6 8c42689378e5081b 15157e0ade97f5d6
> [340441.922126] Call Trace:
> [340441.922315]  [<ffffffffa07d0c40>] ? find_live_mirror.isra.18+0xc0/0xc0 [btrfs]
> [340441.922614]  [<ffffffffa07d0ae0>] ? btrfs_uuid_scan_kthread+0x3c0/0x3c0 [btrfs]
> [340441.922917]  [<ffffffffa07d0afb>] btrfs_uuid_rescan_kthread+0x1b/0x60 [btrfs]
> [340441.923197]  [<ffffffff8107161f>] kthread+0xef/0x110
> [340441.923363]  [<ffffffff81071530>] ? kthread_park+0x60/0x60
> [340441.923531]  [<ffffffff816149ff>] ret_from_fork+0x3f/0x70
> [340441.923697]  [<ffffffff81071530>] ? kthread_park+0x60/0x60
> [340441.923863] Code: 0f 86 a0 00 00 00 48 bb 00 00 00 00 00 16 00 00 41 8b 44 24 40 48 b9 00 00 00 00 00 88 ff ff 8d 50 01 49 8b 04 24 41 89 54 24 40 <48> 03 98 98 00 00 00 48 89 d8 48 c1 f8 06 48 c1 e0 0c 3b 54 08
> [340441.927296] RIP  [<ffffffffa081f774>] btrfs_uuid_tree_iterate+0xf4/0x2d0 [btrfs]
> [340441.927641]  RSP <ffff88034e507e20>
> [340441.927806] CR2: 0000000000000098
>
>
> ffffffffa081f774 is in the heavily inlined btrfs_next_item. Here
> is the decoded instructions, right before the crash with annotations:
>
>    0:	0f 86 a0 00 00 00    	jbe    0xa6
>    6:	48 bb 00 00 00 00 00 	mov    $0x160000000000,%rbx
>    d:	16 00 00
>   10:	41 8b 44 24 40       	mov    0x40(%r12),%eax ; r12 is btrfs_path, eax points to first slot
>   15:	48 b9 00 00 00 00 00 	mov    $0xffff880000000000,%rcx
>   1c:	88 ff ff
>   1f:	8d 50 01             	lea    0x1(%rax),%edx ; incr slot
>   22:	49 8b 04 24          	mov    (%r12),%rax ; load first extent_buffer in rax
>   26:	41 89 54 24 40       	mov    %edx,0x40(%r12) ; save incremented slot
>   2b:*	48 03 98 98 00 00 00 	add    0x98(%rax),%rbx <-- trapping instruction ; load the first page from the extent_buffer
>   32:	48 89 d8             	mov    %rbx,%rax
>   35:	48 c1 f8 06          	sar    $0x6,%rax
>   39:	48 c1 e0 0c          	shl    $0xc,%rax
>   3d:	3b                   	.byte 0x3b
>   3e:	54                   	push   %rsp
>   3f:	08                   	.byte 0x8
>
> So as can be seen rax is zero and naturally dereferencing it is
> also zero. What's interesting is the content of the btrf_path:
>
> struct btrfs_path {
>   nodes = {0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0},
>   slots = {1, 0, 0, 0, 0, 0, 0, 0},
>   locks = {0, 0, 0, 0, 0, 0, 0, 0},
>   reada = 0,
>   lowest_level = 0,
>   search_for_split = 0,
>   keep_locks = 0,
>   skip_locking = 0,
>   leave_spinning = 0,
>   search_commit_root = 0,
>   need_commit_sem = 0,
>   skip_release_on_error = 0
> }
>
> Any ideas how come btrfs_path can be all zero, the one in
> the first slot comes from the increment in btrfs_next_old_item.

Thanks for all the extra details.  It really must be this:

                        if (ret > 0) { 
                                 btrfs_release_path(path); 
                                 ret = btrfs_uuid_iter_rem(root, uuid, key.type,
                                                           subid_cpu); 
                                 if (ret == 0) { 
                                         /* 
                                          * this might look inefficient, but the
                                          * justification is that it is an
                                          * exception that check_func returns 1,
                                          * and that in the regular case only one
                                          * entry per UUID exists. 
                                          */ 
                                         goto again_search_slot; 
                                 } 
                                 if (ret < 0 && ret != -ENOENT) 
                                         goto out; 
                         } 
                         item_size -= sizeof(subid_le); 
                         offset += sizeof(subid_le);


We've released the path, which would explain why its full of NULL.  ret
was ENOENT, so it kept on going, and we fell through to
btrfs_next_item()

Once the path is released, we should either be searching again or
exiting.  A goto again_search_slot would probably fix it, but I'd want
to also bump the key so we don't just process the same item over and
over again.

Can you reproduce this reliably?  I'd hate to patch it now and make more
problems later just because we didn't fully understand the items we were
tripping over.

-chris
