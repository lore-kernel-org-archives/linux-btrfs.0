Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qt0-f179.google.com ([209.85.216.179]:36672 "EHLO
        mail-qt0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753387AbdGCPuk (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Mon, 3 Jul 2017 11:50:40 -0400
Received: by mail-qt0-f179.google.com with SMTP id i2so146455605qta.3
        for <linux-btrfs@vger.kernel.org>; Mon, 03 Jul 2017 08:50:39 -0700 (PDT)
Received: from [192.168.69.101] (cpe-68-174-152-193.nyc.res.rr.com. [68.174.152.193])
        by smtp.gmail.com with ESMTPSA id s6sm12221013qki.44.2017.07.03.08.50.36
        for <linux-btrfs@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 03 Jul 2017 08:50:37 -0700 (PDT)
Subject: Re: kernel BUG at /home/kernel/COD/linux/fs/btrfs/extent_io.c:2328
 when replacing disk
From: Asif Youssuff <yoasif@gmail.com>
To: linux-btrfs@vger.kernel.org
References: <8268b2f2-f40d-1610-f212-b0653febafc4@gmail.com>
Message-ID: <c47cfdcb-4f0b-cc0d-2e79-afa843721955@gmail.com>
Date: Mon, 3 Jul 2017 11:50:35 -0400
MIME-Version: 1.0
In-Reply-To: <8268b2f2-f40d-1610-f212-b0653febafc4@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,
I upgraded to 4.12 (instead of the rc) and the problem continues:

# uname -a
Linux ubuntu-server 4.12.0-041200rc7-generic #201706252231 SMP Mon Jun 
26 02:33:00 UTC 2017 x86_64 x86_64 x86_64 GNU/Linux

$ btrfs --version
btrfs-progs v4.4

# btrfs fi show
Label: none  uuid: 48ed8a66-731d-499b-829e-dd07dd7260cc
	Total devices 14 FS bytes used 39.80TiB
	devid    0 size 7.28TiB used 7.07TiB path /dev/sdk
	devid    4 size 5.46TiB used 5.46TiB path /dev/sdb
	devid    5 size 5.46TiB used 5.43TiB path /dev/sdc
	devid    7 size 5.46TiB used 5.43TiB path /dev/sde
	devid    8 size 5.46TiB used 5.45TiB path /dev/sdf
	devid    9 size 5.46TiB used 5.45TiB path /dev/sda
	devid   10 size 5.46TiB used 5.43TiB path /dev/sdd
	devid   11 size 7.28TiB used 7.25TiB path /dev/sdg
	devid   12 size 5.46TiB used 5.44TiB path /dev/sdn
	devid   14 size 7.28TiB used 7.25TiB path /dev/sdm
	devid   15 size 7.28TiB used 7.25TiB path /dev/sdo
	devid   17 size 5.46TiB used 5.43TiB path /dev/sdj
	devid   18 size 7.28TiB used 7.25TiB path /dev/sdl
	devid   19 size 7.28TiB used 7.07TiB path /dev/sdh2


# btrfs fi df /media/camino/
Data, RAID1: total=39.75TiB, used=39.75TiB
System, RAID1: total=43.12MiB, used=6.69MiB
Metadata, RAID1: total=54.00GiB, used=51.55GiB
GlobalReserve, single: total=512.00MiB, used=0.00B

dmesg log:

[  419.531939] ------------[ cut here ]------------
[  419.531941] kernel BUG at 
/home/kernel/COD/linux/fs/btrfs/extent_io.c:2328!
[  419.531946] invalid opcode: 0000 [#1] SMP
[  419.531949] Modules linked in: zram binfmt_misc dm_crypt intel_rapl 
x86_pkg_temp_thermal cmdlinepart intel_spi_platform intel_spi spi_nor 
mtd intel_powerclamp coretemp crct10dif_pclmul crc32_pclmul 
ghash_clmulni_intel pcbc aesni_intel aes_x86_64 crypto_simd joydev 
glue_helper input_leds cryptd intel_cstate kvm_intel kvm irqbypass 
intel_rapl_perf ipmi_ssif shpchp tpm_crb mei_me mei lpc_ich ie31200_edac 
intel_pch_thermal mac_hid ipmi_si ipmi_devintf ipmi_msghandler acpi_pad 
autofs4 btrfs xor raid6_pq hid_generic usbhid hid uas usb_storage ast 
ttm drm_kms_helper syscopyarea sysfillrect sysimgblt fb_sys_fops igb 
e1000e drm mpt3sas dca ahci libahci ptp i2c_algo_bit raid_class pps_core 
scsi_transport_sas video
[  419.532010] CPU: 4 PID: 228 Comm: kworker/u16:2 Not tainted 
4.12.0-041200rc7-generic #201706252231
[  419.532012] Hardware name: Supermicro X10SLM-F/X10SLM-F, BIOS 3.0 
04/24/2015
[  419.532081] Workqueue: btrfs-endio btrfs_endio_helper [btrfs]
[  419.532086] task: ffff97063b482d00 task.stack: ffffaa9d03884000
[  419.532137] RIP: 0010:btrfs_check_repairable+0xf2/0x100 [btrfs]
[  419.532140] RSP: 0018:ffffaa9d03887ce8 EFLAGS: 00010283
[  419.532143] RAX: 0000000000000001 RBX: ffff970629c69500 RCX: 
0000000000000001
[  419.532145] RDX: 0000000000000003 RSI: 0000000000000000 RDI: 
ffff970622a7ce60
[  419.532146] RBP: ffffaa9d03887d08 R08: 00010f5dc7780000 R09: 
00010f5e07780000
[  419.532148] R10: 0000000000000000 R11: 00000000fffffffb R12: 
00000000f3169540
[  419.532150] R13: ffff970622a70000 R14: ffff9705f3168ce8 R15: 
0000000000000000
[  419.532152] FS:  0000000000000000(0000) GS:ffff97065fd00000(0000) 
knlGS:0000000000000000
[  419.532154] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  419.532156] CR2: 00007fc520ff51e4 CR3: 00000006a2809000 CR4: 
00000000001406e0
[  419.532158] Call Trace:
[  419.532203]  end_bio_extent_readpage+0x404/0x540 [btrfs]
[  419.532212]  bio_endio+0x81/0x100
[  419.532250]  end_workqueue_fn+0x3c/0x40 [btrfs]
[  419.532299]  btrfs_scrubparity_helper+0xc8/0x2e0 [btrfs]
[  419.532349]  btrfs_endio_helper+0xe/0x10 [btrfs]
[  419.532354]  process_one_work+0x1e9/0x410
[  419.532358]  worker_thread+0x4b/0x410
[  419.532364]  kthread+0x109/0x140
[  419.532368]  ? process_one_work+0x410/0x410
[  419.532373]  ? kthread_create_on_node+0x70/0x70
[  419.532378]  ? kthread_create_on_node+0x70/0x70
[  419.532382]  ret_from_fork+0x25/0x30
[  419.532385] Code: 43 28 00 00 00 00 b9 01 00 00 00 31 c0 eb d5 8d 48 
02 eb d9 45 89 e0 48 c7 c6 a8 2b 68 c0 4c 89 ef e8 13 c0 fa ff e9 78 ff 
ff ff <0f> 0b 66 90 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 55 48
[  419.532480] RIP: btrfs_check_repairable+0xf2/0x100 [btrfs] RSP: 
ffffaa9d03887ce8
[  419.532484] ---[ end trace 34db1c353c64ec3d ]---
[  419.665857] BTRFS critical (device sdb): stripe index math went 
horribly wrong, got stripe_index=4121628095, num_stripes=2
[  419.666457] BTRFS critical (device sdb): stripe index math went 
horribly wrong, got stripe_index=4121628095, num_stripes=2
[  419.666989] BTRFS warning (device sdb): csum failed root 5 ino 319406 
off 298371032416256 csum 0xf972d334 expected csum 0x00000000 mirror 
-173339200
[  419.666994] BTRFS critical (device sdb): stripe index math went 
horribly wrong, got stripe_index=4121628095, num_stripes=2
[  419.667024] BTRFS critical (device sdb): stripe index math went 
horribly wrong, got stripe_index=4121628095, num_stripes=2
[  419.667036] BTRFS critical (device sdb): stripe index math went 
horribly wrong, got stripe_index=4121628095, num_stripes=2
[  419.667041] BTRFS warning (device sdb): csum failed root 5 ino 319406 
off 298371032416256 csum 0xac105d1a expected csum 0x00000000 mirror 
-173339200
[  419.667046] BTRFS critical (device sdb): stripe index math went 
horribly wrong, got stripe_index=4121628095, num_stripes=2
[  419.667066] ------------[ cut here ]------------
[  419.667066] kernel BUG at 
/home/kernel/COD/linux/fs/btrfs/extent_io.c:2328!
[  419.667068] invalid opcode: 0000 [#2] SMP
[  419.667068] Modules linked in: zram binfmt_misc dm_crypt intel_rapl 
x86_pkg_temp_thermal cmdlinepart intel_spi_platform intel_spi spi_nor 
mtd intel_powerclamp coretemp crct10dif_pclmul crc32_pclmul 
ghash_clmulni_intel pcbc aesni_intel aes_x86_64 crypto_simd joydev
[  419.667075] BTRFS critical (device sdb): stripe index math went 
horribly wrong, got stripe_index=4121628095, num_stripes=2
[  419.667076]  glue_helper input_leds cryptd intel_cstate kvm_intel kvm 
irqbypass intel_rapl_perf ipmi_ssif shpchp tpm_crb mei_me mei lpc_ich 
ie31200_edac intel_pch_thermal mac_hid ipmi_si ipmi_devintf 
ipmi_msghandler acpi_pad autofs4 btrfs xor raid6_pq hid_generic usbhid 
hid uas usb_storage ast ttm drm_kms_helper syscopyarea sysfillrect 
sysimgblt fb_sys_fops igb e1000e drm mpt3sas dca ahci libahci ptp 
i2c_algo_bit
[  419.667090] BTRFS critical (device sdb): stripe index math went 
horribly wrong, got stripe_index=4121628095, num_stripes=2
[  419.667090]  raid_class pps_core scsi_transport_sas video
[  419.667093] CPU: 5 PID: 230 Comm: kworker/u16:4 Tainted: G      D 
     4.12.0-041200rc7-generic #201706252231
[  419.667094] Hardware name: Supermicro X10SLM-F/X10SLM-F, BIOS 3.0 
04/24/2015
[  419.667096] BTRFS warning (device sdb): csum failed root 5 ino 319406 
off 298371032416256 csum 0xa4cc695f expected csum 0x00000000 mirror 
-173339200
[  419.667117] Workqueue: btrfs-endio btrfs_endio_helper [btrfs]
[  419.667118] BTRFS critical (device sdb): stripe index math went 
horribly wrong, got stripe_index=4121628095, num_stripes=2
[  419.667118] ------------[ cut here ]------------
[  419.667119] kernel BUG at 
/home/kernel/COD/linux/fs/btrfs/extent_io.c:2328!
[  419.667120] task: ffff970631960000 task.stack: ffffaa9d03d84000
[  419.667135] RIP: 0010:btrfs_check_repairable+0xf2/0x100 [btrfs]
[  419.667136] RSP: 0018:ffffaa9d03d87ce8 EFLAGS: 00010287
[  419.667137] RAX: 0000000000000001 RBX: ffff970624cc5e80 RCX: 
0000000000000001
[  419.667138] RDX: 0000000000000003 RSI: 0000000000000000 RDI: 
ffff970622a7ce60
[  419.667139] RBP: ffffaa9d03d87d08 R08: 00010f5dc7780000 R09: 
00010f5e07780000
[  419.667139] R10: 0000000000000000 R11: 00000000fffffffb R12: 
00000000f2567680
[  419.667140] R13: ffff970622a70000 R14: ffff9705f2567468 R15: 
0000000000000000
[  419.667141] FS:  0000000000000000(0000) GS:ffff97065fd40000(0000) 
knlGS:0000000000000000
[  419.667142] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  419.667142] CR2: 00007f197d104570 CR3: 00000007eaffd000 CR4: 
00000000001406e0
[  419.667143] Call Trace:
[  419.667156]  end_bio_extent_readpage+0x404/0x540 [btrfs]
[  419.667157] BTRFS critical (device sdb): stripe index math went 
horribly wrong, got stripe_index=4121628095, num_stripes=2
[  419.667160]  bio_endio+0x81/0x100
[  419.667173]  end_workqueue_fn+0x3c/0x40 [btrfs]
[  419.667174] BTRFS critical (device sdb): stripe index math went 
horribly wrong, got stripe_index=4121628095, num_stripes=2
[  419.667187]  btrfs_scrubparity_helper+0xc8/0x2e0 [btrfs]
[  419.667189] BTRFS warning (device sdb): csum failed root 5 ino 319406 
off 298371032416256 csum 0x62d9e753 expected csum 0x00000000 mirror 
-173339200
[  419.667190] BTRFS critical (device sdb): stripe index math went 
horribly wrong, got stripe_index=4121628095, num_stripes=2
[  419.667203]  btrfs_endio_helper+0xe/0x10 [btrfs]
[  419.667205]  process_one_work+0x1e9/0x410
[  419.667206]  worker_thread+0x4b/0x410
[  419.667208]  kthread+0x109/0x140
[  419.667209]  ? process_one_work+0x410/0x410
[  419.667210] ------------[ cut here ]------------
[  419.667211]  ? kthread_create_on_node+0x70/0x70
[  419.667212] kernel BUG at 
/home/kernel/COD/linux/fs/btrfs/extent_io.c:2328!
[  419.667213]  ret_from_fork+0x25/0x30
[  419.667214] Code: 43 28 00 00 00 00 b9 01 00 00 00 31 c0 eb d5 8d 48 
02 eb
[  419.667221] BTRFS critical (device sdb): stripe index math went 
horribly wrong, got stripe_index=4121628095, num_stripes=2
[  419.667221] d9 45 89 e0 48 c7 c6 a8 2b 68 c0 4c 89 ef e8 13 c0 fa ff 
e9 78 ff ff ff <0f> 0b 66 90 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 
00 55 48
[  419.667256] RIP: btrfs_check_repairable+0xf2/0x100 [btrfs] RSP: 
ffffaa9d03d87ce8
[  419.667257] BTRFS critical (device sdb): stripe index math went 
horribly wrong, got stripe_index=4121628095, num_stripes=2
[  419.667257] ---[ end trace 34db1c353c64ec3e ]---
[  419.667258] invalid opcode: 0000 [#3] SMP
[  419.667259] Modules linked in: zram
[  419.667706] BTRFS warning (device sdb): csum failed root 5 ino 319406 
off 298371032416256 csum 0x6bd9f20b expected csum 0x00000000 mirror 
-173339200
[  419.667707] BTRFS critical (device sdb): stripe index math went 
horribly wrong, got stripe_index=4121628095, num_stripes=2
[  419.667707]  binfmt_misc dm_crypt intel_rapl x86_pkg_temp_thermal 
cmdlinepart intel_spi_platform intel_spi spi_nor mtd intel_powerclamp 
coretemp crct10dif_pclmul crc32_pclmul ghash_clmulni_intel pcbc 
aesni_intel aes_x86_64 crypto_simd joydev glue_helper input_leds cryptd 
intel_cstate kvm_intel kvm irqbypass intel_rapl_perf ipmi_ssif shpchp 
tpm_crb mei_me mei lpc_ich ie31200_edac intel_pch_thermal mac_hid 
ipmi_si ipmi_devintf ipmi_msghandler
[  419.667728] ------------[ cut here ]------------
[  419.667728]  acpi_pad
[  419.667729] kernel BUG at 
/home/kernel/COD/linux/fs/btrfs/extent_io.c:2328!
[  419.667729]  autofs4 btrfs xor raid6_pq hid_generic usbhid hid uas 
usb_storage ast ttm drm_kms_helper syscopyarea sysfillrect sysimgblt 
fb_sys_fops igb e1000e drm mpt3sas dca ahci libahci ptp i2c_algo_bit 
raid_class pps_core scsi_transport_sas video
[  419.667738] CPU: 6 PID: 232 Comm: kworker/u16:6 Tainted: G      D 
     4.12.0-041200rc7-generic #201706252231
[  419.667739] Hardware name: Supermicro X10SLM-F/X10SLM-F, BIOS 3.0 
04/24/2015
[  419.667764] Workqueue: btrfs-endio btrfs_endio_helper [btrfs]
[  419.667765] BTRFS critical (device sdb): stripe index math went 
horribly wrong, got stripe_index=4121628095, num_stripes=2
[  419.667766] task: ffff970633708000 task.stack: ffffaa9d03b04000
[  419.667791] RIP: 0010:btrfs_check_repairable+0xf2/0x100 [btrfs]
[  419.667792] BTRFS critical (device sdb): stripe index math went 
horribly wrong, got stripe_index=4121628095, num_stripes=2
[  419.667793] RSP: 0018:ffffaa9d03b07ce8 EFLAGS: 00010287
[  419.667794] RAX: 0000000000000001 RBX: ffff970624cc51c0 RCX: 
0000000000000001
[  419.667794] RDX: 0000000000000003 RSI: 0000000000000000 RDI: 
ffff970622a7ce60
[  419.667795] RBP: ffffaa9d03b07d08 R08: 00010f5dc7780000 R09: 
00010f5e07780000
[  419.667796] R10: 0000000000000000 R11: 00000000fffffffb R12: 
00000000f25677c0
[  419.667796] R13: ffff970622a70000 R14: ffff9705f2566e28 R15: 
0000000000000000
[  419.667797] FS:  0000000000000000(0000) GS:ffff97065fd80000(0000) 
knlGS:0000000000000000
[  419.667798] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  419.667799] CR2: 00007f047f2d4e18 CR3: 00000006a2809000 CR4: 
00000000001406e0
[  419.667799] Call Trace:
[  419.667813]  end_bio_extent_readpage+0x404/0x540 [btrfs]
[  419.667814] BTRFS critical (device sdb): stripe index math went 
horribly wrong, got stripe_index=4121628095, num_stripes=2
[  419.667816]  bio_endio+0x81/0x100
[  419.667837]  end_workqueue_fn+0x3c/0x40 [btrfs]
[  419.667851]  btrfs_scrubparity_helper+0xc8/0x2e0 [btrfs]
[  419.667864]  btrfs_endio_helper+0xe/0x10 [btrfs]
[  419.667865] BTRFS critical (device sdb): stripe index math went 
horribly wrong, got stripe_index=4121628095, num_stripes=2
[  419.667866]  process_one_work+0x1e9/0x410
[  419.667867]  worker_thread+0x4b/0x410
[  419.667869]  kthread+0x109/0x140
[  419.667870]  ? process_one_work+0x410/0x410
[  419.667872]  ? kthread_create_on_node+0x70/0x70
[  419.667873]  ret_from_fork+0x25/0x30
[  419.667874] Code: 43 28 00 00 00 00 b9 01 00 00 00 31
[  419.667879] BTRFS critical (device sdb): stripe index math went 
horribly wrong, got stripe_index=4121628095, num_stripes=2
[  419.667879] c0 eb d5 8d 48 02 eb d9 45 89 e0 48 c7 c6 a8 2b 68 c0 4c 
89 ef e8 13 c0 fa ff e9 78 ff ff ff <0f> 0b 66 90 66
[  419.667891] BTRFS critical (device sdb): stripe index math went 
horribly wrong, got stripe_index=4121628095, num_stripes=2
[  419.667891] 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 55 48
[  419.667909] RIP: btrfs_check_repairable+0xf2/0x100 [btrfs] RSP: 
ffffaa9d03b07ce8
[  419.667911] invalid opcode: 0000 [#4] SMP
[  419.667911] Modules linked in: zram binfmt_misc dm_crypt intel_rapl 
x86_pkg_temp_thermal cmdlinepart intel_spi_platform intel_spi spi_nor 
mtd intel_powerclamp coretemp crct10dif_pclmul crc32_pclmul 
ghash_clmulni_intel pcbc aesni_intel aes_x86_64 crypto_simd joydev 
glue_helper input_leds cryptd intel_cstate kvm_intel kvm irqbypass 
intel_rapl_perf ipmi_ssif shpchp tpm_crb mei_me mei lpc_ich ie31200_edac 
intel_pch_thermal mac_hid ipmi_si ipmi_devintf ipmi_msghandler
[  419.667921] BTRFS critical (device sdb): stripe index math went 
horribly wrong, got stripe_index=4121628095, num_stripes=2
[  419.667922]  acpi_pad autofs4 btrfs xor raid6_pq hid_generic usbhid 
hid uas usb_storage ast ttm drm_kms_helper syscopyarea sysfillrect 
sysimgblt fb_sys_fops igb e1000e drm mpt3sas dca ahci libahci ptp 
i2c_algo_bit raid_class pps_core scsi_transport_sas video
[  419.667930] CPU: 4 PID: 4155 Comm: kworker/u16:8 Tainted: G      D 
      4.12.0-041200rc7-generic #201706252231
[  419.667930] Hardware name: Supermicro X10SLM-F/X10SLM-F, BIOS 3.0 
04/24/2015
[  419.667945] Workqueue: btrfs-endio btrfs_endio_helper [btrfs]
[  419.667945] ---[ end trace 34db1c353c64ec3f ]---
[  419.667946] BTRFS critical (device sdb): stripe index math went 
horribly wrong, got stripe_index=4121628095, num_stripes=2
[  419.667947] task: ffff9706333cad00 task.stack: ffffaa9d0de24000
[  419.667960] RIP: 0010:btrfs_check_repairable+0xf2/0x100 [btrfs]
[  419.667961] BTRFS critical (device sdb): stripe index math went 
horribly wrong, got stripe_index=4121628095, num_stripes=2
[  419.667962] RSP: 0018:ffffaa9d0de27ce8 EFLAGS: 00010203
[  419.667963] RAX: 0000000000000001 RBX: ffff970624cc5e00 RCX: 
0000000000000001
[  419.667963] RDX: 0000000000000003 RSI: 0000000000000000 RDI: 
ffff970622a7ce60
[  419.667964] RBP: ffffaa9d0de27d08 R08: 00010f5dc7780000 R09: 
00010f5e07780000
[  419.667964] R10: 0000000000000000 R11: 00000000fffffffb R12: 
0000000000000000
[  419.667965] R13: ffff970622a70000 R14: ffff9705f2566568 R15: 
0000000000000000
[  419.667966] FS:  0000000000000000(0000) GS:ffff97065fd00000(0000) 
knlGS:0000000000000000
[  419.667966] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  419.667967] CR2: 00007fc520ff51e4 CR3: 00000006a2809000 CR4: 
00000000001406e0
[  419.667968] Call Trace:
[  419.667980]  end_bio_extent_readpage+0x404/0x540 [btrfs]
[  419.667982]  bio_endio+0x81/0x100
[  419.667993]  end_workqueue_fn+0x3c/0x40 [btrfs]
[  419.667994] BTRFS critical (device sdb): stripe index math went 
horribly wrong, got stripe_index=4121628095, num_stripes=2
[  419.668006]  btrfs_scrubparity_helper+0xc8/0x2e0 [btrfs]
[  419.668017]  btrfs_endio_helper+0xe/0x10 [btrfs]
[  419.668018] BTRFS critical (device sdb): stripe index math went 
horribly wrong, got stripe_index=4121628095, num_stripes=2
[  419.668019]  process_one_work+0x1e9/0x410
[  419.668020]  worker_thread+0x4b/0x410
[  419.668022]  kthread+0x109/0x140
[  419.668023]  ? process_one_work+0x410/0x410
[  419.668024]  ? kthread_create_on_node+0x70/0x70
[  419.668026]  ret_from_fork+0x25/0x30
[  419.668026] Code: 43 28 00 00 00 00 b9
[  419.668029] BTRFS critical (device sdb): stripe index math went 
horribly wrong, got stripe_index=4121628095, num_stripes=2
[  419.668030] 01 00 00 00 31 c0 eb d5 8d 48 02 eb d9 45 89 e0 48 c7 c6 
a8 2b 68 c0 4c 89 ef e8 13 c0 fa ff e9 78 ff ff ff <0f> 0b 66 90 66 2e 
0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 55 48
[  419.668056] RIP: btrfs_check_repairable+0xf2/0x100 [btrfs] RSP: 
ffffaa9d0de27ce8
[  419.668057] ---[ end trace 34db1c353c64ec40 ]---
[  419.668058] invalid opcode: 0000 [#5] SMP
[  419.668058] Modules linked in: zram binfmt_misc
[  419.668060] BTRFS critical (device sdb): stripe index math went 
horribly wrong, got stripe_index=4121628095, num_stripes=2
[  419.668060]  dm_crypt intel_rapl x86_pkg_temp_thermal cmdlinepart 
intel_spi_platform intel_spi spi_nor mtd intel_powerclamp coretemp 
crct10dif_pclmul crc32_pclmul ghash_clmulni_intel pcbc aesni_intel 
aes_x86_64 crypto_simd joydev glue_helper input_leds cryptd intel_cstate 
kvm_intel kvm irqbypass intel_rapl_perf ipmi_ssif shpchp tpm_crb mei_me 
mei lpc_ich ie31200_edac intel_pch_thermal mac_hid ipmi_si ipmi_devintf 
ipmi_msghandler acpi_pad autofs4 btrfs xor raid6_pq hid_generic usbhid 
hid uas usb_storage ast ttm drm_kms_helper syscopyarea sysfillrect 
sysimgblt fb_sys_fops igb e1000e drm mpt3sas dca ahci
[  419.668075] BTRFS critical (device sdb): stripe index math went 
horribly wrong, got stripe_index=4121628095, num_stripes=2
[  419.668075]  libahci ptp i2c_algo_bit raid_class pps_core 
scsi_transport_sas video
[  419.668078] CPU: 0 PID: 4134 Comm: kworker/u16:1 Tainted: G      D 
      4.12.0-041200rc7-generic #201706252231
[  419.668078] Hardware name: Supermicro X10SLM-F/X10SLM-F, BIOS 3.0 
04/24/2015
[  419.668090] Workqueue: btrfs-endio btrfs_endio_helper [btrfs]
[  419.668090] BTRFS critical (device sdb): stripe index math went 
horribly wrong, got stripe_index=4121628095, num_stripes=2
[  419.668091] task: ffff970637c61680 task.stack: ffffaa9d0dc94000
[  419.668102] RIP: 0010:btrfs_check_repairable+0xf2/0x100 [btrfs]
[  419.668103] RSP: 0018:ffffaa9d0dc97ce8 EFLAGS: 00010287
[  419.668104] RAX: 0000000000000001 RBX: ffff970624cc5f00 RCX: 
0000000000000001
[  419.668104] RDX: 0000000000000003 RSI: 0000000000000000 RDI: 
ffff970622a7ce60
[  419.668105] RBP: ffffaa9d0dc97d08 R08: 00010f5dc7780000 R09: 
00010f5e07780000
[  419.668105] R10: 0000000000000000 R11: 00000000fffffffb R12: 
00000000f2566280
[  419.668106] R13: ffff970622a70000 R14: ffff9705f2567828 R15: 
0000000000000000
[  419.668107] FS:  0000000000000000(0000) GS:ffff97065fc00000(0000) 
knlGS:0000000000000000
[  419.668107] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  419.668108] CR2: 00007f2744027268 CR3: 00000006a2809000 CR4: 
00000000001406f0
[  419.668108] Call Trace:
[  419.668119]  end_bio_extent_readpage+0x404/0x540 [btrfs]
[  419.668120] BTRFS critical (device sdb): stripe index math went 
horribly wrong, got stripe_index=4121628095, num_stripes=2
[  419.668121]  bio_endio+0x81/0x100
[  419.668132]  end_workqueue_fn+0x3c/0x40 [btrfs]
[  419.668143]  btrfs_scrubparity_helper+0xc8/0x2e0 [btrfs]
[  419.668144] BTRFS critical (device sdb): stripe index math went 
horribly wrong, got stripe_index=4121628095, num_stripes=2
[  419.668155]  btrfs_endio_helper+0xe/0x10 [btrfs]
[  419.668155] BTRFS critical (device sdb): stripe index math went 
horribly wrong, got stripe_index=4121628095, num_stripes=2
[  419.668157]  process_one_work+0x1e9/0x410
[  419.668158]  worker_thread+0x4b/0x410
[  419.668159]  kthread+0x109/0x140
[  419.668160]  ? process_one_work+0x410/0x410
[  419.668162]  ? kthread_create_on_node+0x70/0x70
[  419.668163]  ret_from_fork+0x25/0x30
[  419.668163] Code: 43 28 00 00 00 00 b9 01 00 00 00 31 c0 eb d5 8d 48 
02 eb d9 45 89 e0 48 c7 c6 a8 2b 68 c0 4c 89 ef e8 13 c0 fa ff e9 78 ff 
ff ff <0f> 0b 66 90 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 55 48
[  419.668192] RIP: btrfs_check_repairable+0xf2/0x100 [btrfs] RSP: 
ffffaa9d0dc97ce8
[  419.668193] BTRFS critical (device sdb): stripe index math went 
horribly wrong, got stripe_index=4121628095, num_stripes=2
[  419.668193] ---[ end trace 34db1c353c64ec41 ]---
[  419.668207] BTRFS critical (device sdb): stripe index math went 
horribly wrong, got stripe_index=4121628095, num_stripes=2
[  419.668218] BTRFS critical (device sdb): stripe index math went 
horribly wrong, got stripe_index=4121628095, num_stripes=2
[  419.668248] BTRFS critical (device sdb): stripe index math went 
horribly wrong, got stripe_index=4121628095, num_stripes=2
[  419.668261] BTRFS critical (device sdb): stripe index math went 
horribly wrong, got stripe_index=4121628095, num_stripes=2
[  419.668273] BTRFS critical (device sdb): stripe index math went 
horribly wrong, got stripe_index=4121628095, num_stripes=2
[  419.668303] BTRFS critical (device sdb): stripe index math went 
horribly wrong, got stripe_index=4121628095, num_stripes=2
[  419.668316] BTRFS critical (device sdb): stripe index math went 
horribly wrong, got stripe_index=4121628095, num_stripes=2
[  419.712524] BTRFS critical (device sdb): stripe index math went 
horribly wrong, got stripe_index=4121628095, num_stripes=2
[  419.712557] BTRFS critical (device sdb): stripe index math went 
horribly wrong, got stripe_index=4121628095, num_stripes=2
[  419.712572] BTRFS critical (device sdb): stripe index math went 
horribly wrong, got stripe_index=4121628095, num_stripes=2
[  419.712584] BTRFS critical (device sdb): stripe index math went 
horribly wrong, got stripe_index=4121628095, num_stripes=2
[  419.712615] BTRFS critical (device sdb): stripe index math went 
horribly wrong, got stripe_index=4121628095, num_stripes=2
[  419.712630] BTRFS critical (device sdb): stripe index math went 
horribly wrong, got stripe_index=4121628095, num_stripes=2
[  419.712641] BTRFS critical (device sdb): stripe index math went 
horribly wrong, got stripe_index=4121628095, num_stripes=2
[  419.712672] BTRFS critical (device sdb): stripe index math went 
horribly wrong, got stripe_index=4121628095, num_stripes=2
[  419.712689] BTRFS critical (device sdb): stripe index math went 
horribly wrong, got stripe_index=4121628095, num_stripes=2
[  419.712701] BTRFS critical (device sdb): stripe index math went 
horribly wrong, got stripe_index=4121628095, num_stripes=2
[  419.712732] BTRFS critical (device sdb): stripe index math went 
horribly wrong, got stripe_index=4121628095, num_stripes=2
[  419.712747] BTRFS critical (device sdb): stripe index math went 
horribly wrong, got stripe_index=4121628095, num_stripes=2
[  419.712757] BTRFS critical (device sdb): stripe index math went 
horribly wrong, got stripe_index=4121628095, num_stripes=2
[  419.712787] BTRFS critical (device sdb): stripe index math went 
horribly wrong, got stripe_index=4121628095, num_stripes=2
[  419.712801] BTRFS critical (device sdb): stripe index math went 
horribly wrong, got stripe_index=4121628095, num_stripes=2
[  419.712814] BTRFS critical (device sdb): stripe index math went 
horribly wrong, got stripe_index=4121628095, num_stripes=2
[  419.712845] BTRFS critical (device sdb): stripe index math went 
horribly wrong, got stripe_index=4121628095, num_stripes=2
[  419.712860] BTRFS critical (device sdb): stripe index math went 
horribly wrong, got stripe_index=4121628095, num_stripes=2
[  419.712870] BTRFS critical (device sdb): stripe index math went 
horribly wrong, got stripe_index=4121628095, num_stripes=2
[  419.712902] BTRFS critical (device sdb): stripe index math went 
horribly wrong, got stripe_index=4121628095, num_stripes=2
[  419.712916] BTRFS critical (device sdb): stripe index math went 
horribly wrong, got stripe_index=4121628095, num_stripes=2
[  419.712928] BTRFS critical (device sdb): stripe index math went 
horribly wrong, got stripe_index=4121628095, num_stripes=2
[  419.712959] BTRFS critical (device sdb): stripe index math went 
horribly wrong, got stripe_index=4121628095, num_stripes=2
[  419.712973] BTRFS critical (device sdb): stripe index math went 
horribly wrong, got stripe_index=4121628095, num_stripes=2
[  419.712987] BTRFS critical (device sdb): stripe index math went 
horribly wrong, got stripe_index=4121628095, num_stripes=2
[  419.713018] BTRFS critical (device sdb): stripe index math went 
horribly wrong, got stripe_index=4121628095, num_stripes=2
[  419.713032] BTRFS critical (device sdb): stripe index math went 
horribly wrong, got stripe_index=4121628095, num_stripes=2
[  419.748699] BTRFS critical (device sdb): stripe index math went 
horribly wrong, got stripe_index=4121628095, num_stripes=2
[  419.748731] BTRFS critical (device sdb): stripe index math went 
horribly wrong, got stripe_index=4121628095, num_stripes=2
[  419.748746] BTRFS critical (device sdb): stripe index math went 
horribly wrong, got stripe_index=4121628095, num_stripes=2
[  419.748759] BTRFS critical (device sdb): stripe index math went 
horribly wrong, got stripe_index=4121628095, num_stripes=2
[  419.748790] BTRFS critical (device sdb): stripe index math went 
horribly wrong, got stripe_index=4121628095, num_stripes=2
[  419.748806] BTRFS critical (device sdb): stripe index math went 
horribly wrong, got stripe_index=4121628095, num_stripes=2
[  419.748817] BTRFS critical (device sdb): stripe index math went 
horribly wrong, got stripe_index=4121628095, num_stripes=2
[  419.748848] BTRFS critical (device sdb): stripe index math went 
horribly wrong, got stripe_index=4121628095, num_stripes=2
[  419.748862] BTRFS critical (device sdb): stripe index math went 
horribly wrong, got stripe_index=4121628095, num_stripes=2
[  419.748876] BTRFS critical (device sdb): stripe index math went 
horribly wrong, got stripe_index=4121628095, num_stripes=2
[  419.748908] BTRFS critical (device sdb): stripe index math went 
horribly wrong, got stripe_index=4121628095, num_stripes=2
[  419.748922] BTRFS critical (device sdb): stripe index math went 
horribly wrong, got stripe_index=4121628095, num_stripes=2
[  419.748935] BTRFS critical (device sdb): stripe index math went 
horribly wrong, got stripe_index=4121628095, num_stripes=2
[  419.748966] BTRFS critical (device sdb): stripe index math went 
horribly wrong, got stripe_index=4121628095, num_stripes=2
[  419.748980] BTRFS critical (device sdb): stripe index math went 
horribly wrong, got stripe_index=4121628095, num_stripes=2
[  419.748993] BTRFS critical (device sdb): stripe index math went 
horribly wrong, got stripe_index=4121628095, num_stripes=2
[  419.749025] BTRFS critical (device sdb): stripe index math went 
horribly wrong, got stripe_index=4121628095, num_stripes=2
[  419.749039] BTRFS critical (device sdb): stripe index math went 
horribly wrong, got stripe_index=4121628095, num_stripes=2
[  419.749052] BTRFS critical (device sdb): stripe index math went 
horribly wrong, got stripe_index=4121628095, num_stripes=2
[  419.749083] BTRFS critical (device sdb): stripe index math went 
horribly wrong, got stripe_index=4121628095, num_stripes=2
[  419.749098] BTRFS critical (device sdb): stripe index math went 
horribly wrong, got stripe_index=4121628095, num_stripes=2
[  419.749112] BTRFS critical (device sdb): stripe index math went 
horribly wrong, got stripe_index=4121628095, num_stripes=2
[  419.749143] BTRFS critical (device sdb): stripe index math went 
horribly wrong, got stripe_index=4121628095, num_stripes=2
[  419.749158] BTRFS critical (device sdb): stripe index math went 
horribly wrong, got stripe_index=4121628095, num_stripes=2
[  419.749164] BTRFS warning (device sdb): csum failed root 5 ino 319406 
off 298371032416256 csum 0xff40460a expected csum 0x00000000 mirror 
-173339200
[  419.749171] BTRFS warning (device sdb): csum failed root 5 ino 319406 
off 298371032416256 csum 0x014f2125 expected csum 0x00000000 mirror 
-173339200
[  419.749178] BTRFS warning (device sdb): csum failed root 5 ino 319406 
off 298371032416256 csum 0x141282bb expected csum 0x00000000 mirror 
-173339200
[  419.972680] ------------[ cut here ]------------
[  419.972844] kernel BUG at 
/home/kernel/COD/linux/fs/btrfs/extent_io.c:2328!
[  419.973021] invalid opcode: 0000 [#6] SMP
[  419.973202] Modules linked in: zram binfmt_misc dm_crypt intel_rapl 
x86_pkg_temp_thermal cmdlinepart intel_spi_platform intel_spi spi_nor 
mtd intel_powerclamp coretemp crct10dif_pclmul crc32_pclmul 
ghash_clmulni_intel pcbc aesni_intel aes_x86_64 crypto_simd joydev 
glue_helper input_leds cryptd intel_cstate kvm_intel kvm irqbypass 
intel_rapl_perf ipmi_ssif shpchp tpm_crb mei_me mei lpc_ich ie31200_edac 
intel_pch_thermal mac_hid ipmi_si ipmi_devintf ipmi_msghandler acpi_pad 
autofs4 btrfs xor raid6_pq hid_generic usbhid hid uas usb_storage ast 
ttm drm_kms_helper syscopyarea sysfillrect sysimgblt fb_sys_fops igb 
e1000e drm mpt3sas dca ahci libahci ptp i2c_algo_bit raid_class pps_core 
scsi_transport_sas video
[  419.974933] CPU: 6 PID: 229 Comm: kworker/u16:3 Tainted: G      D 
     4.12.0-041200rc7-generic #201706252231
[  419.975252] Hardware name: Supermicro X10SLM-F/X10SLM-F, BIOS 3.0 
04/24/2015
[  419.975602] Workqueue: btrfs-endio btrfs_endio_helper [btrfs]
[  419.975939] task: ffff970633a69680 task.stack: ffffaa9d03cf4000
[  419.976294] RIP: 0010:btrfs_check_repairable+0xf2/0x100 [btrfs]
[  419.976660] RSP: 0018:ffffaa9d03cf7ce8 EFLAGS: 00010202
[  419.977032] RAX: 0000000000000001 RBX: ffff970624cc5a40 RCX: 
0000000000000001
[  419.977467] RDX: 0000000000000003 RSI: 0000000000000000 RDI: 
ffff970622a7ce60
[  419.977853] RBP: ffffaa9d03cf7d08 R08: 00010f5dc7780000 R09: 
00010f5e07780000
[  419.978248] R10: 0000000000000000 R11: 00000000fffffffb R12: 
00000000f5dcaa00
[  419.978683] R13: ffff970622a70000 R14: ffff9705f5dcace8 R15: 
0000000000000000
[  419.979082] FS:  0000000000000000(0000) GS:ffff97065fd80000(0000) 
knlGS:0000000000000000
[  419.979502] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  419.979929] CR2: 00007f047f2d4e18 CR3: 00000006a2809000 CR4: 
00000000001406e0
[  419.980369] Call Trace:
[  419.980881]  end_bio_extent_readpage+0x404/0x540 [btrfs]
[  419.981338]  bio_endio+0x81/0x100
[  419.981803]  end_workqueue_fn+0x3c/0x40 [btrfs]
[  419.982278]  btrfs_scrubparity_helper+0xc8/0x2e0 [btrfs]
[  419.982759]  btrfs_endio_helper+0xe/0x10 [btrfs]
[  419.983247]  process_one_work+0x1e9/0x410
[  419.983718]  worker_thread+0x4b/0x410
[  419.984192]  kthread+0x109/0x140
[  419.984683]  ? process_one_work+0x410/0x410
[  419.985240]  ? kthread_create_on_node+0x70/0x70
[  419.985773]  ret_from_fork+0x25/0x30
[  419.986274] Code: 43 28 00 00 00 00 b9 01 00 00 00 31 c0 eb d5 8d 48 
02 eb d9 45 89 e0 48 c7 c6 a8 2b 68 c0 4c 89 ef e8 13 c0 fa ff e9 78 ff 
ff ff <0f> 0b 66 90 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 55 48
[  419.987419] RIP: btrfs_check_repairable+0xf2/0x100 [btrfs] RSP: 
ffffaa9d03cf7ce8
[  419.988059] ---[ end trace 34db1c353c64ec42 ]---
