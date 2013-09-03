Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from spartatux.3towers.de ([176.9.73.246]:29484 "EHLO
	spartatux.3towers.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755286Ab3ICTis (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 3 Sep 2013 15:38:48 -0400
Received: from tower.localnet (77-22-90-216-dynip.superkabel.de [77.22.90.216])
	(using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by spartatux.3towers.de (Postfix) with ESMTPSA id 724941420006
	for <linux-btrfs@vger.kernel.org>; Tue,  3 Sep 2013 21:32:50 +0200 (CEST)
From: Tim Eberhardt <tim@3towers.de>
To: linux-btrfs@vger.kernel.org
Subject: Checksum failure after interrupted defrag
Date: Tue, 03 Sep 2013 21:32:49 +0200
Message-ID: <1802981.IVOZkbogN2@tower>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello!

I started trying btrfs few days ago and formatted 4 1TB disks with -m raid1 -d raid5. Today I had a defrag job runninng when the session got killed (remembder not to run defrag over ssh). After that there where 2 broken files on the subvolume
(stale nfs file handle error message). Because of this (subvolume only contained some temp files) I tried to delete the subvolume. Then I got the following:

[19397.959804] device label datenraid devid 1 transid 2484 /dev/sdc
[19397.983519] btrfs: disk space caching is enabled
[19398.018444] btrfs: bdev /dev/sdd errs: wr 0, rd 0, flush 0, corrupt 1, gen 0
[19398.018448] btrfs: bdev /dev/sdc errs: wr 0, rd 0, flush 0, corrupt 1, gen 0
[19525.618762] csum_tree_block: 6 callbacks suppressed
[19525.618766] btrfs: sdf checksum verify failed on 326074368 wanted 53A8769 found ED8E164B level 0
[19525.658026] btrfs: sdf checksum verify failed on 326074368 wanted 53A8769 found ED8E164B level 0
[19525.675432] btrfs: sdf checksum verify failed on 326074368 wanted 53A8769 found ED8E164B level 0
[19525.675455] BTRFS error (device sdf) in btrfs_drop_snapshot:7494: errno=-5 IO failure
[19525.676802] BTRFS info (device sdf): forced readonly
[19525.676817] ------------[ cut here ]------------
[19525.677458] kernel BUG at fs/btrfs/transaction.c:1917!
[19525.677794] invalid opcode: 0000 [#1] PREEMPT SMP
[19525.677794] Modules linked in: cpufreq_ondemand snd_usb_audio snd_usbmidi_lib snd_hwdep coretemp snd_rawmidi uvcvideo videobuf2_vmalloc videobuf2_memops videobuf2_core usb_storage joydev videodev snd_seq_device kvm_intel kvm nvidia(PO) snd_hda_codec_hdmi snd_hda_codec_via microcode snd_hda_intel snd_hda_codec i2c_i801 i2c_core snd_pcm psmouse acpi_cpufreq atl1e mperf freq_table processor thermal_sys button snd_page_alloc snd_timer snd soundcore hwmon usbhid uhci_hcd ehci_pci ehci_hcd firewire_ohci firewire_core crc_itu_t usbcore usb_common vboxpci(O) vboxnetadp(O) vboxnetflt(O) vboxdrv(O)
[19525.677794] CPU: 2 PID: 3901 Comm: btrfs-cleaner Tainted: P           O 3.10.9-gentoo #3
[19525.677794] Hardware name: System manufacturer System Product Name/P5Q PRO TURBO, BIOS 0602    08/04/2009
[19525.677794] task: ffff880156589440 ti: ffff880144430000 task.ti: ffff880144430000
[19525.677794] RIP: 0010:[<ffffffff811785ce>]  [<ffffffff811785ce>] btrfs_clean_one_deleted_snapshot+0xef/0xfd
[19525.677794] RSP: 0018:ffff880144431e68  EFLAGS: 00010202
[19525.677794] RAX: 00000000fffffffb RBX: ffff880162cc1c50 RCX: 0000000000000000
[19525.677794] RDX: 0000000000000001 RSI: ffff88021fd0cd78 RDI: ffff88021fd0cd70
[19525.677794] RBP: ffff880162cc1800 R08: 0000000000000400 R09: 0000000000000000
[19525.677794] R10: 0000000000000000 R11: 0000000000000000 R12: 0000000000000001
[19525.677794] R13: ffff8802093de748 R14: 0000000000000000 R15: 0000000000000000
[19525.677794] FS:  0000000000000000(0000) GS:ffff88021fd00000(0000) knlGS:0000000000000000
[19525.677794] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[19525.677794] CR2: 00007fb470dc4d10 CR3: 000000000154c000 CR4: 00000000000407e0
[19525.677794] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[19525.677794] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[19525.677794] Stack:
[19525.677794]  ffff880144430000 ffff88006bdd4800 ffff880156589440 0000000000000000
[19525.677794]  ffff880156589440 ffffffff811710f4 0000000000000000 0000000000000000
[19525.677794]  ffff88006bdd4800 ffff88017af6fb68 ffff88006bdd4800 ffffffff81171090
[19525.677794] Call Trace:
[19525.677794]  [<ffffffff811710f4>] ? cleaner_kthread+0x64/0xee
[19525.677794]  [<ffffffff81171090>] ? transaction_kthread+0x17a/0x17a
[19525.677794]  [<ffffffff8104389c>] ? kthread+0xad/0xb5
[19525.677794]  [<ffffffff81040000>] ? init_worker_pool+0x91/0x10c
[19525.677794]  [<ffffffff810437ef>] ? __kthread_parkme+0x5d/0x5d
[19525.677794]  [<ffffffff813d762c>] ? ret_from_fork+0x7c/0xb0
[19525.677794]  [<ffffffff810437ef>] ? __kthread_parkme+0x5d/0x5d
[19525.677794] Code: d2 85 c0 7e 05 ba 01 00 00 00 31 f6 48 89 ef 41 bc 01 00 00 00 e8 71 fe fe ff 83 f8 f5 74 0e 89 c2 c1 ea 1f 74 07 83 f8 e2 74 02 <0f> 0b 5e 44 89 e0 5b 5d 41 5c 41 5d c3 90 48 8b 06 48 89 47 38
[19525.677794] RIP  [<ffffffff811785ce>] btrfs_clean_one_deleted_snapshot+0xef/0xfd
[19525.677794]  RSP <ffff880144431e68>
[19525.710179] ---[ end trace 5732088f95d8927a ]---

I'm still on 3.10.9. I can mount the fs read-only. Should I backup my stuff and recreate the fs or is repair possible? Do you need additional info?

Regards,
Tim
