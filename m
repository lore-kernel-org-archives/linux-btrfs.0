From: Norbert Preining <preining@logic.at>
Subject: [BUG] btrfs is tearing down whole kernel when disk is disconnected
Date: Mon, 27 Jun 2011 10:41:01 +0900
Message-ID: <20110627014101.GA1517@gamma.logic.tuwien.ac.at>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-kernel@vger.kernel.org, linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hi everyone,

(please Cc)

kernel 3.0.0-rc4 (latest git)

btrfs on an external USB drive repeatingly tears down the whole
kernel due to write problems. Is that supposed to be?

It always happens when my external disk disconnects, out of whatever
reason (bad HW, bad cable, whatever?). THe sequence is alwayss:
- disconnect usb 2-3: USB disconnect, device number 4
- reconnect: usb 2-3: new high speed USB device number 5 using ehci_hcd
- kernel wonders about lost writing: lost page write due to I/O error on sdb1
- btrfs errors out: btrfs: 1 errors while writing supers
and from here on more or less everything stucks.

I see that a disconnecting drive during copying is not nice, but
btrfs should not kill the rest of the world due to that, esp since
it is an external drive.

Full syslog (some CD loading interspersed)
Jun 27 09:37:35 mithrandir kernel: [44516.328107] usb 2-3: new high speed USB device number 3 using ehci_hcd
Jun 27 09:37:35 mithrandir kernel: [44516.461495] usb 2-3: New USB device found, idVendor=0411, idProduct=0108
Jun 27 09:37:35 mithrandir kernel: [44516.461504] usb 2-3: New USB device strings: Mfr=1, Product=2, SerialNumber=3
Jun 27 09:37:35 mithrandir kernel: [44516.461511] usb 2-3: Product: USB-SATA Bridge
Jun 27 09:37:35 mithrandir kernel: [44516.461516] usb 2-3: Manufacturer: BUFFALO
Jun 27 09:37:35 mithrandir kernel: [44516.461521] usb 2-3: SerialNumber: 00000002022EAA7
Jun 27 09:37:36 mithrandir mtp-probe: checking bus 2, device 3: "/sys/devices/pci0000:00/0000:00:1d.7/usb2/2-3"
Jun 27 09:37:36 mithrandir mtp-probe: bus: 2, device: 3 was not an MTP device
Jun 27 09:37:36 mithrandir kernel: [44517.432442] Initializing USB Mass Storage driver...
Jun 27 09:37:36 mithrandir kernel: [44517.432566] scsi6 : usb-storage 2-3:1.0
Jun 27 09:37:36 mithrandir kernel: [44517.432672] usbcore: registered new interface driver usb-storage
Jun 27 09:37:36 mithrandir kernel: [44517.432674] USB Mass Storage support registered.
Jun 27 09:37:37 mithrandir kernel: [44518.432874] scsi 6:0:0:0: Direct-Access     BUFFALO  External HDD     0000 PQ: 0 ANSI: 3
Jun 27 09:37:37 mithrandir kernel: [44518.433318] sd 6:0:0:0: Attached scsi generic sg2 type 0
Jun 27 09:37:37 mithrandir kernel: [44518.434314] sd 6:0:0:0: [sdb] 2930277168 512-byte logical blocks: (1.50 TB/1.36 TiB)
Jun 27 09:37:37 mithrandir kernel: [44518.435312] sd 6:0:0:0: [sdb] Write Protect is off
Jun 27 09:37:37 mithrandir kernel: [44518.435321] sd 6:0:0:0: [sdb] Mode Sense: 3b 00 00 00
Jun 27 09:37:37 mithrandir kernel: [44518.436422] sd 6:0:0:0: [sdb] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
Jun 27 09:37:38 mithrandir kernel: [44518.801536]  sdb: sdb1
Jun 27 09:37:38 mithrandir kernel: [44518.804037] sd 6:0:0:0: [sdb] Attached SCSI disk
Jun 27 09:37:38 mithrandir ata_id[23313]: HDIO_GET_IDENTITY failed for '/dev/.tmp-block-8:16'
Jun 27 09:37:39 mithrandir kernel: [44519.806993] usb 2-3: USB disconnect, device number 3
Jun 27 09:37:39 mithrandir kernel: [44519.810841] sd 6:0:0:0: [sdb] Unhandled error code
Jun 27 09:37:39 mithrandir kernel: [44519.810844] sd 6:0:0:0: [sdb]  Result: hostbyte=0x01 driverbyte=0x00
Jun 27 09:37:39 mithrandir kernel: [44519.810847] sd 6:0:0:0: [sdb] CDB: cdb[0]=0x28: 28 00 ae a8 79 a0 00 00 08 00
Jun 27 09:37:39 mithrandir kernel: [44519.810854] end_request: I/O error, dev sdb, sector 2930276768
Jun 27 09:37:39 mithrandir kernel: [44519.810856] Buffer I/O error on device sdb, logical block 366284596
Jun 27 09:37:39 mithrandir kernel: [44519.824099] sd 6:0:0:0: [sdb] Synchronizing SCSI cache
Jun 27 09:37:39 mithrandir kernel: [44519.824152] sd 6:0:0:0: [sdb]  Result: hostbyte=0x01 driverbyte=0x00
Jun 27 09:37:39 mithrandir kernel: [44520.164082] usb 2-3: new high speed USB device number 4 using ehci_hcd
Jun 27 09:37:39 mithrandir kernel: [44520.297602] usb 2-3: New USB device found, idVendor=0411, idProduct=0108
Jun 27 09:37:39 mithrandir kernel: [44520.297613] usb 2-3: New USB device strings: Mfr=1, Product=2, SerialNumber=3
Jun 27 09:37:39 mithrandir kernel: [44520.297620] usb 2-3: Product: USB-SATA Bridge
Jun 27 09:37:39 mithrandir kernel: [44520.297625] usb 2-3: Manufacturer: BUFFALO
Jun 27 09:37:39 mithrandir kernel: [44520.297630] usb 2-3: SerialNumber: 00000002022EAA7
Jun 27 09:37:39 mithrandir kernel: [44520.298226] scsi7 : usb-storage 2-3:1.0
Jun 27 09:37:39 mithrandir mtp-probe: checking bus 2, device 4: "/sys/devices/pci0000:00/0000:00:1d.7/usb2/2-3"
Jun 27 09:37:39 mithrandir mtp-probe: bus: 2, device: 4 was not an MTP device
Jun 27 09:37:40 mithrandir kernel: [44521.296769] scsi 7:0:0:0: Direct-Access     BUFFALO  External HDD     0000 PQ: 0 ANSI: 3
Jun 27 09:37:40 mithrandir kernel: [44521.297214] sd 7:0:0:0: Attached scsi generic sg2 type 0
Jun 27 09:37:40 mithrandir kernel: [44521.299818] sd 7:0:0:0: [sdb] 2930277168 512-byte logical blocks: (1.50 TB/1.36 TiB)
Jun 27 09:37:40 mithrandir kernel: [44521.300814] sd 7:0:0:0: [sdb] Write Protect is off
Jun 27 09:37:40 mithrandir kernel: [44521.300824] sd 7:0:0:0: [sdb] Mode Sense: 3b 00 00 00
Jun 27 09:37:40 mithrandir kernel: [44521.301688] sd 7:0:0:0: [sdb] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
Jun 27 09:37:41 mithrandir kernel: [44521.665802]  sdb: sdb1
Jun 27 09:37:41 mithrandir ata_id[23363]: HDIO_GET_IDENTITY failed for '/dev/.tmp-block-8:16'
Jun 27 09:37:41 mithrandir kernel: [44521.668642] sd 7:0:0:0: [sdb] Attached SCSI disk
Jun 27 09:37:43 mithrandir kernel: [44523.585753] device fsid 70f41f7e-6f28-416e-a263-8c214138822a devid 1 transid 6703 /dev/sdb1
Jun 27 09:38:08 mithrandir kernel: [44548.820391] UDF-fs: No VRS found
Jun 27 09:38:08 mithrandir kernel: [44548.820399] UDF-fs: No partition found (1)
Jun 27 09:38:08 mithrandir kernel: [44548.921926] ISO 9660 Extensions: Microsoft Joliet Level 3
Jun 27 09:38:08 mithrandir kernel: [44548.955499] ISO 9660 Extensions: RRIP_1991A
Jun 27 09:50:59 mithrandir ata_id[24044]: HDIO_GET_IDENTITY failed for '/dev/sdb'
Jun 27 09:51:30 mithrandir kernel: [45351.308494] UDF-fs: No VRS found
Jun 27 09:51:30 mithrandir kernel: [45351.308502] UDF-fs: No partition found (1)
Jun 27 09:51:30 mithrandir kernel: [45351.396511] ISO 9660 Extensions: Microsoft Joliet Level 3
Jun 27 09:51:30 mithrandir kernel: [45351.412473] ISO 9660 Extensions: RRIP_1991A
Jun 27 10:26:24 mithrandir kernel: [47445.226388] usb 2-3: USB disconnect, device number 4
Jun 27 10:26:24 mithrandir kernel: [47445.252127] sd 7:0:0:0: [sdb] Synchronizing SCSI cache
Jun 27 10:26:24 mithrandir kernel: [47445.252169] sd 7:0:0:0: [sdb]  Result: hostbyte=0x01 driverbyte=0x00
Jun 27 10:26:24 mithrandir kernel: [47445.496109] usb 2-3: new high speed USB device number 5 using ehci_hcd
Jun 27 10:26:25 mithrandir kernel: [47445.633561] usb 2-3: New USB device found, idVendor=0411, idProduct=0108
Jun 27 10:26:25 mithrandir kernel: [47445.633571] usb 2-3: New USB device strings: Mfr=1, Product=2, SerialNumber=3
Jun 27 10:26:25 mithrandir kernel: [47445.633578] usb 2-3: Product: USB-SATA Bridge
Jun 27 10:26:25 mithrandir kernel: [47445.633583] usb 2-3: Manufacturer: BUFFALO
Jun 27 10:26:25 mithrandir kernel: [47445.633588] usb 2-3: SerialNumber: 00000002022EAA7
Jun 27 10:26:25 mithrandir kernel: [47445.634901] scsi8 : usb-storage 2-3:1.0
Jun 27 10:26:25 mithrandir mtp-probe: checking bus 2, device 5: "/sys/devices/pci0000:00/0000:00:1d.7/usb2/2-3"
Jun 27 10:26:25 mithrandir mtp-probe: bus: 2, device: 5 was not an MTP device
Jun 27 10:26:26 mithrandir kernel: [47446.632724] scsi 8:0:0:0: Direct-Access     BUFFALO  External HDD     0000 PQ: 0 ANSI: 3
Jun 27 10:26:26 mithrandir kernel: [47446.633142] sd 8:0:0:0: Attached scsi generic sg2 type 0
Jun 27 10:26:26 mithrandir kernel: [47446.633670] sd 8:0:0:0: [sdc] 2930277168 512-byte logical blocks: (1.50 TB/1.36 TiB)
Jun 27 10:26:26 mithrandir kernel: [47446.634540] sd 8:0:0:0: [sdc] Write Protect is off
Jun 27 10:26:26 mithrandir kernel: [47446.634549] sd 8:0:0:0: [sdc] Mode Sense: 3b 00 00 00
Jun 27 10:26:26 mithrandir kernel: [47446.635413] sd 8:0:0:0: [sdc] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
Jun 27 10:26:26 mithrandir kernel: [47446.665271]  sdc: sdc1
Jun 27 10:26:26 mithrandir kernel: [47446.667755] sd 8:0:0:0: [sdc] Attached SCSI disk
Jun 27 10:26:26 mithrandir ata_id[24585]: HDIO_GET_IDENTITY failed for '/dev/.tmp-block-8:32'
Jun 27 10:26:26 mithrandir kernel: [47446.985442] lost page write due to I/O error on sdb1
Jun 27 10:26:26 mithrandir kernel: [47446.985461] lost page write due to I/O error on sdb1
Jun 27 10:26:26 mithrandir kernel: [47446.985478] lost page write due to I/O error on sdb1
Jun 27 10:26:26 mithrandir kernel: [47446.985480] btrfs: 1 errors while writing supers
Jun 27 10:26:26 mithrandir kernel: [47446.985502] ------------[ cut here ]------------
Jun 27 10:26:26 mithrandir kernel: [47446.985532] kernel BUG at fs/btrfs/disk-io.c:2362!
Jun 27 10:26:26 mithrandir kernel: [47446.985559] invalid opcode: 0000 [#1] PREEMPT SMP 
Jun 27 10:26:26 mithrandir kernel: [47446.985592] CPU 0 
Jun 27 10:26:26 mithrandir kernel: [47446.985604] Modules linked in: udf usb_storage bnep rfcomm snd_hrtimer vboxnetadp vboxnetflt vboxdrv binfmt_misc dm_crypt dm_mod hso isofs btrfs zlib_deflate crc32c libcrc32c vfat fat fuse loop uinput snd_hda_codec_realtek btusb bluetooth crc16 arc4 snd_hda_intel snd_hda_codec snd_hwdep snd_pcm_oss snd_mixer_oss mxm_wmi snd_pcm snd_seq_dummy snd_seq_oss snd_seq_midi snd_rawmidi snd_seq_midi_event snd_seq joydev snd_timer snd_seq_device snd iwlagn tpm_infineon firewire_ohci mac80211 sony_laptop cfg80211 firewire_core crc_itu_t rfkill soundcore snd_page_alloc
Jun 27 10:26:26 mithrandir kernel: [47446.985977] 
Jun 27 10:26:26 mithrandir kernel: [47446.985988] Pid: 24594, comm: sync Not tainted 3.0.0-rc4+ #7 Sony Corporation VGN-Z11VN_B/VAIO
Jun 27 10:26:26 mithrandir kernel: [47446.986039] RIP: 0010:[<ffffffffa023aa3e>]  [<ffffffffa023aa3e>] write_all_supers+0x224/0x237 [btrfs]
Jun 27 10:26:26 mithrandir kernel: [47446.986101] RSP: 0018:ffff8801081f9da8  EFLAGS: 00010292
Jun 27 10:26:26 mithrandir kernel: [47446.986129] RAX: 000000000000003a RBX: ffff88012f977ab0 RCX: 0000000000000002
Jun 27 10:26:26 mithrandir kernel: [47446.986165] RDX: 000000000000fbfb RSI: ffff8801081f8000 RDI: ffff8801081f8000
Jun 27 10:26:26 mithrandir kernel: [47446.986201] RBP: ffff8801081f9e08 R08: 0000000000000002 R09: ffff8801881f9ccd
Jun 27 10:26:26 mithrandir kernel: [47446.986237] R10: ffff8801881f9ccd R11: 0000000000000000 R12: 0000000000000001
Jun 27 10:26:26 mithrandir kernel: [47446.986273] R13: ffff88012f977a40 R14: ffff880115577000 R15: 0000000000000000
Jun 27 10:26:26 mithrandir kernel: [47446.986309] FS:  00007f607724d700(0000) GS:ffff88013fc00000(0000) knlGS:0000000000000000
Jun 27 10:26:26 mithrandir kernel: [47446.986350] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
Jun 27 10:26:26 mithrandir kernel: [47446.986380] CR2: 0000000000402560 CR3: 0000000106fed000 CR4: 00000000000006f0
Jun 27 10:26:26 mithrandir kernel: [47446.986416] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
Jun 27 10:26:26 mithrandir kernel: [47446.986452] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Jun 27 10:26:26 mithrandir kernel: [47446.986488] Process sync (pid: 24594, threadinfo ffff8801081f8000, task ffff880108270ee0)
Jun 27 10:26:26 mithrandir kernel: [47446.986528] Stack:
Jun 27 10:26:26 mithrandir kernel: [47446.986541]  00000000053e0000 ffff88012f977ab0 ffff8801053e0e63 0000000000000001
Jun 27 10:26:26 mithrandir kernel: [47446.986587]  0000000000000000 ffff88012f977ab0 ffff8801081f9e08 ffff880115577000
Jun 27 10:26:26 mithrandir kernel: [47446.986633]  ffff8801271bd540 ffff880109a0de80 ffff880109a0def8 0000000000000000
Jun 27 10:26:26 mithrandir kernel: [47446.986679] Call Trace:
Jun 27 10:26:26 mithrandir kernel: [47446.986703]  [<ffffffffa023aa5f>] write_ctree_super+0xe/0x10 [btrfs]
Jun 27 10:26:26 mithrandir kernel: [47446.986746]  [<ffffffffa023ecd2>] btrfs_commit_transaction+0x600/0x700 [btrfs]
Jun 27 10:26:26 mithrandir kernel: [47446.986786]  [<ffffffff81047fd6>] ? remove_wait_queue+0x35/0x35
Jun 27 10:26:26 mithrandir kernel: [47446.986826]  [<ffffffffa023f23b>] ? start_transaction+0x20f/0x267 [btrfs]
Jun 27 10:26:26 mithrandir kernel: [47446.986862]  [<ffffffff810d030e>] ? __sync_filesystem+0x72/0x72
Jun 27 10:26:26 mithrandir kernel: [47446.986898]  [<ffffffffa0223bd5>] btrfs_sync_fs+0x62/0x66 [btrfs]
Jun 27 10:26:26 mithrandir kernel: [47446.986930]  [<ffffffff810d02fa>] __sync_filesystem+0x5e/0x72
Jun 27 10:26:26 mithrandir kernel: [47446.986960]  [<ffffffff810d031f>] sync_one_sb+0x11/0x13
Jun 27 10:26:26 mithrandir kernel: [47446.986989]  [<ffffffff810b3b5d>] iterate_supers+0x6a/0xbf
Jun 27 10:26:26 mithrandir kernel: [47446.987019]  [<ffffffff810d03a6>] sys_sync+0x3d/0x4f
Jun 27 10:26:26 mithrandir kernel: [47446.987048]  [<ffffffff8139b2fb>] system_call_fastpath+0x16/0x1b
Jun 27 10:26:26 mithrandir kernel: [47446.987079] Code: 20 01 00 00 48 8b b8 a0 23 00 00 48 83 c7 50 e8 80 f0 15 e1 44 3b 65 bc 7e 13 44 89 e6 48 c7 c7 5c e2 27 a0 31 c0 e8 7b 8c 15 e1 <0f> 0b 48 83 c4 38 31 c0 5b 41 5c 41 5d 41 5e 41 5f 5d c3 55 48 
Jun 27 10:26:26 mithrandir kernel: [47446.987330] RIP  [<ffffffffa023aa3e>] write_all_supers+0x224/0x237 [btrfs]
Jun 27 10:26:26 mithrandir kernel: [47446.987379]  RSP <ffff8801081f9da8>
Jun 27 10:26:26 mithrandir kernel: [47447.008621] ---[ end trace f05cb8d8439ec1e3 ]---
Jun 27 10:26:26 mithrandir ata_id[24599]: HDIO_GET_IDENTITY failed for '/dev/sdc'
Jun 27 10:26:26 mithrandir kernel: [47447.111285] device fsid 70f41f7e-6f28-416e-a263-8c214138822a devid 1 transid 6733 /dev/sdc1
Jun 27 10:26:40 mithrandir kernel: [47461.228484] UDF-fs: No VRS found
Jun 27 10:26:40 mithrandir kernel: [47461.228499] UDF-fs: No partition found (1)
Jun 27 10:26:40 mithrandir kernel: [47461.291343] ISO 9660 Extensions: Microsoft Joliet Level 3
Jun 27 10:26:40 mithrandir kernel: [47461.307156] ISO 9660 Extensions: RRIP_1991A
Jun 27 10:26:50 mithrandir kernel: [47471.328108] SysRq : Emergency Sync
Jun 27 10:26:51 mithrandir kernel: [47471.560922] SysRq : Emergency Sync




Best wishes

Norbert
------------------------------------------------------------------------
Norbert Preining            preining@{jaist.ac.jp, logic.at, debian.org}
JAIST, Japan                                 TeX Live & Debian Developer
DSA: 0x09C5B094   fp: 14DF 2E6C 0307 BE6D AD76  A9C0 D2BF 4AA3 09C5 B094
------------------------------------------------------------------------
SHENANDOAH (n.)
The infinite smugness of one who knows they are entitled to a place in
a nuclear bunker.
			--- Douglas Adams, The Meaning of Liff
