Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wm0-f50.google.com ([74.125.82.50]:36791 "EHLO
	mail-wm0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752866AbbLBJSa (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 2 Dec 2015 04:18:30 -0500
Received: by wmww144 with SMTP id w144so206115317wmw.1
        for <linux-btrfs@vger.kernel.org>; Wed, 02 Dec 2015 01:18:28 -0800 (PST)
MIME-Version: 1.0
From: =?UTF-8?B?0JzQuNGF0LDQuNC7INCT0LDQstGA0LjQu9C+0LI=?=
	<mikhail.v.gavrilov@gmail.com>
Date: Wed, 2 Dec 2015 14:18:13 +0500
Message-ID: <CABXGCsMgw7NH5VzPvOVKrkd03CH7Dmjhg1xizwhknLDg9Vk2AA@mail.gmail.com>
Subject: kernel BUG at fs/btrfs/extent-tree.c:1833! [btrfs]
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

kernel BUG at fs/btrfs/extent-tree.c:1833!
invalid opcode: 0000 [#1] SMP
Modules linked in: xt_CHECKSUM ipt_MASQUERADE nf_nat_masquerade_ipv4
tun nls_utf8 isofs rfcomm fuse nf_conntrack_netbios_ns
nf_conntrack_broadcast ip6t_rpfilter ip6t_REJECT nf_reject_ipv6
xt_conntrack ebtable_nat ebtable_broute bridge ebtable_filter ebtables
ip6table_mangle ip6table_raw ip6table_nat nf_conntrack_ipv6
nf_defrag_ipv6 nf_nat_ipv6 ip6table_security ip6table_filter
ip6_tables iptable_mangle iptable_raw iptable_nat nf_conntrack_ipv4
nf_defrag_ipv4 nf_nat_ipv4 nf_nat nf_conntrack iptable_security bnep
snd_usb_audio snd_usbmidi_lib snd_rawmidi hid_logitech_hidpp btusb
btrtl btbcm btintel bluetooth gspca_zc3xx gspca_main videodev uas
media joydev usb_storage hid_logitech_dj rfkill btrfs xor intel_rapl
iosf_mbi x86_pkg_temp_thermal snd_hda_codec_hdmi snd_hda_codec_realtek
coretemp
 snd_hda_codec_generic snd_hda_codec_ca0132 iTCO_wdt
iTCO_vendor_support kvm_intel vfat ppdev fat kvm snd_hda_intel
snd_hda_codec snd_hda_core snd_hwdep snd_seq crct10dif_pclmul
snd_seq_device crc32_pclmul crc32c_intel snd_pcm raid6_pq snd_timer
snd mei_me mei soundcore shpchp i2c_i801 lpc_ich parport_pc
tpm_infineon parport tpm_tis tpm nfsd auth_rpcgss nfs_acl lockd grace
sunrpc binfmt_misc i915 i2c_algo_bit drm_kms_helper drm 8021q garp stp
llc mrp serio_raw r8169 mii video
CPU: 7 PID: 10775 Comm: kworker/u16:15 Not tainted 4.2.6-301.fc23.x86_64 #1
Hardware name: Gigabyte Technology Co., Ltd. Z87M-D3H/Z87M-D3H, BIOS
F11 08/12/2014
Workqueue: btrfs-extent-refs btrfs_extent_refs_helper [btrfs]
task: ffff8805c042bb00 ti: ffff88074d748000 task.ti: ffff88074d748000
RIP: 0010:[<ffffffffa05e9af7>]  [<ffffffffa05e9af7>]
insert_inline_extent_backref+0xe7/0xf0 [btrfs]
RSP: 0018:ffff88074d74baa8  EFLAGS: 00010293
RAX: 0000000000000000 RBX: 0000000000000000 RCX: 0000000000000000
RDX: ffff880000000000 RSI: 0000000000000001 RDI: 0000000000000000
RBP: ffff88074d74bb28 R08: 0000000000004000 R09: ffff88074d74b9a0
R10: 0000000000000000 R11: 0000000000000003 R12: ffff8807ec932800
R13: ffff88048185d090 R14: 0000000000000000 R15: 0000000000000000
FS:  0000000000000000(0000) GS:ffff88081e3c0000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 000013dd12294020 CR3: 0000000001c0b000 CR4: 00000000001406e0
Stack:
 0000000000000000 0000000000000005 0000000000000000 0000000000000000
 0000000000000001 ffffffff81200206 ffff88074d74bb08 ffffffffa05dcd4a
 00000000000033e8 000000004e7e87f3 ffff8807ea905800 0000000000000000
Call Trace:
 [<ffffffff81200206>] ? kmem_cache_alloc+0x1d6/0x210
 [<ffffffffa05dcd4a>] ? btrfs_alloc_path+0x1a/0x20 [btrfs]
 [<ffffffffa05e9f99>] __btrfs_inc_extent_ref.isra.52+0xa9/0x270 [btrfs]
 [<ffffffffa05ef6b4>] __btrfs_run_delayed_refs+0xc84/0x1080 [btrfs]
 [<ffffffff811a5347>] ? mempool_free_slab+0x17/0x20
 [<ffffffff812001c3>] ? kmem_cache_alloc+0x193/0x210
 [<ffffffffa05f2674>] btrfs_run_delayed_refs.part.73+0x74/0x270 [btrfs]
 [<ffffffffa05f290e>] delayed_ref_async_start+0x7e/0x90 [btrfs]
 [<ffffffffa06384b2>] btrfs_scrubparity_helper+0xc2/0x260 [btrfs]
 [<ffffffffa063868e>] btrfs_extent_refs_helper+0xe/0x10 [btrfs]
 [<ffffffff810b650e>] process_one_work+0x19e/0x3f0
 [<ffffffff810b67ae>] worker_thread+0x4e/0x450
 [<ffffffff810b6760>] ? process_one_work+0x3f0/0x3f0
 [<ffffffff810bc8b8>] kthread+0xd8/0xf0
 [<ffffffff810bc7e0>] ? kthread_worker_fn+0x160/0x160
 [<ffffffff817797df>] ret_from_fork+0x3f/0x70
 [<ffffffff810bc7e0>] ? kthread_worker_fn+0x160/0x160
Code: 10 49 89 d9 48 8b 55 c0 4c 89 7c 24 10 4c 89 f1 4c 89 ee 4c 89
e7 89 44 24 08 48 8b 45 20 48 89 04 24 e8 5d d5 ff ff 31 c0 eb ac <0f>
0b e8 92 47 ab e0 66 90 0f 1f 44 00 00 55 48 89 e5 41 57 41
RIP  [<ffffffffa05e9af7>] insert_inline_extent_backref+0xe7/0xf0 [btrfs]
 RSP <ffff88074d74baa8>



Report from downstream: https://bugzilla.redhat.com/show_bug.cgi?id=1287508


--
Best Regards,
Mike Gavrilov.
