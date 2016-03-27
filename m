Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from torres.zugschlus.de ([85.214.131.164]:44824 "EHLO
	torres.zugschlus.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753097AbcC0Ili convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 27 Mar 2016 04:41:38 -0400
Received: from mh by torres.zugschlus.de with local (Exim 4.84_2)
	(envelope-from <mh+linux-btrfs@zugschlus.de>)
	id 1ak6GO-00040r-JA
	for linux-btrfs@vger.kernel.org; Sun, 27 Mar 2016 10:41:36 +0200
Date: Sun, 27 Mar 2016 10:41:36 +0200
From: Marc Haber <mh+linux-btrfs@zugschlus.de>
To: linux-btrfs@vger.kernel.org
Subject: Current state of old filesystem (was: Again, no space left on device
 while rebalancing and recipe doesnt work)
Message-ID: <20160327084136.GY10135@torres.zugschlus.de>
References: <20160227211450.GS26042@torres.zugschlus.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <20160227211450.GS26042@torres.zugschlus.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

I have worked on my script and have interesting new findings about the
"old" filesystem, the one that used to have the huge spread between
Size and Used for Metadata.

I have uploaded the script to
http://q.bofh.de/~mh/stuff/20160327-btrfs-balance
and a current full syslog to
http://q.bofh.de/~mh/stuff/20160326-linux-btrfs-ofanbtr

Current state is:

(1)
Filesystem has been resized to 300 GB. This has solved the "Superblock
bytenr is larger than device size" message on btrfs check. btrfs check
now runs through fine, output below.

(2)
Umounting the filesystem results in a kernel trace, given below as well.

(3)
Metadata spread is down to 27GiB/2.31 GiB, decreases to 10Gib/2.30GiB
and increases again during the run of my btrfs-balance script:
[7/507]mh@fan:~$ grep "Metadata, DUP" 20160326-linux-btrfs-ofanbtr
Mar 26 09:49:40 fan root: Metadata, DUP: total=27.00GiB, used=2.31GiB
Mar 26 10:26:15 fan root: Metadata, DUP: total=10.50GiB, used=2.30GiB
Mar 26 11:01:52 fan root: Metadata, DUP: total=10.50GiB, used=2.31GiB
Mar 26 11:03:36 fan root: Metadata, DUP: total=14.50GiB, used=2.30GiB
Mar 26 11:03:36 fan root: Metadata, DUP: total=14.50GiB, used=2.30GiB
Mar 26 11:38:40 fan root: Metadata, DUP: total=19.00GiB, used=2.31GiB
[8/508]mh@fan:~$

(4)
The attached log gives the following indications:
Mar 26 09:49:40 fan root: Metadata,DUP: Size:27.00GiB, Used:2.31GiB
Mar 26 09:49:40 fan mh: BEGIN btrfs balance start /mnt/ofanbtr
Mar 26 10:26:15 fan root: Done, had to relocate 134 out of 134 chunks
Mar 26 10:26:15 fan root: Metadata, DUP: total=10.50GiB, used=2.30GiB
Mar 26 10:26:15 fan mh: BEGIN btrfs balance start -dprofiles=single /mnt/ofanbtr
Mar 26 11:01:52 fan root: Done, had to relocate 79 out of 101 chunks
Mar 26 11:01:52 fan root: Metadata, DUP: total=10.50GiB, used=2.31GiB
Mar 26 11:01:52 fan mh: BEGIN btrfs balance start -mprofiles=dup
Mar 26 11:03:36 fan kernel: [ 4693.269593] BTRFS info (device dm-31): 9 enospc errors during balance
Mar 26 11:03:36 fan root: ERROR: error during balancing '/mnt/ofanbtr': No space left on device
Mar 26 11:03:36 fan root: There may be more info in syslog - try dmesg | tail
Mar 26 11:03:36 fan root: Metadata, DUP: total=14.50GiB, used=2.30GiB
Mar 26 11:03:36 fan mh: BEGIN btrfs balance start --force -sprofiles=dup /mnt/ofanbtr
Mar 26 11:03:36 fan root: Done, had to relocate 1 out of 109 chunks
Mar 26 11:03:36 fan root: Metadata, DUP: total=14.50GiB, used=2.30GiB
Mar 26 11:03:36 fan mh: BEGIN btrfs balance start /mnt/ofanbtr
Mar 26 11:38:40 fan kernel: [ 6796.907286] BTRFS info (device dm-31): 9 enospc errors during balance
Mar 26 11:38:40 fan root: ERROR: error during balancing '/mnt/ofanbtr': No space left on device
Mar 26 11:38:40 fan root: There may be more info in syslog - try dmesg | tail
Mar 26 11:38:40 fan root: Metadata, DUP: total=19.00GiB, used=2.31GiB

Note, that the initial btrfs balance start runs without ENOSPC, the
btrfs balance start -mprofiles=dup errors out, and the final btrfs
balance start errors out again. We thus have the case where a script
run has actually worsened the state of the filesystem.

Is this worth adding to the bug report
(https://bugzilla.kernel.org/show_bug.cgi?id=114451)? Should I include
a new btrfs image? What else should I include?

Any ideas?

Greetings
Marc



btrfs check:
Checking filesystem on /dev/mapper/ofanbtr
UUID: 4198d1bc-e3ce-40df-a7ee-44a2d120bff3
checking extents
checking free space cache
checking fs roots
checking csums
checking root refs
found 86554099816 bytes used err is 0
total csum bytes: 81815012
total tree bytes: 2476228608
total fs tree bytes: 2246311936
total extent tree bytes: 133005312
btree space waste bytes: 452682835
file data blocks allocated: 292993851392
 referenced 132664164352

Kernel trace on umount:
Mar 27 10:06:32 fan kernel: [84067.902831] ------------[ cut here ]------------
Mar 27 10:06:32 fan kernel: [84067.902861] WARNING: CPU: 5 PID: 13409 at fs/btrfs/extent-tree.c:5380 btrfs_free_block_groups+0x1bc/0x36f [btrfs]()
Mar 27 10:06:32 fan kernel: [84067.902862] Modules linked in: iptable_nat nf_conntrack_ipv4 nf_defrag_ipv4 nf_nat_ipv4 nf_nat nf_conntrack ipt_REJECT nf_reject_ipv4 xt_tcpudp dummy ebtable_filter ebtables ip6table_filter ip6_tables iptable_filter ip_tables x_tables cpufreq_userspace cpufreq_stats cpufreq_powersave cpufreq_conservative bridge stp llc kvm_amd kvm irqbypass amd64_edac_mod edac_mce_amd pcspkr edac_core k10temp snd_cmipci snd_mpu401_uart snd_opl3_lib snd_rawmidi snd_hda_codec_realtek snd_seq_device input_leds snd_hda_codec_generic snd_hda_codec_hdmi snd_hda_intel asus_atk0110 snd_hda_codec snd_hda_core snd_hwdep snd_pcm_oss snd_mixer_oss snd_pcm sg evdev snd_timer acpi_cpufreq snd tpm_tis tpm soundcore processor shpchp i2c_piix4 hwmon_vid autofs4 crc32c_generic btrfs xor raid6_pq ext4 crc16 mbcache jbd2 hmac sha256_ssse3 sha256_generic drbg ansi_cprng xts gf128mul algif_skcipher af_alg dm_crypt dm_mod hid_generic usbhid hid usb_storage sr_mod sd_mod cdrom ohci_pci amdkfd radeon r8169 i2c_algo_bit mii sym53c8xx ahci ttm xhci_pci scsi_transport_spi libahci ehci_pci ohci_hcd xhci_hcd drm_kms_helper ehci_hcd libata drm usbcore scsi_mod usb_common i2c_core button
Mar 27 10:06:32 fan kernel: [84067.902909] CPU: 5 PID: 13409 Comm: umount Tainted: G        W    L  4.4.5-zgws1 #2
Mar 27 10:06:32 fan kernel: [84067.902911] Hardware name: System manufacturer System Product Name/M5A88-V EVO, BIOS 1603    10/12/2012
Mar 27 10:06:32 fan kernel: [84067.902913]  000000000000005b ffffffff811dd418 0000000000000000 0000000000000009
Mar 27 10:06:32 fan kernel: [84067.902915]  ffffffff81051e21 ffffffffa0481147 ffff8805f5b00000 0000000000000000
Mar 27 10:06:32 fan kernel: [84067.902917]  ffff8805f5b00080 ffff880608b5c800 ffffffffa0481147 ffff8805f5b00000
Mar 27 10:06:32 fan kernel: [84067.902919] Call Trace:
Mar 27 10:06:32 fan kernel: [84067.902923]  [<ffffffff811dd418>] ? dump_stack+0x5a/0x6f
Mar 27 10:06:32 fan kernel: [84067.902926]  [<ffffffff81051e21>] ? warn_slowpath_common+0x8e/0xa3
Mar 27 10:06:32 fan kernel: [84067.902937]  [<ffffffffa0481147>] ? btrfs_free_block_groups+0x1bc/0x36f [btrfs]
Mar 27 10:06:32 fan kernel: [84067.902947]  [<ffffffffa0481147>] ? btrfs_free_block_groups+0x1bc/0x36f [btrfs]
Mar 27 10:06:32 fan kernel: [84067.902959]  [<ffffffffa048ec72>] ? close_ctree+0x1e6/0x2f2 [btrfs]
Mar 27 10:06:32 fan kernel: [84067.902961]  [<ffffffff8113dfd9>] ? generic_shutdown_super+0x64/0xdf
Mar 27 10:06:32 fan kernel: [84067.902963]  [<ffffffff8113e181>] ? kill_anon_super+0x9/0xe
Mar 27 10:06:32 fan kernel: [84067.902972]  [<ffffffffa046d0db>] ? btrfs_kill_super+0xd/0x16 [btrfs]
Mar 27 10:06:32 fan kernel: [84067.902974]  [<ffffffff8113e286>] ? deactivate_locked_super+0x2f/0x56
Mar 27 10:06:32 fan kernel: [84067.902976]  [<ffffffff81152aff>] ? cleanup_mnt+0x4f/0x6b
Mar 27 10:06:32 fan kernel: [84067.902978]  [<ffffffff81066ab7>] ? task_work_run+0x5d/0x71
Mar 27 10:06:32 fan kernel: [84067.902981]  [<ffffffff810036dc>] ? prepare_exit_to_usermode+0x70/0x99
Mar 27 10:06:32 fan kernel: [84067.902983]  [<ffffffff8140de08>] ? int_ret_from_sys_call+0x25/0x8f
Mar 27 10:06:32 fan kernel: [84067.902985] ---[ end trace 095a538bb634d33d ]---
Mar 27 10:06:32 fan kernel: [84067.902986] ------------[ cut here ]------------
Mar 27 10:06:32 fan kernel: [84067.902997] WARNING: CPU: 5 PID: 13409 at fs/btrfs/extent-tree.c:5381 btrfs_free_block_groups+0x1d7/0x36f [btrfs]()
Mar 27 10:06:32 fan kernel: [84067.902998] Modules linked in: iptable_nat nf_conntrack_ipv4 nf_defrag_ipv4 nf_nat_ipv4 nf_nat nf_conntrack ipt_REJECT nf_reject_ipv4 xt_tcpudp dummy ebtable_filter ebtables ip6table_filter ip6_tables iptable_filter ip_tables x_tables cpufreq_userspace cpufreq_stats cpufreq_powersave cpufreq_conservative bridge stp llc kvm_amd kvm irqbypass amd64_edac_mod edac_mce_amd pcspkr edac_core k10temp snd_cmipci snd_mpu401_uart snd_opl3_lib snd_rawmidi snd_hda_codec_realtek snd_seq_device input_leds snd_hda_codec_generic snd_hda_codec_hdmi snd_hda_intel asus_atk0110 snd_hda_codec snd_hda_core snd_hwdep snd_pcm_oss snd_mixer_oss snd_pcm sg evdev snd_timer acpi_cpufreq snd tpm_tis tpm soundcore processor shpchp i2c_piix4 hwmon_vid autofs4 crc32c_generic btrfs xor raid6_pq ext4 crc16 mbcache jbd2 hmac sha256_ssse3 sha256_generic drbg ansi_cprng xts gf128mul algif_skcipher af_alg dm_crypt dm_mod hid_generic usbhid hid usb_storage sr_mod sd_mod cdrom ohci_pci amdkfd radeon r8169 i2c_algo_bit mii sym53c8xx ahci ttm xhci_pci scsi_transport_spi libahci ehci_pci ohci_hcd xhci_hcd drm_kms_helper ehci_hcd libata drm usbcore scsi_mod usb_common i2c_core button
Mar 27 10:06:32 fan kernel: [84067.903030] CPU: 5 PID: 13409 Comm: umount Tainted: G        W    L  4.4.5-zgws1 #2
Mar 27 10:06:32 fan kernel: [84067.903031] Hardware name: System manufacturer System Product Name/M5A88-V EVO, BIOS 1603    10/12/2012
Mar 27 10:06:32 fan kernel: [84067.903032]  000000000000005b ffffffff811dd418 0000000000000000 0000000000000009
Mar 27 10:06:32 fan kernel: [84067.903034]  ffffffff81051e21 ffffffffa0481162 ffff8805f5b00000 0000000000000000
Mar 27 10:06:32 fan kernel: [84067.903035]  ffff8805f5b00080 ffff880608b5c800 ffffffffa0481162 ffff8805f5b00000
Mar 27 10:06:32 fan kernel: [84067.903037] Call Trace:
Mar 27 10:06:32 fan kernel: [84067.903039]  [<ffffffff811dd418>] ? dump_stack+0x5a/0x6f
Mar 27 10:06:32 fan kernel: [84067.903041]  [<ffffffff81051e21>] ? warn_slowpath_common+0x8e/0xa3
Mar 27 10:06:32 fan kernel: [84067.903055]  [<ffffffffa0481162>] ? btrfs_free_block_groups+0x1d7/0x36f [btrfs]
Mar 27 10:06:32 fan kernel: [84067.903064]  [<ffffffffa0481162>] ? btrfs_free_block_groups+0x1d7/0x36f [btrfs]
Mar 27 10:06:32 fan kernel: [84067.903074]  [<ffffffffa048ec72>] ? close_ctree+0x1e6/0x2f2 [btrfs]
Mar 27 10:06:32 fan kernel: [84067.903076]  [<ffffffff8113dfd9>] ? generic_shutdown_super+0x64/0xdf
Mar 27 10:06:32 fan kernel: [84067.903077]  [<ffffffff8113e181>] ? kill_anon_super+0x9/0xe
Mar 27 10:06:32 fan kernel: [84067.903085]  [<ffffffffa046d0db>] ? btrfs_kill_super+0xd/0x16 [btrfs]
Mar 27 10:06:32 fan kernel: [84067.903086]  [<ffffffff8113e286>] ? deactivate_locked_super+0x2f/0x56
Mar 27 10:06:32 fan kernel: [84067.903088]  [<ffffffff81152aff>] ? cleanup_mnt+0x4f/0x6b
Mar 27 10:06:32 fan kernel: [84067.903089]  [<ffffffff81066ab7>] ? task_work_run+0x5d/0x71
Mar 27 10:06:32 fan kernel: [84067.903091]  [<ffffffff810036dc>] ? prepare_exit_to_usermode+0x70/0x99
Mar 27 10:06:32 fan kernel: [84067.903092]  [<ffffffff8140de08>] ? int_ret_from_sys_call+0x25/0x8f
Mar 27 10:06:32 fan kernel: [84067.903093] ---[ end trace 095a538bb634d33e ]---

Full log sans boring BTRFS info lines (full log including them on
http://q.bofh.de/~mh/stuff/20160326-linux-btrfs-ofanbtr):
[15/514]mh@fan:~$ grep -v -E '(relocating block group|found [[:digit:]]+ extents)' 20160326-linux-btrfs-ofanbtr
Mar 26 09:49:26 fan kernel: [  242.951247] BTRFS: device label ofanbtr devid 1 transid 22237711 /dev/dm-31
Mar 26 09:49:28 fan kernel: [  245.232833] BTRFS info (device dm-31): force clearing of disk cache
Mar 26 09:49:28 fan kernel: [  245.232846] BTRFS info (device dm-31): disk space caching is enabled
Mar 26 09:49:28 fan kernel: [  245.232851] BTRFS: has skinny extents
Mar 26 09:49:28 fan kernel: [  245.333392] BTRFS: detected SSD devices, enabling SSD mode
Mar 26 09:49:40 fan mh: BEGIN btrfs-balance script
Mar 26 09:49:40 fan root: Linux fan 4.4.5-zgws1 #2 SMP Sun Mar 13 21:00:02 UTC 2016 x86_64 GNU/Linux
Mar 26 09:49:40 fan root: /dev/mapper/ofanbtr /mnt/ofanbtr btrfs rw,relatime,ssd,space_cache,clear_cache,subvolid=5,subvol=/ 0 0
Mar 26 09:49:40 fan mh: btrfs fi df /mnt/ofanbtr
Mar 26 09:49:40 fan root: Data, single: total=79.00GiB, used=78.33GiB
Mar 26 09:49:40 fan root: System, DUP: total=32.00MiB, used=16.00KiB
Mar 26 09:49:40 fan root: Metadata, DUP: total=27.00GiB, used=2.31GiB
Mar 26 09:49:40 fan root: GlobalReserve, single: total=512.00MiB, used=0.00B
Mar 26 09:49:40 fan mh: btrfs fi show /mnt/ofanbtr
Mar 26 09:49:40 fan root: Label: 'ofanbtr'  uuid: 4198d1bc-e3ce-40df-a7ee-44a2d120bff3
Mar 26 09:49:40 fan root: #011Total devices 1 FS bytes used 80.63GiB
Mar 26 09:49:40 fan root: #011devid    1 size 300.00GiB used 133.06GiB path /dev/mapper/ofanbtr
Mar 26 09:49:40 fan root:
Mar 26 09:49:40 fan mh: btrfs fi usage /mnt/ofanbtr
Mar 26 09:49:40 fan root: Overall:
Mar 26 09:49:40 fan root:     Device size:#011#011 300.00GiB
Mar 26 09:49:40 fan root:     Device allocated:#011#011 133.06GiB
Mar 26 09:49:40 fan root:     Device unallocated:#011#011 166.94GiB
Mar 26 09:49:40 fan root:     Device missing:#011#011     0.00B
Mar 26 09:49:40 fan root:     Used:#011#011#011  82.94GiB
Mar 26 09:49:40 fan root:     Free (estimated):#011#011 167.61GiB#011(min: 84.14GiB)
Mar 26 09:49:40 fan root:     Data ratio:#011#011#011      1.00
Mar 26 09:49:40 fan root:     Metadata ratio:#011#011      2.00
Mar 26 09:49:40 fan root:     Global reserve:#011#011 512.00MiB#011(used: 0.00B)
Mar 26 09:49:40 fan root:
Mar 26 09:49:40 fan root: Data,single: Size:79.00GiB, Used:78.33GiB
Mar 26 09:49:40 fan root:    /dev/mapper/ofanbtr#011  79.00GiB
Mar 26 09:49:40 fan root:
Mar 26 09:49:40 fan root: Metadata,DUP: Size:27.00GiB, Used:2.31GiB
Mar 26 09:49:40 fan root:    /dev/mapper/ofanbtr#011  54.00GiB
Mar 26 09:49:40 fan root:
Mar 26 09:49:40 fan root: System,DUP: Size:32.00MiB, Used:16.00KiB
Mar 26 09:49:40 fan root:    /dev/mapper/ofanbtr#011  64.00MiB
Mar 26 09:49:40 fan root:
Mar 26 09:49:40 fan root: Unallocated:
Mar 26 09:49:40 fan root:    /dev/mapper/ofanbtr#011 166.94GiB
Mar 26 09:49:40 fan mh: BEGIN btrfs balance start /mnt/ofanbtr
Mar 26 10:26:15 fan root: Done, had to relocate 134 out of 134 chunks
Mar 26 10:26:15 fan mh: btrfs fi df /mnt/ofanbtr
Mar 26 10:26:15 fan root: Data, single: total=79.00GiB, used=78.32GiB
Mar 26 10:26:15 fan root: System, DUP: total=32.00MiB, used=16.00KiB
Mar 26 10:26:15 fan root: Metadata, DUP: total=10.50GiB, used=2.30GiB
Mar 26 10:26:15 fan root: GlobalReserve, single: total=512.00MiB, used=2.70MiB
Mar 26 10:26:15 fan mh: btrfs fi show /mnt/ofanbtr
Mar 26 10:26:15 fan root: Label: 'ofanbtr'  uuid: 4198d1bc-e3ce-40df-a7ee-44a2d120bff3
Mar 26 10:26:15 fan root: #011Total devices 1 FS bytes used 80.63GiB
Mar 26 10:26:15 fan root: #011devid    1 size 300.00GiB used 100.06GiB path /dev/mapper/ofanbtr
Mar 26 10:26:15 fan root:
Mar 26 10:26:15 fan mh: btrfs fi usage /mnt/ofanbtr
Mar 26 10:26:15 fan root: Overall:
Mar 26 10:26:15 fan root:     Device size:#011#011 300.00GiB
Mar 26 10:26:15 fan root:     Device allocated:#011#011 100.06GiB
Mar 26 10:26:15 fan root:     Device unallocated:#011#011 199.94GiB
Mar 26 10:26:15 fan root:     Device missing:#011#011     0.00B
Mar 26 10:26:15 fan root:     Used:#011#011#011  82.93GiB
Mar 26 10:26:15 fan root:     Free (estimated):#011#011 200.61GiB#011(min: 100.64GiB)
Mar 26 10:26:15 fan root:     Data ratio:#011#011#011      1.00
Mar 26 10:26:15 fan root:     Metadata ratio:#011#011      2.00
Mar 26 10:26:15 fan root:     Global reserve:#011#011 512.00MiB#011(used: 2.70MiB)
Mar 26 10:26:15 fan root:
Mar 26 10:26:15 fan root: Data,single: Size:79.00GiB, Used:78.32GiB
Mar 26 10:26:15 fan root:    /dev/mapper/ofanbtr#011  79.00GiB
Mar 26 10:26:15 fan root:
Mar 26 10:26:15 fan root: Metadata,DUP: Size:10.50GiB, Used:2.30GiB
Mar 26 10:26:15 fan root:    /dev/mapper/ofanbtr#011  21.00GiB
Mar 26 10:26:15 fan root:
Mar 26 10:26:15 fan root: System,DUP: Size:32.00MiB, Used:16.00KiB
Mar 26 10:26:15 fan root:    /dev/mapper/ofanbtr#011  64.00MiB
Mar 26 10:26:15 fan root:
Mar 26 10:26:15 fan root: Unallocated:
Mar 26 10:26:15 fan root:    /dev/mapper/ofanbtr#011 199.94GiB
Mar 26 10:26:15 fan mh: BEGIN btrfs balance start -dprofiles=single /mnt/ofanbtr
Mar 26 11:01:52 fan root: Done, had to relocate 79 out of 101 chunks
Mar 26 11:01:52 fan mh: btrfs fi df /mnt/ofanbtr
Mar 26 11:01:52 fan root: Data, single: total=79.00GiB, used=78.33GiB
Mar 26 11:01:52 fan root: System, DUP: total=32.00MiB, used=16.00KiB
Mar 26 11:01:52 fan root: Metadata, DUP: total=10.50GiB, used=2.31GiB
Mar 26 11:01:52 fan root: GlobalReserve, single: total=512.00MiB, used=0.00B
Mar 26 11:01:52 fan mh: btrfs fi show /mnt/ofanbtr
Mar 26 11:01:52 fan root: Label: 'ofanbtr'  uuid: 4198d1bc-e3ce-40df-a7ee-44a2d120bff3
Mar 26 11:01:52 fan root: #011Total devices 1 FS bytes used 80.63GiB
Mar 26 11:01:52 fan root: #011devid    1 size 300.00GiB used 100.06GiB path /dev/mapper/ofanbtr
Mar 26 11:01:52 fan root:
Mar 26 11:01:52 fan mh: btrfs fi usage /mnt/ofanbtr
Mar 26 11:01:52 fan root: Overall:
Mar 26 11:01:52 fan root:     Device size:#011#011 300.00GiB
Mar 26 11:01:52 fan root:     Device allocated:#011#011 100.06GiB
Mar 26 11:01:52 fan root:     Device unallocated:#011#011 199.94GiB
Mar 26 11:01:52 fan root:     Device missing:#011#011     0.00B
Mar 26 11:01:52 fan root:     Used:#011#011#011  82.94GiB
Mar 26 11:01:52 fan root:     Free (estimated):#011#011 200.61GiB#011(min: 100.64GiB)
Mar 26 11:01:52 fan root:     Data ratio:#011#011#011      1.00
Mar 26 11:01:52 fan root:     Metadata ratio:#011#011      2.00
Mar 26 11:01:52 fan root:     Global reserve:#011#011 512.00MiB#011(used: 0.00B)
Mar 26 11:01:52 fan root:
Mar 26 11:01:52 fan root: Data,single: Size:79.00GiB, Used:78.33GiB
Mar 26 11:01:52 fan root:    /dev/mapper/ofanbtr#011  79.00GiB
Mar 26 11:01:52 fan root:
Mar 26 11:01:52 fan root: Metadata,DUP: Size:10.50GiB, Used:2.31GiB
Mar 26 11:01:52 fan root:    /dev/mapper/ofanbtr#011  21.00GiB
Mar 26 11:01:52 fan root:
Mar 26 11:01:52 fan root: System,DUP: Size:32.00MiB, Used:16.00KiB
Mar 26 11:01:52 fan root:    /dev/mapper/ofanbtr#011  64.00MiB
Mar 26 11:01:52 fan root:
Mar 26 11:01:52 fan root: Unallocated:
Mar 26 11:01:52 fan root:    /dev/mapper/ofanbtr#011 199.94GiB
Mar 26 11:01:52 fan mh: BEGIN btrfs balance start -mprofiles=dup /mnt/ofanbtr
Mar 26 11:03:36 fan kernel: [ 4693.269593] BTRFS info (device dm-31): 9 enospc errors during balance
Mar 26 11:03:36 fan root: ERROR: error during balancing '/mnt/ofanbtr': No space left on device
Mar 26 11:03:36 fan root: There may be more info in syslog - try dmesg | tail
Mar 26 11:03:36 fan mh: btrfs fi df /mnt/ofanbtr
Mar 26 11:03:36 fan root: Data, single: total=79.00GiB, used=78.32GiB
Mar 26 11:03:36 fan root: System, DUP: total=32.00MiB, used=16.00KiB
Mar 26 11:03:36 fan root: Metadata, DUP: total=14.50GiB, used=2.30GiB
Mar 26 11:03:36 fan root: GlobalReserve, single: total=512.00MiB, used=0.00B
Mar 26 11:03:36 fan mh: btrfs fi show /mnt/ofanbtr
Mar 26 11:03:36 fan root: Label: 'ofanbtr'  uuid: 4198d1bc-e3ce-40df-a7ee-44a2d120bff3
Mar 26 11:03:36 fan root: #011Total devices 1 FS bytes used 80.63GiB
Mar 26 11:03:36 fan root: #011devid    1 size 300.00GiB used 108.06GiB path /dev/mapper/ofanbtr
Mar 26 11:03:36 fan root:
Mar 26 11:03:36 fan mh: btrfs fi usage /mnt/ofanbtr
Mar 26 11:03:36 fan root: Overall:
Mar 26 11:03:36 fan root:     Device size:#011#011 300.00GiB
Mar 26 11:03:36 fan root:     Device allocated:#011#011 108.06GiB
Mar 26 11:03:36 fan root:     Device unallocated:#011#011 191.94GiB
Mar 26 11:03:36 fan root:     Device missing:#011#011     0.00B
Mar 26 11:03:36 fan root:     Used:#011#011#011  82.93GiB
Mar 26 11:03:36 fan root:     Free (estimated):#011#011 192.61GiB#011(min: 96.64GiB)
Mar 26 11:03:36 fan root:     Data ratio:#011#011#011      1.00
Mar 26 11:03:36 fan root:     Metadata ratio:#011#011      2.00
Mar 26 11:03:36 fan root:     Global reserve:#011#011 512.00MiB#011(used: 0.00B)
Mar 26 11:03:36 fan root:
Mar 26 11:03:36 fan root: Data,single: Size:79.00GiB, Used:78.32GiB
Mar 26 11:03:36 fan root:    /dev/mapper/ofanbtr#011  79.00GiB
Mar 26 11:03:36 fan root:
Mar 26 11:03:36 fan root: Metadata,DUP: Size:14.50GiB, Used:2.30GiB
Mar 26 11:03:36 fan root:    /dev/mapper/ofanbtr#011  29.00GiB
Mar 26 11:03:36 fan root:
Mar 26 11:03:36 fan root: System,DUP: Size:32.00MiB, Used:16.00KiB
Mar 26 11:03:36 fan root:    /dev/mapper/ofanbtr#011  64.00MiB
Mar 26 11:03:36 fan root:
Mar 26 11:03:36 fan root: Unallocated:
Mar 26 11:03:36 fan root:    /dev/mapper/ofanbtr#011 191.94GiB
Mar 26 11:03:36 fan mh: BEGIN btrfs balance start --force -sprofiles=dup /mnt/ofanbtr
Mar 26 11:03:36 fan root: Done, had to relocate 1 out of 109 chunks
Mar 26 11:03:36 fan mh: btrfs fi df /mnt/ofanbtr
Mar 26 11:03:36 fan root: Data, single: total=79.00GiB, used=78.32GiB
Mar 26 11:03:36 fan root: System, DUP: total=32.00MiB, used=16.00KiB
Mar 26 11:03:36 fan root: Metadata, DUP: total=14.50GiB, used=2.30GiB
Mar 26 11:03:36 fan root: GlobalReserve, single: total=512.00MiB, used=0.00B
Mar 26 11:03:36 fan mh: btrfs fi show /mnt/ofanbtr
Mar 26 11:03:36 fan root: Label: 'ofanbtr'  uuid: 4198d1bc-e3ce-40df-a7ee-44a2d120bff3
Mar 26 11:03:36 fan root: #011Total devices 1 FS bytes used 80.63GiB
Mar 26 11:03:36 fan root: #011devid    1 size 300.00GiB used 108.06GiB path /dev/mapper/ofanbtr
Mar 26 11:03:36 fan root:
Mar 26 11:03:36 fan mh: btrfs fi usage /mnt/ofanbtr
Mar 26 11:03:36 fan root: Overall:
Mar 26 11:03:36 fan root:     Device size:#011#011 300.00GiB
Mar 26 11:03:36 fan root:     Device allocated:#011#011 108.06GiB
Mar 26 11:03:36 fan root:     Device unallocated:#011#011 191.94GiB
Mar 26 11:03:36 fan root:     Device missing:#011#011     0.00B
Mar 26 11:03:36 fan root:     Used:#011#011#011  82.93GiB
Mar 26 11:03:36 fan root:     Free (estimated):#011#011 192.61GiB#011(min: 96.64GiB)
Mar 26 11:03:36 fan root:     Data ratio:#011#011#011      1.00
Mar 26 11:03:36 fan root:     Metadata ratio:#011#011      2.00
Mar 26 11:03:36 fan root:     Global reserve:#011#011 512.00MiB#011(used: 0.00B)
Mar 26 11:03:36 fan root:
Mar 26 11:03:36 fan root: Data,single: Size:79.00GiB, Used:78.32GiB
Mar 26 11:03:36 fan root:    /dev/mapper/ofanbtr#011  79.00GiB
Mar 26 11:03:36 fan root:
Mar 26 11:03:36 fan root: Metadata,DUP: Size:14.50GiB, Used:2.30GiB
Mar 26 11:03:36 fan root:    /dev/mapper/ofanbtr#011  29.00GiB
Mar 26 11:03:36 fan root:
Mar 26 11:03:36 fan root: System,DUP: Size:32.00MiB, Used:16.00KiB
Mar 26 11:03:36 fan root:    /dev/mapper/ofanbtr#011  64.00MiB
Mar 26 11:03:36 fan root:
Mar 26 11:03:36 fan root: Unallocated:
Mar 26 11:03:36 fan root:    /dev/mapper/ofanbtr#011 191.94GiB
Mar 26 11:03:36 fan mh: BEGIN btrfs balance start /mnt/ofanbtr
Mar 26 11:38:40 fan kernel: [ 6796.907286] BTRFS info (device dm-31): 9 enospc errors during balance
Mar 26 11:38:40 fan root: ERROR: error during balancing '/mnt/ofanbtr': No space left on device
Mar 26 11:38:40 fan root: There may be more info in syslog - try dmesg | tail
Mar 26 11:38:40 fan mh: btrfs fi df /mnt/ofanbtr
Mar 26 11:38:40 fan root: Data, single: total=79.00GiB, used=78.33GiB
Mar 26 11:38:40 fan root: System, DUP: total=32.00MiB, used=16.00KiB
Mar 26 11:38:40 fan root: Metadata, DUP: total=19.00GiB, used=2.31GiB
Mar 26 11:38:40 fan root: GlobalReserve, single: total=512.00MiB, used=0.00B
Mar 26 11:38:40 fan mh: btrfs fi show /mnt/ofanbtr
Mar 26 11:38:40 fan root: Label: 'ofanbtr'  uuid: 4198d1bc-e3ce-40df-a7ee-44a2d120bff3
Mar 26 11:38:40 fan root: #011Total devices 1 FS bytes used 80.63GiB
Mar 26 11:38:40 fan root: #011devid    1 size 300.00GiB used 117.06GiB path /dev/mapper/ofanbtr
Mar 26 11:38:40 fan root:
Mar 26 11:38:40 fan mh: btrfs fi usage /mnt/ofanbtr
Mar 26 11:38:40 fan root: Overall:
Mar 26 11:38:40 fan root:     Device size:#011#011 300.00GiB
Mar 26 11:38:40 fan root:     Device allocated:#011#011 117.06GiB
Mar 26 11:38:40 fan root:     Device unallocated:#011#011 182.94GiB
Mar 26 11:38:40 fan root:     Device missing:#011#011     0.00B
Mar 26 11:38:40 fan root:     Used:#011#011#011  82.94GiB
Mar 26 11:38:40 fan root:     Free (estimated):#011#011 183.61GiB#011(min: 92.14GiB)
Mar 26 11:38:40 fan root:     Data ratio:#011#011#011      1.00
Mar 26 11:38:40 fan root:     Metadata ratio:#011#011      2.00
Mar 26 11:38:40 fan root:     Global reserve:#011#011 512.00MiB#011(used: 0.00B)
Mar 26 11:38:40 fan root:
Mar 26 11:38:40 fan root: Data,single: Size:79.00GiB, Used:78.33GiB
Mar 26 11:38:40 fan root:    /dev/mapper/ofanbtr#011  79.00GiB
Mar 26 11:38:40 fan root:
Mar 26 11:38:40 fan root: Metadata,DUP: Size:19.00GiB, Used:2.31GiB
Mar 26 11:38:40 fan root:    /dev/mapper/ofanbtr#011  38.00GiB
Mar 26 11:38:40 fan root:
Mar 26 11:38:40 fan root: System,DUP: Size:32.00MiB, Used:16.00KiB
Mar 26 11:38:40 fan root:    /dev/mapper/ofanbtr#011  64.00MiB
Mar 26 11:38:40 fan root:
Mar 26 11:38:40 fan root: Unallocated:
Mar 26 11:38:40 fan root:    /dev/mapper/ofanbtr#011 182.94GiB
Mar 26 11:38:40 fan mh: END btrfs-balance script
[16/515]mh@fan:~$


-- 
-----------------------------------------------------------------------------
Marc Haber         | "I don't trust Computers. They | Mailadresse im Header
Leimen, Germany    |  lose things."    Winona Ryder | Fon: *49 6224 1600402
Nordisch by Nature |  How to make an American Quilt | Fax: *49 6224 1600421
