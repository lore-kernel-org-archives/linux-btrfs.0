Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-it0-f65.google.com ([209.85.214.65]:34887 "EHLO
	mail-it0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752450AbcGGKYr (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 7 Jul 2016 06:24:47 -0400
Received: by mail-it0-f65.google.com with SMTP id g4so2123047ith.2
        for <linux-btrfs@vger.kernel.org>; Thu, 07 Jul 2016 03:24:47 -0700 (PDT)
MIME-Version: 1.0
From: Gabriel C <nix.or.die@gmail.com>
Date: Thu, 7 Jul 2016 12:24:17 +0200
Message-ID: <CAEJqkghMZDOJoyRkf_-HTfuKLnj0eaAGmtjVAPY2UftV7TxbvA@mail.gmail.com>
Subject: A lot warnings in dmesg while running thunderbird
To: linux-btrfs@vger.kernel.org
Cc: quwenruo@cn.fujitsu.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

while running thunderbird on linux 4.6.3 and 4.7.0-rc6 ( didn't tested
other versions )
I trigger the following :


[ 6393.305675] WARNING: CPU: 6 PID: 5870 at fs/btrfs/inode.c:9306
btrfs_destroy_inode+0x22e/0x2a0 [btrfs]
[ 6393.305677] Modules linked in: fuse ufs qnx4 hfsplus hfs minix ntfs
vfat msdos fat jfs ext4 crc16 jbd2 ext2 mbcache binfmt_misc ctr ccm
af_packet xfs libcrc32c crc32c_generic amdkfd amd_iommu_v2 coretemp
radeon intel_powerclamp ttm ar
c4 kvm_intel drm_kms_helper ath9k ath9k_common ath9k_hw ath mac80211
joydev drm agpgart i2c_algo_bit fb_sys_fops syscopyarea sysfillrect
kvm sysimgblt evdev ipmi_ssif mac_hid snd_hda_codec_hdmi snd_hda_intel
snd_hda_codec snd_hda_core sn
d_hwdep iTCO_wdt cfg80211 rfkill iTCO_vendor_support ipmi_si
ipmi_msghandler irqbypass pcspkr e1000e ptp pps_core fjes tpm_infineon
button i2c_i801 ac acpi_power_meter i5500_temp hwmon i7core_edac
ioatdma acpi_cpufreq tpm_tis dca edac_co
re tpm shpchp lpc_ich i2c_core ppdev sch_fq_codel snd_seq_dummy
snd_pcm_oss snd_mixer_oss snd_pcm snd_seq_oss
[ 6393.305742]  snd_seq_midi_event snd_seq snd_seq_device snd_timer
snd soundcore lp parport_pc parport hid_logitech_hidpp hid_logitech_dj
usbhid hid btrfs xor raid6_pq uas usb_storage sd_mod uhci_hcd ahci
libahci libata megaraid_sas crc
32c_intel ehci_pci ehci_hcd usbcore scsi_mod usb_common dm_mirror
dm_region_hash dm_log dm_mod unix ipv6 autofs4 jitterentropy_rng
sha256_ssse3 sha256_generic hmac drbg ansi_cprng
[ 6393.305772] CPU: 6 PID: 5870 Comm: mozStorage #1 Tainted: G
 I     4.7.0-rc6 #1
[ 6393.305774] Hardware name: FUJITSU
PRIMERGY TX200 S5             /D2709, BIOS 6.00 Rev. 1.14.2709
     02/04/2013
[ 6393.305775]  0000000000000000 ffffffff81249333 0000000000000000
0000000000000000
[ 6393.305778]  ffffffff81058044 ffff8807e1de2480 ffff8807e152c898
ffff88083b273800
[ 6393.305780]  ffff8807e152c898 ffff88043f52edd8 ffff88083aa3b910
ffffffffa051eade
[ 6393.305783] Call Trace:
[ 6393.305791]  [<ffffffff81249333>] ? dump_stack+0x5c/0x79
[ 6393.305795]  [<ffffffff81058044>] ? __warn+0xb4/0xd0
[ 6393.305809]  [<ffffffffa051eade>] ? btrfs_destroy_inode+0x22e/0x2a0 [btrfs]
[ 6393.305814]  [<ffffffff81197451>] ? __dentry_kill+0x191/0x210
[ 6393.305816]  [<ffffffff81197632>] ? dput+0x162/0x270
[ 6393.305819]  [<ffffffff81183b8d>] ? __fput+0x11d/0x1c0
[ 6393.305824]  [<ffffffff81070ef0>] ? task_work_run+0x70/0x90
[ 6393.305827]  [<ffffffff810020db>] ? exit_to_usermode_loop+0x9b/0xa0
[ 6393.305829]  [<ffffffff81002565>] ? syscall_return_slowpath+0x45/0x50
[ 6393.305836]  [<ffffffff814972fa>] ? entry_SYSCALL_64_fastpath+0xa2/0xa4
[ 6393.305855] ---[ end trace cd086f0cb12a2d9c ]---

and after that lots:

[ 6509.253357] WARNING: CPU: 12 PID: 7271 at
fs/btrfs/extent-tree.c:4303
btrfs_free_reserved_data_space_noquota+0x68/0x80 [btrfs]
[ 6509.253359] Modules linked in: fuse ufs qnx4 hfsplus hfs minix ntfs
vfat msdos fat jfs ext4 crc16 jbd2 ext2 mbcache binfmt_misc ctr ccm
af_packet xfs libcrc32c crc32c_generic amdkfd amd_iommu_v2 coretemp
radeon intel_powerclamp ttm ar
c4 kvm_intel drm_kms_helper ath9k ath9k_common ath9k_hw ath mac80211
joydev drm agpgart i2c_algo_bit fb_sys_fops syscopyarea sysfillrect
kvm sysimgblt evdev ipmi_ssif mac_hid snd_hda_codec_hdmi snd_hda_intel
snd_hda_codec snd_hda_core sn
d_hwdep iTCO_wdt cfg80211 rfkill iTCO_vendor_support ipmi_si
ipmi_msghandler irqbypass pcspkr e1000e ptp pps_core fjes tpm_infineon
button i2c_i801 ac acpi_power_meter i5500_temp hwmon i7core_edac
ioatdma acpi_cpufreq tpm_tis dca edac_co
re tpm shpchp lpc_ich i2c_core ppdev sch_fq_codel snd_seq_dummy
snd_pcm_oss snd_mixer_oss snd_pcm snd_seq_oss
[ 6509.253420]  snd_seq_midi_event snd_seq snd_seq_device snd_timer
snd soundcore lp parport_pc parport hid_logitech_hidpp hid_logitech_dj
usbhid hid btrfs xor raid6_pq uas usb_storage sd_mod uhci_hcd ahci
libahci libata megaraid_sas crc
32c_intel ehci_pci ehci_hcd usbcore scsi_mod usb_common dm_mirror
dm_region_hash dm_log dm_mod unix ipv6 autofs4 jitterentropy_rng
sha256_ssse3 sha256_generic hmac drbg ansi_cprng
[ 6509.253450] CPU: 12 PID: 7271 Comm: systemd-journal Tainted: G
  W I     4.7.0-rc6 #1
[ 6509.253451] Hardware name: FUJITSU
PRIMERGY TX200 S5             /D2709, BIOS 6.00 Rev. 1.14.2709
     02/04/2013
[ 6509.253453]  0000000000000000 ffffffff81249333 0000000000000000
0000000000000000
[ 6509.253456]  ffffffff81058044 0000000000001000 ffff88043b720200
0000000000000fff
[ 6509.253459]  ffff88083d57990c ffff8807de10b924 0000000000001000
ffffffffa04f3b08
[ 6509.253462] Call Trace:
[ 6509.253467]  [<ffffffff81249333>] ? dump_stack+0x5c/0x79
[ 6509.253470]  [<ffffffff81058044>] ? __warn+0xb4/0xd0
[ 6509.253483]  [<ffffffffa04f3b08>] ?
btrfs_free_reserved_data_space_noquota+0x68/0x80 [btrfs]
[ 6509.253499]  [<ffffffffa050f002>] ? btrfs_clear_bit_hook+0x282/0x360 [btrfs]
[ 6509.253515]  [<ffffffffa052a900>] ? clear_state_bit+0x50/0x1c0 [btrfs]
[ 6509.253532]  [<ffffffffa052abb2>] ? __clear_extent_bit+0x142/0x3c0 [btrfs]
[ 6509.253549]  [<ffffffffa052b91b>] ?
extent_clear_unlock_delalloc+0x5b/0x220 [btrfs]
[ 6509.253560]  [<ffffffffa04e3f87>] ? btrfs_release_path+0x27/0x80 [btrfs]
[ 6509.253563]  [<ffffffff81163c1e>] ? kmem_cache_alloc+0x13e/0x150
[ 6509.253567]  [<ffffffff81199c2c>] ? igrab+0x2c/0x50
[ 6509.253583]  [<ffffffffa052789c>] ?
__btrfs_add_ordered_extent+0x20c/0x2d0 [btrfs]
[ 6509.253595]  [<ffffffffa04ec451>] ?
block_group_cache_tree_search+0xb1/0xd0 [btrfs]
[ 6509.253610]  [<ffffffffa0514e30>] ? run_delalloc_nocow+0xa60/0xba0 [btrfs]
[ 6509.253627]  [<ffffffffa0515300>] ? run_delalloc_range+0x390/0x3b0 [btrfs]
[ 6509.253630]  [<ffffffff8104e925>] ? flush_tlb_page+0x35/0x90
[ 6509.253647]  [<ffffffffa052c08b>] ?
writepage_delalloc.isra.20+0xfb/0x170 [btrfs]
[ 6509.253664]  [<ffffffffa052dbf3>] ? __extent_writepage+0xb3/0x300 [btrfs]
[ 6509.253668]  [<ffffffff81119d7a>] ? __set_page_dirty_nobuffers+0xea/0x140
[ 6509.253685]  [<ffffffffa052e07c>] ?
extent_write_cache_pages.isra.16.constprop.31+0x23c/0x350 [btrfs]
[ 6509.253702]  [<ffffffffa052f448>] ? extent_writepages+0x48/0x60 [btrfs]
[ 6509.253718]  [<ffffffffa0511310>] ? btrfs_direct_IO+0x360/0x360 [btrfs]
[ 6509.253723]  [<ffffffff8110dc32>] ? __filemap_fdatawrite_range+0xa2/0xe0
[ 6509.253739]  [<ffffffffa0523de6>] ? btrfs_fdatawrite_range+0x16/0x40 [btrfs]
[ 6509.253755]  [<ffffffffa0523e20>] ? start_ordered_ops+0x10/0x20 [btrfs]
[ 6509.253771]  [<ffffffffa0523e71>] ? btrfs_sync_file+0x41/0x360 [btrfs]
[ 6509.253775]  [<ffffffff811ad0a3>] ? do_fsync+0x33/0x60
[ 6509.253778]  [<ffffffff811ad2c7>] ? SyS_fsync+0x7/0x10
[ 6509.253782]  [<ffffffff81497272>] ? entry_SYSCALL_64_fastpath+0x1a/0xa4

...

See http://paste.opensuse.org/view/simple/86078072 and
http://paste.opensuse.org/view/simple/87276071

This is from running thunderbird just few seconds , when I let it run
for a while I have to reboot the system.

$ uname -a
Linux zwerg 4.7.0-rc6 #1 SMP PREEMPT Tue Jul 5 07:48:39 CEST 2016
x86_64 x86_64 x86_64 GNU/Linux

btrfs-progs v4.6.1

sda is HW RAID0

...

Jun 23 14:27:48 localhost kernel: scsi host0: Avago SAS based MegaRAID driver
Jun 23 14:27:48 localhost kernel: scsi 0:0:6:0: Direct-Access     ATA
    WDC WD5002ABYS-5 3B06 PQ: 0 ANSI: 5
Jun 23 14:27:48 localhost kernel: scsi 0:0:7:0: Direct-Access     ATA
    WDC WD5002ABYS-5 3B06 PQ: 0 ANSI: 5
Jun 23 14:27:48 localhost kernel: scsi 0:0:10:0: Direct-Access     ATA
     ST500NM0011      FTM6 PQ: 0 ANSI: 5
Jun 23 14:27:48 localhost kernel: scsi 0:2:0:0: Direct-Access     LSI
    MegaRAID SAS RMB 1.40 PQ: 0 ANSI: 5

...

mount | grep sda
/dev/sda1 on / type btrfs
(rw,noatime,compress=lzo,space_cache,autodefrag,subvolid=5,subvol=/)

( tested with and without compression , with just defaults the
warnings are still the same )

btrfs fi show
Label: none  uuid: 67b2e285-e331-42ad-8478-d78b17ea6970
       Total devices 1 FS bytes used 31.47GiB
       devid    1 size 1.36TiB used 37.06GiB path /dev/sda1


btrfs fi df /
Data, single: total=32.00GiB, used=30.43GiB
System, DUP: total=32.00MiB, used=16.00KiB
Metadata, DUP: total=2.50GiB, used=1.04GiB
GlobalReserve, single: total=368.00MiB, used=0.00B


Regards,

Gabriel C
