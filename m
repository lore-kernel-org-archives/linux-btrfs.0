Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:42167 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751263AbbJVXNg (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 22 Oct 2015 19:13:36 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
	id 1ZpP30-000082-EQ
	for linux-btrfs@vger.kernel.org; Fri, 23 Oct 2015 01:13:26 +0200
Received: from 51.174.117.4 ([51.174.117.4])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Fri, 23 Oct 2015 01:13:26 +0200
Received: from btrfs by 51.174.117.4 with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Fri, 23 Oct 2015 01:13:26 +0200
To: linux-btrfs@vger.kernel.org
From: Erik Berg <btrfs@slipsprogrammoer.no>
Subject: Crash during mount -o degraded, kernel BUG at
 fs/btrfs/extent_io.c:2044
Date: Fri, 23 Oct 2015 01:13:15 +0200
Message-ID: <n0bqib$2om$1@ger.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi again,

So I intentionally broke this small raid6 fs on a VM to learn recovery 
strategies for another much bigger raid6 I have running (which also 
suffered a drive failure).

Basically I zeroed out one of the drives (vdd) from under the running 
vm. Then ran an md5sum on a file on the fs to trigger some detection of 
data inconsistency. I ran a scrub, which completed "ok". Then rebooted.

Now trying to mount the filesystem in degraded mode leads to a kernel crash.

I'm using kernel 4.3-rc6 and btrfs-progs 4.2.3

Linux ubuntu 4.3.0-040300rc6-generic #201510182030 SMP Mon Oct 19 
00:31:41 UTC 2015 x86_64 x86_64 x86_64 GNU/Linux

Label: none  uuid: aee28657-3ce0-4efc-9cd3-cc7c58782af3
	Total devices 1 FS bytes used 1.87GiB
	devid    1 size 9.52GiB used 2.89GiB path /dev/vda2

warning devid 3 not found already
Label: 'boxofkittens'  uuid: 4957afbe-e2cb-410c-8d45-3850840898f2
	Total devices 9 FS bytes used 3.56GiB
	devid    1 size 1022.00MiB used 716.19MiB path /dev/vdb1
	devid    2 size 1022.00MiB used 716.19MiB path /dev/vdc1
	devid    4 size 1022.00MiB used 716.19MiB path /dev/vde1
	devid    5 size 1022.00MiB used 716.19MiB path /dev/vdf1
	devid    6 size 1022.00MiB used 716.19MiB path /dev/vdg1
	devid    7 size 2.00GiB used 1.70GiB path /dev/vdh1
	devid    8 size 3.00GiB used 1.70GiB path /dev/vdi1
	devid    9 size 3.00GiB used 1.70GiB path /dev/vdj1
	*** Some devices missing

btrfs-progs v4.2.3

mount -o degraded /dev/vdb1 /mnt/boxofkittens

[   36.426731] ------------[ cut here ]------------
[   36.427547] kernel BUG at 
/home/kernel/COD/linux/fs/btrfs/extent_io.c:2044!
[   36.428686] invalid opcode: 0000 [#1] SMP
[   36.429438] Modules linked in: snd_hda_codec_generic iosf_mbi 
crct10dif_pclmul crc32_pclmul ppdev aesni_intel aes_x86_64 lrw gf128mul 
glue_helper ablk_helper cryptd input_leds joydev snd_hda_intel serio_raw 
snd_hda_codec snd_hda_core snd_hwdep snd_pcm snd_timer snd soundcore 
i2c_piix4 parport_pc parport 8250_fintek mac_hid autofs4 btrfs xor 
raid6_pq cirrus ttm psmouse drm_kms_helper syscopyarea sysfillrect 
sysimgblt fb_sys_fops drm floppy pata_acpi
[   36.436782] CPU: 0 PID: 86 Comm: kworker/u2:2 Not tainted 
4.3.0-040300rc6-generic #201510182030
[   36.438138] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), 
BIOS 1.8.1-20150318_183358- 04/01/2014
[   36.439648] Workqueue: btrfs-endio btrfs_endio_helper [btrfs]
[   36.440617] task: ffff880035b4e200 ti: ffff880035564000 task.ti: 
ffff880035564000
[   36.441778] RIP: 0010:[<ffffffffc0169d39>]  [<ffffffffc0169d39>] 
repair_io_failure+0x1a9/0x1f0 [btrfs]
[   36.443287] RSP: 0018:ffff880035567c20  EFLAGS: 00010246
[   36.444128] RAX: ffff88003c7ad000 RBX: ffff8800363dc7d0 RCX: 
0000000000000000
[   36.445227] RDX: 0000000000001000 RSI: 0000000000027000 RDI: 
ffff8800388ce100
[   36.446315] RBP: ffff880035567c78 R08: ffffea0000ddb640 R09: 
0000000000000000
[   36.447397] R10: ffff8800363dc980 R11: ffff88003bd49b00 R12: 
0000000000027000
[   36.448479] R13: ffff8800388ce000 R14: ffff8800363dc980 R15: 
ffff8800363dc838
[   36.449553] FS:  0000000000000000(0000) GS:ffff88003fc00000(0000) 
knlGS:0000000000000000
[   36.450766] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   36.451641] CR2: 0000000002015008 CR3: 000000003c1be000 CR4: 
00000000000406f0
[   36.452709] Stack:
[   36.453026]  0000000000027000 0000000035567c48 ffffea0000ddb640 
00000002b1047000
[   36.454211]  0000000000000000 0000000000000000 ffff8800363dc7d0 
0000000000027000
[   36.455513]  ffff8800388ce000 ffff8800363dc980 ffff8800363dc838 
ffff880035567ce8
[   36.456663] Call Trace:
[   36.457043]  [<ffffffffc0169fed>] clean_io_failure+0x18d/0x1a0 [btrfs]
[   36.458002]  [<ffffffffc016a3ea>] end_bio_extent_readpage+0x30a/0x560 
[btrfs]
[   36.459662]  [<ffffffffc016a0e0>] ? btrfs_create_repair_bio+0xe0/0xe0 
[btrfs]
[   36.460715]  [<ffffffff81371f40>] bio_endio+0x40/0x60
[   36.461459]  [<ffffffffc013fbbc>] end_workqueue_fn+0x3c/0x40 [btrfs]
[   36.462387]  [<ffffffffc0178ff0>] normal_work_helper+0xc0/0x270 [btrfs]
[   36.463360]  [<ffffffffc0179272>] btrfs_endio_helper+0x12/0x20 [btrfs]
[   36.464314]  [<ffffffff8109251e>] process_one_work+0x14e/0x3d0
[   36.465158]  [<ffffffff81092bca>] worker_thread+0x11a/0x470
[   36.466264]  [<ffffffff81092ab0>] ? rescuer_thread+0x310/0x310
[   36.467154]  [<ffffffff81098319>] kthread+0xc9/0xe0
[   36.467863]  [<ffffffff81098250>] ? kthread_park+0x60/0x60
[   36.468791]  [<ffffffff817b3fcf>] ret_from_fork+0x3f/0x70
[   36.470022]  [<ffffffff81098250>] ? kthread_park+0x60/0x60
[   36.471334] Code: fe ff ff 48 89 df 41 bf fb ff ff ff e8 21 70 20 c1 
31 f6 4c 89 ef e8 07 eb 00 00 e9 d1 fe ff ff 41 bf fb ff ff ff e9 c6 fe 
ff ff <0f> 0b 0f 0b 49 8b 4d 30 49 8b b6 58 fe ff ff 48 83 c1 10 48 85
[   36.475278] RIP  [<ffffffffc0169d39>] repair_io_failure+0x1a9/0x1f0 
[btrfs]
[   36.476256]  RSP <ffff880035567c20>
[   36.476783] ---[ end trace a06ea60748bbedae ]---
[   36.481369] BUG: unable to handle kernel paging request at 
ffffffffffffffd8
[   36.484441] IP: [<ffffffff81098a90>] kthread_data+0x10/0x20
[   36.486710] PGD 1c13067 PUD 1c15067 PMD 0
[   36.488690] Oops: 0000 [#2] SMP
[   36.490516] Modules linked in: snd_hda_codec_generic iosf_mbi 
crct10dif_pclmul crc32_pclmul ppdev aesni_intel aes_x86_64 lrw gf128mul 
glue_helper ablk_helper cryptd input_leds joydev snd_hda_intel serio_raw 
snd_hda_codec snd_hda_core snd_hwdep snd_pcm snd_timer snd soundcore 
i2c_piix4 parport_pc parport 8250_fintek mac_hid autofs4 btrfs xor 
raid6_pq cirrus ttm psmouse drm_kms_helper syscopyarea sysfillrect 
sysimgblt fb_sys_fops drm floppy pata_acpi
[   36.503559] CPU: 0 PID: 86 Comm: kworker/u2:2 Tainted: G      D 
    4.3.0-040300rc6-generic #201510182030
[   36.507074] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), 
BIOS 1.8.1-20150318_183358- 04/01/2014
[   36.510483] task: ffff880035b4e200 ti: ffff880035564000 task.ti: 
ffff880035564000
[   36.513383] RIP: 0010:[<ffffffff81098a90>]  [<ffffffff81098a90>] 
kthread_data+0x10/0x20
[   36.516544] RSP: 0018:ffff880035567918  EFLAGS: 00010002
[   36.519266] RAX: 0000000000000000 RBX: 0000000000000000 RCX: 
0000000000000000
[   36.522101] RDX: ffff88003e002090 RSI: 0000000000000000 RDI: 
ffff880035b4e200
[   36.524889] RBP: ffff880035567918 R08: 000000087e7534f3 R09: 
ffff88003fc1b3b0
[   36.527653] R10: ffffffff8137d322 R11: 0000000000000000 R12: 
ffff880035b4e200
[   36.531102] R13: 0000000000016980 R14: 0000000000000000 R15: 
0000000000000000
[   36.533401] FS:  0000000000000000(0000) GS:ffff88003fc00000(0000) 
knlGS:0000000000000000
[   36.535451] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   36.538332] CR2: 0000000000000028 CR3: 000000003dbd0000 CR4: 
00000000000406f0
[   36.540780] Stack:
[   36.542302]  ffff880035567930 ffffffff810933f1 ffff88003fc16980 
ffff880035567978
[   36.544435]  ffffffff817b0154 ffff880035567970 ffff880035b4e200 
ffff880035568000
[   36.546827]  ffff880035b4e648 0000000000000246 ffff880035b4e200 
ffff88003e2e8000
[   36.548918] Call Trace:
[   36.550402]  [<ffffffff810933f1>] wq_worker_sleeping+0x11/0x90
[   36.552397]  [<ffffffff817b0154>] __schedule+0x674/0x920
[   36.554194]  [<ffffffff817b0433>] schedule+0x33/0x80
[   36.555970]  [<ffffffff8107d35b>] do_exit+0x67b/0xaf0
[   36.557724]  [<ffffffff81019cf1>] oops_end+0xa1/0xd0
[   36.559459]  [<ffffffff8101a1fb>] die+0x4b/0x70
[   36.561117]  [<ffffffff810171cd>] do_trap+0x13d/0x150
[   36.562875]  [<ffffffff81017767>] do_error_trap+0x77/0xe0
[   36.564992]  [<ffffffffc0169d39>] ? repair_io_failure+0x1a9/0x1f0 [btrfs]
[   36.567131]  [<ffffffff811d02e9>] ? __slab_free+0x59/0x280
[   36.568919]  [<ffffffff81371f40>] ? bio_endio+0x40/0x60
[   36.570720]  [<ffffffff81017a40>] do_invalid_op+0x20/0x30
[   36.573180]  [<ffffffff817b574e>] invalid_op+0x1e/0x30
[   36.575082]  [<ffffffffc0169d39>] ? repair_io_failure+0x1a9/0x1f0 [btrfs]
[   36.577043]  [<ffffffffc0169fed>] clean_io_failure+0x18d/0x1a0 [btrfs]
[   36.578948]  [<ffffffffc016a3ea>] end_bio_extent_readpage+0x30a/0x560 
[btrfs]
[   36.580921]  [<ffffffffc016a0e0>] ? btrfs_create_repair_bio+0xe0/0xe0 
[btrfs]
[   36.582870]  [<ffffffff81371f40>] bio_endio+0x40/0x60
[   36.584589]  [<ffffffffc013fbbc>] end_workqueue_fn+0x3c/0x40 [btrfs]
[   36.586553]  [<ffffffffc0178ff0>] normal_work_helper+0xc0/0x270 [btrfs]
[   36.588404]  [<ffffffffc0179272>] btrfs_endio_helper+0x12/0x20 [btrfs]
[   36.590237]  [<ffffffff8109251e>] process_one_work+0x14e/0x3d0
[   36.591996]  [<ffffffff81092bca>] worker_thread+0x11a/0x470
[   36.593727]  [<ffffffff81092ab0>] ? rescuer_thread+0x310/0x310
[   36.595663]  [<ffffffff81098319>] kthread+0xc9/0xe0
[   36.597613]  [<ffffffff81098250>] ? kthread_park+0x60/0x60
[   36.599431]  [<ffffffff817b3fcf>] ret_from_fork+0x3f/0x70
[   36.601067]  [<ffffffff81098250>] ? kthread_park+0x60/0x60
[   36.602667] Code: ba 01 00 00 00 75 c1 48 8b 43 08 eb 9b 48 89 df e8 
b6 f8 ff ff eb af 0f 1f 40 00 66 66 66 66 90 55 48 8b 87 f8 04 00 00 48 
89 e5 <48> 8b 40 d8 5d c3 66 2e 0f 1f 84 00 00 00 00 00 66 66 66 66 90
[   36.607519] RIP  [<ffffffff81098a90>] kthread_data+0x10/0x20
[   36.609104]  RSP <ffff880035567918>
[   36.610810] CR2: ffffffffffffffd8
[   36.612460] ---[ end trace a06ea60748bbedaf ]---
[   36.614385] Fixing recursive fault but reboot is needed!


