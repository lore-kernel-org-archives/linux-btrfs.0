From: oli1417@hallo.ms
Subject: Soft lockup by using 256K sizes
Date: Sat, 11 Jul 2009 02:20:55 +0200
Message-ID: <901705186@web.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hello,

I just tried btrfs with a big blocksize (-n,-l,-s) of 256K. Creating the fs worked Ok. I had to put all three -n,-l,-s options to 256K, otherwise mkfs.btrfs complained. But mounting results in a soft lockup (reproducible). It's not the latest btrfs version however. The details are shown below. 

Background is the following: 

To upgrade the hdd of an old laptop, I used a combination of CompactFlash + CF-to-IDE adapter - a kind of poor-man's SSD solution. With some tuning of /proc/sys/vm/dirty_X settings this is actually really Ok to work with. For erase block aligning I just aligned partitions to 1MiB. 

By experimenting with dd I found, that the best write-rates were with 256KiB / 512KiB blocks sizes. This let me to the wild idea to try btrfs with 256K block sizes, so that cow and small file packing would feed the CF with ideal chunks of data. 

Well, I don't know really whether this is supposed to work anyhow. I know about the ssd option, but was just curious what it would give for the small file packing. Anyhow ... it soft locked it ;).  

Cheers, Oliver

mkfs.btrfs:
---
# mkfs.btrfs -s 256K -n 256K -l 256K /dev/hda3

WARNING! - Btrfs Btrfs v0.18 IS EXPERIMENTAL
WARNING! - see http://btrfs.wiki.kernel.org before using

fs created label (null) on /dev/hda3
        nodesize 262144 leafsize 262144 sectorsize 262144 size 4.88GB
Btrfs Btrfs v0.18

#
---


kmsg:
---
[  447.744830] device fsid 554eb395ef55edc9-b8068222421fcb91 devid 1 transid 9 /dev/hda3       
[  513.252013] BUG: soft lockup - CPU#0 stuck for 61s! [btrfs-endio-met:5137]                  
[  513.252013] Modules linked in: btrfs zlib_deflate crc32c libcrc32c sd_mod crc_t10dif usb_storage i915 drm i2c_algo_bit i2c_core binfmt_misc ppdev lp bnep rfcomm l2cap bluetooth michael_mic arc4 ecb lib80211_crypt_tkip acpi_cpufreq cpufreq_powersave cpufreq_userspace cpufreq_stats cpufreq_conservative nfsd exportfs nfs lockd fscache nfs_acl auth_rpcgss sunrpc ext4 jbd2 crc16 fuse dm_crypt dm_snapshot cdc_ether usbnet loop joydev pcmcia ipw2100 libipw snd_intel8x0m lib80211 yenta_socket rsrc_nonstatic pcmcia_core snd_seq_midi snd_rawmidi snd_intel8x0 snd_seq_midi_event snd_ac97_codec ac97_bus snd_seq snd_pcm_oss snd_mixer_oss snd_seq_device snd_pcm psmouse shpchp snd_timer snd soundcore serio_raw snd_page_alloc rng_core dcdbas irda pcspkr pci_hotplug battery button evdev parport_pc parpor
 t crc_ccitt ac processor usbhid hid ext3 jbd mbcache ide_cd_mod ide_gd_mod cdrom ata_generic libata uhci_hcd scsi_mod ide_pci_generic ehci_hcd piix intel_agp e100 mii ide_core usbcore video 
 output agpgart thermal fan thermal_sys dm_mirror dm_region_hash dm_log dm_mod                                                                                                                                                                                     
[  513.252013]                                                                                                                                                                                                  
[  513.252013] Pid: 5137, comm: btrfs-endio-met Not tainted (2.6.30-1-686 #1) Inspiron 500m
[  513.252013] EIP: 0060:[<c031df3b>] EFLAGS: 00000246 CPU: 0
[  513.252013] EIP is at _spin_unlock_irqrestore+0x6/0xb
[  513.252013] EAX: 00000246 EBX: 00000001 ECX: f65bf5f4 EDX: 00000246
[  513.252013] ESI: f65bf5e0 EDI: f23c3980 EBP: f23c39a8 ESP: f2103f88
[  513.252013]  DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
[  513.252013] CR0: 8005003b CR2: b7ef56e4 CR3: 3080b000 CR4: 000006d0
[  513.252013] DR0: 00000000 DR1: 00000000 DR2: 00000000 DR3: 00000000
[  513.252013] DR6: ffff0ff0 DR7: 00000400
[  513.252013] Call Trace:
[  513.252013]  [<f8839162>] ? btrfs_queue_worker+0x1d4/0x1ea [btrfs]
[  513.252013]  [<f8838ca6>] ? worker_loop+0x73/0x1be [btrfs]
[  513.252013]  [<f8838c33>] ? worker_loop+0x0/0x1be [btrfs]
[  513.252013]  [<c0136740>] ? kthread+0x42/0x67
[  513.252013]  [<c01366fe>] ? kthread+0x0/0x67
[  513.252013]  [<c0103ab7>] ? kernel_thread_helper+0x7/0x10
[  578.748013] BUG: soft lockup - CPU#0 stuck for 61s! [btrfs-endio-met:5137]
[...]
---

