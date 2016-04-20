Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:31950 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S932256AbcDTHZu (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 20 Apr 2016 03:25:50 -0400
Subject: Re: Question: raid1 behaviour on failure
To: Matthias Bodenbinder <matthias@bodenbinder.de>,
        <linux-btrfs@vger.kernel.org>
References: <nf1q0j$ug4$1@ger.gmane.org> <57148B2E.6010904@cn.fujitsu.com>
 <nf73cv$7vh$1@ger.gmane.org>
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
Message-ID: <9ade4472-c99d-82a8-27c9-704b75bd87ab@cn.fujitsu.com>
Date: Wed, 20 Apr 2016 15:25:43 +0800
MIME-Version: 1.0
In-Reply-To: <nf73cv$7vh$1@ger.gmane.org>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



Matthias Bodenbinder wrote on 2016/04/20 07:17 +0200:
> Am 18.04.2016 um 09:22 schrieb Qu Wenruo:
>> BTW, it would be better to post the dmesg for better debug.
>
> So here we. I did the same test again. Here is a full log of what i did. It seems to be mean like a bug in btrfs.
> Sequenz of events:
> 1. mount the raid1 (2 disc with different size)
> 2. unplug the biggest drive (hotplug)
> 3. try to copy something to the degraded raid1
> 4. plugin the device again (hotplug)
>
> This scenario does not work. The disc array is NOT redundant! I can not work with it while a drive is missing and I can not reattach the device so that everything works again.
>
> The btrfs module crashes during the test.
>
> I am using LMDE2 with backports:
> btrfs-tools 4.4-1~bpo8+1
> linux-image-4.4.0-0.bpo.1-amd64
>
> Matthias
>
>
> rakete - root - /root
> 1# mount /mnt/raid1/
>
> Journal:
>
> Apr 20 07:01:16 rakete kernel: BTRFS info (device sdi): enabling auto defrag
> Apr 20 07:01:16 rakete kernel: BTRFS info (device sdi): disk space caching is enabled
> Apr 20 07:01:16 rakete kernel: BTRFS: has skinny extents
>
> rakete - root - /mnt/raid1
> 3# ll
> insgesamt 0
> drwxrwxr-x 1 root root   36 Nov 14  2014 AfterShot2(64-bit)
> drwxrwxr-x 1 root root 5082 Apr 17 09:06 etc
> drwxr-xr-x 1 root root  108 Mär 24 07:31 var
>
> 4# btrfs fi show
> Label: none  uuid: 16d5891f-5d52-4b29-8591-588ddf11e73d
> 	Total devices 3 FS bytes used 1.60GiB
> 	devid    1 size 698.64GiB used 3.03GiB path /dev/sdg
> 	devid    2 size 465.76GiB used 3.03GiB path /dev/sdh
> 	devid    3 size 232.88GiB used 0.00B path /dev/sdi
>
> ####
> unplug device sdg:
>
> Apr 20 07:03:05 rakete kernel: Buffer I/O error on dev sdf1, logical block 243826688, lost sync page write
> Apr 20 07:03:05 rakete kernel: JBD2: Error -5 detected when updating journal superblock for sdf1-8.
> Apr 20 07:03:05 rakete kernel: Aborting journal on device sdf1-8.
> Apr 20 07:03:05 rakete kernel: Buffer I/O error on dev sdf1, logical block 243826688, lost sync page write
> Apr 20 07:03:05 rakete kernel: JBD2: Error -5 detected when updating journal superblock for sdf1-8.
> Apr 20 07:03:05 rakete umount[16405]: umount: /mnt/raid1: target is busy
> Apr 20 07:03:05 rakete umount[16405]: (In some cases useful info about processes that
> Apr 20 07:03:05 rakete umount[16405]: use the device is found by lsof(8) or fuser(1).)
> Apr 20 07:03:05 rakete systemd[1]: mnt-raid1.mount mount process exited, code=exited status=32
> Apr 20 07:03:05 rakete systemd[1]: Failed unmounting /mnt/raid1.
> Apr 20 07:03:24 rakete kernel: usb 3-1: new SuperSpeed USB device number 3 using xhci_hcd
> Apr 20 07:03:24 rakete kernel: usb 3-1: New USB device found, idVendor=152d, idProduct=0567
> Apr 20 07:03:24 rakete kernel: usb 3-1: New USB device strings: Mfr=10, Product=11, SerialNumber=5
> Apr 20 07:03:24 rakete kernel: usb 3-1: Product: USB to ATA/ATAPI Bridge
> Apr 20 07:03:24 rakete kernel: usb 3-1: Manufacturer: JMicron
> Apr 20 07:03:24 rakete kernel: usb 3-1: SerialNumber: 152D00539000
> Apr 20 07:03:24 rakete kernel: usb-storage 3-1:1.0: USB Mass Storage device detected
> Apr 20 07:03:24 rakete kernel: usb-storage 3-1:1.0: Quirks match for vid 152d pid 0567: 5000000
> Apr 20 07:03:24 rakete kernel: scsi host9: usb-storage 3-1:1.0
> Apr 20 07:03:24 rakete mtp-probe[16424]: checking bus 3, device 3: "/sys/devices/pci0000:00/0000:00:1c.5/0000:04:00.0/usb3/3-1"
> Apr 20 07:03:24 rakete mtp-probe[16424]: bus: 3, device: 3 was not an MTP device
> Apr 20 07:03:25 rakete kernel: scsi 9:0:0:0: Direct-Access     WDC WD20 02FAEX-007BA0    0125 PQ: 0 ANSI: 6
> Apr 20 07:03:25 rakete kernel: scsi 9:0:0:1: Direct-Access     WDC WD50 01AALS-00L3B2    0125 PQ: 0 ANSI: 6
> Apr 20 07:03:25 rakete kernel: scsi 9:0:0:2: Direct-Access     SAMSUNG  SP2504C          0125 PQ: 0 ANSI: 6
> Apr 20 07:03:25 rakete kernel: sd 9:0:0:0: Attached scsi generic sg6 type 0
> Apr 20 07:03:25 rakete kernel: sd 9:0:0:1: Attached scsi generic sg7 type 0
> Apr 20 07:03:25 rakete kernel: sd 9:0:0:0: [sdf] 3907029168 512-byte logical blocks: (2.00 TB/1.82 TiB)
> Apr 20 07:03:25 rakete kernel: sd 9:0:0:0: [sdf] Write Protect is off
> Apr 20 07:03:25 rakete kernel: sd 9:0:0:0: [sdf] Mode Sense: 67 00 10 08
> Apr 20 07:03:25 rakete kernel: sd 9:0:0:2: Attached scsi generic sg8 type 0
> Apr 20 07:03:25 rakete kernel: sd 9:0:0:1: [sdj] 976773168 512-byte logical blocks: (500 GB/466 GiB)
> Apr 20 07:03:25 rakete kernel: sd 9:0:0:0: [sdf] No Caching mode page found
> Apr 20 07:03:25 rakete kernel: sd 9:0:0:0: [sdf] Assuming drive cache: write through
> Apr 20 07:03:25 rakete kernel: sd 9:0:0:1: [sdj] Write Protect is off
> Apr 20 07:03:25 rakete kernel: sd 9:0:0:1: [sdj] Mode Sense: 67 00 10 08
> Apr 20 07:03:25 rakete kernel: sd 9:0:0:2: [sdk] 488395055 512-byte logical blocks: (250 GB/233 GiB)
> Apr 20 07:03:25 rakete kernel: sd 9:0:0:1: [sdj] No Caching mode page found
> Apr 20 07:03:25 rakete kernel: sd 9:0:0:1: [sdj] Assuming drive cache: write through
> Apr 20 07:03:25 rakete kernel: sd 9:0:0:2: [sdk] Write Protect is off
> Apr 20 07:03:25 rakete kernel: sd 9:0:0:2: [sdk] Mode Sense: 67 00 10 08
> Apr 20 07:03:25 rakete kernel: sd 9:0:0:2: [sdk] No Caching mode page found
> Apr 20 07:03:25 rakete kernel: sd 9:0:0:2: [sdk] Assuming drive cache: write through
> Apr 20 07:03:25 rakete kernel:  sdf: sdf1
> Apr 20 07:03:25 rakete kernel: sd 9:0:0:0: [sdf] Attached SCSI disk
> Apr 20 07:03:25 rakete kernel: sd 9:0:0:1: [sdj] Attached SCSI disk
> Apr 20 07:03:25 rakete kernel: sd 9:0:0:2: [sdk] Attached SCSI disk
> Apr 20 07:03:25 rakete kernel: EXT4-fs (sdf1): recovery complete
> Apr 20 07:03:25 rakete kernel: EXT4-fs (sdf1): mounted filesystem with ordered data mode. Opts: (null)
> Apr 20 07:03:25 rakete udisksd[3671]: Error statting /dev/sdg: No such file or directory
>
>
> ####
> 5# btrfs fi show
> Label: none  uuid: 16d5891f-5d52-4b29-8591-588ddf11e73d
> 	Total devices 3 FS bytes used 1.60GiB
> 	devid    2 size 465.76GiB used 3.03GiB path /dev/sdj
> 	devid    3 size 232.88GiB used 0.00B path /dev/sdk
> 	*** Some devices missing
> ####
> still mounted in rw mode:
> /dev/sdg on /mnt/raid1 type btrfs (rw,noatime,space_cache,autodefrag,subvolid=5,subvol=/)
> ####

Unfortunately, this is the designed behavior.

The fs is rw just because it doesn't hit any critical problem.

If you try to touch a file and then sync the fs, btrfs will become RO 
immediately.

> 7# cp -r /root/ .
> cp: das Verzeichnis „./root“ kann nicht angelegt werden: Eingabe-/Ausgabefehler
> Apr 20 07:05:37 rakete kernel: BTRFS error (device sdi): bdev /dev/sdg errs: wr 0, rd 1, flush 0, corrupt 0, gen 0
> Apr 20 07:05:37 rakete kernel: BTRFS error (device sdi): bdev /dev/sdg errs: wr 0, rd 2, flush 0, corrupt 0, gen 0
> Apr 20 07:05:37 rakete kernel: BTRFS error (device sdi): bdev /dev/sdg errs: wr 0, rd 3, flush 0, corrupt 0, gen 0
> Apr 20 07:05:37 rakete kernel: BTRFS error (device sdi): bdev /dev/sdg errs: wr 0, rd 4, flush 0, corrupt 0, gen 0
> Apr 20 07:05:37 rakete kernel: BTRFS error (device sdi): bdev /dev/sdg errs: wr 0, rd 5, flush 0, corrupt 0, gen 0
> Apr 20 07:05:37 rakete kernel: BTRFS error (device sdi): bdev /dev/sdg errs: wr 0, rd 6, flush 0, corrupt 0, gen 0
> Apr 20 07:05:37 rakete kernel: BTRFS error (device sdi): bdev /dev/sdg errs: wr 0, rd 7, flush 0, corrupt 0, gen 0
> Apr 20 07:05:37 rakete kernel: BTRFS error (device sdi): bdev /dev/sdg errs: wr 0, rd 8, flush 0, corrupt 0, gen 0
> Apr 20 07:05:37 rakete kernel: BTRFS error (device sdi): bdev /dev/sdg errs: wr 0, rd 9, flush 0, corrupt 0, gen 0
> Apr 20 07:05:37 rakete kernel: BTRFS error (device sdi): bdev /dev/sdg errs: wr 0, rd 10, flush 0, corrupt 0, gen 0
> Apr 20 07:05:37 rakete kernel: BTRFS error (device sdi): error reading free space cache
> Apr 20 07:05:37 rakete kernel: BTRFS warning (device sdi): failed to load free space cache for block group 20497563648, rebuilding it now
> Apr 20 07:05:37 rakete kernel: ------------[ cut here ]------------
> Apr 20 07:05:37 rakete kernel: WARNING: CPU: 7 PID: 16738 at /build/linux-H3jpF0/linux-4.4.6/fs/btrfs/ctree.c:1156 __btrfs_cow_block+0x56f/0x5e0 [btrfs]()
> Apr 20 07:05:37 rakete kernel: BTRFS: Transaction aborted (error -5)
> Apr 20 07:05:37 rakete kernel: Modules linked in: uas usb_storage pci_stub vboxpci(O) vboxnetadp(O) vboxnetflt(O) binfmt_misc dvb_ttpci saa7146_vv ttpci_eeprom saa7146 videobuf_dma_sg videobuf_core dvb_core v4l2_common videodev media cfg80211 vboxdrv(O) cpufreq_powersave cpufreq_conservative cpufreq_userspace cpufreq_stats snd_hda_codec_hdmi intel_rapl iosf_mbi x86_pkg_temp_thermal intel_powerclamp coretemp kvm_intel kvm irqbypass crct10dif_pclmul crc32_pclmul eeepc_wmi asus_wmi joydev sparse_keymap drbg iTCO_wdt iTCO_vendor_support snd_hda_codec_realtek rfkill ansi_cprng snd_hda_codec_generic nvidia(PO) aesni_intel aes_x86_64 lrw gf128mul snd_hda_intel glue_helper ablk_helper snd_hda_codec cryptd snd_hda_core serio_raw pcspkr snd_hwdep snd_pcm i2c_i801 snd_timer snd lpc_ich soundcore 8250_fintek mei_me shpchp mei
> Apr 20 07:05:37 rakete kernel:  mfd_core battery tpm_tis tpm evdev processor drm fuse ecryptfs cbc sha256_ssse3 sha256_generic hmac encrypted_keys parport_pc ppdev lp parport autofs4 ext4 crc16 mbcache jbd2 btrfs raid456 async_raid6_recov async_memcpy async_pq async_xor async_tx xor hid_generic usbhid hid raid6_pq libcrc32c crc32c_generic md_mod dm_mirror dm_region_hash dm_log dm_mod sr_mod sg cdrom sd_mod ata_generic ahci libahci pata_via xhci_pci ehci_pci crc32c_intel xhci_hcd ehci_hcd libata psmouse scsi_mod atl1c usbcore usb_common fjes video wmi fan thermal button
> Apr 20 07:05:37 rakete kernel: CPU: 7 PID: 16738 Comm: cp Tainted: P           O    4.4.0-0.bpo.1-amd64 #1 Debian 4.4.6-1~bpo8+1
> Apr 20 07:05:37 rakete kernel: Hardware name: System manufacturer System Product Name/P8H67-V, BIOS 3707 07/12/2013
> Apr 20 07:05:37 rakete kernel:  0000000000000286 000000006a1407c8 ffffffff812ed425 ffff88016b6dfb90
> Apr 20 07:05:37 rakete kernel:  ffffffffa03817b8 ffffffff81077ea1 ffff88018e7fcd30 ffff88016b6dfbe8
> Apr 20 07:05:37 rakete kernel:  ffff88005d863e88 ffff8801cde7a980 ffff88018e7fce48 ffffffff81077f2c
> Apr 20 07:05:37 rakete kernel: Call Trace:
> Apr 20 07:05:37 rakete kernel:  [<ffffffff812ed425>] ? dump_stack+0x5c/0x77
> Apr 20 07:05:37 rakete kernel:  [<ffffffff81077ea1>] ? warn_slowpath_common+0x81/0xb0
> Apr 20 07:05:37 rakete kernel:  [<ffffffff81077f2c>] ? warn_slowpath_fmt+0x5c/0x80
> Apr 20 07:05:37 rakete kernel:  [<ffffffffa02d74af>] ? __btrfs_cow_block+0x56f/0x5e0 [btrfs]
> Apr 20 07:05:37 rakete kernel:  [<ffffffffa02d76af>] ? btrfs_cow_block+0x10f/0x1d0 [btrfs]
> Apr 20 07:05:37 rakete kernel:  [<ffffffffa02db2cd>] ? btrfs_search_slot+0x1fd/0xa30 [btrfs]
> Apr 20 07:05:37 rakete kernel:  [<ffffffffa02dd3f1>] ? btrfs_insert_empty_items+0x71/0xc0 [btrfs]
> Apr 20 07:05:37 rakete kernel:  [<ffffffff811f4d92>] ? insert_inode_locked4+0xa2/0x1c0
> Apr 20 07:05:37 rakete kernel:  [<ffffffffa030ee5d>] ? btrfs_new_inode+0x1cd/0x590 [btrfs]
> Apr 20 07:05:37 rakete kernel:  [<ffffffffa0310a77>] ? btrfs_mkdir+0x107/0x1f0 [btrfs]
> Apr 20 07:05:37 rakete kernel:  [<ffffffff811e80b0>] ? vfs_mkdir+0xb0/0x140
> Apr 20 07:05:37 rakete kernel:  [<ffffffff811e9d3e>] ? SyS_mkdir+0xce/0x110
> Apr 20 07:05:37 rakete kernel:  [<ffffffff81592736>] ? system_call_fast_compare_end+0xc/0x6b
> Apr 20 07:05:37 rakete kernel: ---[ end trace 025eb0e83ffed96f ]---
> Apr 20 07:05:37 rakete kernel: BTRFS: error (device sdi) in __btrfs_cow_block:1156: errno=-5 IO failure
> Apr 20 07:05:37 rakete kernel: BTRFS info (device sdi): forced readonly

Btrfs fails to read space cache, nor make a new dir.

The failure on cow_block in mkdir is ciritical, and btrfs become RO.

All expected behavior so far.

You may try use degraded mount option, but AFAIK it may not handle case 
like yours.

Thanks,
Qu
>
> ####
> Try to copy again:
> 11# cp -r /root/ .
> cp: cannot create directory './root': Read-only file system
> ####
> /dev/sdg on /mnt/raid1 type btrfs (ro,noatime,space_cache,autodefrag,subvolid=5,subvol=/)
> ####
> plugin device sdg again:
>
> Apr 20 07:07:39 rakete udisksd[3671]: Cleaning up mount point /media/matthias/BACKUP (device 8:81 no longer exist)
> Apr 20 07:07:39 rakete kernel: usb 3-1: USB disconnect, device number 3
> Apr 20 07:07:39 rakete udisksd[3671]: Error statting /dev/sdg: No such file or directory
> Apr 20 07:07:39 rakete umount[16807]: umount: /mnt/raid1: target is busy
> Apr 20 07:07:39 rakete umount[16807]: (In some cases useful info about processes that
> Apr 20 07:07:39 rakete umount[16807]: use the device is found by lsof(8) or fuser(1).)
> Apr 20 07:07:39 rakete systemd[1]: mnt-raid1.mount mount process exited, code=exited status=32
> Apr 20 07:07:39 rakete systemd[1]: Failed unmounting /mnt/raid1.
> Apr 20 07:08:01 rakete kernel: usb 3-1: new SuperSpeed USB device number 4 using xhci_hcd
> Apr 20 07:08:01 rakete kernel: usb 3-1: New USB device found, idVendor=152d, idProduct=0567
> Apr 20 07:08:01 rakete kernel: usb 3-1: New USB device strings: Mfr=10, Product=11, SerialNumber=5
> Apr 20 07:08:01 rakete kernel: usb 3-1: Product: USB to ATA/ATAPI Bridge
> Apr 20 07:08:01 rakete kernel: usb 3-1: Manufacturer: JMicron
> Apr 20 07:08:01 rakete kernel: usb 3-1: SerialNumber: 152D00539000
> Apr 20 07:08:01 rakete kernel: usb-storage 3-1:1.0: USB Mass Storage device detected
> Apr 20 07:08:01 rakete kernel: usb-storage 3-1:1.0: Quirks match for vid 152d pid 0567: 5000000
> Apr 20 07:08:01 rakete kernel: scsi host10: usb-storage 3-1:1.0
> Apr 20 07:08:01 rakete mtp-probe[16826]: checking bus 3, device 4: "/sys/devices/pci0000:00/0000:00:1c.5/0000:04:00.0/usb3/3-1"
> Apr 20 07:08:01 rakete mtp-probe[16826]: bus: 3, device: 4 was not an MTP device
> Apr 20 07:08:02 rakete kernel: scsi 10:0:0:0: Direct-Access     WDC WD20 02FAEX-007BA0    0125 PQ: 0 ANSI: 6
> Apr 20 07:08:02 rakete kernel: scsi 10:0:0:1: Direct-Access     WDC WD75 00AACS-00C7B0    0125 PQ: 0 ANSI: 6
> Apr 20 07:08:02 rakete kernel: scsi 10:0:0:2: Direct-Access     WDC WD50 01AALS-00L3B2    0125 PQ: 0 ANSI: 6
> Apr 20 07:08:02 rakete kernel: scsi 10:0:0:3: Direct-Access     SAMSUNG  SP2504C          0125 PQ: 0 ANSI: 6
> Apr 20 07:08:02 rakete kernel: sd 10:0:0:0: Attached scsi generic sg6 type 0
> Apr 20 07:08:02 rakete kernel: sd 10:0:0:0: [sdf] 3907029168 512-byte logical blocks: (2.00 TB/1.82 TiB)
> Apr 20 07:08:02 rakete kernel: sd 10:0:0:0: [sdf] Write Protect is off
> Apr 20 07:08:02 rakete kernel: sd 10:0:0:0: [sdf] Mode Sense: 67 00 10 08
> Apr 20 07:08:02 rakete kernel: sd 10:0:0:1: Attached scsi generic sg7 type 0
> Apr 20 07:08:02 rakete kernel: sd 10:0:0:0: [sdf] No Caching mode page found
> Apr 20 07:08:02 rakete kernel: sd 10:0:0:0: [sdf] Assuming drive cache: write through
> Apr 20 07:08:02 rakete kernel: sd 10:0:0:1: [sdj] 1465149168 512-byte logical blocks: (750 GB/699 GiB)
> Apr 20 07:08:02 rakete kernel: sd 10:0:0:2: Attached scsi generic sg8 type 0
> Apr 20 07:08:02 rakete kernel: sd 10:0:0:1: [sdj] Write Protect is off
> Apr 20 07:08:02 rakete kernel: sd 10:0:0:1: [sdj] Mode Sense: 67 00 10 08
> Apr 20 07:08:02 rakete kernel: sd 10:0:0:3: Attached scsi generic sg9 type 0
> Apr 20 07:08:02 rakete kernel: sd 10:0:0:2: [sdk] 976773168 512-byte logical blocks: (500 GB/466 GiB)
> Apr 20 07:08:02 rakete kernel: sd 10:0:0:1: [sdj] No Caching mode page found
> Apr 20 07:08:02 rakete kernel: sd 10:0:0:1: [sdj] Assuming drive cache: write through
> Apr 20 07:08:02 rakete kernel: sd 10:0:0:2: [sdk] Write Protect is off
> Apr 20 07:08:02 rakete kernel: sd 10:0:0:2: [sdk] Mode Sense: 67 00 10 08
> Apr 20 07:08:02 rakete kernel: sd 10:0:0:3: [sdl] 488395055 512-byte logical blocks: (250 GB/233 GiB)
> Apr 20 07:08:02 rakete kernel: sd 10:0:0:2: [sdk] No Caching mode page found
> Apr 20 07:08:02 rakete kernel: sd 10:0:0:2: [sdk] Assuming drive cache: write through
> Apr 20 07:08:02 rakete kernel: sd 10:0:0:3: [sdl] Write Protect is off
> Apr 20 07:08:02 rakete kernel: sd 10:0:0:3: [sdl] Mode Sense: 67 00 10 08
> Apr 20 07:08:02 rakete kernel: sd 10:0:0:3: [sdl] No Caching mode page found
> Apr 20 07:08:02 rakete kernel: sd 10:0:0:3: [sdl] Assuming drive cache: write through
> Apr 20 07:08:02 rakete kernel: sd 10:0:0:0: [sdf] Attached SCSI disk
> Apr 20 07:08:02 rakete kernel: sd 10:0:0:1: [sdj] Attached SCSI disk
> Apr 20 07:08:02 rakete kernel: sd 10:0:0:2: [sdk] Attached SCSI disk
> Apr 20 07:08:02 rakete kernel: sd 10:0:0:3: [sdl] Attached SCSI disk
> Apr 20 07:08:02 rakete kernel: EXT4-fs (sdf1): recovery complete
> Apr 20 07:08:02 rakete kernel: EXT4-fs (sdf1): mounted filesystem with ordered data mode. Opts: (null)
>
> ####
> still ro mode
> /dev/sdj on /mnt/raid1 type btrfs (ro,noatime,space_cache,autodefrag,subvolid=5,subvol=/)
> ####
> 14# btrfs fi show
> Label: none  uuid: 16d5891f-5d52-4b29-8591-588ddf11e73d
> 	Total devices 3 FS bytes used 1.60GiB
> 	devid    1 size 698.64GiB used 3.03GiB path /dev/sdj
> 	devid    2 size 465.76GiB used 3.03GiB path /dev/sdk
> 	devid    3 size 232.88GiB used 0.00B path /dev/sdl
> ####
>
>
>
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
>


