Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mondschein.lichtvoll.de ([194.150.191.11]:45851 "EHLO
	mail.lichtvoll.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754090Ab3ITWZW (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 20 Sep 2013 18:25:22 -0400
Received: from merkaba.localnet (aftr-37-24-144-33.unity-media.net [37.24.144.33])
	by mail.lichtvoll.de (Postfix) with ESMTPSA id 8824E1EF
	for <linux-btrfs@vger.kernel.org>; Sat, 21 Sep 2013 00:25:20 +0200 (CEST)
From: Martin Steigerwald <Martin@lichtvoll.de>
To: linux-btrfs@vger.kernel.org
Subject: [REGRESSION] 3.12-rc1: Trying to create snapshot corrupted filesystem
Date: Sat, 21 Sep 2013 00:25:02 +0200
Message-ID: <5021349.IU75SGaY0J@merkaba>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi!

I tried to create a snapshot today like this:

merkaba:/mnt/debian-zeit> ls -l
insgesamt 0
drwxr-xr-x 1 root root 210 Sep 20 11:48 root
merkaba:/mnt/debian-zeit> btrfs subvol list /
ID 256 gen 21382 top level 5 path root
merkaba:/mnt/debian-zeit> btrfs subvol snap -r root root-2013-09-20
merkaba:/mnt/debian-zeit#1>

on

martin@merkaba:~> cat /proc/version 
Linux version 3.12.0-rc1-tp520 (martin@merkaba) (gcc version 4.8.1 (Debian 4.8.1-10) ) #30 SMP PREEMPT Tue Sep 17 12:40:01 CEST 2013

and got this:

[   44.069468] ------------[ cut here ]------------
[   44.073291] WARNING: CPU: 3 PID: 3660 at fs/btrfs/uuid-tree.c:45 btrfs_uuid_tree_add+0x4e/0x2a0 [btrfs]()
[   44.073345] Modules linked in: ip6table_filter ip6_tables iptable_filter ip_tables ebtable_nat ebtables x_tables rfcomm bnep bluetooth cuse nfnetlin
k_queue nfnetlink_log nfnetlink cpufreq_userspace cpufreq_stats cpufreq_powersave cpufreq_conservative pci_stub vboxpci(O) vboxnetadp(O) vboxnetflt(O) 
vboxdrv(O) binfmt_misc uinput ext4 crc16 mbcache jbd2 fuse ecryptfs sbs sbshc joydev hdaps(O) tp_smapi(O) thinkpad_ec(O) loop firewire_sbp2 dm_crypt sn
d_hda_codec_hdmi snd_hda_codec_conexant snd_hda_intel snd_hda_codec snd_hwdep snd_pcm_oss snd_mixer_oss x86_pkg_temp_thermal intel_powerclamp coretemp 
snd_pcm kvm_intel kvm snd_page_alloc iwldvm mac80211 microcode snd_seq_midi snd_seq_midi_event psmouse iwlwifi pcspkr serio_raw i2c_i801 snd_rawmidi lp
c_ich mfd_core cfg80211 snd_seq snd_seq_device thinkpad_acpi snd_timer tpm_tis tpm battery tpm_bios nvram ac rfkill snd evdev soundcore processor btrfs
 xor raid6_pq libcrc32c md_mod dm_mirror dm_region_hash dm_log dm_mod sg sr_mod cdrom sd_mod crc_t10dif crct10dif_pclmul crc32_pclmul crc32c_intel ghas
h_clmulni_intel aesni_intel aes_x86_64 lrw gf128mul ahci glue_helper sata_sil24 ablk_helper libahci cryptd sdhci_pci libata ehci_pci sdhci firewire_ohc
i ehci_hcd mmc_core firewire_core crc_itu_t scsi_mod usbcore e1000e usb_common ptp pps_core thermal
[   44.073393] CPU: 3 PID: 3660 Comm: btrfs Tainted: G           O 3.12.0-rc1-tp520 #30
[   44.073394] Hardware name: LENOVO 42433WG/42433WG, BIOS 8AET63WW (1.43 ) 05/08/2013
[   44.073398]  0000000000000000 ffff880201e57a58 ffffffff81420f5f 0000000000000000
[   44.073401]  ffff880201e57a90 ffffffff81036a58 ffffffffa029928f ffff88020f8e11e0
[   44.073404]  ffff880201e57be0 0000000000000000 00000000000000fb ffff880201e57aa0
[   44.073405] Call Trace:
[   44.073413]  [<ffffffff81420f5f>] dump_stack+0x4e/0x82
[   44.073418]  [<ffffffff81036a58>] warn_slowpath_common+0x7a/0x93
[   44.073451]  [<ffffffffa029928f>] ? btrfs_uuid_tree_add+0x4e/0x2a0 [btrfs]
[   44.073454]  [<ffffffff81036b10>] warn_slowpath_null+0x15/0x17
[   44.073484]  [<ffffffffa029928f>] btrfs_uuid_tree_add+0x4e/0x2a0 [btrfs]
[   44.073511]  [<ffffffffa024b3ff>] ? btrfs_update_inode+0x41/0x85 [btrfs]
[   44.073536]  [<ffffffffa0245bf5>] create_pending_snapshot+0x605/0x6c5 [btrfs]
[   44.073559]  [<ffffffffa0245d22>] create_pending_snapshots+0x6d/0x89 [btrfs]
[   44.073581]  [<ffffffffa0246606>] btrfs_commit_transaction+0x3a0/0x857 [btrfs]
[   44.073610]  [<ffffffffa026b8c1>] btrfs_mksubvol.isra.27+0x253/0x37f [btrfs]
[   44.073637]  [<ffffffffa026bb0e>] btrfs_ioctl_snap_create_transid+0x121/0x151 [btrfs]
[   44.073662]  [<ffffffffa026bc70>] btrfs_ioctl_snap_create_v2+0xcb/0x11c [btrfs]
[   44.073688]  [<ffffffffa026e45c>] btrfs_ioctl+0x419/0x1e59 [btrfs]
[   44.073692]  [<ffffffff81428d04>] ? __do_page_fault+0x33d/0x3b1
[   44.073696]  [<ffffffff81008367>] ? __cycles_2_ns+0xd/0x4d
[   44.073701]  [<ffffffff8112b891>] vfs_ioctl+0x18/0x34
[   44.073704]  [<ffffffff8112c04d>] do_vfs_ioctl+0x32f/0x3e4
[   44.073708]  [<ffffffff8112c154>] SyS_ioctl+0x52/0x7d
[   44.073712]  [<ffffffff8142ad0b>] tracesys+0xdd/0xe2
[   44.073714] ---[ end trace 2968ecf24298c279 ]---
[   44.073716] ------------[ cut here ]------------
[   44.073743] WARNING: CPU: 3 PID: 3660 at fs/btrfs/uuid-tree.c:109 btrfs_uuid_tree_add+0x177/0x2a0 [btrfs]()
[   44.073777] Modules linked in: ip6table_filter ip6_tables iptable_filter ip_tables ebtable_nat ebtables x_tables rfcomm bnep bluetooth cuse nfnetlink_queue nfnetlink_log nfnetlink cpufreq_userspace cpufreq_stats cpufreq_powersave cpufreq_conservative pci_stub vboxpci(O) vboxnetadp(O) vboxnetflt(O) vboxdrv(O) binfmt_misc uinput ext4 crc16 mbcache jbd2 fuse ecryptfs sbs sbshc joydev hdaps(O) tp_smapi(O) thinkpad_ec(O) loop firewire_sbp2 dm_crypt snd_hda_codec_hdmi snd_hda_codec_conexant snd_hda_intel snd_hda_codec snd_hwdep snd_pcm_oss snd_mixer_oss x86_pkg_temp_thermal intel_powerclamp coretemp snd_pcm kvm_intel kvm snd_page_alloc iwldvm mac80211 microcode snd_seq_midi snd_seq_midi_event psmouse iwlwifi pcspkr serio_raw i2c_i801 snd_rawmidi lpc_ich mfd_core cfg80211 snd_seq snd_seq_device thinkpad_acpi snd_timer tpm_tis tpm battery tpm_bios nvram ac rfkill snd evdev soundcore processor btrfs xor raid6_pq libcrc32c md_mod dm_mirror dm_region_hash dm_log dm_mod sg sr_mod cdrom sd_mod crc_t10dif crct10dif_pclmul crc32_pclmul crc32c_intel ghash_clmulni_intel aesni_intel aes_x86_64 lrw gf128mul ahci glue_helper sata_sil24 ablk_helper libahci cryptd sdhci_pci libata ehci_pci sdhci firewire_ohci ehci_hcd mmc_core firewire_core crc_itu_t scsi_mod usbcore e1000e usb_common ptp pps_core thermal
[   44.073804] CPU: 3 PID: 3660 Comm: btrfs Tainted: G        W  O 3.12.0-rc1-tp520 #30
[   44.073805] Hardware name: LENOVO 42433WG/42433WG, BIOS 8AET63WW (1.43 ) 05/08/2013
[   44.073808]  0000000000000000 ffff880201e57a58 ffffffff81420f5f 0000000000000000
[   44.073810]  ffff880201e57a90 ffffffff81036a58 ffffffffa02993b8 0000000000000000
[   44.073813]  ffff880201e57be0 0000000000000000 00000000000000fb ffff880201e57aa0
[   44.073814] Call Trace:
[   44.073817]  [<ffffffff81420f5f>] dump_stack+0x4e/0x82
[   44.073820]  [<ffffffff81036a58>] warn_slowpath_common+0x7a/0x93
[   44.073848]  [<ffffffffa02993b8>] ? btrfs_uuid_tree_add+0x177/0x2a0 [btrfs]
[   44.073851]  [<ffffffff81036b10>] warn_slowpath_null+0x15/0x17
[   44.073879]  [<ffffffffa02993b8>] btrfs_uuid_tree_add+0x177/0x2a0 [btrfs]
[   44.073904]  [<ffffffffa024b3ff>] ? btrfs_update_inode+0x41/0x85 [btrfs]
[   44.073926]  [<ffffffffa0245bf5>] create_pending_snapshot+0x605/0x6c5 [btrfs]
[   44.073949]  [<ffffffffa0245d22>] create_pending_snapshots+0x6d/0x89 [btrfs]
[   44.073971]  [<ffffffffa0246606>] btrfs_commit_transaction+0x3a0/0x857 [btrfs]
[   44.073998]  [<ffffffffa026b8c1>] btrfs_mksubvol.isra.27+0x253/0x37f [btrfs]
[   44.074022]  [<ffffffffa026bb0e>] btrfs_ioctl_snap_create_transid+0x121/0x151 [btrfs]
[   44.074046]  [<ffffffffa026bc70>] btrfs_ioctl_snap_create_v2+0xcb/0x11c [btrfs]
[   44.074071]  [<ffffffffa026e45c>] btrfs_ioctl+0x419/0x1e59 [btrfs]
[   44.074074]  [<ffffffff81428d04>] ? __do_page_fault+0x33d/0x3b1
[   44.074078]  [<ffffffff81008367>] ? __cycles_2_ns+0xd/0x4d
[   44.074081]  [<ffffffff8112b891>] vfs_ioctl+0x18/0x34
[   44.074085]  [<ffffffff8112c04d>] do_vfs_ioctl+0x32f/0x3e4
[   44.074088]  [<ffffffff8112c154>] SyS_ioctl+0x52/0x7d
[   44.074092]  [<ffffffff8142ad0b>] tracesys+0xdd/0xe2
[   44.074094] ---[ end trace 2968ecf24298c27a ]---
[   44.074095] ------------[ cut here ]------------
[   44.074112] WARNING: CPU: 3 PID: 3660 at fs/btrfs/super.c:255 __btrfs_abort_transaction+0x4f/0xff [btrfs]()
[   44.074113] btrfs: Transaction aborted (error -22)
[   44.074146] Modules linked in: ip6table_filter ip6_tables iptable_filter ip_tables ebtable_nat ebtables x_tables rfcomm bnep bluetooth cuse nfnetlink_queue nfnetlink_log nfnetlink cpufreq_userspace cpufreq_stats cpufreq_powersave cpufreq_conservative pci_stub vboxpci(O) vboxnetadp(O) vboxnetflt(O) vboxdrv(O) binfmt_misc uinput ext4 crc16 mbcache jbd2 fuse ecryptfs sbs sbshc joydev hdaps(O) tp_smapi(O) thinkpad_ec(O) loop firewire_sbp2 dm_crypt snd_hda_codec_hdmi snd_hda_codec_conexant snd_hda_intel snd_hda_codec snd_hwdep snd_pcm_oss snd_mixer_oss x86_pkg_temp_thermal intel_powerclamp coretemp snd_pcm kvm_intel kvm snd_page_alloc iwldvm mac80211 microcode snd_seq_midi snd_seq_midi_event psmouse iwlwifi pcspkr serio_raw i2c_i801 snd_rawmidi lpc_ich mfd_core cfg80211 snd_seq snd_seq_device thinkpad_acpi snd_timer tpm_tis tpm battery tpm_bios nvram ac rfkill snd evdev soundcore processor btrfs xor raid6_pq libcrc32c md_mod dm_mirror dm_region_hash dm_log dm_mod sg sr_mod cdrom sd_mod crc_t10dif crct10dif_pclmul crc32_pclmul crc32c_intel ghas
h_clmulni_intel aesni_intel aes_x86_64 lrw gf128mul ahci glue_helper sata_sil24 ablk_helper libahci cryptd sdhci_pci libata ehci_pci sdhci firewire_ohci ehci_hcd mmc_core firewire_core crc_itu_t scsi_mod usbcore e1000e usb_common ptp pps_core thermal
[   44.074173] CPU: 3 PID: 3660 Comm: btrfs Tainted: G        W  O 3.12.0-rc1-tp520 #30
[   44.074174] Hardware name: LENOVO 42433WG/42433WG, BIOS 8AET63WW (1.43 ) 05/08/2013
[   44.074177]  0000000000000000 ffff880201e57a68 ffffffff81420f5f ffff880201e57ab0
[   44.074180]  ffff880201e57aa0 ffffffff81036a58 ffffffffa0225c91 00000000ffffffea
[   44.074182]  ffff8800cf97b000 ffff88020f8e11e0 ffffffffa02a19b0 ffff880201e57b00
[   44.074183] Call Trace:
[   44.074186]  [<ffffffff81420f5f>] dump_stack+0x4e/0x82
[   44.074189]  [<ffffffff81036a58>] warn_slowpath_common+0x7a/0x93
[   44.074207]  [<ffffffffa0225c91>] ? __btrfs_abort_transaction+0x4f/0xff [btrfs]
[   44.074212]  [<ffffffff81036ab8>] warn_slowpath_fmt+0x47/0x49
[   44.074231]  [<ffffffffa0225c91>] __btrfs_abort_transaction+0x4f/0xff [btrfs]
[   44.074253]  [<ffffffffa0245c64>] create_pending_snapshot+0x674/0x6c5 [btrfs]
[   44.074276]  [<ffffffffa0245d22>] create_pending_snapshots+0x6d/0x89 [btrfs]
[   44.074298]  [<ffffffffa0246606>] btrfs_commit_transaction+0x3a0/0x857 [btrfs]
[   44.074323]  [<ffffffffa026b8c1>] btrfs_mksubvol.isra.27+0x253/0x37f [btrfs]
[   44.074353]  [<ffffffffa026bb0e>] btrfs_ioctl_snap_create_transid+0x121/0x151 [btrfs]
[   44.074389]  [<ffffffffa026bc70>] btrfs_ioctl_snap_create_v2+0xcb/0x11c [btrfs]
[   44.074414]  [<ffffffffa026e45c>] btrfs_ioctl+0x419/0x1e59 [btrfs]
[   44.074418]  [<ffffffff81428d04>] ? __do_page_fault+0x33d/0x3b1
[   44.074421]  [<ffffffff81008367>] ? __cycles_2_ns+0xd/0x4d
[   44.074425]  [<ffffffff8112b891>] vfs_ioctl+0x18/0x34
[   44.074428]  [<ffffffff8112c04d>] do_vfs_ioctl+0x32f/0x3e4
[   44.074432]  [<ffffffff8112c154>] SyS_ioctl+0x52/0x7d
[   44.074436]  [<ffffffff8142ad0b>] tracesys+0xdd/0xe2
[   44.074444] ---[ end trace 2968ecf24298c27b ]---
[   44.074447] BTRFS error (device sdb3) in create_pending_snapshot:1321: errno=-22 unknown
[   44.074449] BTRFS info (device sdb3): forced readonly
[   44.074453] BTRFS warning (device sdb3): Skipping commit of aborted transaction.
[   44.074455] BTRFS error (device sdb3) in cleanup_transaction:1526: errno=-22 unknown

The snapshot was not created.



The first time I got this I immediately scrubbed that / filesystem. The
scrub was fine.

I tried doing this snapshot another time after a reboot, to see whether it
happens again. It happened again. And this time the scrub got two errors:

merkaba:~> btrfs scrub status /
scrub status for 2f5c334d-249b-4c89-95cc-18572f750bd7
        scrub started at Sat Sep 21 00:12:08 2013 and finished after 56 seconds
        total bytes scrubbed: 11.91GB with 2 errors
        error details: csum=2
        corrected errors: 0, uncorrectable errors: 2, unverified errors: 0


[   17.104914] BTRFS info (device sdb3): csum failed ino 703589 off 122880 csum 4200103148 expected csum 331742955
[   17.105028] BTRFS info (device sdb3): csum failed ino 703589 off 122880 csum 4200103148 expected csum 331742955
[   33.956693] BTRFS info (device sdb3): csum failed ino 703589 off 122880 csum 4200103148 expected csum 331742955
[   63.794269] BTRFS info (device sdb3): csum failed ino 703589 off 122880 csum 4200103148 expected csum 331742955
[   63.794375] BTRFS info (device sdb3): csum failed ino 703589 off 122880 csum 4200103148 expected csum 331742955
[   63.794471] BTRFS info (device sdb3): csum failed ino 703589 off 122880 csum 4200103148 expected csum 331742955
[   63.794634] BTRFS info (device sdb3): csum failed ino 703589 off 122880 csum 4200103148 expected csum 331742955
[   63.795022] BTRFS info (device sdb3): csum failed ino 703589 off 122880 csum 4200103148 expected csum 331742955
[   63.895130] BTRFS info (device sdb3): csum failed ino 760517 off 16384 csum 2078849109 expected csum 2695320142
[   63.895499] BTRFS info (device sdb3): csum failed ino 760517 off 16384 csum 2078849109 expected csum 2695320142
[   68.374843] BTRFS info (device sdb3): csum failed ino 760517 off 16384 csum 2078849109 expected csum 2695320142
[   68.375500] BTRFS info (device sdb3): csum failed ino 760517 off 16384 csum 2078849109 expected csum 2695320142
[   70.847884] btrfs_readpage_end_io_hook: 2 callbacks suppressed
[   70.847892] BTRFS info (device sdb3): csum failed ino 760517 off 16384 csum 2078849109 expected csum 2695320142
[   70.848082] BTRFS info (device sdb3): csum failed ino 760517 off 16384 csum 2078849109 expected csum 2695320142
[   70.848422] BTRFS info (device sdb3): csum failed ino 760517 off 16384 csum 2078849109 expected csum 2695320142
[   72.125945] btrfs: checksum error at logical 347918336 on dev /dev/sdb3, sector 679528, root 256, inode 703589, offset 122880, length 3984, links 1 (path: var/log/auth.log)
[   72.125955] btrfs: bdev /dev/sdb3 errs: wr 0, rd 0, flush 0, corrupt 3, gen 0
[   72.125959] btrfs: unable to fixup (regular) error at logical 347918336 on dev /dev/sdb3
[   72.206252] btrfs: checksum error at logical 366272512 on dev /dev/sdb3, sector 715376, root 256, inode 760517, offset 16384, length 3541, links 1 (path: root/.histfile)
[   72.206265] btrfs: bdev /dev/sdb3 errs: wr 0, rd 0, flush 0, corrupt 4, gen 0
[   72.206268] btrfs: unable to fixup (regular) error at logical 366272512 on dev /dev/sdb3
[   72.713399] BTRFS info (device sdb3): csum failed ino 760517 off 16384 csum 2078849109 expected csum 2695320142
[   72.715442] BTRFS info (device sdb3): csum failed ino 760517 off 16384 csum 2078849109 expected csum 2695320142
[   72.717669] BTRFS info (device sdb3): csum failed ino 760517 off 16384 csum 2078849109 expected csum 2695320142
[   74.810905] BTRFS info (device sdb3): csum failed ino 760517 off 16384 csum 2078849109 expected csum 2695320142
[   74.813084] BTRFS info (device sdb3): csum failed ino 760517 off 16384 csum 2078849109 expected csum 2695320142
[   74.815255] BTRFS info (device sdb3): csum failed ino 760517 off 16384 csum 2078849109 expected csum 2695320142
[   75.695764] BTRFS info (device sdb3): csum failed ino 760517 off 16384 csum 2078849109 expected csum 2695320142
[   76.409554] btrfs_readpage_end_io_hook: 2 callbacks suppressed
[   76.409561] BTRFS info (device sdb3): csum failed ino 760517 off 16384 csum 2078849109 expected csum 2695320142
[   76.411572] BTRFS info (device sdb3): csum failed ino 760517 off 16384 csum 2078849109 expected csum 2695320142
[   76.411830] BTRFS info (device sdb3): csum failed ino 760517 off 16384 csum 2078849109 expected csum 2695320142
[   77.205828] BTRFS info (device sdb3): csum failed ino 760517 off 16384 csum 2078849109 expected csum 2695320142
[   77.207987] BTRFS info (device sdb3): csum failed ino 760517 off 16384 csum 2078849109 expected csum 2695320142
[   77.210291] BTRFS info (device sdb3): csum failed ino 760517 off 16384 csum 2078849109 expected csum 2695320142
[   77.928918] BTRFS info (device sdb3): csum failed ino 760517 off 16384 csum 2078849109 expected csum 2695320142
[   77.931074] BTRFS info (device sdb3): csum failed ino 760517 off 16384 csum 2078849109 expected csum 2695320142
[   77.933276] BTRFS info (device sdb3): csum failed ino 760517 off 16384 csum 2078849109 expected csum 2695320142
[   78.693109] BTRFS info (device sdb3): csum failed ino 760517 off 16384 csum 2078849109 expected csum 2695320142
[   85.671161] btrfs_readpage_end_io_hook: 9 callbacks suppressed
[   85.671169] BTRFS info (device sdb3): csum failed ino 760517 off 16384 csum 2078849109 expected csum 2695320142
[   85.673191] BTRFS info (device sdb3): csum failed ino 760517 off 16384 csum 2078849109 expected csum 2695320142
[   85.675278] BTRFS info (device sdb3): csum failed ino 760517 off 16384 csum 2078849109 expected csum 2695320142
[   90.543999] BTRFS info (device sdb3): csum failed ino 760517 off 16384 csum 2078849109 expected csum 2695320142
[   90.545910] BTRFS info (device sdb3): csum failed ino 760517 off 16384 csum 2078849109 expected csum 2695320142
[   90.546076] BTRFS info (device sdb3): csum failed ino 760517 off 16384 csum 2078849109 expected csum 2695320142
[  188.834397] BTRFS info (device sdb3): csum failed ino 760517 off 16384 csum 2078849109 expected csum 2695320142
[  188.834575] BTRFS info (device sdb3): csum failed ino 760517 off 16384 csum 2078849109 expected csum 2695320142
[  188.834674] BTRFS info (device sdb3): csum failed ino 760517 off 16384 csum 2078849109 expected csum 2695320142
[  189.805403] BTRFS info (device sdb3): csum failed ino 760517 off 16384 csum 2078849109 expected csum 2695320142
[  189.805577] BTRFS info (device sdb3): csum failed ino 760517 off 16384 csum 2078849109 expected csum 2695320142
[  189.805667] BTRFS info (device sdb3): csum failed ino 760517 off 16384 csum 2078849109 expected csum 2695320142
[  198.813652] BTRFS info (device sdb3): csum failed ino 760517 off 16384 csum 2078849109 expected csum 2695320142
[  198.813847] BTRFS info (device sdb3): csum failed ino 760517 off 16384 csum 2078849109 expected csum 2695320142
[  198.814033] BTRFS info (device sdb3): csum failed ino 760517 off 16384 csum 2078849109 expected csum 2695320142
[  200.063988] BTRFS info (device sdb3): csum failed ino 760517 off 16384 csum 2078849109 expected csum 2695320142
[  200.064164] BTRFS info (device sdb3): csum failed ino 760517 off 16384 csum 2078849109 expected csum 2695320142
[  200.064264] BTRFS info (device sdb3): csum failed ino 760517 off 16384 csum 2078849109 expected csum 2695320142
[  214.143681] BTRFS info (device sdb3): csum failed ino 760517 off 16384 csum 2078849109 expected csum 2695320142
[  214.143931] BTRFS info (device sdb3): csum failed ino 760517 off 16384 csum 2078849109 expected csum 2695320142
[  214.144060] BTRFS info (device sdb3): csum failed ino 760517 off 16384 csum 2078849109 expected csum 2695320142
[  217.938320] BTRFS info (device sdb3): csum failed ino 760517 off 16384 csum 2078849109 expected csum 2695320142
[  217.938474] BTRFS info (device sdb3): csum failed ino 760517 off 16384 csum 2078849109 expected csum 2695320142
[  217.938555] BTRFS info (device sdb3): csum failed ino 760517 off 16384 csum 2078849109 expected csum 2695320142
[  219.652380] BTRFS info (device sdb3): csum failed ino 760517 off 16384 csum 2078849109 expected csum 2695320142
[  219.652582] BTRFS info (device sdb3): csum failed ino 760517 off 16384 csum 2078849109 expected csum 2695320142
[  219.652746] BTRFS info (device sdb3): csum failed ino 760517 off 16384 csum 2078849109 expected csum 2695320142
[  220.495560] BTRFS info (device sdb3): csum failed ino 760517 off 16384 csum 2078849109 expected csum 2695320142
[  220.495776] BTRFS info (device sdb3): csum failed ino 760517 off 16384 csum 2078849109 expected csum 2695320142
[  220.495900] BTRFS info (device sdb3): csum failed ino 760517 off 16384 csum 2078849109 expected csum 2695320142
[  230.830936] BTRFS info (device sdb3): csum failed ino 760517 off 16384 csum 2078849109 expected csum 2695320142
[  230.831105] BTRFS info (device sdb3): csum failed ino 760517 off 16384 csum 2078849109 expected csum 2695320142
[  230.831202] BTRFS info (device sdb3): csum failed ino 760517 off 16384 csum 2078849109 expected csum 2695320142
[  243.215473] BTRFS info (device sdb3): csum failed ino 703589 off 122880 csum 4200103148 expected csum 331742955
[  243.215566] BTRFS info (device sdb3): csum failed ino 703589 off 122880 csum 4200103148 expected csum 331742955
[  243.218387] BTRFS info (device sdb3): csum failed ino 703589 off 122880 csum 4200103148 expected csum 331742955
[  243.218473] BTRFS info (device sdb3): csum failed ino 703589 off 122880 csum 4200103148 expected csum 331742955
[  248.000900] BTRFS info (device sdb3): csum failed ino 760517 off 16384 csum 2078849109 expected csum 2695320142
[  301.681557] BTRFS info (device sdb3): csum failed ino 760517 off 16384 csum 2078849109 expected csum 2695320142
[  301.681713] BTRFS info (device sdb3): csum failed ino 760517 off 16384 csum 2078849109 expected csum 2695320142
[  363.253315] BTRFS info (device sdb3): csum failed ino 703589 off 122880 csum 4200103148 expected csum 331742955
[  363.253475] BTRFS info (device sdb3): csum failed ino 703589 off 122880 csum 4200103148 expected csum 331742955
[  363.256074] BTRFS info (device sdb3): csum failed ino 703589 off 122880 csum 4200103148 expected csum 331742955
[  363.256252] BTRFS info (device sdb3): csum failed ino 703589 off 122880 csum 4200103148 expected csum 331742955
[  470.728931] BTRFS info (device sdb3): csum failed ino 760517 off 16384 csum 2078849109 expected csum 2695320142
[  470.729234] BTRFS info (device sdb3): csum failed ino 760517 off 16384 csum 2078849109 expected csum 2695320142
[  470.729443] BTRFS info (device sdb3): csum failed ino 760517 off 16384 csum 2078849109 expected csum 2695320142
[  478.882101] BTRFS info (device sdb3): csum failed ino 760517 off 16384 csum 2078849109 expected csum 2695320142
[  478.882526] BTRFS info (device sdb3): csum failed ino 760517 off 16384 csum 2078849109 expected csum 2695320142
[  478.882715] BTRFS info (device sdb3): csum failed ino 760517 off 16384 csum 2078849109 expected csum 2695320142
[  492.253997] BTRFS info (device sdb3): csum failed ino 760517 off 16384 csum 2078849109 expected csum 2695320142
[  492.254377] BTRFS info (device sdb3): csum failed ino 760517 off 16384 csum 2078849109 expected csum 2695320142
[  492.254611] BTRFS info (device sdb3): csum failed ino 760517 off 16384 csum 2078849109 expected csum 2695320142



This is on an only about a month old 30 GB Intel mSATA SSDMCEAC030B3 which
reports SMART status as passed and has media wearout indicator still at 100
from 100. So I bet the SSD is still fine.

Will do self-tests tomorrow nonetheless.


I didn¥t try this on another BTRFS filesystem and I do not feel comfortable
trying it on /home, although I have a backup from yesterday, but in a different
city :).


I will scrub /home tough, but I bet it is just fine.

I will keep / as is for now. Maybe you have some ideas where I can dig at.
Since this is a production laptop (well, heck, I still test rc1 kernels on
it), I will redo the filesystem if needed for proper operation.


To what I recall snapshots just worked fine with 3.11.

Thanks,
-- 
Martin 'Helios' Steigerwald - http://www.Lichtvoll.de
GPG: 03B0 0D6C 0040 0710 4AFA  B82F 991B EAAC A599 84C7ˇÙË∫{.n«+â∑üÆâ≠Ü+%äÀˇ±È›∂•äwˇ∫{.n«+â∑•ä{±˝ªk~œ‚ûÿ^nár°ˆ¶zÀÅÎhô®Ë≠⁄&£˚‡zø‰zπﬁó˙+Ä +zf£¢∑höàß~Ü≠Ü€iˇˇÔÅÍˇëÍÁz_ËÆÊj:+vâ®˛)ﬂ£¯m
