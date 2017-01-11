Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ua0-f174.google.com ([209.85.217.174]:33021 "EHLO
        mail-ua0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751093AbdAKXYg (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 11 Jan 2017 18:24:36 -0500
Received: by mail-ua0-f174.google.com with SMTP id i68so2434835uad.0
        for <linux-btrfs@vger.kernel.org>; Wed, 11 Jan 2017 15:24:35 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAOMcM8dtdsHEOCFNZCtSBCE3U_70DtkFOzXFzt6Dh7dTrWJGfg@mail.gmail.com>
References: <CAOMcM8dtdsHEOCFNZCtSBCE3U_70DtkFOzXFzt6Dh7dTrWJGfg@mail.gmail.com>
From: Michael Boratko <boratko@gmail.com>
Date: Wed, 11 Jan 2017 18:23:54 -0500
Message-ID: <CAOMcM8e5MeVdygbA5g_5oLbr-udGcK6Bo3HK=HP_i_E2R=6OhA@mail.gmail.com>
Subject: Re: Restart during btrfs balance raid1 conversion, now can only mount read-only
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I solved the problem. After much futzing with mount options and trying
check --repair, I ended up booting into an Antergos live USB, which
runs kernel and tools 4.9, and was able to succesfully mount the btrfs
volume there. This time, before shutting down, I paused the balance
operation. (Not sure if that was necessary.) When I rebooted back into
Debian, I was able to mount the device normally.


On Wed, Jan 11, 2017 at 4:19 PM, Michael Boratko <boratko@gmail.com> wrote:
> I had an 8TB btrfs filesystem setup with my data, and added a 4TB and
> 3TB drive to it and then ran a raid1 conversion using the command
> btrfs balance start -dconvert=raid1 -mconvert=raid1 /mnt/btrfs
>
> It was running OK, but then I restarted the computer without pausing
> the rebalance (I wasn't aware that would be necessary). Upon reboot,
> the system got stuck on the mounting operation (as well as decryption
> of two of the drives - all drives are setup with encryption and
> automatically get unlocked via keyfiles at boot) and dropped me to a
> root shell. I removed the line which was mounting the btrfs volume in
> fstab, and rebooted successfully, however now when I attempt to mount
> the btrfs volume normally it just hangs with no response, and the
> command never terminates and cannot be killed.
>
> I am able to mount the drive read-only, but am unable to mount it as
> read-write even when using the mount option "skip_balance".
>
> Relevant debug info:
> uname -a
> Linux gaussBonnetXeon 4.8.0-0.bpo.2-amd64 #1 SMP Debian
> 4.8.11-1~bpo8+1 (2016-12-14) x86_64 GNU/Linux
>
> btrfs --version
> btrfs-progs v4.7.3
>
> btrfs fi show
> Label: none  uuid: d5c3f49c-3c69-4fd8-b9ab-272c0dbc1eab
> Total devices 3 FS bytes used 2.61TiB
> devid    1 size 7.00TiB used 2.64TiB path /dev/mapper/Seagate_Archive_8TB-btrfs
> devid    2 size 3.64TiB used 930.00GiB path /dev/mapper/4TB
> devid    3 size 2.73TiB used 0.00B path /dev/mapper/3TB
>
> btrfs fi df /mnt/btrfs
> Data, RAID1: total=925.00GiB, used=912.85GiB
> Data, single: total=1.71TiB, used=1.71TiB
> System, DUP: total=8.00MiB, used=352.00KiB
> Metadata, RAID1: total=5.00GiB, used=2.12GiB
> Metadata, DUP: total=8.50GiB, used=7.61GiB
> GlobalReserve, single: total=512.00MiB, used=1.05MiB
>
> dmesg (from when I try to mount as rw):
> [ 3202.640391] BTRFS info (device dm-10): disk space caching is enabled
> [ 3377.624283] BUG: unable to handle kernel paging request at fffffffffffffe10
> [ 3377.624293] IP: [<ffffffffc0618c9b>]
> qgroup_fix_relocated_data_extents+0x2b/0x2c0 [btrfs]
> [ 3377.624341] PGD 111e09067 PUD 111e0b067 PMD 0
> [ 3377.624348] Oops: 0000 [#1] SMP
> [ 3377.624352] Modules linked in: ipt_REJECT(E) nf_reject_ipv4(E)
> rfcomm(E) xt_multiport(E) iptable_filter(E) ip_tables(E) x_tables(E)
> binfmt_misc(E) nfsd(E) auth_rpcgss(E) nfs_acl(E) lockd(E) grace(E)
> sunrpc(E) bnep(E) cfg80211(E) snd_hda_codec_hdmi(E) nvidia_drm(POE)
> btusb(E) btrtl(E) drm_kms_helper(E) btbcm(E) btintel(E) drm(E)
> bluetooth(E) iTCO_wdt(E) iTCO_vendor_support(E) coretemp(E) joydev(E)
> kvm_intel(E) snd_hda_intel(E) snd_ca0106(E) rfkill(E) evdev(E)
> snd_hda_codec(E) nvidia_modeset(POE) snd_rawmidi(E) kvm(E)
> snd_seq_device(E) snd_hda_core(E) snd_ac97_codec(E) snd_hwdep(E)
> i7core_edac(E) i2c_i801(E) snd_pcm(E) nvidia(POE) irqbypass(E)
> pcspkr(E) edac_core(E) i2c_smbus(E) snd_timer(E) snd(E) soundcore(E)
> ac97_bus(E) ipmi_si(E) ipmi_msghandler(E) shpchp(E) lpc_ich(E)
> mfd_core(E) acpi_cpufreq(E)
> [ 3377.624400]  button(E) tpm_tis(E) tpm_tis_core(E) tpm(E) fuse(E)
> parport_pc(E) ppdev(E) lp(E) parport(E) autofs4(E) ext4(E) crc16(E)
> jbd2(E) fscrypto(E) mbcache(E) btrfs(E) xor(E) raid6_pq(E) xts(E)
> gf128mul(E) algif_skcipher(E) af_alg(E) dm_crypt(E) dm_mod(E)
> sr_mod(E) cdrom(E) hid_generic(E) usbhid(E) hid(E) sg(E) sd_mod(E)
> ahci(E) libahci(E) xhci_pci(E) crc32c_intel(E) ehci_pci(E) xhci_hcd(E)
> libata(E) ehci_hcd(E) e1000e(E) scsi_mod(E) usbcore(E) ptp(E)
> usb_common(E) pps_core(E) fjes(E)
> [ 3377.624426] CPU: 0 PID: 1909 Comm: mount Tainted: P           OE
> 4.8.0-0.bpo.2-amd64 #1 Debian 4.8.11-1~bpo8+1
> [ 3377.624428] Hardware name: Intel Corporation S3420GP/S3420GP, BIOS
> S3420GP.86B.01.00.0040.021120101620 02/11/2010
> [ 3377.624430] task: ffff9277e47f7100 task.stack: ffff92770a060000
> [ 3377.624431] RIP: 0010:[<ffffffffc0618c9b>]  [<ffffffffc0618c9b>]
> qgroup_fix_relocated_data_extents+0x2b/0x2c0 [btrfs]
> [ 3377.624454] RSP: 0018:ffff92770a063cb8  EFLAGS: 00210246
> [ 3377.624455] RAX: ffff927805ee3000 RBX: ffff92772a31de00 RCX: 0000000000000000
> [ 3377.624457] RDX: ffff9277edf22090 RSI: ffff9274d3f5b800 RDI: ffff9277edf22000
> [ 3377.624458] RBP: ffff927805e5d800 R08: 0000000000000000 R09: ffff9277edf22000
> [ 3377.624460] R10: 0000000000000000 R11: 0000000000000000 R12: ffff92770a063d50
> [ 3377.624461] R13: ffff9274d3f5b800 R14: 0000000000000000 R15: ffff9277edf22000
> [ 3377.624463] FS:  00007f0f98765840(0000) GS:ffff92781fc00000(0000)
> knlGS:0000000000000000
> [ 3377.624465] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [ 3377.624467] CR2: fffffffffffffe10 CR3: 000000034b952000 CR4: 00000000000006f0
> [ 3377.624468] Stack:
> [ 3377.624470]  ffffffffc05c14a2 0000000000000801 ffff9277edf22000
> ffff927805ee3000
> [ 3377.624473]  0000000000000801 ffff9277edf22000 ffffffffc05c3ed6
> 0000000000000000
> [ 3377.624476]  0000000000000000 00000000dc2f7325 ffff92772a31de00
> ffff927805e5d800
> [ 3377.624478] Call Trace:
> [ 3377.624497]  [<ffffffffc05c14a2>] ?
> join_transaction.isra.15+0x22/0x3f0 [btrfs]
> [ 3377.624516]  [<ffffffffc05c3ed6>] ? start_transaction+0x96/0x4d0 [btrfs]
> [ 3377.624537]  [<ffffffffc061d288>] ?
> btrfs_recover_relocation+0x2e8/0x420 [btrfs]
> [ 3377.624551]  [<ffffffffc0592fff>] ? btrfs_remount+0x40f/0x570 [btrfs]
> [ 3377.624555]  [<ffffffff8941d852>] ? shrink_dcache_sb+0xd2/0x120
> [ 3377.624558]  [<ffffffff894087c8>] ? do_remount_sb+0x68/0x1d0
> [ 3377.624561]  [<ffffffff89428249>] ? do_mount+0x709/0xc70
> [ 3377.624564]  [<ffffffff893a256a>] ? memdup_user+0x4a/0x70
> [ 3377.624566]  [<ffffffff89428a94>] ? SyS_mount+0x84/0xc0
> [ 3377.624570]  [<ffffffff897f3b76>] ? system_call_fast_compare_end+0xc/0x96
> [ 3377.624571] Code: 66 66 66 66 90 41 57 41 56 41 55 41 54 55 53 48
> 83 ec 50 4c 8b 76 10 65 48 8b 04 25 28 00 00 00 48 89 44 24 48 31 c0
> 48 8b 46 08 <49> 8b ae 10 fe ff ff 48 8b 98 f0 01 00 00 31 c0 f6 83 50
> 0d 00
> [ 3377.624600] RIP  [<ffffffffc0618c9b>]
> qgroup_fix_relocated_data_extents+0x2b/0x2c0 [btrfs]
> [ 3377.624621]  RSP <ffff92770a063cb8>
> [ 3377.624622] CR2: fffffffffffffe10
> [ 3377.624624] ---[ end trace 547a7c76f9cea091 ]---
