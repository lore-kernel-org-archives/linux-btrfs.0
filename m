Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-la0-f45.google.com ([209.85.215.45]:57681 "EHLO
	mail-la0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754662AbaJUIOL (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 21 Oct 2014 04:14:11 -0400
Received: by mail-la0-f45.google.com with SMTP id q1so551097lam.32
        for <linux-btrfs@vger.kernel.org>; Tue, 21 Oct 2014 01:14:08 -0700 (PDT)
MIME-Version: 1.0
From: Cristian Falcas <cristi.falcas@gmail.com>
Date: Tue, 21 Oct 2014 11:13:48 +0300
Message-ID: <CAMo7R_e9=wdGhEm9P+DZgXrKQ+qrKqdELzwwi-OMTCp6Mk8aTg@mail.gmail.com>
Subject: downgrade from kernel 3.17 to 3.10
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Can I downgrade the kernel from 3.17.1 to latest 3.10 if I have a
btrfs partition formatted and used on 3.17.1?

I mean, is there something that could go wrong with the fs if suddenly
I use an older kernel?

I want to downgrade because last night we had some 1200 oops's in 1
hour on the 3.17 kernel related to "CPU#n stuck" and what seems to be
btrfs work:

NMI watchdog: BUG: soft lockup - CPU#3 stuck for 22s! [ceph-osd:3542]
Modules linked in: iptable_nat nf_nat_ipv4 nf_nat iptable_mangle
nf_conntrack_ipv4 nf_defrag_ipv4 iptable_filter ip_tables
nf_conntrack_ipv6 nf_defrag_ipv6 xt_mac xt_physdev veth
ip6table_filter ip6_tables ebtable_nat ebtables ipt_REJECT xt_CHECKSUM
autofs4 openvswitch vxlan udp_tunnel gre libcrc32c xt_state
nf_conntrack xt_comment xt_multiport vfat fat bridge ipv6 stp llc
vhost_net macvtap macvlan vhost tun kvm_intel kvm iTCO_wdt
iTCO_vendor_support serio_raw rtc_efi pcspkr ipmi_si ipmi_msghandler
i2c_i801 lpc_ich cdc_ether usbnet mii shpchp sg ses enclosure ioatdma
dca i7core_edac edac_core bnx2 ext4 jbd2 mbcache btrfs raid6_pq xor
sr_mod cdrom sd_mod crc_t10dif crct10dif_common pata_acpi ata_generic
ata_piix megaraid_sas mgag200 ttm drm_kms_helper sysimgblt sysfillrect
syscopyarea dm_mirror dm_region_hash dm_log dm_mod [last unloaded:
nf_defrag_ipv4]
CPU: 3 PID: 3542 Comm: ceph-osd Tainted: G             L
3.17.1-1.el6.elrepo.x86_64 #1
Hardware name: IBM System x3650 M3 -[7945AC1]-/69Y4438     , BIOS
-[D6E149AUS-1.09]- 09/21/2010
task: ffff88121cc2b010 ti: ffff8810212a4000 task.ti: ffff8810212a4000
RIP: 0010:[<ffffffff810b7c96>]  [<ffffffff810b7c96>]
queue_read_lock_slowpath+0x76/
0x90
RSP: 0018:ffff8810212a7b58  EFLAGS: 00000206
RAX: 0000000000000c11 RBX: ffff8810212a7ba8 RCX: ffff880773ee1aec
RDX: 0000000000000c16 RSI: 000000000000000a RDI: ffff880773ee1ae8
RBP: ffff8810212a7b58 R08: 000000000000000b R09: ffff880773ee1aac
R10: 0000000000000000 R11: 0000000000000000 R12: 0000000000000065
R13: 00000019518bb800 R14: ffff88034a151780 R15: ffff8810212a7bb4
FS:  00007f36da014700(0000) GS:ffff88127f260000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 000000030b145010 CR3: 000000121e0e1000 CR4: 00000000000027e0
Stack:
ffff8810212a7b68 ffffffff8165e78d ffff8810212a7bf8 ffffffffa0174eca
00000001012a7b98 ffff88121cc2b010 ffff8810212a7bb0 ffff88121cc2b010
ffff8806b3b67ab8 ffff880b5005a4a0 ffff8810212a7bc8 ffffffffa0158ad1
Call Trace:
[<ffffffff8165e78d>] _raw_read_lock+0x1d/0x30
[<ffffffffa0174eca>] btrfs_tree_read_lock+0x5a/0x130 [btrfs]
[<ffffffffa0158ad1>] ? free_extent_buffer+0x61/0xc0 [btrfs]
[<ffffffffa010e43b>] btrfs_read_lock_root_node+0x3b/0x50 [btrfs]
[<ffffffffa01182da>] btrfs_search_forward+0x3a/0x340 [btrfs]
[<ffffffffa017d215>] btrfs_log_inode+0x375/0x7b0 [btrfs]
[<ffffffffa015e9d3>] ? extent_write_cache_pages.clone.6+0xf3/0x3f0 [btrfs]
[<ffffffff810afb50>] ? bit_waitqueue+0xb0/0xb0
[<ffffffff8165cb96>] ? mutex_lock+0x16/0x40
[<ffffffffa0175cc1>] ? start_log_trans+0xe1/0x230 [btrfs]
[<ffffffffa017d771>] btrfs_log_inode_parent+0x121/0x340 [btrfs]
[<ffffffffa017da8c>] btrfs_log_dentry_safe+0x6c/0x90 [btrfs]
[<ffffffffa014cfc1>] btrfs_sync_file+0x181/0x340 [btrfs]
[<ffffffff81205861>] vfs_fsync_range+0x21/0x30
[<ffffffff8120588c>] vfs_fsync+0x1c/0x20
[<ffffffff81205a7d>] do_fsync+0x3d/0x70
[<ffffffff81205ac3>] SyS_fdatasync+0x13/0x20
[<ffffffff8165ede9>] system_call_fastpath+0x16/0x1b
Code: 00 00 f0 0f c1 07 3c ff 75 0b 0f 1f 00 f3 90 8b 07 3c ff 74 f8
66 83 47 04 01 c9 c3 f3 90 8b 07 3c ff 74 f8 c9 c3 f3 90 0f b7 01 <66>
39 c2 75 f6 0f 1f 44 00 00 eb b5 90 90 90 90 90 90 90 90 90


Thank you,
Cristian Falcas
