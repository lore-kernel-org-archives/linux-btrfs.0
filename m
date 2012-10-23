Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mho-04-ewr.mailhop.org ([204.13.248.74]:64580 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756708Ab2JWSoU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 23 Oct 2012 14:44:20 -0400
Received: from 168.139.79.188.dynamic.jazztel.es ([188.79.139.168] helo=mail.viric.name)
	by mho-02-ewr.mailhop.org with esmtpsa (TLSv1:AES256-SHA:256)
	(Exim 4.72)
	(envelope-from <viric@viric.name>)
	id 1TQjSd-000IkS-DP
	for linux-btrfs@vger.kernel.org; Tue, 23 Oct 2012 18:44:19 +0000
Date: Tue, 23 Oct 2012 20:44:14 +0200
From: =?iso-8859-1?Q?Llu=EDs?= Batlle i Rossell <viric@viric.name>
To: Btrfs mailing list <linux-btrfs@vger.kernel.org>
Subject: kernel BUG at fs/btrfs/extent_io.c:1901!
Message-ID: <20121023184413.GJ2052@vicerveza.homeunix.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello,

having troubles with a disk drive part of a raid1, I've hit that the repair code
has to be run quite a lot... It seems that one hard disk fails writing when I
resume the machine from suspend. On reboot, btrfs tries to repair all.

In fact, btrfs reports all errors as corrected; I'm happy with that. But I
either run a scrub without running any other program until it finishes, or the
automatic repair triggers too often this kernel BUG. It's 3.6.2, and I don't
know if it has been fixed in newer versions, but here is the log:

[   32.992028] br0: port 1(eth0) entered forwarding state
[   36.317259] btrfs: free space inode generation (0) did not match free space cache generation (188740)
[   36.333158] btrfs: free space inode generation (0) did not match free space cache generation (188739)
[   36.356532] parent transid verify failed on 1970550300672 wanted 188740 found 188735
[   36.373327] btrfs read error corrected: ino 1 off 1970550300672 (dev /dev/sdb1 sector 37924400)
[   36.393322] parent transid verify failed on 1970550304768 wanted 188740 found 188735
[   36.413708] btrfs read error corrected: ino 1 off 1970550304768 (dev /dev/sdb1 sector 37924408)
[   36.692974] parent transid verify failed on 1970550919168 wanted 188740 found 188735
[   36.745875] btrfs read error corrected: ino 1 off 1970550919168 (dev /dev/sdb1 sector 37925608)
[   36.768413] parent transid verify failed on 1970539311104 wanted 188739 found 188737
[   36.785945] btrfs read error corrected: ino 1 off 1970539311104 (dev /dev/sdb1 sector 37902936)
[   55.787463] btrfs csum failed ino 44023067 extent 1013690368 csum 235012505 wanted 401855927 mirror 0
[   55.788861] btrfs csum failed ino 44023067 extent 1013690368 csum 235012505 wanted 401855927 mirror 0
[   55.889353] btrfs csum failed ino 44023067 extent 1013690368 csum 235012505 wanted 401855927 mirror 1
[   55.923970] ------------[ cut here ]------------
[   55.923983] kernel BUG at fs/btrfs/extent_io.c:1901!
[   55.923988] invalid opcode: 0000 [#1] SMP 
[   55.923994] Modules linked in: xfs exportfs bridge stp llc nvidiafb fbcon fb_ddc tileblit font vgastate bitblit softcursor nouveau ttm drm_kms_helper drm i2c_algo_bit mxm_wmi video wmi nvidia(PO) snd_usb_audio snd_usbmidi_lib snd_rawmidi snd_seq_device gspca_ov519 gspca_main videodev rtc_cmos ppdev edac_core mac_hid agpgart parport_pc edac_mce_amd parport forcedeth joydev snd_hda_codec_realtek sg i2c_nforce2 k8temp pcspkr hid_generic button i2c_core snd_hda_intel snd_hda_codec snd_hwdep tun kvm_amd kvm powernow_k8 fuse cpufreq_conservative cpufreq_ondemand cpufreq_powersave cpufreq_performance freq_table processor thermal_sys hwmon mperf snd_pcm_oss snd_pcm snd_timer snd_page_alloc snd_mixer_oss snd soundcore autofs4 loop sunrpc ipv6 sd_mod crc_t10dif sata_nv unix r8169 mii evdev usbhid hid firewire_ohci firewire_core crc_itu_t pata_atiixp ohci_hcd ehci_hcd usbcore usb_common ahci libahci libata scsi_mod dm_mod btrfs zlib_deflate crc32c libcrc32c ext4 jbd2 crc16 ext3 jbd ext2 mbcache
[   55.924108] CPU 1 
[   55.924118] Pid: 1389, comm: btrfs-endio-3 Tainted: P           O 3.6.2 #1 MSI MS-7309/K9N6PGM2-V2 (MS-7309)
[   55.924122] RIP: 0010:[<ffffffffa0189689>]  [<ffffffffa0189689>] repair_io_failure+0x1c9/0x200 [btrfs]
[   55.924182] RSP: 0018:ffff88013971fcc0  EFLAGS: 00010202
[   55.924186] RAX: 0000000000000000 RBX: ffff8801335bac00 RCX: 0000000000000002
[   55.924190] RDX: ffff8801335f5cc0 RSI: 0000007e6e8b5000 RDI: ffff8801385774e0
[   55.924193] RBP: ffff88013971fd40 R08: ffff8801335f5cc0 R09: 0000000000000002
[   55.924196] R10: ffff880133596240 R11: ffff8801385774e0 R12: 0000000038535d40
[   55.924200] R13: ffff88013971fce0 R14: 000001cd44f25000 R15: 0000000000001000
[   55.924205] FS:  00007fd54488c700(0000) GS:ffff88013fc80000(0000) knlGS:0000000000000000
[   55.924208] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[   55.924212] CR2: ffffffffff600400 CR3: 000000013918b000 CR4: 00000000000007e0
[   55.924216] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[   55.924220] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[   55.924224] Process btrfs-endio-3 (pid: 1389, threadinfo ffff88013971e000, task ffff88013a44ad40)
[   55.924226] Stack:
[   55.924229]  ffff88013971fd40 0000000000000000 ffff8801382d0110 ffffea000497a780
[   55.924236]  0000000000000000 0000000000000000 ffff88013971fcf0 ffff88013971fcf0
[   55.924242]  000000000000b000 ffff8801335f5cc0 ffff88013971fd40 ffffea000497a780
[   55.924249] Call Trace:
[   55.924291]  [<ffffffffa0189f0a>] end_bio_extent_readpage+0x84a/0x890 [btrfs]
[   55.924301]  [<ffffffff8118a7bd>] bio_endio+0x1d/0x40
[   55.924335]  [<ffffffffa0169171>] end_workqueue_fn+0x41/0x50 [btrfs]
[   55.924373]  [<ffffffffa0197e4f>] worker_loop+0x14f/0x570 [btrfs]
[   55.924381]  [<ffffffff8107cc78>] ? __wake_up_common+0x58/0x90
[   55.924419]  [<ffffffffa0197d00>] ? btrfs_queue_worker+0x300/0x300 [btrfs]
[   55.924426]  [<ffffffff81073cb3>] kthread+0x93/0xa0
[   55.924435]  [<ffffffff813e9d84>] kernel_thread_helper+0x4/0x10
[   55.924440]  [<ffffffff81073c20>] ? flush_kthread_worker+0xb0/0xb0
[   55.924446]  [<ffffffff813e9d80>] ? gs_change+0x13/0x13
[   55.924449] Code: 40 00 48 89 df e8 c8 25 00 e1 31 f6 4c 89 e7 e8 8e da 00 00 b8 fb ff ff ff eb b6 0f 1f 80 00 00 00 00 b8 fb ff ff ff eb a8 0f 0b <0f> 0b 48 8b 55 98 49 8b 8c 24 88 00 00 00 4d 89 f0 48 c7 c7 00 
[   55.924506] RIP  [<ffffffffa0189689>] repair_io_failure+0x1c9/0x200 [btrfs]
[   55.924542]  RSP <ffff88013971fcc0>
[   55.924584] ---[ end trace 33d1df6b08ca3c28 ]---
[  144.329761] parent transid verify failed on 1970556370944 wanted 188740 found 188736
[  144.336746] btrfs read error corrected: ino 1 off 1970556370944 (dev /dev/sdb1 sector 37936256)
[  144.337197] parent transid verify failed on 1970556379136 wanted 188740 found 188736
[  144.337591] btrfs read error corrected: ino 1 off 1970556379136 (dev /dev/sdb1 sector 37936272)
[  144.350536] parent transid verify failed on 1970556407808 wanted 188740 found 188736
[  144.350939] btrfs read error corrected: ino 1 off 1970556407808 (dev /dev/sdb1 sector 37936328)
[  144.795234] parent transid verify failed on 1970535964672 wanted 188740 found 188737
[  144.804988] btrfs read error corrected: ino 1 off 1970535964672 (dev /dev/sdb1 sector 37896400)
[  144.895175] parent transid verify failed on 1970535952384 wanted 188740 found 188737
[  144.895591] btrfs read error corrected: ino 1 off 1970535952384 (dev /dev/sdb1 sector 37896376)
[  164.330212] parent transid verify failed on 1970547499008 wanted 188740 found 188735
[  164.338751] btrfs read error corrected: ino 1 off 1970547499008 (dev /dev/sdb1 sector 37918928)

Thank you,
Lluís.
