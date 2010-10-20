From: "Smets, Jan (Jan)" <jan.smets@alcatel-lucent.com>
Subject: Inode to bdi  issue?
Date: Wed, 20 Oct 2010 15:03:00 +0200
Message-ID: <14C7F4F06DB5814AB0DE29716C4F6D670EB36236@FRMRSSXCHMBSB1.dc-m.alcatel-lucent.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
To: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hi list

Just a quick cut 'n paste report from my dmesg. Let me know if I can help any furter.

2.6.36~rc6

PS: I think this is identical to the problem reported on 23/09 "Dirtiable inode bdi default != sb bdi btrfs", and might already be fixed in rc6+ , but there are some other traces in here, so I just want to make sure it's all covered :-)

Thanks !

- Jan



[    8.928947] device fsid a147a59b79cb5a8a-a2dba068dd650bbc devid 1 transid 391 /dev/sda6
[    8.943753] device fsid 5c492fd3ca1ab13b-dafe2a63335708b1 devid 1 transid 285 /dev/sdb2
[    8.946699] device fsid 5c492fd3ca1ab13b-dafe2a63335708b1 devid 1 transid 285 /dev/sdb2
[  571.226110] device fsid 43491c1040626f7c-ba5c18b574ff238a devid 1 transid 7 /dev/sda6
[  571.238467] device fsid 5c492fd3ca1ab13b-dafe2a63335708b1 devid 1 transid 291 /dev/sdb2
[  571.252287] device fsid 43491c1040626f7c-ba5c18b574ff238a devid 1 transid 7 /dev/sda6
[  571.265261] ------------[ cut here ]------------
[  571.265267] WARNING: at /build/buildd-linux-2.6_2.6.36~rc6-1~experimental.1-amd64-GyrsOW/linux-2.6-2.6.36~rc6/debian/build/source_amd64_none/fs/fs-writeback.c:87 inode_to_bdi+0x55/0x5e()
[  571.265270] Hardware name: X7SBi-LN4
[  571.265271] Dirtiable inode bdi default != sb bdi btrfs
[  571.265272] Modules linked in: fuse bonding loop radeon ttm e1000e it8213 drm_kms_helper snd_pcm snd_timer ide_core drm i2c_algo_bit i2c_i801 shpchp tpm_tis tpm snd soundcore snd_page_alloc pci_hotplug tpm_bios i3200_edac edac_core i2c_core parport_pc video parport output ghes pcspkr hed evdev container processor button serio_raw ext4 mbcache jbd2 crc16 btrfs zlib_deflate crc32c libcrc32c sd_mod crc_t10dif ata_generic ata_piix libata scsi_mod thermal thermal_sys
[  571.265304] Pid: 2873, comm: chown Not tainted 2.6.36-rc6-amd64 #1
[  571.265306] Call Trace:
[  571.265310]  [<ffffffff810444a0>] ? warn_slowpath_common+0x78/0x8c
[  571.265313]  [<ffffffff81044553>] ? warn_slowpath_fmt+0x45/0x4a
[  571.265326]  [<ffffffffa015db5a>] ? __btrfs_end_transaction+0x18d/0x1a8 [btrfs]
[  571.265329]  [<ffffffff81106a51>] ? inode_to_bdi+0x55/0x5e
[  571.265331]  [<ffffffff81107c56>] ? __mark_inode_dirty+0xc0/0x185
[  571.265341]  [<ffffffffa016789d>] ? btrfs_setattr+0x1fb/0x230 [btrfs]
[  571.265344]  [<ffffffff81048a86>] ? current_fs_time+0x1e/0x24
[  571.265347]  [<ffffffff810ff1a5>] ? notify_change+0x195/0x27e
[  571.265350]  [<ffffffff810eb7b8>] ? chown_common+0x8a/0xa1
[  571.265352]  [<ffffffff810eb918>] ? sys_fchownat+0x51/0x80
[  571.265356]  [<ffffffff8130c915>] ? page_fault+0x25/0x30
[  571.265358]  [<ffffffff81008a02>] ? system_call_fastpath+0x16/0x1b
[  571.265360] ---[ end trace d70c205a10708c10 ]---
[  571.315394] ------------[ cut here ]------------

[  571.315394] ------------[ cut here ]------------
[  571.315400] WARNING: at /build/buildd-linux-2.6_2.6.36~rc6-1~experimental.1-amd64-GyrsOW/linux-2.6-2.6.36~rc6/debian/build/source_amd64_none/fs/fs-writeback.c:87 inode_to_bdi+0x55/0x5e()
[  571.315403] Hardware name: X7SBi-LN4
[  571.315404] Dirtiable inode bdi default != sb bdi btrfs
[  571.315406] Modules linked in: fuse bonding loop radeon ttm e1000e it8213 drm_kms_helper snd_pcm snd_timer ide_core drm i2c_algo_bit i2c_i801 shpchp tpm_tis tpm snd soundcore snd_page_alloc pci_hotplug tpm_bios i3200_edac edac_core i2c_core parport_pc video parport output ghes pcspkr hed evdev container processor button serio_raw ext4 mbcache jbd2 crc16 btrfs zlib_deflate crc32c libcrc32c sd_mod crc_t10dif ata_generic ata_piix libata scsi_mod thermal thermal_sys
[  571.315437] Pid: 2877, comm: cosd Tainted: G        W   2.6.36-rc6-amd64 #1
[  571.315438] Call Trace:
[  571.315443]  [<ffffffff810444a0>] ? warn_slowpath_common+0x78/0x8c
[  571.315446]  [<ffffffff81044553>] ? warn_slowpath_fmt+0x45/0x4a
[  571.315458]  [<ffffffffa015db5a>] ? __btrfs_end_transaction+0x18d/0x1a8 [btrfs]
[  571.315461]  [<ffffffff81106a51>] ? inode_to_bdi+0x55/0x5e
[  571.315464]  [<ffffffff81107c56>] ? __mark_inode_dirty+0xc0/0x185
[  571.315474]  [<ffffffffa016789d>] ? btrfs_setattr+0x1fb/0x230 [btrfs]
[  571.315477]  [<ffffffff81048a86>] ? current_fs_time+0x1e/0x24
[  571.315479]  [<ffffffff810ff1a5>] ? notify_change+0x195/0x27e
[  571.315483]  [<ffffffff810eba52>] ? sys_fchmodat+0x96/0xcd
[  571.315485]  [<ffffffff81008a02>] ? system_call_fastpath+0x16/0x1b
[  571.315487] ---[ end trace d70c205a10708c11 ]---
[  571.564353] device fsid 43491c1040626f7c-ba5c18b574ff238a devid 1 transid 11 /dev/sda6
[  571.634595] device fsid 1b46d5b4fb269fde-1596a386ec6aceac devid 1 transid 7 /dev/sdb2
[  571.674567] device fsid 1b46d5b4fb269fde-1596a386ec6aceac devid 1 transid 7 /dev/sdb2

[  571.677483] ------------[ cut here ]------------
[  571.677490] WARNING: at /build/buildd-linux-2.6_2.6.36~rc6-1~experimental.1-amd64-GyrsOW/linux-2.6-2.6.36~rc6/debian/build/source_amd64_none/fs/fs-writeback.c:87 inode_to_bdi+0x55/0x5e()
[  571.677492] Hardware name: X7SBi-LN4
[  571.677494] Dirtiable inode bdi default != sb bdi btrfs
[  571.677495] Modules linked in: fuse bonding loop radeon ttm e1000e it8213 drm_kms_helper snd_pcm snd_timer ide_core drm i2c_algo_bit i2c_i801 shpchp tpm_tis tpm snd soundcore snd_page_alloc pci_hotplug tpm_bios i3200_edac edac_core i2c_core parport_pc video parport output ghes pcspkr hed evdev container processor button serio_raw ext4 mbcache jbd2 crc16 btrfs zlib_deflate crc32c libcrc32c sd_mod crc_t10dif ata_generic ata_piix libata scsi_mod thermal thermal_sys
[  571.677526] Pid: 2938, comm: chown Tainted: G        W   2.6.36-rc6-amd64 #1
[  571.677528] Call Trace:
[  571.677533]  [<ffffffff810444a0>] ? warn_slowpath_common+0x78/0x8c
[  571.677535]  [<ffffffff81044553>] ? warn_slowpath_fmt+0x45/0x4a
[  571.677547]  [<ffffffffa015db5a>] ? __btrfs_end_transaction+0x18d/0x1a8 [btrfs]
[  571.677551]  [<ffffffff81106a51>] ? inode_to_bdi+0x55/0x5e
[  571.677553]  [<ffffffff81107c56>] ? __mark_inode_dirty+0xc0/0x185
[  571.677563]  [<ffffffffa016789d>] ? btrfs_setattr+0x1fb/0x230 [btrfs]
[  571.677566]  [<ffffffff81048a86>] ? current_fs_time+0x1e/0x24
[  571.677569]  [<ffffffff810ff1a5>] ? notify_change+0x195/0x27e
[  571.677572]  [<ffffffff810eb7b8>] ? chown_common+0x8a/0xa1
[  571.677574]  [<ffffffff810eb918>] ? sys_fchownat+0x51/0x80
[  571.677578]  [<ffffffff8130c915>] ? page_fault+0x25/0x30
[  571.677580]  [<ffffffff81008a02>] ? system_call_fastpath+0x16/0x1b
[  571.677582] ---[ end trace d70c205a10708c12 ]---
[  571.762510] ------------[ cut here ]------------
[  571.762517] WARNING: at /build/buildd-linux-2.6_2.6.36~rc6-1~experimental.1-amd64-GyrsOW/linux-2.6-2.6.36~rc6/debian/build/source_amd64_none/fs/fs-writeback.c:87 inode_to_bdi+0x55/0x5e()
[  571.762519] Hardware name: X7SBi-LN4
[  571.762521] Dirtiable inode bdi default != sb bdi btrfs
[  571.762522] Modules linked in: fuse bonding loop radeon ttm e1000e it8213 drm_kms_helper snd_pcm snd_timer ide_core drm i2c_algo_bit i2c_i801 shpchp tpm_tis tpm snd soundcore snd_page_alloc pci_hotplug tpm_bios i3200_edac edac_core i2c_core parport_pc video parport output ghes pcspkr hed evdev container processor button serio_raw ext4 mbcache jbd2 crc16 btrfs zlib_deflate crc32c libcrc32c sd_mod crc_t10dif ata_generic ata_piix libata scsi_mod thermal thermal_sys
[  571.762553] Pid: 2942, comm: cosd Tainted: G        W   2.6.36-rc6-amd64 #1
[  571.762555] Call Trace:
[  571.762560]  [<ffffffff810444a0>] ? warn_slowpath_common+0x78/0x8c
[  571.762562]  [<ffffffff81044553>] ? warn_slowpath_fmt+0x45/0x4a
[  571.762574]  [<ffffffffa015db5a>] ? __btrfs_end_transaction+0x18d/0x1a8 [btrfs]
[  571.762577]  [<ffffffff81106a51>] ? inode_to_bdi+0x55/0x5e
[  571.762580]  [<ffffffff81107c56>] ? __mark_inode_dirty+0xc0/0x185
[  571.762590]  [<ffffffffa016789d>] ? btrfs_setattr+0x1fb/0x230 [btrfs]
[  571.762593]  [<ffffffff81048a86>] ? current_fs_time+0x1e/0x24
[  571.762596]  [<ffffffff810ff1a5>] ? notify_change+0x195/0x27e
[  571.762599]  [<ffffffff810eba52>] ? sys_fchmodat+0x96/0xcd
[  571.762602]  [<ffffffff81008a02>] ? system_call_fastpath+0x16/0x1b
[  571.762603] ---[ end trace d70c205a10708c13 ]---
[  591.944084] device fsid 43491c1040626f7c-ba5c18b574ff238a devid 1 transid 14 /dev/sda6
[  591.944989] device fsid 1b46d5b4fb269fde-1596a386ec6aceac devid 1 transid 14 /dev/sdb2
[  591.955426] device fsid 43491c1040626f7c-ba5c18b574ff238a devid 1 transid 14 /dev/sda6
[  592.031036] device fsid 43491c1040626f7c-ba5c18b574ff238a devid 1 transid 16 /dev/sda6
[  592.052607] device fsid 1b46d5b4fb269fde-1596a386ec6aceac devid 1 transid 14 /dev/sdb2
[  592.055689] device fsid 1b46d5b4fb269fde-1596a386ec6aceac devid 1 transid 14 /dev/sdb2