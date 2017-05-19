Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from magic.merlins.org ([209.81.13.136]:36007 "EHLO
        mail1.merlins.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750703AbdESEQp (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 19 May 2017 00:16:45 -0400
Date: Thu, 18 May 2017 21:16:38 -0700
From: Marc MERLIN <marc@merlins.org>
To: linux-btrfs@vger.kernel.org
Message-ID: <20170519041638.sf7sensley4lpxiz@merlins.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Subject: 4.11.0: kernel BUG at fs/btrfs/ctree.h:1779!
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Looks like all the unhelpful BUG() aren't gone yet :-/
This one is really not helpful, I don't even know which one of my filesystems caused the crash :(

Why is this not remounting the filesystem read only?
Really, from a user and admin perspective, this is really not helpful.

Could someone who know more than me do a pass and eradicate those? 
Btrfs cannot be a production filesystem as long as those are still around IMO.

Thanks,
Marc

------------[ cut here ]------------
kernel BUG at fs/btrfs/ctree.h:1779!
invalid opcode: 0000 [#1] PREEMPT SMP
Modules linked in: veth ip6table_filter ip6_tables ebtable_nat ebtables ppdev lp xt_addrtype br_netfilter bridge stp llc tun autofs4 softdog binfmt_misc ftdi_sio nfsd auth_rpcgss nfs_acl nfs lockd grace fscache sunrpc ipt_REJECT nf_reject_ipv4 xt_conntrack xt_mark xt_nat xt_tcpudp nf_log_ipv4 nf_log_common xt_LOG iptable_mangle iptable_filter lm85 hwmon_vid pl2303 dm_snapshot dm_bufio iptable_nat ip_tables nf_conntrack_ipv4 nf_defrag_ipv4 nf_nat_ipv4 nf_conntrack_ftp ipt_MASQUERADE nf_nat_masquerade_ipv4 nf_nat nf_conntrack x_tables sg st snd_pcm_oss snd_mixer_oss bcache kvm_intel kvm irqbypass snd_hda_codec_realtek snd_hda_codec_generic snd_cmipci snd_hda_intel snd_mpu401_uart snd_hda_codec snd_opl3_lib snd_hda_core snd_rawmidi eeepc_wmi snd_hwdep snd_seq_device asus_wmi snd_pcm sparse_keymap
 rfkill snd_timer hwmon snd i915 lpc_ich tpm_infineon rc_ati_x10 asix mei_me usbnet ati_remote pcspkr libphy tpm_tis rc_core usbserial tpm_tis_core wmi tpm parport_pc parport input_leds battery i2c_i801 soundcore evdev e1000e ptp pps_core fuse raid456 multipath mmc_block mmc_core lrw ablk_helper dm_crypt dm_mod async_raid6_recov async_pq async_xor async_memcpy async_tx crc32c_intel blowfish_x86_64 blowfish_common pcbc aesni_intel aes_x86_64 crypto_simd glue_helper cryptd xhci_pci ehci_pci xhci_hcd ehci_hcd mvsas r8169 sata_sil24 mii libsas usbcore scsi_transport_sas thermal fan [last unloaded: ftdi_sio]
CPU: 2 PID: 22204 Comm: kworker/u16:20 Tainted: G     U          4.11.0-amd64-preempt-sysrq-20170406 #2
Hardware name: System manufacturer System Product Name/P8H67-M PRO, BIOS 3904 04/27/2013
Workqueue: btrfs-extent-refs btrfs_extent_refs_helper
task: ffff9417d6de2240 task.stack: ffffa1314e7e0000
RIP: 0010:btrfs_extent_inline_ref_size+0x29/0x39
RSP: 0018:ffffa1314e7e3b10 EFLAGS: 00010297
RAX: 000000000000001d RBX: ffff941849fd3700 RCX: ffff941aaa669000
RDX: 0000000000002000 RSI: 000000000000245a RDI: 0000000000000000
RBP: ffffa1314e7e3b10 R08: 0000000000004000 R09: ffffa1314e7e3ad8
R10: 0000000000000000 R11: 0000000000002000 R12: 000000000000245a
R13: 0000000000000000 R14: ffff94183c20b5b8 R15: 0000000000000000
FS:  0000000000000000(0000) GS:ffff941d9e280000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00000000f7557d76 CR3: 00000003f8c09000 CR4: 00000000001406e0
Call Trace:
 lookup_inline_extent_backref+0x302/0x436
 ? ___cache_free+0x200/0x25c
 __btrfs_free_extent+0xf1/0xb18
 __btrfs_run_delayed_refs+0xb2f/0xd15
 ? __wake_up_common+0x4d/0x81
 btrfs_run_delayed_refs+0x7a/0x1cc
 delayed_ref_async_start+0x5e/0x9b
 btrfs_scrubparity_helper+0x111/0x271
 ? pwq_activate_delayed_work+0x4d/0x5b
 btrfs_extent_refs_helper+0xe/0x10
 process_one_work+0x193/0x2b0
 ? rescuer_thread+0x2b1/0x2b1
 worker_thread+0x1e9/0x2c1
 ? rescuer_thread+0x2b1/0x2b1
 kthread+0xfb/0x100
 ? init_completion+0x24/0x24
 ? do_fast_syscall_32+0xb7/0xfe
 ret_from_fork+0x2c/0x40
Code: 5d c3 55 81 ff b0 00 00 00 48 89 e5 74 1f 81 ff b6 00 00 00 74 17 81 ff b8 00 00 00 74 16 81 ff b2 00 00 00 b8 1d 00 00 00 74 0e <0f> 0b b8 09 00 00 00 eb 05 b8 0d 00 00 00 5d c3 55 48 89 f0 48
RIP: btrfs_extent_inline_ref_size+0x29/0x39 RSP: ffffa1314e7e3b10
---[ end trace 8bd2bf161055b042 ]---

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
	BUG();   <<<<<<<<<<<<<<<<<
	return 0;
}

-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet cooking
Home page: http://marc.merlins.org/                         | PGP 1024R/763BE901
