Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-it0-f67.google.com ([209.85.214.67]:36009 "EHLO
        mail-it0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752819AbdF0LAW (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 27 Jun 2017 07:00:22 -0400
Received: by mail-it0-f67.google.com with SMTP id 185so2321627itv.3
        for <linux-btrfs@vger.kernel.org>; Tue, 27 Jun 2017 04:00:22 -0700 (PDT)
MIME-Version: 1.0
Reply-To: fdmanana@gmail.com
In-Reply-To: <007ac50e-71e2-6e25-7d17-821720a37317@fb.com>
References: <cover.1498229425.git.dsterba@suse.com> <007ac50e-71e2-6e25-7d17-821720a37317@fb.com>
From: Filipe Manana <fdmanana@gmail.com>
Date: Tue, 27 Jun 2017 12:00:20 +0100
Message-ID: <CAL3q7H4W6ag=1SZQ83WoYa9r+h3RsC4NR=mV_VYB6=fgZVA9xw@mail.gmail.com>
Subject: Re: [PULL] Btrfs for 4.13, part 1
To: Chris Mason <clm@fb.com>
Cc: David Sterba <dsterba@suse.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Jun 26, 2017 at 5:58 PM, Chris Mason <clm@fb.com> wrote:
> On 06/23/2017 11:16 AM, David Sterba wrote:
>>
>> Hi,
>>
>> this is the main batch for 4.13. There are some user visible changes, see
>> below. The core updates improve error handling (mostly related to bios),
>> with
>> the usual incremental work on the GFP_NOFS (mis)use removal. All patches
>> have
>> been in for-next for an extensive amount of time.
>>
>> Thre will be followups but I want push the series (111 patches) forward.
>> There
>> are also some updates to adjacent subsystems (writeback and blocklayer),
>> so I
>> want to give some stable point for merging in the upcoming weeks.
>
>
> Thanks Dave, I ran this (along with the updates we added) through a long
> stress and the usual xfstests.

Have any of you run xfstests without failures?

I'm finding it hard to believe, as some of these changes cause
problems all the time, and at least one of them deterministically
("btrfs: fix validation of XATTR_ITEM dir items"), as I've just noted
in the respective thread for that patch.

I haven't traced which change is causing a BUG_ON in the raid56 code,
due to lack of time, but running btrfs tests from 060 to 074 triggers
it very easily, for example:

[ 6086.912567] run fstests btrfs/064 at 2017-06-26 21:10:55
[ 6089.821472] BTRFS: device fsid 26f67507-c01d-4101-8435-2299cddab311
devid 1 transid 5 /dev/sdc
[ 6089.913286] BTRFS: device fsid 26f67507-c01d-4101-8435-2299cddab311
devid 2 transid 5 /dev/sdd
[ 6089.966903] BTRFS: device fsid 26f67507-c01d-4101-8435-2299cddab311
devid 3 transid 5 /dev/sde
[ 6090.065205] BTRFS: device fsid 26f67507-c01d-4101-8435-2299cddab311
devid 4 transid 5 /dev/sdf
[ 6090.873020] BTRFS info (device sdf): turning on discard
[ 6090.874452] BTRFS info (device sdf): disk space caching is enabled
[ 6090.893146] BTRFS info (device sdf): has skinny extents
[ 6091.110544] BTRFS info (device sdf): creating UUID tree
[ 6093.459619] BTRFS info (device sdf): dev_replace from /dev/sdd
(devid 2) to /dev/sdg started
[ 6099.046000] BTRFS info (device sdf): dev_replace from /dev/sdd
(devid 2) to /dev/sdg finished
[ 6101.221892] BTRFS info (device sdf): dev_replace from /dev/sde
(devid 3) to /dev/sdd started
[ 6104.224275] BTRFS info (device sdf): dev_replace from /dev/sde
(devid 3) to /dev/sdd finished
[ 6104.610774] BTRFS info (device sdf): dev_replace from /dev/sdf
(devid 4) to /dev/sde started
[ 6105.621356] BTRFS info (device sdf): dev_replace from /dev/sdf
(devid 4) to /dev/sde finished
[ 6111.693426] BTRFS info (device sdf): relocating block group
3242196992 flags data
[ 6111.731322] BTRFS info (device sdf): found 1 extents
[ 6111.762907] BTRFS info (device sdf): found 1 extents
[ 6111.785554] BTRFS info (device sdf): relocating block group
2168455168 flags metadata
[ 6111.823810] BTRFS info (device sdf): relocating block group
1094713344 flags data
[ 6111.974995] BTRFS info (device sdf): found 209 extents
[ 6112.471755] BTRFS info (device sdf): found 209 extents
[ 6112.485584] BTRFS info (device sdf): relocating block group
20971520 flags metadata
[ 6112.527924] BTRFS info (device sdf): found 2 extents
[ 6112.535532] BTRFS info (device sdf): relocating block group
12582912 flags data
[ 6112.585868] BTRFS info (device sdf): found 92 extents
[ 6112.838224] BTRFS info (device sdf): found 92 extents
[ 6112.847285] BTRFS info (device sdf): relocating block group 4194304
flags metadata
[ 6112.963176] BTRFS info (device sdf): found 116 extents
[ 6112.986034] BTRFS info (device sdf): relocating block group 0 flags system
[ 6113.013839] BTRFS info (device sdf): found 1 extents
[ 6114.496170] blk_update_request: I/O error, dev fd0, sector 0
[ 6114.497343] floppy: error -5 while reading block 0
[ 6114.700151] blk_update_request: I/O error, dev fd0, sector 0
[ 6114.701047] floppy: error -5 while reading block 0
[ 6114.975828] BTRFS: device fsid 7ea53fb0-9bc6-48e7-90ed-3d75bf00c180
devid 3 transid 5 /dev/sde
[ 6115.047448] BTRFS: device fsid 7ea53fb0-9bc6-48e7-90ed-3d75bf00c180
devid 1 transid 5 /dev/sdc
[ 6115.080295] BTRFS: device fsid 7ea53fb0-9bc6-48e7-90ed-3d75bf00c180
devid 2 transid 5 /dev/sdd
[ 6115.225944] BTRFS: device fsid 7ea53fb0-9bc6-48e7-90ed-3d75bf00c180
devid 4 transid 5 /dev/sdf
[ 6115.525122] BTRFS info (device sdf): turning on discard
[ 6115.525122] BTRFS info (device sdf): disk space caching is enabled
[ 6115.541244] BTRFS info (device sdf): has skinny extents
[ 6115.653520] BTRFS info (device sdf): creating UUID tree
[ 6115.744243] systemd-journald[618]: Data hash table of
/run/log/journal/bba104ad3dc06c1bd2dc3d7c546a5b43/system.journal has a
fill level at 75.0 (26843 of 35790 items, 16777216 file size, 625
bytes per hash table item), suggesting rotation.
[ 6115.813742] systemd-journald[618]:
/run/log/journal/bba104ad3dc06c1bd2dc3d7c546a5b43/system.journal:
Journal header limits reached or header out-of-date, rotating.
[ 6115.820095] systemd-journald[618]: Rotating...
[ 6115.841292] systemd-journald[618]: Reserving 35790 entries in hash table.
[ 6115.854029] systemd-journald[618]: Vacuuming...
[ 6115.855641] systemd-journald[618]: Vacuuming done, freed 0B of
archived journals on disk.
[ 6116.428897] blk_update_request: I/O error, dev fd0, sector 0
[ 6116.432844] floppy: error -5 while reading block 0
[ 6121.422099] BTRFS info (device sdf): dev_replace from /dev/sdd
(devid 2) to /dev/sdg started
[ 6131.042683] BTRFS info (device sdf): dev_replace from /dev/sdd
(devid 2) to /dev/sdg finished
[ 6136.197456] BTRFS info (device sdf): relocating block group
9768534016 flags data|raid0
[ 6136.338019] BTRFS info (device sdf): found 4 extents
[ 6136.444110] BTRFS info (device sdf): found 4 extents
[ 6136.599240] BTRFS info (device sdf): relocating block group
8694792192 flags metadata|raid0
[ 6136.766634] BTRFS info (device sdf): found 43 extents
[ 6136.854219] BTRFS info (device sdf): relocating block group
8627683328 flags system|raid0
[ 6136.956588] BTRFS info (device sdf): relocating block group
4332716032 flags data|raid0
[ 6143.223627] BTRFS info (device sdf): found 268 extents
[ 6143.225358] systemd-journald[618]: Sent WATCHDOG=1 notification.
[ 6143.657919] BTRFS info (device sdf): found 268 extents
[ 6143.744224] BTRFS info (device sdf): relocating block group
37748736 flags metadata|raid0
[ 6143.867552] BTRFS info (device sdf): found 102 extents
[ 6143.924525] BTRFS info (device sdf): relocating block group
20971520 flags system|raid0
[ 6143.983050] BTRFS info (device sdf): found 1 extents
[ 6145.424161] blk_update_request: I/O error, dev fd0, sector 0
[ 6145.425595] floppy: error -5 while reading block 0
[ 6145.628137] blk_update_request: I/O error, dev fd0, sector 0
[ 6145.628960] floppy: error -5 while reading block 0
[ 6147.044939] BTRFS: device fsid 94157252-d25f-4c1c-9d26-8b7729d7bc5a
devid 1 transid 5 /dev/sdc
[ 6147.049400] BTRFS: device fsid 94157252-d25f-4c1c-9d26-8b7729d7bc5a
devid 2 transid 5 /dev/sdd
[ 6147.086296] BTRFS: device fsid 94157252-d25f-4c1c-9d26-8b7729d7bc5a
devid 3 transid 5 /dev/sde
[ 6147.130074] BTRFS: device fsid 94157252-d25f-4c1c-9d26-8b7729d7bc5a
devid 4 transid 5 /dev/sdf
[ 6147.853052] BTRFS info (device sdf): turning on discard
[ 6147.854682] BTRFS info (device sdf): disk space caching is enabled
[ 6147.873477] BTRFS info (device sdf): has skinny extents
[ 6148.285495] BTRFS info (device sdf): creating UUID tree
[ 6149.101071] blk_update_request: I/O error, dev fd0, sector 0
[ 6149.104974] floppy: error -5 while reading block 0
[ 6151.577159] BTRFS info (device sdf): dev_replace from /dev/sdd
(devid 2) to /dev/sdg started
[ 6241.821804] systemd-journald[618]: Sent WATCHDOG=1 notification.
[ 6306.238550] BTRFS info (device sdf): dev_replace from /dev/sdd
(devid 2) to /dev/sdg finished
[ 6320.201287] systemd-journald[618]: Sent WATCHDOG=1 notification.
[ 6334.496060] blk_update_request: I/O error, dev fd0, sector 0
[ 6334.496849] floppy: error -5 while reading block 0
[ 6368.344060] blk_update_request: I/O error, dev fd0, sector 0
[ 6368.344850] floppy: error -5 while reading block 0
[ 6405.872088] BTRFS: device fsid 3b456cae-f946-4422-8b69-3e562660d3ca
devid 1 transid 5 /dev/sdc
[ 6407.056284] BTRFS: device fsid 3b456cae-f946-4422-8b69-3e562660d3ca
devid 2 transid 5 /dev/sdd
[ 6409.036854] BTRFS: device fsid 3b456cae-f946-4422-8b69-3e562660d3ca
devid 3 transid 5 /dev/sde
[ 6409.061008] systemd-journald[618]: Sent WATCHDOG=1 notification.
[ 6410.988164] BTRFS: device fsid 3b456cae-f946-4422-8b69-3e562660d3ca
devid 4 transid 5 /dev/sdf
[ 6414.503001] BTRFS info (device sdf): turning on discard
[ 6414.542595] BTRFS info (device sdf): disk space caching is enabled
[ 6414.570512] BTRFS info (device sdf): has skinny extents
[ 6415.488940] BTRFS info (device sdf): creating UUID tree
[ 6420.048032] blk_update_request: I/O error, dev fd0, sector 0
[ 6420.051396] floppy: error -5 while reading block 0
[ 6466.781846] BTRFS info (device sdf): relocating block group
1103101952 flags data|raid1
[ 6499.163148] systemd-journald[618]: Sent WATCHDOG=1 notification.
[ 6500.988823] BTRFS info (device sdf): found 163 extents
[ 6520.228862] BTRFS info (device sdf): found 155 extents
[ 6526.150033] BTRFS info (device sdf): relocating block group
29360128 flags metadata|raid1
[ 6543.788137] BTRFS info (device sdf): found 94 extents
[ 6548.960587] BTRFS info (device sdf): relocating block group
20971520 flags system|raid1
[ 6554.786983] BTRFS info (device sdf): found 1 extents
[ 6577.584717] blk_update_request: I/O error, dev fd0, sector 0
[ 6577.588657] floppy: error -5 while reading block 0
[ 6601.128050] blk_update_request: I/O error, dev fd0, sector 0
[ 6601.128840] floppy: error -5 while reading block 0
[ 6601.140652] systemd-journald[618]: Sent WATCHDOG=1 notification.
[ 6625.542882] BTRFS: device fsid e3828911-137a-48d1-9be3-c3b7ec16f953
devid 1 transid 5 /dev/sdc
[ 6625.581187] BTRFS: device fsid e3828911-137a-48d1-9be3-c3b7ec16f953
devid 2 transid 5 /dev/sdd
[ 6625.601238] BTRFS: device fsid e3828911-137a-48d1-9be3-c3b7ec16f953
devid 3 transid 5 /dev/sde
[ 6625.723378] BTRFS: device fsid e3828911-137a-48d1-9be3-c3b7ec16f953
devid 4 transid 5 /dev/sdf
[ 6626.304067] BTRFS info (device sdf): turning on discard
[ 6626.304830] BTRFS info (device sdf): disk space caching is enabled
[ 6626.305520] BTRFS info (device sdf): has skinny extents
[ 6626.471590] BTRFS info (device sdf): creating UUID tree
[ 6628.368615] BTRFS info (device sdf): dev_replace from /dev/sdd
(devid 2) to /dev/sdg started
[ 6641.236372] BTRFS info (device sdf): dev_replace from /dev/sdd
(devid 2) to /dev/sdg finished
[ 6647.060891] BTRFS info (device sdf): relocating block group
5473566720 flags data|raid10
[ 6647.164149] BTRFS info (device sdf): found 2 extents
[ 6647.259690] BTRFS info (device sdf): found 2 extents
[ 6647.330143] BTRFS info (device sdf): relocating block group
4399824896 flags metadata|raid10
[ 6647.458031] BTRFS info (device sdf): found 34 extents
[ 6647.523545] BTRFS info (device sdf): relocating block group
4332716032 flags system|raid10
[ 6647.603603] BTRFS info (device sdf): relocating block group
2185232384 flags data|raid10
[ 6651.461293] BTRFS info (device sdf): found 245 extents
[ 6651.803813] BTRFS info (device sdf): found 245 extents
[ 6651.872335] BTRFS info (device sdf): relocating block group
37748736 flags metadata|raid10
[ 6652.067394] BTRFS info (device sdf): found 102 extents
[ 6652.124856] BTRFS info (device sdf): relocating block group
20971520 flags system|raid10
[ 6652.199854] BTRFS info (device sdf): found 1 extents
[ 6661.700121] blk_update_request: I/O error, dev fd0, sector 0
[ 6661.701526] floppy: error -5 while reading block 0
[ 6662.052252] blk_update_request: I/O error, dev fd0, sector 0
[ 6662.053296] floppy: error -5 while reading block 0
[ 6663.040606] BTRFS: device fsid fac7c5d7-9979-4280-9ced-6adf1baf673d
devid 1 transid 5 /dev/sdc
[ 6663.224627] BTRFS: device fsid fac7c5d7-9979-4280-9ced-6adf1baf673d
devid 2 transid 5 /dev/sdd
[ 6663.266865] BTRFS: device fsid fac7c5d7-9979-4280-9ced-6adf1baf673d
devid 3 transid 5 /dev/sde
[ 6663.280780] BTRFS: device fsid fac7c5d7-9979-4280-9ced-6adf1baf673d
devid 4 transid 5 /dev/sdf
[ 6663.784636] BTRFS info (device sdf): turning on discard
[ 6663.811720] BTRFS info (device sdf): disk space caching is enabled
[ 6663.824680] BTRFS info (device sdf): has skinny extents
[ 6664.005123] BTRFS info (device sdf): creating UUID tree
[ 6664.254147] btrfs_print_data_csum_error: 11 callbacks suppressed
[ 6664.292699] BTRFS warning (device sdf): csum failed root 5 ino 284
off 294912 csum 0x98f94189 expected csum 0xf2364862 mirror 1
[ 6664.344601] BTRFS warning (device sdf): csum failed root 5 ino 284
off 299008 csum 0x98f94189 expected csum 0xf2364862 mirror 1
[ 6664.376676] BTRFS warning (device sdf): csum failed root 5 ino 284
off 303104 csum 0x98f94189 expected csum 0xf2364862 mirror 1
[ 6664.391328] BTRFS warning (device sdf): csum failed root 5 ino 284
off 294912 csum 0x98f94189 expected csum 0xf2364862 mirror 1
[ 6664.401801] BTRFS warning (device sdf): csum failed root 5 ino 284
off 299008 csum 0x98f94189 expected csum 0xf2364862 mirror 1
[ 6664.440441] BTRFS warning (device sdf): csum failed root 5 ino 284
off 303104 csum 0x98f94189 expected csum 0xf2364862 mirror 1
[ 6664.540695] BTRFS warning (device sdf): csum failed root 5 ino 284
off 294912 csum 0x98f94189 expected csum 0xf2364862 mirror 2
[ 6664.542010] BTRFS warning (device sdf): csum failed root 5 ino 284
off 299008 csum 0x98f94189 expected csum 0xf2364862 mirror 2
[ 6664.543258] BTRFS warning (device sdf): csum failed root 5 ino 284
off 303104 csum 0x98f94189 expected csum 0xf2364862 mirror 2
[ 6664.672878] BTRFS warning (device sdf): csum failed root 5 ino 284
off 303104 csum 0x98f94189 expected csum 0xf2364862 mirror 1
[ 6665.232628] blk_update_request: I/O error, dev fd0, sector 0
[ 6665.233526] floppy: error -5 while reading block 0
[ 6669.256609] btrfs_print_data_csum_error: 297 callbacks suppressed
[ 6669.291821] BTRFS warning (device sdf): csum failed root 5 ino 300
off 684032 csum 0x98f94189 expected csum 0x42186b7f mirror 1
[ 6669.319412] BTRFS warning (device sdf): csum failed root 5 ino 300
off 688128 csum 0x98f94189 expected csum 0x42186b7f mirror 1
[ 6669.332644] BTRFS warning (device sdf): csum failed root 5 ino 298
off 892928 csum 0x98f94189 expected csum 0x28d76294 mirror 2
[ 6669.356673] BTRFS warning (device sdf): csum failed root 5 ino 298
off 897024 csum 0x98f94189 expected csum 0x28d76294 mirror 2
[ 6669.376583] BTRFS warning (device sdf): csum failed root 5 ino 300
off 692224 csum 0x98f94189 expected csum 0x42186b7f mirror 1
[ 6669.447063] BTRFS warning (device sdf): csum failed root 5 ino 298
off 901120 csum 0x98f94189 expected csum 0x28d76294 mirror 2
[ 6669.500703] BTRFS warning (device sdf): csum failed root 5 ino 298
off 905216 csum 0x98f94189 expected csum 0x28d76294 mirror 2
[ 6669.505183] BTRFS warning (device sdf): csum failed root 5 ino 298
off 929792 csum 0x98f94189 expected csum 0x28d76294 mirror 2
[ 6669.505238] BTRFS warning (device sdf): csum failed root 5 ino 281
off 901120 csum 0x98f94189 expected csum 0x27a85bb4 mirror 2
[ 6669.508819] BTRFS warning (device sdf): csum failed root 5 ino 300
off 696320 csum 0x98f94189 expected csum 0x42186b7f mirror 1
[ 6669.920580] BTRFS info (device sdf): dev_replace from /dev/sdd
(devid 2) to /dev/sdg started
[ 6674.297803] btrfs_print_data_csum_error: 138 callbacks suppressed
[ 6674.317501] BTRFS warning (device sdf): csum failed root 5 ino 402
off 831488 csum 0x98f94189 expected csum 0x4d67525f mirror 2
[ 6674.348626] BTRFS warning (device sdf): csum failed root 5 ino 311
off 200704 csum 0x98f94189 expected csum 0x4d67525f mirror 1
[ 6674.380668] BTRFS warning (device sdf): csum failed root 5 ino 311
off 204800 csum 0x98f94189 expected csum 0x4d67525f mirror 1
[ 6674.389074] BTRFS warning (device sdf): csum failed root 5 ino 388
off 192512 csum 0x98f94189 expected csum 0xfd497142 mirror 1
[ 6674.407222] BTRFS warning (device sdf): csum failed root 5 ino 402
off 729088 csum 0x42186b7f expected csum 0x4d67525f mirror 2
[ 6674.416111] BTRFS warning (device sdf): csum failed root 5 ino 388
off 147456 csum 0x98f94189 expected csum 0xfd497142 mirror 2
[ 6674.416156] ------------[ cut here ]------------
[ 6674.416157] kernel BUG at fs/btrfs/raid56.c:1897!
[ 6674.416159] invalid opcode: 0000 [#1] PREEMPT SMP
[ 6674.416160] Modules linked in: dm_flakey dm_mod dax ppdev tpm_tis
parport_pc tpm_tis_core evdev tpm psmouse sg i2c_piix4 pcspkr parport
i2c_core serio_raw button sunrpc loop autofs4 ext4 crc16 jbd2 mbcache
btrfs raid10 raid456 async_raid6_recov async_memcpy async_pq async_xor
async_tx xor raid6_pq libcrc32c crc32c_generic raid1 raid0 multipath
linear md_mod sr_mod cdrom ata_generic sd_mod virtio_scsi ata_piix
virtio_pci virtio_ring libata scsi_mod e1000 virtio floppy
[ 6674.416184] CPU: 3 PID: 19236 Comm: kworker/u32:10 Not tainted
4.12.0-rc6-btrfs-next-44+ #1
[ 6674.416185] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996),
BIOS rel-1.9.1-0-gb3ef39f-prebuilt.qemu-project.org 04/01/2014
[ 6674.416210] Workqueue: btrfs-endio btrfs_endio_helper [btrfs]
[ 6674.416211] task: ffff880147f6c740 task.stack: ffffc90001fb8000
[ 6674.416229] RIP: 0010:__raid_recover_end_io+0x1ac/0x370 [btrfs]
[ 6674.416230] RSP: 0018:ffffc90001fbbb90 EFLAGS: 00010217
[ 6674.416231] RAX: ffff8801ff4b4f00 RBX: 0000000000000002 RCX: 0000000000000001
[ 6674.416232] RDX: ffff880099b045d8 RSI: ffffffff81a5f6e0 RDI: 0000000000000004
[ 6674.416232] RBP: ffffc90001fbbbc8 R08: 0000000000000001 R09: 0000000000000001
[ 6674.416233] R10: ffffc90001fbbac8 R11: 0000000000001000 R12: 0000000000000002
[ 6674.416234] R13: ffff880099b045c0 R14: 0000000000000004 R15: ffff88012bff2000
[ 6674.416235] FS:  0000000000000000(0000) GS:ffff88023f2c0000(0000)
knlGS:0000000000000000
[ 6674.416235] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[ 6674.416236] CR2: 00007f28cf282000 CR3: 00000001000c6000 CR4: 00000000000006e0
[ 6674.416239] Call Trace:
[ 6674.416259]  __raid56_parity_recover+0xfc/0x16e [btrfs]
[ 6674.416276]  raid56_parity_recover+0x157/0x16b [btrfs]
[ 6674.416293]  btrfs_map_bio+0xe0/0x259 [btrfs]
[ 6674.416310]  btrfs_submit_bio_hook+0xbf/0x147 [btrfs]
[ 6674.416327]  end_bio_extent_readpage+0x27b/0x4a0 [btrfs]
[ 6674.416331]  bio_endio+0x17d/0x1b3
[ 6674.416346]  end_workqueue_fn+0x3c/0x3f [btrfs]
[ 6674.416362]  btrfs_scrubparity_helper+0x1aa/0x3b8 [btrfs]
[ 6674.416379]  btrfs_endio_helper+0xe/0x10 [btrfs]
[ 6674.416381]  process_one_work+0x276/0x4b6
[ 6674.416384]  worker_thread+0x1ac/0x266
[ 6674.416386]  ? rescuer_thread+0x278/0x278
[ 6674.416387]  kthread+0x106/0x10e
[ 6674.416389]  ? __list_del_entry+0x22/0x22
[ 6674.416391]  ret_from_fork+0x27/0x40
[ 6674.416395] Code: 44 89 e2 be 00 10 00 00 ff 15 b0 ab ef ff eb 72
4d 89 e8 89 d9 44 89 e2 be 00 10 00 00 ff 15 a3 ab ef ff eb 5d 41 83
fc ff 74 02 <0f> 0b 49 63 97 0c 01 00 00 48 63 c3 b9 00 04 00 00 49 8d
44 c5
[ 6674.416432] RIP: __raid_recover_end_io+0x1ac/0x370 [btrfs] RSP:
ffffc90001fbbb90
[ 6674.416434] ---[ end trace 74d56ebe7489dd6a ]---

Scrub also finds lots of errors in those tests, causing them to fail.

btrfs/048 also fails due to this new dir item length validation function....

And so on...


>
> For everyone else on the list, since I'm heading off to vacation until ~July
> 9th, Dave is sending this off to Linus once the merge window starts.
>
> -chris
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



-- 
Filipe David Manana,

“Whether you think you can, or you think you can't — you're right.”
