Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from slmp-550-94.slc.westdc.net ([50.115.112.57]:47747 "EHLO
	slmp-550-94.slc.westdc.net" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754209AbaEOUkW convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 15 May 2014 16:40:22 -0400
Received: from c-75-70-18-61.hsd1.co.comcast.net ([75.70.18.61]:54203 helo=[192.168.1.145])
	by slmp-550-94.slc.westdc.net with esmtpsa (TLSv1:AES128-SHA:128)
	(Exim 4.82)
	(envelope-from <chris@colorremedies.com>)
	id 1Wl2Ry-002OJa-35
	for linux-btrfs@vger.kernel.org; Thu, 15 May 2014 14:40:22 -0600
From: Chris Murphy <chris@colorremedies.com>
Content-Type: text/plain; charset=us-ascii
Subject: kernel BUG at fs/btrfs/locking.c when mounting with previously missing device
Message-Id: <237483C1-00DF-4576-8C44-56EBCF077B9B@colorremedies.com>
Date: Thu, 15 May 2014 14:40:20 -0600
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 6.6 \(1510\))
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Summary: Two device btrfs raid1, as data device not boot/rootfs, mounted and filled with some data. Power off and remove one device. Reboot and mount the single device available with -o degraded. Create new subvolume and fill with some data. Poweroff and reattach previously removed device. Reboot and attempt to mount volume normally and I get a segfault.

Setup:
VBox VM, Fedora Rawhide
2x 2TB VDIs
kernel 3.15.0-0.rc5.git0.1.fc21.x86_64
btrfs-progs 3.14-1
mkfs.btrfs -d raid1 -m raid1 /dev/sd[bc]

Reproduce steps:
1. Mount /dev/sdb /mnt
2. btrfs sub create /mnt/subv1
3. cp -a /var /mnt/prefill/
4. poweroff, remove /dev/sdc
5. Boot, mount /dev/sdb /mnt -o degraded
6. btrfs sub create /mnt/subv2
7. cp -a /boot /mnt/sub2/
8. poweroff, reattach /dev/sdc
9. Boot, mount /dev/sdb /mnt
Segmentation fault

Regression: I know I've done this recently with existing subvolumes (without making new ones while mounting degraded) and it worked OK so I'm not sure how reproducible it is.


[   12.210745] SELinux: initialized (dev tmpfs, type tmpfs), uses transition SIDs
[   84.016634] BTRFS info (device sdb): disk space caching is enabled
[   84.023149] parent transid verify failed on 30146560 wanted 12 found 7
[   84.023260] ------------[ cut here ]------------
[   84.023329] kernel BUG at fs/btrfs/locking.c:269!
[   84.023397] invalid opcode: 0000 [#1] SMP 
[   84.023466] Modules linked in: xt_CHECKSUM ipt_MASQUERADE tun ip6t_rpfilter ip6t_REJECT xt_conntrack ebtable_nat ebtable_broute bridge stp llc ebtable_filter ebtables ip6table_nat nf_conntrack_ipv6 nf_defrag_ipv6 nf_nat_ipv6 ip6table_mangle ip6table_security ip6table_raw ip6table_filter ip6_tables iptable_nat nf_conntrack_ipv4 nf_defrag_ipv4 nf_nat_ipv4 nf_nat nf_conntrack iptable_mangle iptable_security iptable_raw vfat fat sunrpc ppdev microcode serio_raw i2c_piix4 parport_pc virtio_net parport i2c_core btrfs xor raid6_pq virtio_pci virtio ata_generic virtio_ring pata_acpi
[   84.023926] CPU: 2 PID: 1014 Comm: mount Not tainted 3.15.0-0.rc5.git0.1.fc21.x86_64 #1
[   84.024002] Hardware name: innotek GmbH VirtualBox/VirtualBox, BIOS VirtualBox 12/01/2006
[   84.024004] task: ffff880090b693a0 ti: ffff88008baa8000 task.ti: ffff88008baa8000
[   84.024086] RIP: 0010:[<ffffffffa00fe6a9>]  [<ffffffffa00fe6a9>] btrfs_assert_tree_read_locked.part.0+0x9/0x10 [btrfs]
[   84.024112] RSP: 0018:ffff88008baa9bb8  EFLAGS: 00010246
[   84.024112] RAX: 0000000000000000 RBX: ffff88008b50bdc0 RCX: 0000000000009816
[   84.024112] RDX: 0000000000000000 RSI: 000000000001c7a0 RDI: ffff88008b50bdc0
[   84.024112] RBP: ffff88008baa9bb8 R08: 000000000001c7a0 R09: ffffffffa00e3083
[   84.024112] R10: ffff88009d91c7a0 R11: ffffea00022d3940 R12: ffff88008b4a4c10
[   84.024112] R13: 000000000000000c R14: 0000000000000001 R15: ffff880002403800
[   84.024112] FS:  00007fdd0794c840(0000) GS:ffff88009d900000(0000) knlGS:0000000000000000
[   84.024112] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   84.024112] CR2: 00007f9e9511ba60 CR3: 000000008b91c000 CR4: 00000000000006e0
[   84.024112] Stack:
[   84.024112]  ffff88008baa9bd0 ffffffffa00fec35 ffff88008b50bdc0 ffff88008baa9c10
[   84.024112]  ffffffffa00be1d9 0000000000000000 0000000037e18c5d 0000000000000000
[   84.024112]  0000000000000000 0000000000000000 ffff88008b50bdc0 ffff88008baa9c60
[   84.024112] Call Trace:
[   84.024112]  [<ffffffffa00fec35>] btrfs_tree_read_unlock_blocking+0x95/0xc0 [btrfs]
[   84.024112]  [<ffffffffa00be1d9>] verify_parent_transid+0x139/0x1e0 [btrfs]
[   84.024112]  [<ffffffffa00bee5a>] btree_read_extent_buffer_pages.constprop.46+0xca/0x110 [btrfs]
[   84.024112]  [<ffffffffa00c00b8>] read_tree_block+0x38/0x60 [btrfs]
[   84.024112]  [<ffffffffa00c44d6>] open_ctree+0x1386/0x1e60 [btrfs]
[   84.024112]  [<ffffffff81342062>] ? disk_name+0xa2/0xb0
[   84.024112]  [<ffffffffa009b6fd>] btrfs_mount+0x76d/0x940 [btrfs]
[   84.024112]  [<ffffffff81199a24>] ? pcpu_alloc+0x854/0xa70
[   84.024112]  [<ffffffff8135c4d5>] ? ida_get_new_above+0x205/0x230
[   84.024112]  [<ffffffff811f30f8>] mount_fs+0x38/0x1c0
[   84.024112]  [<ffffffff81199c50>] ? __alloc_percpu+0x10/0x20
[   84.024112]  [<ffffffff8120f384>] vfs_kern_mount+0x64/0x110
[   84.024112]  [<ffffffff81211c57>] do_mount+0x247/0xac0
[   84.024112]  [<ffffffff811940d2>] ? memdup_user+0x42/0x70
[   84.024112]  [<ffffffff8121280a>] SyS_mount+0xba/0x140
[   84.024112]  [<ffffffff817119e9>] system_call_fastpath+0x16/0x1b
[   84.024112] Code: b9 ea ff ff ff e9 63 ff ff ff 48 8b 9c 24 98 00 00 00 b9 ea ff ff ff e9 51 ff ff ff 66 0f 1f 44 00 00 66 66 66 66 90 55 48 89 e5 <0f> 0b 0f 1f 44 00 00 66 66 66 66 90 55 48 89 e5 0f 0b 0f 1f 44 
[   84.024112] RIP  [<ffffffffa00fe6a9>] btrfs_assert_tree_read_locked.part.0+0x9/0x10 [btrfs]
[   84.024112]  RSP <ffff88008baa9bb8>
[   84.035940] ---[ end trace 3d0a75005f2c23d6 ]