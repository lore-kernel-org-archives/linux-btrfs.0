Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mondschein.lichtvoll.de ([194.150.191.11]:58371 "EHLO
	mail.lichtvoll.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752039Ab2FPUXW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 16 Jun 2012 16:23:22 -0400
Received: from merkaba.localnet (ppp-93-104-149-2.dynamic.mnet-online.de [93.104.149.2])
	by mail.lichtvoll.de (Postfix) with ESMTPSA id EDD04B9
	for <linux-btrfs@vger.kernel.org>; Sat, 16 Jun 2012 22:23:20 +0200 (CEST)
From: Martin Steigerwald <Martin@lichtvoll.de>
To: linux-btrfs@vger.kernel.org
Subject: kernel got struck while scrubbing BTRFS with node- and leafsize 32768
Date: Sat, 16 Jun 2012 22:23:20 +0200
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <201206162223.20392.Martin@lichtvoll.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi!

I switched my external data harddisk to BTRFS with node- and leafsize
32768. For that I formatted it with mkfs.btrfs -l 32768 -n 32768 -L daten.
This is amazon-daten. A 500 GB 2,5 inch disk connected via eSATA
from ThinkPad T520 Minidock.

After that I recopied the files from my backup BTRFS – I think I will
have one filesystem != btrfs in the future, either the backup or the
"production" one". The backup one is /mnt/steigerwald-daten, a 2 TB disk
connected via Delock ExpressCard eSATA adapter (Silicon Image).


On recopying the backup from steigerwald-daten via rsync I got some read
errors on the backup due to invalid checksums:

    10850926 100%   10.36MB/s    0:00:00 (xfer#4, to-check=1002/86585)
rsync: read errors mapping "/mnt/steigerwald-daten/somefile": Input/output error (5)
ERROR: somefile failed verification -- update discarded.
[… some more of these …]

[246028.219701] btrfs csum failed ino 151001 off 9441280 csum 3484644058 private 2813574800
[246028.368763] btrfs csum failed ino 151001 off 9441280 csum 3484644058 private 2813574800
[246028.369013] btrfs csum failed ino 151001 off 9441280 csum 3484644058 private 2813574800
[246028.384498] btrfs csum failed ino 151002 off 0 csum 3325685936 private 4028003437
[246028.385024] btrfs csum failed ino 151002 off 0 csum 3325685936 private 4028003437
[246028.396389] btrfs csum failed ino 151002 off 524288 csum 1267190645 private 3947228526
[246028.400245] btrfs csum failed ino 151002 off 1048576 csum 1066043438 private 803442567
[246028.400681] btrfs csum failed ino 151002 off 262144 csum 537899514 private 2279507770
[246028.408944] btrfs csum failed ino 151002 off 1572864 csum 1468655655 private 3488597932
[246028.409217] btrfs csum failed ino 151002 off 524288 csum 1267190645 private 3947228526
[246163.410607] btrfs_readpage_end_io_hook: 23 callbacks suppressed
[246163.410612] btrfs csum failed ino 151001 off 9441280 csum 3484644058 private 2813574800
[246163.453750] btrfs csum failed ino 151001 off 9441280 csum 3484644058 private 2813574800
[246163.453949] btrfs csum failed ino 151001 off 9441280 csum 3484644058 private 2813574800
[246163.459707] btrfs csum failed ino 151002 off 0 csum 3325685936 private 4028003437
[246163.460026] btrfs csum failed ino 151002 off 0 csum 3325685936 private 4028003437
[246163.472648] btrfs csum failed ino 151002 off 524288 csum 1267190645 private 3947228526
[246163.476518] btrfs csum failed ino 151002 off 1048576 csum 1066043438 private 803442567
[246163.476737] btrfs csum failed ino 151002 off 262144 csum 537899514 private 2279507770
[246163.481106] btrfs csum failed ino 151002 off 1572864 csum 1468655655 private 3488597932
[246163.481207] btrfs csum failed ino 151002 off 524288 csum 1267190645 private 3947228526
[249970.361560] btrfs_readpage_end_io_hook: 23 callbacks suppressed
[249970.361585] btrfs csum failed ino 151001 off 9441280 csum 3484644058 private 2813574800
[249970.448665] btrfs csum failed ino 151001 off 9441280 csum 3484644058 private 2813574800
[249970.448911] btrfs csum failed ino 151001 off 9441280 csum 3484644058 private 2813574800
[249970.458046] btrfs csum failed ino 151002 off 0 csum 3325685936 private 4028003437
[249970.461646] btrfs csum failed ino 151002 off 0 csum 3325685936 private 4028003437
[249970.467828] btrfs csum failed ino 151002 off 524288 csum 1267190645 private 3947228526
[249970.472160] btrfs csum failed ino 151002 off 1048576 csum 1066043438 private 803442567
[249970.472393] btrfs csum failed ino 151002 off 262144 csum 537899514 private 2279507770
[249970.477415] btrfs csum failed ino 151002 off 1572864 csum 1468655655 private 3488597932
[249970.477507] btrfs csum failed ino 151002 off 524288 csum 1267190645 private 3947228526


I have no idea where these checksum errors might come from. 2 TB disk
steigerwald reports good SMART status, no recent errors and is quite new.


Thus my plan was to recreate the backup FS from the stuff I just copied
over to the "production" BTRFS with big metadata. But I wanted to make
sure this time that the data is all good.

But now the BTRFS scrub on that device is stuck:


merkaba:~> date ; btrfs scrub status /mnt/amazon-daten
Sa 16. Jun 22:06:33 CEST 2012
scrub status for bd94ea73-6e77-4c81-b053-2401b4f52b3e
        scrub started at Sat Jun 16 21:44:09 2012, running for 1341 seconds
        total bytes scrubbed: 90.30GB with 0 errors
merkaba:~> date ; btrfs scrub cancel /mnt/amazon-daten
Sa 16. Jun 22:06:47 CEST 2012
[… hangs here …]

In dmesg I have:

[251818.022631] ------------[ cut here ]------------
[251818.022714] WARNING: at 
/media/data/mattems/src/linux-2.6-3.4.1/debian/build/source_amd64_none/fs/btrfs/extent_io.c:4522 
read_extent_buffer+0x43/0xf0 [btrfs]()
[251818.022723] Hardware name: 42433WG
[251818.022727] Modules linked in: rose usb_storage uas rfcomm bnep btusb bluetooth vboxpci(O) vboxnetadp(O) 
vboxnetflt(O) vboxdrv(O) fuse ufs qnx4 hfsplus hfs minix ntfs msdos jfs xfs reiserfs ext3 jbd ext2 cbc ecb ecryptfs udf 
snd_usb_audio snd_usbmidi_lib usbhid hid sata_sil24 pci_stub binfmt_misc ip6table_filter ip6_tables iptable_filter ip_tables 
ebtable_nat ebtables x_tables cpufreq_conservative cpufreq_powersave cpufreq_userspace cpufreq_stats uinput parport_pc 
ppdev lp parport snd_hda_codec_hdmi snd_hda_codec_conexant appletalk ipx p8023 netrom ax25 joydev nls_utf8 nls_cp437 
vfat fat ext4 crc16 jbd2 mbcache arc4 snd_hda_intel snd_hda_codec snd_hwdep snd_pcm_oss snd_mixer_oss snd_pcm 
snd_page_alloc snd_seq_midi snd_seq_midi_event snd_rawmidi snd_seq tpm_tis psmouse thinkpad_acpi tpm tpm_bios nvram ac 
serio_raw acpi_cpufreq battery snd_seq_device wmi mperf snd_timer evdev i915 iwlwifi microcode snd video button 
drm_kms_helper kvm_intel pcspkr iTCO_wdt mac80211 kvm iTCO_vendor_support processor i2c_i801 cfg80211 drm rfkill 
soundcore i2c_algo_bit i2c_core sbs sbshc power_supply coretemp input_polldev loop firewire_sbp2 autofs4 btrfs libcrc32c 
zlib_deflate raid10 raid456 async_raid6_recov async_memcpy async_pq async_xor xor async_tx raid6_pq raid1 raid0 multipath 
linear md_mod dm_mirror dm_region_hash dm_log dm_mod sd_mod sr_mod cdrom crc_t10dif crc32c_intel ghash_clmulni_intel 
ahci libahci libata firewire_ohci aesni_intel aes_x86_64 firewire_core crc_itu_t sdhci_pci sdhci mmc_core scsi_mod ehci_hcd 
aes_generic cryptd thermal thermal_sys usbcore usb_common e1000e [last unloaded: rose]
[251818.023011] Pid: 26484, comm: btrfs-endio-met Tainted: G           O 3.4-trunk-amd64 #1
[251818.023016] Call Trace:
[251818.023030]  [<ffffffff81039697>] ? warn_slowpath_common+0x78/0x8c
[251818.023073]  [<ffffffffa0245332>] ? read_extent_buffer+0x43/0xf0 [btrfs]
[251818.023119]  [<ffffffffa0269082>] ? __readahead_hook.isra.5+0x1fb/0x3c2 [btrfs]
[251818.023165]  [<ffffffffa02694c7>] ? btree_readahead_hook+0x14/0x2e [btrfs]
[251818.023224]  [<ffffffffa0222700>] ? btree_readpage_end_io_hook+0x193/0x1e7 [btrfs]
[251818.023242]  [<ffffffff81078b9d>] ? arch_local_irq_save+0x11/0x17
[251818.023309]  [<ffffffffa0242525>] ? end_bio_extent_readpage+0x135/0x6ea [btrfs]
[251818.023326]  [<ffffffff81044dd3>] ? try_to_del_timer_sync+0x6c/0x78
[251818.023339]  [<ffffffff810ef841>] ? kfree+0x5b/0x6c
[251818.023407]  [<ffffffffa024cdae>] ? worker_loop+0x176/0x494 [btrfs]
[251818.023473]  [<ffffffffa024cc38>] ? btrfs_queue_worker+0x273/0x273 [btrfs]
[251818.023492]  [<ffffffff81051ea6>] ? kthread+0x7d/0x85
[251818.023511]  [<ffffffff8135fa64>] ? kernel_thread_helper+0x4/0x10
[251818.023527]  [<ffffffff81051e29>] ? kthread_freezable_should_stop+0x3c/0x3c
[251818.023543]  [<ffffffff8135fa60>] ? gs_change+0x13/0x13
[251818.023553] ---[ end trace a163b70d2b1318b8 ]---
[251818.023657] general protection fault: 0000 [#1] SMP 
[251818.023921] CPU 2 
[251818.024021] Modules linked in: rose usb_storage uas rfcomm bnep btusb bluetooth vboxpci(O) vboxnetadp(O) 
vboxnetflt(O) vboxdrv(O) fuse ufs qnx4 hfsplus hfs minix ntfs msdos jfs xfs reiserfs ext3 jbd ext2 cbc ecb ecryptfs udf 
snd_usb_audio snd_usbmidi_lib usbhid hid sata_sil24 pci_stub binfmt_misc ip6table_filter ip6_tables iptable_filter ip_tables 
ebtable_nat ebtables x_tables cpufreq_conservative cpufreq_powersave cpufreq_userspace cpufreq_stats uinput parport_pc 
ppdev lp parport snd_hda_codec_hdmi snd_hda_codec_conexant appletalk ipx p8023 netrom ax25 joydev nls_utf8 nls_cp437 
vfat fat ext4 crc16 jbd2 mbcache arc4 snd_hda_intel snd_hda_codec snd_hwdep snd_pcm_oss snd_mixer_oss snd_pcm 
snd_page_alloc snd_seq_midi snd_seq_midi_event snd_rawmidi snd_seq tpm_tis psmouse thinkpad_acpi tpm tpm_bios nvram ac 
serio_raw acpi_cpufreq battery snd_seq_device wmi mperf snd_timer evdev i915 iwlwifi microcode snd video button 
drm_kms_helper kvm_intel pcspkr iTCO_wdt mac80211 kvm iTCO_vendor_support processor i2c_i801 cfg80211 drm rfkill 
soundcore i2c_algo_bit i2c_core sbs sbshc power_supply coretemp input_polldev loop firewire_sbp2 autofs4 btrfs libcrc32c 
zlib_deflate raid10 raid456 async_raid6_recov async_memcpy async_pq async_xor xor async_tx raid6_pq raid1 raid0 multipath 
linear md_mod dm_mirror dm_region_hash dm_log dm_mod sd_mod sr_mod cdrom crc_t10dif crc32c_intel ghash_clmulni_intel 
ahci libahci libata firewire_ohci aesni_intel aes_x86_64 firewire_core crc_itu_t sdhci_pci sdhci mmc_core scsi_mod ehci_hcd 
aes_generic cryptd thermal thermal_sys usbcore usb_common e1000e [last unloaded: rose]
[251818.031586] 
[251818.031653] Pid: 26484, comm: btrfs-endio-met Tainted: G        W  O 3.4-trunk-amd64 #1 LENOVO 42433WG/42433WG
[251818.032145] RIP: 0010:[<ffffffffa02453c8>]  [<ffffffffa02453c8>] read_extent_buffer+0xd9/0xf0 [btrfs]
[251818.032617] RSP: 0018:ffff880207dfdc00  EFLAGS: 00010246
[251818.032856] RAX: 0000000000000011 RBX: ffff8801599ef870 RCX: 0000000000000011
[251818.033103] RDX: ffff880207dfdcbf RSI: db73880000000003 RDI: ffff880207dfdcbf
[251818.033348] RBP: 0000000000000000 R08: 0000000000000048 R09: 6db6db6db6db6db7
[251818.033660] R10: 0000160000000000 R11: 0000000000001000 R12: ffff880000000000
[251818.033979] R13: 0000000000008014 R14: 0000000000000000 R15: 0000000000000008
[251818.034226] FS:  0000000000000000(0000) GS:ffff88021e280000(0000) knlGS:0000000000000000
[251818.034582] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[251818.034848] CR2: 00007f536c88f000 CR3: 000000008e999000 CR4: 00000000000407e0
[251818.035205] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[251818.035564] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[251818.035901] Process btrfs-endio-met (pid: 26484, threadinfo ffff880207dfc000, task ffff8801f1ccf710)
[251818.036310] Stack:
[251818.036406]  0000160000000000 ffff880207dfdcd0 ffff8801599ef870 ffff88001ec8a6c0
[251818.036774]  ffff88016626e000 0000000073727003 00000000000003de ffffffffa0269082
[251818.037141]  ffff88021e293600 ffff880207dfdcae ffff880207dfdcd0 0000000000007fe2
[251818.037525] Call Trace:
[251818.037744]  [<ffffffffa0269082>] ? __readahead_hook.isra.5+0x1fb/0x3c2 [btrfs]
[251818.038149]  [<ffffffffa02694c7>] ? btree_readahead_hook+0x14/0x2e [btrfs]
[251818.038528]  [<ffffffffa0222700>] ? btree_readpage_end_io_hook+0x193/0x1e7 [btrfs]
[251818.038896]  [<ffffffff81078b9d>] ? arch_local_irq_save+0x11/0x17
[251818.039264]  [<ffffffffa0242525>] ? end_bio_extent_readpage+0x135/0x6ea [btrfs]
[251818.039614]  [<ffffffff81044dd3>] ? try_to_del_timer_sync+0x6c/0x78
[251818.039775]  [<ffffffff810ef841>] ? kfree+0x5b/0x6c
[251818.039856]  [<ffffffffa024cdae>] ? worker_loop+0x176/0x494 [btrfs]
[251818.039952]  [<ffffffffa024cc38>] ? btrfs_queue_worker+0x273/0x273 [btrfs]
[251818.040042]  [<ffffffff81051ea6>] ? kthread+0x7d/0x85
[251818.040112]  [<ffffffff8135fa64>] ? kernel_thread_helper+0x4/0x10
[251818.040188]  [<ffffffff81051e29>] ? kthread_freezable_should_stop+0x3c/0x3c
[251818.040275]  [<ffffffff8135fa60>] ? gs_change+0x13/0x13
[251818.040328] Code: 4a 8b 0c 01 48 0f 47 c5 49 83 c0 08 48 29 c5 4c 01 d1 48 c1 f9 03 49 0f af c9 48 c1 e1 0c 4a 8d 34 21 
48 89 c1 4c 01 f6 45 31 f6 <f3> a4 48 89 fa 48 85 ed 75 b8 41 59 5b 5d 41 5c 41 5d 41 5e 41 
[251818.041000] RIP  [<ffffffffa02453c8>] read_extent_buffer+0xd9/0xf0 [btrfs]
[251818.041112]  RSP <ffff880207dfdc00>
[251818.156301] ---[ end trace a163b70d2b1318b9 ]---


Any idea?

Are there known issues with scrubbing large medadata volumes?


Current status of both BTRFS is:

merkaba:~#12> btrfs filesystem df /mnt/steigerwald-daten
Data: total=431.22GB, used=366.02GB
System, DUP: total=8.00MB, used=56.00KB
System: total=4.00MB, used=0.00
Metadata, DUP: total=9.38GB, used=664.77MB
Metadata: total=8.00MB, used=0.00
merkaba:~> btrfs filesystem df /mnt/amazon-daten     
Data: total=445.73GB, used=366.00GB
System, DUP: total=8.00MB, used=96.00KB
System: total=4.00MB, used=0.00
Metadata, DUP: total=10.00GB, used=662.50MB
Metadata: total=8.00MB, used=0.00


Kernel in use is:

merkaba:~> cat /proc/version
Linux version 3.4-trunk-amd64 (Debian 3.4.1-1~experimental.1) (debian-kernel@lists.debian.org) (gcc version 4.6.3 (Debian 
4.6.3-1) ) #1 SMP Wed Jun 6 10:34:53 CEST 2012


I think I just recreate the backup drive without a scrub. And I will use
btrfs without big metadata there for now. I considered XFS or Ext4, but
when the external disk or the Silicon Image eSATA card produces errors
I´d like to know it.

Data is not critically important, but I do not like to loose it either. Thus
at least two copies.

Thanks,
-- 
Martin 'Helios' Steigerwald - http://www.Lichtvoll.de
GPG: 03B0 0D6C 0040 0710 4AFA  B82F 991B EAAC A599 84C7
