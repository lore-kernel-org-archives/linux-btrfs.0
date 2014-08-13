Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from slmp-550-94.slc.westdc.net ([50.115.112.57]:58184 "EHLO
	slmp-550-94.slc.westdc.net" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751317AbaHMT1P convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 13 Aug 2014 15:27:15 -0400
Received: from c-75-70-18-61.hsd1.co.comcast.net ([75.70.18.61]:58131 helo=ming.hsd1.co.comcast.net)
	by slmp-550-94.slc.westdc.net with esmtpsa (TLSv1:AES128-SHA:128)
	(Exim 4.82)
	(envelope-from <lists@colorremedies.com>)
	id 1XHeCW-003h7U-IA
	for linux-btrfs@vger.kernel.org; Wed, 13 Aug 2014 13:27:13 -0600
From: Chris Murphy <lists@colorremedies.com>
Content-Type: text/plain; charset=us-ascii
Subject: [BUG] kernel BUG at fs/btrfs/extent_io.c:2124! oops when reading corrupt file on btrfs raid5
Message-Id: <E7CC2628-F28A-4431-86D7-0572F6C9F296@colorremedies.com>
Date: Wed, 13 Aug 2014 13:27:10 -0600
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 6.6 \(1510\))
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Summary: 
Corrupt a file on a btrfs raid5 volume, mount then read the file, I get an oops. System is totally hung up, ssh no longer works, etc.


Versions:
kernel-3.16.0-1.cmlb729fdm810v4.fc21.x86_64
btrfs-progs-3.14.2-3.fc21

Kernel 3.16.0-1.fc21.x86_64 with the following patches to btrfs/send.c and btrfs/sysfs.c, probably not a factor.
https://friendpaste.com/Bgwdjk31P3pZHtArr341G
https://www.mail-archive.com/linux-btrfs@vger.kernel.org/msg35925.html

Kernel is tainted due to building vbox guest additions, also probably not a factor.



Reproduce steps:


# mkfs.btrfs -mraid5 -draid5 /dev/sd[bcd]
# mount /dev/sdb /mnt
# cp /boot/vmlinuz-0-rescue-05dc03f2ac9a4275ac6ca3c9acb23b01 /mnt/
# filefrag -v /mnt/vmlinuz-0-rescue-05dc03f2ac9a4275ac6ca3c9acb23b01 
File size of /mnt/vmlinuz-0-rescue-05dc03f2ac9a4275ac6ca3c9acb23b01 is 6188600 (1511 blocks of 4096 bytes)
 ext:     logical_offset:        physical_offset: length:   expected: flags:
   0:        0..    1510:     534016..    535526:   1511:             last,eof
/mnt/vmlinuz-0-rescue-05dc03f2ac9a4275ac6ca3c9acb23b01: 1 extent found
# umount /mnt
# btrfs-corrupt-block -c1 -l 2187329536 /dev/sdb
mirror 1 logical 2187329536 physical 1084227584 device /dev/sdc
corrupting 2187329536 copy 1
mirror 2 logical 2187329536 physical 1084227584 device /dev/sdd
# mount /dev/sdb /mnt
# sha1sum /mnt/vmlinuz-0-rescue-05dc03f2ac9a4275ac6ca3c9acb23b01 
<system hangs>



Capture from serial console:


[  240.937759] BTRFS info (device sdd): disk space caching is enabled
[  246.494163] BTRFS info (device sdd): csum failed ino 257 off 0 csum 2566472073 expected csum 2054244407
[  246.594305] BTRFS info (device sdd): csum failed ino 257 off 4096 csum 232031403 expected csum 2054244407
[  246.699625] BTRFS info (device sdd): csum failed ino 257 off 8192 csum 289721564 expected csum 2054244407
[  246.815886] BTRFS info (device sdd): csum failed ino 257 off 12288 csum 3907555249 expected csum 2054244407
[  246.815945] ------------[ cut here ]------------
[  246.815950] kernel BUG at fs/btrfs/extent_io.c:2124!
[  246.815957] invalid opcode: 0000 [#1] SMP 
[  246.815973] Modules linked in: vboxsf(OE) cfg80211 rfkill btrfs snd_intel8x0 ppdev xor snd_ac97_codec ac97_bus snd_seq raid6_pq snd_seq_device snd_pcm microcode serio_raw vboxvideo(OE) drm snd_timer snd parport_pc i2c_piix4 parport i2c_core soundcore vboxguest(OE) xfs libcrc32c virtio_net virtio_pci virtio_ring virtio ata_generic pata_acpi
[  246.815978] CPU: 1 PID: 75 Comm: kworker/u6:5 Tainted: G           OE 3.16.0-1.cmlb729fdm810v4.fc21.x86_64 #1
[  246.815981] Hardware name: innotek GmbH VirtualBox/VirtualBox, BIOS VirtualBox 12/01/2006
[  246.815999] Workqueue: btrfs-endio normal_work_helper [btrfs]
[  246.816002] task: ffff88009ba54520 ti: ffff880000040000 task.ti: ffff880000040000
[  246.816037] RIP: 0010:[<ffffffffa0317b45>]  [<ffffffffa0317b45>] end_bio_extent_readpage+0xb45/0xcd0 [btrfs]
[  246.816040] RSP: 0018:ffff880000043ca0  EFLAGS: 00010246
[  246.816043] RAX: 0000000000000000 RBX: ffffea00025ae800 RCX: ffff8800997622b0
[  246.816045] RDX: ffff8800997622c0 RSI: ffff8800997622a0 RDI: 0000000000000000
[  246.816048] RBP: ffff880000043d70 R08: 0000000000000001 R09: 0000000000000000
[  246.816051] R10: ffff880099789168 R11: ffff88009aaef200 R12: ffff880099789168
[  246.816053] R13: 0000000000001000 R14: ffff880099bfbc30 R15: 0000000000001000
[  246.816056] FS:  0000000000000000(0000) GS:ffff88009fa80000(0000) knlGS:0000000000000000
[  246.816059] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[  246.816062] CR2: 00007fa49063b000 CR3: 0000000099da3000 CR4: 00000000000006e0
[  246.816067] Stack:
[  246.816073]  ffff88009b927800 ffff88009f4064e0 0000000000014a00 ffff88009fa94a00
[  246.816078]  0000000000014a00 ffff880099788fc0 ffff88009a3f9000 ffff880099789168
[  246.816083]  ffff880099bfbb40 ffff880099789168 ffff880099789000 0000000000000000
[  246.816086] Call Trace:
[  246.816095]  [<ffffffff8133abdb>] bio_endio+0x6b/0xa0
[  246.816101]  [<ffffffff8133ac22>] bio_endio_nodec+0x12/0x20
[  246.816112]  [<ffffffffa02eca57>] end_workqueue_fn+0x37/0x40 [btrfs]
[  246.816125]  [<ffffffffa032664d>] normal_work_helper+0xbd/0x280 [btrfs]
[  246.816132]  [<ffffffff810abc16>] process_one_work+0x176/0x470
[  246.816138]  [<ffffffff810ac62b>] worker_thread+0x6b/0x550
[  246.816144]  [<ffffffff810ac5c0>] ? rescuer_thread+0x2e0/0x2e0
[  246.816151]  [<ffffffff810b30ea>] kthread+0xea/0x100
[  246.816156]  [<ffffffff810b3000>] ? insert_kthread_work+0x40/0x40
[  246.816164]  [<ffffffff8172297c>] ret_from_fork+0x7c/0xb0
[  246.816170]  [<ffffffff810b3000>] ? insert_kthread_work+0x40/0x40
[  246.816186] Code: ff ff ff 4c 8b 9d 78 ff ff ff e9 a8 f9 ff ff 0f 1f 80 00 00 00 00 c7 01 00 00 00 00 c7 44 11 fc 00 00 00 00 e9 e5 f8 ff ff 0f 0b <0f> 0b f6 05 74 d6 06 00 04 74 29 41 8b 4a 28 45 89 d8 ba 01 00 
[  246.816198] RIP  [<ffffffffa0317b45>] end_bio_extent_readpage+0xb45/0xcd0 [btrfs]
[  246.816200]  RSP <ffff880000043ca0>
[  246.816267] ---[ end trace 8de5096f8477f8e8 ]---
[  246.816314] BUG: unable to handle kernel paging request at ffffffffffffffd8
[  246.816320] IP: [<ffffffff810b36f0>] kthread_data+0x10/0x20
[  246.816326] PGD 1c14067 PUD 1c16067 PMD 0 
[  246.816331] Oops: 0000 [#2] SMP 
[  246.816343] Modules linked in: vboxsf(OE) cfg80211 rfkill btrfs snd_intel8x0 ppdev xor snd_ac97_codec ac97_bus snd_seq raid6_pq snd_seq_device snd_pcm microcode serio_raw vboxvideo(OE) drm snd_timer snd parport_pc i2c_piix4 parport i2c_core soundcore vboxguest(OE) xfs libcrc32c virtio_net virtio_pci virtio_ring virtio ata_generic pata_acpi
[  246.816346] CPU: 1 PID: 75 Comm: kworker/u6:5 Tainted: G      D    OE 3.16.0-1.cmlb729fdm810v4.fc21.x86_64 #1
[  246.816349] Hardware name: innotek GmbH VirtualBox/VirtualBox, BIOS VirtualBox 12/01/2006
[  246.816357] task: ffff88009ba54520 ti: ffff880000040000 task.ti: ffff880000040000
[  246.816363] RIP: 0010:[<ffffffff810b36f0>]  [<ffffffff810b36f0>] kthread_data+0x10/0x20
[  246.816366] RSP: 0018:ffff880000043958  EFLAGS: 00010002
[  246.816368] RAX: 0000000000000000 RBX: 0000000000000001 RCX: 0000000000000000
[  246.816371] RDX: 0000000000000000 RSI: 0000000000000001 RDI: ffff88009ba54520
[  246.816374] RBP: ffff880000043958 R08: ffff88009ba545b0 R09: 0000000000000001
[  246.816376] R10: ffff88009fa990c0 R11: ffff880036968bc8 R12: ffff88009fa94a00
[  246.816379] R13: ffff88009ba549d8 R14: 0000000000000001 R15: ffff88009ba54520
[  246.816382] FS:  0000000000000000(0000) GS:ffff88009fa80000(0000) knlGS:0000000000000000
[  246.816384] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[  246.816387] CR2: 0000000000000028 CR3: 0000000099da3000 CR4: 00000000000006e0
[  246.816391] Stack:
[  246.816397]  ffff880000043970 ffffffff810acb91 0000000000000000 ffff8800000439d0
[  246.816402]  ffffffff8171e69c ffff88009ba54520 0000000000014a00 ffff880000043fd8
[  246.816407]  0000000000014a00 ffffffff813461ca ffff88009ba54bf0 ffff880000043670
[  246.816409] Call Trace:
[  246.816416]  [<ffffffff810acb91>] wq_worker_sleeping+0x11/0x90
[  246.816422]  [<ffffffff8171e69c>] __schedule+0x63c/0x780
[  246.816429]  [<ffffffff813461ca>] ? put_io_context_active+0xaa/0xd0
[  246.816434]  [<ffffffff8171e809>] schedule+0x29/0x70
[  246.816441]  [<ffffffff81091f58>] do_exit+0x828/0xa80
[  246.816449]  [<ffffffff8101750c>] oops_end+0x9c/0xe0
[  246.816455]  [<ffffffff810179db>] die+0x4b/0x70
[  246.816461]  [<ffffffff8101402a>] do_trap+0xba/0x150
[  246.816467]  [<ffffffff810143e5>] do_error_trap+0x95/0x130
[  246.816479]  [<ffffffffa0317b45>] ? end_bio_extent_readpage+0xb45/0xcd0 [btrfs]
[  246.816484]  [<ffffffff81333a67>] ? chksum_update+0x17/0x20
[  246.816490]  [<ffffffff813256f6>] ? crypto_shash_update+0x36/0x100
[  246.816496]  [<ffffffff81014c50>] do_invalid_op+0x20/0x30
[  246.816502]  [<ffffffff817243de>] invalid_op+0x1e/0x30
[  246.816513]  [<ffffffffa0317b45>] ? end_bio_extent_readpage+0xb45/0xcd0 [btrfs]
[  246.816519]  [<ffffffff8133abdb>] bio_endio+0x6b/0xa0
[  246.816525]  [<ffffffff8133ac22>] bio_endio_nodec+0x12/0x20
[  246.816536]  [<ffffffffa02eca57>] end_workqueue_fn+0x37/0x40 [btrfs]
[  246.816548]  [<ffffffffa032664d>] normal_work_helper+0xbd/0x280 [btrfs]
[  246.816554]  [<ffffffff810abc16>] process_one_work+0x176/0x470
[  246.816560]  [<ffffffff810ac62b>] worker_thread+0x6b/0x550
[  246.816566]  [<ffffffff810ac5c0>] ? rescuer_thread+0x2e0/0x2e0
[  246.816571]  [<ffffffff810b30ea>] kthread+0xea/0x100
[  246.816577]  [<ffffffff810b3000>] ? insert_kthread_work+0x40/0x40
[  246.816583]  [<ffffffff8172297c>] ret_from_fork+0x7c/0xb0
[  246.816588]  [<ffffffff810b3000>] ? insert_kthread_work+0x40/0x40
[  246.816603] Code: 00 48 89 e5 5d 48 8b 40 c8 48 c1 e8 02 83 e0 01 c3 66 2e 0f 1f 84 00 00 00 00 00 66 66 66 66 90 48 8b 87 60 04 00 00 55 48 89 e5 <48> 8b 40 d8 5d c3 66 2e 0f 1f 84 00 00 00 00 00 66 66 66 66 90 
[  246.816608] RIP  [<ffffffff810b36f0>] kthread_data+0x10/0x20
[  246.816611]  RSP <ffff880000043958>
[  246.816613] CR2: ffffffffffffffd8
[  246.816616] ---[ end trace 8de



Chris Murphy

