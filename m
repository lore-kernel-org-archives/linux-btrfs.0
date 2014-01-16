Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:53574 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751401AbaAPCnk (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 15 Jan 2014 21:43:40 -0500
Message-ID: <52D74714.8060507@cn.fujitsu.com>
Date: Thu, 16 Jan 2014 10:42:28 +0800
From: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
MIME-Version: 1.0
To: Tomasz Chmielewski <tch@virtall.com>
CC: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: kernel BUG at fs/btrfs/relocation.c:4026!
References: <20140115233738.10071ee8@virtall.com>
In-Reply-To: <20140115233738.10071ee8@virtall.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello Tomasz,

Looking at lines 4026, it is a BUG_ON() triggered because we fail to
commit transaction,from dmesg, it is because of ENOSPC issue.

However, we should not BUG_ON here, it has been deleted from
flighting patches and haven't been merge into upstream yet.^_^

Thanks,
Wang
On 01/16/2014 06:37 AM, Tomasz Chmielewski wrote:
> I was doing balance and hit these:
>
> [34363.498746] ------------[ cut here ]------------
> [34363.498825] WARNING: CPU: 3 PID: 2237 at fs/btrfs/super.c:254 __btrfs_abort_transaction+0x4d/0xff [btrfs]()
> [34363.498937] btrfs: Transaction aborted (error -28)
> [34363.498938] Modules linked in: xt_tcpudp iptable_filter ip_tables x_tables tun cpufreq_powersave cpufreq_ondemand cpufreq_conservative cpufreq_stats ipv6 btrfs zlib_deflate ext3 jbd loop pcspkr ehci_pci ehci_hcd lpc_ich i2c_i801 mfd_core acpi_cpufreq i2c_core video button ext4 crc16 jbd2 mbcache aacraid 3w_9xxx 3w_xxxx raid10 raid456 async_raid6_recov async_memcpy async_pq async_xor async_tx xor raid6_pq raid1 raid0 sata_nv sata_sil sata_via sg sd_mod ahci libahci libata scsi_mod r8169 mii
> [34363.499369] CPU: 3 PID: 2237 Comm: btrfs-transacti Not tainted 3.13.0-rc6 #1
> [34363.499433] Hardware name: System manufacturer System Product Name/P8H67-M PRO, BIOS 1106 10/17/2011
> [34363.499541]  0000000000000009 ffff88080d39fa48 ffffffff8138987d 0000000000000006
> [34363.499648]  ffff88080d39fa98 ffff88080d39fa88 ffffffff810370a9 0000000000001000
> [34363.499751]  ffffffffa02e4524 00000000ffffffe4 ffff8808110e9800 ffff880808f06dc0
> [34363.499851] Call Trace:
> [34363.499901]  [<ffffffff8138987d>] dump_stack+0x46/0x58
> [34363.499955]  [<ffffffff810370a9>] warn_slowpath_common+0x77/0x91
> [34363.500010]  [<ffffffffa02e4524>] ? __btrfs_abort_transaction+0x4d/0xff [btrfs]
> [34363.500110]  [<ffffffff81037157>] warn_slowpath_fmt+0x41/0x43
> [34363.500164]  [<ffffffffa02e4524>] __btrfs_abort_transaction+0x4d/0xff [btrfs]
> [34363.500222]  [<ffffffffa02f2ea4>] __btrfs_free_extent+0x79e/0x7e3 [btrfs]
> [34363.500277]  [<ffffffff8138843e>] ? __slab_free+0x294/0x2b8
> [34363.500336]  [<ffffffffa033f10a>] ? btrfs_merge_delayed_refs+0x2c9/0x305 [btrfs]
> [34363.500438]  [<ffffffffa02f7658>] run_clustered_refs+0x9b5/0xba7 [btrfs]
> [34363.500496]  [<ffffffffa02f96b3>] btrfs_run_delayed_refs+0x219/0x46f [btrfs]
> [34363.500551]  [<ffffffff8103f58f>] ? lock_timer_base.isra.25+0x26/0x4a
> [34363.500610]  [<ffffffffa0306b61>] btrfs_commit_transaction+0xe2/0x7df [btrfs]
> [34363.500669]  [<ffffffffa0305345>] transaction_kthread+0xef/0x1c2 [btrfs]
> [34363.500727]  [<ffffffffa0305256>] ? open_ctree+0x1ac7/0x1ac7 [btrfs]
> [34363.500781]  [<ffffffff8104ee9a>] kthread+0xcd/0xd5
> [34363.500833]  [<ffffffff8104edcd>] ? kthread_freezable_should_stop+0x43/0x43
> [34363.500888]  [<ffffffff8138e6bc>] ret_from_fork+0x7c/0xb0
> [34363.500940]  [<ffffffff8104edcd>] ? kthread_freezable_should_stop+0x43/0x43
> [34363.500994] ---[ end trace 99a0c80048824a4c ]---
> [34363.501046] BTRFS error (device sdb4) in __btrfs_free_extent:5783: errno=-28 No space left
> [34363.501144] BTRFS info (device sdb4): forced readonly
> [34363.501195] BTRFS debug (device sdb4): run_one_delayed_ref returned -28
> [34363.501196] BTRFS error (device sdb4) in btrfs_run_delayed_refs:2730: errno=-28 No space left
> [34453.456505] ------------[ cut here ]------------
> [34453.456560] kernel BUG at fs/btrfs/relocation.c:4026!
> [34453.456611] invalid opcode: 0000 [#1] SMP
> [34453.456663] Modules linked in: xt_tcpudp iptable_filter ip_tables x_tables tun cpufreq_powersave cpufreq_ondemand cpufreq_conservative cpufreq_stats ipv6 btrfs zlib_deflate ext3 jbd loop pcspkr ehci_pci ehci_hcd lpc_ich i2c_i801 mfd_core acpi_cpufreq i2c_core video button ext4 crc16 jbd2 mbcache aacraid 3w_9xxx 3w_xxxx raid10 raid456 async_raid6_recov async_memcpy async_pq async_xor async_tx xor raid6_pq raid1 raid0 sata_nv sata_sil sata_via sg sd_mod ahci libahci libata scsi_mod r8169 mii
> [34453.457065] CPU: 1 PID: 5833 Comm: btrfs Tainted: G        W    3.13.0-rc6 #1
> [34453.457120] Hardware name: System manufacturer System Product Name/P8H67-M PRO, BIOS 1106 10/17/2011
> [34453.457221] task: ffff8806bce22e20 ti: ffff8806a77a4000 task.ti: ffff8806a77a4000
> [34453.457319] RIP: 0010:[<ffffffffa03453e0>]  [<ffffffffa03453e0>] relocate_block_group+0x286/0x4c7 [btrfs]
> [34453.457432] RSP: 0018:ffff8806a77a5a68  EFLAGS: 00010286
> [34453.457484] RAX: 00000000ffffffe4 RBX: ffff8808101831b0 RCX: 0000000180190002
> [34453.457564] RDX: 0000000180190003 RSI: ffffea0020405080 RDI: ffff880811551300
> [34453.457619] RBP: ffff8806a77a5ad8 R08: 0000000000000001 R09: ffffea0020405080
> [34453.457673] R10: 0000000000001dc7 R11: ffffffffa030752f R12: 00000000fffffff5
> [34453.457727] R13: ffff880810142b40 R14: ffff88074c7a3000 R15: 0000000000000002
> [34453.457781] FS:  00007f8afc0f0840(0000) GS:ffff88083fa40000(0000) knlGS:0000000000000000
> [34453.457880] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [34453.457932] CR2: 00007e79b2ccc000 CR3: 000000069f630000 CR4: 00000000000407e0
> [34453.457986] Stack:
> [34453.458032]  ffff8806a77a5ad8 ffffffff00018d21 ffff8806a77a5a70 0000000000000000
> [34453.458132]  000000a70000020c 00ff8806a77a5a98 a80000052421e5e0 0000000000001000
> [34453.458232]  ffff88081ed3ba20 ffff88074c7a3000 ffff880812fdc5c8 ffff880812fdc000
> [34453.458331] Call Trace:
> [34453.458386]  [<ffffffffa034576f>] btrfs_relocate_block_group+0x14e/0x28d [btrfs]
> [34453.458490]  [<ffffffffa03248d2>] btrfs_relocate_chunk.isra.65+0x58/0x60e [btrfs]
> [34453.458592]  [<ffffffffa03321ff>] ? btrfs_set_lock_blocking_rw+0x89/0xb2 [btrfs]
> [34453.458693]  [<ffffffffa02e71b7>] ? btrfs_set_path_blocking+0x23/0x54 [btrfs]
> [34453.458751]  [<ffffffffa02eba1b>] ? btrfs_search_slot+0x72f/0x789 [btrfs]
> [34453.458810]  [<ffffffffa0320be1>] ? free_extent_buffer+0x6f/0x7c [btrfs]
> [34453.458869]  [<ffffffffa0327709>] btrfs_balance+0x9fe/0xbe0 [btrfs]
> [34453.458928]  [<ffffffffa032d4c9>] btrfs_ioctl_balance+0x220/0x29f [btrfs]
> [34453.458987]  [<ffffffffa0330a66>] btrfs_ioctl+0xfce/0x2128 [btrfs]
> [34453.459042]  [<ffffffff810c9b0c>] ? handle_mm_fault+0x41a/0x965
> [34453.459096]  [<ffffffff810ccc91>] ? __vm_enough_memory+0x26/0x13d
> [34453.459149]  [<ffffffff8110224a>] do_vfs_ioctl+0x3f7/0x441
> [34453.459201]  [<ffffffff811022e6>] SyS_ioctl+0x52/0x80
> [34453.459254]  [<ffffffff8138e762>] system_call_fastpath+0x16/0x1b
> [34453.459308] Code: 89 86 a8 05 00 00 41 8a 86 b9 05 00 00 49 8b 76 08 a8 08 74 18 83 e0 f7 4c 89 ef 41 88 86 b9 05 00 00 e8 a3 16 fc ff 85 c0 74 13 <0f> 0b 4c 89 ef e8 7b 21 fc ff 49 8b 7e 08 e8 fb d7 fb ff 41 80
> [34453.459496] RIP  [<ffffffffa03453e0>] relocate_block_group+0x286/0x4c7 [btrfs]
> [34453.459598]  RSP <ffff8806a77a5a68>
> [34453.459967] ---[ end trace 99a0c80048824a4d ]---
>
>

