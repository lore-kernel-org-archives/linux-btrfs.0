Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qk0-f180.google.com ([209.85.220.180]:35297 "EHLO
	mail-qk0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751343AbbF2PXg (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 29 Jun 2015 11:23:36 -0400
Received: by qkbp125 with SMTP id p125so96105536qkb.2
        for <linux-btrfs@vger.kernel.org>; Mon, 29 Jun 2015 08:23:36 -0700 (PDT)
MIME-Version: 1.0
From: Martin Tippmann <martin.tippmann@gmail.com>
Date: Mon, 29 Jun 2015 17:23:16 +0200
Message-ID: <CABL_Pd-vt977x_bnkOdC==Wc6iL9gzgfdamypa7k-qcV-ADqyQ@mail.gmail.com>
Subject: Linux 4.1.0: BTRFS: error (device sdb) in btrfs_run_delayed_refs:2821:
 errno=-17 Object already exists
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi, is this a know issue and is there a already a patch out there for
this? This is also happening with Linux 4.0.4. I can reproduce this
expect it's happening under load...

Mount options:
/dev/sdb /media/storage2 btrfs ro,noatime,compress=lzo,space_cache 0 0

# uname -r
4.1.0-040100-generic

# btrfs fi show /dev/sdb
Label: 'storage2'  uuid: 4b0fdfb4-8d9e-43e4-b51c-15446a792d9b
        Total devices 1 FS bytes used 676.37GiB
        devid    1 size 3.64TiB used 829.06GiB path /dev/sdb

# btrfs fi df /media/storage2/
Data, single: total=824.00GiB, used=674.95GiB
System, DUP: total=32.00MiB, used=112.00KiB
Metadata, DUP: total=2.50GiB, used=1.42GiB
GlobalReserve, single: total=496.00MiB, used=0.00B

btrfs-progs v4.0



[23514.127519] ------------[ cut here ]------------
[23514.127566] WARNING: CPU: 0 PID: 920 at
/home/kernel/COD/linux/fs/btrfs/super.c:260
__btrfs_abort_transaction+0x5f/0x140 [btrfs]()
[23514.127569] BTRFS: Transaction aborted (error -17)
[23514.127572] Modules linked in: x86_pkg_temp_thermal
intel_powerclamp coretemp kvm_intel kvm crct10dif_pclmul crc32_pclmul
ghash_clmulni_intel aesni_intel aes_x86_64 ipmi_ssif ipmi_devintf lrw
gf128mul glue_helper dcdbas ablk_helper cryptd joydev mei_me sb_edac
edac_core mac_hid 8250_fintek acpi_pad acpi_power_meter lpc_ich mei
shpchp ipmi_si ipmi_msghandler btrfs xor raid6_pq squashfs nfsv3
nfs_acl nfs lockd grace sunrpc fscache overlay hid_generic usbhid hid
ixgbe igb vxlan ahci ip6_udp_tunnel dca udp_tunnel libahci ptp
i2c_algo_bit megaraid_sas pps_core wmi mdio
[23514.127631] CPU: 0 PID: 920 Comm: btrfs-transacti Tainted: G
 C      4.1.0-040100-generic #201506220235
[23514.127634] Hardware name: Dell Inc. PowerEdge R720/0HJK12, BIOS
2.2.2 01/16/2014
[23514.127637]  0000000000000104 ffff88081a8dfbf8 ffffffff81800595
0000000000000007
[23514.127642]  ffff88081a8dfc48 ffff88081a8dfc38 ffffffff8107d0e7
ffff88081a8dfc38
[23514.127646]  ffff8807c2ebbe40 ffff88101b971000 00000000ffffffef
0000000000000b05
[23514.127651] Call Trace:
[23514.127661]  [<ffffffff81800595>] dump_stack+0x45/0x57
[23514.127668]  [<ffffffff8107d0e7>] warn_slowpath_common+0x97/0xe0
[23514.127673]  [<ffffffff8107d1e6>] warn_slowpath_fmt+0x46/0x50
[23514.127696]  [<ffffffffc0294a95>] ?
__btrfs_run_delayed_refs+0x585/0x620 [btrfs]
[23514.127712]  [<ffffffffc0278aaf>]
__btrfs_abort_transaction+0x5f/0x140 [btrfs]
[23514.127732]  [<ffffffffc0296c05>]
btrfs_run_delayed_refs.part.83+0x175/0x290 [btrfs]
[23514.127749]  [<ffffffffc027daaa>] ? btrfs_free_path+0x2a/0x40 [btrfs]
[23514.127767]  [<ffffffffc0296d37>] btrfs_run_delayed_refs+0x17/0x20 [btrfs]
[23514.127792]  [<ffffffffc0322f11>] commit_cowonly_roots+0x10d/0x2d8 [btrfs]
[23514.127811]  [<ffffffffc0296cc0>] ?
btrfs_run_delayed_refs.part.83+0x230/0x290 [btrfs]
[23514.127834]  [<ffffffffc02a7f4d>]
btrfs_commit_transaction+0x57d/0xb60 [btrfs]
[23514.127855]  [<ffffffffc02a5ab5>] transaction_kthread+0x1d5/0x250 [btrfs]
[23514.127875]  [<ffffffffc02a58e0>] ? open_ctree+0x1900/0x1900 [btrfs]
[23514.127882]  [<ffffffff8109ce59>] kthread+0xc9/0xe0
[23514.127887]  [<ffffffff8109cd90>] ? flush_kthread_worker+0x90/0x90
[23514.127893]  [<ffffffff8180d6a2>] ret_from_fork+0x42/0x70
[23514.127898]  [<ffffffff8109cd90>] ? flush_kthread_worker+0x90/0x90
[23514.127901] ---[ end trace a2b494fb2ce24c5e ]---
[23514.127906] BTRFS: error (device sdb) in
btrfs_run_delayed_refs:2821: errno=-17 Object already exists
[23514.127936] BTRFS info (device sdb): forced readonly
[23514.127940] BTRFS warning (device sdb): Skipping commit of aborted
transaction.
[23514.127943] BTRFS: error (device sdb) in cleanup_transaction:1692:
errno=-17 Object already exists


regards
Martin
