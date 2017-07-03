Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qk0-f196.google.com ([209.85.220.196]:35017 "EHLO
        mail-qk0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755730AbdGCOWB (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Mon, 3 Jul 2017 10:22:01 -0400
Received: by mail-qk0-f196.google.com with SMTP id 16so24130620qkg.2
        for <linux-btrfs@vger.kernel.org>; Mon, 03 Jul 2017 07:22:00 -0700 (PDT)
Received: from [192.168.69.101] (cpe-68-174-152-193.nyc.res.rr.com. [68.174.152.193])
        by smtp.gmail.com with ESMTPSA id h17sm13588379qte.20.2017.07.03.07.21.52
        for <linux-btrfs@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 03 Jul 2017 07:21:53 -0700 (PDT)
To: linux-btrfs@vger.kernel.org
From: Asif Youssuff <yoasif@gmail.com>
Subject: kernel BUG at /home/kernel/COD/linux/fs/btrfs/extent_io.c:2328 when
 replacing disk
Message-ID: <8268b2f2-f40d-1610-f212-b0653febafc4@gmail.com>
Date: Mon, 3 Jul 2017 10:21:51 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

I'm replacing a btrfs device that was set up as a partition with one 
that is a whole disk.

The replace is getting stuck at the 53% mark with errors: kernel BUG at 
/home/kernel/COD/linux/fs/btrfs/extent_io.c:2328

More info below -- rebooting and letting replace continue seems to not 
resume. Any ideas?

I opened a ticket at: https://bugzilla.kernel.org/show_bug.cgi?id=196251 
as well.

$ uname -a
Linux ubuntu-server 4.12.0-041200rc7-generic #201706252231 SMP Mon Jun 
26 02:33:00 UTC 2017 x86_64 x86_64 x86_64 GNU/Linux

$ btrfs --version
btrfs-progs v4.4

$ sudo btrfs fi show
[sudo] password for asif:
Label: none  uuid: 48ed8a66-731d-499b-829e-dd07dd7260cc
	Total devices 14 FS bytes used 39.80TiB
	devid    0 size 7.28TiB used 7.07TiB path /dev/sdk
	devid    4 size 5.46TiB used 5.46TiB path /dev/sdd
	devid    5 size 5.46TiB used 5.43TiB path /dev/sde
	devid    7 size 5.46TiB used 5.43TiB path /dev/sdg
	devid    8 size 5.46TiB used 5.45TiB path /dev/sdi
	devid    9 size 5.46TiB used 5.45TiB path /dev/sdc
	devid   10 size 5.46TiB used 5.43TiB path /dev/sdf
	devid   11 size 7.28TiB used 7.25TiB path /dev/sdh
	devid   12 size 5.46TiB used 5.44TiB path /dev/sdn
	devid   14 size 7.28TiB used 7.25TiB path /dev/sdm
	devid   15 size 7.28TiB used 7.25TiB path /dev/sdo
	devid   17 size 5.46TiB used 5.43TiB path /dev/sdb
	devid   18 size 7.28TiB used 7.25TiB path /dev/sdl
	devid   19 size 7.28TiB used 7.07TiB path /dev/sdj2


$ sudo btrfs fi df /media/camino/
Data, RAID1: total=39.75TiB, used=39.75TiB
System, RAID1: total=43.12MiB, used=6.69MiB
Metadata, RAID1: total=54.00GiB, used=51.55GiB
GlobalReserve, single: total=512.00MiB, used=0.00B

dmesg log below:

[  584.185198] ------------[ cut here ]------------
[  584.185199] kernel BUG at 
/home/kernel/COD/linux/fs/btrfs/extent_io.c:2328!
[  584.185248] invalid opcode: 0000 [#1] SMP
[  584.185271] Modules linked in: zram binfmt_misc dm_crypt intel_rapl 
x86_pkg_temp_thermal intel_powerclamp coretemp crct10dif_pclmul 
crc32_pclmul ghash_clmulni_intel cmdlinepart pcbc intel_spi_platform 
intel_spi spi_nor mtd ipmi_ssif aesni_intel aes_x86_64 crypto_simd 
glue_helper cryptd intel_cstate intel_rapl_perf joydev input_leds mei_me 
mei intel_pch_thermal lpc_ich shpchp ie31200_edac mac_hid tpm_crb 
ipmi_si ipmi_devintf ipmi_msghandler acpi_pad kvm_intel kvm irqbypass 
autofs4 btrfs xor raid6_pq igb ast ttm drm_kms_helper syscopyarea 
sysfillrect sysimgblt fb_sys_fops hid_generic e1000e dca uas ahci usbhid 
mpt3sas ptp libahci drm usb_storage hid i2c_algo_bit raid_class pps_core 
scsi_transport_sas video
[  584.185631] CPU: 6 PID: 4663 Comm: kworker/u16:1 Not tainted 
4.12.0-041200rc7-generic #201706252231
[  584.185679] Hardware name: Supermicro X10SLM-F/X10SLM-F, BIOS 3.0 
04/24/2015
[  584.185754] Workqueue: btrfs-endio btrfs_endio_helper [btrfs]
[  584.185787] task: ffff9317333e9680 task.stack: ffffae8f8ddc8000
[  584.185847] RIP: 0010:btrfs_check_repairable+0xf2/0x100 [btrfs]
[  584.185879] RSP: 0018:ffffae8f8ddcbce8 EFLAGS: 00010282
[  584.185909] RAX: 0000000000000001 RBX: ffff93172ab7b200 RCX: 
0000000000000001
[  584.185948] RDX: 0000000000000003 RSI: 0000000000000000 RDI: 
ffff93171f9ace60
[  584.185986] RBP: ffffae8f8ddcbd08 R08: 00010f5dc7780000 R09: 
00010f5e07780000
[  584.186025] R10: 0000000000000000 R11: 00000000fffffffb R12: 
00000000f4492780
[  584.186063] R13: ffff93171f9a0000 R14: ffff9316f4492f68 R15: 
0000000000000000
[  584.186102] FS:  0000000000000000(0000) GS:ffff93175fd80000(0000) 
knlGS:0000000000000000
[  584.186145] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  584.186160] BTRFS warning (device sdb): csum failed root 5 ino 319406 
off 4265641668608 csum 0x2c6808e7 expected csum 0x00000000 mirror 0
[  584.186195] ------------[ cut here ]------------
[  584.186197] kernel BUG at 
/home/kernel/COD/linux/fs/btrfs/extent_io.c:2328!
[  584.186301] CR2: 00007fc31d49f180 CR3: 000000020c009000 CR4: 
00000000001406e0
[  584.186340] Call Trace:
[  584.186384]  end_bio_extent_readpage+0x404/0x540 [btrfs]
[  584.186388] BTRFS warning (device sdb): csum failed root 5 ino 319406 
off 4265641668608 csum 0x2c6808e7 expected csum 0x00000000 mirror 0
[  584.186414] ------------[ cut here ]------------
[  584.186416] kernel BUG at 
/home/kernel/COD/linux/fs/btrfs/extent_io.c:2328!
[  584.186553]  bio_endio+0x81/0x100
[  584.186561] BTRFS warning (device sdb): csum failed root 5 ino 319406 
off 4265641574400 csum 0x2c6808e7 expected csum 0x00000000 mirror 0
[  584.186577] BTRFS warning (device sdb): csum failed root 5 ino 319406 
off 4265641668608 csum 0x2c6808e7 expected csum 0x00000000 mirror 0
[  584.186606] ------------[ cut here ]------------
[  584.186608] kernel BUG at 
/home/kernel/COD/linux/fs/btrfs/extent_io.c:2328!
[  584.186650] ------------[ cut here ]------------
[  584.186652] kernel BUG at 
/home/kernel/COD/linux/fs/btrfs/extent_io.c:2328!
[  584.187018]  end_workqueue_fn+0x3c/0x40 [btrfs]
[  584.187095]  btrfs_scrubparity_helper+0xc8/0x2e0 [btrfs]
[  584.187099] BTRFS warning (device sdb): csum failed root 5 ino 319406 
off 4265641639936 csum 0x2c6808e7 expected csum 0x00000000 mirror 0
[  584.187107] BTRFS warning (device sdb): csum failed root 5 ino 319406 
off 4265641668608 csum 0x2c6808e7 expected csum 0x00000000 mirror 0
[  584.187127] ------------[ cut here ]------------
[  584.187129] kernel BUG at 
/home/kernel/COD/linux/fs/btrfs/extent_io.c:2328!
[  584.202157]  btrfs_endio_helper+0xe/0x10 [btrfs]
[  584.205101]  process_one_work+0x1e9/0x410
[  584.207975]  worker_thread+0x4b/0x410
[  584.210781]  kthread+0x109/0x140
[  584.213514]  ? process_one_work+0x410/0x410
[  584.216190]  ? kthread_create_on_node+0x70/0x70
[  584.218801]  ret_from_fork+0x25/0x30
[  584.221360] Code: 43 28 00 00 00 00 b9 01 00 00 00 31 c0 eb d5 8d 48 
02 eb d9 45 89 e0 48 c7 c6 a8 9b 55 c0 4c 89 ef e8 13 c0 fa ff e9 78 ff 
ff ff <0f> 0b 66 90 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 55 48
[  584.226721] RIP: btrfs_check_repairable+0xf2/0x100 [btrfs] RSP: 
ffffae8f8ddcbce8
[  584.229382] invalid opcode: 0000 [#2] SMP
[  584.229444] ---[ end trace 67ac87efec627eff ]---
[  584.311229] Modules linked in: zram binfmt_misc dm_crypt intel_rapl 
x86_pkg_temp_thermal intel_powerclamp coretemp crct10dif_pclmul 
crc32_pclmul ghash_clmulni_intel cmdlinepart pcbc intel_spi_platform 
intel_spi spi_nor mtd ipmi_ssif aesni_intel aes_x86_64 crypto_simd 
glue_helper cryptd intel_cstate intel_rapl_perf joydev input_leds mei_me 
mei intel_pch_thermal lpc_ich shpchp ie31200_edac mac_hid tpm_crb 
ipmi_si ipmi_devintf ipmi_msghandler acpi_pad kvm_intel kvm irqbypass 
autofs4 btrfs xor raid6_pq igb ast ttm drm_kms_helper syscopyarea 
sysfillrect sysimgblt fb_sys_fops hid_generic e1000e dca uas ahci usbhid 
mpt3sas ptp libahci drm usb_storage hid i2c_algo_bit raid_class pps_core 
scsi_transport_sas video
[  584.366541] CPU: 4 PID: 233 Comm: kworker/u16:6 Tainted: G      D 
     4.12.0-041200rc7-generic #201706252231
[  584.367716] Hardware name: Supermicro X10SLM-F/X10SLM-F, BIOS 3.0 
04/24/2015
[  584.368895] Workqueue: btrfs-endio btrfs_endio_helper [btrfs]
[  584.370037] task: ffff93173b78da00 task.stack: ffffae8f83e94000
[  584.371195] RIP: 0010:btrfs_check_repairable+0xf2/0x100 [btrfs]
[  584.372336] RSP: 0018:ffffae8f83e97ce8 EFLAGS: 00010286
[  584.373471] RAX: 0000000000000001 RBX: ffff93172ab7b900 RCX: 
0000000000000001
[  584.374610] RDX: 0000000000000003 RSI: 0000000000000000 RDI: 
ffff93171f9ace60
[  584.375749] RBP: ffffae8f83e97d08 R08: 00010f5dc7780000 R09: 
00010f5e07780000
[  584.376872] R10: 0000000000000000 R11: 00000000fffffffb R12: 
00000000f44928c0
[  584.377975] R13: ffff93171f9a0000 R14: ffff9316f4493468 R15: 
0000000000000000
[  584.379079] FS:  0000000000000000(0000) GS:ffff93175fd00000(0000) 
knlGS:0000000000000000
[  584.380187] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  584.381287] CR2: 00007f26d6d751e4 CR3: 000000020c009000 CR4: 
00000000001406e0
[  584.382379] Call Trace:
[  584.383452]  end_bio_extent_readpage+0x404/0x540 [btrfs]
[  584.384503]  bio_endio+0x81/0x100
[  584.385534]  end_workqueue_fn+0x3c/0x40 [btrfs]
[  584.386567]  btrfs_scrubparity_helper+0xc8/0x2e0 [btrfs]
[  584.387597]  btrfs_endio_helper+0xe/0x10 [btrfs]
[  584.388607]  process_one_work+0x1e9/0x410
[  584.389607]  worker_thread+0x4b/0x410
[  584.390595]  kthread+0x109/0x140
[  584.391577]  ? process_one_work+0x410/0x410
[  584.392540]  ? kthread_create_on_node+0x70/0x70
[  584.393479]  ret_from_fork+0x25/0x30
[  584.394390] Code: 43 28 00 00 00 00 b9 01 00 00 00 31 c0 eb d5 8d 48 
02 eb d9 45 89 e0 48 c7 c6 a8 9b 55 c0 4c 89 ef e8 13 c0 fa ff e9 78 ff 
ff ff <0f> 0b 66 90 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 55 48
[  584.396291] RIP: btrfs_check_repairable+0xf2/0x100 [btrfs] RSP: 
ffffae8f83e97ce8
[  584.397233] invalid opcode: 0000 [#3] SMP
[  584.397319] ---[ end trace 67ac87efec627f00 ]---
[  584.443803] Modules linked in: zram binfmt_misc dm_crypt intel_rapl 
x86_pkg_temp_thermal intel_powerclamp coretemp crct10dif_pclmul 
crc32_pclmul ghash_clmulni_intel cmdlinepart pcbc intel_spi_platform 
intel_spi spi_nor mtd ipmi_ssif aesni_intel aes_x86_64 crypto_simd 
glue_helper cryptd intel_cstate intel_rapl_perf joydev input_leds mei_me 
mei intel_pch_thermal lpc_ich shpchp ie31200_edac mac_hid tpm_crb 
ipmi_si ipmi_devintf ipmi_msghandler acpi_pad kvm_intel kvm irqbypass 
autofs4 btrfs xor raid6_pq igb ast ttm drm_kms_helper syscopyarea 
sysfillrect sysimgblt fb_sys_fops hid_generic e1000e dca uas ahci usbhid 
mpt3sas ptp libahci drm usb_storage hid i2c_algo_bit raid_class pps_core 
scsi_transport_sas video
[  584.532156] CPU: 1 PID: 265 Comm: kworker/u16:10 Tainted: G      D 
      4.12.0-041200rc7-generic #201706252231
[  584.532776] Hardware name: Supermicro X10SLM-F/X10SLM-F, BIOS 3.0 
04/24/2015
[  584.533414] Workqueue: btrfs-endio btrfs_endio_helper [btrfs]
[  584.534030] task: ffff93173b771680 task.stack: ffffae8f83c68000
[  584.534660] RIP: 0010:btrfs_check_repairable+0xf2/0x100 [btrfs]
[  584.535287] RSP: 0018:ffffae8f83c6bce8 EFLAGS: 00010282
[  584.535911] RAX: 0000000000000001 RBX: ffff93172ab7ba00 RCX: 
0000000000000001
[  584.536498] RDX: 0000000000000003 RSI: 0000000000000000 RDI: 
ffff93171f9ace60
[  584.537071] RBP: ffffae8f83c6bd08 R08: 00010f5dc7780000 R09: 
00010f5e07780000
[  584.537633] R10: 0000000000000000 R11: 00000000fffffffb R12: 
00000000f4493540
[  584.538183] R13: ffff93171f9a0000 R14: ffff9316f4493e68 R15: 
0000000000000000
[  584.538723] FS:  0000000000000000(0000) GS:ffff93175fc40000(0000) 
knlGS:0000000000000000
[  584.539259] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  584.539816] CR2: 00007f19d54fc2b0 CR3: 000000020c009000 CR4: 
00000000001406e0
[  584.540351] Call Trace:
[  584.540922]  end_bio_extent_readpage+0x404/0x540 [btrfs]
[  584.541460]  bio_endio+0x81/0x100
[  584.541995]  end_workqueue_fn+0x3c/0x40 [btrfs]
[  584.542534]  btrfs_scrubparity_helper+0xc8/0x2e0 [btrfs]
[  584.543072]  btrfs_endio_helper+0xe/0x10 [btrfs]
[  584.543603]  process_one_work+0x1e9/0x410
[  584.544126]  worker_thread+0x4b/0x410
[  584.544643]  kthread+0x109/0x140
[  584.545152]  ? process_one_work+0x410/0x410
[  584.545779]  ? kthread_create_on_node+0x70/0x70
[  584.546636]  ret_from_fork+0x25/0x30
[  584.547369] Code: 43 28 00 00 00 00 b9 01 00 00 00 31 c0 eb d5 8d 48 
02 eb d9 45 89 e0 48 c7 c6 a8 9b 55 c0 4c 89 ef e8 13 c0 fa ff e9 78 ff 
ff ff <0f> 0b 66 90 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 55 48
[  584.548485] RIP: btrfs_check_repairable+0xf2/0x100 [btrfs] RSP: 
ffffae8f83c6bce8
[  584.549020] invalid opcode: 0000 [#4] SMP
[  584.549035] ---[ end trace 67ac87efec627f01 ]---
[  584.591109] Modules linked in: zram binfmt_misc dm_crypt intel_rapl 
x86_pkg_temp_thermal intel_powerclamp coretemp crct10dif_pclmul 
crc32_pclmul ghash_clmulni_intel cmdlinepart pcbc intel_spi_platform 
intel_spi spi_nor mtd ipmi_ssif aesni_intel aes_x86_64 crypto_simd 
glue_helper cryptd intel_cstate intel_rapl_perf joydev input_leds mei_me 
mei intel_pch_thermal lpc_ich shpchp ie31200_edac mac_hid tpm_crb 
ipmi_si ipmi_devintf ipmi_msghandler acpi_pad kvm_intel kvm irqbypass 
autofs4 btrfs xor raid6_pq igb ast ttm drm_kms_helper syscopyarea 
sysfillrect sysimgblt fb_sys_fops hid_generic e1000e dca uas ahci usbhid 
mpt3sas ptp libahci drm usb_storage hid i2c_algo_bit raid_class pps_core 
scsi_transport_sas video
[  584.676177] CPU: 0 PID: 3759 Comm: kworker/u16:0 Tainted: G      D 
      4.12.0-041200rc7-generic #201706252231
[  584.676846] Hardware name: Supermicro X10SLM-F/X10SLM-F, BIOS 3.0 
04/24/2015
[  584.677461] Workqueue: btrfs-endio btrfs_endio_helper [btrfs]
[  584.678057] task: ffff93173382ad00 task.stack: ffffae8f8d46c000
[  584.678678] RIP: 0010:btrfs_check_repairable+0xf2/0x100 [btrfs]
[  584.679274] RSP: 0018:ffffae8f8d46fce8 EFLAGS: 00010286
[  584.679872] RAX: 0000000000000001 RBX: ffff93172ab7bcc0 RCX: 
0000000000000001
[  584.680441] RDX: 0000000000000003 RSI: 0000000000000000 RDI: 
ffff93171f9ace60
[  584.680999] RBP: ffffae8f8d46fd08 R08: 00010f5dc7780000 R09: 
00010f5e07780000
[  584.681735] R10: 0000000000000000 R11: 00000000fffffffb R12: 
00000000f4492500
[  584.682346] R13: ffff93171f9a0000 R14: ffff9316f44922e8 R15: 
0000000000000000
[  584.682872] FS:  0000000000000000(0000) GS:ffff93175fc00000(0000) 
knlGS:0000000000000000
[  584.683416] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  584.683933] CR2: 000055ae5e3d6b18 CR3: 000000020c009000 CR4: 
00000000001406f0
[  584.684467] Call Trace:
[  584.684999]  end_bio_extent_readpage+0x404/0x540 [btrfs]
[  584.685521]  bio_endio+0x81/0x100
[  584.686043]  end_workqueue_fn+0x3c/0x40 [btrfs]
[  584.686567]  btrfs_scrubparity_helper+0xc8/0x2e0 [btrfs]
[  584.687162]  btrfs_endio_helper+0xe/0x10 [btrfs]
[  584.687694]  process_one_work+0x1e9/0x410
[  584.688203]  worker_thread+0x4b/0x410
[  584.688706]  kthread+0x109/0x140
[  584.689202]  ? process_one_work+0x410/0x410
[  584.689715]  ? kthread_create_on_node+0x70/0x70
[  584.690203]  ret_from_fork+0x25/0x30
[  584.690687] Code: 43 28 00 00 00 00 b9 01 00 00 00 31 c0 eb d5 8d 48 
02 eb d9 45 89 e0 48 c7 c6 a8 9b 55 c0 4c 89 ef e8 13 c0 fa ff e9 78 ff 
ff ff <0f> 0b 66 90 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 55 48
[  584.691753] RIP: btrfs_check_repairable+0xf2/0x100 [btrfs] RSP: 
ffffae8f8d46fce8
[  584.692370] invalid opcode: 0000 [#5] SMP
[  584.692383] ---[ end trace 67ac87efec627f02 ]---
[  584.767667] Modules linked in: zram binfmt_misc dm_crypt intel_rapl 
x86_pkg_temp_thermal intel_powerclamp coretemp crct10dif_pclmul 
crc32_pclmul ghash_clmulni_intel cmdlinepart pcbc intel_spi_platform 
intel_spi spi_nor mtd ipmi_ssif aesni_intel aes_x86_64 crypto_simd 
glue_helper cryptd intel_cstate intel_rapl_perf joydev input_leds mei_me 
mei intel_pch_thermal lpc_ich shpchp ie31200_edac mac_hid tpm_crb 
ipmi_si ipmi_devintf ipmi_msghandler acpi_pad kvm_intel kvm irqbypass 
autofs4 btrfs xor raid6_pq igb ast ttm drm_kms_helper syscopyarea 
sysfillrect sysimgblt fb_sys_fops hid_generic e1000e dca uas ahci usbhid 
mpt3sas ptp libahci drm usb_storage hid i2c_algo_bit raid_class pps_core 
scsi_transport_sas video
[  585.356910] CPU: 2 PID: 230 Comm: kworker/u16:3 Tainted: G      D 
     4.12.0-041200rc7-generic #201706252231
[  585.357532] Hardware name: Supermicro X10SLM-F/X10SLM-F, BIOS 3.0 
04/24/2015
[  585.358177] Workqueue: btrfs-endio btrfs_endio_helper [btrfs]
[  585.358790] task: ffff93173379ad00 task.stack: ffffae8f83e7c000
[  585.359419] RIP: 0010:btrfs_check_repairable+0xf2/0x100 [btrfs]
[  585.360024] RSP: 0018:ffffae8f83e7fce8 EFLAGS: 00010282
[  585.360625] RAX: 0000000000000001 RBX: ffff93172ab7b700 RCX: 
0000000000000001
[  585.361195] RDX: 0000000000000003 RSI: 0000000000000000 RDI: 
ffff93171f9ace60
[  585.361752] RBP: ffffae8f83e7fd08 R08: 00010f5dc7780000 R09: 
00010f5e07780000
[  585.362314] R10: 0000000000000000 R11: 00000000fffffffb R12: 
00000000f4492140
[  585.362864] R13: ffff93171f9a0000 R14: ffff9316f4493d28 R15: 
0000000000000000
[  585.363427] FS:  0000000000000000(0000) GS:ffff93175fc80000(0000) 
knlGS:0000000000000000
[  585.363949] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  585.364465] CR2: 00007f9c936feb24 CR3: 000000020c009000 CR4: 
00000000001406e0
[  585.364986] Call Trace:
[  585.365525]  end_bio_extent_readpage+0x404/0x540 [btrfs]
[  585.366047]  bio_endio+0x81/0x100
[  585.366568]  end_workqueue_fn+0x3c/0x40 [btrfs]
[  585.367101]  btrfs_scrubparity_helper+0xc8/0x2e0 [btrfs]
[  585.367635]  ? lock_timer_base+0x81/0xa0
[  585.368177]  btrfs_endio_helper+0xe/0x10 [btrfs]
[  585.368703]  process_one_work+0x1e9/0x410
[  585.369208]  worker_thread+0x4b/0x410
[  585.369706]  kthread+0x109/0x140
[  585.370210]  ? process_one_work+0x410/0x410
[  585.370712]  ? kthread_create_on_node+0x70/0x70
[  585.371219]  ret_from_fork+0x25/0x30
[  585.371726] Code: 43 28 00 00 00 00 b9 01 00 00 00 31 c0 eb d5 8d 48 
02 eb d9 45 89 e0 48 c7 c6 a8 9b 55 c0 4c 89 ef e8 13 c0 fa ff e9 78 ff 
ff ff <0f> 0b 66 90 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 55 48
[  585.372767] RIP: btrfs_check_repairable+0xf2/0x100 [btrfs] RSP: 
ffffae8f83e7fce8
[  585.373286] invalid opcode: 0000 [#6] SMP
[  585.373308] ---[ end trace 67ac87efec627f03 ]---
[  585.374870] Modules linked in: zram binfmt_misc dm_crypt intel_rapl 
x86_pkg_temp_thermal intel_powerclamp coretemp crct10dif_pclmul 
crc32_pclmul ghash_clmulni_intel cmdlinepart pcbc intel_spi_platform 
intel_spi spi_nor mtd ipmi_ssif aesni_intel aes_x86_64 crypto_simd 
glue_helper cryptd intel_cstate intel_rapl_perf joydev input_leds mei_me 
mei intel_pch_thermal lpc_ich shpchp ie31200_edac mac_hid tpm_crb 
ipmi_si ipmi_devintf ipmi_msghandler acpi_pad kvm_intel kvm irqbypass 
autofs4 btrfs xor raid6_pq igb ast ttm drm_kms_helper syscopyarea 
sysfillrect sysimgblt fb_sys_fops hid_generic e1000e dca uas ahci usbhid 
mpt3sas ptp libahci drm usb_storage hid i2c_algo_bit raid_class pps_core 
scsi_transport_sas video
[  585.378631] CPU: 7 PID: 4664 Comm: kworker/u16:2 Tainted: G      D 
      4.12.0-041200rc7-generic #201706252231
[  585.379226] Hardware name: Supermicro X10SLM-F/X10SLM-F, BIOS 3.0 
04/24/2015
[  585.379851] Workqueue: btrfs-endio btrfs_endio_helper [btrfs]
[  585.380447] task: ffff9317333ec380 task.stack: ffffae8f8d6c4000
[  585.381044] RIP: 0010:btrfs_check_repairable+0xf2/0x100 [btrfs]
[  585.381722] RSP: 0018:ffffae8f8d6c7ce8 EFLAGS: 00010282
[  585.382333] RAX: 0000000000000001 RBX: ffff93172ab7b6c0 RCX: 
0000000000000001
[  585.382890] RDX: 0000000000000003 RSI: 0000000000000000 RDI: 
ffff93171f9ace60
[  585.383463] RBP: ffffae8f8d6c7d08 R08: 00010f5dc7780000 R09: 
00010f5e07780000
[  585.383997] R10: 0000000000000000 R11: 00000000fffffffb R12: 
00000000f3172280
[  585.384540] R13: ffff93171f9a0000 R14: ffff9316f31721a8 R15: 
0000000000000000
[  585.385042] FS:  0000000000000000(0000) GS:ffff93175fdc0000(0000) 
knlGS:0000000000000000
[  585.385545] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  585.386046] CR2: 00007fba8530cf70 CR3: 000000020c009000 CR4: 
00000000001406e0
[  585.386551] Call Trace:
[  585.387061]  end_bio_extent_readpage+0x404/0x540 [btrfs]
[  585.387752]  bio_endio+0x81/0x100
[  585.388627]  end_workqueue_fn+0x3c/0x40 [btrfs]
[  585.389504]  btrfs_scrubparity_helper+0xc8/0x2e0 [btrfs]
[  585.390381]  btrfs_endio_helper+0xe/0x10 [btrfs]
[  585.391241]  process_one_work+0x1e9/0x410
[  585.392100]  worker_thread+0x4b/0x410
[  585.392938]  kthread+0x109/0x140
[  585.393767]  ? process_one_work+0x410/0x410
[  585.394589]  ? kthread_create_on_node+0x70/0x70
[  585.395407]  ret_from_fork+0x25/0x30
[  585.396220] Code: 43 28 00 00 00 00 b9 01 00 00 00 31 c0 eb d5 8d 48 
02 eb d9 45 89 e0 48 c7 c6 a8 9b 55 c0 4c 89 ef e8 13 c0 fa ff e9 78 ff 
ff ff <0f> 0b 66 90 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 55 48
[  585.397973] RIP: btrfs_check_repairable+0xf2/0x100 [btrfs] RSP: 
ffffae8f8d6c7ce8
[  585.398931] ---[ end trace 67ac87efec627f04 ]---
[  585.401895] BTRFS warning (device sdb): csum failed root 5 ino 319406 
off 4265641668608 csum 0x2c6808e7 expected csum 0x00000000 mirror 0
[  585.401915] BTRFS warning (device sdb): csum failed root 5 ino 319406 
off 4265641668608 csum 0x2c6808e7 expected csum 0x00000000 mirror 0
[  585.402003] ------------[ cut here ]------------
[  585.402003] kernel BUG at 
/home/kernel/COD/linux/fs/btrfs/extent_io.c:2328!
[  585.402005] invalid opcode: 0000 [#7] SMP
[  585.402005] Modules linked in: zram binfmt_misc dm_crypt intel_rapl 
x86_pkg_temp_thermal intel_powerclamp coretemp crct10dif_pclmul 
crc32_pclmul ghash_clmulni_intel cmdlinepart pcbc intel_spi_platform 
intel_spi spi_nor mtd ipmi_ssif aesni_intel aes_x86_64 crypto_simd 
glue_helper cryptd intel_cstate intel_rapl_perf joydev input_leds mei_me 
mei intel_pch_thermal lpc_ich shpchp ie31200_edac mac_hid tpm_crb 
ipmi_si ipmi_devintf ipmi_msghandler acpi_pad kvm_intel kvm irqbypass 
autofs4 btrfs xor raid6_pq igb ast ttm drm_kms_helper syscopyarea 
sysfillrect sysimgblt fb_sys_fops hid_generic e1000e dca uas ahci usbhid 
mpt3sas ptp libahci drm usb_storage hid i2c_algo_bit raid_class pps_core 
scsi_transport_sas video
[  585.402025] CPU: 4 PID: 4688 Comm: kworker/u16:12 Tainted: G      D 
       4.12.0-041200rc7-generic #201706252231
[  585.402025] Hardware name: Supermicro X10SLM-F/X10SLM-F, BIOS 3.0 
04/24/2015
[  585.402041] Workqueue: btrfs-endio btrfs_endio_helper [btrfs]
[  585.402042] task: ffff9317328e1680 task.stack: ffffae8f8e030000
[  585.402057] RIP: 0010:btrfs_check_repairable+0xf2/0x100 [btrfs]
[  585.402057] RSP: 0018:ffffae8f8e033ce8 EFLAGS: 00010282
[  585.402058] RAX: 0000000000000001 RBX: ffff93172ab7b000 RCX: 
0000000000000001
[  585.402059] RDX: 0000000000000003 RSI: 0000000000000000 RDI: 
ffff93171f9ace60
[  585.402060] RBP: ffffae8f8e033d08 R08: 00010f5dc7780000 R09: 
00010f5e07780000
[  585.402060] R10: 0000000000000000 R11: 00000000fffffffb R12: 
00000000f3173040
[  585.402061] R13: ffff93171f9a0000 R14: ffff9316f3172428 R15: 
0000000000000000
[  585.402062] FS:  0000000000000000(0000) GS:ffff93175fd00000(0000) 
knlGS:0000000000000000
[  585.402062] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  585.402063] CR2: 0000561458209000 CR3: 000000020c009000 CR4: 
00000000001406e0
[  585.402064] Call Trace:
[  585.402077]  end_bio_extent_readpage+0x404/0x540 [btrfs]
[  585.402080]  bio_endio+0x81/0x100
[  585.402092]  end_workqueue_fn+0x3c/0x40 [btrfs]
[  585.402105]  btrfs_scrubparity_helper+0xc8/0x2e0 [btrfs]
[  585.402117]  btrfs_endio_helper+0xe/0x10 [btrfs]
[  585.402119]  process_one_work+0x1e9/0x410
[  585.402120]  worker_thread+0x4b/0x410
[  585.402122]  kthread+0x109/0x140
[  585.402123]  ? process_one_work+0x410/0x410
[  585.402124]  ? kthread_create_on_node+0x70/0x70
[  585.402126]  ret_from_fork+0x25/0x30
[  585.402126] Code: 43 28 00 00 00 00 b9 01 00 00 00 31 c0 eb d5 8d 48 
02 eb d9 45 89 e0 48 c7 c6 a8 9b 55 c0 4c 89 ef e8 13 c0 fa ff e9 78 ff 
ff ff <0f> 0b 66 90 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 55 48
[  585.402158] RIP: btrfs_check_repairable+0xf2/0x100 [btrfs] RSP: 
ffffae8f8e033ce8
[  585.402159] ---[ end trace 67ac87efec627f05 ]---
[  585.429064] ------------[ cut here ]------------
[  585.429617] kernel BUG at 
/home/kernel/COD/linux/fs/btrfs/extent_io.c:2328!
[  585.430177] invalid opcode: 0000 [#8] SMP
[  585.430712] Modules linked in: zram binfmt_misc dm_crypt intel_rapl 
x86_pkg_temp_thermal intel_powerclamp coretemp crct10dif_pclmul 
crc32_pclmul ghash_clmulni_intel cmdlinepart pcbc intel_spi_platform 
intel_spi spi_nor mtd ipmi_ssif aesni_intel aes_x86_64 crypto_simd 
glue_helper cryptd intel_cstate intel_rapl_perf joydev input_leds mei_me 
mei intel_pch_thermal lpc_ich shpchp ie31200_edac mac_hid tpm_crb 
ipmi_si ipmi_devintf ipmi_msghandler acpi_pad kvm_intel kvm irqbypass 
autofs4 btrfs xor raid6_pq igb ast ttm drm_kms_helper syscopyarea 
sysfillrect sysimgblt fb_sys_fops hid_generic e1000e dca uas ahci usbhid 
mpt3sas ptp libahci drm usb_storage hid i2c_algo_bit raid_class pps_core 
scsi_transport_sas video
[  585.434204] CPU: 0 PID: 4687 Comm: kworker/u16:9 Tainted: G      D 
      4.12.0-041200rc7-generic #201706252231
[  585.434816] Hardware name: Supermicro X10SLM-F/X10SLM-F, BIOS 3.0 
04/24/2015
[  585.435443] Workqueue: btrfs-endio btrfs_endio_helper [btrfs]
[  585.436008] task: ffff9317328e0000 task.stack: ffffae8f8e028000
[  585.436625] RIP: 0010:btrfs_check_repairable+0xf2/0x100 [btrfs]
[  585.437259] RSP: 0018:ffffae8f8e02bce8 EFLAGS: 00010282
[  585.437876] RAX: 0000000000000001 RBX: ffff93172ab7bbc0 RCX: 
0000000000000001
[  585.438527] RDX: 0000000000000003 RSI: 0000000000000000 RDI: 
ffff93171f9ace60
[  585.439082] RBP: ffffae8f8e02bd08 R08: 00010f5dc7780000 R09: 
00010f5e07780000
[  585.439656] R10: 0000000000000000 R11: 00000000fffffffb R12: 
00000000f5236c80
[  585.440220] R13: ffff93171f9a0000 R14: ffff9316f5237aa8 R15: 
0000000000000000
[  585.440759] FS:  0000000000000000(0000) GS:ffff93175fc00000(0000) 
knlGS:0000000000000000
[  585.441288] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  585.441806] CR2: 000055ae5e3d6b18 CR3: 000000020c009000 CR4: 
00000000001406f0
[  585.442309] Call Trace:
[  585.442834]  end_bio_extent_readpage+0x404/0x540 [btrfs]
[  585.443463]  bio_endio+0x81/0x100
[  585.443993]  end_workqueue_fn+0x3c/0x40 [btrfs]
[  585.444546]  btrfs_scrubparity_helper+0xc8/0x2e0 [btrfs]
[  585.445097]  btrfs_endio_helper+0xe/0x10 [btrfs]
[  585.445592]  process_one_work+0x1e9/0x410
[  585.446081]  worker_thread+0x4b/0x410
[  585.446566]  kthread+0x109/0x140
[  585.447043]  ? process_one_work+0x410/0x410
[  585.447604]  ? kthread_create_on_node+0x70/0x70
[  585.448105]  ret_from_fork+0x25/0x30
[  585.448624] Code: 43 28 00 00 00 00 b9 01 00 00 00 31 c0 eb d5 8d 48 
02 eb d9 45 89 e0 48 c7 c6 a8 9b 55 c0 4c 89 ef e8 13 c0 fa ff e9 78 ff 
ff ff <0f> 0b 66 90 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 55 48
[  585.449721] RIP: btrfs_check_repairable+0xf2/0x100 [btrfs] RSP: 
ffffae8f8e02bce8
[  585.450268] ---[ end trace 67ac87efec627f06 ]---
