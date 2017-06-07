Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:24435 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751475AbdFGUnx (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Wed, 7 Jun 2017 16:43:53 -0400
Date: Wed, 7 Jun 2017 13:41:42 -0700
From: Liu Bo <bo.li.liu@oracle.com>
To: Thomas Mischke <tmi@ais.de>
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
        Omar Sandoval <osandov@osandov.com>
Subject: Re: mount gets stuck -  BUG: soft lockup
Message-ID: <20170607204142.GE16793@lim.localdomain>
Reply-To: bo.li.liu@oracle.com
References: <650563aa7eda4f3c9c55cac60f476e45@ais.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <650563aa7eda4f3c9c55cac60f476e45@ais.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Jun 07, 2017 at 09:44:41AM +0000, Thomas Mischke wrote:
> Hello,
> 
> i tried to convert a JBOD BTRFS consisting of 5 disks (6TB each) to raid10 (converting from an earlier configuration).
> All disk were backed by bcache.
> 
> Because a rebalance takes very long I had to pause the balance for a required reboot.
> 
> After the reboot, the mount is getting stuck and the system crashes eventually.
> 
> OS: Fedora 25 kernel 4.11.3-200
> 
> DMESG:
> [120095.898769] CPU: 2 PID: 2110 Comm: mount Tainted: G      D      L  4.11.3-200.fc25.x86_64 #1
> [120095.898789] Hardware name: Gigabyte Technology Co., Ltd. To be filled by O.E.M./Z77X-UD5H, BIOS F15q 01/07/2013
> [120095.898812] task: ffff892f10684b00 task.stack: ffffa9a18e21c000
> [120095.898829] RIP: 0010:queued_spin_lock_slowpath+0x179/0x1a0
> [120095.898843] RSP: 0018:ffffa9a18e21f2c8 EFLAGS: 00000202 ORIG_RAX: ffffffffffffff10
> [120095.898861] RAX: 0000000000000101 RBX: ffff892e72d1ae00 RCX: 0000000000000001
> [120095.898878] RDX: 0000000000000101 RSI: 0000000000000001 RDI: ffff892f0dde4c00
> [120095.898896] RBP: ffffa9a18e21f2c8 R08: 0000000000000101 R09: 0000000180380033
> [120095.898913] R10: 0000168d1347c000 R11: 0000000000000000 R12: ffff892f0dde4c00
> [120095.898931] R13: ffff892e72d1ae00 R14: ffff892f29764b58 R15: ffff892f0dde4c00
> [120095.898948] FS:  00007f3e8f844340(0000) GS:ffff892f5f300000(0000) knlGS:0000000000000000
> [120095.898968] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [120095.898983] CR2: 00007f53ff435638 CR3: 00000007d1401000 CR4: 00000000001406e0
> [120095.899000] Call Trace:
> [120095.899009]  _raw_spin_lock+0x20/0x30
> [120095.899035]  find_free_extent+0x9ad/0x1030 [btrfs]

Can you dereference this find_free_extent+0x9ad with a debug-info?

(+Omar for free space cache tree.)

thanks,
-liubo

> [120095.899055]  btrfs_reserve_extent+0x92/0x1f0 [btrfs]
> [120095.899075]  btrfs_alloc_tree_block+0xfe/0x4b0 [btrfs]
> [120095.899095]  __btrfs_cow_block+0x13d/0x5d0 [btrfs]
> [120095.899114]  btrfs_cow_block+0xff/0x1a0 [btrfs]
> [120095.899132]  btrfs_search_slot+0x1f4/0x9d0 [btrfs]
> [120095.899153]  btrfs_search_prev_slot.constprop.10+0x18/0x40 [btrfs]
> [120095.899177]  modify_free_space_bitmap+0x84/0x3d0 [btrfs]
> [120095.899198]  __remove_from_free_space_tree+0xfd/0x2b0 [btrfs]
> [120095.899214]  ? kmem_cache_alloc+0xe3/0x1b0
> [120095.899231]  ? btrfs_alloc_path+0x1a/0x20 [btrfs]
> [120095.899251]  remove_from_free_space_tree+0x85/0x150 [btrfs]
> [120095.899272]  __btrfs_run_delayed_refs+0xff2/0x12b0 [btrfs]
> [120095.899293]  btrfs_run_delayed_refs+0x8f/0x2a0 [btrfs]
> [120095.899314]  commit_cowonly_roots+0xa5/0x310 [btrfs]
> [120095.899336]  ? btrfs_qgroup_account_extents+0x84/0x1a0 [btrfs]
> [120095.899358]  btrfs_commit_transaction+0x45a/0x930 [btrfs]
> [120095.899372]  ? kmem_cache_alloc_trace+0xea/0x1b0
> [120095.899392]  ? tree_insert+0x4d/0x60 [btrfs]
> [120095.899412]  btrfs_recover_relocation+0x2af/0x450 [btrfs]
> [120095.899434]  open_ctree+0x1f81/0x2410 [btrfs]
> [120095.899452]  btrfs_mount+0xd94/0xec0 [btrfs]
> [120095.899464]  ? find_next_bit+0xb/0x10
> [120095.899475]  ? find_next_bit+0xb/0x10
> [120095.899486]  mount_fs+0x38/0x150
> [120095.899496]  ? __alloc_percpu+0x15/0x20
> [120095.899508]  vfs_kern_mount+0x67/0x130
> [120095.899524]  btrfs_mount+0x1b8/0xec0 [btrfs]
> [120095.899536]  ? find_next_bit+0xb/0x10
> [120095.899547]  mount_fs+0x38/0x150
> [120095.899556]  ? __alloc_percpu+0x15/0x20
> [120095.899568]  vfs_kern_mount+0x67/0x130
> [120095.900442]  do_mount+0x1dd/0xc50
> [120095.901312]  ? _copy_from_user+0x4e/0x80
> [120095.902181]  ? kmem_cache_alloc_trace+0xea/0x1b0
> [120095.903048]  ? copy_mount_options+0x2c/0x220
> [120095.903903]  SyS_mount+0x83/0xd0
> [120095.904744]  entry_SYSCALL_64_fastpath+0x1a/0xa9
> [120095.905574] RIP: 0033:0x7f3e8e8b16fa
> [120095.906381] RSP: 002b:00007ffe76a00768 EFLAGS: 00000246 ORIG_RAX: 00000000000000a5
> [120095.907185] RAX: ffffffffffffffda RBX: 00007f3e8f41f907 RCX: 00007f3e8e8b16fa
> [120095.907972] RDX: 000055c13c9e0270 RSI: 000055c13c9e2f40 RDI: 000055c13c9e0210
> [120095.908743] RBP: 000055c13c9e00f0 R08: 000055c13c9e0230 R09: 0000000000000014
> [120095.909496] R10: 00000000c0ed0000 R11: 0000000000000246 R12: 00007f3e8f62e184
> [120095.910231] R13: 00007ffe76a00a78 R14: 0000000000000000 R15: 00000000ffffffff
> [120095.910949] Code: 41 39 c0 74 e6 4d 85 c9 c6 07 01 74 30 41 c7 41 08 01 00 00 00 e9 52 ff ff ff 83 fa 01 0f 84 b0 fe ff ff 8b 07 84 c0 74 08 f3 90 <8b> 07 84 c0 75 f8 b8 01 00 00 00 66 89 07 5d c3 f3 90 4c 8b 09
>  
> I tried older kernels, and an alternate linux installation (arch stable(4.11-something) and 4.12-rc4 from AUR)
> I also removed the caching devices from the single bcache disks.
> 
> Options tested: skip_balance
> 
> Nothing helped so far.
> 
> Any hints,
> 
> Thanks in advance,
> Thomas
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
