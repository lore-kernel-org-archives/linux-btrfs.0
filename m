Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from out.selfhost.de ([82.98.82.95]:37253 "EHLO outgoing.selfhost.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751889Ab3KCW5l (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 3 Nov 2013 17:57:41 -0500
Received: from localhost (kvm-mta.eitelwein.net [IPv6:2001:4dd0:ff00:89e5::208])
	by mail.eitelwein.net (Postfix) with ESMTP id 363B51D26
	for <linux-btrfs@vger.kernel.org>; Sun,  3 Nov 2013 23:50:59 +0100 (CET)
Received: from mail.eitelwein.net ([IPv6:::ffff:127.0.0.1])
	by localhost (vscan.eitelwein.net [::ffff:127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id YnKU0CDrvr5R for <linux-btrfs@vger.kernel.org>;
	Sun,  3 Nov 2013 23:50:59 +0100 (CET)
Received: from [192.168.123.102] (montreal.eitelwein.net [192.168.123.102])
	by mail.eitelwein.net (Postfix) with ESMTPSA id F2A52FB5
	for <linux-btrfs@vger.kernel.org>; Sun,  3 Nov 2013 23:50:58 +0100 (CET)
Message-ID: <5276D352.2090406@eitelwein.net>
Date: Sun, 03 Nov 2013 23:50:58 +0100
From: Michael Eitelwein <michael@eitelwein.net>
MIME-Version: 1.0
To: linux-btrfs@vger.kernel.org
Subject: BTRFS volume crashes after hard reset
Content-Type: text/plain; charset=ISO-8859-15
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi

My computer froze and I had to power-cycle the PC. After reboot,
attempting to mount the btrfs volume leads to a kernel oops:

[  970.140850] device fsid 65db2d61-0301-42c0-9f1b-94dd215f694c devid 1
transid 119849 /dev/sda3
[  970.141475] btrfs: disk space caching is enabled
[  991.149365] ------------[ cut here ]------------
[  991.149378] kernel BUG at
/build/buildd/linux-3.2.0/fs/btrfs/free-space-cache.c:1515!
[  991.149386] invalid opcode: 0000 [#1] SMP
[  991.149393] CPU 3
[  991.149397] Modules linked in: des_generic md4 nls_utf8 cifs
ip6table_filter ip6_tables ebtable_nat ebtables pci_stub vboxpci(O)
vboxnetadp(O) vboxnetflt(O) vboxdrv(O) ipt_MASQUERADE iptable_nat nf_nat
nf_conntrack_ipv4 nf_defrag_ipv4 xt_state nf_conntrack ipt_REJECT
xt_CHECKSUM iptable_mangle xt_tcpudp iptable_filter ip_tables x_tables
kvm_amd kvm bnep rfcomm parport_pc ppdev binfmt_misc dm_crypt btusb
bluetooth snd_hda_codec_hdmi snd_hda_codec_realtek snd_hda_intel
snd_hda_codec bridge stp snd_hwdep snd_pcm snd_seq_midi snd_rawmidi
snd_seq_midi_event snd_seq snd_timer snd_seq_device snd edac_core
k10temp sp5100_tco i2c_piix4 edac_mce_amd soundcore snd_page_alloc
psmouse serio_raw mac_hid lp parport btrfs zlib_deflate libcrc32c
firewire_ohci firewire_core usbhid hid crc_itu_t floppy pata_atiixp wmi
r8169
[  991.149516]
[  991.149523] Pid: 4020, comm: mount Tainted: G           O
3.2.0-32-generic #51-Ubuntu To Be Filled By O.E.M. To Be Filled By
O.E.M./AOD790GX/128M
[  991.149536] RIP: 0010:[<ffffffffa00f2d38>]  [<ffffffffa00f2d38>]
remove_from_bitmap+0x248/0x250 [btrfs]
[  991.149590] RSP: 0018:ffff8801726e1698  EFLAGS: 00010286
[  991.149596] RAX: 00000000ffffffff RBX: ffff880120ade700 RCX:
0000000000000003
[  991.149602] RDX: 0000000000008001 RSI: 0000000000008000 RDI:
ffff8801a0911000
[  991.149608] RBP: ffff8801726e16f8 R08: ffff8801a0912000 R09:
0000000000008000
[  991.149614] R10: ffff880000000000 R11: 0010a78154000000 R12:
0000002c49c00000
[  991.149620] R13: ffff8801726e1718 R14: ffff8801726e1720 R15:
ffff8801819b8840
[  991.149627] FS:  00007f9e6f719800(0000) GS:ffff8801afd80000(0000)
knlGS:00000000f75b86c0
[  991.149633] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[  991.149639] CR2: 00007ff9027b2110 CR3: 0000000159472000 CR4:
00000000000006e0
[  991.149645] DR0: 0000000000000000 DR1: 0000000000000000 DR2:
0000000000000000
[  991.149651] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7:
0000000000000400
[  991.149658] Process mount (pid: 4020, threadinfo ffff8801726e0000,
task ffff8801727b4500)
[  991.149663] Stack:
[  991.149666]  ffff880172682600 ffff880172682600 ffff880172682640
ffff8801819b8864
[  991.149678]  0000002c43303000 000000000000a000 0000000000000286
ffff8801819b8840
[  991.149688]  0000000000000000 ffff8801819b8864 ffff880120ade700
0000000000000000
[  991.149698] Call Trace:
[  991.149742]  [<ffffffffa00f3f99>] btrfs_remove_free_space+0x69/0x330
[btrfs]
[  991.149779]  [<ffffffffa00ae270>]
btrfs_alloc_logged_file_extent+0x1c0/0x1e0 [btrfs]
[  991.149811]  [<ffffffffa009c93a>] ? btrfs_free_path+0x2a/0x40 [btrfs]
[  991.149849]  [<ffffffffa00ef2f8>] replay_one_extent+0x518/0x570 [btrfs]
[  991.149861]  [<ffffffff8108abc0>] ? autoremove_wake_function+0x40/0x40
[  991.149901]  [<ffffffffa00efe2b>] replay_one_buffer+0x26b/0x330 [btrfs]
[  991.149941]  [<ffffffffa00dcb74>] ? alloc_extent_buffer+0x74/0x410
[btrfs]
[  991.149979]  [<ffffffffa00eccea>] walk_down_log_tree+0x1ea/0x3b0 [btrfs]
[  991.150017]  [<ffffffffa00ed1ad>] walk_log_tree+0xbd/0x1d0 [btrfs]
[  991.150056]  [<ffffffffa00f0ea1>] btrfs_recover_log_trees+0x211/0x300
[btrfs]
[  991.150095]  [<ffffffffa00efbc0>] ?
fixup_inode_link_counts+0x150/0x150 [btrfs]
[  991.150133]  [<ffffffffa00bb635>] open_ctree+0x14b5/0x1950 [btrfs]
[  991.150145]  [<ffffffff81316eb4>] ? snprintf+0x34/0x40
[  991.150178]  [<ffffffffa010abe2>] btrfs_fill_super.isra.37+0x72/0x12c
[btrfs]
[  991.150189]  [<ffffffff811e4711>] ? disk_name+0x61/0xc0
[  991.150197]  [<ffffffff813144d7>] ? strlcpy+0x47/0x60
[  991.150226]  [<ffffffffa009a897>] btrfs_mount+0x497/0x4e0 [btrfs]
[  991.150242]  [<ffffffff8117bad3>] mount_fs+0x43/0x1b0
[  991.150254]  [<ffffffff8119637a>] vfs_kern_mount+0x6a/0xc0
[  991.150265]  [<ffffffff81197884>] do_kern_mount+0x54/0x110
[  991.150274]  [<ffffffff811993e4>] do_mount+0x1a4/0x260
[  991.150282]  [<ffffffff811998c0>] sys_mount+0x90/0xe0
[  991.150292]  [<ffffffff81663442>] system_call_fastpath+0x16/0x1b
[  991.150297] Code: e9 7d fe ff ff 66 0f 1f 44 00 00 b8 ea ff ff ff e9
c8 fe ff ff 48 89 de 4c 89 ff 89 45 b0 e8 80 e4 ff ff 8b 45 b0 e9 b2 fe
ff ff <0f> 0b 0f 0b 0f 1f 40 00 55 48 89 e5 41 57 41 56 41 55 41 54 53
[  991.150373] RIP  [<ffffffffa00f2d38>] remove_from_bitmap+0x248/0x250
[btrfs]
[  991.150409]  RSP <ffff8801726e1698>
[  991.150415] ---[ end trace 9a242a0fd54d816f ]---

How can I fix this?

Michael
