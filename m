Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-vb0-f46.google.com ([209.85.212.46]:46645 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755789Ab2IAXY1 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sat, 1 Sep 2012 19:24:27 -0400
Received: by vbbff1 with SMTP id ff1so4348311vbb.19
        for <linux-btrfs@vger.kernel.org>; Sat, 01 Sep 2012 16:24:26 -0700 (PDT)
MIME-Version: 1.0
Date: Sat, 1 Sep 2012 20:24:26 -0300
Message-ID: <CA+5DtPr2DhvcxM03c-Q48qGmTOqpBF6pM3g+P783VMmhgQfgOQ@mail.gmail.com>
Subject: bug report
From: Manoel Pedro <msa.usu@gmail.com>
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Sep  1 20:24:07 sa kernel: [ 8034.244618] ------------[ cut here ]------------
Sep  1 20:24:07 sa kernel: [ 8034.244638] WARNING: at
/home/abuild/rpmbuild/BUILD/kernel-desktop-3.5.3/linux-3.5/fs/btrfs/extent-tree.c:6221
use_block_rsv+0x15e/0x170 [btrfs]()
Sep  1 20:24:07 sa kernel: [ 8034.244640] Hardware name: Latitude 120L
Sep  1 20:24:07 sa kernel: [ 8034.244642] Modules linked in: loop
af_packet fuse arc4 cpufreq_conservative cpufreq_userspace
cpufreq_powersave b43 mac80211 cfg80211 rfkill bcma iTCO_wdt gpio_ich
iTCO_vendor_support sr_mod cdrom sg b44 dell_laptop usb_storage dcdbas
uas joydev ssb snd_hda_codec_idt mmc_core pcmcia pcmcia_core pcspkr
lpc_ich mfd_core snd_hda_intel snd_hda_codec snd_hwdep snd_pcm
snd_timer battery ac snd soundcore snd_page_alloc acpi_cpufreq mperf
microcode binfmt_misc pciehp pci_hotplug autofs4 i915 drm_kms_helper
drm i2c_algo_bit thermal button video processor thermal_sys
scsi_dh_rdac scsi_dh_hp_sw scsi_dh_emc scsi_dh_alua scsi_dh btrfs
zlib_deflate libcrc32c ata_generic ata_piix
Sep  1 20:24:07 sa kernel: [ 8034.244690] Pid: 314, comm:
btrfs-balance Tainted: G        W    3.5.3-40-desktop #1
Sep  1 20:24:07 sa kernel: [ 8034.244692] Call Trace:
Sep  1 20:24:07 sa kernel: [ 8034.244698]  [<c02055b3>]
try_stack_unwind+0x173/0x180
Sep  1 20:24:07 sa kernel: [ 8034.244704]  [<c02042c7>] dump_trace+0x47/0xf0
Sep  1 20:24:07 sa kernel: [ 8034.244709]  [<c020560b>]
show_trace_log_lvl+0x4b/0x60
Sep  1 20:24:07 sa kernel: [ 8034.244714]  [<c0205638>] show_trace+0x18/0x20
Sep  1 20:24:07 sa kernel: [ 8034.244720]  [<c070e144>] dump_stack+0x6d/0x72
Sep  1 20:24:07 sa kernel: [ 8034.244725]  [<c0234ea8>]
warn_slowpath_common+0x78/0xb0
Sep  1 20:24:07 sa kernel: [ 8034.244730]  [<c0234efb>]
warn_slowpath_null+0x1b/0x20
Sep  1 20:24:07 sa kernel: [ 8034.244750]  [<f7cd8a2e>]
use_block_rsv+0x15e/0x170 [btrfs]
Sep  1 20:24:07 sa kernel: [ 8034.244817]  [<f7cdc92c>]
btrfs_alloc_free_block+0x3c/0x2a0 [btrfs]
Sep  1 20:24:07 sa kernel: [ 8034.244888]  [<f7cc7ba8>]
__btrfs_cow_block+0x158/0x5c0 [btrfs]
Sep  1 20:24:07 sa kernel: [ 8034.244931]  [<f7cc80e9>]
btrfs_cow_block+0xd9/0x250 [btrfs]
Sep  1 20:24:07 sa kernel: [ 8034.244982]  [<f7d392e7>]
do_relocation+0x447/0x500 [btrfs]
Sep  1 20:24:07 sa kernel: [ 8034.251298]  [<f7d395bc>]
relocate_tree_block+0x21c/0x260 [btrfs]
Sep  1 20:24:07 sa kernel: [ 8034.251567]  [<f7d3da8d>]
relocate_tree_blocks+0x11d/0x180 [btrfs]
Sep  1 20:24:07 sa kernel: [ 8034.251841]  [<f7d3e89e>]
relocate_block_group+0x1fe/0x5a0 [btrfs]
Sep  1 20:24:07 sa kernel: [ 8034.252125]  [<f7d3edea>]
btrfs_relocate_block_group+0x1aa/0x300 [btrfs]
Sep  1 20:24:07 sa kernel: [ 8034.252397]  [<f7d19b35>]
btrfs_relocate_chunk.isra.51+0x55/0x410 [btrfs]
Sep  1 20:24:07 sa kernel: [ 8034.252613]  [<f7d1e6b2>]
btrfs_shrink_device+0x262/0x480 [btrfs]
Sep  1 20:24:07 sa kernel: [ 8034.252834]  [<f7d1e9a1>]
__btrfs_balance+0xd1/0x4a0 [btrfs]
Sep  1 20:24:07 sa kernel: [ 8034.257807]  [<f7d1f0f7>]
btrfs_balance+0x387/0x550 [btrfs]
Sep  1 20:24:07 sa kernel: [ 8034.259855]  [<f7d1f330>]
balance_kthread+0x70/0x80 [btrfs]
Sep  1 20:24:07 sa kernel: [ 8034.260082]  [<c02545fe>] kthread+0x6e/0x80
Sep  1 20:24:07 sa kernel: [ 8034.260092]  [<c072bf66>]
kernel_thread_helper+0x6/0xd
Sep  1 20:24:07 sa kernel: [ 8034.260098] ---[ end trace dc79c5cfcfeff6c9 ]---
