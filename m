Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:34973 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1761833AbcINNOO (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 14 Sep 2016 09:14:14 -0400
Subject: Re: [PATCH] Btrfs: Free fs_info->eb_info only when it holds a valid
 pointer
To: Chandan Rajendra <chandan@linux.vnet.ibm.com>,
        <linux-btrfs@vger.kernel.org>
References: <1473848917-25442-1-git-send-email-chandan@linux.vnet.ibm.com>
From: Josef Bacik <jbacik@fb.com>
Message-ID: <102abcdf-d25a-0bed-daea-fceea54d66ad@fb.com>
Date: Wed, 14 Sep 2016 09:13:01 -0400
MIME-Version: 1.0
In-Reply-To: <1473848917-25442-1-git-send-email-chandan@linux.vnet.ibm.com>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 09/14/2016 06:28 AM, Chandan Rajendra wrote:
> The following command line sequence causes a NULL pointer dereference,
>
> mount /dev/loop0 /mnt/dir1
> mount /dev/loop0 /mnt/dir2
>
> [  159.964194] BUG: unable to handle kernel NULL pointer dereference at 0000000000000070
> [  159.965147] IP: [<ffffffff8114e438>] list_lru_destroy+0x8/0x20
> [  159.965147] PGD 0
> [  159.965147] Oops: 0000 [#1] SMP DEBUG_PAGEALLOC
> [  159.965147] Modules linked in:
> [  159.965147] CPU: 2 PID: 3043 Comm: mount Not tainted 4.7.0-ge96efee1-dirty #5
> [  159.965147] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS Bochs 01/01/2011
> [  159.965147] task: ffff8818b511a400 task.stack: ffff8818a5108000
> [  159.965147] RIP: 0010:[<ffffffff8114e438>]  [<ffffffff8114e438>] list_lru_destroy+0x8/0x20
> [  159.965147] RSP: 0018:ffff8818a510bbd8  EFLAGS: 00010246
> [  159.965147] RAX: 0000000000000000 RBX: 0000000000000070 RCX: 00000000c0000100
> [  159.965147] RDX: ffffffff82041b78 RSI: ffff8818b511a400 RDI: 0000000000000070
> [  159.965147] RBP: ffff8818a510bbe0 R08: ffff8818a5108000 R09: ffff8818a50a6000
> [  159.965147] R10: 0000000000000000 R11: 000000253e9b4bd4 R12: ffffffff82098f80
> [  159.965147] R13: ffff8818b266e000 R14: ffff8818a4760000 R15: ffff8818b5449b50
> [  159.965147] FS:  00007f29f0ab0840(0000) GS:ffff881933480000(0000) knlGS:0000000000000000
> [  159.965147] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [  159.965147] CR2: 0000000000000070 CR3: 00000018a5239000 CR4: 00000000000006e0
> [  159.965147] Stack:
> [  159.965147]  0000000000000000 ffff8818a510bcb8 ffffffff813464e5 0000000fa510bc00
> [  159.965147]  000000200100243e ffff8818a4004d18 0000000800000046 ffff8818a510bc20
> [  159.965147]  ffffffff8148243e ffff8818a510bc50 ffff8818b5449b30 0000000000000008
> [  159.965147] Call Trace:
> [  159.965147]  [<ffffffff813464e5>] btrfs_mount+0xad5/0xee0
> [  159.965147]  [<ffffffff8148243e>] ? find_next_zero_bit+0x1e/0x20
> [  159.965147]  [<ffffffff81184b64>] mount_fs+0x34/0x160
> [  159.965147]  [<ffffffff81146fa0>] ? __alloc_percpu+0x10/0x20
> [  159.965147]  [<ffffffff8119f032>] vfs_kern_mount+0x62/0x100
> [  159.965147]  [<ffffffff81345b96>] btrfs_mount+0x186/0xee0
> [  159.965147]  [<ffffffff8148243e>] ? find_next_zero_bit+0x1e/0x20
> [  159.965147]  [<ffffffff81184b64>] mount_fs+0x34/0x160
> [  159.965147]  [<ffffffff81146fa0>] ? __alloc_percpu+0x10/0x20
> [  159.965147]  [<ffffffff8119f032>] vfs_kern_mount+0x62/0x100
> [  159.965147]  [<ffffffff811a19b6>] do_mount+0x1b6/0xc40
> [  159.965147]  [<ffffffff811422dd>] ? memdup_user+0x3d/0x70
> [  159.965147]  [<ffffffff811a271e>] SyS_mount+0x7e/0xd0
> [  159.965147]  [<ffffffff81a3ef1b>] entry_SYSCALL_64_fastpath+0x13/0x8f
> [  159.965147] Code: 89 08 48 89 e5 48 8b 02 48 89 70 08 48 89 06 48 89 56 08 48 89 32 5d 48 83 6f 10 01 c3 66 0f 1f 44 00 00 55 48 89 e5 53 48 89 fb <48> 8b 3f 48 85 ff 74 0c e8 9b 99 02 00 48 c7 03 00 00 00 00 5b
> [  159.965147] RIP  [<ffffffff8114e438>] list_lru_destroy+0x8/0x20
> [  159.965147]  RSP <ffff8818a510bbd8>
> [  159.965147] CR2: 0000000000000070
> [  159.999634] ---[ end trace 04bad43e08a10198 ]---
>
> When servicing the second mount command, btrfs_mount() invokes
> free_fs_info() because super_block->s_root is already set. At this
> instance we would not have initialized btrfs_fs_info->eb_info to a valid
> memory address. Hence the statement,
> list_lru_destroy(&fs_info->eb_info->lru_list); causes a NULL pointer
> dereference.
>
> Signed-off-by: Chandan Rajendra <chandan@linux.vnet.ibm.com>

I fixed this already and sent it out last week, look for V2 of the kill the 
btree_inode patch.  Thanks,

Josef

