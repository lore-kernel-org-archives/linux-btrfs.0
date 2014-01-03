Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:45425 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750743AbaACDoD (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 2 Jan 2014 22:44:03 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1Vyvg1-0004vp-Kj
	for linux-btrfs@vger.kernel.org; Fri, 03 Jan 2014 04:44:01 +0100
Received: from 50-0-67-239.dsl.static.fusionbroadband.com ([50.0.67.239])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Fri, 03 Jan 2014 04:44:01 +0100
Received: from rogerb by 50-0-67-239.dsl.static.fusionbroadband.com with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Fri, 03 Jan 2014 04:44:01 +0100
To: linux-btrfs@vger.kernel.org
From: Roger Binns <rogerb@rogerbinns.com>
Subject: Crash in submit_extent_page.isra  (3.12.6)
Date: Thu, 02 Jan 2014 19:43:50 -0800
Message-ID: <la5bla$6c8$1@ger.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

This occurs sporadically and the machine is somewhat useless as a result
since most filesystem operations then hang.  For example even reboot 
fails because it does filesystem operations.

kernel is regular kernel.org 3.12.6 compiled with Ubuntu's kernel config.
OS is Ubuntu 13.10 AMD64

I have 3 separate btrfs filesystems each with a few subvolumes, and with
subvolume snapshots (hourly, daily, weekly etc).  No RAID, crypto etc.

Kernel BUG at ffffffffa01268e8 [verbose debug info unavailable]
[86961.217522] invalid opcode: 0000 [#1] SMP 
[86961.217536] Modules linked in: pci_stub vboxpci(OF) vboxnetadp(OF) vboxnetflt(OF) vboxdrv(OF) 8021q garp mrp parport_pc ppdev bnep rfcomm bluetooth binfmt_misc snd_hda_codec_hdmi snd_hda_codec_realtek x86_pkg_temp_thermal intel_powerclamp coretemp kvm_intel kvm crct10dif_pclmul crc32_pclmul ghash_clmulni_intel bridge aesni_intel stp aes_x86_64 llc lrw gf128mul glue_helper ablk_helper cryptd eeepc_wmi asus_wmi mxm_wmi sparse_keymap joydev snd_hda_intel snd_hda_codec arc4 snd_usb_audio snd_seq_midi snd_usbmidi_lib snd_hwdep snd_seq_midi_event uvcvideo snd_rawmidi videobuf2_vmalloc ath9k videobuf2_memops snd_pcm videobuf2_core ath9k_common videodev ath9k_hw snd_page_alloc ath mac80211 microcode psmouse serio_raw cfg80211 i915 snd_seq lpc_ich snd_seq_device drm_kms_helper snd_timer drm snd wmi video i2c_algo_bit mac_hid mei_me soundcore mei lp parport hid_generic usbhid hid btrfs libcrc32c raid10 raid456 async_raid6_recov async_memcpy async_pq async_xor async_tx xor raid6_pq e1000e rai
d1 ahci raid0 ptp libahci pps_core multipath linear
[86961.217905] CPU: 2 PID: 6825 Comm: btrfs-endio-wri Tainted: GF       W  O 3.12.6-rogerb #1
[86961.217926] Hardware name: System manufacturer System Product Name/P8Z77-V PRO, BIOS 2003 05/10/2013
[86961.217954] task: ffff8800a2374710 ti: ffff88003fbb8000 task.ti: ffff88003fbb8000
[86961.217985] RIP: 0010:[<ffffffffa01268e8>]  [<ffffffffa01268e8>] btrfs_merge_bio_hook+0x78/0x80 [btrfs]
[86961.218031] RSP: 0000:ffff88003fbb9638  EFLAGS: 00010282
[86961.218044] RAX: 00000000ffffffea RBX: 0000000000001000 RCX: 0000000000000006
[86961.218070] RDX: 0000000000000007 RSI: 0000000021382136 RDI: 0000000000000246
[86961.218108] RBP: ffff88003fbb9650 R08: 0000000000000092 R09: 000000000000078f
[86961.218126] R10: 0000000000000000 R11: ffff88003fbb91e6 R12: 0000000000001000
[86961.218156] R13: ffff8801044e0ba8 R14: ffff8807f3580040 R15: 0000000019800008
[86961.218174] FS:  0000000000000000(0000) GS:ffff88081fa80000(0000) knlGS:0000000000000000
[86961.218193] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[86961.218208] CR2: 00007f5b389be000 CR3: 0000000001a30000 CR4: 00000000001407e0
[86961.218240] Stack:
[86961.218250]  0000000000001000 0000000000001000 ffff88003fbb9870 ffff88003fbb96a0
[86961.218283]  ffffffffa0141c67 0000002000000000 0000000000000000 ffffea0019b1d7c0
[86961.218306]  0000000019800008 0000000000000000 0000000000000000 0000000000001000
[86961.218333] Call Trace:
[86961.218356]  [<ffffffffa0141c67>] submit_extent_page.isra.35+0xb7/0x1e0 [btrfs]
[86961.218386]  [<ffffffffa0141fd5>] __do_readpage+0x245/0x760 [btrfs]
[86961.218408]  [<ffffffffa01436f0>] ? repair_eb_io_failure+0xb0/0xb0 [btrfs]
[86961.218432]  [<ffffffffa011c240>] ? free_root_pointers+0x190/0x190 [btrfs]
[86961.218457]  [<ffffffffa013d987>] ? btrfs_lookup_ordered_extent+0x27/0x1e0 [btrfs]
[86961.218482]  [<ffffffffa01425b5>] __extent_read_full_page+0xc5/0xe0 [btrfs]
[86961.218508]  [<ffffffffa011c240>] ? free_root_pointers+0x190/0x190 [btrfs]
[86961.218544]  [<ffffffffa011c240>] ? free_root_pointers+0x190/0x190 [btrfs]
[86961.218580]  [<ffffffffa0145ceb>] read_extent_buffer_pages+0x21b/0x300 [btrfs]
[86961.218603]  [<ffffffffa011c240>] ? free_root_pointers+0x190/0x190 [btrfs]
[86961.218625]  [<ffffffffa011d373>] btree_read_extent_buffer_pages.constprop.55+0xb3/0x120 [btrfs]
[86961.218651]  [<ffffffffa011fc16>] read_tree_block+0x46/0x80 [btrfs]
[86961.218671]  [<ffffffffa0101038>] read_block_for_search.isra.34+0x148/0x380 [btrfs]
[86961.218702]  [<ffffffff81061ccf>] ? warn_slowpath_common+0x8f/0xa0
[86961.218724]  [<ffffffffa01039f7>] btrfs_search_old_slot+0x2c7/0x900 [btrfs]
[86961.218747]  [<ffffffffa017d04c>] __resolve_indirect_refs+0x11c/0x5c0 [btrfs]
[86961.218771]  [<ffffffffa017de2a>] find_parent_nodes+0x5ca/0xe70 [btrfs]
[86961.218793]  [<ffffffffa01287f0>] ? btrfs_submit_bio_hook+0x1e0/0x1e0 [btrfs]
[86961.218816]  [<ffffffffa017f03f>] iterate_extent_inodes+0xdf/0x250 [btrfs]
[86961.218838]  [<ffffffffa01287f0>] ? btrfs_submit_bio_hook+0x1e0/0x1e0 [btrfs]
[86961.218861]  [<ffffffffa017f237>] iterate_inodes_from_logical+0x87/0xa0 [btrfs]
[86961.218883]  [<ffffffffa0126dab>] record_extent_backrefs+0x7b/0xf0 [btrfs]
[86961.218906]  [<ffffffffa013116f>] btrfs_finish_ordered_io+0x1ef/0xaf0 [btrfs]
[86961.218929]  [<ffffffffa0131cf5>] finish_ordered_fn+0x15/0x20 [btrfs]
[86961.218950]  [<ffffffffa0152cca>] worker_loop+0x15a/0x5c0 [btrfs]
[86961.218971]  [<ffffffffa0152b70>] ? btrfs_queue_worker+0x330/0x330 [btrfs]
[86961.218988]  [<ffffffff81085480>] kthread+0xc0/0xd0
[86961.219001]  [<ffffffff810853c0>] ? kthread_create_on_node+0x120/0x120
[86961.219018]  [<ffffffff816f3afc>] ret_from_fork+0x7c/0xb0
[86961.219033]  [<ffffffff810853c0>] ? kthread_create_on_node+0x120/0x120
[86961.219049] Code: c9 45 31 c0 89 fe 48 89 c7 4c 89 65 e8 e8 31 77 02 00 85 c0 78 15 4c 01 e3 31 c0 48 3b 5d e8 0f 97 c0 48 83 c4 08 5b 41 5c 5d c3 <0f> 0b 66 0f 1f 44 00 00 0f 1f 44 00 00 55 48 89 e5 41 57 49 89 
[86961.219169] RIP  [<ffffffffa01268e8>] btrfs_merge_bio_hook+0x78/0x80 [btrfs]
[86961.219193]  RSP <ffff88003fbb9638>

Roger
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.14 (GNU/Linux)

iEYEARECAAYFAlLGMfEACgkQmOOfHg372QRSNwCfakfGA/iGw9nLn6wzTv+1QDIJ
2o4An0mOr6swtm3BU02KzDThn7BeFiBv
=wNlu
-----END PGP SIGNATURE-----

