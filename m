Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from magic.merlins.org ([209.81.13.136]:54943 "EHLO
	mail1.merlins.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752853AbaDEPh2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sat, 5 Apr 2014 11:37:28 -0400
Received: from svh-gw.merlins.org ([173.11.111.145]:40512 helo=legolas.merlins.org)
	by mail1.merlins.org with esmtpsa
	(Cipher TLS1.2:DHE_RSA_AES_128_CBC_SHA1:128) (Exim 4.80 #2)
	id 1WWSem-00010M-UQ by authid <merlins.org> with srv_auth_plain
	for <linux-btrfs@vger.kernel.org>; Sat, 05 Apr 2014 08:37:28 -0700
Received: from merlin by legolas.merlins.org with local (Exim 4.80)
	(envelope-from <merlin@legolas.merlins.org>)
	id 1WWSen-0000Qa-Bu
	for linux-btrfs@vger.kernel.org; Sat, 05 Apr 2014 08:37:21 -0700
Date: Sat, 5 Apr 2014 08:37:21 -0700
From: Marc MERLIN <marc@merlins.org>
To: linux-btrfs@vger.kernel.org
Message-ID: <20140405153721.GC12124@merlins.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Subject: kernel BUG at fs/btrfs/extent_io.c:4324! (3.14-rc5)
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

static void btrfs_release_extent_buffer_page(struct extent_buffer *eb,
						unsigned long start_idx)
{
	unsigned long index;
	unsigned long num_pages;
	struct page *page;
	int mapped = !test_bit(EXTENT_BUFFER_DUMMY, &eb->bflags);

>>>	BUG_ON(extent_buffer_under_io(eb));

	num_pages = num_extent_pages(eb->start, eb->len);
	index = start_idx + num_pages;
	if (start_idx >= index)
		return;


------------[ cut here ]------------
kernel BUG at fs/btrfs/extent_io.c:4324!
invalid opcode: 0000 [#1] PREEMPT SMP
Modules linked in: udp_diag tcp_diag inet_diag ip6table_filter ip6_tables ebtable_nat ebtables tun ppdev lp autofs4 binfmt_misc kl5kusb105 ftdi_sio keyspan deflate ctr twofish_avx_x86_64 twofish_x86_64_3way twofish_x86_64 twofish_generic twofish_common camellia_x86_64 camellia_generic serpent_avx_x86_64 serpent_sse2_x86_64 glue_helper lrw serpent_generic blowfish_x86_64 blowfish_generic blowfish_common cast5_avx_x86_64 ablk_helper cast5_generic cast_common des_generic cmac xcbc rmd160 sha512_ssse3 sha512_generic crypto_null af_key xfrm_algo dm_mirror dm_region_hash dm_log nfsd nfs_acl auth_rpcgss nfs fscache lockd sunrpc ipt_REJECT xt_conntrack xt_nat xt_tcpudp xt_LOG iptable_mangle iptable_filter aes_x86_64 lm85 hwmon_vid dm_snapshot dm_bufio iptable_nat ip_tables nf_conntrack_ipv4 nf_defrag_ipv4 nf_nat_ipv4 nf_conntrack_ftp ipt_MASQUERADE nf_nat x_tables nf_conntrack sg st snd_pcm_oss snd_mixer_oss fuse microcode eeepc_wmi kvm_intel asus_wmi snd_hda_codec_realtek sparse_keymap kvm snd_cmipci snd_hda_codec_generic rfkill gameport tpm_infineon battery snd_hda_intel snd_opl3_lib snd_mpu401_uart snd_hda_codec snd_seq_midi asix snd_seq_midi_event snd_hwdep snd_seq snd_pcm snd_rawmidi rc_ati_x10 coretemp snd_timer libphy wmi snd_seq_device pl2303 pcspkr processor usbnet intel_rapl lpc_ich xhci_hcd ati_remote evdev snd i2c_i801 parport_pc tpm_tis parport rc_core intel_powerclamp tpm soundcore x86_pkg_temp_thermal ezusb usbserial xts gf128mul dm_crypt dm_mod raid456 async_raid6_recov async_pq async_xor async_memcpy async_tx e1000e ptp pps_core crc32_pclmul crc32c_intel crct10dif_pclmul ehci_pci ghash_clmulni_intel sata_sil24 ehci_hcd thermal r8169 cryptd fan mii sata_mv usbcore usb_common [last unloaded: kl5kusb105]
CPU: 3 PID: 25229 Comm: btrfs-endio-wri Not tainted 3.14.0-rc5-amd64-i915-preempt-20140216c #1
Hardware name: System manufacturer System Product Name/P8H67-M PRO, BIOS 3806 08/20/2012
task: ffff880043952150 ti: ffff880025714000 task.ti: ffff880025714000
RIP: 0010:[<ffffffff81240a2f>]  [<ffffffff81240a2f>] btrfs_release_extent_buffer_page.constprop.21+0x20/0xf0
RSP: 0018:ffff8800257158f0  EFLAGS: 00010202
RAX: 0000000000000001 RBX: 0000000000000005 RCX: 0000000000000000
RDX: 0000000000000000 RSI: 0000000000000002 RDI: ffff88013d16f2b0
RBP: ffff880025715910 R08: 000000000001e045 R09: 000000000001e045
R10: 0000160000000000 R11: 6db6db6db6db6db7 R12: ffff88013d16f2b0
R13: ffff880036dda000 R14: ffff8802120b0800 R15: ffff88019e943070
FS:  0000000000000000(0000) GS:ffff88021f380000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00000000e08a1ff0 CR3: 0000000001c0e000 CR4: 00000000000407e0
Stack:
 ffff88013d16f2b0 ffff880036ddb608 ffff880036dda000 ffff8802120b0800
 ffff880025715940 ffffffff81240b8a 0000000000000006 ffff88013d16f2b0
 ffff88013d16f3f0 ffff88013d16f2b0 ffff880025715958 ffffffff812452f7
Call Trace:
 [<ffffffff81240b8a>] release_extent_buffer+0x8b/0xb8
 [<ffffffff812452f7>] free_extent_buffer+0x8a/0x8d
 [<ffffffff8120ecb4>] __push_leaf_right+0x3a0/0x3c8
 [<ffffffff8120ee1f>] push_leaf_right+0x143/0x16b
 [<ffffffff8120f593>] split_leaf+0xc5/0x567
 [<ffffffff8120c189>] ? leaf_space_used+0xa9/0xd8
 [<ffffffff812578cf>] ? btrfs_set_lock_blocking_rw+0x95/0xdf
 [<ffffffff81210055>] btrfs_search_slot+0x620/0x6bb
 [<ffffffff81211330>] btrfs_insert_empty_items+0x5d/0xa8
 [<ffffffff8121ba41>] __btrfs_run_delayed_refs+0x6f1/0xbdf
 [<ffffffff8160ea0b>] ? _raw_spin_unlock+0x17/0x2a
 [<ffffffff812187bf>] ? reserve_metadata_bytes+0x1b2/0x723
 [<ffffffff8121dac8>] btrfs_run_delayed_refs+0x81/0x18f
 [<ffffffff81217d03>] ? btrfs_delayed_refs_qgroup_accounting+0xda/0xe8
 [<ffffffff8122bcc1>] __btrfs_end_transaction+0xe1/0x2c6
 [<ffffffff8122beb6>] btrfs_end_transaction+0x10/0x12
 [<ffffffff8123248f>] btrfs_finish_ordered_io+0x307/0x3bd
 [<ffffffff81232744>] finish_ordered_fn+0x15/0x17
 [<ffffffff8125073f>] worker_loop+0x168/0x4d8
 [<ffffffff812505d7>] ? btrfs_queue_worker+0x283/0x283
 [<ffffffff8106bc56>] kthread+0xae/0xb6
 [<ffffffff8106bba8>] ? __kthread_parkme+0x61/0x61
 [<ffffffff816153fc>] ret_from_fork+0x7c/0xb0
 [<ffffffff8106bba8>] ? __kthread_parkme+0x61/0x61
Code: 00 48 89 e5 e8 19 db eb ff 5d c3 66 66 66 66 90 55 48 89 e5 41 56 41 55 41 54 49 89 fc 53 48 8b 5f 20 e8 41 f6 ff ff 85 c0 74 02 <0f> 0b 49 8b 74 24 08 49 8b 3c 24 e8 f7 f4 ff ff 48 85 c0 49 89
RIP  [<ffffffff81240a2f>] btrfs_release_extent_buffer_page.constprop.21+0x20/0xf0
 RSP <ffff8800257158f0>
---[ end trace f634aceb09e737f6 ]---
Kernel panic - not syncing: Fatal exception


-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet cooking
Home page: http://marc.merlins.org/                         | PGP 1024R/763BE901
