Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lf0-f46.google.com ([209.85.215.46]:33120 "EHLO
	mail-lf0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750904AbcACErq (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sat, 2 Jan 2016 23:47:46 -0500
Received: by mail-lf0-f46.google.com with SMTP id p203so262778437lfa.0
        for <linux-btrfs@vger.kernel.org>; Sat, 02 Jan 2016 20:47:45 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CA+X5Wn66VabG5mnQPfPvgUuadgEs5a+UtNLSohjrr-pe1GOoog@mail.gmail.com>
References: <CA+X5Wn66VabG5mnQPfPvgUuadgEs5a+UtNLSohjrr-pe1GOoog@mail.gmail.com>
Date: Sat, 2 Jan 2016 23:47:44 -0500
Message-ID: <CA+X5Wn6vJJVk45nrZ+e62Y+swJFVbGWwhU89zi1XidbJR4jzkA@mail.gmail.com>
Subject: Re: WARNING CPU at linux/fs/btrfs/ioctl.c:558 create_subvol BTRFS
 Transaction aborted (error -2)
From: james harvey <jamespharvey20@gmail.com>
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Have looked at http://comments.gmane.org/gmane.comp.file-systems.btrfs/48926

which contains a discussion and patch that is related to ioctl.c:558,
not sure if it was ever committed, or if it's even the same issue I'm
having.

On Sat, Jan 2, 2016 at 11:40 PM, james harvey <jamespharvey20@gmail.com> wrote:
> Fresh Arch install.  Official ISO dated 1/1/2016, using linux 4.3.3-2,
> btrfs-progs 4.3.1-2, lvm2 2.02.137-1, and thin-provisioning-tools
> 0.5.6-2.  Hard drive installation uses the exact same (only a day
> after ISO released) and snapper 0.2.8-4.
>
> I can re-create this by when booted off the archiso, when
> arch-chroot'ing into my mounted hard drive, running "snapper --no-dbus
> create-config /terra/main".  Then, either inside the arch-chroot (or
> outside of it, it doesn't matter) running "btrfs subvolume delete
> /terra/main/.snapshots".  I do this because I prefer to have a
> main.snapshots primary volume, rather than a subvolume.  If I wait
> until I've booted off the new install, I can run the subvolume delete
> command just fine.
>
> I notice snapper always forces me to have a subvolume
> "main/var/lib/machines".  I don't store vm files there, I've tried
> deleting it, but snapper forces it back.  But, when running off the
> archiso the subvolume delete for the .snapshots folder, I don't see
> the "main/var/lib/machines" subvolume... So I'm thinking this oddity
> may be a pointer toward why this is happening.
>
> I was confused why I was even seeing "create_subvol" during boot.  It
> must be then snapper makes the "main/var/lib/machines" subvolume
> during boot, not when on the archiso.  So, deleting the .snapshots
> volume booted off the ISO must be leaving btrfs in a bad state, so on
> reboot when a subvol is created by snapper, it fails.
>
>
> After a fresh install, on the first boot from the hard drive:
>
> Full dmesg here: http://pastebin.ca/3313720
> Pertinent section below:
>
> [    9.989908] ------------[ cut here ]------------
> [    9.989933] WARNING: CPU: 4 PID: 605 at fs/btrfs/ioctl.c:558
> create_subvol+0x3f2/0x721 [btrfs]()
> [    9.989934] BTRFS: Transaction aborted (error -2)
> [    9.989986] Modules linked in: hp_wmi sparse_keymap rfkill iTCO_wdt
> gpio_ich iTCO_vendor_support coretemp tg3 kvm_intel ppdev
> snd_hda_codec_realtek snd_hda_codec_generic lpc_ich mlx4_core(+) ptp
> pps_core input_leds led_class evdev snd_hda_intel libphy mac_hid kvm
> psmouse serio_raw snd_hda_codec snd_hda_core pcspkr snd_hwdep snd_pcm
> parport_pc snd_timer parport snd i5000_edac rng_core acpi_cpufreq
> soundcore edac_core wmi shpchp processor i5k_amb fjes button
> sch_fq_codel ip_tables x_tables btrfs xor raid6_pq dm_thin_pool
> dm_persistent_data crc32c_generic libcrc32c dm_bio_prison dm_bufio
> dm_mod raid1 md_mod sr_mod cdrom sd_mod ata_generic pata_acpi atkbd
> libps2 ahci libahci ata_piix uhci_hcd ehci_pci firewire_ohci libata
> ehci_hcd firewire_core crc_itu_t usbcore usb_common mptsas
> scsi_transport_sas mptscsih
> [    9.989998]  scsi_mod mptbase i8042 serio floppy ext4 crc16 mbcache
> jbd2 radeon i2c_algo_bit drm_kms_helper syscopyarea sysfillrect
> sysimgblt fb_sys_fops ttm drm
> [    9.990020] CPU: 4 PID: 605 Comm: systemd-tmpfile Not tainted 4.3.3-2-ARCH #1
> [    9.990022] Hardware name: Hewlett-Packard HP xw8400
> Workstation/0A08h, BIOS 786D5 v02.38 10/25/2010
> [    9.990025]  0000000000000000 000000000a69a5d9 ffff88085a7f78c0
> ffffffff812c0dc9
> [    9.990027]  ffff88085a7f7908 ffff88085a7f78f8 ffffffff81074f42
> 00000000fffffffe
> [    9.990029]  ffff8808566db000 ffff88085a9e4170 ffff8808575d3478
> fffffffffffffffe
> [    9.990030] Call Trace:
> [    9.990038]  [<ffffffff812c0dc9>] dump_stack+0x4b/0x72
> [    9.990043]  [<ffffffff81074f42>] warn_slowpath_common+0x82/0xc0
> [    9.990045]  [<ffffffff81074fdc>] warn_slowpath_fmt+0x5c/0x80
> [    9.990054]  [<ffffffffa05c9a6e>] create_subvol+0x3f2/0x721 [btrfs]
> [    9.990068]  [<ffffffffa058587b>] btrfs_mksubvol+0x35b/0x500 [btrfs]
> [    9.990079]  [<ffffffffa058587b>] ? btrfs_mksubvol+0x35b/0x500 [btrfs]
> [    9.990091]  [<ffffffffa0585b25>]
> btrfs_ioctl_snap_create_transid+0x105/0x180 [btrfs]
> [    9.990102]  [<ffffffffa0585bf7>] btrfs_ioctl_snap_create+0x57/0x70 [btrfs]
> [    9.990114]  [<ffffffffa058a457>] btrfs_ioctl+0x497/0x2910 [btrfs]
> [    9.990119]  [<ffffffff811e9075>] ? do_filp_open+0xa5/0x100
> [    9.990121]  [<ffffffff811eb5f5>] do_vfs_ioctl+0x295/0x480
> [    9.990124]  [<ffffffff811e8154>] ? putname+0x54/0x60
> [    9.990126]  [<ffffffff811d8bcb>] ? do_sys_open+0x1bb/0x230
> [    9.990128]  [<ffffffff811eb859>] SyS_ioctl+0x79/0x90
> [    9.990132]  [<ffffffff81583d2e>] entry_SYSCALL_64_fastpath+0x12/0x71
> [    9.990134] ---[ end trace 82633426a6c67618 ]---
> [    9.990137] BTRFS: error (device dm-17) in create_subvol:558:
> errno=-2 No such entry
> [    9.990139] BTRFS info (device dm-17): forced readonly
> [    9.990356] pending csums is 4096
> [    9.990499] systemd-journald[437]: Failed to truncate file to its
> own size: Read-only file system
>
> And then / is read-only, and tons of systemd-journald messages flood.
> I can log in and see:
>
> # btrfs subvolume list /terra
> ID 258 gen 22 top level 5 path main
> ID 259 gen 8 top level 5 path main.snapshots
> ID 260 gen 20 top level 5 path persistent
> ID 261 gen 10 top level 5 path persistent.snapshots
> ID 262 gen 20 top level 5 path snapper
>
> # btrfs subvolume get-default /terra
> ID 258 gen 22 top level 5 path main
>
> Rebooting to the arch ISO:
>
> # btrfs check /dev/disk1/terra1
> Checking filesystem on /dev/disk1/terra1
> UUID: 05321b3b-0447-43f7-9eb0-801b246a2b6c
> checking extents
> checking free space cache
> checking fs roots
> checking csums
> checking root refs
> found 897310722 bytes used err is 0
> total csum bytes: 759744
> total tree bytes: 106840064
> total fs tree bytes: 103022592
> total extent tree bytes: 2637824
> btree space waste bytes: 14738997
> file data blocks allocated: 1567948800
>  referenced 2021396480
