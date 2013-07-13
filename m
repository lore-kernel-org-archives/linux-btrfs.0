Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-bk0-f54.google.com ([209.85.214.54]:34854 "EHLO
	mail-bk0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751752Ab3GMP2Z convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 13 Jul 2013 11:28:25 -0400
Received: by mail-bk0-f54.google.com with SMTP id it16so4138496bkc.13
        for <linux-btrfs@vger.kernel.org>; Sat, 13 Jul 2013 08:28:23 -0700 (PDT)
MIME-Version: 1.0
Reply-To: fdmanana@gmail.com
In-Reply-To: <20130713120829.2e67645b@wpkg.org>
References: <20130713120829.2e67645b@wpkg.org>
Date: Sat, 13 Jul 2013 16:28:23 +0100
Message-ID: <CAL3q7H5PyRsYZCHwRi8us31g79YG99g+-QLrqWsXqZ10E0k2kQ@mail.gmail.com>
Subject: Re: btrfs filesystem balance /mnt/btrfs -> segmentation fault (kernel
 BUG at fs/btrfs/relocation.c:3296!)
From: Filipe David Manana <fdmanana@gmail.com>
To: Tomasz Chmielewski <mangoo@wpkg.org>
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, Jul 13, 2013 at 5:08 AM, Tomasz Chmielewski <mangoo@wpkg.org> wrote:
> I've enabled "extended inode refs" and "skinny metadata extent refs" with btrfstune.
>
> Then, I've tried running "btrfs filesystem balance" - unfortunately it segfaulted.
> (not sure if I should run balance operation after using btrfstune with -r and -x)?
>
> This is with 3.10 kernel with "Btrfs: make backref walking code handle skinny metadata" patch
> https://patchwork.kernel.org/patch/2800271/

Perhaps this patch fixes your problem:
https://patchwork.kernel.org/patch/2718061/

(Which doesn't seem to be included in 3.10,
https://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/tree/fs/btrfs/relocation.c?id=refs/tags/v3.10#n3262)


>
>
> [18483.575594] ------------[ cut here ]------------
> [18483.575644] kernel BUG at fs/btrfs/relocation.c:3296!
> [18483.575692] invalid opcode: 0000 [#1] SMP
> [18483.575739] Modules linked in: veth ipt_MASQUERADE iptable_nat nf_conntrack_ipv4 nf_defrag_ipv4 nf_nat_ipv4 nf_nat nf_conntrack ip_tables x_tables cpufreq_ondemand cpufreq_conservative cpufreq_powersave cpufreq_stats bridge stp llc ipv6 btrfs xor raid6_pq zlib_deflate loop acpi_cpufreq mperf freq_table intel_powerclamp kvm_intel kvm crc32_pclmul i2c_i801 i2c_core video button lpc_ich mfd_core microcode pcspkr ehci_pci ehci_hcd ext4 crc16 jbd2 mbcache raid1 sg sd_mod ahci libahci libata scsi_mod r8169 mii
> [18483.576119] CPU: 2 PID: 13753 Comm: btrfs Not tainted 3.10.0 #2
> [18483.576167] Hardware name: System manufacturer System Product Name/P8H77-M PRO, BIOS 1101 02/04/2013
> [18483.576259] task: ffff8807f3edc4a0 ti: ffff8802ceb26000 task.ti: ffff8802ceb26000
> [18483.576348] RIP: 0010:[<ffffffffa0734e98>]  [<ffffffffa0734e98>] __add_tree_block+0x11b/0x12c [btrfs]
> [18483.576453] RSP: 0018:ffff8802ceb27a28  EFLAGS: 00010287
> [18483.576501] RAX: 0000000000000001 RBX: ffff8807efdadcf0 RCX: 0000018b46636000
> [18483.576550] RDX: 00000000000000a9 RSI: ffff88047afa24f4 RDI: ffff8802ceb27a68
> [18483.576600] RBP: ffff8802ceb27a98 R08: ffff8802ceb27a68 R09: ffff880527110348
> [18483.576650] R10: 0000000000001000 R11: 0000160000000000 R12: 0000018b46647000
> [18483.576699] R13: ffff880345192800 R14: ffff8802ceb27b40 R15: 0000000000001000
> [18483.576752] FS:  00007fb48c80d740(0000) GS:ffff88081fa80000(0000) knlGS:0000000000000000
> [18483.576842] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [18483.576892] CR2: 0000000045e025a8 CR3: 0000000624b31000 CR4: 00000000001407e0
> [18483.576941] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> [18483.576991] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
> [18483.577040] Stack:
> [18483.577083]  ffff8807f3e00c00 ffff880500000001 0000000000000000 6000ffffa070af5f
> [18483.577184]  00a90000018b4663 0000000000000000 a90000018b466360 0000000000000000
> [18483.577278]  ffff8802ceb27a98 ffff8807eddd3120 ffff880345192800 0000000000000904
> [18483.577368] Call Trace:
> [18483.577422]  [<ffffffffa0734f6a>] add_data_references+0xc1/0x245 [btrfs]
> [18483.577480]  [<ffffffffa0735a87>] relocate_block_group+0x212/0x503 [btrfs]
> [18483.577537]  [<ffffffffa0735ec7>] btrfs_relocate_block_group+0x14f/0x283 [btrfs]
> [18483.577634]  [<ffffffffa0715d8a>] btrfs_relocate_chunk.isra.65+0x50/0x3bc [btrfs]
> [18483.577731]  [<ffffffffa0711d09>] ? free_extent_buffer+0x77/0x7c [btrfs]
> [18483.577788]  [<ffffffffa07190cc>] btrfs_balance+0x9c2/0xb9a [btrfs]
> [18483.577838]  [<ffffffff810b9117>] ? __do_fault+0x3d0/0x40a
> [18483.577888]  [<ffffffff810e5e02>] ? __sb_start_write+0xbd/0xf1
> [18483.577947]  [<ffffffffa071e778>] btrfs_ioctl_balance+0x22e/0x2ac [btrfs]
> [18483.578004]  [<ffffffffa0721bac>] btrfs_ioctl+0xfab/0x1967 [btrfs]
> [18483.578055]  [<ffffffff81157d72>] ? avc_has_perm_flags+0x32/0xf7
> [18483.578104]  [<ffffffff81026887>] ? __do_page_fault+0x34f/0x3f3
> [18483.578153]  [<ffffffff810f1f51>] vfs_ioctl+0x21/0x34
> [18483.578200]  [<ffffffff810f27a3>] do_vfs_ioctl+0x3b1/0x3f4
> [18483.578248]  [<ffffffff810f2838>] SyS_ioctl+0x52/0x82
> [18483.578298]  [<ffffffff81375812>] system_call_fastpath+0x16/0x1b
> [18483.578345] Code: 4c 89 f7 e8 77 b1 ff ff 48 89 c2 31 c0 48 85 d2 75 1b e9 42 ff ff ff 48 8d 75 ae 4c 89 f1 48 89 da 4c 89 ef e8 f2 d6 ff ff eb b7 <0f> 0b 48 83 c4 48 5b 41 5c 41 5d 41 5e 41 5f 5d c3 55 48 89 e5
> [18483.578527] RIP  [<ffffffffa0734e98>] __add_tree_block+0x11b/0x12c [btrfs]
> [18483.578588]  RSP <ffff8802ceb27a28>
> [18483.578921] ---[ end trace 5fbd1b64c8886e51 ]---
>
>
> --
> Tomasz Chmielewski
> http://wpkg.org
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



--
Filipe David Manana,

"Reasonable men adapt themselves to the world.
 Unreasonable men adapt the world to themselves.
 That's why all progress depends on unreasonable men."
