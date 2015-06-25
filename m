Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from magic.merlins.org ([209.81.13.136]:33006 "EHLO
	mail1.merlins.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752903AbbFYBjE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 24 Jun 2015 21:39:04 -0400
Received: from merlin by mail1.merlins.org with local (Exim 4.80 #2)
	id 1Z7w7m-0001lT-7z by authid <merlin>
	for <linux-btrfs@vger.kernel.org>; Wed, 24 Jun 2015 18:38:42 -0700
Date: Wed, 24 Jun 2015 18:38:42 -0700
From: Marc MERLIN <marc@merlins.org>
To: linux-btrfs@vger.kernel.org
Subject: 3.19.8: kernel BUG at fs/btrfs/extent_io.c:4548!
Message-ID: <20150625013842.GK20517@merlins.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Known already fixed problem, or not?

[680279.909435] kernel BUG at fs/btrfs/extent_io.c:4548!
[680279.926208] invalid opcode: 0000 [#1] SMP
[680279.940494] Modules linked in: udp_diag tcp_diag inet_diag loop veth ip6table_filter ip6_tables ebtable_nat ebtables ppdev lp xt_addrtype bridge stp llc tun autofs4 softdog binfmt_misc ftdi_sio nfsd nfs_acl auth_rpcgss nfs fscache lockd grace sunrpc ipt_REJECT nf_reject_ipv4 xt_conntrack xt_mark xt_nat xt_tcpudp nf_log_ipv4 nf_log_common xt_LOG iptable_mangle iptable_filter lm85 hwmon_vid pl2303 iptable_nat nf_conntrack_ipv4 nf_defrag_ipv4 nf_nat_ipv4 ip_tables nf_conntrack_ftp ipt_MASQUERADE x_tables nf_nat_masquerade_ipv4 nf_nat nf_conntrack sg st snd_pcm_oss snd_mixer_oss microcode snd_opl3_synth snd_hda_codec_realtek snd_seq_midi_emul snd_hda_codec_generic kvm_intel kvm snd_cmipci snd_hda_intel eeepc_wmi gameport snd_opl3_lib snd_mpu401_uart asus_wmi snd_hda_controller snd_seq_midi snd_hda_codec sparse_keymap coretemp snd_seq_midi_event tpm_infineon snd_seq rfkill snd_hwdep intel_rapl asix tpm_tis xhci_pci pcspkr libphy snd_pcm iosf_mbi rc_ati_x10 snd_rawmidi 8250_fintek processor tpm battery snd_timer parport_pc wmi snd_seq_device xhci_hcd intel_powerclamp snd usbserial usbnet i2c_i801 ati_remote evdev parport x86_pkg_temp_thermal rc_core lpc_ich soundcore e1000e ptp pps_core fuse raid456 multipath mmc_block mmc_core dm_snapshot dm_bufio dm_mirror dm_region_hash dm_log dm_crypt dm_mod async_raid6_recov async_pq async_xor async_memcpy async_tx blowfish_x86_64 blowfish_common ecb xts sata_sil24 aesni_intel ablk_helper lrw gf128mul glue_helper aes_x86_64 crc32_pclmul crc32c_intel crct10dif_pclmul ghash_clmulni_intel cryptd thermal ehci_pci ehci_hcd r8169 fan usbcore mii sata_mv usb_common [last unloaded: ftdi_sio]
[680280.398916] CPU: 4 PID: 29414 Comm: kworker/u16:12 Not tainted 3.19.8-amd64-i915-volpreempt-s20150421rc3 #1
[680280.429947] Hardware name: System manufacturer System Product Name/P8H67-M PRO, BIOS 3904 04/27/2013
[680280.459290] Workqueue: btrfs-extent-refs btrfs_extent_refs_helper
[680280.479538] task: ffff880002b62410 ti: ffff880010120000 task.ti: ffff880010120000
[680280.503793] RIP: 0010:[<ffffffff8125d60f>]  [<ffffffff8125d60f>] btrfs_release_extent_buffer_page+0x20/0xec
[680280.534904] RSP: 0018:ffff880010123aa8  EFLAGS: 00010202
[680280.552765] RAX: 0000000000000001 RBX: 0000000000000005 RCX: 00000000fffffffa
[680280.576109] RDX: 0000000000000000 RSI: ffff88018195e008 RDI: ffff880140d06c58
[680280.599311] RBP: ffff880010123ac8 R08: ffff88018195e008 R09: ffff880010123a80
[680280.622483] R10: 0000000000000034 R11: 000000000000007a R12: ffff880140d06c58
[680280.645692] R13: ffff8800c73215c0 R14: ffff8802120ad000 R15: ffff880155859bc8
[680280.668935] FS:  0000000000000000(0000) GS:ffff88021e300000(0000) knlGS:0000000000000000
[680280.695018] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[680280.714188] CR2: 00000000fff93f7c CR3: 0000000001c12000 CR4: 00000000001407e0
[680280.737352] Stack:
[680280.745157]  ffff880140d06c58 ffff8800c87c6000 ffff8800c73215c0 ffff8802120ad000
[680280.769317]  ffff880010123ae8 ffffffff8125d764 ffff880140d06c58 ffff8800c73215c0
[680280.793356]  ffff880010123b08 ffffffff8125db17 00000000001a0e5b 0000000000000000
[680280.817345] Call Trace:
[680280.826355]  [<ffffffff8125d764>] release_extent_buffer+0x89/0xaa
[680280.846250]  [<ffffffff8125db17>] free_extent_buffer+0x8b/0x8f
[680280.865417]  [<ffffffff812223b6>] btrfs_release_path+0x4b/0x6a
[680280.884530]  [<ffffffff8122ce57>] __btrfs_free_extent+0x70b/0x81a
[680280.904389]  [<ffffffff81232475>] __btrfs_run_delayed_refs+0xaee/0xc22
[680280.925469]  [<ffffffff8167d69d>] ? _raw_spin_unlock_irqrestore+0x15/0x17
[680280.947354]  [<ffffffff81234237>] btrfs_run_delayed_refs+0x6d/0x19e
[680280.967677]  [<ffffffff812343a4>] delayed_ref_async_start+0x3c/0x7b
[680280.988035]  [<ffffffff81268d49>] normal_work_helper+0xe7/0x21e
[680281.007241]  [<ffffffff81068075>] ? pwq_activate_delayed_work+0x31/0x3f
[680281.028511]  [<ffffffff81269034>] btrfs_extent_refs_helper+0x12/0x14
[680281.049031]  [<ffffffff81068aab>] process_one_work+0x17e/0x2a7
[680281.067993]  [<ffffffff81068dcc>] worker_thread+0x1c9/0x2a0
[680281.086116]  [<ffffffff81068c03>] ? process_scheduled_works+0x2f/0x2f1G
[680281.106835]  [<ffffffff8106d2f1>] kthread+0xae/0xb6
[680281.122867]  [<ffffffff8106d243>] ? __kthread_parkme+0x61/0x61
[680281.141732]  [<ffffffff8167db58>] ret_from_fork+0x58/0x90
[680281.159332]  [<ffffffff8106d243>] ? __kthread_parkme+0x61/0x61
[680281.178152] Code: 47 10 48 c1 e8 02 83 e0 01 5d c3 0f 1f 44 00 00 55 48 89 e5 41 56 41 55 41 54 49 89 fc 53 48 8b 5f 10 e8 b9 ff ff ff 85 c0 74 02 <0f> 0b 49 8b 74 24 08 49 8b 3c 24 e8 e6 aa ff ff 48 85 c0 49 89
[680281.240385] RIP  [<ffffffff8125d60f>] btrfs_release_extent_buffer_page+0x20/0xec
[680281.263941]  RSP <ffff880010123aa8>
[680281.275779] ---[ end trace 7fcf888a3dfb45bf ]---
[680281.290929] Kernel panic - not syncing: Fatal exception


static void btrfs_release_extent_buffer_page(struct extent_buffer *eb)
{
	unsigned long index;
	struct page *page;
	int mapped = !test_bit(EXTENT_BUFFER_DUMMY, &eb->bflags);

>>>	BUG_ON(extent_buffer_under_io(eb));

	index = num_extent_pages(eb->start, eb->len);
	if (index == 0)
		return;


-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet cooking
Home page: http://marc.merlins.org/  
