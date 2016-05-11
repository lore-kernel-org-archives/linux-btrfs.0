Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-vk0-f53.google.com ([209.85.213.53]:36400 "EHLO
	mail-vk0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750978AbcEKBCu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 10 May 2016 21:02:50 -0400
Received: by mail-vk0-f53.google.com with SMTP id s184so38306767vkb.3
        for <linux-btrfs@vger.kernel.org>; Tue, 10 May 2016 18:02:50 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <96d3dbd3-bbf5-28da-6b0d-a2c634db45b7@chefmail.de>
References: <96d3dbd3-bbf5-28da-6b0d-a2c634db45b7@chefmail.de>
Date: Wed, 11 May 2016 03:02:49 +0200
Message-ID: <CAPmG0jYgG2N=2oL6fQFjnQqyD-TzN6AczO4STAeu3EO7Kt_f-Q@mail.gmail.com>
Subject: Re: FYI: Kernel crash info
From: Henk Slager <eye1tm@gmail.com>
To: g6094199@freenet.de
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, May 10, 2016 at 9:35 PM,  <g6094199@freenet.de> wrote:
> He guys!
>
>
> while testing/stressing (dd'ing 200GB random to the drive) a brand new
> 8TB seagate drive i ran into an kernel ooops.
>
> i think it happend after i finished dd'ing and while removing the drive.
> saw it a few minutes afterwards.

Strictly speaking, this is not a kernel crash, it is just a failure to
write to the device and reporting an IO error and file system going
read-only as a result.

What does   dmesg | grep ST8000   show?

If this 8TB is an SMR drive ('Archive'), be aware that under certain
circumstances, like for example unplugging/unpowering too fast after
massive random writes, this kind of IO failures are to be expected.


> uname -a
> Linux MacBookPro 4.4.0-22-generic #39~14.04.1-Ubuntu SMP Thu May 5
> 19:19:06 UTC 2016 x86_64 x86_64 x86_64 GNU/Linux
> master@MacBookPro:~$ btrfs --version
> btrfs-progs v4.4
>
>
> [ 6971.087519] BTRFS: error (device sdb1) in
> btrfs_commit_transaction:2124: errno=-5 IO failure (Error while writing
> out transaction)
> [ 6971.087525] BTRFS info (device sdb1): forced readonly
> [ 6971.087528] BTRFS warning (device sdb1): Skipping commit of aborted
> transaction.
> [ 6971.087530] ------------[ cut here ]------------
> [ 6971.087559] WARNING: CPU: 1 PID: 8161 at
> /build/linux-lts-xenial-T5gd_J/linux-lts-xenial-4.4.0/fs/btrfs/transaction.c:1746
> cleanup_transaction+0x87/0x2e0 [btrfs]()
> [ 6971.087561] BTRFS: Transaction aborted (error -5)
> [ 6971.087563] Modules linked in: ufs qnx4 hfsplus hfs minix ntfs msdos
> jfs xfs libcrc32c cpuid uas usb_storage ipt_MASQUERADE
> nf_nat_masquerade_ipv4 iptable_nat nf_nat_ipv4 nf_nat nf_conntrack_ipv4
> nf_defrag_ipv4 xt_conntrack nf_conntrack ipt_REJECT nf_reject_ipv4
> xt_CHECKSUM iptable_mangle xt_tcpudp bridge stp llc ip6table_filter
> ip6_tables iptable_filter ip_tables ebtable_nat ebtables x_tables
> rpcsec_gss_krb5 nfsv4 rfcomm bnep nfsd auth_rpcgss nfs_acl nfs lockd
> grace sunrpc fscache intel_rapl x86_pkg_temp_thermal intel_powerclamp
> joydev coretemp applesmc kvm_intel input_polldev kvm irqbypass
> crct10dif_pclmul snd_hda_codec_cirrus snd_hda_codec_generic
> snd_hda_codec_hdmi crc32_pclmul dm_multipath aesni_intel uvcvideo
> aes_x86_64 videobuf2_vmalloc lrw videobuf2_memops btusb gf128mul
> snd_seq_midi videobuf2_v4l2 glue_helper btrtl snd_seq_midi_event
> snd_hda_intel ablk_helper videobuf2_core v4l2_common btbcm cryptd
> snd_rawmidi snd_hda_codec btintel videodev snd_hda_core hid_appleir
> bluetooth wl(POE) snd_hwdep lpc_ich snd_pcm input_leds snd_seq cfg80211
> media bcm5974 snd_seq_device snd_timer snd soundcore acpi_als sbs
> kfifo_buf apple_gmux industrialio sbshc mac_hid mei_me parport_pc
> apple_bl mei shpchp ppdev lp parport btrfs xor raid6_pq hid_generic
> hid_apple usbhid hid amdkfd amd_iommu_v2 radeon i2c_algo_bit ttm
> drm_kms_helper syscopyarea sysfillrect sysimgblt tg3 fb_sys_fops drm
> firewire_ohci ptp firewire_core pata_acpi pps_core crc_itu_t video fjes
> [ 6971.087672] CPU: 1 PID: 8161 Comm: umount Tainted: P           OE
> 4.4.0-22-generic #39~14.04.1-Ubuntu
> [ 6971.087675] Hardware name: Apple Inc.
> MacBookPro8,3/Mac-942459F5819B171B, BIOS
> MBP81.88Z.0047.B2C.1510261540 10/26/15
> [ 6971.087677]  0000000000000000 ffff88045806fc38 ffffffff813cde6c
> ffff88045806fc80
> [ 6971.087681]  ffffffffc04741c0 ffff88045806fc70 ffffffff8107d856
> ffff88045b52f960
> [ 6971.087684]  ffff88045ab22800 ffff88045b5a6000 00000000fffffffb
> 00000000fffffffb
> [ 6971.087687] Call Trace:
> [ 6971.087694]  [<ffffffff813cde6c>] dump_stack+0x63/0x87
> [ 6971.087699]  [<ffffffff8107d856>] warn_slowpath_common+0x86/0xc0
> [ 6971.087703]  [<ffffffff8107d8dc>] warn_slowpath_fmt+0x4c/0x50
> [ 6971.087722]  [<ffffffffc03f1fd7>] cleanup_transaction+0x87/0x2e0 [btrfs]
> [ 6971.087727]  [<ffffffff810bdd60>] ? prepare_to_wait_event+0xf0/0xf0
> [ 6971.087731]  [<ffffffff810bd874>] ? __wake_up+0x44/0x50
> [ 6971.087750]  [<ffffffffc03f2cc7>]
> btrfs_commit_transaction+0x267/0xa80 [btrfs]
> [ 6971.087764]  [<ffffffffc03beb75>] btrfs_sync_fs+0x55/0x110 [btrfs]
> [ 6971.087768]  [<ffffffff8122fc41>] sync_filesystem+0x71/0xa0
> [ 6971.087773]  [<ffffffff81200167>] generic_shutdown_super+0x27/0x100
> [ 6971.087776]  [<ffffffff81200252>] kill_anon_super+0x12/0x20
> [ 6971.087790]  [<ffffffffc03c3f88>] btrfs_kill_super+0x18/0x120 [btrfs]
> [ 6971.087794]  [<ffffffff811ffbf3>] deactivate_locked_super+0x43/0x70
> [ 6971.087797]  [<ffffffff811ffc66>] deactivate_super+0x46/0x60
> [ 6971.087801]  [<ffffffff8121be2f>] cleanup_mnt+0x3f/0x80
> [ 6971.087805]  [<ffffffff8121bec2>] __cleanup_mnt+0x12/0x20
> [ 6971.087809]  [<ffffffff81099f07>] task_work_run+0x77/0x90
> [ 6971.087812]  [<ffffffff81078866>] exit_to_usermode_loop+0x73/0xa2
> [ 6971.087816]  [<ffffffff81003a6e>] syscall_return_slowpath+0x4e/0x60
> [ 6971.087820]  [<ffffffff817efe18>] int_ret_from_sys_call+0x25/0x8f
> [ 6971.087823] ---[ end trace 02b0451a7c4939ae ]---
> [ 6971.087826] BTRFS: error (device sdb1) in cleanup_transaction:1746:
> errno=-5 IO failure
> [ 6971.087828] BTRFS info (device sdb1): delayed_refs has NO entry
> [ 6973.206207] BTRFS error (device sdb1): cleaner transaction attach
> returned -30
>
>
> master@MacBookPro:~$ apt-cache show linux-image-generic-lts-xenial
> Package: linux-image-generic-lts-xenial
> Priority: optional
> Section: kernel
> Installed-Size: 27
> Maintainer: Ubuntu Kernel Team <kernel-team@lists.ubuntu.com>
> Architecture: amd64
> Source: linux-meta-lts-xenial
> Version: 4.4.0.22.12
> Depends: linux-image-4.4.0-22-generic,
> linux-image-extra-4.4.0-22-generic, linux-firmware
> Recommends: thermald
> Filename:
> pool/main/l/linux-meta-lts-xenial/linux-image-generic-lts-xenial_4.4.0.22.12_amd64.deb
> Size: 2292
> MD5sum: 8e56c322b9dce409b213b89ee4cb2bdb
> SHA1: e1784a952bde3ccacc1ebf238e769ccd4dad48e9
> SHA256: 63aa6bdd3aa1e8172a2f6094ea6669716c7ea032ddf7c9a65a765fc4bcff64ad
> Description-en: Generic Linux kernel image
>  This package will always depend on the latest generic kernel image
>  available.
> Description-md5: 6d632579c673704f44b290b16e7dbfd1
> Bugs: https://bugs.launchpad.net/ubuntu/+filebug
> Origin: Ubuntu
>
>
> master@MacBookPro:~$apt-cache show btrfs-tools
> Package: btrfs-tools
> Status: install ok installed
> Priority: optional
> Section: admin
> Installed-Size: 3638
> Maintainer: Ubuntu Developers <ubuntu-devel-discuss@lists.ubuntu.com>
> Architecture: amd64
> Version: 4.4-1
> Depends: e2fslibs (>= 1.42), libblkid1 (>= 2.17.2), libc6 (>= 2.8),
> libcomerr2 (>= 1.01), liblzo2-2, libuuid1 (>= 2.16), zlib1g (>= 1:1.2.0)
> Description-de: Werkzeuge für Copy-on-Write-Dateisystem mit Prüfsummen
>  Das neue Linux-Dateisystem btrfs kopiert beim Schreiben (Copy-On-Write).
>  Es zielt auf die Realisierung hochentwickelter Funktionen und konzentriert
>  sich auf Fehlertoleranz, Reparaturfähigkeit und einfache Verwaltung.
>  .
>  This package contains utilities (mkfs, fsck) used to work with btrfs and
>  an utility (btrfs-convert) to make a btrfs filesystem from an ext3.
> Description-md5: b373529b44d89311deab77020f34ab70
> Original-Maintainer: Dimitri John Ledkov <xnox@debian.org>
> Homepage: http://btrfs.wiki.kernel.org/
>
>
>
> I hope it helps....
>
>
>
> regards
>
> sash
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
