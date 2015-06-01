Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:24388 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751388AbbFABQZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 31 May 2015 21:16:25 -0400
Message-ID: <556BB266.5060904@cn.fujitsu.com>
Date: Mon, 1 Jun 2015 09:16:22 +0800
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
To: Felix Koop <fdp@fkoop.de>, linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: AW: Re: Help needed to recover a RAID5 btrfs
References: <s4g9lo5xb777tq32fufv8s6u.1432920642565@email.android.com>
In-Reply-To: <s4g9lo5xb777tq32fufv8s6u.1432920642565@email.android.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

You can now try the following commands to see which gives the least
error output:

# btrfsck /dev/mapper/Data1vg-afs0 --tree-root <BACKUP_ROOTS>.

Where BACKUP_ROOTS can be one of the following numbers:
1111811768320
1111816585216
1111842062336

Normally I would not recommend the last 2 numbers, but since btrfsck 
without --repair is read-only, so trying them should not do any harm.

Thanks,
Qu

-------- Original Message  --------
Subject: AW: Re: Help needed to recover a RAID5 btrfs
From: Felix Koop <fdp@fkoop.de>
To: linux-btrfs <linux-btrfs@vger.kernel.org>, Qu Wenruo 
<quwenruo@cn.fujitsu.com>
Date: 2015年05月30日 01:30

> Hello list,
>
> can anyone help me how to proceed?
>
>
>
> Von meinem Samsung Gerät gesendet.
>
>
> -------- Ursprüngliche Nachricht --------
> Von: Felix Koop <fdp@fkoop.de>
> Datum: 26.05.2015 22:15 (GMT+01:00)
> An: linux-btrfs <linux-btrfs@vger.kernel.org>, Qu Wenruo
> <quwenruo@cn.fujitsu.com>
> Betreff: Re: Help needed to recover a RAID5 btrfs
>
>  > Qu Wenruo <quwenruo@cn.fujitsu.com> hat am 26. Mai 2015 um 07:56
> geschrieben:
>  >
>  > > Label: none uuid: 7d4b023a-a1ef-4991-b01d-31e7c4fdfbcf
>  > >   Total devices 3 FS bytes used 213.96GiB
>  > >   devid 2 size 150.00GiB used 108.53GiB path /dev/mapper/Data1vg-afs0
>  > >   devid 4 size 150.00GiB used 108.53GiB path /dev/mapper/Data3vg-afs0
>  > >   *** Some devices missing
>  > The device 3, I guest it's /dev/mapper/data2vg-afs0, does it still
>  > exists in /dev/mapper?
>
> No, the disk crashed, so that the device does no longer exist.
>
>  > Need some extra info:
>  >   btrfs-show-super -a -f /dev/mapper/Data1vg-afs0
>
> root@server:~# btrfs-show-super -a -f /dev/mapper/Data1vg-afs0
> superblock: bytenr=65536, device=/dev/mapper/Data1vg-afs0
> ---------------------------------------------------------
> csum 0xc33db89c [match]
> bytenr 65536
> flags 0x1
> magic _BHRfS_M [match]
> fsid 7d4b023a-a1ef-4991-b01d-31e7c4fdfbcf
> label
> generation 35278
> root 1111813750784
> sys_array_size 161
> chunk_root_generation 33824
> root_level 1
> chunk_root 1111721295872
> chunk_root_level 1
> log_root 0
> log_root_transid 0
> log_root_level 0
> total_bytes 483183820800
> bytes_used 229738524672
> sectorsize 4096
> nodesize 16384
> leafsize 16384
> stripesize 4096
> root_dir 6
> num_devices 3
> compat_flags 0x0
> compat_ro_flags 0x0
> incompat_flags 0xe1
> ( MIXED_BACKREF |
>    BIG_METADATA |
>    EXTENDED_IREF |
>    RAID56 )
> csum_type 0
> csum_size 4
> cache_generation 35278
> uuid_tree_generation 35278
> dev_item.uuid 5e5332c3-9e02-4b86-a84e-709f6ac4196b
> dev_item.fsid 7d4b023a-a1ef-4991-b01d-31e7c4fdfbcf [match]
> dev_item.type 0
> dev_item.total_bytes 161061273600
> dev_item.bytes_used 116534542336
> dev_item.io_align 4096
> dev_item.io_width 4096
> dev_item.sector_size 4096
> dev_item.devid 2
> dev_item.dev_group 0
> dev_item.seek_speed 0
> dev_item.bandwidth 0
> dev_item.generation 0
> sys_chunk_array[2048]:
> item 0 key (FIRST_CHUNK_TREE CHUNK_ITEM 1111721246720)
> chunk length 67108864 owner 2 type SYSTEM|RAID5 num_stripes 3
> stripe 0 devid 2 offset 1048576
> stripe 1 devid 4 offset 1048576
> stripe 2 devid 3 offset 1048576
> backup_roots[4]:
> backup 0:
> backup_tree_root: 1111813750784 gen: 35278 level: 1
> backup_chunk_root: 1111721295872 gen: 33824 level: 1
> backup_extent_root: 1111813963776 gen: 35278 level: 2
> backup_fs_root: 1111836409856 gen: 35277 level: 2
> backup_dev_root: 1111814504448 gen: 35278 level: 1
> backup_csum_root: 1111814963200 gen: 35278 level: 2
> backup_total_bytes: 483183820800
> backup_bytes_used: 229738524672
> backup_num_devices: 3
>
> backup 1:
> backup_tree_root: 1111811768320 gen: 35275 level: 1
> backup_chunk_root: 1111721295872 gen: 33824 level: 1
> backup_extent_root: 1111808262144 gen: 35275 level: 2
> backup_fs_root: 1111808081920 gen: 35275 level: 2
> backup_dev_root: 1112427905024 gen: 33824 level: 1
> backup_csum_root: 1111814733824 gen: 35275 level: 2
> backup_total_bytes: 483183820800
> backup_bytes_used: 229738541056
> backup_num_devices: 3
>
> backup 2:
> backup_tree_root: 1111816585216 gen: 35276 level: 1
> backup_chunk_root: 1111721295872 gen: 33824 level: 1
> backup_extent_root: 1111815340032 gen: 35276 level: 2
> backup_fs_root: 1111808983040 gen: 35277 level: 2
> backup_dev_root: 1112427905024 gen: 33824 level: 1
> backup_csum_root: 1111818010624 gen: 35276 level: 2
> backup_total_bytes: 483183820800
> backup_bytes_used: 229738541056
> backup_num_devices: 3
>
> backup 3:
> backup_tree_root: 1111842062336 gen: 35277 level: 1
> backup_chunk_root: 1111721295872 gen: 33824 level: 1
> backup_extent_root: 1111825956864 gen: 35277 level: 2
> backup_fs_root: 1111836409856 gen: 35277 level: 2
> backup_dev_root: 1111842095104 gen: 35277 level: 1
> backup_csum_root: 1111842160640 gen: 35277 level: 2
> backup_total_bytes: 483183820800
> backup_bytes_used: 229738524672
> backup_num_devices: 3
>
>
> superblock: bytenr=67108864, device=/dev/mapper/Data1vg-afs0
> ---------------------------------------------------------
> csum 0x635c9052 [match]
> bytenr 67108864
> flags 0x1
> magic _BHRfS_M [match]
> fsid 7d4b023a-a1ef-4991-b01d-31e7c4fdfbcf
> label
> generation 35278
> root 1111813750784
> sys_array_size 161
> chunk_root_generation 33824
> root_level 1
> chunk_root 1111721295872
> chunk_root_level 1
> log_root 0
> log_root_transid 0
> log_root_level 0
> total_bytes 483183820800
> bytes_used 229738524672
> sectorsize 4096
> nodesize 16384
> leafsize 16384
> stripesize 4096
> root_dir 6
> num_devices 3
> compat_flags 0x0
> compat_ro_flags 0x0
> incompat_flags 0xe1
> ( MIXED_BACKREF |
>    BIG_METADATA |
>    EXTENDED_IREF |
>    RAID56 )
> csum_type 0
> csum_size 4
> cache_generation 35278
> uuid_tree_generation 35278
> dev_item.uuid 5e5332c3-9e02-4b86-a84e-709f6ac4196b
> dev_item.fsid 7d4b023a-a1ef-4991-b01d-31e7c4fdfbcf [match]
> dev_item.type 0
> dev_item.total_bytes 161061273600
> dev_item.bytes_used 116534542336
> dev_item.io_align 4096
> dev_item.io_width 4096
> dev_item.sector_size 4096
> dev_item.devid 2
> dev_item.dev_group 0
> dev_item.seek_speed 0
> dev_item.bandwidth 0
> dev_item.generation 0
> sys_chunk_array[2048]:
> item 0 key (FIRST_CHUNK_TREE CHUNK_ITEM 1111721246720)
> chunk length 67108864 owner 2 type SYSTEM|RAID5 num_stripes 3
> stripe 0 devid 2 offset 1048576
> stripe 1 devid 4 offset 1048576
> stripe 2 devid 3 offset 1048576
> backup_roots[4]:
> backup 0:
> backup_tree_root: 1111813750784 gen: 35278 level: 1
> backup_chunk_root: 1111721295872 gen: 33824 level: 1
> backup_extent_root: 1111813963776 gen: 35278 level: 2
> backup_fs_root: 1111836409856 gen: 35277 level: 2
> backup_dev_root: 1111814504448 gen: 35278 level: 1
> backup_csum_root: 1111814963200 gen: 35278 level: 2
> backup_total_bytes: 483183820800
> backup_bytes_used: 229738524672
> backup_num_devices: 3
>
> backup 1:
> backup_tree_root: 1111811768320 gen: 35275 level: 1
> backup_chunk_root: 1111721295872 gen: 33824 level: 1
> backup_extent_root: 1111808262144 gen: 35275 level: 2
> backup_fs_root: 1111808081920 gen: 35275 level: 2
> backup_dev_root: 1112427905024 gen: 33824 level: 1
> backup_csum_root: 1111814733824 gen: 35275 level: 2
> backup_total_bytes: 483183820800
> backup_bytes_used: 229738541056
> backup_num_devices: 3
>
> backup 2:
> backup_tree_root: 1111816585216 gen: 35276 level: 1
> backup_chunk_root: 1111721295872 gen: 33824 level: 1
> backup_extent_root: 1111815340032 gen: 35276 level: 2
> backup_fs_root: 1111808983040 gen: 35277 level: 2
> backup_dev_root: 1112427905024 gen: 33824 level: 1
> backup_csum_root: 1111818010624 gen: 35276 level: 2
> backup_total_bytes: 483183820800
> backup_bytes_used: 229738541056
> backup_num_devices: 3
>
> backup 3:
> backup_tree_root: 1111842062336 gen: 35277 level: 1
> backup_chunk_root: 1111721295872 gen: 33824 level: 1
> backup_extent_root: 1111825956864 gen: 35277 level: 2
> backup_fs_root: 1111836409856 gen: 35277 level: 2
> backup_dev_root: 1111842095104 gen: 35277 level: 1
> backup_csum_root: 1111842160640 gen: 35277 level: 2
> backup_total_bytes: 483183820800
> backup_bytes_used: 229738524672
> backup_num_devices: 3
>
>
>
>
>
>  >   btrfs-show-super -a -f /dev/mapper/Data2vg-afs0 (If that is device3
>  > and exists)
>
> As I said, the device does no longer exist, because the disk crashed.
>
>  >   btrfs-show-super -a -f /dev/mapper/Data3vg-afs0
>
> root@server:~# btrfs-show-super -a -f /dev/mapper/Data3vg-afs0
> superblock: bytenr=65536, device=/dev/mapper/Data3vg-afs0
> ---------------------------------------------------------
> csum 0xe3500af0 [match]
> bytenr 65536
> flags 0x1
> magic _BHRfS_M [match]
> fsid 7d4b023a-a1ef-4991-b01d-31e7c4fdfbcf
> label
> generation 35278
> root 1111813750784
> sys_array_size 161
> chunk_root_generation 33824
> root_level 1
> chunk_root 1111721295872
> chunk_root_level 1
> log_root 0
> log_root_transid 0
> log_root_level 0
> total_bytes 483183820800
> bytes_used 229738524672
> sectorsize 4096
> nodesize 16384
> leafsize 16384
> stripesize 4096
> root_dir 6
> num_devices 3
> compat_flags 0x0
> compat_ro_flags 0x0
> incompat_flags 0xe1
> ( MIXED_BACKREF |
>    BIG_METADATA |
>    EXTENDED_IREF |
>    RAID56 )
> csum_type 0
> csum_size 4
> cache_generation 35278
> uuid_tree_generation 35278
> dev_item.uuid ce22bfec-b82d-42cf-8703-8f1eaa17a1ec
> dev_item.fsid 7d4b023a-a1ef-4991-b01d-31e7c4fdfbcf [match]
> dev_item.type 0
> dev_item.total_bytes 161061273600
> dev_item.bytes_used 116534542336
> dev_item.io_align 4096
> dev_item.io_width 4096
> dev_item.sector_size 4096
> dev_item.devid 4
> dev_item.dev_group 0
> dev_item.seek_speed 0
> dev_item.bandwidth 0
> dev_item.generation 0
> sys_chunk_array[2048]:
> item 0 key (FIRST_CHUNK_TREE CHUNK_ITEM 1111721246720)
> chunk length 67108864 owner 2 type SYSTEM|RAID5 num_stripes 3
> stripe 0 devid 2 offset 1048576
> stripe 1 devid 4 offset 1048576
> stripe 2 devid 3 offset 1048576
> backup_roots[4]:
> backup 0:
> backup_tree_root: 1111813750784 gen: 35278 level: 1
> backup_chunk_root: 1111721295872 gen: 33824 level: 1
> backup_extent_root: 1111813963776 gen: 35278 level: 2
> backup_fs_root: 1111836409856 gen: 35277 level: 2
> backup_dev_root: 1111814504448 gen: 35278 level: 1
> backup_csum_root: 1111814963200 gen: 35278 level: 2
> backup_total_bytes: 483183820800
> backup_bytes_used: 229738524672
> backup_num_devices: 3
>
> backup 1:
> backup_tree_root: 1111811768320 gen: 35275 level: 1
> backup_chunk_root: 1111721295872 gen: 33824 level: 1
> backup_extent_root: 1111808262144 gen: 35275 level: 2
> backup_fs_root: 1111808081920 gen: 35275 level: 2
> backup_dev_root: 1112427905024 gen: 33824 level: 1
> backup_csum_root: 1111814733824 gen: 35275 level: 2
> backup_total_bytes: 483183820800
> backup_bytes_used: 229738541056
> backup_num_devices: 3
>
> backup 2:
> backup_tree_root: 1111816585216 gen: 35276 level: 1
> backup_chunk_root: 1111721295872 gen: 33824 level: 1
> backup_extent_root: 1111815340032 gen: 35276 level: 2
> backup_fs_root: 1111808983040 gen: 35277 level: 2
> backup_dev_root: 1112427905024 gen: 33824 level: 1
> backup_csum_root: 1111818010624 gen: 35276 level: 2
> backup_total_bytes: 483183820800
> backup_bytes_used: 229738541056
> backup_num_devices: 3
>
> backup 3:
> backup_tree_root: 1111842062336 gen: 35277 level: 1
> backup_chunk_root: 1111721295872 gen: 33824 level: 1
> backup_extent_root: 1111825956864 gen: 35277 level: 2
> backup_fs_root: 1111836409856 gen: 35277 level: 2
> backup_dev_root: 1111842095104 gen: 35277 level: 1
> backup_csum_root: 1111842160640 gen: 35277 level: 2
> backup_total_bytes: 483183820800
> backup_bytes_used: 229738524672
> backup_num_devices: 3
>
>
> superblock: bytenr=67108864, device=/dev/mapper/Data3vg-afs0
> ---------------------------------------------------------
> csum 0x4331223e [match]
> bytenr 67108864
> flags 0x1
> magic _BHRfS_M [match]
> fsid 7d4b023a-a1ef-4991-b01d-31e7c4fdfbcf
> label
> generation 35278
> root 1111813750784
> sys_array_size 161
> chunk_root_generation 33824
> root_level 1
> chunk_root 1111721295872
> chunk_root_level 1
> log_root 0
> log_root_transid 0
> log_root_level 0
> total_bytes 483183820800
> bytes_used 229738524672
> sectorsize 4096
> nodesize 16384
> leafsize 16384
> stripesize 4096
> root_dir 6
> num_devices 3
> compat_flags 0x0
> compat_ro_flags 0x0
> incompat_flags 0xe1
> ( MIXED_BACKREF |
>    BIG_METADATA |
>    EXTENDED_IREF |
>    RAID56 )
> csum_type 0
> csum_size 4
> cache_generation 35278
> uuid_tree_generation 35278
> dev_item.uuid ce22bfec-b82d-42cf-8703-8f1eaa17a1ec
> dev_item.fsid 7d4b023a-a1ef-4991-b01d-31e7c4fdfbcf [match]
> dev_item.type 0
> dev_item.total_bytes 161061273600
> dev_item.bytes_used 116534542336
> dev_item.io_align 4096
> dev_item.io_width 4096
> dev_item.sector_size 4096
> dev_item.devid 4
> dev_item.dev_group 0
> dev_item.seek_speed 0
> dev_item.bandwidth 0
> dev_item.generation 0
> sys_chunk_array[2048]:
> item 0 key (FIRST_CHUNK_TREE CHUNK_ITEM 1111721246720)
> chunk length 67108864 owner 2 type SYSTEM|RAID5 num_stripes 3
> stripe 0 devid 2 offset 1048576
> stripe 1 devid 4 offset 1048576
> stripe 2 devid 3 offset 1048576
> backup_roots[4]:
> backup 0:
> backup_tree_root: 1111813750784 gen: 35278 level: 1
> backup_chunk_root: 1111721295872 gen: 33824 level: 1
> backup_extent_root: 1111813963776 gen: 35278 level: 2
> backup_fs_root: 1111836409856 gen: 35277 level: 2
> backup_dev_root: 1111814504448 gen: 35278 level: 1
> backup_csum_root: 1111814963200 gen: 35278 level: 2
> backup_total_bytes: 483183820800
> backup_bytes_used: 229738524672
> backup_num_devices: 3
>
> backup 1:
> backup_tree_root: 1111811768320 gen: 35275 level: 1
> backup_chunk_root: 1111721295872 gen: 33824 level: 1
> backup_extent_root: 1111808262144 gen: 35275 level: 2
> backup_fs_root: 1111808081920 gen: 35275 level: 2
> backup_dev_root: 1112427905024 gen: 33824 level: 1
> backup_csum_root: 1111814733824 gen: 35275 level: 2
> backup_total_bytes: 483183820800
> backup_bytes_used: 229738541056
> backup_num_devices: 3
>
> backup 2:
> backup_tree_root: 1111816585216 gen: 35276 level: 1
> backup_chunk_root: 1111721295872 gen: 33824 level: 1
> backup_extent_root: 1111815340032 gen: 35276 level: 2
> backup_fs_root: 1111808983040 gen: 35277 level: 2
> backup_dev_root: 1112427905024 gen: 33824 level: 1
> backup_csum_root: 1111818010624 gen: 35276 level: 2
> backup_total_bytes: 483183820800
> backup_bytes_used: 229738541056
> backup_num_devices: 3
>
> backup 3:
> backup_tree_root: 1111842062336 gen: 35277 level: 1
> backup_chunk_root: 1111721295872 gen: 33824 level: 1
> backup_extent_root: 1111825956864 gen: 35277 level: 2
> backup_fs_root: 1111836409856 gen: 35277 level: 2
> backup_dev_root: 1111842095104 gen: 35277 level: 1
> backup_csum_root: 1111842160640 gen: 35277 level: 2
> backup_total_bytes: 483183820800
> backup_bytes_used: 229738524672
> backup_num_devices: 3
>
>
>
>
>  >
>  > Maybe we can use old super to restore it to a mountable status.
>  >
>  > If you have spare space to backup all the 3 devices, it's recommended to
>  > do it, as some repair tips may cause some write into disk, and may even
>  > make things worse.
>  >
>
> Will do. I have enough space.
>
>
>
> Mit freundlichen Grüßen/Kind regards
>
>
>
>
>
> Felix Koop
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
