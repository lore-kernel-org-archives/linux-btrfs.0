From: "Jan Schubert" <jan.schubert@gmx.li>
Subject: Broken btrfs?
Date: Sat, 16 Jul 2011 23:44:04 +0200
Message-ID: <20110716214404.50480@gmx.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

For some while now I can reproduce a kernel oops. The reading of the oops migt point to btrfs so I also did a btrfsk which gives me this warning before aborting:

warning, start mismatch 13636968448 13636997120

I also find several entries in my dmesg concerning missing or wrong csum.

Please find some data and log below. Is there any chance to fix this?

Thx,
Jan

# uname -a
Linux toral 2.6.39-ARCH #1 SMP PREEMPT Sat Jul 9 14:57:41 CEST 2011 x86_64 Intel(R) Core(TM) i7 CPU M 620 @ 2.67GHz GenuineIntel GNU/Linux

Kernel oops incl. some trailing dmesg entries:
Jul 15 17:45:28 toral kernel: [    8.939884] btrfs: use ssd allocation scheme
Jul 15 17:45:28 toral kernel: [    9.215458] btrfs: unlinked 9 orphans
Jul 15 17:45:28 toral kernel: [   11.742539] IBM TrackPoint firmware: 0x0e, buttons: 3/3
Jul 15 17:45:28 toral kernel: [   11.989808] input: TPPS/2 IBM TrackPoint as /devices/platform/i8042/serio1/serio2/input/input10
Jul 15 17:45:28 toral kernel: [   12.783222] Adding 4194300k swap on /dev/sda3.  Priority:-1 extents:1 across:4194300k SS
Jul 15 17:45:48 toral kernel: [   32.414686] block group 13182697472 has an wrong amount of free space
Jul 15 17:48:48 toral kernel: [  212.347409] chrome-sandbox (1281): /proc/1278/oom_adj is deprecated, please use /proc/1278/oom_score_adj instead.
Jul 15 17:48:48 toral kernel: [  212.795221] btrfs no csum found for inode 199934 start 729088
Jul 15 17:48:48 toral kernel: [  212.796185] btrfs csum failed ino 199934 off 729088 csum 3390946210 private 0
Jul 15 17:48:49 toral kernel: [  213.458279] btrfs no csum found for inode 199934 start 24096768
Jul 15 17:48:49 toral kernel: [  213.461443] btrfs csum failed ino 199934 off 24096768 csum 439962552 private 0
Jul 15 17:48:49 toral kernel: [  213.471893] btrfs no csum found for inode 199934 start 24801280
Jul 15 17:48:49 toral kernel: [  213.471897] btrfs no csum found for inode 199934 start 24805376
Jul 15 17:48:49 toral kernel: [  213.473736] btrfs csum failed ino 199934 off 24801280 csum 158010657 private 0
Jul 15 17:48:49 toral kernel: [  213.473750] btrfs csum failed ino 199934 off 24805376 csum 127231121 private 0
Jul 15 17:49:18 toral kernel: [  241.943511] e1000e 0000:00:19.0: irq 42 for MSI/MSI-X
Jul 15 17:49:18 toral kernel: [  241.996564] e1000e 0000:00:19.0: irq 42 for MSI/MSI-X
Jul 15 17:49:21 toral kernel: [  245.266971] e1000e: eth0 NIC Link is Up 1000 Mbps Full Duplex, Flow Control: Rx
Jul 15 17:53:46 toral kernel: [  509.790018] BUG: unable to handle kernel paging request at ffffc9001153d000
Jul 15 17:53:46 toral kernel: [  509.790024] IP: [<ffffffff8121fb0b>] memcpy+0xb/0x120
Jul 15 17:53:46 toral kernel: [  509.790032] PGD 137020067 PUD 137021067 PMD 12a687067 PTE 0
Jul 15 17:53:46 toral kernel: [  509.790035] Oops: 0002 [#1] PREEMPT SMP 
Jul 15 17:53:46 toral kernel: [  509.790038] last sysfs file: /sys/devices/LNXSYSTM:00/device:00/PNP0A08:00/device:0a/PNP0C09:00/PNP0C0A:00/power_supply/BAT0/status
Jul 15 17:53:46 toral kernel: [  509.790041] CPU 1 
Jul 15 17:53:46 toral kernel: [  509.790042] Modules linked in: fpu aesni_intel cryptd aes_x86_64 aes_generic xts gf128mul dm_crypt dm_mod loop acpi_cpufreq freq_table mperf joydev snd_hda_codec_hdmi nvidia(P) snd_hda_codec_conexant qcserial usbhid snd_pcm_oss usb_wwan snd_mixer_oss hid btusb usbserial snd_hda_intel bluetooth arc4 ecb crc16 snd_hda_codec snd_hwdep snd_pcm iwlagn sdhci_pci snd_timer sdhci thinkpad_acpi serio_raw mac80211 iTCO_wdt evdev psmouse pcspkr i2c_i801 snd battery sg nvram intel_agp ac mmc_core iTCO_vendor_support cfg80211 soundcore video intel_gtt intel_ips snd_page_alloc i2c_core wmi thermal rfkill button processor e1000e btrfs zlib_deflate crc32c libcrc32c ext2 mbcache ehci_hcd usbcore sr_mod cdrom sd_mod ahci libahci libata scsi_mod
Jul 15 17:53:46 toral kernel: [  509.790082] 
Jul 15 17:53:46 toral kernel: [  509.790085] Pid: 1668, comm: btrfs-endio-1 Tainted: P            2.6.39-ARCH #1 LENOVO 25223FG/25223FG
Jul 15 17:53:46 toral kernel: [  509.790088] RIP: 0010:[<ffffffff8121fb0b>]  [<ffffffff8121fb0b>] memcpy+0xb/0x120
Jul 15 17:53:46 toral kernel: [  509.790090] RSP: 0018:ffff880103793c58  EFLAGS: 00010246
Jul 15 17:53:46 toral kernel: [  509.790092] RAX: ffffc9001153cff8 RBX: 0000000000001000 RCX: 00000000000001ff
Jul 15 17:53:46 toral kernel: [  509.790093] RDX: 0000000000000000 RSI: ffff8800b1d6c008 RDI: ffffc9001153d000
Jul 15 17:53:46 toral kernel: [  509.790095] RBP: ffff880103793d30 R08: 000000006fb3eeb1 R09: ffffc9001153b000
Jul 15 17:53:46 toral kernel: [  509.790096] R10: 0000000000000000 R11: 0000000000000001 R12: 0000000000000000
Jul 15 17:53:46 toral kernel: [  509.790098] R13: ffff880129b16b58 R14: 000000006fb40ea9 R15: 000000006fb40eb1
Jul 15 17:53:46 toral kernel: [  509.790100] FS:  0000000000000000(0000) GS:ffff880137c80000(0000) knlGS:0000000000000000
Jul 15 17:53:46 toral kernel: [  509.790101] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
Jul 15 17:53:46 toral kernel: [  509.790103] CR2: ffffc9001153d000 CR3: 0000000001693000 CR4: 00000000000006e0
Jul 15 17:53:46 toral kernel: [  509.790104] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
Jul 15 17:53:46 toral kernel: [  509.790106] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Jul 15 17:53:46 toral kernel: [  509.790107] Process btrfs-endio-1 (pid: 1668, threadinfo ffff880103792000, task ffff88013167d4c0)
Jul 15 17:53:46 toral kernel: [  509.790109] Stack:
Jul 15 17:53:46 toral kernel: [  509.790110]  ffffffffa014f84b ffff880103793cb0 ffffffffa013316b ffff880103793fd8
Jul 15 17:53:46 toral kernel: [  509.790113]  000000006fb3eeb1 ffffc9001153b000 0000000000001000 0000000000000000
Jul 15 17:53:46 toral kernel: [  509.790115]  ffff88012f8bc780 0000000000000002 00000020a014ff66 ffff8800b1f9e000
Jul 15 17:53:46 toral kernel: [  509.790118] Call Trace:
Jul 15 17:53:46 toral kernel: [  509.790131]  [<ffffffffa014f84b>] ? lzo_decompress_biovec+0x27b/0x2f0 [btrfs]
Jul 15 17:53:46 toral kernel: [  509.790139]  [<ffffffffa013316b>] ? clear_state_bit+0xfb/0x170 [btrfs]
Jul 15 17:53:46 toral kernel: [  509.790145]  [<ffffffffa0150f58>] btrfs_decompress_biovec+0x68/0xa0 [btrfs]
Jul 15 17:53:46 toral kernel: [  509.790151]  [<ffffffffa01510ed>] end_compressed_bio_read+0x15d/0x240 [btrfs]
Jul 15 17:53:46 toral kernel: [  509.790158]  [<ffffffffa010d14b>] ? end_workqueue_fn+0x4b/0x140 [btrfs]
Jul 15 17:53:46 toral kernel: [  509.790163]  [<ffffffff8118392d>] bio_endio+0x1d/0x40
Jul 15 17:53:46 toral kernel: [  509.790169]  [<ffffffffa010d156>] end_workqueue_fn+0x56/0x140 [btrfs]
Jul 15 17:53:46 toral kernel: [  509.790176]  [<ffffffffa0140d25>] worker_loop+0x165/0x520 [btrfs]
Jul 15 17:53:46 toral kernel: [  509.790182]  [<ffffffffa0140bc0>] ? btrfs_queue_worker+0x2f0/0x2f0 [btrfs]
Jul 15 17:53:46 toral kernel: [  509.790187]  [<ffffffff8107d6ec>] kthread+0x8c/0xa0
Jul 15 17:53:46 toral kernel: [  509.790190]  [<ffffffff813e9fe4>] kernel_thread_helper+0x4/0x10
Jul 15 17:53:46 toral kernel: [  509.790192]  [<ffffffff8107d660>] ? kthread_worker_fn+0x190/0x190
Jul 15 17:53:46 toral kernel: [  509.790194]  [<ffffffff813e9fe0>] ? gs_change+0x13/0x13
Jul 15 17:53:46 toral kernel: [  509.790195] Code: 58 2a 43 50 88 43 4e 48 83 c4 08 5b 5d c3 66 90 e8 0b fd ff ff eb e6 90 90 90 90 90 90 90 90 90 48 89 f8 89 d1 c1 e9 03 83 e2 07 <f3> 48 a5 89 d1 f3 a4 c3 20 48 83 ea 20 4c 8b 06 4c 8b 4e 08 4c 
Jul 15 17:53:46 toral kernel: [  509.790214] RIP  [<ffffffff8121fb0b>] memcpy+0xb/0x120
Jul 15 17:53:46 toral kernel: [  509.790216]  RSP <ffff880103793c58>
Jul 15 17:53:46 toral kernel: [  509.790217] CR2: ffffc9001153d000
Jul 15 17:53:46 toral kernel: [  509.790219] ---[ end trace e610e9ec534eb542 ]---
-- 
NEU: FreePhone - kostenlos mobil telefonieren!			
Jetzt informieren: http://www.gmx.net/de/go/freephone
