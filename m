Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pl0-f42.google.com ([209.85.160.42]:46804 "EHLO
        mail-pl0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755904AbdLTTQd (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 20 Dec 2017 14:16:33 -0500
Subject: Re: WARN_ON in __writeback_inodes_sb_nr
From: David Ahern <dsahern@gmail.com>
To: linux-btrfs@vger.kernel.org, viro@zeniv.linux.org.uk,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>
References: <6833930a-08d7-6fbc-0141-eb9cdfd6bb4d@gmail.com>
Message-ID: <58a1255c-e96d-21bf-e206-7d6ebaa3e94c@gmail.com>
Date: Wed, 20 Dec 2017 12:16:31 -0700
MIME-Version: 1.0
In-Reply-To: <6833930a-08d7-6fbc-0141-eb9cdfd6bb4d@gmail.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I am still seeing this problem on 4.15.0-rc3


On 11/17/17 12:55 PM, David Ahern wrote:
> I see a backtrace booting 4.14+ on a mellanox switch. The trace is due
> to the WARN_ON in __writeback_inodes_sb_nr.
> 
> [   40.958590] WARNING: CPU: 0 PID: 183 at
> /home/dsa/kernel-2.git/fs/fs-writeback.c:2339
> __writeback_inodes_sb_nr+0x8a/0x90
> [   40.958593] Modules linked in: ebtable_filter ebtables ip6table_raw
> ip6table_mangle ip6table_filter ip6_tables iTCO_wdt iTCO_vendor_support
> coretemp x86_pkg_temp_thermal kvm_intel kvm irqbypass lpc_ich mfd_core
> battery mei_me mei shpchp lm75 regmap_i2c pmbus pmbus_core i2c_dev
> i2c_mux k10temp mpls_iptunnel mpls_router ip_tunnel at24 tun
> br_netfilter bonding loop autofs4 dm_mod dax crc32c_intel i2c_i801
> i2c_core thermal mlxsw_spectrum psample parman bridge stp llc mlxsw_pci
> mlxsw_core mlxfw devlink e1000e hwmon
> [   40.958664] CPU: 0 PID: 183 Comm: btrfs-transacti Not tainted 4.14.0+ #38
> [   40.958666] Hardware name: Mellanox Technologies Ltd. Mellanox
> switch/Mellanox switch, BIOS 4.6.5 05/21/2015
> [   40.958669] task: ffff8803db266540 task.stack: ffffc90000344000
> [   40.958675] RIP: 0010:__writeback_inodes_sb_nr+0x8a/0x90
> [   40.958677] RSP: 0018:ffffc90000347dc8 EFLAGS: 00010246
> [   40.958681] RAX: 0000000000000000 RBX: ffff88040a641800 RCX:
> 0000000000000000
> [   40.958683] RDX: 0000000000000002 RSI: 00000000000045a7 RDI:
> ffffc90000347e10
> [   40.958685] RBP: ffffc90000347e20 R08: 0000000000000003 R09:
> ffffc90000347dd0
> [   40.958687] R10: ffff8803db287000 R11: 0000000000000000 R12:
> ffffc90000347dcc
> [   40.958689] R13: ffff8804015e7a00 R14: ffff8803dade2bc8 R15:
> ffff880400a68000
> [   40.958692] FS:  0000000000000000(0000) GS:ffff88041dc00000(0000)
> knlGS:0000000000000000
> [   40.958695] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [   40.958697] CR2: 00005602d78aad50 CR3: 0000000001e09002 CR4:
> 00000000001606f0
> [   40.958699] Call Trace:
> [   40.958710]  writeback_inodes_sb+0x27/0x30
> [   40.958719]  btrfs_commit_transaction+0x7b2/0x8e0
> [   40.958723]  ? start_transaction+0x9e/0x450
> [   40.958728]  transaction_kthread+0x177/0x1b0
> [   40.958735]  kthread+0x11d/0x150
> [   40.958740]  ? btrfs_cleanup_transaction+0x4f0/0x4f0
> [   40.958744]  ? kthread_associate_blkcg+0xb0/0xb0
> [   40.958751]  ret_from_fork+0x24/0x30
> [   40.958754] Code: 8b 42 70 48 85 c0 74 23 4c 89 ce 48 89 df 41 0f b6
> d3 e8 fa fc ff ff 4c 89 e6 48 89 df e8 8f de ff ff 48 83 c4 48 5b 41 5c
> 5d c3 <0f> ff eb d9 66 90 0f 1f 44 00 00 55 31 c9 48 89 e5 e8 60 ff ff
> [   40.958826] ---[ end trace defabeb7afdfd414 ]---
> 
> 
> Tree is DaveM's net-next, but it was recently merged with Linus' tree at:
> 
> commit 6363b3f3ac5be096d08c8c504128befa0c033529
> Merge: 1b6115fbe3b3 6297fabd93f9
> Author: Linus Torvalds <torvalds@linux-foundation.org>
> Date:   Wed Nov 15 15:12:28 2017 -0800
> 
>     Merge tag 'ipmi-for-4.15' of git://github.com/cminyard/linux-ipmi
> 

