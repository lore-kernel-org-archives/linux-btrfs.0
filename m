Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wm0-f42.google.com ([74.125.82.42]:38648 "EHLO
	mail-wm0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751230AbcF2Xw1 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 29 Jun 2016 19:52:27 -0400
Received: by mail-wm0-f42.google.com with SMTP id r201so94977903wme.1
        for <linux-btrfs@vger.kernel.org>; Wed, 29 Jun 2016 16:51:13 -0700 (PDT)
Received: from system (dslb-188-099-185-114.188.099.pools.vodafone-ip.de. [188.99.185.114])
        by smtp.gmail.com with ESMTPSA id bo1sm412517wjb.35.2016.06.29.16.51.11
        for <linux-btrfs@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 29 Jun 2016 16:51:11 -0700 (PDT)
Date: Thu, 30 Jun 2016 01:51:09 +0200
From: Saint Germain <saintger@gmail.com>
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Subject: Re: Kernel bug during RAID1 replace
Message-ID: <20160630015109.6901070d@system>
In-Reply-To: <20160629192357.GC10223@carfax.org.uk>
References: <CAJCQCtRSu0GwLRqgvzj9pv80gqoqb6vnjVMLwMmnWF-rvR0tcg@mail.gmail.com>
	<20160629005208.5e9addcf@system>
	<CAJCQCtQnNfpu6xoFy2W_hfikphhp_AbUDVmm4Lr2Rsncrx_EsA@mail.gmail.com>
	<20160629115055.29018e6a@system>
	<CAJCQCtS=kd31tOe_YCX96W1K85sH2_qTAsxggyyP5kWzZrauoQ@mail.gmail.com>
	<20160629201208.275b37ad@system>
	<16e65a07-03b6-2540-fc96-3538c5bc5c99@gmail.com>
	<20160629210217.0e4e4d1c@system>
	<CAJCQCtRyPyXA+4+D-J8940xiOMcEwQHgsk6uSpnPeLUduAJd2Q@mail.gmail.com>
	<20160629211613.125ce3f0@system>
	<20160629192357.GC10223@carfax.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, 29 Jun 2016 19:23:57 +0000, Hugo Mills <hugo@carfax.org.uk>
wrote :

> On Wed, Jun 29, 2016 at 09:16:13PM +0200, Saint Germain wrote:
> > On Wed, 29 Jun 2016 13:08:30 -0600, Chris Murphy
> > <lists@colorremedies.com> wrote :
> > 
> > > >> > Ok I will follow your advice and start over with a fresh
> > > >> > BTRFS volume. As explained on another email, rsync doesn't
> > > >> > support reflink, so do you think it is worth trying with
> > > >> > BTRFS send instead ? Is it safe to copy this way or rsync is
> > > >> > more reliable in case of faulty BTRFS volume ?
> > > >> >
> > > >> If you have the space, btrfs restore would probably be the best
> > > >> option. It's not likely, but using send has a risk of
> > > >> contaminating the new filesystem as well.
> > > >>
> > > >
> > > > I have to copy through the network (I am running out of
> > > > disks...) so btrfs restore is unfortunately not an option.
> > > > I didn't know that btrfs send could contaminate the target disk
> > > > as well ?
> > > > Ok rsync it is then.
> > > 
> > > restore will let you extract files despite csum errors. I don't
> > > think send will, and using cp or rsync Btrfs definitely won't
> > > hand over the file.
> > > 
> > 
> > That's Ok I'd prefer to avoid copying files with csum errors anyway
> > (I can restore them from backups).
> > However will btrfs send abort the whole operation as soon as it
> > finds a csum error ?
> > And will I have the risk to "contaminate" the target BTRFS volume by
> > using BTRFS send ?
> 
>    A send stream is effectively just a sequence of filesystem commands
> (mv, cp, cp --reflink, rm, dd). So any damage that it can do when
> replayed by receive is limited to what you can do with the basic shell
> commands (plus cloning extents). If you have metadata breakage in your
> source filesystem, this won't cause the same metadata breakage to show
> up in the target filesystem.
> 

Well after 300GB copied through "btrfs send", the process is aborted
with the following error:
ERROR: send ioctl failed with -5: Input/output error
ERROR: unexpected EOF in stream.

/var/log/syslog relevant lines are appended at the end of this email.

So it seems that I will have to go with rsync then.

WARNING: CPU: 3 PID: 1779 at /build/linux-9LouV5/linux-4.6.1/fs/btrfs/extent-tree.c:6608 __btrfs_free_extent.isra.67+0x152/0xdc0 [btrfs]
BTRFS: Transaction aborted (error -5)
Modules linked in: bnep(E) snd_hda_codec_hdmi(E) snd_hda_codec_realtek(E) snd_hda_codec_generic(E) nfsd(E) auth_rpcgss(E) nfs_acl(E) nfs(E) lockd(E) grace(E) fscache(E) sunrpc(E) intel_rapl(E) x86_pkg_temp_thermal(E) intel_powerclamp(E) coretemp(E) kvm_intel(E) kvm(E) irqbypass(E) crct10dif_pclmul(E) crc32_pclmul(E) ghash_clmulni_intel(E) nls_utf8(E) hmac(E) nls_cp437(E) drbg(E) ansi_cprng(E) vfat(E) fat(E) wl(POE) aesni_intel(E) aes_x86_64(E) lrw(E) gf128mul(E) glue_helper(E) ablk_helper(E) cryptd(E) cfg80211(E) pcspkr(E) snd_hda_intel(E) snd_hda_codec(E) snd_hda_core(E) snd_hwdep(E) evdev(E) btusb(E) efi_pstore(E) joydev(E) btrtl(E) serio_raw(E) snd_pcm(E) snd_timer(E) snd(E) soundcore(E) shpchp(E) efivars(E) i2c_i801(E) hci_uart(E) btbcm(E) btqca(E) btintel(E) bluetooth(E) rfkill(E) i915(E) battery(E) crc16(E) video(E) intel_lpss_acpi(E) drm_kms_helper(E) intel_lpss(E) mfd_core(E) tpm_tis(E) acpi_pad(E) tpm(E) drm(E) acpi_als(E) kfifo_buf(E) i2c_algo_bit(E) mei_me(E) button(E) processor(E) industrialio(E) mei(E) fuse(E) autofs4(E) btrfs(E) xor(E) raid6_pq(E) sg(E) sd_mod(E) hid_logitech_hidpp(E) hid_logitech_dj(E) usbhid(E) ahci(E) libahci(E) crc32c_intel(E) e1000e(E) xhci_pci(E) xhci_hcd(E) ptp(E) psmouse(E) libata(E) pps_core(E) scsi_mod(E) usbcore(E) usb_common(E) i2c_hid(E) hid(E) fjes(E)
CPU: 3 PID: 1779 Comm: btrfs-transacti Tainted: P           OE   4.6.0-0.bpo.1-amd64 #1 Debian 4.6.1-1~bpo8+1
Hardware name: To Be Filled By O.E.M. To Be Filled By O.E.M./Z170 Gaming-ITX/ac, BIOS P2.10 04/13/2016
 0000000000000286 000000003e3b5862 ffffffff813123c5 ffff880067783b68
 0000000000000000 ffffffff8107af94 000001b8f6065000 ffff880067783bc0
 ffff88006b328000 ffff880165fc6000 0000000000000000 ffff880105a21150
Call Trace:
 [<ffffffff813123c5>] ? dump_stack+0x5c/0x77
 [<ffffffff8107af94>] ? __warn+0xc4/0xe0
 [<ffffffff8107b00f>] ? warn_slowpath_fmt+0x5f/0x80
 [<ffffffffc0246cf2>] ? __btrfs_free_extent.isra.67+0x152/0xdc0 [btrfs]
 [<ffffffffc02b131c>] ? btrfs_merge_delayed_refs+0x6c/0x610 [btrfs]
 [<ffffffffc024b7cd>] ? __btrfs_run_delayed_refs+0x9ad/0x1210 [btrfs]
 [<ffffffffc024edde>] ? btrfs_run_delayed_refs+0x8e/0x2b0 [btrfs]
 [<ffffffffc0264853>] ? btrfs_commit_transaction+0x4a3/0xa30 [btrfs]
 [<ffffffffc0264e76>] ? start_transaction+0x96/0x4d0 [btrfs]
 [<ffffffffc025f76e>] ? transaction_kthread+0x1ce/0x1f0 [btrfs]
 [<ffffffffc025f5a0>] ? btrfs_cleanup_transaction+0x590/0x590 [btrfs]
 [<ffffffff81099ecf>] ? kthread+0xdf/0x100
 [<ffffffff815c85f2>] ? ret_from_fork+0x22/0x40
 [<ffffffff81099df0>] ? kthread_park+0x50/0x50
---[ end trace 7c9951bcf0da5e1b ]---
BTRFS: error (device sdb1) in __btrfs_free_extent:6608: errno=-5 IO failure
BTRFS info (device sdb1): forced readonly
BTRFS: error (device sdb1) in btrfs_run_delayed_refs:2946: errno=-5 IO failure
BTRFS warning (device sdb1): Skipping commit of aborted transaction.
BTRFS: error (device sdb1) in cleanup_transaction:1771: errno=-5 IO
failure
