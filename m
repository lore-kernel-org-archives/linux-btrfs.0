Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cloud1-vm154.de-nserver.de ([178.250.10.56]:31624 "EHLO
        cloud1-vm154.de-nserver.de" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1756598AbcKCQ2Q (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 3 Nov 2016 12:28:16 -0400
To: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
From: Stefan Priebe - Profihost AG <s.priebe@profihost.ag>
Subject: recover btrfs with kernel 4.9-rc3 but btrfs progs fails
Message-ID: <28e451c5-8654-6b21-2cdf-81f530f47d57@profihost.ag>
Date: Thu, 3 Nov 2016 17:28:10 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

currently i've an fs which triggers this one on mount while originally
having 50% disk free - but btrfs progs fails too.

# btrfs check --repair -p /dev/vdb1
enabling repair mode
couldn't open RDWR because of unsupported option features (3).
ERROR: cannot open file system


[  164.378512] BTRFS info (device vdb1): using free space tree
[  164.378513] BTRFS info (device vdb1): has skinny extents
[  205.671655] ------------[ cut here ]------------
[  205.671686] WARNING: CPU: 10 PID: 4629 at fs/btrfs/extent-tree.c:2961
btrfs_run_delayed_refs+0x28d/0x2c0 [btrfs]
[  205.671689] BTRFS: error (device vdb1) in
btrfs_run_delayed_refs:2961: errno=-28 No space left
[  205.671695] BTRFS: error (device vdb1) in
btrfs_create_pending_block_groups:10349: errno=-28 No space left
[  205.671764] BTRFS: error (device vdb1) in
btrfs_create_pending_block_groups:10353: errno=-28 No space left
[  205.671770] BTRFS: error (device vdb1) in
add_block_group_free_space:1339: errno=-28 No space left
[  205.671928] BTRFS: Transaction aborted (error -28)
[  205.671929] Modules linked in: netconsole ipt_REJECT nf_reject_ipv4
xt_multiport iptable_filter ip_tables x_tables i2c_piix4 i2c_core button
crc32_pclmul ghash_clmulni_intel loop btrfs xor raid6_pq usbhid
ata_generic virtio_blk virtio_net uhci_hcd ehci_hcd usbcore virtio_pci
usb_common ata_piix floppy
[  205.671943] CPU: 10 PID: 4629 Comm: mount Tainted: G        W
4.9.0-rc3 #1
[  205.671944] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996),
BIOS 1.7.5-20140722_172050-sagunt 04/01/2014
[  205.671946]  ffffb2ed110f78f0 ffffffffa23f2c93 ffffb2ed110f7940
0000000000000000
[  205.671948]  ffffb2ed110f7930 ffffffffa20865f1 00000b9129130170
ffff8b4e7f1bc000
[  205.671949]  ffff8b4e29130170 ffff8b4e27e5f000 0000000000000000
00000000003105b4
[  205.671951] Call Trace:
[  205.671956]  [<ffffffffa23f2c93>] dump_stack+0x63/0x90
[  205.671960]  [<ffffffffa20865f1>] __warn+0xd1/0xf0
[  205.671962]  [<ffffffffa208665f>] warn_slowpath_fmt+0x4f/0x60
[  205.671972]  [<ffffffffc0238bfd>] btrfs_run_delayed_refs+0x28d/0x2c0
[btrfs]
[  205.671982]  [<ffffffffc024f9b9>] btrfs_commit_transaction+0x29/0x70
[btrfs]
[  205.671993]  [<ffffffffc02962b3>] btrfs_recover_log_trees+0x3b3/0x440
[btrfs]
[  205.672004]  [<ffffffffc0292ed0>] ? replay_one_extent+0x730/0x730 [btrfs]
[  205.672013]  [<ffffffffc024c85d>] open_ctree+0x264d/0x2760 [btrfs]
[  205.672020]  [<ffffffffc0220547>] btrfs_mount+0xcc7/0xe00 [btrfs]
[  205.672023]  [<ffffffffa2184810>] ? pcpu_next_unpop+0x40/0x50
[  205.672025]  [<ffffffffa2408fe5>] ? find_next_bit+0x15/0x20
[  205.672026]  [<ffffffffa218577d>] ? pcpu_alloc+0x32d/0x620
[  205.672028]  [<ffffffffa21e91d5>] mount_fs+0x15/0x90
[  205.672030]  [<ffffffffa2204f07>] vfs_kern_mount+0x67/0x110
[  205.672037]  [<ffffffffc021fb2c>] btrfs_mount+0x2ac/0xe00 [btrfs]
[  205.672039]  [<ffffffffa2184810>] ? pcpu_next_unpop+0x40/0x50
[  205.672040]  [<ffffffffa2408fe5>] ? find_next_bit+0x15/0x20
[  205.672041]  [<ffffffffa21e91d5>] mount_fs+0x15/0x90
[  205.672042]  [<ffffffffa2204f07>] vfs_kern_mount+0x67/0x110
[  205.672044]  [<ffffffffa2207642>] do_mount+0x192/0xc30
[  205.672045]  [<ffffffffa21800f2>] ? memdup_user+0x42/0x60
[  205.672046]  [<ffffffffa22083e4>] SyS_mount+0x94/0xd0
[  205.672048]  [<ffffffffa2002af9>] do_syscall_64+0x69/0x200
[  205.672049]  [<ffffffffa26fec6b>] entry_SYSCALL64_slow_path+0x25/0x25
[  205.672050] ---[ end trace be50fce8648d2575 ]---
[  205.672052] BTRFS: error (device vdb1) in
btrfs_run_delayed_refs:2961: errno=-28 No space left
[  205.672109] BTRFS: error (device vdb1) in btrfs_replay_log:2491:
errno=-28 No space left (Failed to recover log tree)
[  206.061658] BTRFS error (device vdb1): pending csums is 643072
[  206.061801] BTRFS error (device vdb1): cleaner transaction attach
returned -30
[  206.577900] BTRFS error (device vdb1): open_ctree failed

Stefan
