Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:50321 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751992AbcGAU0H (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 1 Jul 2016 16:26:07 -0400
Subject: Re: btrfs/113: Assertion failure
To: Chandan Rajendra <chandan@linux.vnet.ibm.com>
References: <2400102.bkxfPSyYym@localhost.localdomain>
 <2057588.odf3SpF3Kc@localhost.localdomain>
CC: David Sterba <dsterba@suse.com>, <linux-btrfs@vger.kernel.org>
From: Josef Bacik <jbacik@fb.com>
Message-ID: <c89ccfc1-ad37-c06f-f6f3-1cafee7fbf92@fb.com>
Date: Fri, 1 Jul 2016 16:25:52 -0400
MIME-Version: 1.0
In-Reply-To: <2057588.odf3SpF3Kc@localhost.localdomain>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 07/01/2016 12:11 PM, Chandan Rajendra wrote:
> Sorry, Forgot to add the mailing list to CC. Doing it now ...
>
>> While running btrfs/113, I see the following call trace,
>>
>> [  182.272009] BTRFS: assertion failed: !current->journal_info || flush != BTRFS_RESERVE_FLUSH_ALL, file: /home/chandan/repos/linux/fs/btrfs/extent-tree.c, line: 5131
>> [  182.274010] ------------[ cut here ]------------
>> [  182.274685] kernel BUG at /home/chandan/repos/linux/fs/btrfs/ctree.h:3347!
>> [  182.274982] invalid opcode: 0000 [#1] SMP DEBUG_PAGEALLOC
>> [  182.274982] Modules linked in:
>> [  182.274982] CPU: 2 PID: 2911 Comm: xfs_io Not tainted 4.6.0-g5027553-dirty #29
>> [  182.274982] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS Bochs 01/01/2011
>> [  182.274982] task: ffff8818a4c3a400 ti: ffff8818aec4c000 task.ti: ffff8818aec4c000
>> [  182.274982] RIP: 0010:[<ffffffff813e4bc5>]  [<ffffffff813e4bc5>] assfail+0x1a/0x1c
>> [  182.274982] RSP: 0018:ffff8818aec4f5d8  EFLAGS: 00010282
>> [  182.274982] RAX: 0000000000000097 RBX: 0000000000030000 RCX: ffffffff8203dc18
>> [  182.274982] RDX: 0000000000000001 RSI: 0000000000000286 RDI: ffffffff822c8ccc
>> [  182.274982] RBP: ffff8818aec4f5d8 R08: 00000000fffffffe R09: 0000000000000000
>> [  182.274982] R10: 0000000000000005 R11: 000000000000028d R12: ffff8818b44ff000
>> [  182.274982] R13: 0000000000030000 R14: ffff8818a54a01f0 R15: ffff8818a4f36150
>> [  182.274982] FS:  00007f54fbc6b700(0000) GS:ffff881933500000(0000) knlGS:0000000000000000
>> [  182.274982] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
>> [  182.274982] CR2: 000000000061eba0 CR3: 00000018aec54000 CR4: 00000000000006e0
>> [  182.274982] Stack:
>> [  182.274982]  ffff8818aec4fa70 ffffffff8134a891 0000000200000000 0000000000030000
>> [  182.274982]  ffff8818b2502600 ffff8818b44ff000 0000000000000000 0000000000000000
>> [  182.274982]  0000000000000000 0000000000000000 0000000000000000 0000000000000000
>> [  182.274982] Call Trace:
>> [  182.274982]  [<ffffffff8134a891>] __reserve_metadata_bytes+0xb1/0x1fe0
>> [  182.274982]  [<ffffffff8104ada3>] ? lookup_address+0x23/0x30
>> [  182.274982]  [<ffffffff8104ae8d>] ? _lookup_address_cpa.isra.9+0x2d/0x30
>> [  182.274982]  [<ffffffff8104af7b>] ? __change_page_attr_set_clr+0xeb/0xc80
>> [  182.274982]  [<ffffffff8104ada3>] ? lookup_address+0x23/0x30
>> [  182.274982]  [<ffffffff8133d46a>] ? get_alloc_profile+0x8a/0x1a0
>> [  182.274982]  [<ffffffff8134350b>] ? btrfs_get_alloc_profile+0x2b/0x30
>> [  182.274982]  [<ffffffff813435ae>] ? can_overcommit+0x9e/0x100
>> [  182.274982]  [<ffffffff8134b468>] ? __reserve_metadata_bytes+0xc88/0x1fe0
>> [  182.274982]  [<ffffffff81129b5d>] ? __alloc_pages_nodemask+0x10d/0xc80
>> [  182.274982]  [<ffffffff8104ae8d>] ? _lookup_address_cpa.isra.9+0x2d/0x30
>> [  182.274982]  [<ffffffff8104af7b>] ? __change_page_attr_set_clr+0xeb/0xc80
>> [  182.274982]  [<ffffffff8104ada3>] ? lookup_address+0x23/0x30
>> [  182.274982]  [<ffffffff811720f6>] ? __slab_free+0x96/0x2b0
>> [  182.274982]  [<ffffffff81125f09>] ? __probe_kernel_read+0x39/0x90
>> [  182.274982]  [<ffffffff8137e789>] ? insert_state+0xc9/0x150
>> [  182.274982]  [<ffffffff813af02e>] ? add_delayed_ref_tail_merge+0x2e/0x350
>> [  182.274982]  [<ffffffff8134c7df>] reserve_metadata_bytes+0x1f/0xe0
>> [  182.274982]  [<ffffffff8134c8c6>] btrfs_block_rsv_add+0x26/0x50
>> [  182.274982]  [<ffffffff8137e495>] ? free_extent_state+0x15/0x20
>> [  182.274982]  [<ffffffff8134ccee>] btrfs_delalloc_reserve_metadata+0x13e/0x490
>> [  182.274982]  [<ffffffff8134d06a>] btrfs_delalloc_reserve_space+0x2a/0x50
>> [  182.274982]  [<ffffffff8136acea>] btrfs_truncate_block+0x8a/0x430
>> [  182.274982]  [<ffffffff81335a46>] ? generic_bin_search.constprop.35+0x86/0x1e0
>> [  182.274982]  [<ffffffff8136b1e7>] truncate_inline_extent+0x157/0x260
>> [  182.274982]  [<ffffffff813387dc>] ? btrfs_search_slot+0x86c/0x990
>> [  182.274982]  [<ffffffff81378b6c>] ? free_extent_map+0x4c/0xa0
>> [  182.274982]  [<ffffffff8136be97>] btrfs_truncate_inode_items+0xba7/0xdc0
>> [  182.274982]  [<ffffffff8136c218>] btrfs_truncate+0x168/0x280
>> [  182.274982]  [<ffffffff8136ca44>] btrfs_setattr+0x214/0x320
>> [  182.274982]  [<ffffffff8119694c>] notify_change+0x1dc/0x380
>> [  182.274982]  [<ffffffff81178ae1>] do_truncate+0x61/0xa0
>> [  182.274982]  [<ffffffff81178e39>] do_sys_ftruncate.constprop.17+0xf9/0x160
>> [  182.274982]  [<ffffffff81178ec9>] SyS_ftruncate+0x9/0x10
>> [  182.274982]  [<ffffffff819fb3db>] entry_SYSCALL_64_fastpath+0x13/0x8f
>> [  182.274982] Code: 48 c7 c7 48 14 df 81 48 89 e5 e8 ac ac d3 ff 0f 0b 55 89 d1 31 c0 48 89 f2 48 89 fe 48 c7 c7 48 14 df 81 48 89 e5 e8 90 ac d3 ff <0f> 0b 55 b9 11 00 00 00 48 89 e5 41 55 49 89 f5 41 54 49 89 d4
>> [  182.274982] RIP  [<ffffffff813e4bc5>] assfail+0x1a/0x1c
>> [  182.274982]  RSP <ffff8818aec4f5d8>
>> [  182.327207] ---[ end trace 44721e14eef0a6b2 ]---
>>
>>
>> Basically btrfs_truncate() starts a transaction, btrfs_truncate_inode_items()
>> encounters an inline extent and invokes
>> btrfs_truncate_block(). btrfs_truncate_block() tries to reserve delalloc (both
>> data & metadata) space. While doing so it passes BTRFS_RESERVE_FLUSH_ALL as an
>> argument. Since we already have a transaction running, we fail the following
>> ASSERT() statement in __reserve_metadata_bytes(),
>>
>>    ASSERT(!current->journal_info || flush != BTRFS_RESERVE_FLUSH_ALL);
>>
>

Where is this code?  I can't find it anywhere.  Thanks,

Josef
