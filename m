Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ve0-f173.google.com ([209.85.128.173]:35532 "EHLO
	mail-ve0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752383AbaBPP7G (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 16 Feb 2014 10:59:06 -0500
Received: by mail-ve0-f173.google.com with SMTP id jw12so4068331veb.32
        for <linux-btrfs@vger.kernel.org>; Sun, 16 Feb 2014 07:59:05 -0800 (PST)
MIME-Version: 1.0
Date: Sun, 16 Feb 2014 16:59:04 +0100
Message-ID: <CAC+fKQUfzjvdfBdc=9R-WCw94B2fpChW25WWQJD4snw2q0y=ng@mail.gmail.com>
Subject: Error when deleting snapshots
From: Juan Orti Alcaine <j.orti.alcaine@gmail.com>
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I got this error when deleting around a hundred snapshots with kernel
3.13.0 and btrfs-progs 3.12:

[  831.628833] [sched_delayed] sched: RT throttling activated
[  858.586718] BUG: soft lockup - CPU#1 stuck for 22s! [btrfs-transacti:643]
[  858.586721] Modules linked in: ipt_MASQUERADE xt_CHECKSUM tun
ip6t_rpfilter ip6t_REJECT xt_conntrack bnep bluetooth cfg80211
ebtable_nat ebtable_broute bridge stp llc ebtable_filter ebtables
ip6table_nat nf_conntrack_ipv6 nf_defrag_ipv6 nf_nat_ipv6
ip6table_mangle ip6table_security ip6table_raw ip6table_filter
ip6_tables iptable_nat nf_conntrack_ipv4 nf_defrag_ipv4 nf_nat_ipv4
nf_nat nf_conntrack iptable_mangle iptable_security iptable_raw
iTCO_wdt eeepc_wmi iTCO_vendor_support asus_wmi sparse_keymap rfkill
snd_hda_codec_hdmi vfat fat x86_pkg_temp_thermal coretemp kvm_intel
kvm crct10dif_pclmul crc32_pclmul snd_hda_codec_realtek crc32c_intel
ghash_clmulni_intel uvcvideo videobuf2_vmalloc videobuf2_memops
videobuf2_core microcode videodev snd_usb_audio snd_hda_intel media
snd_usbmidi_lib serio_raw
[  858.586742]  snd_hda_codec snd_rawmidi i2c_i801 snd_hwdep snd_seq
mceusb snd_seq_device rc_core r8169 snd_pcm mii lpc_ich mfd_core
snd_page_alloc snd_timer snd mei_me mei soundcore shpchp wmi
binfmt_misc usb_storage btrfs libcrc32c xor raid6_pq radeon
i2c_algo_bit drm_kms_helper ttm drm i2c_core video
[  858.586754] CPU: 1 PID: 643 Comm: btrfs-transacti Not tainted
3.13.0-1.fc20.x86_64 #1
[  858.586755] Hardware name: System manufacturer System Product
Name/P8Z68-V LE, BIOS 4101 05/09/2013
[  858.586756] task: ffff8803ff9133c0 ti: ffff880002898000 task.ti:
ffff880002898000
[  858.586757] RIP: 0010:[<ffffffffa029eea1>]  [<ffffffffa029eea1>]
comp_entry+0x11/0x1b0 [btrfs]
[  858.586767] RSP: 0018:ffff880002899c00  EFLAGS: 00000246
[  858.586768] RAX: 0000035f45c00000 RBX: ffff880002899b98 RCX: 00000000000000b8
[  858.586769] RDX: 0000000000000000 RSI: ffff8802e5a4fae0 RDI: ffff88037a7a8360
[  858.586769] RBP: ffff880002899c18 R08: 0000000000000000 R09: 0000000000000000
[  858.586770] R10: ffffffffa029fa3f R11: ffffea000bc7fac0 R12: ffff880403d5b100
[  858.586771] R13: 00000001002a0001 R14: ffffffff00000000 R15: 002a000002899b80
[  858.586772] FS:  0000000000000000(0000) GS:ffff88041ec40000(0000)
knlGS:0000000000000000
[  858.586772] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  858.586773] CR2: 0000000002beb018 CR3: 000000000dc0c000 CR4: 00000000000407e0
[  858.586774] Stack:
[  858.586774]  ffff88037a7a8360 0000300900000000 ffff8802e5a4d300
ffff880002899c70
[  858.586776]  ffffffffa029f8b5 ffff8802f31dd660 ffff880404ab4be0
ffff88037a7a8360
[  858.586777]  0000000100000000 ffff88031c7e3cc0 ffff8802f31dd660
0000000000000000
[  858.586779] Call Trace:
[  858.586787]  [<ffffffffa029f8b5>] btrfs_merge_delayed_refs+0xe5/0x3d0 [btrfs]
[  858.586793]  [<ffffffffa0246e74>] run_clustered_refs+0x84/0x1080 [btrfs]
[  858.586798]  [<ffffffffa02472af>] ? run_clustered_refs+0x4bf/0x1080 [btrfs]
[  858.586803]  [<ffffffffa02472af>] ? run_clustered_refs+0x4bf/0x1080 [btrfs]
[  858.586809]  [<ffffffffa024bb70>] btrfs_run_delayed_refs+0xe0/0x530 [btrfs]
[  858.586815]  [<ffffffffa025bb0e>] btrfs_commit_transaction+0x4e/0x940 [btrfs]
[  858.586821]  [<ffffffffa0257c25>] transaction_kthread+0x1c5/0x250 [btrfs]
[  858.586827]  [<ffffffffa0257a60>] ?
btrfs_cleanup_transaction+0x520/0x520 [btrfs]
[  858.586830]  [<ffffffff8108f3b2>] kthread+0xd2/0xf0
[  858.586831]  [<ffffffff8108f2e0>] ? insert_kthread_work+0x40/0x40
[  858.586833]  [<ffffffff8169503c>] ret_from_fork+0x7c/0xb0
[  858.586835]  [<ffffffff8108f2e0>] ? insert_kthread_work+0x40/0x40
[  858.586835] Code: b4 eb 2c a0 48 89 55 e8 e8 2d e8 dc e0 48 8b 55
e8 e9 1e ff ff ff 0f 1f 40 00 66 66 66 66 90 55 48 89 e5 41 55 41 54
49 89 fc 53 <48> 8b 47 18 48 89 f3 48 39 46 18 0f 82 be 00 00 00 0f 87
90 00
[  858.622675] BUG: soft lockup - CPU#4 stuck for 22s! [btrfs-cleaner:642]
[  858.622677] Modules linked in: ipt_MASQUERADE xt_CHECKSUM tun
ip6t_rpfilter ip6t_REJECT xt_conntrack bnep bluetooth cfg80211
ebtable_nat ebtable_broute bridge stp llc ebtable_filter ebtables
ip6table_nat nf_conntrack_ipv6 nf_defrag_ipv6 nf_nat_ipv6
ip6table_mangle ip6table_security ip6table_raw ip6table_filter
ip6_tables iptable_nat nf_conntrack_ipv4 nf_defrag_ipv4 nf_nat_ipv4
nf_nat nf_conntrack iptable_mangle iptable_security iptable_raw
iTCO_wdt eeepc_wmi iTCO_vendor_support asus_wmi sparse_keymap rfkill
snd_hda_codec_hdmi vfat fat x86_pkg_temp_thermal coretemp kvm_intel
kvm crct10dif_pclmul crc32_pclmul snd_hda_codec_realtek crc32c_intel
ghash_clmulni_intel uvcvideo videobuf2_vmalloc videobuf2_memops
videobuf2_core microcode videodev snd_usb_audio snd_hda_intel media
snd_usbmidi_lib serio_raw
[  858.622698]  snd_hda_codec snd_rawmidi i2c_i801 snd_hwdep snd_seq
mceusb snd_seq_device rc_core r8169 snd_pcm mii lpc_ich mfd_core
snd_page_alloc snd_timer snd mei_me mei soundcore shpchp wmi
binfmt_misc usb_storage btrfs libcrc32c xor raid6_pq radeon
i2c_algo_bit drm_kms_helper ttm drm i2c_core video
[  858.622711] CPU: 4 PID: 642 Comm: btrfs-cleaner Not tainted
3.13.0-1.fc20.x86_64 #1
[  858.622712] Hardware name: System manufacturer System Product
Name/P8Z68-V LE, BIOS 4101 05/09/2013
[  858.622713] task: ffff8803ff915640 ti: ffff880002896000 task.ti:
ffff880002896000
[  858.622714] RIP: 0010:[<ffffffff8168cb48>]  [<ffffffff8168cb48>]
_raw_spin_lock+0x28/0x40
[  858.622718] RSP: 0018:ffff880002897c40  EFLAGS: 00000297
[  858.622718] RAX: 0000000000008d1a RBX: ffff880002897c48 RCX: 0000000000008d1b
[  858.622719] RDX: 0000000000008d1b RSI: 0000000000000050 RDI: ffff8800d781e598
[  858.622720] RBP: ffff880002897c40 R08: 000000000001b680 R09: ffffffffa029fe74
[  858.622721] R10: ffff880404a22510 R11: ffff880404ab00a0 R12: ffffffff8114a6ca
[  858.622721] R13: ffff880002897bc0 R14: ffffffff00000000 R15: ffffea000b552680
[  858.622722] FS:  0000000000000000(0000) GS:ffff88041ed00000(0000)
knlGS:0000000000000000
[  858.622723] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  858.622724] CR2: 00007fff278fcff8 CR3: 000000000dc0c000 CR4: 00000000000407e0
[  858.622724] Stack:
[  858.622725]  ffff880002897cb8 ffffffffa029fe99 ffff880391c11000
0000000000000272
[  858.622727]  ffff880002897d18 ffffffffa023facd ffff8802d5081cc0
000003525ee3e000
[  858.622728]  ffff880406ee6000 000003525a110000 ffff8802d507fb80
ffff880391c11000
[  858.622729] Call Trace:
[  858.622742]  [<ffffffffa029fe99>]
btrfs_add_delayed_tree_ref+0x89/0x160 [btrfs]
[  858.622747]  [<ffffffffa023facd>] ? __btrfs_mod_ref+0xcd/0x270 [btrfs]
[  858.622753]  [<ffffffffa02482fc>] btrfs_free_tree_block+0x8c/0x280 [btrfs]
[  858.622758]  [<ffffffffa02485b5>] walk_up_proc+0xc5/0x410 [btrfs]
[  858.622764]  [<ffffffffa0248a31>] walk_up_tree+0x131/0x1f0 [btrfs]
[  858.622769]  [<ffffffffa024a2c8>] btrfs_drop_snapshot+0x3e8/0x780 [btrfs]
[  858.622776]  [<ffffffffa025d244>]
btrfs_clean_one_deleted_snapshot+0xb4/0x110 [btrfs]
[  858.622781]  [<ffffffffa0254448>] cleaner_kthread+0x128/0x180 [btrfs]
[  858.622787]  [<ffffffffa0254320>] ? check_leaf.isra.40+0x310/0x310 [btrfs]
[  858.622789]  [<ffffffff8108f3b2>] kthread+0xd2/0xf0
[  858.622791]  [<ffffffff8108f2e0>] ? insert_kthread_work+0x40/0x40
[  858.622792]  [<ffffffff8169503c>] ret_from_fork+0x7c/0xb0
[  858.622794]  [<ffffffff8108f2e0>] ? insert_kthread_work+0x40/0x40
[  858.622795] Code: 0f 1f 00 66 66 66 66 90 55 48 89 e5 b8 00 00 01
00 f0 0f c1 07 89 c2 c1 ea 10 66 39 c2 75 02 5d c3 0f b7 07 89 d1 66
39 d0 74 f4 <f3> 90 0f b7 07 66 39 c8 75 f6 5d c3 66 66 66 2e 0f 1f 84
00 00
[  862.653874] BUG: soft lockup - CPU#7 stuck for 22s! [btrfs-delalloc-:4932]
[  862.653876] Modules linked in: ipt_MASQUERADE xt_CHECKSUM tun
ip6t_rpfilter ip6t_REJECT xt_conntrack bnep bluetooth cfg80211
ebtable_nat ebtable_broute bridge stp llc ebtable_filter ebtables
ip6table_nat nf_conntrack_ipv6 nf_defrag_ipv6 nf_nat_ipv6
ip6table_mangle ip6table_security ip6table_raw ip6table_filter
ip6_tables iptable_nat nf_conntrack_ipv4 nf_defrag_ipv4 nf_nat_ipv4
nf_nat nf_conntrack iptable_mangle iptable_security iptable_raw
iTCO_wdt eeepc_wmi iTCO_vendor_support asus_wmi sparse_keymap rfkill
snd_hda_codec_hdmi vfat fat x86_pkg_temp_thermal coretemp kvm_intel
kvm crct10dif_pclmul crc32_pclmul snd_hda_codec_realtek crc32c_intel
ghash_clmulni_intel uvcvideo videobuf2_vmalloc videobuf2_memops
videobuf2_core microcode videodev snd_usb_audio snd_hda_intel media
snd_usbmidi_lib serio_raw
[  862.653897]  snd_hda_codec snd_rawmidi i2c_i801 snd_hwdep snd_seq
mceusb snd_seq_device rc_core r8169 snd_pcm mii lpc_ich mfd_core
snd_page_alloc snd_timer snd mei_me mei soundcore shpchp wmi
binfmt_misc usb_storage btrfs libcrc32c xor raid6_pq radeon
i2c_algo_bit drm_kms_helper ttm drm i2c_core video
[  862.653910] CPU: 7 PID: 4932 Comm: btrfs-delalloc- Not tainted
3.13.0-1.fc20.x86_64 #1
[  862.653911] Hardware name: System manufacturer System Product
Name/P8Z68-V LE, BIOS 4101 05/09/2013
[  862.653912] task: ffff8803db711140 ti: ffff880093860000 task.ti:
ffff880093860000
[  862.653912] RIP: 0010:[<ffffffff8168cb4a>]  [<ffffffff8168cb4a>]
_raw_spin_lock+0x2a/0x40
[  862.653916] RSP: 0018:ffff880093861990  EFLAGS: 00000293
[  862.653917] RAX: 0000000000008d1a RBX: ffffffffa0274d81 RCX: 0000000000008d1c
[  862.653918] RDX: 0000000000008d1c RSI: 0000000000000050 RDI: ffff8800d781e598
[  862.653919] RBP: ffff880093861990 R08: 000000000001b680 R09: ffffffffa029fe74
[  862.653919] R10: 00000000e3398e01 R11: ffffea000d9cc900 R12: ffff880093861938
[  862.653920] R13: 00000001002e002e R14: ffff880093861900 R15: ffff8800d781e4e8
[  862.653921] FS:  0000000000000000(0000) GS:ffff88041edc0000(0000)
knlGS:0000000000000000
[  862.653922] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  862.653923] CR2: 00007f64f9abd000 CR3: 000000000dc0c000 CR4: 00000000000407e0
[  862.653923] Stack:
[  862.653924]  ffff880093861a08 ffffffffa029fe99 ffff880093861fd8
0000000000000000
[  862.653926]  000004479ffb3fff 0000000000001001 ffff88009890d770
0000000000000000
[  862.653927]  ffff880406ee6000 000004479ffb3000 ffff88009456cc80
ffff88000b515000
[  862.653928] Call Trace:
[  862.653939]  [<ffffffffa029fe99>]
btrfs_add_delayed_tree_ref+0x89/0x160 [btrfs]
[  862.653946]  [<ffffffffa0249e12>] btrfs_alloc_free_block+0x372/0x440 [btrfs]
[  862.653951]  [<ffffffffa0239605>] split_leaf+0x1a5/0x6c0 [btrfs]
[  862.653956]  [<ffffffffa023a420>] btrfs_search_slot+0x900/0x970 [btrfs]
[  862.653961]  [<ffffffffa023bdb0>] btrfs_insert_empty_items+0x70/0xc0 [btrfs]
[  862.653965]  [<ffffffffa023501a>] ? btrfs_alloc_path+0x1a/0x20 [btrfs]
[  862.653972]  [<ffffffffa026234d>] insert_inline_extent+0xbd/0x330 [btrfs]
[  862.653978]  [<ffffffffa0262736>] cow_file_range_inline+0x176/0x260 [btrfs]
[  862.653984]  [<ffffffffa026416b>]
compress_file_range.constprop.54+0x30b/0x5e0 [btrfs]
[  862.653990]  [<ffffffffa0264475>] async_cow_start+0x35/0x60 [btrfs]
[  862.653996]  [<ffffffffa0288d8c>] worker_loop+0x12c/0x510 [btrfs]
[  862.654003]  [<ffffffffa0288c60>] ? btrfs_queue_worker+0x2f0/0x2f0 [btrfs]
[  862.654005]  [<ffffffff8108f3b2>] kthread+0xd2/0xf0
[  862.654007]  [<ffffffff8108f2e0>] ? insert_kthread_work+0x40/0x40
[  862.654008]  [<ffffffff8169503c>] ret_from_fork+0x7c/0xb0
[  862.654010]  [<ffffffff8108f2e0>] ? insert_kthread_work+0x40/0x40
[  862.654010] Code: 00 66 66 66 66 90 55 48 89 e5 b8 00 00 01 00 f0
0f c1 07 89 c2 c1 ea 10 66 39 c2 75 02 5d c3 0f b7 07 89 d1 66 39 d0
74 f4 f3 90 <0f> b7 07 66 39 c8 75 f6 5d c3 66 66 66 2e 0f 1f 84 00 00
00 00
