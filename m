Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:58097 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750942Ab3ERMsZ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 18 May 2013 08:48:25 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1UdgYh-0006WA-Ij
	for linux-btrfs@vger.kernel.org; Sat, 18 May 2013 14:48:23 +0200
Received: from dyndsl-085-016-234-163.ewe-ip-backbone.de ([85.16.234.163])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sat, 18 May 2013 14:48:23 +0200
Received: from hurikhan77+btrfs by dyndsl-085-016-234-163.ewe-ip-backbone.de with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sat, 18 May 2013 14:48:23 +0200
To: linux-btrfs@vger.kernel.org
From: Kai Krakow <hurikhan77+btrfs@gmail.com>
Subject: btrfs: error -5 while searching for dev_stats item for device
Date: Sat, 18 May 2013 14:47:20 +0200
Message-ID: <jr9k6a-tia.ln1@hurikhan.ath.cx>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hey list!

Here's another backtrace observed while deduplicating my snapshotted btrfs 
backup volume...

https://gist.github.com/kakra/26b377cccfc66ab870e4

[58198.314804] btrfs: error -5 while searching for dev_stats item for device 
/dev/sdd1!
[58198.314807] ------------[ cut here ]------------
[58198.314812] WARNING: at fs/btrfs/transaction.c:913 
commit_cowonly_roots+0xb4/0x22b()
[58198.314813] Hardware name: To Be Filled By O.E.M.
[58198.314814] Modules linked in: bnep bluetooth ipt_MASQUERADE 
nf_conntrack_netbios_ns nf_conntrack_broadcast xt_tcpudp ip6table_mangle 
ip6t_REJECT nf_conntrack_ipv6 nf_defrag_ipv6 ip6table_filter ip6_tables 
iptable_nat nf_nat_ipv4 nf_nat iptable_mangle ipt_REJECT nf_conntrack_ipv4 
nf_defrag_ipv4 xt_conntrack nf_conntrack iptable_filter ip_tables x_tables 
af_packet vmblock(O) vsock vmmon(O) vmci(O) vmnet(O) reiserfs snd_usb_audio 
snd_usbmidi_lib snd_rawmidi snd_seq_device gspca_sonixj gspca_main gpio_ich 
videodev coretemp hwmon kvm_intel kvm crc32_pclmul crc32c_intel lpc_ich 
mfd_core i2c_i801 r8169 microcode pcspkr evdev usb_storage zram(C) unix
[58198.314841] Pid: 13751, comm: umount Tainted: G         C O 3.9.2-gentoo 
#1
[58198.314842] Call Trace:
[58198.314847]  [<ffffffff8102f11d>] ? warn_slowpath_common+0x78/0x8e
[58198.314849]  [<ffffffff8117ef77>] ? commit_cowonly_roots+0xb4/0x22b
[58198.314852]  [<ffffffff8104f6b8>] ? should_resched+0x5/0x23
[58198.314854]  [<ffffffff811808a8>] ? btrfs_commit_transaction+0x452/0x845
[58198.314857]  [<ffffffff81049e3a>] ? add_wait_queue+0x3c/0x3c
[58198.314859]  [<ffffffff811815d1>] ? 
btrfs_attach_transaction_barrier+0x15/0x38
[58198.314862]  [<ffffffff8111a5fd>] ? __sync_filesystem+0x32/0x44
[58198.314865]  [<ffffffff810f9366>] ? generic_shutdown_super+0x26/0xbf
[58198.314867]  [<ffffffff810f9467>] ? kill_anon_super+0x9/0x11
[58198.314870]  [<ffffffff8115bfe8>] ? btrfs_kill_super+0xd/0x16
[58198.314872]  [<ffffffff810f9517>] ? deactivate_locked_super+0x2c/0x56
[58198.314875]  [<ffffffff8110df45>] ? sys_umount+0x2d1/0x303
[58198.314879]  [<ffffffff81516792>] ? system_call_fastpath+0x16/0x1b
[58198.314880] ---[ end trace 2657d62297fa95d1 ]---
[58198.314907] ------------[ cut here ]------------
[58198.314910] WARNING: at fs/btrfs/super.c:255 
__btrfs_abort_transaction+0x4b/0xd2()
[58198.314911] Hardware name: To Be Filled By O.E.M.
[58198.314912] btrfs: Transaction aborted
[58198.314913] Modules linked in: bnep bluetooth ipt_MASQUERADE 
nf_conntrack_netbios_ns nf_conntrack_broadcast xt_tcpudp ip6table_mangle 
ip6t_REJECT nf_conntrack_ipv6 nf_defrag_ipv6 ip6table_filter ip6_tables 
iptable_nat nf_nat_ipv4 nf_nat iptable_mangle ipt_REJECT nf_conntrack_ipv4 
nf_defrag_ipv4 xt_conntrack nf_conntrack iptable_filter ip_tables x_tables 
af_packet vmblock(O) vsock vmmon(O) vmci(O) vmnet(O) reiserfs snd_usb_audio 
snd_usbmidi_lib snd_rawmidi snd_seq_device gspca_sonixj gspca_main gpio_ich 
videodev coretemp hwmon kvm_intel kvm crc32_pclmul crc32c_intel lpc_ich 
mfd_core i2c_i801 r8169 microcode pcspkr evdev usb_storage zram(C) unix
[58198.314931] Pid: 13751, comm: umount Tainted: G        WC O 3.9.2-gentoo 
#1
[58198.314932] Call Trace:
[58198.314934]  [<ffffffff8102f11d>] ? warn_slowpath_common+0x78/0x8e
[58198.314936]  [<ffffffff8102f1cb>] ? warn_slowpath_fmt+0x45/0x4a
[58198.314938]  [<ffffffff81160f10>] ? __btrfs_abort_transaction+0x4b/0xd2
[58198.314940]  [<ffffffff8116d8e4>] ? __btrfs_free_extent+0x5d8/0x605
[58198.314942]  [<ffffffff81170901>] ? run_clustered_refs+0x765/0x80a
[58198.314945]  [<ffffffff8117372f>] ? btrfs_run_delayed_refs+0x215/0x39c
[58198.314948]  [<ffffffff811cde40>] ? btrfs_dev_replace_unlock+0x8a/0x99
[58198.314949]  [<ffffffff811cea5f>] ? btrfs_run_dev_replace+0x41/0x2a6
[58198.314951]  [<ffffffff8117efbf>] ? commit_cowonly_roots+0xfc/0x22b
[58198.314953]  [<ffffffff8104f6b8>] ? should_resched+0x5/0x23
[58198.314955]  [<ffffffff811808a8>] ? btrfs_commit_transaction+0x452/0x845
[58198.314957]  [<ffffffff81049e3a>] ? add_wait_queue+0x3c/0x3c
[58198.314959]  [<ffffffff811815d1>] ? 
btrfs_attach_transaction_barrier+0x15/0x38
[58198.314961]  [<ffffffff8111a5fd>] ? __sync_filesystem+0x32/0x44
[58198.314963]  [<ffffffff810f9366>] ? generic_shutdown_super+0x26/0xbf
[58198.314965]  [<ffffffff810f9467>] ? kill_anon_super+0x9/0x11
[58198.314967]  [<ffffffff8115bfe8>] ? btrfs_kill_super+0xd/0x16
[58198.314968]  [<ffffffff810f9517>] ? deactivate_locked_super+0x2c/0x56
[58198.314971]  [<ffffffff8110df45>] ? sys_umount+0x2d1/0x303
[58198.314973]  [<ffffffff81516792>] ? system_call_fastpath+0x16/0x1b
[58198.314974] ---[ end trace 2657d62297fa95d2 ]---
[58198.314976] BTRFS error (device sdd1) in __btrfs_free_extent:5394: IO 
failure
[58198.314977] btrfs is forced readonly
[58198.314978] btrfs: run_one_delayed_ref returned -5
[58198.314980] BTRFS error (device sdd1) in btrfs_run_delayed_refs:2565: IO 
failure
[58198.314987] ------------[ cut here ]------------
[58198.315010] kernel BUG at fs/btrfs/transaction.c:922!
[58198.315031] invalid opcode: 0000 [#1] SMP 
[58198.315052] Modules linked in: bnep bluetooth ipt_MASQUERADE 
nf_conntrack_netbios_ns nf_conntrack_broadcast xt_tcpudp ip6table_mangle 
ip6t_REJECT nf_conntrack_ipv6 nf_defrag_ipv6 ip6table_filter ip6_tables 
iptable_nat nf_nat_ipv4 nf_nat iptable_mangle ipt_REJECT nf_conntrack_ipv4 
nf_defrag_ipv4 xt_conntrack nf_conntrack iptable_filter ip_tables x_tables 
af_packet vmblock(O) vsock vmmon(O) vmci(O) vmnet(O) reiserfs snd_usb_audio 
snd_usbmidi_lib snd_rawmidi snd_seq_device gspca_sonixj gspca_main gpio_ich 
videodev coretemp hwmon kvm_intel kvm crc32_pclmul crc32c_intel lpc_ich 
mfd_core i2c_i801 r8169 microcode pcspkr evdev usb_storage zram(C) unix
[58198.315353] CPU 0 
[58198.315363] Pid: 13751, comm: umount Tainted: G        WC O 3.9.2-gentoo 
#1 To Be Filled By O.E.M. To Be Filled By O.E.M./Z68 Pro3
[58198.315409] RIP: 0010:[<ffffffff8117efd7>]  [<ffffffff8117efd7>] 
commit_cowonly_roots+0x114/0x22b
[58198.315446] RSP: 0018:ffff880196dcdd78  EFLAGS: 00010282
[58198.315468] RAX: ffff8802ca859028 RBX: ffff8802ca858000 RCX: 
0000000000000007
[58198.315496] RDX: 0000000070810001 RSI: 0000000000000046 RDI: 
ffff88041f20cdd0
[58198.315525] RBP: ffff8802c906b000 R08: 0000000000000002 R09: 
0000000000000000
[58198.315553] R10: 0000000000000000 R11: 0000000000000000 R12: 
ffff88040160e8c0
[58198.315581] R13: 00000000fffffffb R14: ffff8803d2061e88 R15: 
0000000000000000
[58198.315609] FS:  00007f893f3e4780(0000) GS:ffff88041f200000(0000) 
knlGS:0000000000000000
[58198.315641] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[58198.315664] CR2: 0000003b1562f8db CR3: 0000000165d87000 CR4: 
00000000000407f0
[58198.315692] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 
0000000000000000
[58198.315720] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 
0000000000000400
[58198.315749] Process umount (pid: 13751, threadinfo ffff880196dcc000, task 
ffff880368ca0700)
[58198.315781] Stack:
[58198.315790]  ffff88029ba20000 ffff8801eadd6000 ffff88029ba22800 
ffff8802ca859028
[58198.315824]  ffff880255d2a800 ffff8801cc048bd0 ffffffff8104f6b8 
ffff8802c906b000
[58198.315858]  ffff88040160e8c0 0000000000000000 ffff8803d2061e10 
ffff8803d2061e88
[58198.315900] Call Trace:
[58198.315911]  [<ffffffff8104f6b8>] ? should_resched+0x5/0x23
[58198.315934]  [<ffffffff811808a8>] ? btrfs_commit_transaction+0x452/0x845
[58198.315968]  [<ffffffff81049e3a>] ? add_wait_queue+0x3c/0x3c
[58198.315992]  [<ffffffff811815d1>] ? 
btrfs_attach_transaction_barrier+0x15/0x38
[58198.316022]  [<ffffffff8111a5fd>] ? __sync_filesystem+0x32/0x44
[58198.316058]  [<ffffffff810f9366>] ? generic_shutdown_super+0x26/0xbf
[58198.316084]  [<ffffffff810f9467>] ? kill_anon_super+0x9/0x11
[58198.316106]  [<ffffffff8115bfe8>] ? btrfs_kill_super+0xd/0x16
[58198.316129]  [<ffffffff810f9517>] ? deactivate_locked_super+0x2c/0x56
[58198.316155]  [<ffffffff8110df45>] ? sys_umount+0x2d1/0x303
[58198.316178]  [<ffffffff81516792>] ? system_call_fastpath+0x16/0x1b
[58198.316210] Code: 74 02 0f 0b 48 83 ca ff 48 89 ee 4c 89 e7 e8 5b 45 ff 
ff 41 89 c5 48 8d 83 28 10 00 00 45 85 ed 48 89 44 24 18 0f 84 cb 00 00 00 
<0f> 0b 48 8b 45 08 4c 8d b5 d8 fb ff ff 4c 89 e7 48 8b 55 00 4d 
[58198.316377] RIP  [<ffffffff8117efd7>] commit_cowonly_roots+0x114/0x22b
[58198.316404]  RSP <ffff880196dcdd78>
[58198.511604] ---[ end trace 2657d62297fa95d3 ]---

