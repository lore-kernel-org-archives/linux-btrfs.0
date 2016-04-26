Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lf0-f50.google.com ([209.85.215.50]:35001 "EHLO
	mail-lf0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751907AbcDZPRA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 26 Apr 2016 11:17:00 -0400
Received: by mail-lf0-f50.google.com with SMTP id c126so22312763lfb.2
        for <linux-btrfs@vger.kernel.org>; Tue, 26 Apr 2016 08:16:59 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <nff6vr$odm$1@ger.gmane.org>
References: <nf1q0j$ug4$1@ger.gmane.org>
	<57148B2E.6010904@cn.fujitsu.com>
	<nf73cv$7vh$1@ger.gmane.org>
	<9ade4472-c99d-82a8-27c9-704b75bd87ab@cn.fujitsu.com>
	<nf9o32$7r4$1@ger.gmane.org>
	<180d89ae-32cf-ad59-2b6e-56ed82e9f439@cn.fujitsu.com>
	<nfb39q$iv0$1@ger.gmane.org>
	<1772508d-40b5-5303-8edb-29b5504216aa@cn.fujitsu.com>
	<nff6vr$odm$1@ger.gmane.org>
Date: Tue, 26 Apr 2016 17:16:57 +0200
Message-ID: <CAPmG0ja0i+WuBxO4UwKwO=t05br6_pdxQr54hFUJbCrvYgF7pQ@mail.gmail.com>
Subject: Re: Question: raid1 behaviour on failure
From: Henk Slager <eye1tm@gmail.com>
To: Matthias Bodenbinder <matthias@bodenbinder.de>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, Apr 23, 2016 at 9:07 AM, Matthias Bodenbinder
<matthias@bodenbinder.de> wrote:
>
> Here is my newest test. The backports provide a 4.5 kernel:
>
> ####
> kernel: 4.5.0-0.bpo.1-amd64
> btrfs-tools: 4.4-1~bpo8+1
> ####
>
> This time the raid1 is automatically unmounted after I unplug the device and it can not be mounted while the device is missing. See below.
>
> Matthias
>
>
> ####
> 1) turn on the Fantec case:
>
> Apr 23 08:45:38 rakete kernel: usb 3-1: new SuperSpeed USB device number 2 using xhci_hcd
> Apr 23 08:45:38 rakete kernel: usb 3-1: New USB device found, idVendor=152d, idProduct=0567
> Apr 23 08:45:38 rakete kernel: usb 3-1: New USB device strings: Mfr=10, Product=11, SerialNumber=5
> Apr 23 08:45:38 rakete kernel: usb 3-1: Product: USB to ATA/ATAPI Bridge
> Apr 23 08:45:38 rakete kernel: usb 3-1: Manufacturer: JMicron
> Apr 23 08:45:38 rakete kernel: usb 3-1: SerialNumber: 152D00539000
> Apr 23 08:45:38 rakete mtp-probe[3641]: checking bus 3, device 2: "/sys/devices/pci0000:00/0000:00:1c.5/0000:04:00.0/usb3/3-1"
> Apr 23 08:45:38 rakete mtp-probe[3641]: bus: 3, device: 2 was not an MTP device
> Apr 23 08:45:38 rakete kernel: usb-storage 3-1:1.0: USB Mass Storage device detected
> Apr 23 08:45:38 rakete kernel: usb-storage 3-1:1.0: Quirks match for vid 152d pid 0567: 5000000
> Apr 23 08:45:38 rakete kernel: scsi host8: usb-storage 3-1:1.0
> Apr 23 08:45:38 rakete kernel: usbcore: registered new interface driver usb-storage
> Apr 23 08:45:38 rakete kernel: usbcore: registered new interface driver uas
> Apr 23 08:45:39 rakete kernel: scsi 8:0:0:0: Direct-Access     WDC WD20 02FAEX-007BA0    0125 PQ: 0 ANSI: 6
> Apr 23 08:45:39 rakete kernel: scsi 8:0:0:1: Direct-Access     WDC WD75 00AACS-00C7B0    0125 PQ: 0 ANSI: 6
> Apr 23 08:45:39 rakete kernel: scsi 8:0:0:2: Direct-Access     WDC WD50 01AALS-00L3B2    0125 PQ: 0 ANSI: 6
> Apr 23 08:45:39 rakete kernel: scsi 8:0:0:3: Direct-Access     SAMSUNG  SP2504C          0125 PQ: 0 ANSI: 6
> Apr 23 08:45:39 rakete kernel: sd 8:0:0:0: Attached scsi generic sg6 type 0
> Apr 23 08:45:39 rakete kernel: sd 8:0:0:0: [sdf] 3907029168 512-byte logical blocks: (2.00 TB/1.82 TiB)
> Apr 23 08:45:39 rakete kernel: sd 8:0:0:1: Attached scsi generic sg7 type 0
> Apr 23 08:45:39 rakete kernel: sd 8:0:0:0: [sdf] Write Protect is off
> Apr 23 08:45:39 rakete kernel: sd 8:0:0:0: [sdf] Mode Sense: 67 00 10 08
> Apr 23 08:45:39 rakete kernel: sd 8:0:0:2: Attached scsi generic sg8 type 0
> Apr 23 08:45:39 rakete kernel: sd 8:0:0:1: [sdg] 1465149168 512-byte logical blocks: (750 GB/699 GiB)
> Apr 23 08:45:39 rakete kernel: sd 8:0:0:1: [sdg] Write Protect is off
> Apr 23 08:45:39 rakete kernel: sd 8:0:0:1: [sdg] Mode Sense: 67 00 10 08
> Apr 23 08:45:39 rakete kernel: sd 8:0:0:2: [sdh] 976773168 512-byte logical blocks: (500 GB/466 GiB)
> Apr 23 08:45:39 rakete kernel: sd 8:0:0:3: Attached scsi generic sg9 type 0
> Apr 23 08:45:39 rakete kernel: sd 8:0:0:1: [sdg] No Caching mode page found
> Apr 23 08:45:39 rakete kernel: sd 8:0:0:1: [sdg] Assuming drive cache: write through
> Apr 23 08:45:39 rakete kernel: sd 8:0:0:2: [sdh] Write Protect is off
> Apr 23 08:45:39 rakete kernel: sd 8:0:0:2: [sdh] Mode Sense: 67 00 10 08
> Apr 23 08:45:39 rakete kernel: sd 8:0:0:3: [sdi] 488395055 512-byte logical blocks: (250 GB/233 GiB)
> Apr 23 08:45:39 rakete kernel: sd 8:0:0:0: [sdf] No Caching mode page found
> Apr 23 08:45:39 rakete kernel: sd 8:0:0:0: [sdf] Assuming drive cache: write through
> Apr 23 08:45:39 rakete kernel: sd 8:0:0:3: [sdi] Write Protect is off
> Apr 23 08:45:39 rakete kernel: sd 8:0:0:3: [sdi] Mode Sense: 67 00 10 08
> Apr 23 08:45:39 rakete kernel: sd 8:0:0:2: [sdh] No Caching mode page found
> Apr 23 08:45:39 rakete kernel: sd 8:0:0:2: [sdh] Assuming drive cache: write through
> Apr 23 08:45:39 rakete kernel: sd 8:0:0:3: [sdi] No Caching mode page found
> Apr 23 08:45:39 rakete kernel: sd 8:0:0:3: [sdi] Assuming drive cache: write through
> Apr 23 08:45:39 rakete kernel:  sdf: sdf1
> Apr 23 08:45:39 rakete kernel: sd 8:0:0:0: [sdf] Attached SCSI disk
> Apr 23 08:45:39 rakete kernel: sd 8:0:0:1: [sdg] Attached SCSI disk
> Apr 23 08:45:40 rakete kernel: sd 8:0:0:2: [sdh] Attached SCSI disk
> Apr 23 08:45:40 rakete kernel: sd 8:0:0:3: [sdi] Attached SCSI disk
> Apr 23 08:45:40 rakete kernel: BTRFS: device fsid 16d5891f-5d52-4b29-8591-588ddf11e73d devid 1 transid 89 /dev/sdg
> Apr 23 08:45:40 rakete kernel: BTRFS: device fsid 16d5891f-5d52-4b29-8591-588ddf11e73d devid 2 transid 89 /dev/sdh
> Apr 23 08:45:40 rakete kernel: BTRFS: device fsid 16d5891f-5d52-4b29-8591-588ddf11e73d devid 3 transid 89 /dev/sdi
> Apr 23 08:45:40 rakete kernel: EXT4-fs (sdf1): mounted filesystem with ordered data mode. Opts: (null)
> Apr 23 08:45:40 rakete udisksd[2422]: Mounted /dev/sdf1 at /media/matthias/BACKUP on behalf of uid 1000
>
> ####
>
> 7# mount /mnt/raid1/
>
> Apr 23 08:47:31 rakete kernel: BTRFS info (device sdi): enabling auto defrag
> Apr 23 08:47:31 rakete kernel: BTRFS info (device sdi): disk space caching is enabled
> Apr 23 08:47:31 rakete kernel: BTRFS: has skinny extents
>
> 8# btrfs fi show
> Label: none  uuid: 16d5891f-5d52-4b29-8591-588ddf11e73d
>         Total devices 3 FS bytes used 1.60GiB
>         devid    1 size 698.64GiB used 3.03GiB path /dev/sdg
>         devid    2 size 465.76GiB used 3.03GiB path /dev/sdh
>         devid    3 size 232.88GiB used 0.00B path /dev/sdi
>
> 9# ls -l /mnt/raid1/
> total 0
> drwxrwxr-x 1 root root   36 Nov 14  2014 AfterShot2(64-bit)
> drwxrwxr-x 1 root root 5082 Apr 17 09:06 etc
> drwxr-xr-x 1 root root  108 Mar 24 07:31 var
>
> ####
>
> Unplug the biggest HD
>
> Apr 23 08:51:29 rakete kernel: usb 3-1: USB disconnect, device number 2
> Apr 23 08:51:29 rakete kernel: Buffer I/O error on dev sdf1, logical block 243826688, lost sync page write
> Apr 23 08:51:29 rakete kernel: JBD2: Error -5 detected when updating journal superblock for sdf1-8.
> Apr 23 08:51:29 rakete kernel: Aborting journal on device sdf1-8.
> Apr 23 08:51:29 rakete kernel: Buffer I/O error on dev sdf1, logical block 243826688, lost sync page write
> Apr 23 08:51:29 rakete kernel: JBD2: Error -5 detected when updating journal superblock for sdf1-8.
> Apr 23 08:51:29 rakete kernel: BTRFS error (device sdi): bdev /dev/sdh errs: wr 0, rd 1, flush 0, corrupt 0, gen 0
> Apr 23 08:51:29 rakete kernel: BTRFS error (device sdi): bdev /dev/sdh errs: wr 0, rd 3, flush 0, corrupt 0, gen 0
> Apr 23 08:51:29 rakete kernel: BTRFS error (device sdi): bdev /dev/sdh errs: wr 0, rd 3, flush 0, corrupt 0, gen 0
> Apr 23 08:51:29 rakete kernel: BTRFS error (device sdi): bdev /dev/sdh errs: wr 0, rd 4, flush 0, corrupt 0, gen 0
> Apr 23 08:51:29 rakete kernel: BTRFS error (device sdi): bdev /dev/sdh errs: wr 0, rd 5, flush 0, corrupt 0, gen 0
> Apr 23 08:51:29 rakete kernel: BTRFS error (device sdi): bdev /dev/sdh errs: wr 0, rd 6, flush 0, corrupt 0, gen 0
> Apr 23 08:51:29 rakete kernel: BTRFS error (device sdi): bdev /dev/sdh errs: wr 0, rd 7, flush 0, corrupt 0, gen 0
> Apr 23 08:51:29 rakete kernel: BTRFS error (device sdi): bdev /dev/sdh errs: wr 0, rd 8, flush 0, corrupt 0, gen 0
> Apr 23 08:51:29 rakete kernel: BTRFS error (device sdi): bdev /dev/sdh errs: wr 0, rd 9, flush 0, corrupt 0, gen 0
> Apr 23 08:51:29 rakete kernel: BTRFS error (device sdi): bdev /dev/sdh errs: wr 0, rd 10, flush 0, corrupt 0, gen 0
> Apr 23 08:51:29 rakete kernel: BTRFS error (device sdi): error reading free space cache
> Apr 23 08:51:29 rakete kernel: BTRFS warning (device sdi): failed to load free space cache for block group 20497563648, rebuilding it now
> Apr 23 08:51:29 rakete kernel: BTRFS error (device sdi): error reading free space cache
> Apr 23 08:51:29 rakete kernel: BTRFS warning (device sdi): failed to load free space cache for block group 21571305472, rebuilding it now
> Apr 23 08:51:29 rakete kernel: BTRFS: error (device sdi) in btrfs_commit_transaction:2142: errno=-5 IO failure (Error while writing out transaction)
> Apr 23 08:51:29 rakete kernel: BTRFS info (device sdi): forced readonly
> Apr 23 08:51:29 rakete kernel: BTRFS warning (device sdi): Skipping commit of aborted transaction.
> Apr 23 08:51:29 rakete kernel: ------------[ cut here ]------------
> Apr 23 08:51:29 rakete kernel: WARNING: CPU: 1 PID: 4277 at /build/linux-Ki7dwx/linux-4.5.1/fs/btrfs/transaction.c:1764 cleanup_transaction+0x96/0x300 [btrfs]()
> Apr 23 08:51:29 rakete kernel: BTRFS: Transaction aborted (error -5)
> Apr 23 08:51:29 rakete kernel: Modules linked in: uas(E) usb_storage(E) pci_stub(E) vboxpci(OE) vboxnetadp(OE) vboxnetflt(OE) binfmt_misc(E) dvb_ttpci(E) saa7146_vv(E) ttpci_eeprom(E) saa7146(E) videobuf_dma_sg(E) videobuf_core(E) dvb_core(E) v4l2_common(E) videodev(E) media(E) cfg80211(E) vboxdrv(OE) cpufreq_powersave(E) cpufreq_conservative(E) cpufreq_userspace(E) cpufreq_stats(E) snd_hda_codec_hdmi(E) intel_rapl(E) x86_pkg_temp_thermal(E) intel_powerclamp(E) coretemp(E) kvm_intel(E) kvm(E) irqbypass(E) crct10dif_pclmul(E) crc32_pclmul(E) ghash_clmulni_intel(E) drbg(E) ansi_cprng(E) eeepc_wmi(E) asus_wmi(E) sparse_keymap(E) iTCO_wdt(E) joydev(E) iTCO_vendor_support(E) rfkill(E) aesni_intel(E) aes_x86_64(E) lrw(E) gf128mul(E) glue_helper(E) ablk_helper(E) cryptd(E) snd_hda_codec_realtek(E) pcspkr(E) snd_hda_codec_generic(E)
> Apr 23 08:51:29 rakete kernel:  serio_raw(E) i2c_i801(E) lpc_ich(E) mfd_core(E) snd_hda_intel(E) snd_hda_codec(E) snd_hda_core(E) snd_hwdep(E) snd_pcm(E) evdev(E) battery(E) snd_timer(E) 8250_fintek(E) snd(E) mei_me(E) soundcore(E) mei(E) shpchp(E) tpm_tis(E) tpm(E) processor(E) nvidia(POE) drm(E) fuse(E) ecryptfs(E) cbc(E) hmac(E) encrypted_keys(E) parport_pc(E) ppdev(E) lp(E) parport(E) autofs4(E) ext4(E) crc16(E) mbcache(E) jbd2(E) btrfs(E) raid456(E) async_raid6_recov(E) async_memcpy(E) async_pq(E) async_xor(E) async_tx(E) xor(E) hid_generic(E) usbhid(E) hid(E) raid6_pq(E) libcrc32c(E) crc32c_generic(E) md_mod(E) dm_mirror(E) dm_region_hash(E) dm_log(E) dm_mod(E) sg(E) sr_mod(E) cdrom(E) sd_mod(E) ata_generic(E) ahci(E) pata_via(E) libahci(E) crc32c_intel(E) xhci_pci(E) ehci_pci(E) psmouse(E) libata(E) xhci_hcd(E)
> Apr 23 08:51:29 rakete kernel:  ehci_hcd(E) atl1c(E) scsi_mod(E) usbcore(E) usb_common(E) wmi(E) fan(E) thermal(E) fjes(E) video(E) button(E)
> Apr 23 08:51:29 rakete kernel: CPU: 1 PID: 4277 Comm: umount Tainted: P           OE   4.5.0-0.bpo.1-amd64 #1 Debian 4.5.1-1~bpo8+1
> Apr 23 08:51:29 rakete kernel: Hardware name: System manufacturer System Product Name/P8H67-V, BIOS 3707 07/12/2013
> Apr 23 08:51:29 rakete kernel:  0000000000000286 00000000bfe9047d ffffffff813099f5 ffff8801c1103ca8
> Apr 23 08:51:29 rakete kernel:  ffffffffc03a8c98 ffffffff81079a61 ffff880214562d90 ffff8801c1103d00
> Apr 23 08:51:29 rakete kernel:  ffff8801c5165980 00000000fffffffb ffff880214562d90 ffffffff81079aec
> Apr 23 08:51:29 rakete kernel: Call Trace:
> Apr 23 08:51:29 rakete kernel:  [<ffffffff813099f5>] ? dump_stack+0x5c/0x77
> Apr 23 08:51:29 rakete kernel:  [<ffffffff81079a61>] ? warn_slowpath_common+0x81/0xb0
> Apr 23 08:51:29 rakete kernel:  [<ffffffff81079aec>] ? warn_slowpath_fmt+0x5c/0x80
> Apr 23 08:51:29 rakete kernel:  [<ffffffffc0320e46>] ? cleanup_transaction+0x96/0x300 [btrfs]
> Apr 23 08:51:29 rakete kernel:  [<ffffffff810b94a0>] ? wait_woken+0x90/0x90
> Apr 23 08:51:29 rakete kernel:  [<ffffffffc0321bf3>] ? btrfs_commit_transaction+0x2b3/0xa30 [btrfs]
> Apr 23 08:51:29 rakete kernel:  [<ffffffffc0322406>] ? start_transaction+0x96/0x4d0 [btrfs]
> Apr 23 08:51:29 rakete kernel:  [<ffffffffc031d0d2>] ? close_ctree+0x2b2/0x360 [btrfs]
> Apr 23 08:51:29 rakete kernel:  [<ffffffff81206fd7>] ? evict_inodes+0x147/0x170
> Apr 23 08:51:29 rakete kernel:  [<ffffffff811eda39>] ? generic_shutdown_super+0x69/0xf0
> Apr 23 08:51:29 rakete kernel:  [<ffffffff811edace>] ? kill_anon_super+0xe/0x20
> Apr 23 08:51:29 rakete kernel:  [<ffffffffc02f1603>] ? btrfs_kill_super+0x13/0x100 [btrfs]
> Apr 23 08:51:29 rakete kernel:  [<ffffffff811ed4c4>] ? deactivate_locked_super+0x34/0x60
> Apr 23 08:51:29 rakete kernel:  [<ffffffff81209d5b>] ? cleanup_mnt+0x3b/0x80
> Apr 23 08:51:29 rakete kernel:  [<ffffffff81096114>] ? task_work_run+0x74/0x90
> Apr 23 08:51:29 rakete kernel:  [<ffffffff8100334a>] ? exit_to_usermode_loop+0xba/0xc0
> Apr 23 08:51:29 rakete kernel:  [<ffffffff81003bcf>] ? syscall_return_slowpath+0x8f/0x110
> Apr 23 08:51:29 rakete kernel:  [<ffffffff815b9918>] ? int_ret_from_sys_call+0x25/0x8f
> Apr 23 08:51:29 rakete kernel: ---[ end trace 6bbe2b6d20973e0e ]---
> Apr 23 08:51:29 rakete kernel: BTRFS: error (device sdi) in cleanup_transaction:1764: errno=-5 IO failure
> Apr 23 08:51:29 rakete kernel: BTRFS info (device sdi): delayed_refs has NO entry
> Apr 23 08:51:29 rakete kernel: BTRFS error (device sdi): commit super ret -5
> Apr 23 08:51:29 rakete kernel: BTRFS error (device sdi): cleaner transaction attach returned -30
>
> ....

In this 19 (or less) seconds the linux system decides to unmount the
btrfs raid1 filesystem (as all its devices have disappeared). I am
wondering if this is done directly by the kernel or is it udisksd that
initiates this?

>
> Apr 23 08:51:48 rakete kernel: usb 3-1: new SuperSpeed USB device number 3 using xhci_hcd
> Apr 23 08:51:48 rakete kernel: usb 3-1: New USB device found, idVendor=152d, idProduct=0567
> Apr 23 08:51:48 rakete kernel: usb 3-1: New USB device strings: Mfr=10, Product=11, SerialNumber=5
> Apr 23 08:51:48 rakete kernel: usb 3-1: Product: USB to ATA/ATAPI Bridge
> Apr 23 08:51:48 rakete kernel: usb 3-1: Manufacturer: JMicron
> Apr 23 08:51:48 rakete kernel: usb 3-1: SerialNumber: 152D00539000
> Apr 23 08:51:48 rakete kernel: usb-storage 3-1:1.0: USB Mass Storage device detected
> Apr 23 08:51:48 rakete kernel: usb-storage 3-1:1.0: Quirks match for vid 152d pid 0567: 5000000
> Apr 23 08:51:48 rakete kernel: scsi host9: usb-storage 3-1:1.0
> Apr 23 08:51:48 rakete mtp-probe[4301]: checking bus 3, device 3: "/sys/devices/pci0000:00/0000:00:1c.5/0000:04:00.0/usb3/3-1"
> Apr 23 08:51:48 rakete mtp-probe[4301]: bus: 3, device: 3 was not an MTP device
> Apr 23 08:51:49 rakete kernel: scsi 9:0:0:0: Direct-Access     WDC WD20 02FAEX-007BA0    0125 PQ: 0 ANSI: 6
> Apr 23 08:51:49 rakete kernel: scsi 9:0:0:1: Direct-Access     WDC WD50 01AALS-00L3B2    0125 PQ: 0 ANSI: 6
> Apr 23 08:51:49 rakete kernel: scsi 9:0:0:2: Direct-Access     SAMSUNG  SP2504C          0125 PQ: 0 ANSI: 6
> Apr 23 08:51:49 rakete kernel: sd 9:0:0:0: Attached scsi generic sg6 type 0
> Apr 23 08:51:49 rakete kernel: sd 9:0:0:1: Attached scsi generic sg7 type 0
> Apr 23 08:51:49 rakete kernel: sd 9:0:0:0: [sdf] 3907029168 512-byte logical blocks: (2.00 TB/1.82 TiB)
> Apr 23 08:51:49 rakete kernel: sd 9:0:0:2: Attached scsi generic sg8 type 0
> Apr 23 08:51:49 rakete kernel: sd 9:0:0:0: [sdf] Write Protect is off
> Apr 23 08:51:49 rakete kernel: sd 9:0:0:0: [sdf] Mode Sense: 67 00 10 08
> Apr 23 08:51:49 rakete kernel: sd 9:0:0:1: [sdg] 976773168 512-byte logical blocks: (500 GB/466 GiB)
> Apr 23 08:51:49 rakete kernel: sd 9:0:0:0: [sdf] No Caching mode page found
> Apr 23 08:51:49 rakete kernel: sd 9:0:0:0: [sdf] Assuming drive cache: write through
> Apr 23 08:51:49 rakete kernel: sd 9:0:0:1: [sdg] Write Protect is off
> Apr 23 08:51:49 rakete kernel: sd 9:0:0:1: [sdg] Mode Sense: 67 00 10 08
> Apr 23 08:51:49 rakete kernel: sd 9:0:0:2: [sdh] 488395055 512-byte logical blocks: (250 GB/233 GiB)
> Apr 23 08:51:49 rakete kernel: sd 9:0:0:1: [sdg] No Caching mode page found
> Apr 23 08:51:49 rakete kernel: sd 9:0:0:1: [sdg] Assuming drive cache: write through
> Apr 23 08:51:49 rakete kernel: sd 9:0:0:2: [sdh] Write Protect is off
> Apr 23 08:51:49 rakete kernel: sd 9:0:0:2: [sdh] Mode Sense: 67 00 10 08
> Apr 23 08:51:49 rakete kernel: sd 9:0:0:2: [sdh] No Caching mode page found
> Apr 23 08:51:49 rakete kernel: sd 9:0:0:2: [sdh] Assuming drive cache: write through
> Apr 23 08:51:49 rakete kernel:  sdf: sdf1
> Apr 23 08:51:49 rakete kernel: sd 9:0:0:0: [sdf] Attached SCSI disk
> Apr 23 08:51:49 rakete kernel: sd 9:0:0:1: [sdg] Attached SCSI disk
> Apr 23 08:51:49 rakete kernel: sd 9:0:0:2: [sdh] Attached SCSI disk
> Apr 23 08:51:49 rakete udisksd[2422]: Mounted /dev/sdf1 at /media/matthias/BACKUP on behalf of uid 1000
> Apr 23 08:51:49 rakete kernel: EXT4-fs (sdf1): recovery complete
> Apr 23 08:51:49 rakete kernel: EXT4-fs (sdf1): mounted filesystem with ordered data mode. Opts: (null)
>
> ####
>
> 10# btrfs fi show
> warning, device 1 is missing
> warning devid 1 not found already
> Label: none  uuid: 16d5891f-5d52-4b29-8591-588ddf11e73d
>         Total devices 3 FS bytes used 1.60GiB
>         devid    2 size 465.76GiB used 3.03GiB path /dev/sdg
>         devid    3 size 232.88GiB used 0.00B path /dev/sdh
>         *** Some devices missing
>
> ####
> This time the raid1 is in state "unmounted" after removing the device. This is different to what I found with kernel 4.4.
>
> 12# ls -l /mnt/raid1/
> total 0
>
> ####
> Trying to mount it again:
>
> 14# mount /mnt/raid1/
> mount: wrong fs type, bad option, bad superblock on /dev/sdh,
>        missing codepage or helper program, or other error
>
>        In some cases useful info is found in syslog - try
>        dmesg | tail or so.
> ####
>
> Apr 23 08:54:35 rakete kernel: BTRFS info (device sdh): enabling auto defrag
> Apr 23 08:54:35 rakete kernel: BTRFS info (device sdh): disk space caching is enabled
> Apr 23 08:54:35 rakete kernel: BTRFS: has skinny extents
> Apr 23 08:54:35 rakete kernel: BTRFS: failed to read the system array on sdh
> Apr 23 08:54:35 rakete kernel: BTRFS: open_ctree failed
>
> ####
>
> Plugin the device again.
>
> Apr 23 08:55:44 rakete kernel: usb 3-1: USB disconnect, device number 3
> Apr 23 08:56:06 rakete kernel: usb 3-1: new SuperSpeed USB device number 4 using xhci_hcd
> Apr 23 08:56:06 rakete kernel: usb 3-1: New USB device found, idVendor=152d, idProduct=0567
> Apr 23 08:56:06 rakete kernel: usb 3-1: New USB device strings: Mfr=10, Product=11, SerialNumber=5
> Apr 23 08:56:06 rakete kernel: usb 3-1: Product: USB to ATA/ATAPI Bridge
> Apr 23 08:56:06 rakete kernel: usb 3-1: Manufacturer: JMicron
> Apr 23 08:56:06 rakete kernel: usb 3-1: SerialNumber: 152D00539000
> Apr 23 08:56:06 rakete kernel: usb-storage 3-1:1.0: USB Mass Storage device detected
> Apr 23 08:56:06 rakete kernel: usb-storage 3-1:1.0: Quirks match for vid 152d pid 0567: 5000000
> Apr 23 08:56:06 rakete kernel: scsi host10: usb-storage 3-1:1.0
> Apr 23 08:56:06 rakete mtp-probe[4751]: checking bus 3, device 4: "/sys/devices/pci0000:00/0000:00:1c.5/0000:04:00.0/usb3/3-1"
> Apr 23 08:56:06 rakete mtp-probe[4751]: bus: 3, device: 4 was not an MTP device
> Apr 23 08:56:07 rakete kernel: scsi 10:0:0:0: Direct-Access     WDC WD20 02FAEX-007BA0    0125 PQ: 0 ANSI: 6
> Apr 23 08:56:07 rakete kernel: scsi 10:0:0:1: Direct-Access     WDC WD75 00AACS-00C7B0    0125 PQ: 0 ANSI: 6
> Apr 23 08:56:07 rakete kernel: scsi 10:0:0:2: Direct-Access     WDC WD50 01AALS-00L3B2    0125 PQ: 0 ANSI: 6
> Apr 23 08:56:07 rakete kernel: scsi 10:0:0:3: Direct-Access     SAMSUNG  SP2504C          0125 PQ: 0 ANSI: 6
> Apr 23 08:56:07 rakete kernel: sd 10:0:0:0: Attached scsi generic sg6 type 0
> Apr 23 08:56:07 rakete kernel: sd 10:0:0:0: [sdf] 3907029168 512-byte logical blocks: (2.00 TB/1.82 TiB)
> Apr 23 08:56:07 rakete kernel: sd 10:0:0:0: [sdf] Write Protect is off
> Apr 23 08:56:07 rakete kernel: sd 10:0:0:0: [sdf] Mode Sense: 67 00 10 08
> Apr 23 08:56:07 rakete kernel: sd 10:0:0:1: Attached scsi generic sg7 type 0
> Apr 23 08:56:07 rakete kernel: sd 10:0:0:0: [sdf] No Caching mode page found
> Apr 23 08:56:07 rakete kernel: sd 10:0:0:0: [sdf] Assuming drive cache: write through
> Apr 23 08:56:07 rakete kernel: sd 10:0:0:2: Attached scsi generic sg8 type 0
> Apr 23 08:56:07 rakete kernel: sd 10:0:0:1: [sdg] 1465149168 512-byte logical blocks: (750 GB/699 GiB)
> Apr 23 08:56:07 rakete kernel: sd 10:0:0:3: Attached scsi generic sg9 type 0
> Apr 23 08:56:07 rakete kernel: sd 10:0:0:1: [sdg] Write Protect is off
> Apr 23 08:56:07 rakete kernel: sd 10:0:0:1: [sdg] Mode Sense: 67 00 10 08
> Apr 23 08:56:07 rakete kernel: sd 10:0:0:2: [sdh] 976773168 512-byte logical blocks: (500 GB/466 GiB)
> Apr 23 08:56:07 rakete kernel: sd 10:0:0:1: [sdg] No Caching mode page found
> Apr 23 08:56:07 rakete kernel: sd 10:0:0:1: [sdg] Assuming drive cache: write through
> Apr 23 08:56:07 rakete kernel: sd 10:0:0:3: [sdi] 488395055 512-byte logical blocks: (250 GB/233 GiB)
> Apr 23 08:56:07 rakete kernel: sd 10:0:0:2: [sdh] Write Protect is off
> Apr 23 08:56:07 rakete kernel: sd 10:0:0:2: [sdh] Mode Sense: 67 00 10 08
> Apr 23 08:56:07 rakete kernel: sd 10:0:0:3: [sdi] Write Protect is off
> Apr 23 08:56:07 rakete kernel: sd 10:0:0:3: [sdi] Mode Sense: 67 00 10 08
> Apr 23 08:56:07 rakete kernel: sd 10:0:0:2: [sdh] No Caching mode page found
> Apr 23 08:56:07 rakete kernel: sd 10:0:0:2: [sdh] Assuming drive cache: write through
> Apr 23 08:56:07 rakete kernel: sd 10:0:0:3: [sdi] No Caching mode page found
> Apr 23 08:56:07 rakete kernel: sd 10:0:0:3: [sdi] Assuming drive cache: write through
> Apr 23 08:56:07 rakete kernel:  sdf: sdf1
> Apr 23 08:56:07 rakete kernel: sd 10:0:0:0: [sdf] Attached SCSI disk
> Apr 23 08:56:07 rakete kernel: sd 10:0:0:1: [sdg] Attached SCSI disk
> Apr 23 08:56:07 rakete kernel: sd 10:0:0:2: [sdh] Attached SCSI disk
> Apr 23 08:56:07 rakete kernel: sd 10:0:0:3: [sdi] Attached SCSI disk
> Apr 23 08:56:07 rakete kernel: BTRFS: device fsid 16d5891f-5d52-4b29-8591-588ddf11e73d devid 1 transid 89 /dev/sdg
> Apr 23 08:56:07 rakete kernel: BTRFS: device fsid 16d5891f-5d52-4b29-8591-588ddf11e73d devid 2 transid 89 /dev/sdh
> Apr 23 08:56:07 rakete kernel: BTRFS: device fsid 16d5891f-5d52-4b29-8591-588ddf11e73d devid 3 transid 89 /dev/sdi
> Apr 23 08:56:07 rakete kernel: EXT4-fs (sdf1): recovery complete
> Apr 23 08:56:07 rakete kernel: EXT4-fs (sdf1): mounted filesystem with ordered data mode. Opts: (null)
>
> ####
>
> 15# btrfs fi show
> Label: none  uuid: 16d5891f-5d52-4b29-8591-588ddf11e73d
>         Total devices 3 FS bytes used 1.60GiB
>         devid    1 size 698.64GiB used 3.03GiB path /dev/sdg
>         devid    2 size 465.76GiB used 3.03GiB path /dev/sdh
>         devid    3 size 232.88GiB used 0.00B path /dev/sdi
>
> ####
>
> 18# mount /mnt/raid1/
>
> Apr 23 08:57:00 rakete kernel: BTRFS info (device sdi): enabling auto defrag
> Apr 23 08:57:00 rakete kernel: BTRFS info (device sdi): disk space caching is enabled
> Apr 23 08:57:00 rakete kernel: BTRFS: has skinny extents
>
> ####
>
> 19# ls -l /mnt/raid1/
> total 0
> drwxrwxr-x 1 root root   36 Nov 14  2014 AfterShot2(64-bit)
> drwxrwxr-x 1 root root 5082 Apr 17 09:06 etc
> drwxr-xr-x 1 root root  108 Mar 24 07:31 var
>
> ####
>
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
