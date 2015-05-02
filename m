Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mondschein.lichtvoll.de ([194.150.191.11]:33299 "EHLO
	mail.lichtvoll.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751966AbbEBRHp (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sat, 2 May 2015 13:07:45 -0400
From: Martin Steigerwald <martin@lichtvoll.de>
To: fdmanana@gmail.com
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: [REGRESSION] Hang during backup with rsync
Date: Sat, 02 May 2015 19:07:42 +0200
Message-ID: <3898262.9kp6fRbkBD@merkaba>
In-Reply-To: <CAL3q7H4TWwr5X+8VxdAdQ-10BYy2ZpAzHWTz7SE7D1XesDReow@mail.gmail.com>
References: <1943792.PglQ59K4TH@merkaba> <CAL3q7H4TWwr5X+8VxdAdQ-10BYy2ZpAzHWTz7SE7D1XesDReow@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Am Freitag, 1. Mai 2015, 11:30:10 schrieb Filipe David Manana:
> On Thu, Apr 30, 2015 at 6:29 PM, Martin Steigerwald <martin@lichtvoll.de> wrote:
> > Hi!
> >
> > With Linux 4.0 I had a hang while backuping /home with my still rsync
> > based backup script. /home is BTRFS Dual SSD RAID 1, backup is 2 TiB disk
> > with one big BTRFS via Expresscard eSATA controller from Delock.
> >
> > The hang was: Mouse pointer in KDE not movable anymore, Ctrl-Alt-F1 had
> > no effect. I waited for a minute at least. Maybe it would have reacted after
> > a longer time, but I wanted my machine back. Disks where idle, if I remember
> > correctly. After reboot both filesystems mount okay.
> >
> >
> > Label: 'home'  uuid:
> >         Total devices 2 FS bytes used 129.46GiB
> >         devid    1 size 170.00GiB used 146.03GiB path /dev/mapper/msata-home
> >         devid    2 size 170.00GiB used 146.03GiB path /dev/mapper/sata-home
> >
> > Label: 'steigerwald'
> >         Total devices 1 FS bytes used 1.18TiB
> >         devid    1 size 1.82TiB used 1.39TiB path /dev/sdc1
> >
> > merkaba:~> btrfs fi df /home
> > Data, RAID1: total=142.00GiB, used=126.70GiB
> > System, RAID1: total=32.00MiB, used=48.00KiB
> > Metadata, RAID1: total=4.00GiB, used=2.76GiB
> > GlobalReserve, single: total=512.00MiB, used=0.00B
> >
> > merkaba:~> btrfs fi df /mnt/steigerwald
> > Data, single: total=1.34TiB, used=1.17TiB
> > System, DUP: total=8.00MiB, used=168.00KiB
> > System, single: total=4.00MiB, used=0.00B
> > Metadata, DUP: total=25.00GiB, used=11.17GiB
> > Metadata, single: total=8.00MiB, used=0.00B
> > GlobalReserve, single: total=512.00MiB, used=0.00B
> >
> >
> > I got this in kern.log:
> >
> > Apr 30 17:14:27 merkaba kernel: [142441.099236] ata11: SATA max UDMA/100 host m128@0xf1c02000 port 0xf1c00000 irq 19
> > Apr 30 17:14:29 merkaba kernel: [142443.118750] ata11: SATA link down (SStatus 0 SControl 0)
> > Apr 30 17:14:33 merkaba kernel: [142446.570437] ata11: exception Emask 0x10 SAct 0x0 SErr 0x0 action 0xe frozen
> > Apr 30 17:14:33 merkaba kernel: [142446.570443] ata11: irq_stat 0x00b40090, PHY RDY changed
> > Apr 30 17:14:33 merkaba kernel: [142446.570453] ata11: hard resetting link
> > Apr 30 17:14:43 merkaba kernel: [142456.579984] ata11: softreset failed (timeout)
> > Apr 30 17:14:43 merkaba kernel: [142456.579999] ata11: hard resetting link
> > Apr 30 17:14:45 merkaba kernel: [142458.745258] ata11: SATA link up 3.0 Gbps (SStatus 123 SControl 0)
> > Apr 30 17:14:45 merkaba kernel: [142458.746785] ata11.00: ATA-8: Hitachi HDS5C3020ALA632, ML6OA580, max UDMA/133
> > Apr 30 17:14:45 merkaba kernel: [142458.746791] ata11.00: 3907029168 sectors, multi 0: LBA48 NCQ (depth 31/32)
> > Apr 30 17:14:45 merkaba kernel: [142458.748560] ata11.00: configured for UDMA/100
> > Apr 30 17:14:45 merkaba kernel: [142458.748590] ata11: EH complete
> > Apr 30 17:14:45 merkaba kernel: [142458.748829] scsi 11:0:0:0: Direct-Access     ATA      Hitachi HDS5C302 A580 PQ: 0 ANSI: 5
> > Apr 30 17:14:45 merkaba kernel: [142458.750317] sd 11:0:0:0: [sdc] 3907029168 512-byte logical blocks: (2.00 TB/1.81 TiB)
> > Apr 30 17:14:45 merkaba kernel: [142458.750432] sd 11:0:0:0: [sdc] Write Protect is off
> > Apr 30 17:14:45 merkaba kernel: [142458.750447] sd 11:0:0:0: [sdc] Mode Sense: 00 3a 00 00
> > Apr 30 17:14:45 merkaba kernel: [142458.750506] sd 11:0:0:0: [sdc] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
> > Apr 30 17:14:45 merkaba kernel: [142458.750596] sd 11:0:0:0: Attached scsi generic sg3 type 0
> > Apr 30 17:14:45 merkaba kernel: [142458.817366]  sdc: sdc1
> > Apr 30 17:14:45 merkaba kernel: [142458.818317] sd 11:0:0:0: [sdc] Attached SCSI disk
> > Apr 30 17:14:46 merkaba kernel: [142460.048718] BTRFS: device label steigerwald devid 1 transid 9964 /dev/sdc1
> > Apr 30 17:14:57 merkaba kernel: [142470.859313] BTRFS info (device sdc1): enabling auto defrag
> > Apr 30 17:14:57 merkaba kernel: [142470.859328] BTRFS info (device sdc1): disk space caching is enabled
> > Apr 30 17:57:46 merkaba kernel: [145039.790346] ------------[ cut here ]------------
> > Apr 30 17:57:46 merkaba kernel: [145039.796051] kernel BUG at fs/btrfs/extent_io.c:4551!
> 
> https://git.kernel.org/cgit/linux/kernel/git/stable/linux-stable.git/tree/fs/btrfs/extent_io.c?id=refs/tags/v4.0.1#n4551
> 
> line 4551 -> BUG_ON(extent_buffer_under_io(eb));
> 
> Fixed recently by https://patchwork.kernel.org/patch/6261421/
> 
> And no, it's not a recent regression. Problem goes back to 2012, it's
> just a very hard to hit race.

I redid the backup with 4.1 rc1 from yesterday plus your patch.

It worked.

No other issues so far, so

Reported-and-tested-by: Martin Steigerwald <martin@lichtvoll.de>

(if you want to take it so early, as you said its a hard to hit race)

Thanks,
Martin

> > Apr 30 17:57:46 merkaba kernel: [145039.802527] invalid opcode: 0000 [#1] PREEMPT SMP
> > Apr 30 17:57:46 merkaba kernel: [145039.808550] Modules linked in: usblp uvcvideo videobuf2_vmalloc videobuf2_memops videobuf2_core v4l2_common videodev media uas usb_storage ctr ccm rfcomm btusb ebtable_filter ebtables ip6table_filter ip6_tables iptable_filter ip_tables x_tables tun binfmt_misc cpufreq_userspace cpufreq_stats cpufreq_powersave bnep cpufreq_conservative bluetooth msr ext4 crc16 mbcache jbd2 snd_usb_audio snd_usbmidi_lib snd_rawmidi snd_seq_device x86_pkg_temp_thermal intel_powerclamp kvm_intel kvm crct10dif_pclmul crc32_pclmul ghash_clmulni_intel aesni_intel aes_x86_64 lrw gf128mul glue_helper ablk_helper snd_hda_codec_hdmi psmouse iwldvm cryptd mac80211 snd_hda_codec_conexant serio_raw snd_hda_codec_generic pcspkr i2c_i801 snd_hda_intel snd_hda_controller iwlwifi snd_hda_codec tpm_tis snd_hwdep battery thinkpad_acpi tpm cfg80211 ac snd_pcm nvram snd_timer rfkill snd soundcore lpc_ich mfd_core shpchp processor evdev joydev sbs sbshc coretemp hdaps(O) tp_smapi(O) thinkpad_ec(O) loop firewire_sbp2 fuse ecryptfs autofs4 md_mod btrfs xor raid6_pq microcode dm_mirror dm_region_hash dm_log dm_mod sg sr_mod sd_mod cdrom hid_generic usbhid hid crc32c_intel firewire_ohci ahci sdhci_pci libahci sdhci firewire_core mmc_core sata_sil24 crc_itu_t libata scsi_mod ehci_pci ehci_hcd usbcore usb_common e1000e ptp pps_core thermal
> > Apr 30 17:57:46 merkaba kernel: [145039.864382] CPU: 1 PID: 6061 Comm: kworker/u8:14 Tainted: G        W  O    4.0.0-tp520-btrfs-trim+ #25
> > Apr 30 17:57:46 merkaba kernel: [145039.871788] Hardware name: LENOVO 42433WG/42433WG, BIOS 8AET63WW (1.43 ) 05/08/2013
> > Apr 30 17:57:46 merkaba kernel: [145039.879273] Workqueue: btrfs-endio-write btrfs_endio_write_helper [btrfs]
> > Apr 30 17:57:46 merkaba kernel: [145039.887460] task: ffff8802d6501890 ti: ffff88011be90000 task.ti: ffff88011be90000
> > Apr 30 17:57:46 merkaba kernel: [145039.895164] RIP: 0010:[<ffffffffc050986d>]  [<ffffffffc050986d>] btrfs_release_extent_buffer_page+0x1b/0xde [btrfs]
> > Apr 30 17:57:46 merkaba kernel: [145039.902849] RSP: 0018:ffff88011be93998  EFLAGS: 00010202
> > Apr 30 17:57:46 merkaba kernel: [145039.910531] RAX: 0000000000000001 RBX: ffff880380dea9d8 RCX: ffff8803d34e1d18
> > Apr 30 17:57:46 merkaba kernel: [145039.919232] RDX: 0000000000000000 RSI: ffff8803d34e1b60 RDI: ffff880380dea9d8
> > Apr 30 17:57:46 merkaba kernel: [145039.927049] RBP: ffff88011be939b8 R08: 0000000000000000 R09: 0000000000000036
> > Apr 30 17:57:46 merkaba kernel: [145039.935254] R10: 0000000000000018 R11: ffff88011be93970 R12: 0000000000000005
> > Apr 30 17:57:46 merkaba kernel: [145039.942956] R13: ffff880380dea9d8 R14: ffff8802b31a2800 R15: 0000000000000227
> > Apr 30 17:57:46 merkaba kernel: [145039.950884] FS:  0000000000000000(0000) GS:ffff88041e280000(0000) knlGS:0000000000000000
> > Apr 30 17:57:46 merkaba kernel: [145039.958780] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> > Apr 30 17:57:46 merkaba kernel: [145039.966673] CR2: 00007f3bec0ed000 CR3: 0000000001a0b000 CR4: 00000000000406e0
> > Apr 30 17:57:46 merkaba kernel: [145039.974906] Stack:
> > Apr 30 17:57:46 merkaba kernel: [145039.982958]  ffff880380dea9d8 ffff88011b1ac000 ffff88011b1acd88 ffff8802b31a2800
> > Apr 30 17:57:46 merkaba kernel: [145039.991204]  ffff88011be939f8 ffffffffc05099bb 0000000000000003 ffff880380dea9f8
> > Apr 30 17:57:46 merkaba kernel: [145039.998900]  ffff88011be939f8 ffff880380dea9d8 ffff880380dea9d8 ffff880380deb3b0
> > Apr 30 17:57:46 merkaba kernel: [145040.007140] Call Trace:
> > Apr 30 17:57:46 merkaba kernel: [145040.015141]  [<ffffffffc05099bb>] release_extent_buffer+0x8b/0xbb [btrfs]
> > Apr 30 17:57:46 merkaba kernel: [145040.022895]  [<ffffffffc0509dae>] free_extent_buffer+0x8b/0x8f [btrfs]
> > Apr 30 17:57:46 merkaba kernel: [145040.030967]  [<ffffffffc04cecff>] copy_for_split+0x1b5/0x1cc [btrfs]
> > Apr 30 17:57:46 merkaba kernel: [145040.039149]  [<ffffffffc04d21cd>] split_leaf+0x23c/0x576 [btrfs]
> > Apr 30 17:57:46 merkaba kernel: [145040.047319]  [<ffffffffc04d2aa1>] btrfs_search_slot+0x59a/0x72b [btrfs]
> > Apr 30 17:57:46 merkaba kernel: [145040.055483]  [<ffffffffc04d3e01>] btrfs_insert_empty_items+0x58/0xa3 [btrfs]
> > Apr 30 17:57:46 merkaba kernel: [145040.063159]  [<ffffffffc04e57ac>] btrfs_csum_file_blocks+0x439/0x548 [btrfs]
> > Apr 30 17:57:46 merkaba kernel: [145040.071046]  [<ffffffffc04f1075>] add_pending_csums.isra.36+0x49/0x66 [btrfs]
> > Apr 30 17:57:46 merkaba kernel: [145040.078955]  [<ffffffffc04f65a3>] btrfs_finish_ordered_io+0x2c5/0x419 [btrfs]
> > Apr 30 17:57:46 merkaba kernel: [145040.086360]  [<ffffffffc04f68de>] finish_ordered_fn+0x10/0x12 [btrfs]
> > Apr 30 17:57:46 merkaba kernel: [145040.093766]  [<ffffffffc05150fe>] normal_work_helper+0xd2/0x217 [btrfs]
> > Apr 30 17:57:46 merkaba kernel: [145040.100945]  [<ffffffff8105344f>] ? pwq_activate_delayed_work+0x2c/0x3a
> > Apr 30 17:57:46 merkaba kernel: [145040.108499]  [<ffffffffc0515304>] btrfs_endio_write_helper+0xd/0xf [btrfs]
> > Apr 30 17:57:46 merkaba kernel: [145040.115728]  [<ffffffff81053e23>] process_one_work+0x15d/0x2ad
> > Apr 30 17:57:46 merkaba kernel: [145040.122849]  [<ffffffff810543ed>] worker_thread+0x1d1/0x27e
> > Apr 30 17:57:46 merkaba kernel: [145040.129947]  [<ffffffff8105421c>] ? rescuer_thread+0x27f/0x27f
> > Apr 30 17:57:46 merkaba kernel: [145040.137039]  [<ffffffff8105421c>] ? rescuer_thread+0x27f/0x27f
> > Apr 30 17:57:46 merkaba kernel: [145040.143867]  [<ffffffff81057edf>] kthread+0xb2/0xba
> > Apr 30 17:57:46 merkaba kernel: [145040.150659]  [<ffffffff81050000>] ? do_prlimit+0x35/0x1b6
> > Apr 30 17:57:46 merkaba kernel: [145040.157258]  [<ffffffff81057e2d>] ? __kthread_parkme+0x62/0x62
> > Apr 30 17:57:46 merkaba kernel: [145040.163654]  [<ffffffff814c5688>] ret_from_fork+0x58/0x90
> > Apr 30 17:57:46 merkaba kernel: [145040.170036]  [<ffffffff81057e2d>] ? __kthread_parkme+0x62/0x62
> > Apr 30 17:57:46 merkaba kernel: [145040.176191] Code: 80 75 0b 48 8b 47 10 48 c1 e8 02 83 e0 01 5d c3 55 48 89 e5 41 56 41 55 49 89 fd 41 54 53 4c 8b 67 10 e8 c3 ff ff ff 85 c0 74 02 <0f> 0b 49 8b 75 08 49 8b 7d 00 e8 40 ae ff ff 48 85 c0 49 89 c6
> > Apr 30 17:57:46 merkaba kernel: [145040.188172] RIP  [<ffffffffc050986d>] btrfs_release_extent_buffer_page+0x1b/0xde [btrfs]
> > Apr 30 17:57:46 merkaba kernel: [145040.192620]  RSP <ffff88011be93998>
> > Apr 30 17:57:46 merkaba kernel: [145040.223617] ---[ end trace 37e2d6f90374a311 ]---
> > Apr 30 17:57:46 merkaba kernel: [145040.223752] BUG: unable to handle kernel paging request at ffffffffffffffd8
> > Apr 30 17:58:47 merkaba kernel: [145040.233898] IP: [<ffffffff81058161>] kthread_data+0xc/0x11
> > Apr 30 17:58:47 merkaba kernel: [145040.243119] PGD 1a0c067 PUD 1a0e067 PMD 0
> > Apr 30 17:58:47 merkaba kernel: [145040.251934] Oops: 0000 [#2] PREEMPT SMP
> > Apr 30 17:58:47 merkaba kernel: [145040.259693] Modules linked in: usblp uvcvideo videobuf2_vmalloc videobuf2_memops videobuf2_core v4l2_common videodev media uas usb_storage ctr ccm rfcomm btusb ebtable_filter ebtables ip6table_filter ip6_tables iptable_filter ip_tables x_tables tun binfmt_misc cpufreq_userspace cpufreq_stats cpufreq_powersave bnep cpufreq_conservative bluetooth msr ext4 crc16 mbcache jbd2 snd_usb_audio snd_usbmidi_lib snd_rawmidi snd_seq_device x86_pkg_temp_thermal intel_powerclamp kvm_intel kvm crct10dif_pclmul crc32_pclmul ghash_clmulni_intel aesni_intel aes_x86_64 lrw gf128mul glue_helper ablk_helper snd_hda_codec_hdmi psmouse iwldvm cryptd mac80211 snd_hda_codec_conexant serio_raw snd_hda_codec_generic pcspkr i2c_i801 snd_hda_intel snd_hda_controller iwlwifi snd_hda_codec tpm_tis snd_hwdep battery thinkpad_acpi tpm cfg80211 ac snd_pcm nvram snd_timer rfkill snd soundcore lpc_ich mfd_core shpchp processor evdev joydev sbs sbshc coretemp hdaps(O) tp_smapi(O) thinkpad_ec(O) loop firewire_sbp2 fuse ecryptfs autofs4 md_mod btrfs xor raid6_pq microcode dm_mirror dm_region_hash dm_log dm_mod sg sr_mod sd_mod cdrom hid_generic usbhid hid crc32c_intel firewire_ohci ahci sdhci_pci libahci sdhci firewire_core mmc_core sata_sil24 crc_itu_t libata scsi_mod ehci_pci ehci_hcd usbcore usb_common e1000e ptp pps_core thermal
> > Apr 30 17:58:47 merkaba kernel: [145040.335818] CPU: 1 PID: 6061 Comm: kworker/u8:14 Tainted: G      D W  O    4.0.0-tp520-btrfs-trim+ #25
> > Apr 30 17:58:47 merkaba kernel: [145040.344323] Hardware name: LENOVO 42433WG/42433WG, BIOS 8AET63WW (1.43 ) 05/08/2013
> > Apr 30 17:58:47 merkaba kernel: [145040.354449] task: ffff8802d6501890 ti: ffff88011be90000 task.ti: ffff88011be90000
> > Apr 30 17:58:47 merkaba kernel: [145040.364822] RIP: 0010:[<ffffffff81058161>]  [<ffffffff81058161>] kthread_data+0xc/0x11
> > Apr 30 17:58:47 merkaba kernel: [145040.373127] RSP: 0018:ffff88011be93630  EFLAGS: 00010002
> > Apr 30 17:58:47 merkaba kernel: [145040.379901] RAX: 0000000000000000 RBX: ffff88041e292c80 RCX: 000000000000000f
> > Apr 30 17:58:47 merkaba kernel: [145040.386431] RDX: 0000000000000000 RSI: 0000000000000001 RDI: ffff8802d6501890
> > Apr 30 17:58:47 merkaba kernel: [145040.393815] RBP: ffff88011be93648 R08: ffff88041e292ce8 R09: ffffffff81bd7400
> > Apr 30 17:58:47 merkaba kernel: [145040.403602] R10: ffffffff81c49844 R11: 000000000000bf56 R12: 0000000000000001
> > Apr 30 17:58:47 merkaba kernel: [145040.412894] R13: ffff8802d6501e10 R14: 0000000000000001 R15: ffff88041e292c80
> > Apr 30 17:58:47 merkaba kernel: [145040.422987] FS:  0000000000000000(0000) GS:ffff88041e280000(0000) knlGS:0000000000000000
> > Apr 30 17:58:47 merkaba kernel: [145040.433054] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> > Apr 30 17:58:47 merkaba kernel: [145040.442755] CR2: 0000000000000028 CR3: 00000000c5e41000 CR4: 00000000000406e0
> > Apr 30 17:58:47 merkaba kernel: [145040.453039] Stack:
> > Apr 30 17:58:47 merkaba kernel: [145040.463202]  ffffffff81054504 ffff88041e292c80 0000000000012c80 ffff88011be93698
> > Apr 30 17:58:47 merkaba kernel: [145040.473543]  ffffffff814c2452 ffff88011be93688 ffff8802d6501890 ffff8803a45da5a0
> > Apr 30 17:58:47 merkaba kernel: [145040.483955]  ffff88011be93fd8 ffff8802d6502030 ffff88011be93270 ffff8802d6501cf0
> > Apr 30 17:58:47 merkaba kernel: [145040.494213] Call Trace:
> > Apr 30 17:58:47 merkaba kernel: [145040.504372]  [<ffffffff81054504>] ? wq_worker_sleeping+0xf/0x88
> > Apr 30 17:58:47 merkaba kernel: [145040.514807]  [<ffffffff814c2452>] __schedule+0x157/0x57e
> > Apr 30 17:58:47 merkaba kernel: [145040.525013]  [<ffffffff814c28e8>] schedule+0x6f/0x7e
> > Apr 30 17:58:47 merkaba kernel: [145040.535351]  [<ffffffff81043474>] do_exit+0x920/0x966
> > Apr 30 17:58:47 merkaba kernel: [145040.545437]  [<ffffffff810058ad>] oops_end+0xa0/0xa8
> > Apr 30 17:58:47 merkaba kernel: [145040.555437]  [<ffffffff81005cad>] die+0x55/0x5e
> > Apr 30 17:58:47 merkaba kernel: [145040.565562]  [<ffffffff81002afe>] do_trap+0x66/0x11f
> > Apr 30 17:58:47 merkaba kernel: [145040.575500]  [<ffffffff8100317e>] do_error_trap+0xc9/0xe6
> > Apr 30 17:58:47 merkaba kernel: [145040.584971]  [<ffffffffc050986d>] ? btrfs_release_extent_buffer_page+0x1b/0xde [btrfs]
> > Apr 30 17:58:47 merkaba kernel: [145040.593350]  [<ffffffffc052a8d2>] ? btrfs_add_delayed_tree_ref+0x8a/0x141 [btrfs]
> > Apr 30 17:58:47 merkaba kernel: [145040.603484]  [<ffffffff814c5069>] ? _raw_spin_unlock+0x11/0x23
> > Apr 30 17:58:47 merkaba kernel: [145040.613596]  [<ffffffff8100367c>] do_invalid_op+0x1b/0x1d
> > Apr 30 17:58:47 merkaba kernel: [145040.623956]  [<ffffffff814c6e98>] invalid_op+0x18/0x20
> > Apr 30 17:58:47 merkaba kernel: [145040.634365]  [<ffffffffc050986d>] ? btrfs_release_extent_buffer_page+0x1b/0xde [btrfs]
> > Apr 30 17:58:47 merkaba kernel: [145040.644968]  [<ffffffffc0509869>] ? btrfs_release_extent_buffer_page+0x17/0xde [btrfs]
> > Apr 30 17:58:47 merkaba kernel: [145040.655198]  [<ffffffffc05099bb>] release_extent_buffer+0x8b/0xbb [btrfs]
> > Apr 30 17:58:47 merkaba kernel: [145040.665069]  [<ffffffffc0509dae>] free_extent_buffer+0x8b/0x8f [btrfs]
> > Apr 30 17:58:47 merkaba kernel: [145040.674839]  [<ffffffffc04cecff>] copy_for_split+0x1b5/0x1cc [btrfs]
> > Apr 30 17:58:47 merkaba kernel: [145040.684508]  [<ffffffffc04d21cd>] split_leaf+0x23c/0x576 [btrfs]
> > Apr 30 17:58:47 merkaba kernel: [145040.694094]  [<ffffffffc04d2aa1>] btrfs_search_slot+0x59a/0x72b [btrfs]
> > Apr 30 17:58:47 merkaba kernel: [145040.703562]  [<ffffffffc04d3e01>] btrfs_insert_empty_items+0x58/0xa3 [btrfs]
> > Apr 30 17:58:47 merkaba kernel: [145040.712966]  [<ffffffffc04e57ac>] btrfs_csum_file_blocks+0x439/0x548 [btrfs]
> > Apr 30 17:58:47 merkaba kernel: [145040.722421]  [<ffffffffc04f1075>] add_pending_csums.isra.36+0x49/0x66 [btrfs]
> > Apr 30 17:58:47 merkaba kernel: [145040.731626]  [<ffffffffc04f65a3>] btrfs_finish_ordered_io+0x2c5/0x419 [btrfs]
> > Apr 30 17:58:47 merkaba kernel: [145040.740529]  [<ffffffffc04f68de>] finish_ordered_fn+0x10/0x12 [btrfs]
> > Apr 30 17:58:47 merkaba kernel: [145040.749132]  [<ffffffffc05150fe>] normal_work_helper+0xd2/0x217 [btrfs]
> > Apr 30 17:58:47 merkaba kernel: [145040.757469]  [<ffffffff8105344f>] ? pwq_activate_delayed_work+0x2c/0x3a
> > Apr 30 17:58:47 merkaba kernel: [145040.765548]  [<ffffffffc0515304>] btrfs_endio_write_helper+0xd/0xf [btrfs]
> > Apr 30 17:58:47 merkaba kernel: [145040.773297]  [<ffffffff81053e23>] process_one_work+0x15d/0x2ad
> > Apr 30 17:58:47 merkaba kernel: [145040.780701]  [<ffffffff810543ed>] worker_thread+0x1d1/0x27e
> > Apr 30 17:58:47 merkaba kernel: [145040.787774]  [<ffffffff8105421c>] ? rescuer_thread+0x27f/0x27f
> > Apr 30 17:58:47 merkaba kernel: [145040.794697]  [<ffffffff8105421c>] ? rescuer_thread+0x27f/0x27f
> > Apr 30 17:58:47 merkaba kernel: [145040.801326]  [<ffffffff81057edf>] kthread+0xb2/0xba
> > Apr 30 17:58:47 merkaba kernel: [145040.807770]  [<ffffffff81050000>] ? do_prlimit+0x35/0x1b6
> > Apr 30 17:58:47 merkaba kernel: [145040.814183]  [<ffffffff81057e2d>] ? __kthread_parkme+0x62/0x62
> > Apr 30 17:58:47 merkaba kernel: [145040.820544]  [<ffffffff814c5688>] ret_from_fork+0x58/0x90
> > Apr 30 17:58:47 merkaba kernel: [145040.826770]  [<ffffffff81057e2d>] ? __kthread_parkme+0x62/0x62
> > Apr 30 17:58:47 merkaba kernel: [145040.832971] Code: 48 8b 04 25 80 a9 00 00 48 8b 80 10 05 00 00 48 89 e5 5d 48 8b 40 c8 48 c1 e8 02 83 e0 01 c3 48 8b 87 10 05 00 00 55 48 89 e5 5d <48> 8b 40 d8 c3 55 ba 08 00 00 00 48 89 e5 48 83 ec 10 48 8b b7
> > Apr 30 17:58:47 merkaba kernel: [145040.847356] RIP  [<ffffffff81058161>] kthread_data+0xc/0x11
> > Apr 30 17:58:47 merkaba kernel: [145040.854365]  RSP <ffff88011be93630>
> > Apr 30 17:58:47 merkaba kernel: [145040.861220] CR2: ffffffffffffffd8
> > Apr 30 17:58:47 merkaba kernel: [145040.867964] ---[ end trace 37e2d6f90374a312 ]---
> > Apr 30 17:58:47 merkaba kernel: [145040.867970] Fixing recursive fault but reboot is needed!
> > Apr 30 17:58:47 merkaba kernel: [145040.867978] BUG: scheduling while atomic: kworker/u8:14/6061/0x00000004
> > Apr 30 17:58:47 merkaba kernel: [145040.867981] Modules linked in: usblp uvcvideo videobuf2_vmalloc videobuf2_memops videobuf2_core v4l2_common videodev media uas usb_storage ctr ccm rfcomm btusb ebtable_filter ebtables ip6table_filter ip6_tables iptable_filter ip_tables x_tables tun binfmt_misc cpufreq_userspace cpufreq_stats cpufreq_powersave bnep cpufreq_conservative bluetooth msr ext4 crc16 mbcache jbd2 snd_usb_audio snd_usbmidi_lib snd_rawmidi snd_seq_device x86_pkg_temp_thermal intel_powerclamp kvm_intel kvm crct10dif_pclmul crc32_pclmul ghash_clmulni_intel aesni_intel aes_x86_64 lrw gf128mul glue_helper ablk_helper snd_hda_codec_hdmi psmouse iwldvm cryptd mac80211 snd_hda_codec_conexant serio_raw snd_hda_codec_generic pcspkr i2c_i801 snd_hda_intel snd_hda_controller iwlwifi snd_hda_codec tpm_tis snd_hwdep battery thinkpad_acpi tpm cfg80211 ac snd_pcm nvram snd_timer rfkill snd soundcore lpc_ich mfd_core shpchp processor evdev joydev sbs sbshc coretemp hdaps(O) tp_smapi(O) thinkpad_ec(O) loop firewire_sbp2 fuse ecryptfs autofs4 md_mod btrfs xor raid6_pq microcode dm_mirror dm_region_hash dm_log dm_mod sg sr_mod sd_mod cdrom hid_generic usbhid hid crc32c_intel firewire_ohci ahci sdhci_pci libahci sdhci firewire_core mmc_core sata_sil24 crc_itu_t libata scsi_mod ehci_pci ehci_hcd usbcore usb_common e1000e ptp pps_core thermal
> > Apr 30 17:58:47 merkaba kernel: [145040.868230] Preemption disabled at:[<ffffffff810058ad>] oops_end+0xa0/0xa8
> > Apr 30 17:58:47 merkaba kernel: [145040.868238]
> > Apr 30 17:58:47 merkaba kernel: [145040.868247] CPU: 1 PID: 6061 Comm: kworker/u8:14 Tainted: G      D W  O    4.0.0-tp520-btrfs-trim+ #25
> > Apr 30 17:58:47 merkaba kernel: [145040.868252] Hardware name: LENOVO 42433WG/42433WG, BIOS 8AET63WW (1.43 ) 05/08/2013
> > Apr 30 17:58:47 merkaba kernel: [145040.868279]  0000000000012c80 ffff88011be932e8 ffffffff814c0a2a 0000000080000004
> > Apr 30 17:58:47 merkaba kernel: [145040.868289]  ffff88041e292c80 ffff88011be932f8 ffffffff8105cdd5 ffff88011be93348
> > Apr 30 17:58:47 merkaba kernel: [145040.868297]  ffffffff814c236c ffff88011be93368 ffff8802d6501890 0000000000000000
> > Apr 30 17:58:47 merkaba kernel: [145040.868306] Call Trace:
> > Apr 30 17:58:47 merkaba kernel: [145040.868317]  [<ffffffff814c0a2a>] dump_stack+0x4f/0x7b
> > Apr 30 17:58:47 merkaba kernel: [145040.868326]  [<ffffffff8105cdd5>] __schedule_bug+0x96/0xa4
> > Apr 30 17:58:47 merkaba kernel: [145040.868335]  [<ffffffff814c236c>] __schedule+0x71/0x57e
> > Apr 30 17:58:47 merkaba kernel: [145040.868344]  [<ffffffff814c28e8>] schedule+0x6f/0x7e
> > Apr 30 17:58:47 merkaba kernel: [145040.868354]  [<ffffffff81042c5b>] do_exit+0x107/0x966
> > Apr 30 17:58:47 merkaba kernel: [145040.868363]  [<ffffffff814bfbe5>] ? printk+0x41/0x43
> > Apr 30 17:58:47 merkaba kernel: [145040.868374]  [<ffffffff8107ebbd>] ? kmsg_dump+0xa7/0xae
> > Apr 30 17:58:47 merkaba kernel: [145040.868382]  [<ffffffff810058ad>] oops_end+0xa0/0xa8
> > Apr 30 17:58:47 merkaba kernel: [145040.868390]  [<ffffffff810347f9>] no_context+0x2d0/0x32d
> > Apr 30 17:58:47 merkaba kernel: [145040.868401]  [<ffffffff8108519c>] ? __call_rcu_nocb_enqueue+0x48/0xfc
> > Apr 30 17:58:47 merkaba kernel: [145040.868410]  [<ffffffff810348ba>] __bad_area_nosemaphore+0x64/0x1b4
> > Apr 30 17:58:47 merkaba kernel: [145040.868417]  [<ffffffff81034a18>] bad_area_nosemaphore+0xe/0x10
> > Apr 30 17:58:47 merkaba kernel: [145040.868425]  [<ffffffff81034dfa>] __do_page_fault+0x22f/0x3ed
> > Apr 30 17:58:47 merkaba kernel: [145040.868433]  [<ffffffff814c62e7>] ? native_iret+0x7/0x7
> > Apr 30 17:58:47 merkaba kernel: [145040.868441]  [<ffffffff81034fdb>] do_page_fault+0x23/0x4f
> > Apr 30 17:58:47 merkaba kernel: [145040.868449]  [<ffffffff814c71d2>] page_fault+0x22/0x30
> > Apr 30 17:58:47 merkaba kernel: [145040.868458]  [<ffffffff81058161>] ? kthread_data+0xc/0x11
> > Apr 30 17:58:47 merkaba kernel: [145040.868467]  [<ffffffff81054504>] ? wq_worker_sleeping+0xf/0x88
> > Apr 30 17:58:47 merkaba kernel: [145040.868476]  [<ffffffff814c2452>] __schedule+0x157/0x57e
> > Apr 30 17:58:47 merkaba kernel: [145040.868484]  [<ffffffff814c28e8>] schedule+0x6f/0x7e
> > Apr 30 17:58:47 merkaba kernel: [145040.868492]  [<ffffffff81043474>] do_exit+0x920/0x966
> > Apr 30 17:58:47 merkaba kernel: [145040.868500]  [<ffffffff810058ad>] oops_end+0xa0/0xa8
> > Apr 30 17:58:47 merkaba kernel: [145040.868507]  [<ffffffff81005cad>] die+0x55/0x5e
> > Apr 30 17:58:47 merkaba kernel: [145040.868514]  [<ffffffff81002afe>] do_trap+0x66/0x11f
> > Apr 30 17:58:47 merkaba kernel: [145040.868521]  [<ffffffff8100317e>] do_error_trap+0xc9/0xe6
> > Apr 30 17:58:47 merkaba kernel: [145040.868589]  [<ffffffffc050986d>] ? btrfs_release_extent_buffer_page+0x1b/0xde [btrfs]
> > Apr 30 17:58:47 merkaba kernel: [145040.868656]  [<ffffffffc052a8d2>] ? btrfs_add_delayed_tree_ref+0x8a/0x141 [btrfs]
> > Apr 30 17:58:47 merkaba kernel: [145040.868664]  [<ffffffff814c5069>] ? _raw_spin_unlock+0x11/0x23
> > Apr 30 17:58:47 merkaba kernel: [145040.868671]  [<ffffffff8100367c>] do_invalid_op+0x1b/0x1d
> > Apr 30 17:58:47 merkaba kernel: [145040.868678]  [<ffffffff814c6e98>] invalid_op+0x18/0x20
> > Apr 30 17:58:47 merkaba kernel: [145040.868741]  [<ffffffffc050986d>] ? btrfs_release_extent_buffer_page+0x1b/0xde [btrfs]
> > Apr 30 17:58:47 merkaba kernel: [145040.868797]  [<ffffffffc0509869>] ? btrfs_release_extent_buffer_page+0x17/0xde [btrfs]
> > Apr 30 17:58:47 merkaba kernel: [145040.868852]  [<ffffffffc05099bb>] release_extent_buffer+0x8b/0xbb [btrfs]
> > Apr 30 17:58:47 merkaba kernel: [145040.868906]  [<ffffffffc0509dae>] free_extent_buffer+0x8b/0x8f [btrfs]
> > Apr 30 17:58:47 merkaba kernel: [145040.868948]  [<ffffffffc04cecff>] copy_for_split+0x1b5/0x1cc [btrfs]
> > Apr 30 17:58:47 merkaba kernel: [145040.868992]  [<ffffffffc04d21cd>] split_leaf+0x23c/0x576 [btrfs]
> > Apr 30 17:58:47 merkaba kernel: [145040.869036]  [<ffffffffc04d2aa1>] btrfs_search_slot+0x59a/0x72b [btrfs]
> > Apr 30 17:58:47 merkaba kernel: [145040.869081]  [<ffffffffc04d3e01>] btrfs_insert_empty_items+0x58/0xa3 [btrfs]
> > Apr 30 17:58:47 merkaba kernel: [145040.869132]  [<ffffffffc04e57ac>] btrfs_csum_file_blocks+0x439/0x548 [btrfs]
> > Apr 30 17:58:47 merkaba kernel: [145040.869207]  [<ffffffffc04f1075>] add_pending_csums.isra.36+0x49/0x66 [btrfs]
> > Apr 30 17:58:47 merkaba kernel: [145040.869262]  [<ffffffffc04f65a3>] btrfs_finish_ordered_io+0x2c5/0x419 [btrfs]
> > Apr 30 17:58:47 merkaba kernel: [145040.869314]  [<ffffffffc04f68de>] finish_ordered_fn+0x10/0x12 [btrfs]
> > Apr 30 17:58:47 merkaba kernel: [145040.869375]  [<ffffffffc05150fe>] normal_work_helper+0xd2/0x217 [btrfs]
> > Apr 30 17:58:47 merkaba kernel: [145040.869384]  [<ffffffff8105344f>] ? pwq_activate_delayed_work+0x2c/0x3a
> > Apr 30 17:58:47 merkaba kernel: [145040.869443]  [<ffffffffc0515304>] btrfs_endio_write_helper+0xd/0xf [btrfs]
> > Apr 30 17:58:47 merkaba kernel: [145040.869452]  [<ffffffff81053e23>] process_one_work+0x15d/0x2ad
> > Apr 30 17:58:47 merkaba kernel: [145040.869461]  [<ffffffff810543ed>] worker_thread+0x1d1/0x27e
> > Apr 30 17:58:47 merkaba kernel: [145040.869470]  [<ffffffff8105421c>] ? rescuer_thread+0x27f/0x27f
> > Apr 30 17:58:47 merkaba kernel: [145040.869478]  [<ffffffff8105421c>] ? rescuer_thread+0x27f/0x27f
> > Apr 30 17:58:47 merkaba kernel: [145040.869485]  [<ffffffff81057edf>] kthread+0xb2/0xba
> > Apr 30 17:58:47 merkaba kernel: [145040.869493]  [<ffffffff81050000>] ? do_prlimit+0x35/0x1b6
> > Apr 30 17:58:47 merkaba kernel: [145040.869501]  [<ffffffff81057e2d>] ? __kthread_parkme+0x62/0x62
> > Apr 30 17:58:47 merkaba kernel: [145040.869508]  [<ffffffff814c5688>] ret_from_fork+0x58/0x90
> > Apr 30 17:58:47 merkaba kernel: [145040.869515]  [<ffffffff81057e2d>] ? __kthread_parkme+0x62/0x62
> > Apr 30 17:58:47 merkaba kernel: [145101.334039] INFO: rcu_preempt detected stalls on CPUs/tasks: { 1} (detected by 2, t=60434 jiffies, g=5499107, c=5499106, q=0)
> > Apr 30 17:58:47 merkaba kernel: [145101.334064] Task dump for CPU 1:
> > Apr 30 17:58:47 merkaba kernel: [145101.334071] kworker/u8:14   D ffff88011be93688     0  6061      0 0x00080000
> > Apr 30 17:58:47 merkaba kernel: [145101.334107]  ffff8802d6501890 ffff8803a45da5a0 ffff88011be93fd8 ffff8802d6502030
> > Apr 30 17:58:47 merkaba kernel: [145101.334120]  ffff88011be93270 ffff8802d6501cf0 ffff88011be938e8 ffff88011be936b8
> > Apr 30 17:58:47 merkaba kernel: [145101.334131]  ffffffff814c28e8 ffff8802d6502525 ffff8802d6501890 ffff88011be93748
> > Apr 30 17:58:47 merkaba kernel: [145101.334144] Call Trace:
> > Apr 30 17:58:47 merkaba kernel: [145101.334164]  [<ffffffff814c28e8>] ? schedule+0x6f/0x7e
> > Apr 30 17:58:47 merkaba kernel: [145101.334178]  [<ffffffff81043474>] ? do_exit+0x920/0x966
> > Apr 30 17:58:47 merkaba kernel: [145101.334191]  [<ffffffff810058ad>] ? oops_end+0xa0/0xa8
> > Apr 30 17:58:47 merkaba kernel: [145101.334200]  [<ffffffff81005cad>] ? die+0x55/0x5e
> > Apr 30 17:58:47 merkaba kernel: [145101.334209]  [<ffffffff81002afe>] ? do_trap+0x66/0x11f
> > Apr 30 17:58:47 merkaba kernel: [145101.334219]  [<ffffffff8100317e>] ? do_error_trap+0xc9/0xe6
> > Apr 30 17:58:47 merkaba kernel: [145101.334324]  [<ffffffffc050986d>] ? btrfs_release_extent_buffer_page+0x1b/0xde [btrfs]
> > Apr 30 17:58:47 merkaba kernel: [145101.334399]  [<ffffffffc052a8d2>] ? btrfs_add_delayed_tree_ref+0x8a/0x141 [btrfs]
> > Apr 30 17:58:47 merkaba kernel: [145101.334409]  [<ffffffff814c5069>] ? _raw_spin_unlock+0x11/0x23
> > Apr 30 17:58:47 merkaba kernel: [145101.334419]  [<ffffffff8100367c>] ? do_invalid_op+0x1b/0x1d
> > Apr 30 17:58:47 merkaba kernel: [145101.334430]  [<ffffffff814c6e98>] ? invalid_op+0x18/0x20
> > Apr 30 17:58:47 merkaba kernel: [145101.334495]  [<ffffffffc050986d>] ? btrfs_release_extent_buffer_page+0x1b/0xde [btrfs]
> > Apr 30 17:58:47 merkaba kernel: [145101.334555]  [<ffffffffc0509869>] ? btrfs_release_extent_buffer_page+0x17/0xde [btrfs]
> > Apr 30 17:58:47 merkaba kernel: [145101.334615]  [<ffffffffc05099bb>] ? release_extent_buffer+0x8b/0xbb [btrfs]
> > Apr 30 17:58:47 merkaba kernel: [145101.334674]  [<ffffffffc0509dae>] ? free_extent_buffer+0x8b/0x8f [btrfs]
> > Apr 30 17:58:47 merkaba kernel: [145101.334717]  [<ffffffffc04cecff>] ? copy_for_split+0x1b5/0x1cc [btrfs]
> > Apr 30 17:58:47 merkaba kernel: [145101.334762]  [<ffffffffc04d21cd>] ? split_leaf+0x23c/0x576 [btrfs]
> > Apr 30 17:58:47 merkaba kernel: [145101.334807]  [<ffffffffc04d2aa1>] ? btrfs_search_slot+0x59a/0x72b [btrfs]
> > Apr 30 17:58:47 merkaba kernel: [145101.334853]  [<ffffffffc04d3e01>] ? btrfs_insert_empty_items+0x58/0xa3 [btrfs]
> > Apr 30 17:58:47 merkaba kernel: [145101.334907]  [<ffffffffc04e57ac>] ? btrfs_csum_file_blocks+0x439/0x548 [btrfs]
> > Apr 30 17:58:47 merkaba kernel: [145101.334967]  [<ffffffffc04f1075>] ? add_pending_csums.isra.36+0x49/0x66 [btrfs]
> > Apr 30 17:58:47 merkaba kernel: [145101.335025]  [<ffffffffc04f65a3>] ? btrfs_finish_ordered_io+0x2c5/0x419 [btrfs]
> > Apr 30 17:58:47 merkaba kernel: [145101.335081]  [<ffffffffc04f68de>] ? finish_ordered_fn+0x10/0x12 [btrfs]
> > Apr 30 17:58:47 merkaba kernel: [145101.335146]  [<ffffffffc05150fe>] ? normal_work_helper+0xd2/0x217 [btrfs]
> > Apr 30 17:58:47 merkaba kernel: [145101.335159]  [<ffffffff8105344f>] ? pwq_activate_delayed_work+0x2c/0x3a
> > Apr 30 17:58:47 merkaba kernel: [145101.335222]  [<ffffffffc0515304>] ? btrfs_endio_write_helper+0xd/0xf [btrfs]
> > Apr 30 17:58:47 merkaba kernel: [145101.335234]  [<ffffffff81053e23>] ? process_one_work+0x15d/0x2ad
> > Apr 30 17:58:47 merkaba kernel: [145101.335245]  [<ffffffff810543ed>] ? worker_thread+0x1d1/0x27e
> > Apr 30 17:58:47 merkaba kernel: [145101.335256]  [<ffffffff8105421c>] ? rescuer_thread+0x27f/0x27f
> > Apr 30 17:58:47 merkaba kernel: [145101.335267]  [<ffffffff8105421c>] ? rescuer_thread+0x27f/0x27f
> > Apr 30 17:58:47 merkaba kernel: [145101.335277]  [<ffffffff81057edf>] ? kthread+0xb2/0xba
> > Apr 30 17:58:47 merkaba kernel: [145101.335287]  [<ffffffff81050000>] ? do_prlimit+0x35/0x1b6
> > Apr 30 17:58:47 merkaba kernel: [145101.335297]  [<ffffffff81057e2d>] ? __kthread_parkme+0x62/0x62
> > Apr 30 17:58:47 merkaba kernel: [145101.335308]  [<ffffffff814c5688>] ? ret_from_fork+0x58/0x90
> > Apr 30 17:58:47 merkaba kernel: [145101.335318]  [<ffffffff81057e2d>] ? __kthread_parkme+0x62/0x62
> > Apr 30 17:58:47 merkaba kernel: [145101.335327] rcu_preempt kthread starved for 57217 jiffies!
> > Apr 30 19:17:13 merkaba kernel: [    0.000000] Initializing cgroup subsys cpuset
> > Apr 30 19:17:13 merkaba kernel: [    0.000000] Initializing cgroup subsys cpu
> > Apr 30 19:17:13 merkaba kernel: [    0.000000] Initializing cgroup subsys cpuacct
> > Apr 30 19:17:13 merkaba kernel: [    0.000000] Linux version 4.0.0-tp520-btrfs-trim+ (martin@merkaba) (gcc version 4.9.2 (Debian 4.9.2-10) ) #25 SMP PREEMPT Mon Apr 13 09:38:29 CEST 2015
> >
> >
> >
> > I unplugged and replugged the controller + cable several times before,
> > as I was not sure whether it was seated properly, and during this I got:
> >
> > Apr 30 17:14:08 merkaba kernel: [142421.959435] pci 0000:05:00.0: [1095:3531] type 00 class 0x018000
> > Apr 30 17:14:08 merkaba kernel: [142421.959490] pci 0000:05:00.0: reg 0x10: [mem 0x00000000-0x0000007f 64bit]
> > Apr 30 17:14:08 merkaba kernel: [142421.959522] pci 0000:05:00.0: reg 0x18: [mem 0x00000000-0x00001fff 64bit]
> > Apr 30 17:14:08 merkaba kernel: [142421.959542] pci 0000:05:00.0: reg 0x20: [io  0x0000-0x007f]
> > Apr 30 17:14:08 merkaba kernel: [142421.959709] pci 0000:05:00.0: supports D1 D2
> > Apr 30 17:14:08 merkaba kernel: [142421.961793] pci 0000:05:00.0: BAR 2: assigned [mem 0xf1c00000-0xf1c01fff 64bit]
> > Apr 30 17:14:08 merkaba kernel: [142421.961827] pci 0000:05:00.0: BAR 0: assigned [mem 0xf1c02000-0xf1c0207f 64bit]
> > Apr 30 17:14:08 merkaba kernel: [142421.961856] pci 0000:05:00.0: BAR 4: assigned [io  0x4000-0x407f]
> > Apr 30 17:14:08 merkaba kernel: [142421.962005] sata_sil24 0000:05:00.0: enabling device (0000 -> 0003)
> > Apr 30 17:14:08 merkaba kernel: [142421.963120] scsi host8: sata_sil24
> > Apr 30 17:14:08 merkaba kernel: [142421.963435] ata8: SATA max UDMA/100 host m128@0xf1c02000 port 0xf1c00000 irq 19
> > Apr 30 17:14:11 merkaba kernel: [142424.602681] ata8: SATA link down (SStatus FFFFFFFF SControl FFFFFFFF)
> > Apr 30 17:14:11 merkaba kernel: [142424.602722] ------------[ cut here ]------------
> > Apr 30 17:14:11 merkaba kernel: [142424.602774] WARNING: CPU: 3 PID: 5714 at drivers/ata/libata-core.c:6259 ata_host_detach+0x7e/0x13a [libata]()
> > Apr 30 17:14:11 merkaba kernel: [142424.602778] Modules linked in: usblp uvcvideo videobuf2_vmalloc videobuf2_memops videobuf2_core v4l2_common videodev media uas usb_storage ctr ccm rfcomm btusb ebtable_filter ebtables ip6table_filter ip6_tables iptable_filter ip_tables x_tables tun binfmt_misc cpufreq_userspace cpufreq_stats cpufreq_powersave bnep cpufreq_conservative bluetooth msr ext4 crc16 mbcache jbd2 snd_usb_audio snd_usbmidi_lib snd_rawmidi snd_seq_device x86_pkg_temp_thermal intel_powerclamp kvm_intel kvm crct10dif_pclmul crc32_pclmul ghash_clmulni_intel aesni_intel aes_x86_64 lrw gf128mul glue_helper ablk_helper snd_hda_codec_hdmi psmouse iwldvm cryptd mac80211 snd_hda_codec_conexant serio_raw snd_hda_codec_generic pcspkr i2c_i801 snd_hda_intel snd_hda_controller iwlwifi snd_hda_codec tpm_tis snd_hwdep battery thinkpad_acpi tpm cfg80211 ac snd_pcm nvram snd_timer rfkill snd soundcore lpc_ich mfd_core shpchp processor evdev joydev sbs sbshc coretemp hdaps(O) tp_smapi(O) thinkpad_ec(O) loop firewire_sbp2 fuse ecryptfs autofs4 md_mod btrfs xor raid6_pq microcode dm_mirror dm_region_hash dm_log dm_mod sg sr_mod sd_mod cdrom hid_generic usbhid hid crc32c_intel firewire_ohci ahci sdhci_pci libahci sdhci firewire_core mmc_core sata_sil24 crc_itu_t libata scsi_mod ehci_pci ehci_hcd usbcore usb_common e1000e ptp pps_core thermal
> > Apr 30 17:14:11 merkaba kernel: [142424.602928] CPU: 3 PID: 5714 Comm: kworker/u8:4 Tainted: G           O    4.0.0-tp520-btrfs-trim+ #25
> > Apr 30 17:14:11 merkaba kernel: [142424.602932] Hardware name: LENOVO 42433WG/42433WG, BIOS 8AET63WW (1.43 ) 05/08/2013
> > Apr 30 17:14:11 merkaba kernel: [142424.602942] Workqueue: kacpi_hotplug acpi_hotplug_work_fn
> > Apr 30 17:14:11 merkaba kernel: [142424.602946]  0000000000000009 ffff8803b3763bb8 ffffffff814c0a2a 0000000080000000
> > Apr 30 17:14:11 merkaba kernel: [142424.602952]  0000000000000000 ffff8803b3763bf8 ffffffff81040ce5 ffff8803a1a1c9b0
> > Apr 30 17:14:11 merkaba kernel: [142424.602958]  ffffffffc03a416c ffff8803bc17c000 0000000000000282 0000000000000000
> > Apr 30 17:14:11 merkaba kernel: [142424.602964] Call Trace:
> > Apr 30 17:14:11 merkaba kernel: [142424.602974]  [<ffffffff814c0a2a>] dump_stack+0x4f/0x7b
> > Apr 30 17:14:11 merkaba kernel: [142424.602983]  [<ffffffff81040ce5>] warn_slowpath_common+0x9c/0xb6
> > Apr 30 17:14:11 merkaba kernel: [142424.603002]  [<ffffffffc03a416c>] ? ata_host_detach+0x7e/0x13a [libata]
> > Apr 30 17:14:11 merkaba kernel: [142424.603008]  [<ffffffff81040d93>] warn_slowpath_null+0x15/0x17
> > Apr 30 17:14:11 merkaba kernel: [142424.603026]  [<ffffffffc03a416c>] ata_host_detach+0x7e/0x13a [libata]
> > Apr 30 17:14:11 merkaba kernel: [142424.603033]  [<ffffffff8138e66a>] ? __pm_runtime_resume+0x52/0x60
> > Apr 30 17:14:11 merkaba kernel: [142424.603055]  [<ffffffffc03a4238>] ata_pci_remove_one+0x10/0x12 [libata]
> > Apr 30 17:14:11 merkaba kernel: [142424.603062]  [<ffffffff8123f157>] pci_device_remove+0x41/0x8c
> > Apr 30 17:14:11 merkaba kernel: [142424.603072]  [<ffffffff813861e0>] __device_release_driver+0x84/0xdb
> > Apr 30 17:14:11 merkaba kernel: [142424.603076]  [<ffffffff81386255>] device_release_driver+0x1e/0x2b
> > Apr 30 17:14:11 merkaba kernel: [142424.603084]  [<ffffffff8123a456>] pci_stop_bus_device+0x45/0x88
> > Apr 30 17:14:11 merkaba kernel: [142424.603089]  [<ffffffff8123a5fb>] pci_stop_and_remove_bus_device+0xe/0x1a
> > Apr 30 17:14:11 merkaba kernel: [142424.603096]  [<ffffffff81251a0e>] disable_slot+0x3a/0x7b
> > Apr 30 17:14:11 merkaba kernel: [142424.603102]  [<ffffffff8125201d>] acpiphp_check_bridge+0xa4/0xaf
> > Apr 30 17:14:11 merkaba kernel: [142424.603108]  [<ffffffff8125231c>] acpiphp_hotplug_notify+0xa0/0xc7
> > Apr 30 17:14:11 merkaba kernel: [142424.603114]  [<ffffffff8125227c>] ? acpiphp_post_dock_fixup+0xa4/0xa4
> > Apr 30 17:14:11 merkaba kernel: [142424.603121]  [<ffffffff81271eac>] acpi_device_hotplug+0x3ab/0x3f3
> > Apr 30 17:14:11 merkaba kernel: [142424.603127]  [<ffffffff8126bdbb>] acpi_hotplug_work_fn+0x1a/0x26
> > Apr 30 17:14:11 merkaba kernel: [142424.603133]  [<ffffffff81053e23>] process_one_work+0x15d/0x2ad
> > Apr 30 17:14:11 merkaba kernel: [142424.603140]  [<ffffffff810543ed>] worker_thread+0x1d1/0x27e
> > Apr 30 17:14:11 merkaba kernel: [142424.603145]  [<ffffffff8105421c>] ? rescuer_thread+0x27f/0x27f
> > Apr 30 17:14:11 merkaba kernel: [142424.603151]  [<ffffffff8105421c>] ? rescuer_thread+0x27f/0x27f
> > Apr 30 17:14:11 merkaba kernel: [142424.603156]  [<ffffffff81057edf>] kthread+0xb2/0xba
> > Apr 30 17:14:11 merkaba kernel: [142424.603161]  [<ffffffff81050000>] ? do_prlimit+0x35/0x1b6
> > Apr 30 17:14:11 merkaba kernel: [142424.603167]  [<ffffffff81057e2d>] ? __kthread_parkme+0x62/0x62
> > Apr 30 17:14:11 merkaba kernel: [142424.603172]  [<ffffffff814c5688>] ret_from_fork+0x58/0x90
> > Apr 30 17:14:11 merkaba kernel: [142424.603177]  [<ffffffff81057e2d>] ? __kthread_parkme+0x62/0x62
> > Apr 30 17:14:11 merkaba kernel: [142424.603181] ---[ end trace 37e2d6f90374a30f ]---
> > Apr 30 17:14:11 merkaba kernel: [142425.227122] pci 0000:05:00.0: [1095:3531] type 00 class 0x018000
> > Apr 30 17:14:11 merkaba kernel: [142425.227188] pci 0000:05:00.0: reg 0x10: [mem 0x00000000-0x0000007f 64bit]
> > Apr 30 17:14:11 merkaba kernel: [142425.227225] pci 0000:05:00.0: reg 0x18: [mem 0x00000000-0x00001fff 64bit]
> > Apr 30 17:14:11 merkaba kernel: [142425.227250] pci 0000:05:00.0: reg 0x20: [io  0x0000-0x007f]
> > Apr 30 17:14:11 merkaba kernel: [142425.227440] pci 0000:05:00.0: supports D1 D2
> > Apr 30 17:14:11 merkaba kernel: [142425.229796] pci 0000:05:00.0: BAR 2: assigned [mem 0xf1c00000-0xf1c01fff 64bit]
> > Apr 30 17:14:11 merkaba kernel: [142425.229846] pci 0000:05:00.0: BAR 0: assigned [mem 0xf1c02000-0xf1c0207f 64bit]
> > Apr 30 17:14:11 merkaba kernel: [142425.229886] pci 0000:05:00.0: BAR 4: assigned [io  0x4000-0x407f]
> > Apr 30 17:14:11 merkaba kernel: [142425.230124] sata_sil24 0000:05:00.0: enabling device (0000 -> 0003)
> > Apr 30 17:14:11 merkaba kernel: [142425.233547] scsi host9: sata_sil24
> > Apr 30 17:14:11 merkaba kernel: [142425.234206] ata9: SATA max UDMA/100 host m128@0xf1c02000 port 0xf1c00000 irq 19
> > Apr 30 17:14:13 merkaba kernel: [142427.254202] ata9: SATA link down (SStatus 0 SControl 0)
> > Apr 30 17:14:25 merkaba kernel: [142438.509382] pci 0000:05:00.0: [1095:3531] type 00 class 0x018000
> > Apr 30 17:14:25 merkaba kernel: [142438.509440] pci 0000:05:00.0: reg 0x10: [mem 0x00000000-0x0000007f 64bit]
> > Apr 30 17:14:25 merkaba kernel: [142438.509473] pci 0000:05:00.0: reg 0x18: [mem 0x00000000-0x00001fff 64bit]
> > Apr 30 17:14:25 merkaba kernel: [142438.509494] pci 0000:05:00.0: reg 0x20: [io  0x0000-0x007f]
> > Apr 30 17:14:25 merkaba kernel: [142438.509666] pci 0000:05:00.0: supports D1 D2
> > Apr 30 17:14:25 merkaba kernel: [142438.511949] pci 0000:05:00.0: BAR 2: assigned [mem 0xf1c00000-0xf1c01fff 64bit]
> > Apr 30 17:14:25 merkaba kernel: [142438.511990] pci 0000:05:00.0: BAR 0: assigned [mem 0xf1c02000-0xf1c0207f 64bit]
> > Apr 30 17:14:25 merkaba kernel: [142438.512021] pci 0000:05:00.0: BAR 4: assigned [io  0x4000-0x407f]
> > Apr 30 17:14:25 merkaba kernel: [142438.512213] sata_sil24 0000:05:00.0: enabling device (0000 -> 0003)
> > Apr 30 17:14:25 merkaba kernel: [142438.514955] scsi host10: sata_sil24
> > Apr 30 17:14:25 merkaba kernel: [142438.515693] ata10: SATA max UDMA/100 host m128@0xf1c02000 port 0xf1c00000 irq 19
> > Apr 30 17:14:27 merkaba kernel: [142441.083405] ata10: SATA link down (SStatus FFFFFFFF SControl FFFFFFFF)
> > Apr 30 17:14:27 merkaba kernel: [142441.083557] ------------[ cut here ]------------
> > Apr 30 17:14:27 merkaba kernel: [142441.083617] WARNING: CPU: 2 PID: 5768 at drivers/ata/libata-core.c:6259 ata_host_detach+0x7e/0x13a [libata]()
> > Apr 30 17:14:27 merkaba kernel: [142441.083621] Modules linked in: usblp uvcvideo videobuf2_vmalloc videobuf2_memops videobuf2_core v4l2_common videodev media uas usb_storage ctr ccm rfcomm btusb ebtable_filter ebtables ip6table_filter ip6_tables iptable_filter ip_tables x_tables tun binfmt_misc cpufreq_userspace cpufreq_stats cpufreq_powersave bnep cpufreq_conservative bluetooth msr ext4 crc16 mbcache jbd2 snd_usb_audio snd_usbmidi_lib snd_rawmidi snd_seq_device x86_pkg_temp_thermal intel_powerclamp kvm_intel kvm crct10dif_pclmul crc32_pclmul ghash_clmulni_intel aesni_intel aes_x86_64 lrw gf128mul glue_helper ablk_helper snd_hda_codec_hdmi psmouse iwldvm cryptd mac80211 snd_hda_codec_conexant serio_raw snd_hda_codec_generic pcspkr i2c_i801 snd_hda_intel snd_hda_controller iwlwifi snd_hda_codec tpm_tis snd_hwdep battery thinkpad_acpi tpm cfg80211 ac snd_pcm nvram snd_timer rfkill snd soundcore lpc_ich mfd_core shpchp processor evdev joydev sbs sbshc coretemp hdaps(O) tp_smapi(O) thinkpad_ec(O) loop firewire_sbp2 fuse ecryptfs autofs4 md_mod btrfs xor raid6_pq microcode dm_mirror dm_region_hash dm_log dm_mod sg sr_mod sd_mod cdrom hid_generic usbhid hid crc32c_intel firewire_ohci ahci sdhci_pci libahci sdhci firewire_core mmc_core sata_sil24 crc_itu_t libata scsi_mod ehci_pci ehci_hcd usbcore usb_common e1000e ptp pps_core thermal
> > Apr 30 17:14:27 merkaba kernel: [142441.083829] CPU: 2 PID: 5768 Comm: kworker/u8:6 Tainted: G        W  O    4.0.0-tp520-btrfs-trim+ #25
> > Apr 30 17:14:27 merkaba kernel: [142441.083833] Hardware name: LENOVO 42433WG/42433WG, BIOS 8AET63WW (1.43 ) 05/08/2013
> > Apr 30 17:14:27 merkaba kernel: [142441.083845] Workqueue: kacpi_hotplug acpi_hotplug_work_fn
> > Apr 30 17:14:27 merkaba kernel: [142441.083850]  0000000000000009 ffff8803b0383bb8 ffffffff814c0a2a 0000000080000000
> > Apr 30 17:14:27 merkaba kernel: [142441.083857]  0000000000000000 ffff8803b0383bf8 ffffffff81040ce5 ffff8803980c8000
> > Apr 30 17:14:27 merkaba kernel: [142441.083864]  ffffffffc03a416c ffff88020f344000 0000000000000282 0000000000000000
> > Apr 30 17:14:27 merkaba kernel: [142441.083872] Call Trace:
> > Apr 30 17:14:27 merkaba kernel: [142441.083884]  [<ffffffff814c0a2a>] dump_stack+0x4f/0x7b
> > Apr 30 17:14:27 merkaba kernel: [142441.083894]  [<ffffffff81040ce5>] warn_slowpath_common+0x9c/0xb6
> > Apr 30 17:14:27 merkaba kernel: [142441.083917]  [<ffffffffc03a416c>] ? ata_host_detach+0x7e/0x13a [libata]
> > Apr 30 17:14:27 merkaba kernel: [142441.083924]  [<ffffffff81040d93>] warn_slowpath_null+0x15/0x17
> > Apr 30 17:14:27 merkaba kernel: [142441.083958]  [<ffffffffc03a416c>] ata_host_detach+0x7e/0x13a [libata]
> > Apr 30 17:14:27 merkaba kernel: [142441.083967]  [<ffffffff8138e66a>] ? __pm_runtime_resume+0x52/0x60
> > Apr 30 17:14:27 merkaba kernel: [142441.083997]  [<ffffffffc03a4238>] ata_pci_remove_one+0x10/0x12 [libata]
> > Apr 30 17:14:27 merkaba kernel: [142441.084006]  [<ffffffff8123f157>] pci_device_remove+0x41/0x8c
> > Apr 30 17:14:27 merkaba kernel: [142441.084028]  [<ffffffff813861e0>] __device_release_driver+0x84/0xdb
> > Apr 30 17:14:27 merkaba kernel: [142441.084033]  [<ffffffff81386255>] device_release_driver+0x1e/0x2b
> > Apr 30 17:14:27 merkaba kernel: [142441.084041]  [<ffffffff8123a456>] pci_stop_bus_device+0x45/0x88
> > Apr 30 17:14:27 merkaba kernel: [142441.084047]  [<ffffffff8123a5fb>] pci_stop_and_remove_bus_device+0xe/0x1a
> > Apr 30 17:14:27 merkaba kernel: [142441.084054]  [<ffffffff81251a0e>] disable_slot+0x3a/0x7b
> > Apr 30 17:14:27 merkaba kernel: [142441.084061]  [<ffffffff8125201d>] acpiphp_check_bridge+0xa4/0xaf
> > Apr 30 17:14:27 merkaba kernel: [142441.084069]  [<ffffffff8125231c>] acpiphp_hotplug_notify+0xa0/0xc7
> > Apr 30 17:14:27 merkaba kernel: [142441.084076]  [<ffffffff8125227c>] ? acpiphp_post_dock_fixup+0xa4/0xa4
> > Apr 30 17:14:27 merkaba kernel: [142441.084084]  [<ffffffff81271eac>] acpi_device_hotplug+0x3ab/0x3f3
> > Apr 30 17:14:27 merkaba kernel: [142441.084091]  [<ffffffff8126bdbb>] acpi_hotplug_work_fn+0x1a/0x26
> > Apr 30 17:14:27 merkaba kernel: [142441.084099]  [<ffffffff81053e23>] process_one_work+0x15d/0x2ad
> > Apr 30 17:14:27 merkaba kernel: [142441.084107]  [<ffffffff810543ed>] worker_thread+0x1d1/0x27e
> > Apr 30 17:14:27 merkaba kernel: [142441.084114]  [<ffffffff8105421c>] ? rescuer_thread+0x27f/0x27f
> > Apr 30 17:14:27 merkaba kernel: [142441.084120]  [<ffffffff81057edf>] kthread+0xb2/0xba
> > Apr 30 17:14:27 merkaba kernel: [142441.084137]  [<ffffffff81050000>] ? do_prlimit+0x35/0x1b6
> > Apr 30 17:14:27 merkaba kernel: [142441.084144]  [<ffffffff81057e2d>] ? __kthread_parkme+0x62/0x62
> > Apr 30 17:14:27 merkaba kernel: [142441.084151]  [<ffffffff814c5688>] ret_from_fork+0x58/0x90
> > Apr 30 17:14:27 merkaba kernel: [142441.084158]  [<ffffffff81057e2d>] ? __kthread_parkme+0x62/0x62
> > Apr 30 17:14:27 merkaba kernel: [142441.084163] ---[ end trace 37e2d6f90374a310 ]---
> > Apr 30 17:14:27 merkaba kernel: [142441.094843] pci 0000:05:00.0: [1095:3531] type 00 class 0x018000
> > Apr 30 17:14:27 merkaba kernel: [142441.094924] pci 0000:05:00.0: reg 0x10: [mem 0x00000000-0x0000007f 64bit]
> > Apr 30 17:14:27 merkaba kernel: [142441.094971] pci 0000:05:00.0: reg 0x18: [mem 0x00000000-0x00001fff 64bit]
> > Apr 30 17:14:27 merkaba kernel: [142441.095001] pci 0000:05:00.0: reg 0x20: [io  0x0000-0x007f]
> > Apr 30 17:14:27 merkaba kernel: [142441.095231] pci 0000:05:00.0: supports D1 D2
> > Apr 30 17:14:27 merkaba kernel: [142441.097378] pci 0000:05:00.0: BAR 2: assigned [mem 0xf1c00000-0xf1c01fff 64bit]
> > Apr 30 17:14:27 merkaba kernel: [142441.097412] pci 0000:05:00.0: BAR 0: assigned [mem 0xf1c02000-0xf1c0207f 64bit]
> > Apr 30 17:14:27 merkaba kernel: [142441.097452] pci 0000:05:00.0: BAR 4: assigned [io  0x4000-0x407f]
> > Apr 30 17:14:27 merkaba kernel: [142441.097595] sata_sil24 0000:05:00.0: enabling device (0000 -> 0003)
> >
> > I didn´t see anything BTRFS related in there and am not sure whether it is
> > to the BTRFS hang.
> >
> >
> > I think I will try this tomorrow, cause, hey, I want to update my backup!
> >
> > For safety I will run a scrub now.
> >
> > Ciao,
> > --
> > Martin 'Helios' Steigerwald - http://www.Lichtvoll.de
> > GPG: 03B0 0D6C 0040 0710 4AFA  B82F 991B EAAC A599 84C7
> 
> 
> 
> 

-- 
Martin 'Helios' Steigerwald - http://www.Lichtvoll.de
GPG: 03B0 0D6C 0040 0710 4AFA  B82F 991B EAAC A599 84C7ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±ı»k~ÏâØ^n‡r¡ö¦zËëh™¨è­Ú&£ûàz¿äz¹Ş—ú+€Ê+zf£¢·hšˆ§~†­†Ûiÿÿïêÿ‘êçz_è®æj:+v‰¨ş)ß£øm
