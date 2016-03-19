Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.20]:57530 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932426AbcCSXfF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 19 Mar 2016 19:35:05 -0400
MIME-Version: 1.0
Message-ID: <trinity-af54e977-779b-4ee5-82a0-5022c97ad5c5-1458430500649@3capp-gmx-bs56>
From: "Patrick Tschackert" <Killing-Time@gmx.de>
To: lists@colorremedies.com, linux-btrfs@vger.kernel.org
Subject: Re: unable to mount btrfs partition, please help :(
Content-Type: text/plain; charset=UTF-8
Date: Sun, 20 Mar 2016 00:35:00 +0100
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Chris,

thank you for answering so quickly!

> Try 'btrfs check' without any options first.
$ btrfs check /dev/mapper/storage
checksum verify failed on 36340960788480 found 8F8E1006 wanted 4AA1BC89
checksum verify failed on 36340960788480 found 8F8E1006 wanted 4AA1BC89
bytenr mismatch, want=36340960788480, have=4530277753793296986
Couldn't read chunk tree
Couldn't open file system

> To me it seems the problem is instigated by lower layers either not
> completing critical writes at the time of the power failure, or didn't
> rebuild correctly.

There wasn't a power failure, a VM crashed whilst writing to the btrfs filesys. I then rebooted the whole system via "shutdown -r now", after which the filesystem wasn't mountable.
The rebuild/restore of the raid seemed to go just fine though.

> You should check the SCT ERC setting on each drive with 'smartctl -l
> scterc /dev/sdX' and also the kernel command timer setting with 'cat
> /sys/block/sdX/device/timeout' also for each device. The SCT ERC value
> must be less than the command timer. It's a common misconfiguration
> with raid setups.

$ smartctl -l scterc /dev/sda (sdb, sdc, sde, sdg)
gives me

smartctl 6.4 2014-10-07 r4002 [x86_64-linux-3.16.0-4-amd64] (local build)
Copyright (C) 2002-14, Bruce Allen, Christian Franke, www.smartmontools.org

SCT Error Recovery Control command not supported

while
$ smartctl -l scterc /dev/sdf (sdh, sdi, sdj, sdk)
gives me

smartctl 6.4 2014-10-07 r4002 [x86_64-linux-3.16.0-4-amd64] (local build)
Copyright (C) 2002-14, Bruce Allen, Christian Franke, www.smartmontools.org

SCT Error Recovery Control:
           Read:     70 (7.0 seconds)
          Write:     70 (7.0 seconds)

$ cat /sys/block/sdX/device/timeout
gives me "30" for every device

Does that mean my settings for the device timeouts are wrong?

> After that's fixed you should do a scrub, and I'm thinking it's best
> to do only a check, which means 'echo check >
> /sys/block/mdX/md/sync_action' rather than issuing repair which
> assumes data strips are correct and parity strips are wrong and
> rebuilds all parity strips.

I don't quite understand, I thought a scrub could only be done on a mounted filesys?
Do you reall mean executing the command "echo check > /sys/block/md0/md/sync_action"? At the moment it says "idle" in that file.
Also, the btrfs filesys sits in an encrypted container, so the setup looks like this:

/dev/md0 (this is the Raid device)
/dev/mapper/storage (after cryptsetup luksOpen, this is where filesys should be mounted from)
/media/storage (i always mounted the filesystem into this folder by executing "mount /dev/mapper/storage /media/storage")

Apologies if I didn't make that clear enough in my initial email


>> $ uname -a
>> Linux vmhost 3.16.0-4-amd64 #1 SMP Debian 3.16.7-ckt20-1+deb8u4
>> (2016-02-29) x86_64 GNU/Linux
>This is old. You should upgrade to something newer, ideally 4.5 but
>4.4.6 is good also, and then oldest I'd suggest is 4.1.20.

Shouldn't I be able to get the newest kernel by executing "apt-get update && apt-get dist-upgrade"?
That's what I ran just now, and it doesn't install a newer kernel. Do I really have to manually upgrade to a newer one?
On top of the sticky situation i'm already in, i'm not sure if I trust myself manually building a new kernel. Should I?

> What do you get for
> btrfs-find-root /dev/mdX
> btrfs-show-super -fa /dev/mdX

$ btrfs-find-root /dev/mapper/storage
Couldn't read chunk tree
Open ctree failed

$ btrfs-show-super -fa /dev/mapper/storage
superblock: bytenr=65536, device=/dev/mapper/storage
---------------------------------------------------------
csum                    0xf3887f83 [match]
bytenr                  65536
flags                   0x1
                        ( WRITTEN )
magic                   _BHRfS_M [match]
fsid                    9868d803-78d1-40c3-b1ee-a4ce3363df87
label
generation              1322969
root                    24022309593088
sys_array_size          97
chunk_root_generation   1275381
root_level              2
chunk_root              36340959809536
chunk_root_level        2
log_root                0
log_root_transid        0
log_root_level          0
total_bytes             21003208163328
bytes_used              17670843191296
sectorsize              4096
nodesize                4096
leafsize                4096
stripesize              4096
root_dir                6
num_devices             1
compat_flags            0x0
compat_ro_flags         0x0
incompat_flags          0x1
                        ( MIXED_BACKREF )
csum_type               0
csum_size               4
cache_generation        1322969
uuid_tree_generation    1322969
dev_item.uuid           c1123f55-46ce-4931-8722-7387fee07608
dev_item.fsid           9868d803-78d1-40c3-b1ee-a4ce3363df87 [match]
dev_item.type           0
dev_item.total_bytes    21003208163328
dev_item.bytes_used     17886424858624
dev_item.io_align       4096
dev_item.io_width       4096
dev_item.sector_size    4096
dev_item.devid          1
dev_item.dev_group      0
dev_item.seek_speed     0
dev_item.bandwidth      0
dev_item.generation     0
sys_chunk_array[2048]:
        item 0 key (FIRST_CHUNK_TREE CHUNK_ITEM 36340959805440)
                chunk length 33554432 owner 2 stripe_len 65536
                type SYSTEM num_stripes 1
                        stripe 0 devid 1 offset 7549747200
                        dev uuid: c1123f55-46ce-4931-8722-7387fee07608
backup_roots[4]:
        backup 0:
                backup_tree_root:       24022006386688  gen: 1322967    level: 2
                backup_chunk_root:      36340959809536  gen: 1275381    level: 2
                backup_extent_root:     24022070910976  gen: 1322968    level: 3
                backup_fs_root:         24022070902784  gen: 1322968    level: 3
                backup_dev_root:        24014655901696  gen: 1275381    level: 2
                backup_csum_root:       24022070956032  gen: 1322968    level: 4
                backup_total_bytes:     21003208163328
                backup_bytes_used:      17670808895488
                backup_num_devices:     1

        backup 1:
                backup_tree_root:       24022114037760  gen: 1322968    level: 2
                backup_chunk_root:      36340959809536  gen: 1275381    level: 2
                backup_extent_root:     24022186385408  gen: 1322969    level: 3
                backup_fs_root:         24022186381312  gen: 1322969    level: 3
                backup_dev_root:        24014655901696  gen: 1275381    level: 2
                backup_csum_root:       24022186536960  gen: 1322969    level: 4
                backup_total_bytes:     21003208163328
                backup_bytes_used:      17670826078208
                backup_num_devices:     1

        backup 2:
                backup_tree_root:       24022309593088  gen: 1322969    level: 2
                backup_chunk_root:      36340959809536  gen: 1275381    level: 2
                backup_extent_root:     24022337949696  gen: 1322970    level: 3
                backup_fs_root:         24022337937408  gen: 1322970    level: 3
                backup_dev_root:        24014655901696  gen: 1275381    level: 2
                backup_csum_root:       24022337990656  gen: 1322970    level: 4
                backup_total_bytes:     21003208163328
                backup_bytes_used:      17670866358272
                backup_num_devices:     1

        backup 3:
                backup_tree_root:       24021840482304  gen: 1322966    level: 2
                backup_chunk_root:      36340959809536  gen: 1275381    level: 2
                backup_extent_root:     24021883957248  gen: 1322967    level: 3
                backup_fs_root:         24021883949056  gen: 1322967    level: 3
                backup_dev_root:        24014655901696  gen: 1275381    level: 2
                backup_csum_root:       24021884100608  gen: 1322967    level: 4
                backup_total_bytes:     21003208163328
                backup_bytes_used:      17670630260736
                backup_num_devices:     1


superblock: bytenr=67108864, device=/dev/mapper/storage
---------------------------------------------------------
csum                    0x53e9574d [match]
bytenr                  67108864
flags                   0x1
                        ( WRITTEN )
magic                   _BHRfS_M [match]
fsid                    9868d803-78d1-40c3-b1ee-a4ce3363df87
label
generation              1322969
root                    24022309593088
sys_array_size          97
chunk_root_generation   1275381
root_level              2
chunk_root              36340959809536
chunk_root_level        2
log_root                0
log_root_transid        0
log_root_level          0
total_bytes             21003208163328
bytes_used              17670843191296
sectorsize              4096
nodesize                4096
leafsize                4096
stripesize              4096
root_dir                6
num_devices             1
compat_flags            0x0
compat_ro_flags         0x0
incompat_flags          0x1
                        ( MIXED_BACKREF )
csum_type               0
csum_size               4
cache_generation        1322969
uuid_tree_generation    1322969
dev_item.uuid           c1123f55-46ce-4931-8722-7387fee07608
dev_item.fsid           9868d803-78d1-40c3-b1ee-a4ce3363df87 [match]
dev_item.type           0
dev_item.total_bytes    21003208163328
dev_item.bytes_used     17886424858624
dev_item.io_align       4096
dev_item.io_width       4096
dev_item.sector_size    4096
dev_item.devid          1
dev_item.dev_group      0
dev_item.seek_speed     0
dev_item.bandwidth      0
dev_item.generation     0
sys_chunk_array[2048]:
        item 0 key (FIRST_CHUNK_TREE CHUNK_ITEM 36340959805440)
                chunk length 33554432 owner 2 stripe_len 65536
                type SYSTEM num_stripes 1
                        stripe 0 devid 1 offset 7549747200
                        dev uuid: c1123f55-46ce-4931-8722-7387fee07608
backup_roots[4]:
        backup 0:
                backup_tree_root:       24022006386688  gen: 1322967    level: 2
                backup_chunk_root:      36340959809536  gen: 1275381    level: 2
                backup_extent_root:     24022070910976  gen: 1322968    level: 3
                backup_fs_root:         24022070902784  gen: 1322968    level: 3
                backup_dev_root:        24014655901696  gen: 1275381    level: 2
                backup_csum_root:       24022070956032  gen: 1322968    level: 4
                backup_total_bytes:     21003208163328
                backup_bytes_used:      17670808895488
                backup_num_devices:     1

        backup 1:
                backup_tree_root:       24022114037760  gen: 1322968    level: 2
                backup_chunk_root:      36340959809536  gen: 1275381    level: 2
                backup_extent_root:     24022186385408  gen: 1322969    level: 3
                backup_fs_root:         24022186381312  gen: 1322969    level: 3
                backup_dev_root:        24014655901696  gen: 1275381    level: 2
                backup_csum_root:       24022186536960  gen: 1322969    level: 4
                backup_total_bytes:     21003208163328
                backup_bytes_used:      17670826078208
                backup_num_devices:     1

        backup 2:
                backup_tree_root:       24022309593088  gen: 1322969    level: 2
                backup_chunk_root:      36340959809536  gen: 1275381    level: 2
                backup_extent_root:     24022337949696  gen: 1322970    level: 3
                backup_fs_root:         24022337937408  gen: 1322970    level: 3
                backup_dev_root:        24014655901696  gen: 1275381    level: 2
                backup_csum_root:       24022337990656  gen: 1322970    level: 4
                backup_total_bytes:     21003208163328
                backup_bytes_used:      17670866358272
                backup_num_devices:     1

        backup 3:
                backup_tree_root:       24021840482304  gen: 1322966    level: 2
                backup_chunk_root:      36340959809536  gen: 1275381    level: 2
                backup_extent_root:     24021883957248  gen: 1322967    level: 3
                backup_fs_root:         24021883949056  gen: 1322967    level: 3
                backup_dev_root:        24014655901696  gen: 1275381    level: 2
                backup_csum_root:       24021884100608  gen: 1322967    level: 4
                backup_total_bytes:     21003208163328
                backup_bytes_used:      17670630260736
                backup_num_devices:     1


superblock: bytenr=274877906944, device=/dev/mapper/storage
---------------------------------------------------------
csum                    0xae6e017c [match]
bytenr                  274877906944
flags                   0x1
                        ( WRITTEN )
magic                   _BHRfS_M [match]
fsid                    9868d803-78d1-40c3-b1ee-a4ce3363df87
label
generation              1322969
root                    24022309593088
sys_array_size          97
chunk_root_generation   1275381
root_level              2
chunk_root              36340959809536
chunk_root_level        2
log_root                0
log_root_transid        0
log_root_level          0
total_bytes             21003208163328
bytes_used              17670843191296
sectorsize              4096
nodesize                4096
leafsize                4096
stripesize              4096
root_dir                6
num_devices             1
compat_flags            0x0
compat_ro_flags         0x0
incompat_flags          0x1
                        ( MIXED_BACKREF )
csum_type               0
csum_size               4
cache_generation        1322969
uuid_tree_generation    1322969
dev_item.uuid           c1123f55-46ce-4931-8722-7387fee07608
dev_item.fsid           9868d803-78d1-40c3-b1ee-a4ce3363df87 [match]
dev_item.type           0
dev_item.total_bytes    21003208163328
dev_item.bytes_used     17886424858624
dev_item.io_align       4096
dev_item.io_width       4096
dev_item.sector_size    4096
dev_item.devid          1
dev_item.dev_group      0
dev_item.seek_speed     0
dev_item.bandwidth      0
dev_item.generation     0
sys_chunk_array[2048]:
        item 0 key (FIRST_CHUNK_TREE CHUNK_ITEM 36340959805440)
                chunk length 33554432 owner 2 stripe_len 65536
                type SYSTEM num_stripes 1
                        stripe 0 devid 1 offset 7549747200
                        dev uuid: c1123f55-46ce-4931-8722-7387fee07608
backup_roots[4]:
        backup 0:
                backup_tree_root:       24022006386688  gen: 1322967    level: 2
                backup_chunk_root:      36340959809536  gen: 1275381    level: 2
                backup_extent_root:     24022070910976  gen: 1322968    level: 3
                backup_fs_root:         24022070902784  gen: 1322968    level: 3
                backup_dev_root:        24014655901696  gen: 1275381    level: 2
                backup_csum_root:       24022070956032  gen: 1322968    level: 4
                backup_total_bytes:     21003208163328
                backup_bytes_used:      17670808895488
                backup_num_devices:     1

        backup 1:
                backup_tree_root:       24022114037760  gen: 1322968    level: 2
                backup_chunk_root:      36340959809536  gen: 1275381    level: 2
                backup_extent_root:     24022186385408  gen: 1322969    level: 3
                backup_fs_root:         24022186381312  gen: 1322969    level: 3
                backup_dev_root:        24014655901696  gen: 1275381    level: 2
                backup_csum_root:       24022186536960  gen: 1322969    level: 4
                backup_total_bytes:     21003208163328
                backup_bytes_used:      17670826078208
                backup_num_devices:     1

        backup 2:
                backup_tree_root:       24022309593088  gen: 1322969    level: 2
                backup_chunk_root:      36340959809536  gen: 1275381    level: 2
                backup_extent_root:     24022337949696  gen: 1322970    level: 3
                backup_fs_root:         24022337937408  gen: 1322970    level: 3
                backup_dev_root:        24014655901696  gen: 1275381    level: 2
                backup_csum_root:       24022337990656  gen: 1322970    level: 4
                backup_total_bytes:     21003208163328
                backup_bytes_used:      17670866358272
                backup_num_devices:     1

        backup 3:
                backup_tree_root:       24021840482304  gen: 1322966    level: 2
                backup_chunk_root:      36340959809536  gen: 1275381    level: 2
                backup_extent_root:     24021883957248  gen: 1322967    level: 3
                backup_fs_root:         24021883949056  gen: 1322967    level: 3
                backup_dev_root:        24014655901696  gen: 1275381    level: 2
                backup_csum_root:       24021884100608  gen: 1322967    level: 4
                backup_total_bytes:     21003208163328
                backup_bytes_used:      17670630260736
                backup_num_devices:     1


On Sun, Mar 20, 2016 at 12:02 AM, Chris Murphy <lists@colorremedies.com> wrote:
> On Sat, Mar 19, 2016 at 4:15 PM, Patrick Tschackert <Killing-Time@gmx.de> wrote:
>
>> I'm growing increasingly desperate, can anyone help me? I'm thinking
>> of trying one or more of the following, but would like an informed
>> opinion:
>> 1) btrfs check --fix-crc
>> 2) btrfs-check --init-csum-tree
>> 3) btrfs rescue chunk-recover
>> 4) btrfs-check --repair
>> 5) btrfs rescue zero-log
>
> None of the above. Try 'btrfs check' without any options first.
>
> To me it seems the problem is instigated by lower layers either not
> completing critical writes at the time of the power failure, or didn't
> rebuild correctly.
>
> You should check the SCT ERC setting on each drive with 'smartctl -l
> scterc /dev/sdX' and also the kernel command timer setting with 'cat
> /sys/block/sdX/device/timeout' also for each device. The SCT ERC value
> must be less than the command timer. It's a common misconfiguration
> with raid setups.
>
> After that's fixed you should do a scrub, and I'm thinking it's best
> to do only a check, which means 'echo check >
> /sys/block/mdX/md/sync_action' rather than issuing repair which
> assumes data strips are correct and parity strips are wrong and
> rebuilds all parity strips.
>
>
>>
>> $ uname -a
>> Linux vmhost 3.16.0-4-amd64 #1 SMP Debian 3.16.7-ckt20-1+deb8u4
>> (2016-02-29) x86_64 GNU/Linux
>
> This is old. You should upgrade to something newer, ideally 4.5 but
> 4.4.6 is good also, and then oldest I'd suggest is 4.1.20.
>
>>
>> $ btrfs --version
>> btrfs-progs v4.4
>
> Good.
>
>> $ btrfs fi show
>> Label: none uuid: 9868d803-78d1-40c3-b1ee-a4ce3363df87
>> Total devices 1 FS bytes used 16.07TiB
>> devid 1 size 19.10TiB used 16.27TiB path /dev/mapper/storage
>>
>> excerpt from DMESG:
>> [ 151.970916] BTRFS: device fsid 9868d803-78d1-40c3-b1ee-a4ce3363df87
>> devid 1 transid 1322969 /dev/dm-0
>> [ 163.105784] BTRFS info (device dm-0): disk space caching is enabled
>> [ 165.304968] BTRFS: bad tree block start 4530277753793296986 36340960788480
>> [ 165.305233] BTRFS: bad tree block start 4530277753793296986 36340960788480
>> [ 165.305281] BTRFS: failed to read chunk tree on dm-0
>> [ 165.331407] BTRFS: open_ctree failed
>
> Yeah this isn't a good message typically. There's one surprising (to
> me) case where someone had luck getting this fixed with btrfs-zero-log
> which is unexpected. But I think it's very premature to make changes
> to the file system until you have more information.
>
> What do you get for
> btrfs-find-root /dev/mdX
> btrfs-show-super -fa /dev/mdX
>
>
> --
> Chris Murphy
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

 
