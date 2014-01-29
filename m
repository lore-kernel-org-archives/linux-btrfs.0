Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wg0-f45.google.com ([74.125.82.45]:57932 "EHLO
	mail-wg0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751862AbaA2JRo (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 29 Jan 2014 04:17:44 -0500
Received: by mail-wg0-f45.google.com with SMTP id n12so2961896wgh.24
        for <linux-btrfs@vger.kernel.org>; Wed, 29 Jan 2014 01:17:40 -0800 (PST)
Received: from [192.168.0.29] (ppp-2-85-89-247.home.otenet.gr. [2.85.89.247])
        by mx.google.com with ESMTPSA id q15sm3412502wjw.18.2014.01.29.01.17.38
        for <linux-btrfs@vger.kernel.org>
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 29 Jan 2014 01:17:39 -0800 (PST)
Message-ID: <52E8C72F.4090106@gmail.com>
Date: Wed, 29 Jan 2014 11:17:35 +0200
From: Konstantinos Skarlatos <k.skarlatos@gmail.com>
MIME-Version: 1.0
To: linux-btrfs@vger.kernel.org
Subject: help with btrfs device delete of a disk with errors (resent from
 subscribed mail)
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I am trying to delete a device  (device 5, /dev/sdg) that has some read 
errors from a multi device file system :

Label: none  uuid: f379d9aa-ddfd-4b4e-84c1-cd93d4592862
         Total devices 6 FS bytes used 7.11TiB
         devid    1 size 1.82TiB used 1.21TiB path /dev/sda
         devid    2 size 1.82TiB used 1.23TiB path /dev/sdb
         devid    3 size 1.82TiB used 1.23TiB path /dev/sdc
         devid    4 size 1.82TiB used 1.23TiB path /dev/sdd
         devid    5 size 0.00 used 1.12TiB path /dev/sdg
         devid    6 size 1.82TiB used 1.23TiB path /dev/sdh

$ btrfs fi df /storage/btrfs2
Data, RAID0: total=7.07TiB, used=7.07TiB
Data, single: total=8.00MiB, used=7.94MiB
System, RAID1: total=8.00MiB, used=416.00KiB
System, single: total=4.00MiB, used=0.00
Metadata, RAID1: total=81.00GiB, used=35.02GiB
Metadata, single: total=8.00MiB, used=0.00

btrfs: bdev /dev/sdg errs: wr 0, rd 510, flush 0, corrupt 0, gen 0

Device delete works fine until it gets to a block group that has a read 
error, then it crashes and remounts the filesystem as readonly.
I have found via btrfs inspect-internal logical-resolve the file that 
corresponds to that block group, and deleted it.
After that, btrfs inspect-internal logical-resolve returns:

ioctl ret=-1, error: No such file or directory

When i retry the device delete operation it still tries to relocate that 
same block group and crashes... Is there something else i can do to skip 
that block group and continue the device delete?

my kernel is linux-3.13.0-rc6-git




[2279324.794890] btrfs: found 55688 extents
[2279325.525990] btrfs: relocating block group 7349792145408 flags 9
[2279360.657953] btrfs: found 64189 extents
[2279367.861713] ------------[ cut here ]------------
[2279367.861753] WARNING: CPU: 1 PID: 29088 at 
fs/btrfs/extent-tree.c:1597 lookup_inline_extent_backref+0x1d9/0x5c0 
[btrfs]()
[2279367.861758] Modules linked in: sha256_generic btrfs raid6_pq crc32c 
libcrc32c radeon xor snd_hda_codec_hdmi snd_hda_intel snd_hda_codec 
snd_hwdep pcspkr ttm snd_pcm snd_page_alloc snd_timer snd drm_kms_helper 
edac_core sp5100_tco i2c_piix4 serio_raw k10temp soundcore edac_mce_amd 
drm evdev i2c_algo_bit r8169 i2c_core mii wmi shpchp button acpi_cpufreq 
processor ext4 crc16 mbcache jbd2 ata_generic pata_acpi sd_mod 
hid_generic usbhid hid ohci_pci ehci_pci ohci_hcd xhci_hcd pata_jmicron 
ehci_hcd ahci libahci libata scsi_mod usbcore usb_common
[2279367.861839] CPU: 1 PID: 29088 Comm: btrfs Tainted: G W 
3.13.0-rc6-git #1
[2279367.861845] Hardware name: Gigabyte Technology Co., Ltd. 
GA-890GPA-UD3H/GA-890GPA-UD3H, BIOS FD 07/23/2010
[2279367.861849]  0000000000000009 ffff8800827f96e8 ffffffff814f5648 
0000000000000000
[2279367.861858]  ffff8800827f9720 ffffffff81061b5d ffff8801fad0be10 
0000000000000000
[2279367.861866]  0000000000000000 ffff8800c92b1500 0000000000000009 
ffff8800827f9730
[2279367.861873] Call Trace:
[2279367.861886]  [<ffffffff814f5648>] dump_stack+0x4d/0x6f
[2279367.861897]  [<ffffffff81061b5d>] warn_slowpath_common+0x7d/0xa0
[2279367.861905]  [<ffffffff81061c3a>] warn_slowpath_null+0x1a/0x20
[2279367.861929]  [<ffffffffa09229d9>] 
lookup_inline_extent_backref+0x1d9/0x5c0 [btrfs]
[2279367.861954]  [<ffffffffa0923e15>] 
insert_inline_extent_backref+0x55/0xd0 [btrfs]
[2279367.861978]  [<ffffffffa0923f27>] __btrfs_inc_extent_ref+0x97/0x200 
[btrfs]
[2279367.862003]  [<ffffffffa092b016>] run_clustered_refs+0xb46/0x1180 
[btrfs]
[2279367.862027]  [<ffffffffa091a63d>] ? 
generic_bin_search.constprop.34+0x8d/0x1a0 [btrfs]
[2279367.862054]  [<ffffffffa092f3f0>] btrfs_run_delayed_refs+0xe0/0x550 
[btrfs]
[2279367.862083]  [<ffffffffa093fdee>] 
btrfs_commit_transaction+0x4e/0x9a0 [btrfs]
[2279367.862104]  [<ffffffffa09acd6f>] prepare_to_merge+0x1d2/0x1ed [btrfs]
[2279367.862131]  [<ffffffffa098d613>] relocate_block_group+0x393/0x640 
[btrfs]
[2279367.862156]  [<ffffffffa098da62>] 
btrfs_relocate_block_group+0x1a2/0x2f0 [btrfs]
[2279367.862184]  [<ffffffffa0965568>] 
btrfs_relocate_chunk.isra.28+0x68/0x760 [btrfs]
[2279367.862207]  [<ffffffffa091d066>] ? btrfs_search_slot+0x496/0x970 
[btrfs]
[2279367.862237]  [<ffffffffa095b01b>] ? release_extent_buffer+0x2b/0xd0 
[btrfs]
[2279367.862265]  [<ffffffffa096082f>] ? free_extent_buffer+0x4f/0xb0 
[btrfs]
[2279367.862294]  [<ffffffffa0967df9>] btrfs_shrink_device+0x1e9/0x420 
[btrfs]
[2279367.862322]  [<ffffffffa096ab58>] btrfs_rm_device+0x328/0x800 [btrfs]
[2279367.862330]  [<ffffffff8118b192>] ? __kmalloc_track_caller+0x32/0x250
[2279367.862358]  [<ffffffffa0974ed0>] btrfs_ioctl+0x2250/0x2d90 [btrfs]
[2279367.862366]  [<ffffffff811b350f>] ? user_path_at_empty+0x5f/0x90
[2279367.862374]  [<ffffffff814ff9c4>] ? __do_page_fault+0x2c4/0x5b0
[2279367.862382]  [<ffffffff811650b7>] ? vma_link+0xb7/0xc0
[2279367.862389]  [<ffffffff811b58a0>] do_vfs_ioctl+0x2e0/0x4c0
[2279367.862397]  [<ffffffff811b5b01>] SyS_ioctl+0x81/0xa0
[2279367.862404]  [<ffffffff814ffcbe>] ? do_page_fault+0xe/0x10
[2279367.862412]  [<ffffffff81503aad>] system_call_fastpath+0x1a/0x1f
[2279367.862416] ---[ end trace 0897e4c2446e06c5 ]---
[2279367.862426] BTRFS debug (device sdh): run_one_delayed_ref returned -5
[2279367.862430] ------------[ cut here ]------------
[2279367.862454] WARNING: CPU: 1 PID: 29088 at fs/btrfs/super.c:254 
__btrfs_abort_transaction+0x50/0x110 [btrfs]()
[2279367.862459] btrfs: Transaction aborted (error -5)
[2279367.862461] Modules linked in: sha256_generic btrfs raid6_pq crc32c 
libcrc32c radeon xor snd_hda_codec_hdmi snd_hda_intel snd_hda_codec 
snd_hwdep pcspkr ttm snd_pcm snd_page_alloc snd_timer snd drm_kms_helper 
edac_core sp5100_tco i2c_piix4 serio_raw k10temp soundcore edac_mce_amd 
drm evdev i2c_algo_bit r8169 i2c_core mii wmi shpchp button acpi_cpufreq 
processor ext4 crc16 mbcache jbd2 ata_generic pata_acpi sd_mod 
hid_generic usbhid hid ohci_pci ehci_pci ohci_hcd xhci_hcd pata_jmicron 
ehci_hcd ahci libahci libata scsi_mod usbcore usb_common
[2279367.862525] CPU: 1 PID: 29088 Comm: btrfs Tainted: G W 
3.13.0-rc6-git #1
[2279367.862529] Hardware name: Gigabyte Technology Co., Ltd. 
GA-890GPA-UD3H/GA-890GPA-UD3H, BIOS FD 07/23/2010
[2279367.862533]  0000000000000009 ffff8800827f98e8 ffffffff814f5648 
ffff8800827f9930
[2279367.862540]  ffff8800827f9920 ffffffff81061b5d 00000000fffffffb 
ffff880204182000
[2279367.862547]  ffff8800c92b1500 ffffffffa09b2b60 0000000000000b04 
ffff8800827f9980
[2279367.862554] Call Trace:
[2279367.862563]  [<ffffffff814f5648>] dump_stack+0x4d/0x6f
[2279367.862571]  [<ffffffff81061b5d>] warn_slowpath_common+0x7d/0xa0
[2279367.862580]  [<ffffffff81061bcc>] warn_slowpath_fmt+0x4c/0x50
[2279367.862603]  [<ffffffffa0914c50>] 
__btrfs_abort_transaction+0x50/0x110 [btrfs]
[2279367.862629]  [<ffffffffa092f72b>] 
btrfs_run_delayed_refs+0x41b/0x550 [btrfs]
[2279367.862658]  [<ffffffffa093fdee>] 
btrfs_commit_transaction+0x4e/0x9a0 [btrfs]
[2279367.862678]  [<ffffffffa09acd6f>] prepare_to_merge+0x1d2/0x1ed [btrfs]
[2279367.862704]  [<ffffffffa098d613>] relocate_block_group+0x393/0x640 
[btrfs]
[2279367.862730]  [<ffffffffa098da62>] 
btrfs_relocate_block_group+0x1a2/0x2f0 [btrfs]
[2279367.862758]  [<ffffffffa0965568>] 
btrfs_relocate_chunk.isra.28+0x68/0x760 [btrfs]
[2279367.862782]  [<ffffffffa091d066>] ? btrfs_search_slot+0x496/0x970 
[btrfs]
[2279367.862811]  [<ffffffffa095b01b>] ? release_extent_buffer+0x2b/0xd0 
[btrfs]
[2279367.862840]  [<ffffffffa096082f>] ? free_extent_buffer+0x4f/0xb0 
[btrfs]
[2279367.862868]  [<ffffffffa0967df9>] btrfs_shrink_device+0x1e9/0x420 
[btrfs]
[2279367.862896]  [<ffffffffa096ab58>] btrfs_rm_device+0x328/0x800 [btrfs]
[2279367.862904]  [<ffffffff8118b192>] ? __kmalloc_track_caller+0x32/0x250
[2279367.862932]  [<ffffffffa0974ed0>] btrfs_ioctl+0x2250/0x2d90 [btrfs]
[2279367.862939]  [<ffffffff811b350f>] ? user_path_at_empty+0x5f/0x90
[2279367.862947]  [<ffffffff814ff9c4>] ? __do_page_fault+0x2c4/0x5b0
[2279367.862954]  [<ffffffff811650b7>] ? vma_link+0xb7/0xc0
[2279367.862961]  [<ffffffff811b58a0>] do_vfs_ioctl+0x2e0/0x4c0
[2279367.862968]  [<ffffffff811b5b01>] SyS_ioctl+0x81/0xa0
[2279367.862976]  [<ffffffff814ffcbe>] ? do_page_fault+0xe/0x10
[2279367.862982]  [<ffffffff81503aad>] system_call_fastpath+0x1a/0x1f
[2279367.862987] ---[ end trace 0897e4c2446e06c6 ]---
[2279367.862993] BTRFS error (device sdh) in 
btrfs_run_delayed_refs:2820: errno=-5 IO failure
[2279367.867045] BTRFS info (device sdh): forced readonly

