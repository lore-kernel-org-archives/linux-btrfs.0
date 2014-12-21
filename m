Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from meiko.romanrm.net ([195.154.114.20]:59255 "EHLO
	meiko.romanrm.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752448AbaLUBEX (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 20 Dec 2014 20:04:23 -0500
Received: from natsu (unknown [IPv6:fd39::a60:6eff:fef3:b5b3])
	by meiko.romanrm.net (Postfix) with SMTP id E715619EA9
	for <linux-btrfs@vger.kernel.org>; Sun, 21 Dec 2014 00:57:16 +0000 (UTC)
Date: Sun, 21 Dec 2014 05:56:38 +0500
From: Roman Mamedov <rm@romanrm.net>
To: linux-btrfs@vger.kernel.org
Subject: WARNING btrfs_assert_delayed_root_empty
Message-ID: <20141221055638.6a113348@natsu>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello,

Using kernel 3.14.25;

I was doing multiple snapshot deletions and at the same time deletion of
multiple trees in remaining snapshots, in parallel (3 'rm -rf' running in
background). All of this lead to "soft lock-up" of one CPU, with warnings every
22-23 seconds and no activity on disks. Sadly I didn't manage to save those,
my running programs locked up one by one, and I had to hard-reset the machine.

Now I have these (below) repeating every 30 seconds or so. What's the problem
and how to fix it, will btrfsck help here?

[ 6950.651788] ------------[ cut here ]------------
[ 6950.651815] WARNING: CPU: 3 PID: 2179 at fs/btrfs/delayed-inode.c:1407 btrfs_assert_delayed_root_empty+0x2f/0x40 [btrfs]()
[ 6950.651816] Modules linked in: tun cpufreq_stats cpufreq_userspace cpufreq_powersave cpufreq_conservative fuse 8021q garp mrp bridge stp llc tcp_illinois loop it87 hwmon_vid ecryptfs kvm_amd uvcvideo kvm eeepc_wmi videobuf2_vmalloc snd_usb_audio asus_wmi snd_hda_codec_realtek videobuf2_memops crct10dif_pclmul crc32_pclmul crc32c_intel videobuf2_core snd_hda_codec_generic snd_usbmidi_lib ghash_clmulni_intel sparse_keymap snd_hda_intel videodev aesni_intel snd_pcsp cp210x rfkill snd_rawmidi snd_hda_codec aes_x86_64 media video lrw usbserial edac_mce_amd acpi_cpufreq sp5100_tco tpm_infineon snd_seq_device snd_hwdep gf128mul k10temp snd_pcm_oss mxm_wmi snd_mixer_oss glue_helper fam15h_power psmouse i2c_piix4 i2c_core serio_raw joydev evdev edac_core tpm_tis snd_pcm ablk_helper wmi processor tpm snd_timer cryptd snd thermal_sys button soundcore ext4 crc16 mbcache jbd2 crc32c btrfs dm_mod raid1 raid456 async_raid6_recov async_memcpy async_pq async_xor async_tx xor raid6_pq md_mod nbd sa
 ta_nv hid_generic usbhid hid sg sd_mod crc_t10dif crct10dif_common ahci libahci sata_mv ohci_pci libata ehci_pci ohci_hcd ehci_hcd xhci_hcd r8169 scsi_mod mii usbcore usb_common
[ 6950.651853] CPU: 3 PID: 2179 Comm: btrfs-transacti Tainted: G        W    3.14.25-rm1+ #79
[ 6950.651855] Hardware name: To be filled by O.E.M. To be filled by O.E.M./M5A97 LE R2.0, BIOS 2501 04/09/2014
[ 6950.651856]  0000000000000009 ffff88040216fd88 ffffffff814e74e5 0000000000000007
[ 6950.651859]  0000000000000000 ffff88040216fdc8 ffffffff81062777 ffff880408c55000
[ 6950.651861]  ffff880051a25380 0000000000000000 ffff880408c55000 ffff88008d5bb220
[ 6950.651863] Call Trace:
[ 6950.651868]  [<ffffffff814e74e5>] dump_stack+0x46/0x58
[ 6950.651871]  [<ffffffff81062777>] warn_slowpath_common+0x87/0xb0
[ 6950.651872]  [<ffffffff810627b5>] warn_slowpath_null+0x15/0x20
[ 6950.651884]  [<ffffffffa02a7d5f>] btrfs_assert_delayed_root_empty+0x2f/0x40 [btrfs]
[ 6950.651894]  [<ffffffffa02569ef>] btrfs_commit_transaction+0x39f/0x920 [btrfs]
[ 6950.651896]  [<ffffffff8106d8a0>] ? call_timer_fn+0xf0/0xf0
[ 6950.651907]  [<ffffffffa0254985>] transaction_kthread+0x1c5/0x240 [btrfs]
[ 6950.651917]  [<ffffffffa02547c0>] ? open_ctree+0x1f60/0x1f60 [btrfs]
[ 6950.651919]  [<ffffffff81084044>] kthread+0xc4/0xe0
[ 6950.651921]  [<ffffffff81010000>] ? ftrace_raw_event_xen_cpu_write_ldt_entry+0x10/0x170
[ 6950.651923]  [<ffffffff81083f80>] ? flush_kthread_worker+0x70/0x70
[ 6950.651925]  [<ffffffff814f568c>] ret_from_fork+0x7c/0xb0
[ 6950.651927]  [<ffffffff81083f80>] ? flush_kthread_worker+0x70/0x70
[ 6950.651928] ---[ end trace facf5add31ff6951 ]---

-- 
With respect,
Roman
