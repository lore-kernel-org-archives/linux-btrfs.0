Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wm0-f52.google.com ([74.125.82.52]:37378 "EHLO
	mail-wm0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752058AbcF0W0V (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 27 Jun 2016 18:26:21 -0400
Received: by mail-wm0-f52.google.com with SMTP id a66so2205107wme.0
        for <linux-btrfs@vger.kernel.org>; Mon, 27 Jun 2016 15:26:07 -0700 (PDT)
Received: from system (dslb-094-217-100-036.094.217.pools.vodafone-ip.de. [94.217.100.36])
        by smtp.gmail.com with ESMTPSA id x83sm3801729wmx.9.2016.06.27.15.26.04
        for <linux-btrfs@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 27 Jun 2016 15:26:05 -0700 (PDT)
Date: Tue, 28 Jun 2016 00:26:02 +0200
From: Saint Germain <saintger@gmail.com>
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Subject: Re: Kernel bug during RAID1 replace
Message-ID: <20160628002602.022258bf@system>
In-Reply-To: <CAJCQCtT_vbOzbvMOuV6wgvz4iMHcpQmAhX-y1-dkOi6F323KRg@mail.gmail.com>
References: <20160627233612.662d2a9a@system>
	<CAJCQCtT_vbOzbvMOuV6wgvz4iMHcpQmAhX-y1-dkOi6F323KRg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, 27 Jun 2016 15:42:42 -0600, Chris Murphy
<lists@colorremedies.com> wrote :

> On Mon, Jun 27, 2016 at 3:36 PM, Saint Germain <saintger@gmail.com>
> wrote:
> > Hello,
> >
> > I am on Debian Jessie with a kernel from backports:
> > 4.6.0-0.bpo.1-amd64
> >
> > I am also using btrfs-tools 4.4.1-1.1~bpo8+1
> >
> > When trying to replace a RAID1 drive (with btrfs replace start
> > -f /dev/sda1 /dev/sdd1), the operation is cancelled after completing
> > only 5%.
> >
> > I got this error in the /var/log/syslog:
> > ------------[ cut here ]------------
> > WARNING: CPU: 2 PID: 2617
> > at /build/linux-9LouV5/linux-4.6.1/fs/btrfs/dev-replace.c:430
> > btrfs_dev_replace_start+0x2be/0x400 [btrfs] Modules linked in:
> > uas(E) usb_storage(E) bnep(E) ftdi_sio(E) usbserial(E)
> > snd_hda_codec_hdmi(E) nls_utf8(E) nls_cp437(E) vfat(E) fat(E)
> > intel_rapl(E) x86_pkg_temp_thermal(E) intel_powerclamp(E)
> > coretemp(E) kvm_intel(E) kvm(E) iTCO_wdt(E) irqbypass(E)
> > iTCO_vendor_support(E) crct10dif_pclmul(E) crc32_pclmul(E)
> > ghash_clmulni_intel(E) hmac(E) drbg(E) ansi_cprng(E) aesni_intel(E)
> > aes_x86_64(E) lrw(E) gf128mul(E) glue_helper(E) ablk_helper(E)
> > cryptd(E) wl(POE) btusb(E) btrtl(E) btbcm(E) btintel(E) cfg80211(E)
> > bluetooth(E) efi_pstore(E) snd_hda_codec_realtek(E) evdev(E)
> > crc16(E) serio_raw(E) pcspkr(E) efivars(E) joydev(E)
> > snd_hda_codec_generic(E) rfkill(E) snd_hda_intel(E) nuvoton_cir(E)
> > rc_core(E) snd_hda_codec(E) i915(E) battery(E) snd_hda_core(E)
> > snd_hwdep(E) soc_button_array(E) tpm_tis(E) drm_kms_helper(E)
> > intel_smartconnect(E) snd_pcm(E) tpm(E) video(E) i2c_i801(E)
> > snd_timer(E) drm(E) snd(E) lpc_ich(E) i2c_algo_bit(E) soundcore(E)
> > mfd_core(E) mei_me(E) processor(E) button(E) mei(E) shpchp(E)
> > fuse(E) autofs4(E) hid_logitech_hidpp(E) btrfs(E)
> > hid_logitech_dj(E) usbhid(E) hid(E) xor(E) raid6_pq(E) sg(E)
> > sr_mod(E) cdrom(E) sd_mod(E) crc32c_intel(E) ahci(E) libahci(E)
> > libata(E) psmouse(E) scsi_mod(E) xhci_pci(E) ehci_pci(E)
> > xhci_hcd(E) ehci_hcd(E) e1000e(E) usbcore(E) ptp(E) pps_core(E)
> > usb_common(E) fjes(E) CPU: 2 PID: 2617 Comm: btrfs Tainted:
> > P           OE   4.6.0-0.bpo.1-amd64 #1 Debian 4.6.1-1~bpo8+1
> > Hardware name: To Be Filled By O.E.M. To Be Filled By
> > O.E.M./Z87E-ITX, BIOS P2.10 10/04/2013 0000000000000286
> > 00000000f0ba7fe7 ffffffff813123c5 0000000000000000 0000000000000000
> > ffffffff8107af94 ffff880186caf000 00000000fffffffb ffff8800c76b0800
> > ffff8800cae70000 ffff8800cae70ee0 00007ffdd5397d98 Call Trace:
> > [<ffffffff813123c5>] ? dump_stack+0x5c/0x77 [<ffffffff8107af94>] ?
> > __warn+0xc4/0xe0 [<ffffffffc030990e>] ?
> > btrfs_dev_replace_start+0x2be/0x400 [btrfs] [<ffffffffc02d24f2>] ?
> > btrfs_ioctl+0x1d42/0x2190 [btrfs] [<ffffffff811a8e2d>] ?
> > handle_mm_fault+0x154d/0x1cb0 [<ffffffff81205379>] ?
> > do_vfs_ioctl+0x99/0x5d0 [<ffffffff81205926>] ? SyS_ioctl+0x76/0x90
> > [<ffffffff815c83b6>] ? system_call_fast_compare_end+0xc/0x96
> > ---[ end trace 9fbfaa137cc5a72a ]---
> >
> >
> >
> > What should I do to replace correctly my drive ?
> 
> I don't often see handle_mm_fault with btrfs problems, maybe the
> entire dmesg from mounting the fs and including btrfs replace would
> reveal a related problem that instigates the failure?
> 
> If the device being replaced is acting unreliably, then you'd want to
> use -r with replace to ignore that device unless it's absolutely
> necessary to read from it.
> 

Thanks for your help.

Ok here is the log from the mounting, and including btrfs replace
(btrfs replace start -f /dev/sda1 /dev/sdd1 /home):

BTRFS info (device sdb1): disk space caching is enabled
BTRFS info (device sdb1): bdev /dev/sdb1 errs: wr 11881695, rd 12, flush 7928, corrupt 1705631, gen 1335
BTRFS info (device sdb1): bdev /dev/sda1 errs: wr 0, rd 0, flush 0, corrupt 14220, gen 24
BTRFS info (device sdb1): dev_replace from /dev/sda1 (devid 1) to /dev/sdd1 started
scrub_handle_errored_block: 166 callbacks suppressed
BTRFS warning (device sdb1): checksum error at logical 93445255168 on dev /dev/sda1, sector 77669048, root 5, inode 3434831, offset 479232, length 4096, links 1 (path: user/.local/share/zeitgeist/activity.sqlite-wal)
btrfs_dev_stat_print_on_error: 166 callbacks suppressed
BTRFS error (device sdb1): bdev /dev/sda1 errs: wr 0, rd 0, flush 0, corrupt 14221, gen 24
scrub_handle_errored_block: 166 callbacks suppressed
BTRFS error (device sdb1): unable to fixup (regular) error at logical 93445255168 on dev /dev/sda1
BTRFS error (device sdb1): bdev /dev/sda1 errs: wr 0, rd 0, flush 0, corrupt 14222, gen 24
BTRFS error (device sdb1): unable to fixup (regular) error at logical 93445259264 on dev /dev/sda1
BTRFS warning (device sdb1): checksum error at logical 136349810688 on dev /dev/sda1, sector 140429952, root 5, inode 4265283, offset 0, length 4096, links 1 (path: user/Pictures/Picture-42-2.jpg)
BTRFS error (device sdb1): bdev /dev/sda1 errs: wr 0, rd 0, flush 0, corrupt 14223, gen 24
BTRFS error (device sdb1): unable to fixup (regular) error at logical 136349810688 on dev /dev/sda1
BTRFS warning (device sdb1): checksum error at logical 136349814784 on dev /dev/sda1, sector 140429960, root 5, inode 4265283, offset 4096, length 4096, links 1 (path: user/Pictures/Picture-42-2.jpg)
BTRFS error (device sdb1): bdev /dev/sda1 errs: wr 0, rd 0, flush 0, corrupt 14224, gen 24
BTRFS error (device sdb1): unable to fixup (regular) error at logical 136349814784 on dev /dev/sda1
BTRFS warning (device sdb1): checksum error at logical 136349818880 on dev /dev/sda1, sector 140429968, root 5, inode 4265283, offset 8192, length 4096, links 1 (path: user/Pictures/Picture-42-2.jpg)
BTRFS error (device sdb1): bdev /dev/sda1 errs: wr 0, rd 0, flush 0, corrupt 14225, gen 24
BTRFS error (device sdb1): unable to fixup (regular) error at logical 136349818880 on dev /dev/sda1
BTRFS warning (device sdb1): checksum error at logical 136349822976 on dev /dev/sda1, sector 140429976, root 5, inode 4265283, offset 12288, length 4096, links 1 (path: user/Pictures/Picture-42-2.jpg)
BTRFS error (device sdb1): bdev /dev/sda1 errs: wr 0, rd 0, flush 0, corrupt 14226, gen 24
BTRFS error (device sdb1): unable to fixup (regular) error at logical 136349822976 on dev /dev/sda1
BTRFS warning (device sdb1): checksum error at logical 136349827072 on dev /dev/sda1, sector 140429984, root 5, inode 4265283, offset 16384, length 4096, links 1 (path: user/Pictures/Picture-42-2.jpg)
BTRFS error (device sdb1): bdev /dev/sda1 errs: wr 0, rd 0, flush 0, corrupt 14227, gen 24
BTRFS error (device sdb1): unable to fixup (regular) error at logical 136349827072 on dev /dev/sda1
BTRFS warning (device sdb1): checksum error at logical 136349831168 on dev /dev/sda1, sector 140429992, root 5, inode 4265283, offset 20480, length 4096, links 1 (path: user/Pictures/Picture-42-2.jpg)
BTRFS error (device sdb1): bdev /dev/sda1 errs: wr 0, rd 0, flush 0, corrupt 14228, gen 24
BTRFS error (device sdb1): unable to fixup (regular) error at logical 136349831168 on dev /dev/sda1
BTRFS warning (device sdb1): checksum error at logical 136349835264 on dev /dev/sda1, sector 140430000, root 5, inode 4265283, offset 24576, length 4096, links 1 (path: user/Pictures/Picture-42-2.jpg)
BTRFS error (device sdb1): bdev /dev/sda1 errs: wr 0, rd 0, flush 0, corrupt 14229, gen 24
BTRFS error (device sdb1): unable to fixup (regular) error at logical 136349835264 on dev /dev/sda1
BTRFS warning (device sdb1): checksum error at logical 136349839360 on dev /dev/sda1, sector 140430008, root 5, inode 4265283, offset 28672, length 4096, links 1 (path: user/Pictures/Picture-42-2.jpg)
BTRFS error (device sdb1): bdev /dev/sda1 errs: wr 0, rd 0, flush 0, corrupt 14230, gen 24
BTRFS error (device sdb1): unable to fixup (regular) error at logical 136349839360 on dev /dev/sda1
BTRFS warning (device sdb1): checksum error at logical 136349843456 on dev /dev/sda1, sector 140430016, root 5, inode 4265283, offset 32768, length 4096, links 1 (path: user/Pictures/Picture-42-2.jpg)
BTRFS error (device sdb1): bdev /dev/sda1 errs: wr 0, rd 0, flush 0, corrupt 14231, gen 24
BTRFS error (device sdb1): unable to fixup (regular) error at logical 136349843456 on dev /dev/sda1
BTRFS warning (device sdb1): checksum error at logical 136349847552 on dev /dev/sda1, sector 140430024, root 5, inode 4265283, offset 36864, length 4096, links 1 (path: user/Pictures/Picture-42-2.jpg)
BTRFS error (device sdb1): bdev /dev/sda1 errs: wr 0, rd 0, flush 0, corrupt 14232, gen 24
BTRFS error (device sdb1): unable to fixup (regular) error at logical 136349847552 on dev /dev/sda1
scrub_handle_errored_block: 164 callbacks suppressed
BTRFS warning (device sdb1): checksum error at logical 139677270016 on dev /dev/sda1, sector 146928896, root 5, inode 4265287, offset 0, length 4096, links 1 (path: user/Pictures/Picture-51-2.jpg)
btrfs_dev_stat_print_on_error: 164 callbacks suppressed
BTRFS error (device sdb1): bdev /dev/sda1 errs: wr 0, rd 0, flush 0, corrupt 14397, gen 24
scrub_handle_errored_block: 164 callbacks suppressed
BTRFS error (device sdb1): unable to fixup (regular) error at logical 139677270016 on dev /dev/sda1
BTRFS warning (device sdb1): checksum error at logical 139677274112 on dev /dev/sda1, sector 146928904, root 5, inode 4265287, offset 4096, length 4096, links 1 (path: user/Pictures/Picture-51-2.jpg)
BTRFS error (device sdb1): bdev /dev/sda1 errs: wr 0, rd 0, flush 0, corrupt 14398, gen 24
BTRFS error (device sdb1): unable to fixup (regular) error at logical 139677274112 on dev /dev/sda1
BTRFS warning (device sdb1): checksum error at logical 139677278208 on dev /dev/sda1, sector 146928912, root 5, inode 4265287, offset 8192, length 4096, links 1 (path: user/Pictures/Picture-51-2.jpg)
BTRFS error (device sdb1): bdev /dev/sda1 errs: wr 0, rd 0, flush 0, corrupt 14399, gen 24
BTRFS error (device sdb1): unable to fixup (regular) error at logical 139677278208 on dev /dev/sda1
BTRFS warning (device sdb1): checksum error at logical 139677282304 on dev /dev/sda1, sector 146928920, root 5, inode 4265287, offset 12288, length 4096, links 1 (path: user/Pictures/Picture-51-2.jpg)
BTRFS error (device sdb1): bdev /dev/sda1 errs: wr 0, rd 0, flush 0, corrupt 14400, gen 24
BTRFS error (device sdb1): unable to fixup (regular) error at logical 139677282304 on dev /dev/sda1
BTRFS warning (device sdb1): checksum error at logical 139677286400 on dev /dev/sda1, sector 146928928, root 5, inode 4265287, offset 16384, length 4096, links 1 (path: user/Pictures/Picture-51-2.jpg)
BTRFS error (device sdb1): bdev /dev/sda1 errs: wr 0, rd 0, flush 0, corrupt 14401, gen 24
BTRFS error (device sdb1): unable to fixup (regular) error at logical 139677286400 on dev /dev/sda1
BTRFS warning (device sdb1): checksum error at logical 139677290496 on dev /dev/sda1, sector 146928936, root 5, inode 4265287, offset 20480, length 4096, links 1 (path: user/Pictures/Picture-51-2.jpg)
BTRFS error (device sdb1): bdev /dev/sda1 errs: wr 0, rd 0, flush 0, corrupt 14402, gen 24
BTRFS error (device sdb1): unable to fixup (regular) error at logical 139677290496 on dev /dev/sda1
BTRFS warning (device sdb1): checksum error at logical 139677294592 on dev /dev/sda1, sector 146928944, root 5, inode 4265287, offset 24576, length 4096, links 1 (path: user/Pictures/Picture-51-2.jpg)
BTRFS error (device sdb1): bdev /dev/sda1 errs: wr 0, rd 0, flush 0, corrupt 14403, gen 24
BTRFS error (device sdb1): unable to fixup (regular) error at logical 139677294592 on dev /dev/sda1
BTRFS warning (device sdb1): checksum error at logical 139677298688 on dev /dev/sda1, sector 146928952, root 5, inode 4265287, offset 28672, length 4096, links 1 (path: user/Pictures/Picture-51-2.jpg)
BTRFS error (device sdb1): bdev /dev/sda1 errs: wr 0, rd 0, flush 0, corrupt 14404, gen 24
BTRFS error (device sdb1): unable to fixup (regular) error at logical 139677298688 on dev /dev/sda1
BTRFS warning (device sdb1): checksum error at logical 139677302784 on dev /dev/sda1, sector 146928960, root 5, inode 4265287, offset 32768, length 4096, links 1 (path: user/Pictures/Picture-51-2.jpg)
BTRFS error (device sdb1): bdev /dev/sda1 errs: wr 0, rd 0, flush 0, corrupt 14405, gen 24
BTRFS error (device sdb1): unable to fixup (regular) error at logical 139677302784 on dev /dev/sda1
BTRFS warning (device sdb1): checksum error at logical 139677306880 on dev /dev/sda1, sector 146928968, root 5, inode 4265287, offset 36864, length 4096, links 1 (path: user/Pictures/Picture-51-2.jpg)
BTRFS error (device sdb1): bdev /dev/sda1 errs: wr 0, rd 0, flush 0, corrupt 14406, gen 24
BTRFS error (device sdb1): unable to fixup (regular) error at logical 139677306880 on dev /dev/sda1
scrub_handle_errored_block: 434 callbacks suppressed
BTRFS warning (device sdb1): checksum error at logical 140475064320 on dev /dev/sda1, sector 148487088, root 5, inode 4265291, offset 0, length 4096, links 1 (path: user/Pictures/Picture-56-2.jpg)
btrfs_dev_stat_print_on_error: 434 callbacks suppressed
BTRFS error (device sdb1): bdev /dev/sda1 errs: wr 0, rd 0, flush 0, corrupt 14841, gen 24
scrub_handle_errored_block: 434 callbacks suppressed
BTRFS error (device sdb1): unable to fixup (regular) error at logical 140475064320 on dev /dev/sda1
BTRFS warning (device sdb1): checksum error at logical 140475068416 on dev /dev/sda1, sector 148487096, root 5, inode 4265291, offset 4096, length 4096, links 1 (path: user/Pictures/Picture-56-2.jpg)
BTRFS error (device sdb1): bdev /dev/sda1 errs: wr 0, rd 0, flush 0, corrupt 14842, gen 24
BTRFS error (device sdb1): unable to fixup (regular) error at logical 140475068416 on dev /dev/sda1
BTRFS warning (device sdb1): checksum error at logical 140475072512 on dev /dev/sda1, sector 148487104, root 5, inode 4265291, offset 8192, length 4096, links 1 (path: user/Pictures/Picture-56-2.jpg)
BTRFS error (device sdb1): bdev /dev/sda1 errs: wr 0, rd 0, flush 0, corrupt 14843, gen 24
BTRFS error (device sdb1): unable to fixup (regular) error at logical 140475072512 on dev /dev/sda1
BTRFS warning (device sdb1): checksum error at logical 140475076608 on dev /dev/sda1, sector 148487112, root 5, inode 4265291, offset 12288, length 4096, links 1 (path: user/Pictures/Picture-56-2.jpg)
BTRFS error (device sdb1): bdev /dev/sda1 errs: wr 0, rd 0, flush 0, corrupt 14844, gen 24
BTRFS error (device sdb1): unable to fixup (regular) error at logical 140475076608 on dev /dev/sda1
BTRFS warning (device sdb1): checksum error at logical 140475080704 on dev /dev/sda1, sector 148487120, root 5, inode 4265291, offset 16384, length 4096, links 1 (path: user/Pictures/Picture-56-2.jpg)
BTRFS error (device sdb1): bdev /dev/sda1 errs: wr 0, rd 0, flush 0, corrupt 14845, gen 24
BTRFS error (device sdb1): unable to fixup (regular) error at logical 140475080704 on dev /dev/sda1
BTRFS warning (device sdb1): checksum error at logical 140475084800 on dev /dev/sda1, sector 148487128, root 5, inode 4265291, offset 20480, length 4096, links 1 (path: user/Pictures/Picture-56-2.jpg)
BTRFS error (device sdb1): bdev /dev/sda1 errs: wr 0, rd 0, flush 0, corrupt 14846, gen 24
BTRFS error (device sdb1): unable to fixup (regular) error at logical 140475084800 on dev /dev/sda1
BTRFS warning (device sdb1): checksum error at logical 140475088896 on dev /dev/sda1, sector 148487136, root 5, inode 4265291, offset 24576, length 4096, links 1 (path: user/Pictures/Picture-56-2.jpg)
BTRFS error (device sdb1): bdev /dev/sda1 errs: wr 0, rd 0, flush 0, corrupt 14847, gen 24
BTRFS error (device sdb1): unable to fixup (regular) error at logical 140475088896 on dev /dev/sda1
BTRFS warning (device sdb1): checksum error at logical 140475092992 on dev /dev/sda1, sector 148487144, root 5, inode 4265291, offset 28672, length 4096, links 1 (path: user/Pictures/Picture-56-2.jpg)
BTRFS error (device sdb1): bdev /dev/sda1 errs: wr 0, rd 0, flush 0, corrupt 14848, gen 24
BTRFS error (device sdb1): unable to fixup (regular) error at logical 140475092992 on dev /dev/sda1
BTRFS warning (device sdb1): checksum error at logical 140475097088 on dev /dev/sda1, sector 148487152, root 5, inode 4265291, offset 32768, length 4096, links 1 (path: user/Pictures/Picture-56-2.jpg)
BTRFS error (device sdb1): bdev /dev/sda1 errs: wr 0, rd 0, flush 0, corrupt 14849, gen 24
BTRFS error (device sdb1): unable to fixup (regular) error at logical 140475097088 on dev /dev/sda1
BTRFS warning (device sdb1): checksum error at logical 140475101184 on dev /dev/sda1, sector 148487160, root 5, inode 4265291, offset 36864, length 4096, links 1 (path: user/Pictures/Picture-56-2.jpg)
BTRFS error (device sdb1): bdev /dev/sda1 errs: wr 0, rd 0, flush 0, corrupt 14850, gen 24
BTRFS error (device sdb1): unable to fixup (regular) error at logical 140475101184 on dev /dev/sda1
scrub_handle_errored_block: 310 callbacks suppressed
BTRFS warning (device sdb1): checksum error at logical 162995269632 on dev /dev/sda1, sector 192471864, root 5, inode 4265299, offset 0, length 4096, links 1 (path: user/Pictures/Picture-22.jpg)
btrfs_dev_stat_print_on_error: 310 callbacks suppressed
BTRFS error (device sdb1): bdev /dev/sda1 errs: wr 0, rd 0, flush 0, corrupt 15161, gen 24
scrub_handle_errored_block: 310 callbacks suppressed
BTRFS error (device sdb1): unable to fixup (regular) error at logical 162995269632 on dev /dev/sda1
BTRFS warning (device sdb1): checksum error at logical 162995273728 on dev /dev/sda1, sector 192471872, root 5, inode 4265299, offset 4096, length 4096, links 1 (path: user/Pictures/Picture-22.jpg)
BTRFS error (device sdb1): bdev /dev/sda1 errs: wr 0, rd 0, flush 0, corrupt 15162, gen 24
BTRFS error (device sdb1): unable to fixup (regular) error at logical 162995273728 on dev /dev/sda1
BTRFS warning (device sdb1): checksum error at logical 162995277824 on dev /dev/sda1, sector 192471880, root 5, inode 4265299, offset 8192, length 4096, links 1 (path: user/Pictures/Picture-22.jpg)
BTRFS error (device sdb1): bdev /dev/sda1 errs: wr 0, rd 0, flush 0, corrupt 15163, gen 24
BTRFS error (device sdb1): unable to fixup (regular) error at logical 162995277824 on dev /dev/sda1
BTRFS warning (device sdb1): checksum error at logical 162995281920 on dev /dev/sda1, sector 192471888, root 5, inode 4265299, offset 12288, length 4096, links 1 (path: user/Pictures/Picture-22.jpg)
BTRFS error (device sdb1): bdev /dev/sda1 errs: wr 0, rd 0, flush 0, corrupt 15164, gen 24
BTRFS error (device sdb1): unable to fixup (regular) error at logical 162995281920 on dev /dev/sda1
BTRFS warning (device sdb1): checksum error at logical 162995286016 on dev /dev/sda1, sector 192471896, root 5, inode 4265299, offset 16384, length 4096, links 1 (path: user/Pictures/Picture-22.jpg)
BTRFS error (device sdb1): bdev /dev/sda1 errs: wr 0, rd 0, flush 0, corrupt 15165, gen 24
BTRFS error (device sdb1): unable to fixup (regular) error at logical 162995286016 on dev /dev/sda1
BTRFS warning (device sdb1): checksum error at logical 162995290112 on dev /dev/sda1, sector 192471904, root 5, inode 4265299, offset 20480, length 4096, links 1 (path: user/Pictures/Picture-22.jpg)
BTRFS error (device sdb1): bdev /dev/sda1 errs: wr 0, rd 0, flush 0, corrupt 15166, gen 24
BTRFS error (device sdb1): unable to fixup (regular) error at logical 162995290112 on dev /dev/sda1
BTRFS warning (device sdb1): checksum error at logical 162995294208 on dev /dev/sda1, sector 192471912, root 5, inode 4265299, offset 24576, length 4096, links 1 (path: user/Pictures/Picture-22.jpg)
BTRFS error (device sdb1): bdev /dev/sda1 errs: wr 0, rd 0, flush 0, corrupt 15167, gen 24
BTRFS error (device sdb1): unable to fixup (regular) error at logical 162995294208 on dev /dev/sda1
BTRFS warning (device sdb1): checksum error at logical 162995298304 on dev /dev/sda1, sector 192471920, root 5, inode 4265299, offset 28672, length 4096, links 1 (path: user/Pictures/Picture-22.jpg)
BTRFS error (device sdb1): bdev /dev/sda1 errs: wr 0, rd 0, flush 0, corrupt 15168, gen 24
BTRFS error (device sdb1): unable to fixup (regular) error at logical 162995298304 on dev /dev/sda1
BTRFS warning (device sdb1): checksum error at logical 162995302400 on dev /dev/sda1, sector 192471928, root 5, inode 4265299, offset 32768, length 4096, links 1 (path: user/Pictures/Picture-22.jpg)
BTRFS error (device sdb1): bdev /dev/sda1 errs: wr 0, rd 0, flush 0, corrupt 15169, gen 24
BTRFS error (device sdb1): unable to fixup (regular) error at logical 162995302400 on dev /dev/sda1
BTRFS warning (device sdb1): checksum error at logical 162995306496 on dev /dev/sda1, sector 192471936, root 5, inode 4265299, offset 36864, length 4096, links 1 (path: user/Pictures/Picture-22.jpg)
BTRFS error (device sdb1): bdev /dev/sda1 errs: wr 0, rd 0, flush 0, corrupt 15170, gen 24
BTRFS error (device sdb1): unable to fixup (regular) error at logical 162995306496 on dev /dev/sda1
scrub_handle_errored_block: 434 callbacks suppressed
BTRFS warning (device sdb1): checksum error at logical 170607226880 on dev /dev/sda1, sector 207338968, root 5, inode 4265298, offset 450560, length 4096, links 1 (path: user/Pictures/Picture-22-2.jpg)
btrfs_dev_stat_print_on_error: 434 callbacks suppressed
BTRFS error (device sdb1): bdev /dev/sda1 errs: wr 0, rd 0, flush 0, corrupt 15605, gen 24
scrub_handle_errored_block: 434 callbacks suppressed
BTRFS error (device sdb1): unable to fixup (regular) error at logical 170607226880 on dev /dev/sda1
BTRFS warning (device sdb1): checksum error at logical 170607230976 on dev /dev/sda1, sector 207338976, root 5, inode 4265298, offset 454656, length 4096, links 1 (path: user/Pictures/Picture-22-2.jpg)
BTRFS error (device sdb1): bdev /dev/sda1 errs: wr 0, rd 0, flush 0, corrupt 15606, gen 24
BTRFS error (device sdb1): unable to fixup (regular) error at logical 170607230976 on dev /dev/sda1
BTRFS warning (device sdb1): checksum error at logical 170607235072 on dev /dev/sda1, sector 207338984, root 5, inode 4265298, offset 458752, length 4096, links 1 (path: user/Pictures/Picture-22-2.jpg)
BTRFS error (device sdb1): bdev /dev/sda1 errs: wr 0, rd 0, flush 0, corrupt 15607, gen 24
BTRFS error (device sdb1): unable to fixup (regular) error at logical 170607235072 on dev /dev/sda1
BTRFS warning (device sdb1): checksum error at logical 170607239168 on dev /dev/sda1, sector 207338992, root 5, inode 4265298, offset 462848, length 4096, links 1 (path: user/Pictures/Picture-22-2.jpg)
BTRFS error (device sdb1): bdev /dev/sda1 errs: wr 0, rd 0, flush 0, corrupt 15608, gen 24
BTRFS error (device sdb1): unable to fixup (regular) error at logical 170607239168 on dev /dev/sda1
BTRFS warning (device sdb1): checksum error at logical 170607243264 on dev /dev/sda1, sector 207339000, root 5, inode 4265298, offset 466944, length 4096, links 1 (path: user/Pictures/Picture-22-2.jpg)
BTRFS error (device sdb1): bdev /dev/sda1 errs: wr 0, rd 0, flush 0, corrupt 15609, gen 24
BTRFS error (device sdb1): unable to fixup (regular) error at logical 170607243264 on dev /dev/sda1
BTRFS warning (device sdb1): checksum error at logical 170607247360 on dev /dev/sda1, sector 207339008, root 5, inode 4265298, offset 471040, length 4096, links 1 (path: user/Pictures/Picture-22-2.jpg)
BTRFS error (device sdb1): bdev /dev/sda1 errs: wr 0, rd 0, flush 0, corrupt 15610, gen 24
BTRFS error (device sdb1): unable to fixup (regular) error at logical 170607247360 on dev /dev/sda1
BTRFS warning (device sdb1): checksum error at logical 170607251456 on dev /dev/sda1, sector 207339016, root 5, inode 4265298, offset 475136, length 4096, links 1 (path: user/Pictures/Picture-22-2.jpg)
BTRFS error (device sdb1): bdev /dev/sda1 errs: wr 0, rd 0, flush 0, corrupt 15611, gen 24
BTRFS error (device sdb1): unable to fixup (regular) error at logical 170607251456 on dev /dev/sda1
BTRFS warning (device sdb1): checksum error at logical 170607255552 on dev /dev/sda1, sector 207339024, root 5, inode 4265298, offset 479232, length 4096, links 1 (path: user/Pictures/Picture-22-2.jpg)
BTRFS error (device sdb1): bdev /dev/sda1 errs: wr 0, rd 0, flush 0, corrupt 15612, gen 24
BTRFS error (device sdb1): unable to fixup (regular) error at logical 170607255552 on dev /dev/sda1
BTRFS warning (device sdb1): checksum error at logical 170607259648 on dev /dev/sda1, sector 207339032, root 5, inode 4265298, offset 483328, length 4096, links 1 (path: user/Pictures/Picture-22-2.jpg)
BTRFS error (device sdb1): bdev /dev/sda1 errs: wr 0, rd 0, flush 0, corrupt 15613, gen 24
BTRFS error (device sdb1): unable to fixup (regular) error at logical 170607259648 on dev /dev/sda1
BTRFS warning (device sdb1): checksum error at logical 170607263744 on dev /dev/sda1, sector 207339040, root 5, inode 4265298, offset 487424, length 4096, links 1 (path: user/Pictures/Picture-22-2.jpg)
BTRFS error (device sdb1): bdev /dev/sda1 errs: wr 0, rd 0, flush 0, corrupt 15614, gen 24
BTRFS error (device sdb1): unable to fixup (regular) error at logical 170607263744 on dev /dev/sda1
scrub_handle_errored_block: 281 callbacks suppressed
BTRFS warning (device sdb1): checksum error at logical 171216498688 on dev /dev/sda1, sector 208528952, root 5, inode 4265266, offset 655360, length 4096, links 1 (path: user/Pictures/Picture-33.jpg)
btrfs_dev_stat_print_on_error: 281 callbacks suppressed
BTRFS error (device sdb1): bdev /dev/sda1 errs: wr 0, rd 0, flush 0, corrupt 15896, gen 24
scrub_handle_errored_block: 281 callbacks suppressed
BTRFS error (device sdb1): unable to fixup (regular) error at logical 171216498688 on dev /dev/sda1
BTRFS warning (device sdb1): checksum error at logical 171216502784 on dev /dev/sda1, sector 208528960, root 5, inode 4265266, offset 659456, length 4096, links 1 (path: user/Pictures/Picture-33.jpg)
BTRFS error (device sdb1): bdev /dev/sda1 errs: wr 0, rd 0, flush 0, corrupt 15897, gen 24
BTRFS error (device sdb1): unable to fixup (regular) error at logical 171216502784 on dev /dev/sda1
BTRFS warning (device sdb1): checksum error at logical 171216506880 on dev /dev/sda1, sector 208528968, root 5, inode 4265266, offset 663552, length 4096, links 1 (path: user/Pictures/Picture-33.jpg)
BTRFS error (device sdb1): bdev /dev/sda1 errs: wr 0, rd 0, flush 0, corrupt 15898, gen 24
BTRFS error (device sdb1): unable to fixup (regular) error at logical 171216506880 on dev /dev/sda1
BTRFS warning (device sdb1): checksum error at logical 171216510976 on dev /dev/sda1, sector 208528976, root 5, inode 4265266, offset 667648, length 4096, links 1 (path: user/Pictures/Picture-33.jpg)
BTRFS error (device sdb1): bdev /dev/sda1 errs: wr 0, rd 0, flush 0, corrupt 15899, gen 24
BTRFS error (device sdb1): unable to fixup (regular) error at logical 171216510976 on dev /dev/sda1
BTRFS warning (device sdb1): checksum error at logical 171216515072 on dev /dev/sda1, sector 208528984, root 5, inode 4265266, offset 671744, length 4096, links 1 (path: user/Pictures/Picture-33.jpg)
BTRFS error (device sdb1): bdev /dev/sda1 errs: wr 0, rd 0, flush 0, corrupt 15900, gen 24
BTRFS error (device sdb1): unable to fixup (regular) error at logical 171216515072 on dev /dev/sda1
BTRFS warning (device sdb1): checksum error at logical 171216519168 on dev /dev/sda1, sector 208528992, root 5, inode 4265266, offset 675840, length 4096, links 1 (path: user/Pictures/Picture-33.jpg)
BTRFS error (device sdb1): bdev /dev/sda1 errs: wr 0, rd 0, flush 0, corrupt 15901, gen 24
BTRFS error (device sdb1): unable to fixup (regular) error at logical 171216519168 on dev /dev/sda1
BTRFS warning (device sdb1): checksum error at logical 171216523264 on dev /dev/sda1, sector 208529000, root 5, inode 4265266, offset 679936, length 4096, links 1 (path: user/Pictures/Picture-33.jpg)
BTRFS error (device sdb1): bdev /dev/sda1 errs: wr 0, rd 0, flush 0, corrupt 15902, gen 24
BTRFS error (device sdb1): unable to fixup (regular) error at logical 171216523264 on dev /dev/sda1
BTRFS warning (device sdb1): checksum error at logical 171216527360 on dev /dev/sda1, sector 208529008, root 5, inode 4265266, offset 684032, length 4096, links 1 (path: user/Pictures/Picture-33.jpg)
BTRFS error (device sdb1): bdev /dev/sda1 errs: wr 0, rd 0, flush 0, corrupt 15903, gen 24
BTRFS error (device sdb1): unable to fixup (regular) error at logical 171216527360 on dev /dev/sda1
BTRFS warning (device sdb1): checksum error at logical 171216531456 on dev /dev/sda1, sector 208529016, root 5, inode 4265266, offset 688128, length 4096, links 1 (path: user/Pictures/Picture-33.jpg)
BTRFS error (device sdb1): bdev /dev/sda1 errs: wr 0, rd 0, flush 0, corrupt 15904, gen 24
BTRFS error (device sdb1): unable to fixup (regular) error at logical 171216531456 on dev /dev/sda1
BTRFS warning (device sdb1): checksum error at logical 171216535552 on dev /dev/sda1, sector 208529024, root 5, inode 4265266, offset 692224, length 4096, links 1 (path: user/Pictures/Picture-33.jpg)
BTRFS error (device sdb1): bdev /dev/sda1 errs: wr 0, rd 0, flush 0, corrupt 15905, gen 24
BTRFS error (device sdb1): unable to fixup (regular) error at logical 171216535552 on dev /dev/sda1
scrub_handle_errored_block: 311 callbacks suppressed
BTRFS warning (device sdb1): checksum error at logical 182510542848 on dev /dev/sdb1, sector 228484336, root 5, inode 4265300, offset 0, length 4096, links 1 (path: user/Pictures/Picture-24-2.jpg)
btrfs_dev_stat_print_on_error: 311 callbacks suppressed
BTRFS error (device sdb1): bdev /dev/sdb1 errs: wr 11881695, rd 12, flush 7928, corrupt 1705632, gen 1335
scrub_handle_errored_block: 311 callbacks suppressed
BTRFS error (device sdb1): unable to fixup (regular) error at logical 182510542848 on dev /dev/sdb1
BTRFS warning (device sdb1): checksum error at logical 182510546944 on dev /dev/sdb1, sector 228484344, root 5, inode 4265300, offset 4096, length 4096, links 1 (path: user/Pictures/Picture-24-2.jpg)
BTRFS error (device sdb1): bdev /dev/sdb1 errs: wr 11881695, rd 12, flush 7928, corrupt 1705633, gen 1335
BTRFS error (device sdb1): unable to fixup (regular) error at logical 182510546944 on dev /dev/sdb1
BTRFS warning (device sdb1): checksum error at logical 182510551040 on dev /dev/sdb1, sector 228484352, root 5, inode 4265300, offset 8192, length 4096, links 1 (path: user/Pictures/Picture-24-2.jpg)
BTRFS error (device sdb1): bdev /dev/sdb1 errs: wr 11881695, rd 12, flush 7928, corrupt 1705634, gen 1335
BTRFS error (device sdb1): unable to fixup (regular) error at logical 182510551040 on dev /dev/sdb1
BTRFS warning (device sdb1): checksum error at logical 182510555136 on dev /dev/sdb1, sector 228484360, root 5, inode 4265300, offset 12288, length 4096, links 1 (path: user/Pictures/Picture-24-2.jpg)
BTRFS error (device sdb1): bdev /dev/sdb1 errs: wr 11881695, rd 12, flush 7928, corrupt 1705635, gen 1335
BTRFS error (device sdb1): unable to fixup (regular) error at logical 182510555136 on dev /dev/sdb1
BTRFS warning (device sdb1): checksum error at logical 182510559232 on dev /dev/sdb1, sector 228484368, root 5, inode 4265300, offset 16384, length 4096, links 1 (path: user/Pictures/Picture-24-2.jpg)
BTRFS error (device sdb1): bdev /dev/sdb1 errs: wr 11881695, rd 12, flush 7928, corrupt 1705636, gen 1335
BTRFS error (device sdb1): unable to fixup (regular) error at logical 182510559232 on dev /dev/sdb1
BTRFS warning (device sdb1): checksum error at logical 182510563328 on dev /dev/sdb1, sector 228484376, root 5, inode 4265300, offset 20480, length 4096, links 1 (path: user/Pictures/Picture-24-2.jpg)
BTRFS error (device sdb1): bdev /dev/sdb1 errs: wr 11881695, rd 12, flush 7928, corrupt 1705637, gen 1335
BTRFS error (device sdb1): unable to fixup (regular) error at logical 182510563328 on dev /dev/sdb1
BTRFS warning (device sdb1): checksum error at logical 182510567424 on dev /dev/sdb1, sector 228484384, root 5, inode 4265300, offset 24576, length 4096, links 1 (path: user/Pictures/Picture-24-2.jpg)
BTRFS error (device sdb1): bdev /dev/sdb1 errs: wr 11881695, rd 12, flush 7928, corrupt 1705638, gen 1335
BTRFS error (device sdb1): unable to fixup (regular) error at logical 182510567424 on dev /dev/sdb1
BTRFS warning (device sdb1): checksum error at logical 182510571520 on dev /dev/sdb1, sector 228484392, root 5, inode 4265300, offset 28672, length 4096, links 1 (path: user/Pictures/Picture-24-2.jpg)
BTRFS error (device sdb1): bdev /dev/sdb1 errs: wr 11881695, rd 12, flush 7928, corrupt 1705639, gen 1335
BTRFS error (device sdb1): unable to fixup (regular) error at logical 182510571520 on dev /dev/sdb1
BTRFS warning (device sdb1): checksum error at logical 182510575616 on dev /dev/sdb1, sector 228484400, root 5, inode 4265300, offset 32768, length 4096, links 1 (path: user/Pictures/Picture-24-2.jpg)
BTRFS error (device sdb1): bdev /dev/sdb1 errs: wr 11881695, rd 12, flush 7928, corrupt 1705640, gen 1335
BTRFS error (device sdb1): unable to fixup (regular) error at logical 182510575616 on dev /dev/sdb1
BTRFS warning (device sdb1): checksum error at logical 182510579712 on dev /dev/sdb1, sector 228484408, root 5, inode 4265300, offset 36864, length 4096, links 1 (path: user/Pictures/Picture-24-2.jpg)
BTRFS error (device sdb1): bdev /dev/sdb1 errs: wr 11881695, rd 12, flush 7928, corrupt 1705641, gen 1335
BTRFS error (device sdb1): unable to fixup (regular) error at logical 182510579712 on dev /dev/sdb1
scrub_handle_errored_block: 345 callbacks suppressed
BTRFS warning (device sdb1): checksum error at logical 198160945152 on dev /dev/sda1, sector 261154824, root 5, inode 4265307, offset 2592768, length 4096, links 1 (path: user/Pictures/Picture-38.jpg)
btrfs_dev_stat_print_on_error: 345 callbacks suppressed
BTRFS error (device sdb1): bdev /dev/sda1 errs: wr 0, rd 0, flush 0, corrupt 16217, gen 24
ata2.00: exception Emask 0x0 SAct 0x4000 SErr 0x0 action 0x0
ata2.00: irq_stat 0x40000008
ata2.00: failed command: READ FPDMA QUEUED
ata2.00: cmd 60/08:70:08:d8:70/00:00:0f:00:00/40 tag 14 ncq 4096 in
         res 41/40:00:08:d8:70/00:00:0f:00:00/40 Emask 0x409 (media error) <F>
ata2.00: status: { DRDY ERR }
ata2.00: error: { UNC }
ata2.00: configured for UDMA/133
sd 1:0:0:0: [sdb] tag#14 FAILED Result: hostbyte=DID_OK driverbyte=DRIVER_SENSE
sd 1:0:0:0: [sdb] tag#14 Sense Key : Medium Error [current] [descriptor] 
sd 1:0:0:0: [sdb] tag#14 Add. Sense: Unrecovered read error - auto reallocate failed
sd 1:0:0:0: [sdb] tag#14 CDB: Read(10) 28 00 0f 70 d8 08 00 00 08 00
blk_update_request: I/O error, dev sdb, sector 259053576
scrub_handle_errored_block: 345 callbacks suppressed
ata2: EH complete
BTRFS error (device sdb1): unable to fixup (regular) error at logical 198160945152 on dev /dev/sda1
BTRFS warning (device sdb1): checksum error at logical 198160949248 on dev /dev/sda1, sector 261154832, root 5, inode 4265307, offset 2596864, length 4096, links 1 (path: user/Pictures/Picture-38.jpg)
BTRFS error (device sdb1): bdev /dev/sda1 errs: wr 0, rd 0, flush 0, corrupt 16218, gen 24
BTRFS error (device sdb1): unable to fixup (regular) error at logical 198160949248 on dev /dev/sda1
BTRFS warning (device sdb1): checksum error at logical 198160953344 on dev /dev/sda1, sector 261154840, root 5, inode 4265307, offset 2600960, length 4096, links 1 (path: user/Pictures/Picture-38.jpg)
BTRFS error (device sdb1): bdev /dev/sda1 errs: wr 0, rd 0, flush 0, corrupt 16219, gen 24
BTRFS error (device sdb1): unable to fixup (regular) error at logical 198160953344 on dev /dev/sda1
BTRFS warning (device sdb1): checksum error at logical 198160957440 on dev /dev/sda1, sector 261154848, root 5, inode 4265307, offset 2605056, length 4096, links 1 (path: user/Pictures/Picture-38.jpg)
BTRFS error (device sdb1): bdev /dev/sda1 errs: wr 0, rd 0, flush 0, corrupt 16220, gen 24
BTRFS error (device sdb1): unable to fixup (regular) error at logical 198160957440 on dev /dev/sda1
BTRFS warning (device sdb1): checksum error at logical 198160961536 on dev /dev/sda1, sector 261154856, root 5, inode 4265307, offset 2609152, length 4096, links 1 (path: user/Pictures/Picture-38.jpg)
BTRFS error (device sdb1): bdev /dev/sda1 errs: wr 0, rd 0, flush 0, corrupt 16221, gen 24
BTRFS error (device sdb1): unable to fixup (regular) error at logical 198160961536 on dev /dev/sda1
BTRFS warning (device sdb1): checksum error at logical 198160965632 on dev /dev/sda1, sector 261154864, root 5, inode 4265307, offset 2613248, length 4096, links 1 (path: user/Pictures/Picture-38.jpg)
BTRFS error (device sdb1): bdev /dev/sda1 errs: wr 0, rd 0, flush 0, corrupt 16222, gen 24
BTRFS error (device sdb1): unable to fixup (regular) error at logical 198160965632 on dev /dev/sda1
BTRFS warning (device sdb1): checksum error at logical 198160969728 on dev /dev/sda1, sector 261154872, root 5, inode 4265307, offset 2617344, length 4096, links 1 (path: user/Pictures/Picture-38.jpg)
BTRFS error (device sdb1): bdev /dev/sda1 errs: wr 0, rd 0, flush 0, corrupt 16223, gen 24
BTRFS error (device sdb1): unable to fixup (regular) error at logical 198160969728 on dev /dev/sda1
BTRFS warning (device sdb1): checksum error at logical 198160973824 on dev /dev/sda1, sector 261154880, root 5, inode 4265307, offset 2621440, length 4096, links 1 (path: user/Pictures/Picture-38.jpg)
BTRFS error (device sdb1): bdev /dev/sda1 errs: wr 0, rd 0, flush 0, corrupt 16224, gen 24
BTRFS error (device sdb1): unable to fixup (regular) error at logical 198160973824 on dev /dev/sda1
BTRFS warning (device sdb1): checksum error at logical 198160977920 on dev /dev/sda1, sector 261154888, root 5, inode 4265307, offset 2625536, length 4096, links 1 (path: user/Pictures/Picture-38.jpg)
BTRFS error (device sdb1): bdev /dev/sda1 errs: wr 0, rd 0, flush 0, corrupt 16225, gen 24
BTRFS error (device sdb1): unable to fixup (regular) error at logical 198160977920 on dev /dev/sda1
BTRFS warning (device sdb1): checksum error at logical 198160982016 on dev /dev/sda1, sector 261154896, root 5, inode 4265307, offset 2629632, length 4096, links 1 (path: user/Pictures/Picture-38.jpg)
BTRFS error (device sdb1): bdev /dev/sda1 errs: wr 0, rd 0, flush 0, corrupt 16226, gen 24
BTRFS error (device sdb1): unable to fixup (regular) error at logical 198160982016 on dev /dev/sda1
BTRFS error (device sdb1): parent transid verify failed on 1894596354048 wanted 246893 found 240551
BTRFS error (device sdb1): parent transid verify failed on 1894596354048 wanted 246893 found 240551
BTRFS error (device sdb1): btrfs_scrub_dev(/dev/sda1, 1, /dev/sdd1) failed -5
------------[ cut here ]------------
WARNING: CPU: 0 PID: 1143 at /build/linux-9LouV5/linux-4.6.1/fs/btrfs/dev-replace.c:430 btrfs_dev_replace_start+0x2be/0x400 [btrfs]
Modules linked in: uas(E) usb_storage(E) bnep(E) ftdi_sio(E) usbserial(E) snd_hda_codec_hdmi(E) nls_utf8(E) nls_cp437(E) vfat(E) fat(E) intel_rapl(E) x86_pkg_temp_thermal(E) intel_powerclamp(E) coretemp(E) kvm_intel(E) kvm(E) iTCO_wdt(E) irqbypass(E) iTCO_vendor_support(E) crct10dif_pclmul(E) crc32_pclmul(E) ghash_clmulni_intel(E) hmac(E) drbg(E) ansi_cprng(E) aesni_intel(E) aes_x86_64(E) lrw(E) gf128mul(E) glue_helper(E) ablk_helper(E) cryptd(E) wl(POE) btusb(E) btrtl(E) btbcm(E) btintel(E) cfg80211(E) bluetooth(E) efi_pstore(E) snd_hda_codec_realtek(E) evdev(E) crc16(E) serio_raw(E) pcspkr(E) efivars(E) joydev(E) snd_hda_codec_generic(E) rfkill(E) snd_hda_intel(E) nuvoton_cir(E) rc_core(E) snd_hda_codec(E) i915(E) battery(E) snd_hda_core(E) snd_hwdep(E) soc_button_array(E) tpm_tis(E) drm_kms_helper(E) intel_smartconnect(E) snd_pcm(E) tpm(E) video(E) i2c_i801(E) snd_timer(E) drm(E) snd(E) lpc_ich(E) i2c_algo_bit(E) soundcore(E) mfd_core(E) mei_me(E) processor(E) button(E) mei(E) shpchp(E) fuse(E) autofs4(E) hid_logitech_hidpp(E) btrfs(E) hid_logitech_dj(E) usbhid(E) hid(E) xor(E) raid6_pq(E) sg(E) sr_mod(E) cdrom(E) sd_mod(E) crc32c_intel(E) ahci(E) libahci(E) libata(E) psmouse(E) scsi_mod(E) xhci_pci(E) ehci_pci(E) xhci_hcd(E) ehci_hcd(E) e1000e(E) usbcore(E) ptp(E) pps_core(E) usb_common(E) fjes(E)
CPU: 0 PID: 1143 Comm: btrfs Tainted: P        W  OE   4.6.0-0.bpo.1-amd64 #1 Debian 4.6.1-1~bpo8+1
Hardware name: To Be Filled By O.E.M. To Be Filled By O.E.M./Z87E-ITX, BIOS P2.10 10/04/2013
 0000000000000286 000000002f7c2f6a ffffffff813123c5 0000000000000000
 0000000000000000 ffffffff8107af94 ffff880176f5d000 00000000fffffffb
 ffff8801937a6000 ffff880176f10000 ffff880176f10ee0 00007ffe88dfa8f8
Call Trace:
 [<ffffffff813123c5>] ? dump_stack+0x5c/0x77
 [<ffffffff8107af94>] ? __warn+0xc4/0xe0
 [<ffffffffc030990e>] ? btrfs_dev_replace_start+0x2be/0x400 [btrfs]
 [<ffffffffc02d24f2>] ? btrfs_ioctl+0x1d42/0x2190 [btrfs]
 [<ffffffff811a8e2d>] ? handle_mm_fault+0x154d/0x1cb0
 [<ffffffff81205379>] ? do_vfs_ioctl+0x99/0x5d0
 [<ffffffff81205926>] ? SyS_ioctl+0x76/0x90
 [<ffffffff815c83b6>] ? system_call_fast_compare_end+0xc/0x96
---[ end trace 9fbfaa137cc5a72b ]---
