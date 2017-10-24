Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail1.arhont.com ([178.248.108.111]:37078 "EHLO
        mail1.arhont.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751742AbdJXTCu (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 24 Oct 2017 15:02:50 -0400
Date: Tue, 24 Oct 2017 20:02:42 +0100 (BST)
From: "Konstantin V. Gavrilenko" <k.gavrilenko@arhont.com>
To: Linux fs Btrfs <linux-btrfs@vger.kernel.org>
Cc: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <27675301.364.1508871760291.JavaMail.gkos@dynomob>
In-Reply-To: <b040ab81-b40a-7ace-b493-5e5c539e7231@gmx.com>
References: <13409678.203.1508836811909.JavaMail.gkos@dynomob> <bde403d9-c487-d385-deb1-35c898765f7a@gmx.com> <14075786.243.1508845404640.JavaMail.gkos@dynomob> <b040ab81-b40a-7ace-b493-5e5c539e7231@gmx.com>
Subject: Re: super_total_bytes 32004083023872 mismatch with fs_devices
 total_rw_bytes 64008166047744
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The mentioning of the device scan scode and the fact the total_bytes is double made me try hashing the raid from the fstab.
So i booted, run the "inspect-internal dump-super" that confirmed that it is in order.
# grep -i total_bytes hashed-inspect-internal

total_bytes             32004083023872
dev_item.total_bytes    32004083023872
                backup_total_bytes:     32004083023872
                backup_total_bytes:     32004083023872
                backup_total_bytes:     32004083023872
                backup_total_bytes:     32004083023872
total_bytes             32004083023872
dev_item.total_bytes    32004083023872
                backup_total_bytes:     32004083023872
                backup_total_bytes:     32004083023872
                backup_total_bytes:     32004083023872
                backup_total_bytes:     32004083023872
total_bytes             32004083023872
dev_item.total_bytes    32004083023872
                backup_total_bytes:     32004083023872
                backup_total_bytes:     32004083023872
                backup_total_bytes:     32004083023872
                backup_total_bytes:     32004083023872

then I unhashed the device in fstab, mounted it manually and it successfully mounted. 

# time mount /mnt/arh-backup1/

real    2m49.021s
user    0m0.000s
sys     0m1.244s



With the unhashed device in the fstab, i rebooted and upon reboot I run mount

time mount /mnt/arh-backup1/
mount: wrong fs type, bad option, bad superblock on /dev/sda,
       missing codepage or helper program, or other error

       In some cases useful info is found in syslog - try
       dmesg | tail or so.

real    1m20.499s
user    0m0.000s
sys     0m0.045s

that failed. I further waited for couple of minutes and run the mount again, and it mounted successfully.


So it seems that because of the amount of time it takes mount, nearly 3 minutes, to mount the device, there is some sort of race condition, and two device scans are running at the same time, or something similar.
I can say one thing for sure, it wasn't happening on 4.10 and I have only observed such behaviour on 4.12 and 4.13

p.s. the disk does not mount automatically upon boot, but can be mounted manually later


# uptime 
 19:54:45 up 4 min,  1 user,  load average: 0.30, 0.74, 0.39

# time mount /mnt/arh-backup1/

real    2m52.247s
user    0m0.000s
sys     0m1.246s


Here is the  dmesg extract. It seems that for some reason on 204th second the system return "open ctree failed" 
on 329 second, I started the mount manually.

[  204.389231] BTRFS error (device sda): open_ctree failed
[  329.234613] BTRFS info (device sda): force zlib compression
[  329.234618] BTRFS info (device sda): using free space tree
[  329.234620] BTRFS info (device sda): has skinny extents


hope that helps and thanks for your help


Yours sincerely,
Konstantin V. Gavrilenko



----- Original Message -----
From: "Qu Wenruo" <quwenruo.btrfs@gmx.com>
To: "Konstantin V. Gavrilenko" <k.gavrilenko@arhont.com>
Cc: "Linux fs Btrfs" <linux-btrfs@vger.kernel.org>
Sent: Tuesday, 24 October, 2017 3:44:21 PM
Subject: Re: super_total_bytes 32004083023872 mismatch with fs_devices total_rw_bytes 64008166047744



On 2017年10月24日 19:44, Konstantin V. Gavrilenko wrote:
> answers inline marked with KVG:
> 
> Yours sincerely,
> Konstantin V. Gavrilenko
> 
> 
> 
> 
> ----- Original Message -----
> From: "Qu Wenruo" <quwenruo.btrfs@gmx.com>
> To: "Konstantin V. Gavrilenko" <k.gavrilenko@arhont.com>, "Linux fs Btrfs" <linux-btrfs@vger.kernel.org>
> Sent: Tuesday, 24 October, 2017 11:37:56 AM
> Subject: Re: super_total_bytes 32004083023872 mismatch with fs_devices total_rw_bytes 64008166047744
> 
> 
> 
> On 2017年10月24日 17:20, Konstantin V. Gavrilenko wrote:
>> Hi list,
>>
>> having installed the recent kernel version I am no longer able to mount the btrfs partition with compression on the first attempt. Previously on 4.10.0-37-generic everything was working fine, once I switched to 4.13.9-041309-generic I started getting the following error while trying to mount it with the same  options "compress-force=zlib,space_cache=v2"
>>
>> [  204.596381] BTRFS error (device sda): open_ctree failed
>> [  204.631895] BTRFS info (device sda): force zlib compression
>> [  204.631901] BTRFS info (device sda): using free space tree
>> [  204.631903] BTRFS info (device sda): has skinny extents
>> [  204.890145] BTRFS error (device sda): super_total_bytes 32004083023872 mismatch with fs_devices total_rw_bytes 64008166047744
>> [  204.891276] BTRFS error (device sda): failed to read chunk tree: -22
>> [  204.944333] BTRFS error (device sda): open_ctree failed
> 
> Such problem can be easily fixed with this branch:
> https://github.com/adam900710/btrfs-progs/tree/check_unaligned_dev
> 
> Use "btrfs rescue fix-device-size" should handle it well.
> 
> But the problem is, normally the super_total_bytes should only be less
> than 4K smaller than total device size.
> 
> Unless something else went wrong, it should not have such large difference.
> 
> 
> KVG: Thanks, will try. 
> The drive was initially created as RAID5 with 4 x 8tb devices, and later expanded to included another 8Tb. So now it is 5x8tb RAID5.
> 
> 
>>
>> For some reason, the super_total_bytes is exactly half of total_rw_bytes.
>>
>>
>> however, if after unsuccessful first mount attempt, I mount it with minimum number of options "space_cache=v2" the partition mounts. Then I umount it, and mount normally, with full set of options "compress-force=zlib,space_cache=v2" it mounts without an error.
>> I also observed the same error on 4.12.14-041214-generic
>> Any ideas why this might be happening?
> 
> Would you please provide super dump by:
> 
> # btrfs inspect-internal dump-super -fa /dev/sda
> 
> (Although I don't think it will be very interesting since it can be
> mounted later)
> 
> 
> KVG: here you go
> 
> # btrfs inspect-internal dump-super -fa /dev/sda
> superblock: bytenr=65536, device=/dev/sda
> ---------------------------------------------------------
> csum_type               0 (crc32c)
> csum_size               4
> csum                    0xc4b95762 [match]
> bytenr                  65536
> flags                   0x1
>                         ( WRITTEN )
> magic                   _BHRfS_M [match]
> fsid                    017b587a-3e88-4f08-8616-ec686f8f969f
> label                   arh-backup
> generation              145942
> root                    17334200778752
> sys_array_size          129
> chunk_root_generation   145699
> root_level              1
> chunk_root              20971520
> chunk_root_level        1
> log_root                17334149644288
> log_root_transid        0
> log_root_level          0
> total_bytes             32004083023872

Here 32004083023872.
> bytes_used              19719727349760
> sectorsize              4096
> nodesize                16384
> leafsize (deprecated)           16384
> stripesize              4096
> root_dir                6
> num_devices             1
> compat_flags            0x0
> compat_ro_flags         0x3
>                         ( FREE_SPACE_TREE |
>                           FREE_SPACE_TREE_VALID )
> incompat_flags          0x169
>                         ( MIXED_BACKREF |
>                           COMPRESS_LZO |
>                           BIG_METADATA |
>                           EXTENDED_IREF |
>                           SKINNY_METADATA )
> cache_generation        7
> uuid_tree_generation    145942
> dev_item.uuid           ee632cde-2139-4181-9d57-ff892768f2ef
> dev_item.fsid           017b587a-3e88-4f08-8616-ec686f8f969f [match]
> dev_item.type           0
> dev_item.total_bytes    32004083023872
And here, 32004083023872 again.

So it matches now.

And considering the original report says it's twice the size, I wonder
if it's something related to device scan.

Like the same disk get counted twice, so it's reporting like that.

If the problem happens again, would you please try run "btrfs device
scan" and remount it with the same mount option?


> dev_item.bytes_used     19832028266496
> dev_item.io_align       4096
> dev_item.io_width       4096
> dev_item.sector_size    4096
> dev_item.devid          1
> dev_item.dev_group      0
> dev_item.seek_speed     0
> dev_item.bandwidth      0
> dev_item.generation     0
> sys_chunk_array[2048]:
>         item 0 key (FIRST_CHUNK_TREE CHUNK_ITEM 20971520)
>                 length 8388608 owner 2 stripe_len 65536 type SYSTEM|DUP
>                 io_align 65536 io_width 65536 sector_size 4096
>                 num_stripes 2 sub_stripes 0
>                         stripe 0 devid 1 offset 20971520
>                         dev_uuid ee632cde-2139-4181-9d57-ff892768f2ef
>                         stripe 1 devid 1 offset 29360128
>                         dev_uuid ee632cde-2139-4181-9d57-ff892768f2ef
> backup_roots[4]:
>         backup 0:
>                 backup_tree_root:       17334200778752  gen: 145940     level: 1
>                 backup_chunk_root:      20971520        gen: 145699     level: 1
>                 backup_extent_root:     17334177021952  gen: 145940     level: 3
>                 backup_fs_root:         17334133260288  gen: 145941     level: 3
>                 backup_dev_root:        32391168        gen: 145836     level: 1
>                 backup_csum_root:       17154410381312  gen: 145925     level: 3
>                 backup_total_bytes:     32004083023872
>                 backup_bytes_used:      19719727349760
>                 backup_num_devices:     1
> 
>         backup 1:
>                 backup_tree_root:       17334201057280  gen: 145941     level: 1
>                 backup_chunk_root:      20971520        gen: 145699     level: 1
>                 backup_extent_root:     17334177988608  gen: 145941     level: 3
>                 backup_fs_root:         17334133161984  gen: 145942     level: 3
>                 backup_dev_root:        32391168        gen: 145836     level: 1
>                 backup_csum_root:       17154410381312  gen: 145925     level: 3
>                 backup_total_bytes:     32004083023872
>                 backup_bytes_used:      19719727349760
>                 backup_num_devices:     1
> 
>         backup 2:
>                 backup_tree_root:       17334200778752  gen: 145942     level: 1
>                 backup_chunk_root:      20971520        gen: 145699     level: 1
>                 backup_extent_root:     17334184558592  gen: 145942     level: 3
>                 backup_fs_root:         17334135275520  gen: 145943     level: 3
>                 backup_dev_root:        32391168        gen: 145836     level: 1
>                 backup_csum_root:       17154410381312  gen: 145925     level: 3
>                 backup_total_bytes:     32004083023872
>                 backup_bytes_used:      19719727349760
>                 backup_num_devices:     1
> 
>         backup 3:
>                 backup_tree_root:       17334201057280  gen: 145939     level: 1
>                 backup_chunk_root:      20971520        gen: 145699     level: 1
>                 backup_extent_root:     17334177988608  gen: 145939     level: 3
>                 backup_fs_root:         17334131884032  gen: 145940     level: 3
>                 backup_dev_root:        32391168        gen: 145836     level: 1
>                 backup_csum_root:       17154410381312  gen: 145925     level: 3
>                 backup_total_bytes:     32004083023872
>                 backup_bytes_used:      19719727349760
>                 backup_num_devices:     1
> 
> 
> superblock: bytenr=67108864, device=/dev/sda
> ---------------------------------------------------------
> csum_type               0 (crc32c)
> csum_size               4
> csum                    0xd1c4187f [match]
> bytenr                  67108864
> flags                   0x1
>                         ( WRITTEN )
> magic                   _BHRfS_M [match]
> fsid                    017b587a-3e88-4f08-8616-ec686f8f969f
> label                   arh-backup
> generation              145942
> root                    17334200778752
> sys_array_size          129
> chunk_root_generation   145699
> root_level              1
> chunk_root              20971520
> chunk_root_level        1
> log_root                0
> log_root_transid        0
> log_root_level          0
> total_bytes             32004083023872
> bytes_used              19719727349760
> sectorsize              4096
> nodesize                16384
> leafsize (deprecated)           16384
> stripesize              4096
> root_dir                6
> num_devices             1
> compat_flags            0x0
> compat_ro_flags         0x3
>                         ( FREE_SPACE_TREE |
>                           FREE_SPACE_TREE_VALID )
> incompat_flags          0x169
>                         ( MIXED_BACKREF |
>                           COMPRESS_LZO |
>                           BIG_METADATA |
>                           EXTENDED_IREF |
>                           SKINNY_METADATA )
> cache_generation        7
> uuid_tree_generation    145942
> dev_item.uuid           ee632cde-2139-4181-9d57-ff892768f2ef
> dev_item.fsid           017b587a-3e88-4f08-8616-ec686f8f969f [match]
> dev_item.type           0
> dev_item.total_bytes    32004083023872
> dev_item.bytes_used     19832028266496
> dev_item.io_align       4096
> dev_item.io_width       4096
> dev_item.sector_size    4096
> dev_item.devid          1
> dev_item.dev_group      0
> dev_item.seek_speed     0
> dev_item.bandwidth      0
> dev_item.generation     0
> sys_chunk_array[2048]:
>         item 0 key (FIRST_CHUNK_TREE CHUNK_ITEM 20971520)
>                 length 8388608 owner 2 stripe_len 65536 type SYSTEM|DUP
>                 io_align 65536 io_width 65536 sector_size 4096
>                 num_stripes 2 sub_stripes 0
>                         stripe 0 devid 1 offset 20971520
>                         dev_uuid ee632cde-2139-4181-9d57-ff892768f2ef
>                         stripe 1 devid 1 offset 29360128
>                         dev_uuid ee632cde-2139-4181-9d57-ff892768f2ef
> backup_roots[4]:
>         backup 0:
>                 backup_tree_root:       17334200778752  gen: 145940     level: 1
>                 backup_chunk_root:      20971520        gen: 145699     level: 1
>                 backup_extent_root:     17334177021952  gen: 145940     level: 3
>                 backup_fs_root:         17334133260288  gen: 145941     level: 3
>                 backup_dev_root:        32391168        gen: 145836     level: 1
>                 backup_csum_root:       17154410381312  gen: 145925     level: 3
>                 backup_total_bytes:     32004083023872
>                 backup_bytes_used:      19719727349760
>                 backup_num_devices:     1
> 
>         backup 1:
>                 backup_tree_root:       17334201057280  gen: 145941     level: 1
>                 backup_chunk_root:      20971520        gen: 145699     level: 1
>                 backup_extent_root:     17334177988608  gen: 145941     level: 3
>                 backup_fs_root:         17334133161984  gen: 145942     level: 3
>                 backup_dev_root:        32391168        gen: 145836     level: 1
>                 backup_csum_root:       17154410381312  gen: 145925     level: 3
>                 backup_total_bytes:     32004083023872
>                 backup_bytes_used:      19719727349760
>                 backup_num_devices:     1
> 
>         backup 2:
>                 backup_tree_root:       17334200778752  gen: 145942     level: 1
>                 backup_chunk_root:      20971520        gen: 145699     level: 1
>                 backup_extent_root:     17334184558592  gen: 145942     level: 3
>                 backup_fs_root:         17334133161984  gen: 145942     level: 3
>                 backup_dev_root:        32391168        gen: 145836     level: 1
>                 backup_csum_root:       17154410381312  gen: 145925     level: 3
>                 backup_total_bytes:     32004083023872
>                 backup_bytes_used:      19719727349760
>                 backup_num_devices:     1
> 
>         backup 3:
>                 backup_tree_root:       17334201057280  gen: 145939     level: 1
>                 backup_chunk_root:      20971520        gen: 145699     level: 1
>                 backup_extent_root:     17334177988608  gen: 145939     level: 3
>                 backup_fs_root:         17334131884032  gen: 145940     level: 3
>                 backup_dev_root:        32391168        gen: 145836     level: 1
>                 backup_csum_root:       17154410381312  gen: 145925     level: 3
>                 backup_total_bytes:     32004083023872
>                 backup_bytes_used:      19719727349760
>                 backup_num_devices:     1
> 
> 
> superblock: bytenr=274877906944, device=/dev/sda
> ---------------------------------------------------------
> csum_type               0 (crc32c)
> csum_size               4
> csum                    0x2c434e4e [match]
> bytenr                  274877906944
> flags                   0x1
>                         ( WRITTEN )
> magic                   _BHRfS_M [match]
> fsid                    017b587a-3e88-4f08-8616-ec686f8f969f
> label                   arh-backup
> generation              145942
> root                    17334200778752
> sys_array_size          129
> chunk_root_generation   145699
> root_level              1
> chunk_root              20971520
> chunk_root_level        1
> log_root                0
> log_root_transid        0
> log_root_level          0
> total_bytes             32004083023872
> bytes_used              19719727349760
> sectorsize              4096
> nodesize                16384
> leafsize (deprecated)           16384
> stripesize              4096
> root_dir                6
> num_devices             1
> compat_flags            0x0
> compat_ro_flags         0x3
>                         ( FREE_SPACE_TREE |
>                           FREE_SPACE_TREE_VALID )
> incompat_flags          0x169
>                         ( MIXED_BACKREF |
>                           COMPRESS_LZO |
>                           BIG_METADATA |
>                           EXTENDED_IREF |
>                           SKINNY_METADATA )
> cache_generation        7
> uuid_tree_generation    145942
> dev_item.uuid           ee632cde-2139-4181-9d57-ff892768f2ef
> dev_item.fsid           017b587a-3e88-4f08-8616-ec686f8f969f [match]
> dev_item.type           0
> dev_item.total_bytes    32004083023872
> dev_item.bytes_used     19832028266496
> dev_item.io_align       4096
> dev_item.io_width       4096
> dev_item.sector_size    4096
> dev_item.devid          1
> dev_item.dev_group      0
> dev_item.seek_speed     0
> dev_item.bandwidth      0
> dev_item.generation     0
> sys_chunk_array[2048]:
>         item 0 key (FIRST_CHUNK_TREE CHUNK_ITEM 20971520)
>                 length 8388608 owner 2 stripe_len 65536 type SYSTEM|DUP
>                 io_align 65536 io_width 65536 sector_size 4096
>                 num_stripes 2 sub_stripes 0
>                         stripe 0 devid 1 offset 20971520
>                         dev_uuid ee632cde-2139-4181-9d57-ff892768f2ef
>                         stripe 1 devid 1 offset 29360128
>                         dev_uuid ee632cde-2139-4181-9d57-ff892768f2ef
> backup_roots[4]:
>         backup 0:
>                 backup_tree_root:       17334200778752  gen: 145940     level: 1
>                 backup_chunk_root:      20971520        gen: 145699     level: 1
>                 backup_extent_root:     17334177021952  gen: 145940     level: 3
>                 backup_fs_root:         17334133260288  gen: 145941     level: 3
>                 backup_dev_root:        32391168        gen: 145836     level: 1
>                 backup_csum_root:       17154410381312  gen: 145925     level: 3
>                 backup_total_bytes:     32004083023872
>                 backup_bytes_used:      19719727349760
>                 backup_num_devices:     1
> 
>         backup 1:
>                 backup_tree_root:       17334201057280  gen: 145941     level: 1
>                 backup_chunk_root:      20971520        gen: 145699     level: 1
>                 backup_extent_root:     17334177988608  gen: 145941     level: 3
>                 backup_fs_root:         17334133161984  gen: 145942     level: 3
>                 backup_dev_root:        32391168        gen: 145836     level: 1
>                 backup_csum_root:       17154410381312  gen: 145925     level: 3
>                 backup_total_bytes:     32004083023872
>                 backup_bytes_used:      19719727349760
>                 backup_num_devices:     1
> 
>         backup 2:
>                 backup_tree_root:       17334200778752  gen: 145942     level: 1
>                 backup_chunk_root:      20971520        gen: 145699     level: 1
>                 backup_extent_root:     17334184558592  gen: 145942     level: 3
>                 backup_fs_root:         17334133161984  gen: 145942     level: 3
>                 backup_dev_root:        32391168        gen: 145836     level: 1
>                 backup_csum_root:       17154410381312  gen: 145925     level: 3
>                 backup_total_bytes:     32004083023872
>                 backup_bytes_used:      19719727349760
>                 backup_num_devices:     1
> 
>         backup 3:
>                 backup_tree_root:       17334201057280  gen: 145939     level: 1
>                 backup_chunk_root:      20971520        gen: 145699     level: 1
>                 backup_extent_root:     17334177988608  gen: 145939     level: 3
>                 backup_fs_root:         17334131884032  gen: 145940     level: 3
>                 backup_dev_root:        32391168        gen: 145836     level: 1
>                 backup_csum_root:       17154410381312  gen: 145925     level: 3
>                 backup_total_bytes:     32004083023872
>                 backup_bytes_used:      19719727349760
>                 backup_num_devices:     1
> 
> 
> 
> 
> 
> And device tree dump by:
> # btrfs inspect-internal dump-tree -t dev /dev/sda
> 
> KVG: Here you go again
> 
> # btrfs inspect-internal dump-tree -t dev /dev/sda > /tmp/inspect-internal-dump-tree
> parent transid verify failed on 17334203744256 wanted 145954 found 145956
> parent transid verify failed on 17334203744256 wanted 145954 found 145956
> parent transid verify failed on 17334203744256 wanted 145954 found 145956
> parent transid verify failed on 17334203744256 wanted 145954 found 145956
> Ignoring transid failure
> 
> # wc -l < inspect-internal-dump-tree                                                                                                                                                     74760

That's beyond my expectation, but since the super block matches, I
wonder it's related to device scan implemented wrongly or has some race.

And in that case, dump-tree output is not that important.

BTW, are you running dump-tree with device mounted? If so the transid
verification failure may not be a big problem.

> 
> 
> # head -n 150 < inspect-internal-dump-tree                                                                                                                                               [13:28:00]
> btrfs-progs v4.13.3
> device tree key (DEV_TREE ROOT_ITEM 0) 
> node 32391168 level 1 items 88 free 405 generation 145836 owner 4
> fs uuid 017b587a-3e88-4f08-8616-ec686f8f969f
> chunk uuid 5820b5e3-9610-4cf3-a37a-b638a9963084
>         key (0 PERSISTENT_ITEM 1) block 32407552 (1978) gen 145836
>         key (1 DEV_EXTENT 234113466368) block 231767769088 (14145982) gen 274
>         key (1 DEV_EXTENT 473557893120) block 484797186048 (29589672) gen 378
>         key (1 DEV_EXTENT 710854836224) block 861293805568 (52569202) gen 482
>         key (1 DEV_EXTENT 949225521152) block 1042388156416 (63622324) gen 587
>         key (1 DEV_EXTENT 1187596206080) block 1221328453632 (74543973) gen 691
>         key (1 DEV_EXTENT 1424893149184) block 1583808970752 (96668028) gen 764
>         key (1 DEV_EXTENT 1662190092288) block 1603743318016 (97884724) gen 843
>         key (1 DEV_EXTENT 1900560777216) block 2231483187200 (136198925) gen 1017
>         key (1 DEV_EXTENT 2138931462144) block 2241853407232 (136831873) gen 1080
>         key (1 DEV_EXTENT 2371933437952) block 2268266070016 (138443974) gen 1138
>         key (1 DEV_EXTENT 2610304122880) block 2311626964992 (141090513) gen 1177
>         key (1 DEV_EXTENT 2848674807808) block 2590371545088 (158103732) gen 1263
>         key (1 DEV_EXTENT 3088119234560) block 2837798567936 (173205479) gen 1314
>         key (1 DEV_EXTENT 3326489919488) block 3114321903616 (190083124) gen 1372
>         key (1 DEV_EXTENT 3564860604416) block 3591785086976 (219225164) gen 1448
>         key (1 DEV_EXTENT 3802157547520) block 3718121062400 (226936100) gen 1524
>         key (1 DEV_EXTENT 4040528232448) block 21927333150720 (1338338205) gen 136290
>         key (1 DEV_EXTENT 4278898917376) block 4133925863424 (252314811) gen 1724
>         key (1 DEV_EXTENT 4516195860480) block 22441652109312 (1369729743) gen 133266
>         key (1 DEV_EXTENT 4755640287232) block 14608468082688 (891630132) gen 133130
>         key (1 DEV_EXTENT 4992937230336) block 5180103491584 (316168426) gen 2146
>         key (1 DEV_EXTENT 5231307915264) block 20077315735552 (1225422103) gen 131467
>         key (1 DEV_EXTENT 5468604858368) block 5866555588608 (358066137) gen 3067
>         key (1 DEV_EXTENT 5705901801472) block 6367858622464 (388663246) gen 3174
>         key (1 DEV_EXTENT 5826160885760) block 6367858638848 (388663247) gen 3174
>         key (1 DEV_EXTENT 6064531570688) block 17709247496192 (1080886688) gen 63205
>         key (1 DEV_EXTENT 6303975997440) block 17459226411008 (1065626612) gen 145661
>         key (1 DEV_EXTENT 6500470751232) block 17459593674752 (1065649028) gen 145669
>         key (1 DEV_EXTENT 6737767694336) block 14608384458752 (891625028) gen 132007
>         key (1 DEV_EXTENT 6976138379264) block 15230725767168 (929609727) gen 132017
>         key (1 DEV_EXTENT 7136125911040) block 13657160859648 (833566947) gen 137915
>         key (1 DEV_EXTENT 7255311253504) block 13657457180672 (833585033) gen 137917
>         key (1 DEV_EXTENT 7492608196608) block 22441489580032 (1369719823) gen 136294
>         key (1 DEV_EXTENT 7730978881536) block 13854137253888 (845589432) gen 138616
>         key (1 DEV_EXTENT 7969349566464) block 7788285968384 (475359251) gen 140545
>         key (1 DEV_EXTENT 8207720251392) block 14113310818304 (861408131) gen 127092
>         key (1 DEV_EXTENT 8446090936320) block 8679398998016 (529748474) gen 17985
>         key (1 DEV_EXTENT 8684461621248) block 8916314619904 (544208656) gen 18574
>         key (1 DEV_EXTENT 8922832306176) block 29434636730368 (1796547652) gen 144688
>         key (1 DEV_EXTENT 9157981765632) block 6453626322944 (393898091) gen 145220
>         key (1 DEV_EXTENT 9361992712192) block 19459087679488 (1187688457) gen 132049
>         key (1 DEV_EXTENT 9600363397120) block 12893675651072 (786967508) gen 116367
>         key (1 DEV_EXTENT 9720622481408) block 22441517318144 (1369721516) gen 95603
>         key (1 DEV_EXTENT 9847860887552) block 22441466626048 (1369718422) gen 117878
>         key (1 DEV_EXTENT 10082473476096) block 22493359931392 (1372885738) gen 117882
>         key (1 DEV_EXTENT 10232797331456) block 13983139643392 (853463113) gen 137923
>         key (1 DEV_EXTENT 10471168016384) block 6959763996672 (424790283) gen 105377
>         key (1 DEV_EXTENT 10591427100672) block 10067009994752 (614441528) gen 27773
>         key (1 DEV_EXTENT 10830871527424) block 10072383062016 (614769474) gen 28150
>         key (1 DEV_EXTENT 11070315954176) block 10072413356032 (614771323) gen 92253
>         key (1 DEV_EXTENT 11309760380928) block 22493328687104 (1372883831) gen 133268
>         key (1 DEV_EXTENT 11548131065856) block 1042474778624 (63627611) gen 133909
>         key (1 DEV_EXTENT 11785428008960) block 15016548761600 (916537400) gen 121951
>         key (1 DEV_EXTENT 12024872435712) block 12656435298304 (772487506) gen 32985
>         key (1 DEV_EXTENT 12263243120640) block 12893629710336 (786964704) gen 33745
>         key (1 DEV_EXTENT 12500540063744) block 16644219928576 (1015882564) gen 112366
>         key (1 DEV_EXTENT 12738910748672) block 14703563259904 (897434281) gen 145699
>         key (1 DEV_EXTENT 12976207691776) block 14113684733952 (861430953) gen 137926
>         key (1 DEV_EXTENT 13214578376704) block 15230715084800 (929609075) gen 116469
>         key (1 DEV_EXTENT 13452949061632) block 12787035504640 (780458710) gen 119919
>         key (1 DEV_EXTENT 13690246004736) block 10067511001088 (614472107) gen 119958
>         key (1 DEV_EXTENT 13928616689664) block 14113506328576 (861420064) gen 106290
>         key (1 DEV_EXTENT 14166987374592) block 861654532096 (52591219) gen 140596
>         key (1 DEV_EXTENT 14404284317696) block 6959531130880 (424776070) gen 103496
>         key (1 DEV_EXTENT 14643728744448) block 484408541184 (29565951) gen 103596
>         key (1 DEV_EXTENT 14882099429376) block 205519962112 (12543943) gen 137977
>         key (1 DEV_EXTENT 15118322630656) block 13289788358656 (811144309) gen 145698
>         key (1 DEV_EXTENT 15356693315584) block 13289789358080 (811144370) gen 145698
>         key (1 DEV_EXTENT 15596137742336) block 15736233984000 (960463500) gen 117936
>         key (1 DEV_EXTENT 15833434685440) block 1221260197888 (74539807) gen 138299
>         key (1 DEV_EXTENT 16071805370368) block 6368249397248 (388687097) gen 124384
>         key (1 DEV_EXTENT 16310176055296) block 12787123699712 (780464093) gen 138137
>         key (1 DEV_EXTENT 16548546740224) block 9420764561408 (574997837) gen 124415
>         key (1 DEV_EXTENT 16787991166976) block 22441589932032 (1369725948) gen 124583
>         key (1 DEV_EXTENT 17025288110080) block 15016789147648 (916552072) gen 144864
>         key (1 DEV_EXTENT 17263658795008) block 17459171082240 (1065623235) gen 144951
>         key (1 DEV_EXTENT 17502029479936) block 673143095296 (41085394) gen 143317
>         key (1 DEV_EXTENT 17740400164864) block 19010757427200 (1160324550) gen 141153
>         key (1 DEV_EXTENT 17979844591616) block 10067131596800 (614448950) gen 141191
>         key (1 DEV_EXTENT 18217141534720) block 205212958720 (12525205) gen 124623
>         key (1 DEV_EXTENT 18455512219648) block 205287997440 (12529785) gen 124626
>         key (1 DEV_EXTENT 18692809162752) block 16703827378176 (1019520714) gen 124744
>         key (1 DEV_EXTENT 18931179847680) block 7268874698752 (443656903) gen 124899
>         key (1 DEV_EXTENT 19169550532608) block 14291177324544 (872264241) gen 141256
>         key (1 DEV_EXTENT 19407921217536) block 29134446510080 (1778225495) gen 142791
>         key (1 DEV_EXTENT 19646291902464) block 6453644148736 (393899179) gen 143236
>         key (1 DEV_EXTENT 19883588845568) block 15998310219776 (976459364) gen 143270
> leaf 32407552 items 223 free space 12 generation 145836 owner 4
> leaf 32407552 flags 0x1(WRITTEN) backref revision 1
> fs uuid 017b587a-3e88-4f08-8616-ec686f8f969f
> chunk uuid 5820b5e3-9610-4cf3-a37a-b638a9963084
>         item 0 key (0 PERSISTENT_ITEM 1) itemoff 16243 itemsize 40
>                 persistent item objectid 0 offset 1
>                 device stats
>                 write_errs 0 read_errs 0 flush_errs 0 corruption_errs 0 generation 0
>         item 1 key (1 DEV_EXTENT 20971520) itemoff 16195 itemsize 48
>                 dev extent chunk_tree 3
>                 chunk_objectid 256 chunk_offset 20971520 length 8388608
>                 chunk_tree_uuid 5820b5e3-9610-4cf3-a37a-b638a9963084
>         item 2 key (1 DEV_EXTENT 29360128) itemoff 16147 itemsize 48
>                 dev extent chunk_tree 3
>                 chunk_objectid 256 chunk_offset 20971520 length 8388608
>                 chunk_tree_uuid 5820b5e3-9610-4cf3-a37a-b638a9963084
>         item 3 key (1 DEV_EXTENT 37748736) itemoff 16099 itemsize 48
>                 dev extent chunk_tree 3
>                 chunk_objectid 256 chunk_offset 29360128 length 1073741824
>                 chunk_tree_uuid 5820b5e3-9610-4cf3-a37a-b638a9963084
>         item 4 key (1 DEV_EXTENT 1111490560) itemoff 16051 itemsize 48
>                 dev extent chunk_tree 3
>                 chunk_objectid 256 chunk_offset 29360128 length 1073741824
>                 chunk_tree_uuid 5820b5e3-9610-4cf3-a37a-b638a9963084
>         item 5 key (1 DEV_EXTENT 2185232384) itemoff 16003 itemsize 48
>                 dev extent chunk_tree 3
>                 chunk_objectid 256 chunk_offset 16135487488 length 1073741824
>                 chunk_tree_uuid 00000000-0000-0000-0000-000000000000
>         item 6 key (1 DEV_EXTENT 3258974208) itemoff 15955 itemsize 48
>                 dev extent chunk_tree 3
>                 chunk_objectid 256 chunk_offset 17209229312 length 1073741824
>                 chunk_tree_uuid 00000000-0000-0000-0000-000000000000
>         item 7 key (1 DEV_EXTENT 4332716032) itemoff 15907 itemsize 48
>                 dev extent chunk_tree 3
>                 chunk_objectid 256 chunk_offset 18282971136 length 1073741824
>                 chunk_tree_uuid 00000000-0000-0000-0000-000000000000
>         item 8 key (1 DEV_EXTENT 5406457856) itemoff 15859 itemsize 48
>                 dev extent chunk_tree 3
>                 chunk_objectid 256 chunk_offset 19356712960 length 1073741824
>                 chunk_tree_uuid 00000000-0000-0000-0000-000000000000
>         item 9 key (1 DEV_EXTENT 6480199680) itemoff 15811 itemsize 48
>                 dev extent chunk_tree 3
>                 chunk_objectid 256 chunk_offset 20430454784 length 1073741824
>                 chunk_tree_uuid 00000000-0000-0000-0000-000000000000
>         item 10 key (1 DEV_EXTENT 7553941504) itemoff 15763 itemsize 48
>                 dev extent chunk_tree 3
>                 chunk_objectid 256 chunk_offset 21504196608 length 1073741824
>                 chunk_tree_uuid 00000000-0000-0000-0000-000000000000
>         item 11 key (1 DEV_EXTENT 8627683328) itemoff 15715 itemsize 48
>                 dev extent chunk_tree 3
>                 chunk_objectid 256 chunk_offset 22577938432 length 1073741824
>                 chunk_tree_uuid 00000000-0000-0000-0000-000000000000
>         item 12 key (1 DEV_EXTENT 9701425152) itemoff 15667 itemsize 48
>                 dev extent chunk_tree 3
>                 chunk_objectid 256 chunk_offset 23651680256 length 1073741824
>                 chunk_tree_uuid 00000000-0000-0000-0000-000000000000
>         item 13 key (1 DEV_EXTENT 10775166976) itemoff 15619 itemsize 48
> 
> KVG: and the complete file is attached to this message
> 
> 
> 
> 
> Normally it should not be mountable after v4.6 kernel if
> super_total_bytes mismatch, but I'm more interested in how it mounted
> successfully.
> 
> KVG: I've no idea why it mounts successfully when the compressions flags are omitted. No indication in the dmesg.

I think it's device scan code, maybe I can check it later.

Considering your superblock is good, you won't encounter such problem
any longer.

And if it really happens again, please try "btrfs device scan" first.

Thanks,
Qu

> 
> 
> And BTW, are you using x86_64 kernel or x86 kernel?
> I don't think it's related in your case, but some reports about 32bit
> kernel has strange bugs are in mail list, so just in case.
> 
> KVG: both kernels are 64bit. with 4.10.37 it mounts without a problem, with newer kernels the problem exis
> 
> [    0.000000] Linux version 4.10.0-37-generic (buildd@lgw01-amd64-037) (gcc version 5.4.0 20160609 (Ubuntu 5.4.0-6ubuntu1~16.04.4) ) #41~16.04.1-Ubuntu SMP Fri Oct 6 22:42:59 UTC 2017 (Ubuntu 4.10.0-37.41~16.04.1-generic 4.10.17)
> 
> [    0.000000] Linux version 4.13.9-041309-generic (kernel@tangerine) (gcc version 7.2.0 (Ubuntu 7.2.0-8ubuntu3)) #201710211231 SMP Sat Oct 21 16:32:44 UTC 2017
> 
> 
> 
> Thanks,
> Qu
> 
> 
>>
>>
>>
>> System information
>>
>> distribution: Ubuntu 16.04
>> btrfs-progs v4.8.1 later upgraded to v4.13.3
>>
>> # btrfs fi usage /mnt/backup
>> Overall:
>>     Device size:                  29.11TiB
>>     Device allocated:             18.04TiB
>>     Device unallocated:           11.07TiB
>>     Device missing:                  0.00B
>>     Used:                         17.99TiB
>>     Free (estimated):             11.12TiB      (min: 5.58TiB)
>>     Data ratio:                       1.00
>>     Metadata ratio:                   2.00
>>     Global reserve:              512.00MiB      (used: 0.00B)
>>
>> Data,single: Size:17.93TiB, Used:17.88TiB
>>    /dev/sda       17.93TiB
>>
>> Metadata,DUP: Size:53.50GiB, Used:51.78GiB
>>    /dev/sda      107.00GiB
>>
>> System,DUP: Size:8.00MiB, Used:2.30MiB
>>    /dev/sda       16.00MiB
>>
>> Unallocated:
>>    /dev/sda       11.07TiB
>>
>>
>>
>>
>> Yours sincerely,
>> Konstantin V. Gavrilenko
>>
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>


