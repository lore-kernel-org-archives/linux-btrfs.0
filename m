Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-oi0-f54.google.com ([209.85.218.54]:35686 "EHLO
	mail-oi0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751749AbcF0Vmn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 27 Jun 2016 17:42:43 -0400
Received: by mail-oi0-f54.google.com with SMTP id r2so219095749oih.2
        for <linux-btrfs@vger.kernel.org>; Mon, 27 Jun 2016 14:42:43 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20160627233612.662d2a9a@system>
References: <20160627233612.662d2a9a@system>
From: Chris Murphy <lists@colorremedies.com>
Date: Mon, 27 Jun 2016 15:42:42 -0600
Message-ID: <CAJCQCtT_vbOzbvMOuV6wgvz4iMHcpQmAhX-y1-dkOi6F323KRg@mail.gmail.com>
Subject: Re: Kernel bug during RAID1 replace
To: Saint Germain <saintger@gmail.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Jun 27, 2016 at 3:36 PM, Saint Germain <saintger@gmail.com> wrote:
> Hello,
>
> I am on Debian Jessie with a kernel from backports:
> 4.6.0-0.bpo.1-amd64
>
> I am also using btrfs-tools 4.4.1-1.1~bpo8+1
>
> When trying to replace a RAID1 drive (with btrfs replace start
> -f /dev/sda1 /dev/sdd1), the operation is cancelled after completing
> only 5%.
>
> I got this error in the /var/log/syslog:
> ------------[ cut here ]------------
> WARNING: CPU: 2 PID: 2617 at /build/linux-9LouV5/linux-4.6.1/fs/btrfs/dev-replace.c:430 btrfs_dev_replace_start+0x2be/0x400 [btrfs]
> Modules linked in: uas(E) usb_storage(E) bnep(E) ftdi_sio(E) usbserial(E) snd_hda_codec_hdmi(E) nls_utf8(E) nls_cp437(E) vfat(E) fat(E) intel_rapl(E) x86_pkg_temp_thermal(E) intel_powerclamp(E) coretemp(E) kvm_intel(E) kvm(E) iTCO_wdt(E) irqbypass(E) iTCO_vendor_support(E) crct10dif_pclmul(E) crc32_pclmul(E) ghash_clmulni_intel(E) hmac(E) drbg(E) ansi_cprng(E) aesni_intel(E) aes_x86_64(E) lrw(E) gf128mul(E) glue_helper(E) ablk_helper(E) cryptd(E) wl(POE) btusb(E) btrtl(E) btbcm(E) btintel(E) cfg80211(E) bluetooth(E) efi_pstore(E) snd_hda_codec_realtek(E) evdev(E) crc16(E) serio_raw(E) pcspkr(E) efivars(E) joydev(E) snd_hda_codec_generic(E) rfkill(E) snd_hda_intel(E) nuvoton_cir(E) rc_core(E) snd_hda_codec(E) i915(E) battery(E) snd_hda_core(E) snd_hwdep(E) soc_button_array(E) tpm_tis(E) drm_kms_helper(E) intel_smartconnect(E) snd_pcm(E) tpm(E) video(E) i2c_i801(E) snd_timer(E) drm(E) snd(E) lpc_ich(E) i2c_algo_bit(E) soundcore(E) mfd_core(E) mei_me(E) processor(E) button(E) mei(E) shpchp(E) fuse(E) autofs4(E) hid_logitech_hidpp(E) btrfs(E) hid_logitech_dj(E) usbhid(E) hid(E) xor(E) raid6_pq(E) sg(E) sr_mod(E) cdrom(E) sd_mod(E) crc32c_intel(E) ahci(E) libahci(E) libata(E) psmouse(E) scsi_mod(E) xhci_pci(E) ehci_pci(E) xhci_hcd(E) ehci_hcd(E) e1000e(E) usbcore(E) ptp(E) pps_core(E) usb_common(E) fjes(E)
> CPU: 2 PID: 2617 Comm: btrfs Tainted: P           OE   4.6.0-0.bpo.1-amd64 #1 Debian 4.6.1-1~bpo8+1
> Hardware name: To Be Filled By O.E.M. To Be Filled By O.E.M./Z87E-ITX, BIOS P2.10 10/04/2013
>  0000000000000286 00000000f0ba7fe7 ffffffff813123c5 0000000000000000
>  0000000000000000 ffffffff8107af94 ffff880186caf000 00000000fffffffb
>  ffff8800c76b0800 ffff8800cae70000 ffff8800cae70ee0 00007ffdd5397d98
> Call Trace:
>  [<ffffffff813123c5>] ? dump_stack+0x5c/0x77
>  [<ffffffff8107af94>] ? __warn+0xc4/0xe0
>  [<ffffffffc030990e>] ? btrfs_dev_replace_start+0x2be/0x400 [btrfs]
>  [<ffffffffc02d24f2>] ? btrfs_ioctl+0x1d42/0x2190 [btrfs]
>  [<ffffffff811a8e2d>] ? handle_mm_fault+0x154d/0x1cb0
>  [<ffffffff81205379>] ? do_vfs_ioctl+0x99/0x5d0
>  [<ffffffff81205926>] ? SyS_ioctl+0x76/0x90
>  [<ffffffff815c83b6>] ? system_call_fast_compare_end+0xc/0x96
> ---[ end trace 9fbfaa137cc5a72a ]---
>
>
>
> What should I do to replace correctly my drive ?

I don't often see handle_mm_fault with btrfs problems, maybe the
entire dmesg from mounting the fs and including btrfs replace would
reveal a related problem that instigates the failure?

If the device being replaced is acting unreliably, then you'd want to
use -r with replace to ignore that device unless it's absolutely
necessary to read from it.

-- 
Chris Murphy
