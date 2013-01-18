Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from redisdead.crans.org ([138.231.136.39]:33041 "EHLO
	redisdead.crans.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756199Ab3AROjv (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 18 Jan 2013 09:39:51 -0500
Received: from owl.crans.org (owl.adm.crans.org [10.231.136.73])
	by redisdead.crans.org (Postfix) with ESMTP id AFDA52194
	for <linux-btrfs@vger.kernel.org>; Fri, 18 Jan 2013 15:33:55 +0100 (CET)
To: <linux-btrfs@vger.kernel.org>
Subject: unresolved ref dir
MIME-Version: 1.0
Content-Type: text/plain;
 charset=UTF-8;
 format=flowed
Date: Fri, 18 Jan 2013 15:33:55 +0100
From: calves <calves@crans.org>
Message-ID: <2c25832179962f24e555bb6b3d5c695b@crans.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi everyone,

  Few days ago, during a system update, some errors appeard: "can't 
create file XXX (Input/Output errors)". ls, stat, rm, on these files 
gave always the same Input/output error. "btrfsck --repair" told me that 
some leaves were corrupt (bad key order)  but nothing changed. They were 
all in the same folder so i tried to move its contents into another dir 
and delete it.

  Surprisingly it fixed some bad files but i got new errors. Trying to 
delete the file "kgthemeselector.h" gives these kernel messages:

[  814.056583] device label system devid 1 transid 32432 /dev/sda4
[  814.058370] btrfs: use ssd allocation scheme
[  814.058394] btrfs: use lzo compression
[  814.058403] btrfs: enabling auto defrag
[  814.058413] btrfs: enabling auto recovery
[  814.058418] btrfs: disk space caching is enabled
[  814.060856] btrfs: mismatching generation and generation_v2 found in 
root item. This root was probably mounted with an older kernel. 
Resetting all new fields.
[  834.384784] btrfs: unlinked 1 orphans
[  846.062494] btrfs failed to delete reference to kgthemeselector.h, 
inode 538801 parent 419
[  846.062506] ------------[ cut here ]------------
[  846.062579] WARNING: at fs/btrfs/super.c:246 
__btrfs_abort_transaction+0x99/0xb0 [btrfs]()
[  846.062585] Hardware name: System Product Name
[  846.062590] btrfs: Transaction aborted
[  846.062595] Modules linked in:
[  846.062600]  fuse btusb ext4 jbd2 mbcache arc4 powernow_k8 ath9k 
mperf ath9k_common ath9k_hw kvm_amd eeepc_wmi asus_wmi ath3k ath kvm 
sparse_keymap video mac80211 bluetooth pci_hotplug crc16 cfg80211 
snd_hda_codec_realtek rfkill radeon microcode snd_hda_codec_hdmi r8169 
psmouse ttm drm_kms_helper k10temp serio_raw snd_hda_intel pcspkr 
sp5100_tco drm mii snd_hda_codec agpgart joydev evdev snd_hwdep 
i2c_piix4 i2c_algo_bit snd_pcm snd_page_alloc snd_timer i2c_core snd wmi 
soundcore button processor sha256_generic ablk_helper cryptd aes_i586 
aes_generic cbc hid_generic usbhid hid usb_storage dm_crypt dm_mod btrfs 
crc32c libcrc32c zlib_deflate sd_mod ata_generic pata_acpi ohci_hcd ahci 
libahci xhci_hcd pata_atiixp libata ehci_hcd scsi_mod usbcore usb_common
[  846.062747] Pid: 1730, comm: rm Not tainted 3.6.11-1-ARCH #1
[  846.062753] Call Trace:
[  846.062774]  [<c1039fc2>] warn_slowpath_common+0x72/0xa0
[  846.062814]  [<f8a33da9>] ? __btrfs_abort_transaction+0x99/0xb0 
[btrfs]
[  846.062965]  [<f8a33da9>] ? __btrfs_abort_transaction+0x99/0xb0 
[btrfs]
[  846.062977]  [<c103a093>] warn_slowpath_fmt+0x33/0x40
[  846.063031]  [<f8a33da9>] __btrfs_abort_transaction+0x99/0xb0 
[btrfs]
[  846.063086]  [<f8a63247>] __btrfs_unlink_inode+0x357/0x360 [btrfs]
[  846.063135]  [<f8a66323>] btrfs_unlink_inode+0x33/0x60 [btrfs]
[  846.063180]  [<f8a663b8>] btrfs_unlink+0x68/0xc0 [btrfs]
[  846.063192]  [<c11472b1>] vfs_unlink+0x81/0xf0
[  846.063201]  [<c1147445>] do_unlinkat+0x125/0x140
[  846.063214]  [<c104281c>] ? irq_exit+0x5c/0xa0
[  846.063228]  [<c1149292>] sys_unlinkat+0x22/0x50
[  846.063239]  [<c13e06df>] sysenter_do_call+0x12/0x28
[  846.063246] ---[ end trace 158e903eaeb56eb1 ]---
[  846.063255] BTRFS error (device sda4) in __btrfs_unlink_inode:2810: 
error 2
[  846.063262] btrfs is forced readonly


  And "btrfs --repair" gives

checking extents
checking fs roots
root 256 inode 266753 errors 2000
     unresolved ref dir 419 index 2091 namelen 17 name kgthemeselector.h 
filetype 1 error 1
root 256 inode 538801 errors 2000
     unresolved ref dir 419 index 0 namelen 17 name kgthemeselector.h 
filetype 1 error 6
enabling repair mode
found 18558943232 bytes used err is 0
total csum bytes: 17455544
total tree bytes: 434208768
total fs tree bytes: 386076672
btree space waste bytes: 102939178
file data blocks allocated: 26994438144
  referenced 21001273344
Btrfs Btrfs v0.19
  I'm on a 64 bit Arch Linux up to date, uname gives

Linux ... 3.6.11-1-ARCH #1 SMP PREEMPT ... x86_64 GNU/Linux

  Is there a way to get rid of these files?

Thanks!
-- 
Christophe Calvès
