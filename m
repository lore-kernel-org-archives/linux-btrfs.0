Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from magic.merlins.org ([209.81.13.136]:50427 "EHLO
        mail1.merlins.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934894AbdKPREy (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 16 Nov 2017 12:04:54 -0500
Date: Thu, 16 Nov 2017 09:04:45 -0800
From: Marc MERLIN <marc@merlins.org>
To: linux-btrfs@vger.kernel.org
Message-ID: <20171116170445.24n57phzltgiehj6@merlins.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Subject: kernel BUG at fs/btrfs/ctree.h:1802!
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

My server now reboots every 20mn or so, with this.
Sadly another BUG_ON() and it won't even tell me which filesystem
it's on

static inline u32 btrfs_extent_inline_ref_size(int type)
{
	if (type == BTRFS_TREE_BLOCK_REF_KEY ||
	    type == BTRFS_SHARED_BLOCK_REF_KEY)
		return sizeof(struct btrfs_extent_inline_ref);
	if (type == BTRFS_SHARED_DATA_REF_KEY)
		return sizeof(struct btrfs_shared_data_ref) +
		       sizeof(struct btrfs_extent_inline_ref);
	if (type == BTRFS_EXTENT_DATA_REF_KEY)
		return sizeof(struct btrfs_extent_data_ref) +
		       offsetof(struct btrfs_extent_inline_ref, offset);
	BUG();
	return 0;
}



[ 1399.728735] ------------[ cut here ]------------
[ 1399.744149] kernel BUG at fs/btrfs/ctree.h:1802!
[ 1399.759400] invalid opcode: 0000 [#1] PREEMPT SMP
[ 1399.774892] Modules linked in: veth ip6table_filter ip6_tables ebtable_nat ebtables ppdev lp xt_addrtype br_netfilter bridge stp llc tun autofs4 softdog binfmt_misc ftdi_sio nfsd auth_rpcgss nfs_acl nfs lockd grace fscache sunrpc ipt_REJECT nf_reject_ipv4 xt_conntrack xt_mark xt_nat xt_tcpudp nf_log_ipv4 nf_log_common xt_LOG iptable_mangle iptable_filter lm85 hwmon_vid pl2303 dm_snapshot dm_bufio iptable_nat ip_tables nf_conntrack_ipv4 nf_defrag_ipv4 nf_nat_ipv4 nf_conntrack_ftp ipt_MASQUERADE nf_nat_masquerade_ipv4 nf_nat nf_conntrack x_tables sg st snd_pcm_oss snd_mixer_oss bcache kvm_intel kvm irqbypass snd_hda_codec_realtek snd_hda_codec_generic snd_hda_intel snd_cmipci snd_hda_codec snd_mpu401_uart eeepc_wmi snd_opl3_lib snd_hda_core snd_rawmidi asus_wmi sparse_keymap snd_seq_device asix snd_hwdep
[ 1399.997524]  rc_ati_x10 tpm_infineon snd_pcm rfkill snd_timer ati_remote usbnet tpm_tis usbserial libphy i915 rc_core hwmon tpm_tis_core snd wmi_bmof mei_me lpc_ich i2c_i801 soundcore battery pcspkr evdev input_leds tpm wmi parport_pc parport e1000e ptp pps_core fuse raid456 multipath mmc_block mmc_core lrw ablk_helper dm_crypt dm_mod async_raid6_recov async_pq async_xor async_memcpy async_tx crc32c_intel blowfish_x86_64 blowfish_common pcbc aesni_intel aes_x86_64 crypto_simd glue_helper cryptd xhci_pci ehci_pci mvsas ehci_hcd xhci_hcd libsas r8169 scsi_transport_sas mii usbcore sata_sil24 thermal fan [last unloaded: ftdi_sio]
[ 1400.174918] CPU: 0 PID: 80 Comm: kworker/u16:1 Tainted: G     U  W       4.13.12-amd64-stkreg-sysrq-20171018 #2
[ 1400.206640] Hardware name: System manufacturer System Product Name/P8H67-M PRO, BIOS 3904 04/27/2013
[ 1400.235418] Workqueue: btrfs-extent-refs btrfs_extent_refs_helper
[ 1400.255104] task: ffff8a94fa750180 task.stack: ffffb632c3404000
[ 1400.274346] RIP: 0010:btrfs_extent_inline_ref_size+0x29/0x39
[ 1400.292749] RSP: 0018:ffffb632c3407b28 EFLAGS: 00210297
[ 1400.309756] RAX: 000000000000001d RBX: ffff8a94f59f4a80 RCX: ffff8a9127287000
[ 1400.332482] RDX: 0000000000002000 RSI: 0000000000002598 RDI: 0000000000000000
[ 1400.355188] RBP: ffffb632c3407b28 R08: ffffb632c3407ae8 R09: ffffb632c3407af0
[ 1400.377871] R10: 0000000000000000 R11: 0000000000002000 R12: 0000000000000000
[ 1400.400537] R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000002598
[ 1400.423912] FS:  0000000000000000(0000) GS:ffff8a951e200000(0000) knlGS:0000000000000000
[ 1400.449416] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[ 1400.467878] CR2: 000000000be9c3f8 CR3: 00000004b5c09000 CR4: 00000000001406f0
[ 1400.490491] Call Trace:
[ 1400.499066]  lookup_inline_extent_backref+0x2ff/0x411
[ 1400.515452]  ? ___cache_free+0x200/0x25c
[ 1400.528390]  __btrfs_free_extent+0xeb/0xa5d
[ 1400.542077]  ? ___cache_free+0x1e8/0x25c
[ 1400.554950]  __btrfs_run_delayed_refs+0xb6c/0xd52
[ 1400.570208]  ? _raw_spin_unlock_irqrestore+0x14/0x24
[ 1400.586191]  ? try_to_wake_up+0x251/0x277
[ 1400.599288]  btrfs_run_delayed_refs+0x77/0x1a1
[ 1400.613653]  delayed_ref_async_start+0x5e/0x9b
[ 1400.628580]  btrfs_scrubparity_helper+0x111/0x271
[ 1400.644271]  ? pwq_activate_delayed_work+0x4d/0x5b
[ 1400.659614]  btrfs_extent_refs_helper+0xe/0x10
[ 1400.673972]  process_one_work+0x179/0x2a5
[ 1400.686951]  worker_thread+0x1b1/0x262
[ 1400.699155]  ? rescuer_thread+0x273/0x273
[ 1400.712069]  kthread+0xfb/0x100
[ 1400.722354]  ? init_completion+0x24/0x24
[ 1400.734949]  ret_from_fork+0x25/0x30
[ 1400.746497] Code: 5d c3 55 81 ff b0 00 00 00 48 89 e5 74 1f 81 ff b6 00 00 00 74 17 81 ff b8 00 00 00 74 16 81 ff b2 00 00 00 b8 1d 00 00 00 74 0e <0f> 0b b8 09 00 00 00 eb 05 b8 0d 00 00 00 5d c3 55 48 89 f0 48
[ 1400.804753] RIP: btrfs_extent_inline_ref_size+0x29/0x39 RSP: ffffb632c3407b28
[ 1400.827109] ---[ end trace 70850509bfd007d7 ]---
[ 1400.841833] Kernel panic - not syncing: Fatal exception
[ 1400.858356] Kernel Offset: 0x17000000 from 0xffffffff81000000 (relocation range: 0xffffffff80000000-0xffffffffbfffffff)


-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet cooking
Home page: http://marc.merlins.org/                         | PGP 1024R/763BE901
