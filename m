Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wi0-f171.google.com ([209.85.212.171]:41588 "EHLO
	mail-wi0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751312Ab3KTK2x convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 20 Nov 2013 05:28:53 -0500
Received: by mail-wi0-f171.google.com with SMTP id ca18so355969wib.4
        for <linux-btrfs@vger.kernel.org>; Wed, 20 Nov 2013 02:28:52 -0800 (PST)
Received: from linux-suse.localnet (5401C5A6.dsl.pool.telekom.hu. [84.1.197.166])
        by mx.google.com with ESMTPSA id y20sm43633523wib.0.2013.11.20.02.28.50
        for <linux-btrfs@vger.kernel.org>
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 20 Nov 2013 02:28:51 -0800 (PST)
From: =?utf-8?B?U3rFkXRzIMOBa29z?= <szotsaki@gmail.com>
To: linux-btrfs@vger.kernel.org
Subject: Btrfs assertion failed: !memcmp_extent_buffer() and bug at ctree.h:3832
Date: Wed, 20 Nov 2013 11:28:33 +0100
Message-ID: <3055147.DzOkB8dIN6@linux-suse>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Dear list members,

After a quick directory defragging, I tried to start the mysql daemon. Then 
suddenly to following appeared in the kernel log and the whole system hung up. 
This log is also from an instant copy over SSH.

Now I'm planning to run a btrfsck on the file system, also.

[ 4878.255759] BTRFS assertion failed: !memcmp_extent_buffer(b, &disk_key, 
offsetof(struct btrfs_leaf, items[0].key), sizeof(disk_key)), file: 
/home/abuild/rpmbuild/BUILD/kernel-desktop-3.12.0/linux-3.12/fs/btrfs/ctree.c, 
line: 2444
[ 4878.255788] ------------[ cut here ]------------
[ 4878.255791] kernel BUG at /home/abuild/rpmbuild/BUILD/kernel-
desktop-3.12.0/linux-3.12/fs/btrfs/ctree.h:3832!
[ 4878.255792] invalid opcode: 0000 [#1] PREEMPT SMP 
[ 4878.255795] Modules linked in: bnep bluetooth rfkill xt_tcpudp xt_pkttype 
xt_LOG xt_limit af_packet ip6t_REJECT nf_conntrack_ipv6 nf_defrag_ipv6 
ip6table_raw ipt_REJECT iptable_raw xt_CT iptable_filter ip6table_mangle 
nf_conntrack_netbios_ns nf_conntrack_broadcast nf_conntrack_ipv4 
nf_defrag_ipv4 xt_conntrack ip6table_filter ip6_tables fuse snd_hda_codec_hdmi 
snd_hda_codec_realtek nvidia(PO) snd_hda_intel snd_hda_codec snd_hwdep snd_pcm 
snd_seq snd_timer snd_seq_device snd gpio_ich coretemp kvm_intel iTCO_wdt 
r8169 iTCO_vendor_support soundcore snd_page_alloc mxm_wmi usb_storage sr_mod 
mii serio_raw kvm drm pcspkr lpc_ich mfd_core cdrom i7core_edac wmi edac_core 
i2c_i801 shpchp button acpi_cpufreq sg nf_conntrack ip_tables x_tables dm_mod 
autofs4 btrfs raid6_pq xor libcrc32c crc32c_intel hid_logitech_dj
[ 4878.255829]  processor thermal_sys scsi_dh_rdac scsi_dh_hp_sw scsi_dh_emc 
scsi_dh_alua scsi_dh ata_generic ata_piix
[ 4878.255836] CPU: 1 PID: 23068 Comm: btrfs-endio-wri Tainted: P           O 
3.12.0-6.ge7c00d8-desktop #1
[ 4878.255838] Hardware name: MSI MS-7522/MSI X58 Pro-E (MS-7522), BIOS V8.15 
03/19/2011
[ 4878.255840] task: ffff8801ce70e580 ti: ffff88005e776000 task.ti: ffff88005e776000
[ 4878.255841] RIP: 0010:[<ffffffffa0133525>]  [<ffffffffa0133525>] 
assfail.constprop.38+0x1a/0x1c [btrfs]
[ 4878.255860] RSP: 0018:ffff88005e7779b8  EFLAGS: 00010286
[ 4878.255862] RAX: 00000000000000d9 RBX: ffff8801daba5d00 RCX: 0000000000007c72
[ 4878.255863] RDX: 0000000000007c72 RSI: 0000000000000046 RDI: 
0000000000000246
[ 4878.255865] RBP: ffff880192529960 R08: 000000000000000a R09: 00000000000015f7
[ 4878.255866] R10: 0000000000000000 R11: ffff88005e777786 R12: 0000000000000000
[ 4878.255867] R13: 0000160000000000 R14: 0000000000000000 R15: 
0000000000000000
[ 4878.255869] FS:  0000000000000000(0000) GS:ffff8802bfc20000(0000) 
knlGS:0000000000000000
[ 4878.255871] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[ 4878.255872] CR2: 00000000007a385c CR3: 00000001dc534000 CR4: 
00000000000007e0
[ 4878.255874] Stack:
[ 4878.255875]  ffffffffa00a003b 19ff8801daba5d00 6c00000000000442 0000000000000000
[ 4878.255878]  ffffffffa00a79da ffff8801c9121928 ffff880065f21000 000550a300000000
[ 4878.255881]  ffff8801722e2420 0000000037306000 ffff8801722e2420 ffff880000000000
[ 4878.255884] Call Trace:
[ 4878.255905]  [<ffffffffa00a003b>] key_search_validate+0x6b/0x70 [btrfs]
[ 4878.255924]  [<ffffffffa00a79da>] btrfs_search_old_slot+0x2fa/0xa70 [btrfs]
[ 4878.255954]  [<ffffffffa0121a23>] __resolve_indirect_refs+0x103/0x600 [btrfs]
[ 4878.256069]  [<ffffffffa012282a>] find_parent_nodes+0x5da/0xe70 [btrfs]
[ 4878.256178]  [<ffffffffa0123a96>] iterate_extent_inodes+0xf6/0x320 [btrfs]
[ 4878.256291]  [<ffffffffa0123d44>] iterate_inodes_from_logical+0x84/0xa0 [btrfs]
[ 4878.256400]  [<ffffffffa00cb20b>] record_extent_backrefs+0x6b/0xe0 [btrfs]
[ 4878.256451]  [<ffffffffa00d55b0>] btrfs_finish_ordered_io+0x1d0/0xad0 [btrfs]
[ 4878.256507]  [<ffffffffa00f73d9>] worker_loop+0x149/0x550 [btrfs]
[ 4878.256581]  [<ffffffff8107355f>] kthread+0xaf/0xc0
[ 4878.256587]  [<ffffffff815caf8c>] ret_from_fork+0x7c/0xb0
[ 4878.256590] Code: c7 80 f9 13 a0 31 c0 e9 0e 52 48 e1 c3 0f 0b 0f 0b 89 f1 
48 c7 c2 58 ff 13 a0 48 89 fe 31 c0 48 c7 c7 f8 ff 13 a0 e8 ef 51 48 e1 <0f> 0b 
0f 0b 41 54 49 89 f4 55 48 89 d5 53 48 89 fb 48 83 ec 18 
[ 4878.256615] RIP  [<ffffffffa0133525>] assfail.constprop.38+0x1a/0x1c [btrfs]
[ 4878.256626]  RSP <ffff88005e7779b8>
[ 4878.256642] ---[ end trace 2108d6eb38da44b5 ]---
[ 4878.256644] note: btrfs-endio-wri[23068] exited with preempt_count 1

Versions:
- OS: openSUSE 13.1
- Kernel: Linux linux-suse 3.12.0-6.ge7c00d8-desktop #1 SMP PREEMPT Tue Nov 12 
13:09:24 UTC 2013 (e7c00d8) x86_64 x86_64 x86_64 GNU/Linux

Ákos
