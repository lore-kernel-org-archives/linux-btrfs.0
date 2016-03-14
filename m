Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from torres.zugschlus.de ([85.214.131.164]:34568 "EHLO
	torres.zugschlus.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755580AbcCNMHF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 14 Mar 2016 08:07:05 -0400
Received: from mh by torres.zugschlus.de with local (Exim 4.84)
	(envelope-from <mh+linux-btrfs@zugschlus.de>)
	id 1afRH5-0001uq-Qx
	for linux-btrfs@vger.kernel.org; Mon, 14 Mar 2016 13:07:03 +0100
Date: Mon, 14 Mar 2016 13:07:03 +0100
From: Marc Haber <mh+linux-btrfs@zugschlus.de>
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Subject: Re: New file system with same issue (was: Again, no space left on
 device while rebalancing and recipe doesnt work)
Message-ID: <20160314120703.GD2334@torres.zugschlus.de>
References: <20160227211450.GS26042@torres.zugschlus.de>
 <CAOE4rSyPvkzjKDVoQ-7U8ay5t7Pp2qeaCqh-tFg-etmgHGEOJQ@mail.gmail.com>
 <20160305143934.GE1902@torres.zugschlus.de>
 <CAJCQCtTw1+E=X1bbGgSB-fPHDtEPUO5amFUEs4fyPmTfK4QaGw@mail.gmail.com>
 <20160313115809.GQ2334@torres.zugschlus.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <20160313115809.GQ2334@torres.zugschlus.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, Mar 13, 2016 at 12:58:09PM +0100, Marc Haber wrote:
> On Sat, Mar 05, 2016 at 12:34:09PM -0700, Chris Murphy wrote:
> > The alternative if this can't be fixed, is to recreate the filesystem
> > because there's no practical way yet to migrate so many snapshots to a
> > new file system.
> 
> I recreated the file system on March 7, with 200 GiB in size, using
> btrfs-tools 4.4. The snapshot-taking process has been running since
> then, but I also regularly cleaned up. The number of snapshots on the
> new filesystem has never exceeded 1000, with the current count being
> at 148.
> 
> And btrfs balance runs into the same ENOSPC issues as the old one:

... with Qu's patch, I now get a reproducible kernel trace:

Mar 14 10:23:49 fan mh: BEGIN btrfs-balance script
Mar 14 10:23:49 fan mh: btrfs fi df /
Mar 14 10:23:49 fan root: Data, single: total=79.00GiB, used=78.42GiB
Mar 14 10:23:49 fan root: System, single: total=32.00MiB, used=16.00KiB
Mar 14 10:23:49 fan root: Metadata, single: total=10.00GiB, used=2.46GiB
Mar 14 10:23:49 fan root: GlobalReserve, single: total=512.00MiB, used=0.00B
Mar 14 10:23:49 fan mh: btrfs fi show /
Mar 14 10:23:49 fan root: Label: 'fanbtr'  uuid: 90f8d728-6bae-4fca-8cda-b368ba2c008e
Mar 14 10:23:49 fan root: #011Total devices 1 FS bytes used 80.89GiB
Mar 14 10:23:49 fan root: #011devid    1 size 200.00GiB used 89.03GiB path /dev/mapper/fanbtr
Mar 14 10:23:49 fan root: 
Mar 14 10:23:49 fan mh: btrfs fi usage /
Mar 14 10:23:49 fan root: Overall:
Mar 14 10:23:49 fan root:     Device size:#011#011 200.00GiB
Mar 14 10:23:49 fan root:     Device allocated:#011#011  89.03GiB
Mar 14 10:23:49 fan root:     Device unallocated:#011#011 110.97GiB
Mar 14 10:23:49 fan root:     Device missing:#011#011     0.00B
Mar 14 10:23:49 fan root:     Used:#011#011#011  80.89GiB
Mar 14 10:23:49 fan root:     Free (estimated):#011#011 111.54GiB#011(min: 111.54GiB)
Mar 14 10:23:49 fan root:     Data ratio:#011#011#011      1.00
Mar 14 10:23:49 fan root:     Metadata ratio:#011#011      1.00
Mar 14 10:23:49 fan root:     Global reserve:#011#011 512.00MiB#011(used: 0.00B)
Mar 14 10:23:49 fan root: 
Mar 14 10:23:49 fan root: Data,single: Size:79.00GiB, Used:78.42GiB
Mar 14 10:23:49 fan root:    /dev/mapper/fanbtr#011  79.00GiB
Mar 14 10:23:49 fan root: 
Mar 14 10:23:49 fan root: Metadata,single: Size:10.00GiB, Used:2.46GiB
Mar 14 10:23:49 fan root:    /dev/mapper/fanbtr#011  10.00GiB
Mar 14 10:23:49 fan root: 
Mar 14 10:23:49 fan root: System,single: Size:32.00MiB, Used:16.00KiB
Mar 14 10:23:49 fan root:    /dev/mapper/fanbtr#011  32.00MiB
Mar 14 10:23:49 fan root: 
Mar 14 10:23:49 fan root: Unallocated:
Mar 14 10:23:49 fan root:    /dev/mapper/fanbtr#011 110.97GiB
Mar 14 10:23:49 fan mh: BEGIN btrfs balance start /
Mar 14 10:36:46 fan kernel: [  890.995815] BTRFS info (device dm-15): 6 enospc errors during balance
Mar 14 10:36:46 fan root: ERROR: error during balancing '/': No space left on device
Mar 14 10:36:46 fan root: There may be more info in syslog - try dmesg | tail
Mar 14 10:36:46 fan root: btrfs fi df /
Mar 14 10:36:46 fan root: Data, single: total=79.00GiB, used=78.42GiB
Mar 14 10:36:46 fan root: System, single: total=32.00MiB, used=16.00KiB
Mar 14 10:36:46 fan root: Metadata, single: total=12.00GiB, used=2.46GiB
Mar 14 10:36:46 fan root: GlobalReserve, single: total=512.00MiB, used=0.00B
Mar 14 10:36:46 fan root: btrfs fi show /
Mar 14 10:36:46 fan root: Label: 'fanbtr'  uuid: 90f8d728-6bae-4fca-8cda-b368ba2c008e
Mar 14 10:36:46 fan root: #011Total devices 1 FS bytes used 80.89GiB
Mar 14 10:36:46 fan root: #011devid    1 size 200.00GiB used 91.03GiB path /dev/mapper/fanbtr
Mar 14 10:36:46 fan root: 
Mar 14 10:36:46 fan root: btrfs fi usage /
Mar 14 10:36:46 fan root: Overall:
Mar 14 10:36:46 fan root:     Device size:#011#011 200.00GiB
Mar 14 10:36:46 fan root:     Device allocated:#011#011  91.03GiB
Mar 14 10:36:46 fan root:     Device unallocated:#011#011 108.97GiB
Mar 14 10:36:46 fan root:     Device missing:#011#011     0.00B
Mar 14 10:36:46 fan root:     Used:#011#011#011  80.89GiB
Mar 14 10:36:46 fan root:     Free (estimated):#011#011 109.54GiB#011(min: 109.54GiB)
Mar 14 10:36:46 fan root:     Data ratio:#011#011#011      1.00
Mar 14 10:36:46 fan root:     Metadata ratio:#011#011      1.00
Mar 14 10:36:46 fan root:     Global reserve:#011#011 512.00MiB#011(used: 0.00B)
Mar 14 10:36:46 fan root: 
Mar 14 10:36:46 fan root: Data,single: Size:79.00GiB, Used:78.42GiB
Mar 14 10:36:46 fan root:    /dev/mapper/fanbtr#011  79.00GiB
Mar 14 10:36:46 fan root: 
Mar 14 10:36:46 fan root: Metadata,single: Size:12.00GiB, Used:2.46GiB
Mar 14 10:36:46 fan root:    /dev/mapper/fanbtr#011  12.00GiB
Mar 14 10:36:46 fan root: 
Mar 14 10:36:46 fan root: System,single: Size:32.00MiB, Used:16.00KiB
Mar 14 10:36:46 fan root:    /dev/mapper/fanbtr#011  32.00MiB
Mar 14 10:36:46 fan root: 
Mar 14 10:36:46 fan root: Unallocated:
Mar 14 10:36:46 fan root:    /dev/mapper/fanbtr#011 108.97GiB
Mar 14 10:36:46 fan root: BEGIN btrfs balance start -dprofiles=single /
Mar 14 10:48:16 fan kernel: [ 1581.228727] ------------[ cut here ]------------
Mar 14 10:48:16 fan kernel: [ 1581.228794] WARNING: CPU: 1 PID: 121 at fs/btrfs/extent-tree.c:7897 btrfs_alloc_tree_block+0xeb/0x3d6 [btrfs]()
Mar 14 10:48:16 fan kernel: [ 1581.228800] BTRFS: block rsv returned -28
Mar 14 10:48:16 fan kernel: [ 1581.228804] Modules linked in: iptable_nat nf_conntrack_ipv4 nf_defrag_ipv4 nf_nat_ipv4 nf_nat nf_conntrack ipt_REJECT nf_reject_ipv4 xt_tcpudp dummy ebtable_filter ebtables ip6table_filter ip6_tables iptable_filter ip_tables x_tables cpufreq_userspace cpufreq_stats cpufreq_powersave cpufreq_conservative bridge stp llc snd_hda_codec_realtek snd_hda_codec_generic snd_hda_codec_hdmi amd64_edac_mod edac_mce_amd kvm_amd input_leds pcspkr edac_core snd_hda_intel kvm snd_cmipci snd_hda_codec snd_mpu401_uart snd_opl3_lib snd_rawmidi snd_hda_core snd_seq_device irqbypass k10temp snd_hwdep snd_pcm_oss snd_mixer_oss snd_pcm snd_timer evdev snd asus_atk0110 soundcore acpi_cpufreq i2c_piix4 tpm_tis sg tpm processor shpchp hwmon_vid autofs4 crc32c_generic btrfs xor raid6_pq ext4 crc16 mbcache jbd2 hmac sha256_ssse3 sha256_generic drbg ansi_cprng xts gf128mul algif_skcipher af_alg dm_crypt dm_mod hid_generic usbhid hid usb_storage sr_mod sd_mod cdrom ohci_pci ahci libahci amdkfd r8169 mii radeon xhci_pci i2c_algo_bit xhci_hcd ttm sym53c8xx ehci_pci scsi_transport_spi ohci_hcd drm_kms_helper libata ehci_hcd drm usbcore scsi_mod usb_common i2c_core button
Mar 14 10:48:16 fan kernel: [ 1581.228957] CPU: 1 PID: 121 Comm: kworker/u16:2 Not tainted 4.4.5-zgws1 #2
Mar 14 10:48:16 fan kernel: [ 1581.228963] Hardware name: System manufacturer System Product Name/M5A88-V EVO, BIOS 1603    10/12/2012
Mar 14 10:48:16 fan kernel: [ 1581.229012] Workqueue: btrfs-endio-write btrfs_endio_write_helper [btrfs]
Mar 14 10:48:16 fan kernel: [ 1581.229018]  0000000000000000 ffffffff811dd418 ffff880613aafb58 0000000000000009
Mar 14 10:48:16 fan kernel: [ 1581.229026]  ffffffff81051e21 ffffffffa047d29f ffff8804350d6800 ffff880613aafbb0
Mar 14 10:48:16 fan kernel: [ 1581.229033]  ffff880610322000 ffff880531466700 ffffffff81051e79 ffffffffa04f065b
Mar 14 10:48:16 fan kernel: [ 1581.229039] Call Trace:
Mar 14 10:48:16 fan kernel: [ 1581.229052]  [<ffffffff811dd418>] ? dump_stack+0x5a/0x6f
Mar 14 10:48:16 fan kernel: [ 1581.229061]  [<ffffffff81051e21>] ? warn_slowpath_common+0x8e/0xa3
Mar 14 10:48:16 fan kernel: [ 1581.229104]  [<ffffffffa047d29f>] ? btrfs_alloc_tree_block+0xeb/0x3d6 [btrfs]
Mar 14 10:48:16 fan kernel: [ 1581.229112]  [<ffffffff81051e79>] ? warn_slowpath_fmt+0x43/0x4b
Mar 14 10:48:16 fan kernel: [ 1581.229155]  [<ffffffffa047d29f>] ? btrfs_alloc_tree_block+0xeb/0x3d6 [btrfs]
Mar 14 10:48:16 fan kernel: [ 1581.229194]  [<ffffffffa046b05b>] ? btrfs_copy_root+0x9e/0x1c1 [btrfs]
Mar 14 10:48:16 fan kernel: [ 1581.229239]  [<ffffffffa04c7844>] ? create_reloc_root+0x6c/0x196 [btrfs]
Mar 14 10:48:16 fan kernel: [ 1581.229285]  [<ffffffffa04cb3cd>] ? btrfs_init_reloc_root+0x71/0x9a [btrfs]
Mar 14 10:48:16 fan kernel: [ 1581.229329]  [<ffffffffa0489d74>] ? record_root_in_trans+0xc8/0xd5 [btrfs]
Mar 14 10:48:16 fan kernel: [ 1581.229374]  [<ffffffffa048b192>] ? btrfs_record_root_in_trans+0x42/0x5a [btrfs]
Mar 14 10:48:16 fan kernel: [ 1581.229418]  [<ffffffffa048c383>] ? start_transaction+0x2de/0x455 [btrfs]
Mar 14 10:48:16 fan kernel: [ 1581.229464]  [<ffffffffa0492c67>] ? btrfs_finish_ordered_io+0x1e2/0x4d7 [btrfs]
Mar 14 10:48:16 fan kernel: [ 1581.229474]  [<ffffffff81078953>] ? pick_next_task_fair+0x1f8/0x357
Mar 14 10:48:16 fan kernel: [ 1581.229482]  [<ffffffff810752af>] ? account_entity_dequeue+0x46/0x67
Mar 14 10:48:16 fan kernel: [ 1581.229529]  [<ffffffffa04b1ec4>] ? btrfs_scrubparity_helper+0xf4/0x233 [btrfs]
Mar 14 10:48:16 fan kernel: [ 1581.229538]  [<ffffffff81063b4f>] ? process_one_work+0x178/0x27b
Mar 14 10:48:16 fan kernel: [ 1581.229545]  [<ffffffff810640d3>] ? worker_thread+0x1da/0x280
Mar 14 10:48:16 fan kernel: [ 1581.229553]  [<ffffffff81063ef9>] ? rescuer_thread+0x284/0x284
Mar 14 10:48:16 fan kernel: [ 1581.229559]  [<ffffffff81067e59>] ? kthread+0x95/0x9d
Mar 14 10:48:16 fan kernel: [ 1581.229566]  [<ffffffff81067dc4>] ? kthread_parkme+0x16/0x16
Mar 14 10:48:16 fan kernel: [ 1581.229574]  [<ffffffff8140dfff>] ? ret_from_fork+0x3f/0x70
Mar 14 10:48:16 fan kernel: [ 1581.229580]  [<ffffffff81067dc4>] ? kthread_parkme+0x16/0x16
Mar 14 10:48:16 fan kernel: [ 1581.229586] ---[ end trace 69a5cc7238dc3665 ]---
Mar 14 10:51:06 fan root: Done, had to relocate 79 out of 92 chunks
Mar 14 10:51:06 fan root: btrfs fi df /
Mar 14 10:51:06 fan root: Data, single: total=79.00GiB, used=78.43GiB
Mar 14 10:51:06 fan root: System, single: total=32.00MiB, used=16.00KiB
Mar 14 10:51:06 fan root: Metadata, single: total=12.00GiB, used=2.46GiB
Mar 14 10:51:06 fan root: GlobalReserve, single: total=512.00MiB, used=0.00B
Mar 14 10:51:06 fan root: btrfs fi show /
Mar 14 10:51:06 fan root: Label: 'fanbtr'  uuid: 90f8d728-6bae-4fca-8cda-b368ba2c008e
Mar 14 10:51:06 fan root: #011Total devices 1 FS bytes used 80.89GiB
Mar 14 10:51:06 fan root: #011devid    1 size 200.00GiB used 91.03GiB path /dev/mapper/fanbtr
Mar 14 10:51:06 fan root: 
Mar 14 10:51:06 fan root: btrfs fi usage /
Mar 14 10:51:06 fan root: Overall:
Mar 14 10:51:06 fan root:     Device size:#011#011 200.00GiB
Mar 14 10:51:06 fan root:     Device allocated:#011#011  91.03GiB
Mar 14 10:51:06 fan root:     Device unallocated:#011#011 108.97GiB
Mar 14 10:51:06 fan root:     Device missing:#011#011     0.00B
Mar 14 10:51:06 fan root:     Used:#011#011#011  80.89GiB
Mar 14 10:51:06 fan root:     Free (estimated):#011#011 109.54GiB#011(min: 109.54GiB)
Mar 14 10:51:06 fan root:     Data ratio:#011#011#011      1.00
Mar 14 10:51:06 fan root:     Metadata ratio:#011#011      1.00
Mar 14 10:51:06 fan root:     Global reserve:#011#011 512.00MiB#011(used: 0.00B)
Mar 14 10:51:06 fan root: 
Mar 14 10:51:06 fan root: Data,single: Size:79.00GiB, Used:78.43GiB
Mar 14 10:51:06 fan root:    /dev/mapper/fanbtr#011  79.00GiB
Mar 14 10:51:06 fan root: 
Mar 14 10:51:06 fan root: Metadata,single: Size:12.00GiB, Used:2.46GiB
Mar 14 10:51:06 fan root:    /dev/mapper/fanbtr#011  12.00GiB
Mar 14 10:51:06 fan root: 
Mar 14 10:51:06 fan root: System,single: Size:32.00MiB, Used:16.00KiB
Mar 14 10:51:06 fan root:    /dev/mapper/fanbtr#011  32.00MiB
Mar 14 10:51:06 fan root: 
Mar 14 10:51:06 fan root: Unallocated:
Mar 14 10:51:06 fan root:    /dev/mapper/fanbtr#011 108.97GiB
Mar 14 10:51:06 fan root: BEGIN btrfs balance start -mprofiles=dup /
Mar 14 10:51:06 fan root: Done, had to relocate 0 out of 92 chunks
Mar 14 10:51:06 fan root: btrfs fi df /
Mar 14 10:51:06 fan root: Data, single: total=79.00GiB, used=78.43GiB
Mar 14 10:51:06 fan root: System, single: total=32.00MiB, used=16.00KiB
Mar 14 10:51:06 fan root: Metadata, single: total=12.00GiB, used=2.46GiB
Mar 14 10:51:06 fan root: GlobalReserve, single: total=512.00MiB, used=0.00B
Mar 14 10:51:06 fan root: btrfs fi show /
Mar 14 10:51:06 fan root: Label: 'fanbtr'  uuid: 90f8d728-6bae-4fca-8cda-b368ba2c008e
Mar 14 10:51:06 fan root: #011Total devices 1 FS bytes used 80.89GiB
Mar 14 10:51:06 fan root: #011devid    1 size 200.00GiB used 91.03GiB path /dev/mapper/fanbtr
Mar 14 10:51:06 fan root: 
Mar 14 10:51:06 fan root: btrfs fi usage /
Mar 14 10:51:06 fan root: Overall:
Mar 14 10:51:06 fan root:     Device size:#011#011 200.00GiB
Mar 14 10:51:06 fan root:     Device allocated:#011#011  91.03GiB
Mar 14 10:51:06 fan root:     Device unallocated:#011#011 108.97GiB
Mar 14 10:51:06 fan root:     Device missing:#011#011     0.00B
Mar 14 10:51:06 fan root:     Used:#011#011#011  80.89GiB
Mar 14 10:51:06 fan root:     Free (estimated):#011#011 109.54GiB#011(min: 109.54GiB)
Mar 14 10:51:06 fan root:     Data ratio:#011#011#011      1.00
Mar 14 10:51:06 fan root:     Metadata ratio:#011#011      1.00
Mar 14 10:51:06 fan root:     Global reserve:#011#011 512.00MiB#011(used: 0.00B)
Mar 14 10:51:06 fan root: 
Mar 14 10:51:06 fan root: Data,single: Size:79.00GiB, Used:78.43GiB
Mar 14 10:51:06 fan root:    /dev/mapper/fanbtr#011  79.00GiB
Mar 14 10:51:06 fan root: 
Mar 14 10:51:06 fan root: Metadata,single: Size:12.00GiB, Used:2.46GiB
Mar 14 10:51:06 fan root:    /dev/mapper/fanbtr#011  12.00GiB
Mar 14 10:51:06 fan root: 
Mar 14 10:51:06 fan root: System,single: Size:32.00MiB, Used:16.00KiB
Mar 14 10:51:06 fan root:    /dev/mapper/fanbtr#011  32.00MiB
Mar 14 10:51:06 fan root: 
Mar 14 10:51:06 fan root: Unallocated:
Mar 14 10:51:06 fan root:    /dev/mapper/fanbtr#011 108.97GiB
Mar 14 10:51:06 fan root: BEGIN btrfs balance start --force -sprofiles=dup /
Mar 14 10:51:06 fan root: Done, had to relocate 0 out of 92 chunks
Mar 14 10:51:06 fan root: btrfs fi df /
Mar 14 10:51:06 fan root: Data, single: total=79.00GiB, used=78.43GiB
Mar 14 10:51:06 fan root: System, single: total=32.00MiB, used=16.00KiB
Mar 14 10:51:06 fan root: Metadata, single: total=12.00GiB, used=2.46GiB
Mar 14 10:51:06 fan root: GlobalReserve, single: total=512.00MiB, used=0.00B
Mar 14 10:51:06 fan root: btrfs fi show /
Mar 14 10:51:06 fan root: Label: 'fanbtr'  uuid: 90f8d728-6bae-4fca-8cda-b368ba2c008e
Mar 14 10:51:06 fan root: #011Total devices 1 FS bytes used 80.89GiB
Mar 14 10:51:06 fan root: #011devid    1 size 200.00GiB used 91.03GiB path /dev/mapper/fanbtr
Mar 14 10:51:06 fan root: 
Mar 14 10:51:06 fan root: btrfs fi usage /
Mar 14 10:51:06 fan root: Overall:
Mar 14 10:51:06 fan root:     Device size:#011#011 200.00GiB
Mar 14 10:51:06 fan root:     Device allocated:#011#011  91.03GiB
Mar 14 10:51:06 fan root:     Device unallocated:#011#011 108.97GiB
Mar 14 10:51:06 fan root:     Device missing:#011#011     0.00B
Mar 14 10:51:06 fan root:     Used:#011#011#011  80.89GiB
Mar 14 10:51:06 fan root:     Free (estimated):#011#011 109.54GiB#011(min: 109.54GiB)
Mar 14 10:51:06 fan root:     Data ratio:#011#011#011      1.00
Mar 14 10:51:06 fan root:     Metadata ratio:#011#011      1.00
Mar 14 10:51:06 fan root:     Global reserve:#011#011 512.00MiB#011(used: 0.00B)
Mar 14 10:51:06 fan root: 
Mar 14 10:51:06 fan root: Data,single: Size:79.00GiB, Used:78.43GiB
Mar 14 10:51:06 fan root:    /dev/mapper/fanbtr#011  79.00GiB
Mar 14 10:51:06 fan root: 
Mar 14 10:51:06 fan root: Metadata,single: Size:12.00GiB, Used:2.46GiB
Mar 14 10:51:06 fan root:    /dev/mapper/fanbtr#011  12.00GiB
Mar 14 10:51:06 fan root: 
Mar 14 10:51:06 fan root: System,single: Size:32.00MiB, Used:16.00KiB
Mar 14 10:51:06 fan root:    /dev/mapper/fanbtr#011  32.00MiB
Mar 14 10:51:06 fan root: 
Mar 14 10:51:06 fan root: Unallocated:
Mar 14 10:51:06 fan root:    /dev/mapper/fanbtr#011 108.97GiB
Mar 14 10:51:06 fan root: BEGIN btrfs balance start /
Mar 14 11:08:36 fan kernel: [ 2800.565044] BTRFS info (device dm-15): 7 enospc errors during balance
Mar 14 11:08:36 fan root: ERROR: error during balancing '/': No space left on device
Mar 14 11:08:36 fan root: There may be more info in syslog - try dmesg | tail
Mar 14 11:08:36 fan mh: btrfs fi df /
Mar 14 11:08:36 fan root: Data, single: total=79.00GiB, used=78.43GiB
Mar 14 11:08:36 fan root: System, single: total=32.00MiB, used=16.00KiB
Mar 14 11:08:36 fan root: Metadata, single: total=19.00GiB, used=2.46GiB
Mar 14 11:08:36 fan root: GlobalReserve, single: total=512.00MiB, used=0.00B
Mar 14 11:08:36 fan mh: btrfs fi show /
Mar 14 11:08:36 fan root: Label: 'fanbtr'  uuid: 90f8d728-6bae-4fca-8cda-b368ba2c008e
Mar 14 11:08:36 fan root: #011Total devices 1 FS bytes used 80.89GiB
Mar 14 11:08:36 fan root: #011devid    1 size 200.00GiB used 98.03GiB path /dev/mapper/fanbtr
Mar 14 11:08:36 fan root: 
Mar 14 11:08:36 fan mh: btrfs fi usage /
Mar 14 11:08:36 fan root: Overall:
Mar 14 11:08:36 fan root:     Device size:#011#011 200.00GiB
Mar 14 11:08:36 fan root:     Device allocated:#011#011  98.03GiB
Mar 14 11:08:36 fan root:     Device unallocated:#011#011 101.97GiB
Mar 14 11:08:36 fan root:     Device missing:#011#011     0.00B
Mar 14 11:08:36 fan root:     Used:#011#011#011  80.89GiB
Mar 14 11:08:36 fan root:     Free (estimated):#011#011 102.54GiB#011(min: 102.54GiB)
Mar 14 11:08:36 fan root:     Data ratio:#011#011#011      1.00
Mar 14 11:08:36 fan root:     Metadata ratio:#011#011      1.00
Mar 14 11:08:36 fan root:     Global reserve:#011#011 512.00MiB#011(used: 0.00B)
Mar 14 11:08:36 fan root: 
Mar 14 11:08:36 fan root: Data,single: Size:79.00GiB, Used:78.43GiB
Mar 14 11:08:36 fan root:    /dev/mapper/fanbtr#011  79.00GiB
Mar 14 11:08:36 fan root: 
Mar 14 11:08:36 fan root: Metadata,single: Size:19.00GiB, Used:2.46GiB
Mar 14 11:08:36 fan root:    /dev/mapper/fanbtr#011  19.00GiB
Mar 14 11:08:36 fan root: 
Mar 14 11:08:36 fan root: System,single: Size:32.00MiB, Used:16.00KiB
Mar 14 11:08:36 fan root:    /dev/mapper/fanbtr#011  32.00MiB
Mar 14 11:08:36 fan root: 
Mar 14 11:08:36 fan root: Unallocated:
Mar 14 11:08:36 fan root:    /dev/mapper/fanbtr#011 101.97GiB
Mar 14 11:08:36 fan mh: END btrfs-balance script

Full log is at http://q.bofh.de/~mh/stuff/20160314-fanbtr-btrfs-syslog

The log was taken with enospc_debug active on the file system and all
file system, block device and storage relevant log lines were left in.

What does the trace tell us here?

Greetings
Marc

-- 
-----------------------------------------------------------------------------
Marc Haber         | "I don't trust Computers. They | Mailadresse im Header
Leimen, Germany    |  lose things."    Winona Ryder | Fon: *49 6224 1600402
Nordisch by Nature |  How to make an American Quilt | Fax: *49 6224 1600421
