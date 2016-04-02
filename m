Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lb0-f182.google.com ([209.85.217.182]:34114 "EHLO
	mail-lb0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752392AbcDBKYq (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sat, 2 Apr 2016 06:24:46 -0400
Received: by mail-lb0-f182.google.com with SMTP id vo2so94220321lbb.1
        for <linux-btrfs@vger.kernel.org>; Sat, 02 Apr 2016 03:24:45 -0700 (PDT)
Received: from mail-lf0-f53.google.com (mail-lf0-f53.google.com. [209.85.215.53])
        by smtp.gmail.com with ESMTPSA id m141sm2966413lfb.12.2016.04.02.03.24.43
        for <linux-btrfs@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 02 Apr 2016 03:24:44 -0700 (PDT)
Received: by mail-lf0-f53.google.com with SMTP id g184so30277820lfb.3
        for <linux-btrfs@vger.kernel.org>; Sat, 02 Apr 2016 03:24:43 -0700 (PDT)
MIME-Version: 1.0
From: Jarno Elonen <elonen@iki.fi>
Date: Sat, 2 Apr 2016 13:24:14 +0300
Message-ID: <CAL3dRBVCNMf4rFaMKyJNTAuZfU+0Ngq3OYRmMrJEvmuZ2td--A@mail.gmail.com>
Subject: Non-mountable FS (raid10, can't read superblock / corrupt leaf /
 open_ctree failed)
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

I've got a big BTRFS raid10 set that fails to mount. I'm currently
running "btrfs restore" on the most important stuff, but would
appreciate any ideas on how to fix the FS gracefully.

# btrfs de scan
# mount -o clear_cache,recovery,degraded /dev/sdh1 /mnt/raid/
mount: /dev/sdh1: can't read superblock


The FS consists of 8 disks:

# btrfs fi show
Label: 'btrfs-raid'  uuid: 8b5b4aa6-c3c6-4db0-9ead-df93812e51bc
        Total devices 8 FS bytes used 9.26TiB
        devid    4 size 2.73TiB used 2.34TiB path /dev/sdi1
        devid    5 size 2.73TiB used 2.34TiB path /dev/sdj1
        devid    7 size 2.73TiB used 2.34TiB path /dev/sdc1
        devid    9 size 3.64TiB used 2.34TiB path /dev/sdh1
        devid   11 size 2.73TiB used 2.34TiB path /dev/sda1
        devid   16 size 2.73TiB used 2.34TiB path /dev/sdk1
        devid   17 size 2.73TiB used 2.34TiB path /dev/sdl1
        devid   18 size 3.64TiB used 2.34TiB path /dev/sdd1


Software versions are pretty recent:

# uname -a
Linux serv-archive 4.4.0-1-amd64 #1 SMP Debian 4.4.6-1 (2016-03-17)
x86_64 GNU/Linux

# btrfs version
btrfs-progs v4.4


Errors don't *look* that bad...

 # btrfsck -p /dev/sda1

 Checking filesystem on /dev/sda1
 UUID: 8b5b4aa6-c3c6-4db0-9ead-df93812e51bc
 bad key ordering 173 174
 bad block 103797139668992

 Errors found in extent allocation tree or chunk allocation
 block group 98636232261632 has wrong amount of free space
 failed to load free space cache for block group 98636232261632
 checking free space cache [o]
 checking fs roots [.]
    (...havent's seen this through, takes forever)

 # btrfsck -s 2 -p /dev/sda1

 using SB copy 2, bytenr 274877906944
 Checking filesystem on /dev/sda1
 UUID: 8b5b4aa6-c3c6-4db0-9ead-df93812e51bc
 bad key ordering 173 174
 bad block 103797139668992

 Errors found in extent allocation tree or chunk allocation
 block group 98636232261632 has wrong amount of free space
 failed to load free space cache for block group 98636232261632
 checking free space cache [o]
 checking fs roots [o]


...but mount attempts show "corrupt leaf, bad key" and end in "BTRFS:
open_ctree failed":

# dmesg

...

[   13.156643] Btrfs loaded
[   13.228545] BTRFS: device label btrfs-raid devid 17 transid
15891267 /dev/sdl1
[   13.228606] BTRFS: device label btrfs-raid devid 16 transid
15891267 /dev/sdk1
[   13.228666] BTRFS: device label btrfs-raid devid 5 transid 15891267 /dev/sdj1
[   13.228723] BTRFS: device label btrfs-raid devid 4 transid 15891267 /dev/sdi1
[   13.228799] BTRFS: device label btrfs-raid devid 9 transid 15891267 /dev/sdh1
[   13.228858] BTRFS: device label btrfs-raid devid 18 transid
15891267 /dev/sdd1
[   13.228920] BTRFS: device label btrfs-raid devid 7 transid 15891267 /dev/sdc1
[   13.228977] BTRFS: device label btrfs-raid devid 11 transid
15891267 /dev/sda1

...

[  191.183172] BTRFS info (device sda1): force clearing of disk cache
[  191.183181] BTRFS info (device sda1): enabling auto recovery
[  191.183184] BTRFS info (device sda1): allowing degraded mounts
[  191.183188] BTRFS info (device sda1): disk space caching is enabled
[  192.057675] BTRFS info (device sda1): bdev /dev/sdi1 errs: wr 0, rd
0, flush 0, corrupt 10, gen 0
[  192.057678] BTRFS info (device sda1): bdev /dev/sdj1 errs: wr 0, rd
7, flush 0, corrupt 20, gen 0
[  210.226357] BTRFS critical (device sda1): corrupt leaf, bad key
order: block=103797139668992,root=1, slot=173
[  210.226535] BTRFS critical (device sda1): corrupt leaf, bad key
order: block=103797139668992,root=1, slot=173
[  210.236768] BTRFS critical (device sda1): corrupt leaf, bad key
order: block=103797139668992,root=1, slot=173
[  210.263439] BTRFS critical (device sda1): corrupt leaf, bad key
order: block=103797139668992,root=1, slot=173
[  210.263447] ------------[ cut here ]------------
[  210.263464] WARNING: CPU: 1 PID: 118 at
/build/linux-dFNWCu/linux-4.4.6/fs/btrfs/extent-tree.c:6552
__btrfs_free_extent.isra.70+0x314/0xd70 [btrfs]()
[  210.263465] BTRFS: Transaction aborted (error -5)
[  210.263466] Modules linked in: nfsd auth_rpcgss oid_registry
nfs_acl nfs lockd grace fscache sunrpc intel_rapl iosf_mbi
x86_pkg_temp_thermal intel_powerclamp kvm_intel kvm irqbypass
crct10dif_pclmul crc32_pclmul iTCO_wdt iTCO_vendor_support eeepc_wmi
asus_wmi sparse_keymap rfkill sha256_ssse3 sha256_generic hmac drbg
ansi_cprng aesni_intel aes_x86_64 lrw gf128mul glue_helper ablk_helper
cryptd psmouse pcspkr nouveau serio_raw i2c_i801 mxm_wmi lpc_ich ttm
mfd_core drm_kms_helper drm option huawei_cdc_ncm cdc_wdm usb_wwan
cdc_ncm usbnet joydev evdev mei_me mii usbserial shpchp mei
8250_fintek battery wmi video tpm_infineon button tpm_tis tpm
processor coretemp loop autofs4 ext4 crc16 mbcache jbd2 btrfs xor
raid6_pq dm_mod osst st ch sr_mod cdrom hid_generic usbhid hid sg
sd_mod uas usb_storage crc32c_intel
[  210.263497]  ahci libahci firewire_ohci mpt3sas raid_class
scsi_transport_sas igb i2c_algo_bit dca ptp ehci_pci pps_core ehci_hcd
firewire_core xhci_pci crc_itu_t libata xhci_hcd scsi_mod usbcore
usb_common fjes fan thermal
[  210.263506] CPU: 1 PID: 118 Comm: kworker/u8:4 Not tainted
4.4.0-1-amd64 #1 Debian 4.4.6-1
[  210.263507] Hardware name: ASUS All Series/Z87-WS, BIOS 2004 06/05/2014
[  210.263517] Workqueue: btrfs-extent-refs btrfs_extent_refs_helper [btrfs]
[  210.263518]  0000000000000286 00000000812d62de ffffffff812ea865
ffff880408987b20
[  210.263519]  ffffffffa03dd468 ffffffff810774fd 000059b651a58000
ffff880408987b78
[  210.263521]  0000000000000000 ffff88040aa87000 ffff880408d6a000
ffffffff8107758c
[  210.263522] Call Trace:
[  210.263526]  [<ffffffff812ea865>] ? dump_stack+0x5c/0x77
[  210.263528]  [<ffffffff810774fd>] ? warn_slowpath_common+0x7d/0xb0
[  210.263529]  [<ffffffff8107758c>] ? warn_slowpath_fmt+0x5c/0x80
[  210.263536]  [<ffffffffa03408d4>] ?
__btrfs_free_extent.isra.70+0x314/0xd70 [btrfs]
[  210.263543]  [<ffffffffa0344761>] ?
__btrfs_run_delayed_refs+0x4c1/0x11c0 [btrfs]
[  210.263551]  [<ffffffffa0348198>] ? btrfs_run_delayed_refs+0x78/0x2a0 [btrfs]
[  210.263557]  [<ffffffffa03483f2>] ? delayed_ref_async_start+0x32/0x80 [btrfs]
[  210.263566]  [<ffffffffa038e058>] ?
btrfs_scrubparity_helper+0xc8/0x2d0 [btrfs]
[  210.263568]  [<ffffffff8108ed47>] ? process_one_work+0x157/0x410
[  210.263569]  [<ffffffff8108f04d>] ? worker_thread+0x4d/0x450
[  210.263570]  [<ffffffff8108f000>] ? process_one_work+0x410/0x410
[  210.263572]  [<ffffffff81094ddd>] ? kthread+0xcd/0xf0
[  210.263574]  [<ffffffff81094d10>] ? kthread_create_on_node+0x190/0x190
[  210.263576]  [<ffffffff8158efcf>] ? ret_from_fork+0x3f/0x70
[  210.263578]  [<ffffffff81094d10>] ? kthread_create_on_node+0x190/0x190
[  210.263579] ---[ end trace 089d9efc392111fa ]---
[  210.263580] BTRFS: error (device sda1) in __btrfs_free_extent:6552:
errno=-5 IO failure
[  210.263585] BTRFS: error (device sda1) in
btrfs_run_delayed_refs:2927: errno=-5 IO failure
[  210.263639] BTRFS: error (device sda1) in btrfs_replay_log:2401:
errno=-5 IO failure (Failed to recover log tree)
[  210.263760] pending csums is 458752
[  210.263825] BTRFS error (device sda1): cleaner transaction attach
returned -30
[  245.519916] BTRFS critical (device sda1): corrupt leaf, bad key
order: block=103797139668992,root=1, slot=173
[  245.519951] ------------[ cut here ]------------
[  245.519979] WARNING: CPU: 0 PID: 3127 at
/build/linux-dFNWCu/linux-4.4.6/fs/btrfs/extent-tree.c:136
btrfs_put_block_group+0x5a/0x60 [btrfs]()
[  245.519980] Modules linked in: nfsd auth_rpcgss oid_registry
nfs_acl nfs lockd grace fscache sunrpc intel_rapl iosf_mbi
x86_pkg_temp_thermal intel_powerclamp kvm_intel kvm irqbypass
crct10dif_pclmul crc32_pclmul iTCO_wdt iTCO_vendor_support eeepc_wmi
asus_wmi sparse_keymap rfkill sha256_ssse3 sha256_generic hmac drbg
ansi_cprng aesni_intel aes_x86_64 lrw gf128mul glue_helper ablk_helper
cryptd psmouse pcspkr nouveau serio_raw i2c_i801 mxm_wmi lpc_ich ttm
mfd_core drm_kms_helper drm option huawei_cdc_ncm cdc_wdm usb_wwan
cdc_ncm usbnet joydev evdev mei_me mii usbserial shpchp mei
8250_fintek battery wmi video tpm_infineon button tpm_tis tpm
processor coretemp loop autofs4 ext4 crc16 mbcache jbd2 btrfs xor
raid6_pq dm_mod osst st ch sr_mod cdrom hid_generic usbhid hid sg
sd_mod uas usb_storage crc32c_intel
[  245.520010]  ahci libahci firewire_ohci mpt3sas raid_class
scsi_transport_sas igb i2c_algo_bit dca ptp ehci_pci pps_core ehci_hcd
firewire_core xhci_pci crc_itu_t libata xhci_hcd scsi_mod usbcore
usb_common fjes fan thermal
[  245.520019] CPU: 0 PID: 3127 Comm: mount Tainted: G        W
4.4.0-1-amd64 #1 Debian 4.4.6-1
[  245.520020] Hardware name: ASUS All Series/Z87-WS, BIOS 2004 06/05/2014
[  245.520020]  0000000000000286 0000000062978552 ffffffff812ea865
0000000000000000
[  245.520022]  ffffffffa03dd468 ffffffff810774fd ffff8803f89fb200
ffff8803f89fb200
[  245.520023]  ffff880408d6a080 ffff880408d6a000 ffff880408d6a090
ffffffffa033fd2a
[  245.520025] Call Trace:
[  245.520029]  [<ffffffff812ea865>] ? dump_stack+0x5c/0x77
[  245.520032]  [<ffffffff810774fd>] ? warn_slowpath_common+0x7d/0xb0
[  245.520039]  [<ffffffffa033fd2a>] ? btrfs_put_block_group+0x5a/0x60 [btrfs]
[  245.520046]  [<ffffffffa0347546>] ?
btrfs_free_block_groups+0xd6/0x3d0 [btrfs]
[  245.520054]  [<ffffffffa035a517>] ? open_ctree+0x1b07/0x2470 [btrfs]
[  245.520061]  [<ffffffffa032f69c>] ? btrfs_mount+0x8ec/0xa00 [btrfs]
[  245.520063]  [<ffffffff8118897b>] ? pcpu_next_unpop+0x3b/0x50
[  245.520065]  [<ffffffff811dafe6>] ? mount_fs+0x36/0x160
[  245.520066]  [<ffffffff811f5e42>] ? vfs_kern_mount+0x62/0x100
[  245.520072]  [<ffffffffa032ef6b>] ? btrfs_mount+0x1bb/0xa00 [btrfs]
[  245.520074]  [<ffffffff8118897b>] ? pcpu_next_unpop+0x3b/0x50
[  245.520075]  [<ffffffff81189902>] ? pcpu_alloc+0x392/0x6a0
[  245.520077]  [<ffffffff811dafe6>] ? mount_fs+0x36/0x160
[  245.520078]  [<ffffffff811f5e42>] ? vfs_kern_mount+0x62/0x100
[  245.520079]  [<ffffffff811f834c>] ? do_mount+0x22c/0xd40
[  245.520081]  [<ffffffff811f918a>] ? SyS_mount+0x9a/0xf0
[  245.520083]  [<ffffffff8158ec32>] ? system_call_fast_compare_end+0xc/0x67
[  245.520084] ---[ end trace 089d9efc392111fb ]---
[  245.555010] BTRFS: open_ctree failed



========================================================================
========================================================================



# btrfs-show-super /dev/sda1 -f -a

---------------------------------------------------------
csum                    0xad9f65db [match]
bytenr                  65536
flags                   0x1
                        ( WRITTEN )
magic                   _BHRfS_M [match]
fsid                    8b5b4aa6-c3c6-4db0-9ead-df93812e51bc
label                   btrfs-raid
generation              15891267
root                    103797496037376
sys_array_size          321
chunk_root_generation   15890014
root_level              1
chunk_root              98481546395648
chunk_root_level        1
log_root                103797444984832
log_root_transid        0
log_root_level          0
total_bytes             26005118910464
bytes_used              10185173540864
sectorsize              4096
nodesize                16384
leafsize                16384
stripesize              4096
root_dir                6
num_devices             8
compat_flags            0x0
compat_ro_flags         0x0
incompat_flags          0x69
                        ( MIXED_BACKREF |
                          COMPRESS_LZO |
                          BIG_METADATA |
                          EXTENDED_IREF )
csum_type               0
csum_size               4
cache_generation        15891267
uuid_tree_generation    15891267
dev_item.uuid           df4c61f5-1e77-4e03-8d4a-6301a04d0b3c
dev_item.fsid           8b5b4aa6-c3c6-4db0-9ead-df93812e51bc [match]
dev_item.type           0
dev_item.total_bytes    3000591450112
dev_item.bytes_used     2569480962048
dev_item.io_align       4096
dev_item.io_width       4096
dev_item.sector_size    4096
dev_item.devid          11
dev_item.dev_group      0
dev_item.seek_speed     0
dev_item.bandwidth      0
dev_item.generation     0
sys_chunk_array[2048]:
        item 0 key (FIRST_CHUNK_TREE CHUNK_ITEM 98481546330112)
                chunk length 67108864 owner 2 stripe_len 65536
                type SYSTEM|RAID10 num_stripes 8
                        stripe 0 devid 18 offset 1025424490496
                        dev uuid: fca3ed49-de9a-4525-8848-7b9c494045bd
                        stripe 1 devid 17 offset 1025424490496
                        dev uuid: 552340b0-4218-4197-848f-f631acc658f2
                        stripe 2 devid 16 offset 426108780544
                        dev uuid: 96025eea-b4fe-4ae8-9d08-9f8a1fdbb784
                        stripe 3 devid 9 offset 205119291392
                        dev uuid: 191414fb-6c9c-45bb-8490-87d4317fb0db
                        stripe 4 devid 7 offset 181463416832
                        dev uuid: 9143bdf3-ec10-4048-8c14-2f9e51dfa2dd
                        stripe 5 devid 4 offset 6443499520
                        dev uuid: 6c68d643-4a49-48ba-8d1a-e320bd290af3
                        stripe 6 devid 11 offset 20435697664
                        dev uuid: df4c61f5-1e77-4e03-8d4a-6301a04d0b3c
                        stripe 7 devid 5 offset 5369757696
                        dev uuid: 23438b70-6c1d-4f9a-8703-c5d00038d55f
backup_roots[4]:
        backup 0:
                backup_tree_root:       103797424144384 gen: 15891265   level: 1
                backup_chunk_root:      98481546395648  gen: 15890014   level: 1
                backup_extent_root:     103797407514624 gen: 15891265   level: 2
                backup_fs_root:         102098872401920 gen: 15872333   level: 0
                backup_dev_root:        103797478162432 gen: 15890014   level: 1
                backup_csum_root:       103797398618112 gen: 15891265   level: 3
                backup_total_bytes:     26005118910464
                backup_bytes_used:      10185172480000
                backup_num_devices:     8

        backup 1:
                backup_tree_root:       103797398749184 gen: 15891266   level: 1
                backup_chunk_root:      98481546395648  gen: 15890014   level: 1
                backup_extent_root:     103797452177408 gen: 15891267   level: 2
                backup_fs_root:         102098872401920 gen: 15872333   level: 0
                backup_dev_root:        103797478162432 gen: 15890014   level: 1
                backup_csum_root:       103797411266560 gen: 15891267   level: 3
                backup_total_bytes:     26005118910464
                backup_bytes_used:      10185173540864
                backup_num_devices:     8

        backup 2:
                backup_tree_root:       103797496037376 gen: 15891267   level: 1
                backup_chunk_root:      98481546395648  gen: 15890014   level: 1
                backup_extent_root:     103797430976512 gen: 15891268   level: 2
                backup_fs_root:         102098872401920 gen: 15872333   level: 0
                backup_dev_root:        103797478162432 gen: 15890014   level: 1
                backup_csum_root:       103797424144384 gen: 15891268   level: 3
                backup_total_bytes:     26005118910464
                backup_bytes_used:      10185173442560
                backup_num_devices:     8

        backup 3:
                backup_tree_root:       103797410758656 gen: 15891264   level: 1
                backup_chunk_root:      98481546395648  gen: 15890014   level: 1
                backup_extent_root:     103797409267712 gen: 15891264   level: 2
                backup_fs_root:         102098872401920 gen: 15872333   level: 0
                backup_dev_root:        103797478162432 gen: 15890014   level: 1
                backup_csum_root:       103797401976832 gen: 15891264   level: 3
                backup_total_bytes:     26005118910464
                backup_bytes_used:      10184586289152
                backup_num_devices:     8


superblock: bytenr=67108864, device=/dev/sda1
---------------------------------------------------------
csum                    0x67cb727e [match]
bytenr                  67108864
flags                   0x1
                        ( WRITTEN )
magic                   _BHRfS_M [match]
fsid                    8b5b4aa6-c3c6-4db0-9ead-df93812e51bc
label                   btrfs-raid
generation              15891267
root                    103797496037376
sys_array_size          321
chunk_root_generation   15890014
root_level              1
chunk_root              98481546395648
chunk_root_level        1
log_root                0
log_root_transid        0
log_root_level          0
total_bytes             26005118910464
bytes_used              10185173540864
sectorsize              4096
nodesize                16384
leafsize                16384
stripesize              4096
root_dir                6
num_devices             8
compat_flags            0x0
compat_ro_flags         0x0
incompat_flags          0x69
                        ( MIXED_BACKREF |
                          COMPRESS_LZO |
                          BIG_METADATA |
                          EXTENDED_IREF )
csum_type               0
csum_size               4
cache_generation        15891267
uuid_tree_generation    15891267
dev_item.uuid           df4c61f5-1e77-4e03-8d4a-6301a04d0b3c
dev_item.fsid           8b5b4aa6-c3c6-4db0-9ead-df93812e51bc [match]
dev_item.type           0
dev_item.total_bytes    3000591450112
dev_item.bytes_used     2569480962048
dev_item.io_align       4096
dev_item.io_width       4096
dev_item.sector_size    4096
dev_item.devid          11
dev_item.dev_group      0
dev_item.seek_speed     0
dev_item.bandwidth      0
dev_item.generation     0
sys_chunk_array[2048]:
        item 0 key (FIRST_CHUNK_TREE CHUNK_ITEM 98481546330112)
                chunk length 67108864 owner 2 stripe_len 65536
                type SYSTEM|RAID10 num_stripes 8
                        stripe 0 devid 18 offset 1025424490496
                        dev uuid: fca3ed49-de9a-4525-8848-7b9c494045bd
                        stripe 1 devid 17 offset 1025424490496
                        dev uuid: 552340b0-4218-4197-848f-f631acc658f2
                        stripe 2 devid 16 offset 426108780544
                        dev uuid: 96025eea-b4fe-4ae8-9d08-9f8a1fdbb784
                        stripe 3 devid 9 offset 205119291392
                        dev uuid: 191414fb-6c9c-45bb-8490-87d4317fb0db
                        stripe 4 devid 7 offset 181463416832
                        dev uuid: 9143bdf3-ec10-4048-8c14-2f9e51dfa2dd
                        stripe 5 devid 4 offset 6443499520
                        dev uuid: 6c68d643-4a49-48ba-8d1a-e320bd290af3
                        stripe 6 devid 11 offset 20435697664
                        dev uuid: df4c61f5-1e77-4e03-8d4a-6301a04d0b3c
                        stripe 7 devid 5 offset 5369757696
                        dev uuid: 23438b70-6c1d-4f9a-8703-c5d00038d55f
backup_roots[4]:
        backup 0:
                backup_tree_root:       103797424144384 gen: 15891265   level: 1
                backup_chunk_root:      98481546395648  gen: 15890014   level: 1
                backup_extent_root:     103797407514624 gen: 15891265   level: 2
                backup_fs_root:         102098872401920 gen: 15872333   level: 0
                backup_dev_root:        103797478162432 gen: 15890014   level: 1
                backup_csum_root:       103797398618112 gen: 15891265   level: 3
                backup_total_bytes:     26005118910464
                backup_bytes_used:      10185172480000
                backup_num_devices:     8

        backup 1:
                backup_tree_root:       103797398749184 gen: 15891266   level: 1
                backup_chunk_root:      98481546395648  gen: 15890014   level: 1
                backup_extent_root:     103797452177408 gen: 15891267   level: 2
                backup_fs_root:         102098872401920 gen: 15872333   level: 0
                backup_dev_root:        103797478162432 gen: 15890014   level: 1
                backup_csum_root:       103797411266560 gen: 15891267   level: 3
                backup_total_bytes:     26005118910464
                backup_bytes_used:      10185173540864
                backup_num_devices:     8

        backup 2:
                backup_tree_root:       103797496037376 gen: 15891267   level: 1
                backup_chunk_root:      98481546395648  gen: 15890014   level: 1
                backup_extent_root:     103797452177408 gen: 15891267   level: 2
                backup_fs_root:         102098872401920 gen: 15872333   level: 0
                backup_dev_root:        103797478162432 gen: 15890014   level: 1
                backup_csum_root:       103797411266560 gen: 15891267   level: 3
                backup_total_bytes:     26005118910464
                backup_bytes_used:      10185173540864
                backup_num_devices:     8

        backup 3:
                backup_tree_root:       103797410758656 gen: 15891264   level: 1
                backup_chunk_root:      98481546395648  gen: 15890014   level: 1
                backup_extent_root:     103797409267712 gen: 15891264   level: 2
                backup_fs_root:         102098872401920 gen: 15872333   level: 0
                backup_dev_root:        103797478162432 gen: 15890014   level: 1
                backup_csum_root:       103797401976832 gen: 15891264   level: 3
                backup_total_bytes:     26005118910464
                backup_bytes_used:      10184586289152
                backup_num_devices:     8


superblock: bytenr=274877906944, device=/dev/sda1
---------------------------------------------------------
csum                    0x9a4c244f [match]
bytenr                  274877906944
flags                   0x1
                        ( WRITTEN )
magic                   _BHRfS_M [match]
fsid                    8b5b4aa6-c3c6-4db0-9ead-df93812e51bc
label                   btrfs-raid
generation              15891267
root                    103797496037376
sys_array_size          321
chunk_root_generation   15890014
root_level              1
chunk_root              98481546395648
chunk_root_level        1
log_root                0
log_root_transid        0
log_root_level          0
total_bytes             26005118910464
bytes_used              10185173540864
sectorsize              4096
nodesize                16384
leafsize                16384
stripesize              4096
root_dir                6
num_devices             8
compat_flags            0x0
compat_ro_flags         0x0
incompat_flags          0x69
                        ( MIXED_BACKREF |
                          COMPRESS_LZO |
                          BIG_METADATA |
                          EXTENDED_IREF )
csum_type               0
csum_size               4
cache_generation        15891267
uuid_tree_generation    15891267
dev_item.uuid           df4c61f5-1e77-4e03-8d4a-6301a04d0b3c
dev_item.fsid           8b5b4aa6-c3c6-4db0-9ead-df93812e51bc [match]
dev_item.type           0
dev_item.total_bytes    3000591450112
dev_item.bytes_used     2569480962048
dev_item.io_align       4096
dev_item.io_width       4096
dev_item.sector_size    4096
dev_item.devid          11
dev_item.dev_group      0
dev_item.seek_speed     0
dev_item.bandwidth      0
dev_item.generation     0
sys_chunk_array[2048]:
        item 0 key (FIRST_CHUNK_TREE CHUNK_ITEM 98481546330112)
                chunk length 67108864 owner 2 stripe_len 65536
                type SYSTEM|RAID10 num_stripes 8
                        stripe 0 devid 18 offset 1025424490496
                        dev uuid: fca3ed49-de9a-4525-8848-7b9c494045bd
                        stripe 1 devid 17 offset 1025424490496
                        dev uuid: 552340b0-4218-4197-848f-f631acc658f2
                        stripe 2 devid 16 offset 426108780544
                        dev uuid: 96025eea-b4fe-4ae8-9d08-9f8a1fdbb784
                        stripe 3 devid 9 offset 205119291392
                        dev uuid: 191414fb-6c9c-45bb-8490-87d4317fb0db
                        stripe 4 devid 7 offset 181463416832
                        dev uuid: 9143bdf3-ec10-4048-8c14-2f9e51dfa2dd
                        stripe 5 devid 4 offset 6443499520
                        dev uuid: 6c68d643-4a49-48ba-8d1a-e320bd290af3
                        stripe 6 devid 11 offset 20435697664
                        dev uuid: df4c61f5-1e77-4e03-8d4a-6301a04d0b3c
                        stripe 7 devid 5 offset 5369757696
                        dev uuid: 23438b70-6c1d-4f9a-8703-c5d00038d55f
backup_roots[4]:
        backup 0:
                backup_tree_root:       103797424144384 gen: 15891265   level: 1
                backup_chunk_root:      98481546395648  gen: 15890014   level: 1
                backup_extent_root:     103797407514624 gen: 15891265   level: 2
                backup_fs_root:         102098872401920 gen: 15872333   level: 0
                backup_dev_root:        103797478162432 gen: 15890014   level: 1
                backup_csum_root:       103797398618112 gen: 15891265   level: 3
                backup_total_bytes:     26005118910464
                backup_bytes_used:      10185172480000
                backup_num_devices:     8

        backup 1:
                backup_tree_root:       103797398749184 gen: 15891266   level: 1
                backup_chunk_root:      98481546395648  gen: 15890014   level: 1
                backup_extent_root:     103797452177408 gen: 15891267   level: 2
                backup_fs_root:         102098872401920 gen: 15872333   level: 0
                backup_dev_root:        103797478162432 gen: 15890014   level: 1
                backup_csum_root:       103797411266560 gen: 15891267   level: 3
                backup_total_bytes:     26005118910464
                backup_bytes_used:      10185173540864
                backup_num_devices:     8

        backup 2:
                backup_tree_root:       103797496037376 gen: 15891267   level: 1
                backup_chunk_root:      98481546395648  gen: 15890014   level: 1
                backup_extent_root:     103797452177408 gen: 15891267   level: 2
                backup_fs_root:         102098872401920 gen: 15872333   level: 0
                backup_dev_root:        103797478162432 gen: 15890014   level: 1
                backup_csum_root:       103797411266560 gen: 15891267   level: 3
                backup_total_bytes:     26005118910464
                backup_bytes_used:      10185173540864
                backup_num_devices:     8

        backup 3:
                backup_tree_root:       103797410758656 gen: 15891264   level: 1
                backup_chunk_root:      98481546395648  gen: 15890014   level: 1
                backup_extent_root:     103797409267712 gen: 15891264   level: 2
                backup_fs_root:         102098872401920 gen: 15872333   level: 0
                backup_dev_root:        103797478162432 gen: 15890014   level: 1
                backup_csum_root:       103797401976832 gen: 15891264   level: 3
                backup_total_bytes:     26005118910464
                backup_bytes_used:      10184586289152
                backup_num_devices:     8
