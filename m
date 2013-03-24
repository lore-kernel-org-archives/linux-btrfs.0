Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mailbackend.panix.com ([166.84.1.89]:64972 "EHLO
	mailbackend.panix.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753387Ab3CXMMV (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 24 Mar 2013 08:12:21 -0400
Received: from panix2.panix.com (panix2.panix.com [166.84.1.2])
	by mailbackend.panix.com (Postfix) with ESMTP id 9447234165
	for <linux-btrfs@vger.kernel.org>; Sun, 24 Mar 2013 08:12:20 -0400 (EDT)
To: linux-btrfs@vger.kernel.org
Subject: btrfs: block rsv returned -28 stack trace
From: Brian Downing <bsd@panix.com>
Date: 24 Mar 2013 08:12:20 -0400
Message-ID: <yratxo1j8t7.fsf@panix2.panix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

 I don't know where I'm supposed to send this, so I'm taking a wild
ass guess and sending it to this list.
Please fwd if necessary
THX

# uname -a
Linux hostname 3.8.4-1-ARCH #1 SMP PREEMPT Wed Mar 20 22:10:25 CET
2013 x86_64 GNU/Linux

# btrfs --version
Btrfs v0.20-rc1

btrfs filesystem was created on logical volume on an SSD

[83350.020435] ------------[ cut here ]------------
[83350.020467] WARNING: at fs/btrfs/extent-tree.c:6337 btrfs_alloc_free_block+0x35a/0x370 [btrfs]()
[83350.020469] Hardware name: To be filled by O.E.M.
[83350.020471] btrfs: block rsv returned -28
[83350.020472] Modules linked in: xfs nfsv4 auth_rpcgss fuse joydev hid_logitech ff_memless usbhid hid uvcvideo snd_usb_audio snd_usbmidi_lib videobuf2_vmalloc videobuf2_memops videobuf2_core
snd_rawmidi videodev snd_seq_device media nls_cp437 vfat fat eeepc_wmi asus_wmi sparse_keymap rfkill video pci_hotplug usb_storage mxm_wmi evdev acpi_cpufreq mperf kvm_amd kvm cdc_acm microcode
psmouse serio_raw pcspkr r8169 edac_core snd_hda_codec_hdmi edac_mce_amd mii k10temp i2c_piix4 snd_hda_codec_realtek snd_hda_intel snd_hda_codec snd_hwdep snd_pcm snd_page_alloc snd_timer snd
soundcore wmi button processor nfs lockd sunrpc fscache dm_mod btrfs crc32c libcrc32c zlib_deflate sr_mod cdrom sd_mod firewire_ohci ahci libahci firewire_core crc_itu_t libata ohci_hcd ehci_pci
ehci_hcd usbcore usb_common scsi_mod
[83350.020511]  radeon i2c_algo_bit drm_kms_helper ttm drm i2c_core
[83350.020517] Pid: 11267, comm: mv Not tainted 3.8.4-1-ARCH #1
[83350.020519] Call Trace:
[83350.020525]  [<ffffffff8105750f>] warn_slowpath_common+0x7f/0xc0
[83350.020528]  [<ffffffff81057606>] warn_slowpath_fmt+0x46/0x50
[83350.020541]  [<ffffffffa040acda>] btrfs_alloc_free_block+0x35a/0x370 [btrfs]
[83350.020553]  [<ffffffffa0413c80>] ? verify_parent_transid+0x170/0x170 [btrfs]
[83350.020588]  [<ffffffffa043b7c3>] ? read_extent_buffer+0xc3/0x120 [btrfs]
[83350.020599]  [<ffffffffa03f6e08>] __btrfs_cow_block+0x128/0x510 [btrfs]
[83350.020614]  [<ffffffffa03f7394>] btrfs_cow_block+0x124/0x200 [btrfs]
[83350.020624]  [<ffffffffa03fb59f>] btrfs_search_slot+0x1af/0x780 [btrfs]
[83350.020629]  [<ffffffff810e67bd>] ? call_rcu+0x1d/0x20
[83350.020641]  [<ffffffffa041146f>] btrfs_del_csums+0x12f/0x310 [btrfs]
[83350.020651]  [<ffffffffa040467c>] __btrfs_free_extent+0x5fc/0x880 [btrfs]
[83350.020663]  [<ffffffffa0408528>] run_clustered_refs+0x318/0xb40 [btrfs]
[83350.020674]  [<ffffffffa045db83>] ? find_ref_head+0x83/0xf0 [btrfs]
[83350.020686]  [<ffffffffa040c748>] btrfs_run_delayed_refs+0xc8/0x2f0 [btrfs]
[83350.020698]  [<ffffffffa041cf5e>] __btrfs_end_transaction+0xee/0x3f0 [btrfs]
[83350.020710]  [<ffffffffa041d2b0>] btrfs_end_transaction+0x10/0x20 [btrfs]
[83350.020722]  [<ffffffffa0427c46>] btrfs_evict_inode+0x266/0x380 [btrfs]
[83350.020728]  [<ffffffff811a6f88>] evict+0xb8/0x1b0
[83350.020730]  [<ffffffff811a7755>] iput+0x105/0x1a0
[83350.020734]  [<ffffffff8119a91e>] do_unlinkat+0x1de/0x240
[83350.020738]  [<ffffffff81191f6a>] ? sys_newfstatat+0x2a/0x40
[83350.020740]  [<ffffffff8119ceab>] sys_unlinkat+0x1b/0x40
[83350.020744]  [<ffffffff814da81d>] system_call_fastpath+0x1a/0x1f
[83350.020746] ---[ end trace 7f778ab5fc0a3f11 ]---
[83350.020779] ------------[ cut here ]------------

