Return-Path: <SRS0=6jfg=QB=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=FREEMAIL_FORGED_FROMDOMAIN,
	FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E5B4FC282C0
	for <linux-btrfs@archiver.kernel.org>; Fri, 25 Jan 2019 07:39:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A320C218D0
	for <linux-btrfs@archiver.kernel.org>; Fri, 25 Jan 2019 07:39:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727500AbfAYHjh (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 25 Jan 2019 02:39:37 -0500
Received: from mout.gmx.net ([212.227.17.20]:48929 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726520AbfAYHjh (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 25 Jan 2019 02:39:37 -0500
Received: from t460-skr.localnet ([194.94.224.254]) by mail.gmx.com (mrgmx101
 [212.227.17.168]) with ESMTPSA (Nemesis) id 0LyR1G-1hIA6f01jC-015n0L for
 <linux-btrfs@vger.kernel.org>; Fri, 25 Jan 2019 08:39:31 +0100
From:   Stefan K <shadow_7@gmx.net>
To:     linux-btrfs@vger.kernel.org
Subject: kernel calltraces with btrfs and bonnie++
Date:   Fri, 25 Jan 2019 08:39:30 +0100
Message-ID: <4998841.JdUrKLmerL@t460-skr>
User-Agent: KMail/5.2.3 (Linux/4.9.0-8-amd64; KDE/5.28.0; x86_64; ; )
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V03:K1:PG6bZNtbqEIOaXBmkoxBz5L22HyaHs7O1kZJDCigp3LJBEIRTC8
 sRDTpkaWOSoXZTeeJaNx1jJdQHM+/L3pSWaMaEeDadFLosr02FX+Z3dTbuMI+sB7Bb/oSWo
 R/3HrSzetFVInkaNEK6oIB6LAA/HA8Z8HcgqhTQar+Ajt+W40YKs2cmo8VP8laVtDlRlC5P
 5ae5ZRrGJhL5TV0vVyfwA==
X-UI-Out-Filterresults: notjunk:1;V03:K0:1zIMl9lw/Sc=:wu6bR/wkx1cCw6EgdhtMAZ
 I23FONvvPKimMcRqOsBbHsjza41j9XBaRB7WK2oWKqRiflR+EkEUw9dD8k1sZpNyE64OavP/u
 RajeHWRWTawvT2D2yGu40XWsVBt52n8Znfsr9O5X90/4Ah8ZZSdJzhRH3E5MvtjaroxT5o2Ps
 GIeRe78FrDxCgOGPCllfOf9Z8SidcMZmI1enmzYtglC9pvPwP7TIOlgSmDd67b8IhIKUB2Uc/
 oNTj3QHSKNtfTn4SMU13QZunSkN8XrJIW+s365lniZtQFnzCimJ1fai3ZVGg6zgkHkARc1c+H
 FboPJyhCKJ/7/h7GyeF2vlPTfdyGyI3cxmwJtb1D3prO5K/KO7uBCT+2qYJU1bIGntK8eqIan
 2K7kacXj8ddBR9X0VOjYtwQn4TekJV/uVBwNPlYV8k89NHu7vemGBza6sC1yq5Kw6yv2rujXW
 TQCefw53Wkso798SwI6Xg0A/RNeCdlJUxCwqSsP06nJ3xBW1AlXr7znfWIW/OC2i6BF2Q0HLX
 Cu9/5BpJXg1NFgb/QNFK9Gesb29lZtlAhNfVCi2ExwRmk1c+twvaaS5o3FkqX/jlJogNU0QGa
 RyNYcfI4o7xRaEWiDKPmnnQy+OwQsWMXShPGfW0HVuk08mlm/rrP6XWwUxVa5lfI5law0hksW
 hj0Kpj3En+dBMDZbV7bDGyq53NF+IsPCk00pBfIPz6fdpUz//b1ER2uKezNOcfPGQ8BHQoLpw
 FqtDj07hN/Ow1iZ98evAYE6F+Uf6HmeRvpDhSnrh+dh8616AJv5xRWYYwedzfao/L4u6dnOYx
 xNohAqcSuNIAqNYhvfm7esylG0dwdrQBZ7cpS/RRDNU4/7Vw7MsKdufijqO0yg4lW32eV8H/i
 jUSMpGfGy9Lgi6FWDqiKJMR6DP/12Fm6+EwE3VkY3Cy2zntW8NeIqKvob9s5yKEJcprNUTuoe
 YrgOmhdoaWQ==
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Hello,

if I run 'bonnie++ -c4' the system is unusable and hangs, I got also some CallTraces in my syslog. Is that a normal behavior? 

My system is:
uname -a 
Linux tani 4.19.0-0.bpo.1-amd64 #1 SMP Debian 4.19.12-1~bpo9+1 (2018-12-30) x86_64 GNU/Linux

btrfs fi sh
Label: none  uuid: 24be286b-ece6-4481-aa48-af255e96e5bd
        Total devices 2 FS bytes used 128.89GiB
        devid    1 size 219.84GiB used 131.03GiB path /dev/sdb2
        devid    2 size 219.84GiB used 131.03GiB path /dev/sde2

both are new SSDs:
smartctl -i /dev/sdb
smartctl 6.6 2016-05-31 r4324 [x86_64-linux-4.19.0-0.bpo.1-amd64] (local build)
Copyright (C) 2002-16, Bruce Allen, Christian Franke, www.smartmontools.org

=== START OF INFORMATION SECTION ===
Device Model:     SAMSUNG MZ7LM240HMHQ-00005
Serial Number:    S2TWNX0KA02412
LU WWN Device Id: 5 002538 c40b988bf
Firmware Version: GXT5404Q
User Capacity:    240,057,409,536 bytes [240 GB]
Sector Size:      512 bytes logical/physical
Rotation Rate:    Solid State Device
Form Factor:      2.5 inches
Device is:        Not in smartctl database [for details use: -P showall]
ATA Version is:   ACS-2, ATA8-ACS T13/1699-D revision 4c
SATA Version is:  SATA 3.1, 6.0 Gb/s (current: 6.0 Gb/s)
Local Time is:    Fri Jan 25 08:37:49 2019 CET
SMART support is: Available - device has SMART capability.
SMART support is: Enabled


if I run this I got this output in my /var/log/syslog:

Jan 25 08:19:20 tani kernel: [  480.733545] WARNING: CPU: 8 PID: 8564 at /build/linux-Ut6wTa/linux-4.19.12/fs/btrfs/ctree.h:1588 btrfs_update_device+0x1b2/0x1c0 [btrfs]
Jan 25 08:19:20 tani kernel: [  480.733546] Modules linked in: intel_rapl skx_edac nfit libnvdimm x86_pkg_temp_thermal intel_powerclamp coretemp kvm_intel kvm irqbypass crct10dif_pclmul crc32_pclmul ghash_clmulni_intel intel_cstate intel_uncore intel_rapl_perf pcspkr dm_service_time zfs(POE) zunicode(POE) zavl(POE) 
icp(POE) zcommon(POE) znvpair(POE) spl(OE) ast ttm drm_kms_helper drm mei_me ipmi_si ioatdma ipmi_devintf iTCO_wdt sg joydev i2c_algo_bit evdev iTCO_vendor_support lpc_ich mei dca wmi ipmi_msghandler acpi_power_meter acpi_pad pcc_cpufreq button dm_multipath dm_mod scsi_dh_rdac scsi_dh_emc scsi_dh_alua ip_tables x_ta
bles autofs4 btrfs xor zstd_decompress zstd_compress xxhash raid6_pq libcrc32c crc32c_generic ses enclosure sd_mod hid_generic usbhid hid crc32c_intel ahci mpt3sas libahci aesni_intel xhci_pci aes_x86_64 libata
Jan 25 08:19:20 tani kernel: [  480.733582]  raid_class crypto_simd xhci_hcd scsi_transport_sas cryptd glue_helper i40e scsi_mod usbcore i2c_i801 usb_common
Jan 25 08:19:20 tani kernel: [  480.733591] CPU: 8 PID: 8564 Comm: bonnie++ Tainted: P           OE     4.19.0-0.bpo.1-amd64 #1 Debian 4.19.12-1~bpo9+1
Jan 25 08:19:20 tani kernel: [  480.733591] Hardware name: Supermicro Super Server/X11DPH-i, BIOS 2.1 06/15/2018
Jan 25 08:19:20 tani kernel: [  480.733605] RIP: 0010:btrfs_update_device+0x1b2/0x1c0 [btrfs]
Jan 25 08:19:20 tani kernel: [  480.733606] Code: 89 f7 45 31 c0 ba 10 00 00 00 4c 89 ee e8 e6 27 ff ff 4c 89 f7 e8 fe f7 fc ff e9 de fe ff ff 41 bc f4 ff ff ff e9 db fe ff ff <0f> 0b eb b7 e8 25 d5 89 e7 0f 1f 44 00 00 0f 1f 44 00 00 41 55 41
Jan 25 08:19:20 tani kernel: [  480.733607] RSP: 0018:ffffb6be475bfab0 EFLAGS: 00010206
Jan 25 08:19:20 tani kernel: [  480.733608] RAX: 0000000000000fff RBX: ffff96b769786bd0 RCX: 00000036f60ffc00
Jan 25 08:19:20 tani kernel: [  480.733609] RDX: 0000000000001000 RSI: 0000000000003f5c RDI: ffff96b6d6b76f50
Jan 25 08:19:20 tani kernel: [  480.733609] RBP: ffff96b729a2f000 R08: ffffb6be475bfa60 R09: ffffb6be475bfa68
Jan 25 08:19:20 tani kernel: [  480.733610] R10: 0000000000000003 R11: 0000000000003000 R12: 0000000000000000
Jan 25 08:19:20 tani kernel: [  480.733611] R13: 0000000000003f3c R14: ffff96b6d6b76f50 R15: 00000000fffffff4
Jan 25 08:19:20 tani kernel: [  480.733612] FS:  00007f3451aeb740(0000) GS:ffff96b77fc00000(0000) knlGS:0000000000000000
Jan 25 08:19:20 tani kernel: [  480.733613] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
Jan 25 08:19:20 tani kernel: [  480.733614] CR2: 0000565195079000 CR3: 0000003f25eec001 CR4: 00000000007606e0
Jan 25 08:19:20 tani kernel: [  480.733615] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
Jan 25 08:19:20 tani kernel: [  480.733616] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Jan 25 08:19:20 tani kernel: [  480.733616] PKRU: 55555554
Jan 25 08:19:20 tani kernel: [  480.733617] Call Trace:
Jan 25 08:19:20 tani kernel: [  480.733632]  btrfs_finish_chunk_alloc+0x12d/0x4b0 [btrfs]
Jan 25 08:19:20 tani kernel: [  480.733643]  ? btrfs_create_pending_block_groups+0xec/0x240 [btrfs]
Jan 25 08:19:20 tani kernel: [  480.733652]  btrfs_create_pending_block_groups+0xec/0x240 [btrfs]
Jan 25 08:19:20 tani kernel: [  480.733664]  __btrfs_end_transaction+0x87/0x2c0 [btrfs]
Jan 25 08:19:20 tani kernel: [  480.733673]  btrfs_alloc_data_chunk_ondemand+0xf8/0x300 [btrfs]
Jan 25 08:19:20 tani kernel: [  480.733682]  btrfs_check_data_free_space+0x53/0xa0 [btrfs]
Jan 25 08:19:20 tani kernel: [  480.733694]  btrfs_buffered_write.isra.23+0x1a9/0x790 [btrfs]
Jan 25 08:19:20 tani kernel: [  480.733697]  ? current_time+0x4d/0x90
Jan 25 08:19:20 tani kernel: [  480.733708]  btrfs_file_write_iter+0x383/0x530 [btrfs]
Jan 25 08:19:20 tani kernel: [  480.733711]  new_sync_write+0xfd/0x160
Jan 25 08:19:20 tani kernel: [  480.733714]  vfs_write+0xb0/0x190
Jan 25 08:19:20 tani kernel: [  480.733716]  ksys_write+0x52/0xc0
Jan 25 08:19:20 tani kernel: [  480.733719]  do_syscall_64+0x55/0x110
Jan 25 08:19:20 tani kernel: [  480.733722]  entry_SYSCALL_64_after_hwframe+0x44/0xa9
Jan 25 08:19:20 tani kernel: [  480.733723] RIP: 0033:0x7f34516ca190
Jan 25 08:19:20 tani kernel: [  480.733725] Code: 2e 0f 1f 84 00 00 00 00 00 90 48 8b 05 39 7e 20 00 c3 0f 1f 84 00 00 00 00 00 83 3d 39 c2 20 00 00 75 10 b8 01 00 00 00 0f 05 <48> 3d 01 f0 ff ff 73 31 c3 48 83 ec 08 e8 ae fc ff ff 48 89 04 24
Jan 25 08:19:20 tani kernel: [  480.733726] RSP: 002b:00007ffea85dff38 EFLAGS: 00000246 ORIG_RAX: 0000000000000001
Jan 25 08:19:20 tani kernel: [  480.733727] RAX: ffffffffffffffda RBX: 00007ffea85dff80 RCX: 00007f34516ca190
Jan 25 08:19:20 tani kernel: [  480.733728] RDX: 0000000000002000 RSI: 0000565195078000 RDI: 0000000000000003
Jan 25 08:19:20 tani kernel: [  480.733728] RBP: 0000000000006414 R08: 00007f3450e19700 R09: 00007f3450e18520
Jan 25 08:19:20 tani kernel: [  480.733729] R10: 00007ffea85dff20 R11: 0000000000000246 R12: 0000000000000415
Jan 25 08:19:20 tani kernel: [  480.733730] R13: 00007ffea85dff80 R14: 00007ffea85dff60 R15: 0000565195078000
Jan 25 08:19:20 tani kernel: [  480.733731] ---[ end trace c733fae4edf212cd ]---
Jan 25 08:19:20 tani dhclient[3708]: DHCPDISCOVER on eno1 to 255.255.255.255 port 67 interval 7
Jan 25 08:19:21 tani kernel: [  481.082338] WARNING: CPU: 8 PID: 8564 at /build/linux-Ut6wTa/linux-4.19.12/fs/btrfs/ctree.h:1588 btrfs_update_device+0x1b2/0x1c0 [btrfs]
Jan 25 08:19:21 tani kernel: [  481.082339] Modules linked in: intel_rapl skx_edac nfit libnvdimm x86_pkg_temp_thermal intel_powerclamp coretemp kvm_intel kvm irqbypass crct10dif_pclmul crc32_pclmul ghash_clmulni_intel intel_cstate intel_uncore intel_rapl_perf pcspkr dm_service_time zfs(POE) zunicode(POE) zavl(POE) icp(POE) zcommon(POE) znvpair(POE) spl(OE) ast ttm drm_kms_helper drm mei_me ipmi_si ioatdma ipmi_devintf iTCO_wdt sg joydev i2c_algo_bit evdev iTCO_vendor_support lpc_ich mei dca wmi ipmi_msghandler acpi_power_meter acpi_pad pcc_cpufreq button dm_multipath dm_mod scsi_dh_rdac scsi_dh_emc scsi_dh_alua ip_tables x_tables autofs4 btrfs xor zstd_decompress zstd_compress xxhash raid6_pq libcrc32c crc32c_generic ses enclosure sd_mod hid_generic usbhid hid crc32c_intel ahci mpt3sas libahci aesni_intel xhci_pci aes_x86_64 libata
Jan 25 08:19:21 tani kernel: [  481.082372]  raid_class crypto_simd xhci_hcd scsi_transport_sas cryptd glue_helper i40e scsi_mod usbcore i2c_i801 usb_common
Jan 25 08:19:21 tani kernel: [  481.082378] CPU: 8 PID: 8564 Comm: bonnie++ Tainted: P        W  OE     4.19.0-0.bpo.1-amd64 #1 Debian 4.19.12-1~bpo9+1
Jan 25 08:19:21 tani kernel: [  481.082379] Hardware name: Supermicro Super Server/X11DPH-i, BIOS 2.1 06/15/2018
Jan 25 08:19:21 tani kernel: [  481.082390] RIP: 0010:btrfs_update_device+0x1b2/0x1c0 [btrfs]
Jan 25 08:19:21 tani kernel: [  481.082392] Code: 89 f7 45 31 c0 ba 10 00 00 00 4c 89 ee e8 e6 27 ff ff 4c 89 f7 e8 fe f7 fc ff e9 de fe ff ff 41 bc f4 ff ff ff e9 db fe ff ff <0f> 0b eb b7 e8 25 d5 89 e7 0f 1f 44 00 00 0f 1f 44 00 00 41 55 41
Jan 25 08:19:21 tani kernel: [  481.082392] RSP: 0018:ffffb6be475bfab0 EFLAGS: 00010206
Jan 25 08:19:21 tani kernel: [  481.082394] RAX: 0000000000000fff RBX: ffff96b769786bd0 RCX: 00000036f60ffc00
Jan 25 08:19:21 tani kernel: [  481.082394] RDX: 0000000000001000 RSI: 0000000000003f5c RDI: ffff96b6d6b76f50
Jan 25 08:19:21 tani kernel: [  481.082395] RBP: ffff96b729a2f000 R08: ffffb6be475bfa60 R09: ffffb6be475bfa68
Jan 25 08:19:21 tani kernel: [  481.082396] R10: 0000000000000003 R11: 0000000000003000 R12: 0000000000000000
Jan 25 08:19:21 tani kernel: [  481.082396] R13: 0000000000003f3c R14: ffff96b6d6b76f50 R15: 00000000fffffff4
Jan 25 08:19:21 tani kernel: [  481.082397] FS:  00007f3451aeb740(0000) GS:ffff96b77fc00000(0000) knlGS:0000000000000000
Jan 25 08:19:21 tani kernel: [  481.082398] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
Jan 25 08:19:21 tani kernel: [  481.082399] CR2: 0000565195079000 CR3: 0000003f25eec001 CR4: 00000000007606e0
Jan 25 08:19:21 tani kernel: [  481.082400] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
Jan 25 08:19:21 tani kernel: [  481.082401] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Jan 25 08:19:21 tani kernel: [  481.082401] PKRU: 55555554
Jan 25 08:19:21 tani kernel: [  481.082401] Call Trace:
Jan 25 08:19:21 tani kernel: [  481.082416]  btrfs_finish_chunk_alloc+0x12d/0x4b0 [btrfs]
Jan 25 08:19:21 tani kernel: [  481.082426]  ? btrfs_create_pending_block_groups+0xec/0x240 [btrfs]
Jan 25 08:19:21 tani kernel: [  481.082435]  btrfs_create_pending_block_groups+0xec/0x240 [btrfs]
Jan 25 08:19:21 tani kernel: [  481.082446]  __btrfs_end_transaction+0x87/0x2c0 [btrfs]
Jan 25 08:19:21 tani kernel: [  481.082455]  btrfs_alloc_data_chunk_ondemand+0xf8/0x300 [btrfs]
Jan 25 08:19:21 tani kernel: [  481.082463]  btrfs_check_data_free_space+0x53/0xa0 [btrfs]
Jan 25 08:19:21 tani kernel: [  481.082473]  btrfs_buffered_write.isra.23+0x1a9/0x790 [btrfs]
Jan 25 08:19:21 tani kernel: [  481.082476]  ? current_time+0x4d/0x90
Jan 25 08:19:21 tani kernel: [  481.082486]  btrfs_file_write_iter+0x383/0x530 [btrfs]
Jan 25 08:19:21 tani kernel: [  481.082490]  new_sync_write+0xfd/0x160
Jan 25 08:19:21 tani kernel: [  481.082492]  vfs_write+0xb0/0x190
Jan 25 08:19:21 tani kernel: [  481.082494]  ksys_write+0x52/0xc0
Jan 25 08:19:21 tani kernel: [  481.082496]  do_syscall_64+0x55/0x110
Jan 25 08:19:21 tani kernel: [  481.082499]  entry_SYSCALL_64_after_hwframe+0x44/0xa9
Jan 25 08:19:21 tani kernel: [  481.082501] RIP: 0033:0x7f34516ca190
Jan 25 08:19:21 tani kernel: [  481.082502] Code: 2e 0f 1f 84 00 00 00 00 00 90 48 8b 05 39 7e 20 00 c3 0f 1f 84 00 00 00 00 00 83 3d 39 c2 20 00 00 75 10 b8 01 00 00 00 0f 05 <48> 3d 01 f0 ff ff 73 31 c3 48 83 ec 08 e8 ae fc ff ff 48 89 04 24
Jan 25 08:19:21 tani kernel: [  481.082502] RSP: 002b:00007ffea85dff38 EFLAGS: 00000246 ORIG_RAX: 0000000000000001
Jan 25 08:19:21 tani kernel: [  481.082504] RAX: ffffffffffffffda RBX: 00007ffea85dff80 RCX: 00007f34516ca190
Jan 25 08:19:21 tani kernel: [  481.082504] RDX: 0000000000002000 RSI: 0000565195078000 RDI: 0000000000000003
Jan 25 08:19:21 tani kernel: [  481.082505] RBP: 0000000000026411 R08: 00007f3450e19700 R09: 00007f3450e18520
Jan 25 08:19:21 tani kernel: [  481.082505] R10: 00007ffea85dff20 R11: 0000000000000246 R12: 0000000000000412
Jan 25 08:19:21 tani kernel: [  481.082506] R13: 00007ffea85dff80 R14: 00007ffea85dff60 R15: 0000565195078000
Jan 25 08:19:21 tani kernel: [  481.082507] ---[ end trace c733fae4edf212ce ]---

