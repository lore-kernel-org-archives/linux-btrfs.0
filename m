Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-la0-f50.google.com ([209.85.215.50]:34492 "EHLO
	mail-la0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754106AbbGTQUu (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 20 Jul 2015 12:20:50 -0400
Received: by lahe2 with SMTP id e2so37844782lah.1
        for <linux-btrfs@vger.kernel.org>; Mon, 20 Jul 2015 09:20:48 -0700 (PDT)
MIME-Version: 1.0
From: Tobias Holst <tobby@tobby.eu>
Date: Mon, 20 Jul 2015 18:20:28 +0200
Message-ID: <CAGwxe4j7J5ztPk-OyeOuX2YH6SO3G9_h6VU_1wWMdP4rHpqiew@mail.gmail.com>
Subject: "free_raid_bio" crash on RAID6
To: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi

My btrfs-RAID6 seems to be broken again :(

When reading from it I get several of these:
[  176.349943] BTRFS info (device dm-4): csum failed ino 1287707
extent 21274957705216 csum 2830458701 wanted 426660650 mirror 2

then followed by a "free_raid_bio"-crash:

[  176.349961] ------------[ cut here ]------------
[  176.349981] WARNING: CPU: 6 PID: 110 at
/home/kernel/COD/linux/fs/btrfs/raid56.c:831
__free_raid_bio+0xfc/0x130 [btrfs]()
[  176.349982] Modules linked in: iosf_mbi kvm_intel kvm ppdev
crct10dif_pclmul crc32_pclmul dm_crypt ghash_clmulni_intel aesni_intel
aes_x86_64 lrw gf128mul glue_helper ablk_helper serio_raw 8250_fintek
i2c_piix4 pvpanic cryptd mac_hid virtio_rng parport_pc lp parport
btrfs xor raid6_pq cirrus syscopyarea sysfillrect sysimgblt ttm
drm_kms_helper mpt2sas drm raid_class psmouse floppy
scsi_transport_sas pata_acpi
[  176.349998] CPU: 6 PID: 110 Comm: kworker/u16:2 Not tainted
4.1.2-040102-generic #201507101335
[  176.349999] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996),
BIOS Bochs 01/01/2011
[  176.350007] Workqueue: btrfs-endio btrfs_endio_helper [btrfs]
[  176.350008]  ffffffffc026fc18 ffff8800baa4f978 ffffffff817d076c
0000000000000000
[  176.350010]  0000000000000000 ffff8800baa4f9b8 ffffffff81079b0a
0000000000000246
[  176.350011]  ffff88034e7baa68 ffff88008619b800 00000000fffffffb
0000000000000000
[  176.350013] Call Trace:
[  176.350023]  [<ffffffff817d076c>] dump_stack+0x45/0x57
[  176.350026]  [<ffffffff81079b0a>] warn_slowpath_common+0x8a/0xc0
[  176.350029]  [<ffffffff81079bfa>] warn_slowpath_null+0x1a/0x20
[  176.350036]  [<ffffffffc025e91c>] __free_raid_bio+0xfc/0x130 [btrfs]
[  176.350041]  [<ffffffffc025f351>] rbio_orig_end_io+0x51/0xa0 [btrfs]
[  176.350047]  [<ffffffffc02610e3>] __raid56_parity_recover+0x1d3/0x210 [btrfs]
[  176.350052]  [<ffffffffc0261cb0>] raid56_parity_recover+0x110/0x180 [btrfs]
[  176.350058]  [<ffffffffc0216cdb>] btrfs_map_bio+0xdb/0x4e0 [btrfs]
[  176.350065]  [<ffffffffc0236024>]
btrfs_submit_compressed_read+0x354/0x4e0 [btrfs]
[  176.350070]  [<ffffffffc01ee681>] btrfs_submit_bio_hook+0x1d1/0x1e0 [btrfs]
[  176.350076]  [<ffffffff81376dbe>] ? bio_add_page+0x5e/0x70
[  176.350083]  [<ffffffffc020c176>] ?
btrfs_create_repair_bio+0xe6/0x110 [btrfs]
[  176.350089]  [<ffffffffc020c6ab>] end_bio_extent_readpage+0x50b/0x560 [btrfs]
[  176.350094]  [<ffffffffc020c1a0>] ?
btrfs_create_repair_bio+0x110/0x110 [btrfs]
[  176.350096]  [<ffffffff8137934b>] bio_endio+0x5b/0xa0
[  176.350103]  [<ffffffff811d9e19>] ? kmem_cache_free+0x1d9/0x1f0
[  176.350104]  [<ffffffff813793a2>] bio_endio_nodec+0x12/0x20
[  176.350109]  [<ffffffffc01e10df>] end_workqueue_fn+0x3f/0x50 [btrfs]
[  176.350115]  [<ffffffffc021b522>] normal_work_helper+0xc2/0x2b0 [btrfs]
[  176.350121]  [<ffffffffc021b7e2>] btrfs_endio_helper+0x12/0x20 [btrfs]
[  176.350124]  [<ffffffff8109324f>] process_one_work+0x14f/0x420
[  176.350127]  [<ffffffff81093a08>] worker_thread+0x118/0x530
[  176.350128]  [<ffffffff810938f0>] ? rescuer_thread+0x3d0/0x3d0
[  176.350129]  [<ffffffff81098f89>] kthread+0xc9/0xe0
[  176.350130]  [<ffffffff81098ec0>] ? kthread_create_on_node+0x180/0x180
[  176.350134]  [<ffffffff817d86a2>] ret_from_fork+0x42/0x70
[  176.350135]  [<ffffffff81098ec0>] ? kthread_create_on_node+0x180/0x180
[  176.350136] ---[ end trace 81289955f20d48ee ]---

Did I found a kernel bug? What can/should I do?

Don't worry about my data, I have tape-backups of the important data,
I just want to help fixing RAID-related btrfs bugs.

Hardware: KVM with all drives attached to a passed through SAS-controller
System: Ubuntu 14.04.2
Kernel: 4.1.2
btrfs-tools: 4.0
It's a btrfs-RAID-6 on top of 6 LUKS-encrypted volumes, created with
"-O extref,raid56,skinny-metadata,no-holes". At normal it's mounted
with "defaults,compress=lzo,space_cache,autodefrag,subvol=raid".
One drive is broken, so at the moment it is mounted with "-O
defaults,ro,degraded,recovery,compress=lzo,space_cache,subvol=raid".

It's pretty much full, so "btrfs fi show" shows:
Label: 't-raid'  uuid: 3938baeb-cb02-4909-8e75-6ec2f47d1d19
        Total devices 6 FS bytes used 14.44TiB
        devid    2 size 3.64TiB used 3.64TiB path /dev/mapper/sdb_crypt
        devid    3 size 3.64TiB used 3.64TiB path /dev/mapper/sdc_crypt
        devid    4 size 3.64TiB used 3.64TiB path /dev/mapper/sdd_crypt
        devid    5 size 3.64TiB used 3.64TiB path /dev/mapper/sde_crypt
        devid    6 size 3.64TiB used 3.64TiB path /dev/mapper/sdf_crypt
        *** Some devices missing

and "btrfs fi df /raid" shows:
Data, RAID6: total=14.52TiB, used=14.42TiB
System, RAID6: total=64.00MiB, used=1.00MiB
Metadata, RAID6: total=24.00GiB, used=21.78GiB
GlobalReserve, single: total=512.00MiB, used=0.00B


Regards,
Tobias
