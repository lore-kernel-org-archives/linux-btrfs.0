Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from resqmta-po-03v.sys.comcast.net ([96.114.154.162]:44242 "EHLO
        resqmta-po-03v.sys.comcast.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752341AbdITEtg (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 20 Sep 2017 00:49:36 -0400
Subject: Re: WARNING: CPU: 3 PID: 439 at fs/btrfs/ctree.h:1559
 btrfs_update_device+0x1c5/0x1d0 [btrfs]
To: Qu Wenruo <quwenruo.btrfs@gmx.com>, Rich Rauenzahn <rrauenza@gmail.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
References: <CAG+QAKXTRiC0s5pH_EQoz7Zd7nNfMC5++AN+EFgU6yY=3uvckw@mail.gmail.com>
 <69ee49ff-d2d6-bec9-055c-18697b71ec20@gmx.com>
From: Rich Rauenzahn <rich@shroop.net>
Message-ID: <1f8d39cd-a36a-6b4d-dea8-7a9acd9f9396@shroop.net>
Date: Tue, 19 Sep 2017 21:49:24 -0700
MIME-Version: 1.0
In-Reply-To: <69ee49ff-d2d6-bec9-055c-18697b71ec20@gmx.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 9/19/2017 5:31 PM, Qu Wenruo wrote:
> On 2017年09月19日 23:56, Rich Rauenzahn wrote:
>> [    4.747377] WARNING: CPU: 3 PID: 439 at fs/btrfs/ctree.h:1559
>> btrfs_update_device+0x1c5/0x1d0 [btrfs]
>
> Is that line the following WARN_ON()?
> ---
> static inline void btrfs_set_device_total_bytes(struct extent_buffer *eb,
>                         struct btrfs_dev_item *s,
>                         u64 val)
> {
>     BUILD_BUG_ON(sizeof(u64) !=
>              sizeof(((struct btrfs_dev_item *)0))->total_bytes);
>     WARN_ON(!IS_ALIGNED(val, eb->fs_info->sectorsize)); <<<
>     btrfs_set_64(eb, s, offsetof(struct btrfs_dev_item, total_bytes), 
> val);
> }
> ---
>
> If so, that means your devices size is not aligned to 4K.
>
> Is your block device still using old 512 block size?
> AFAIK nowadays most HDDs are using 4K blocksize and it's recommended 
> to use it.
>
> It's not a big problem and one can easily remove the WARN_ON().
> But I think we'd better fix the caller to do round_down() before 
> calling this function.
>

That's interesting!  I believe I made an effort to align them when I set 
it up years ago, but never knew how to verify.

I have three mirrored filesystems:

$ for i in /dev/sd[abcdef]; do sudo gdisk -l $i; done
GPT fdisk (gdisk) version 0.8.6

Partition table scan:
   MBR: protective
   BSD: not present
   APM: not present
   GPT: present

Found valid GPT with protective MBR; using GPT.
Disk /dev/sda: 3907029168 sectors, 1.8 TiB
Logical sector size: 512 bytes
Disk identifier (GUID): 03FFF12A-2EF5-4916-92D9-59C244EFDF5B
Partition table holds up to 128 entries
First usable sector is 34, last usable sector is 3907029134
Partitions will be aligned on 2048-sector boundaries
Total free space is 2014 sectors (1007.0 KiB)

Number  Start (sector)    End (sector)  Size       Code Name
    1            2048      3907029134   1.8 TiB     8300 BTRFS BACKUPS
GPT fdisk (gdisk) version 0.8.6

Partition table scan:
   MBR: protective
   BSD: not present
   APM: not present
   GPT: present

Found valid GPT with protective MBR; using GPT.
Disk /dev/sdb: 3907029168 sectors, 1.8 TiB
Logical sector size: 512 bytes
Disk identifier (GUID): B0CF9AC1-7DD0-46CD-AF62-2E54761686C7
Partition table holds up to 128 entries
First usable sector is 34, last usable sector is 3907029134
Partitions will be aligned on 2048-sector boundaries
Total free space is 2014 sectors (1007.0 KiB)

Number  Start (sector)    End (sector)  Size       Code Name
    1            2048      3907029134   1.8 TiB     8300 BTRFS BACKUPS
GPT fdisk (gdisk) version 0.8.6

Partition table scan:
   MBR: protective
   BSD: not present
   APM: not present
   GPT: present

Found valid GPT with protective MBR; using GPT.
Disk /dev/sdc: 3907029168 sectors, 1.8 TiB
Logical sector size: 512 bytes
Disk identifier (GUID): 21CA2468-8185-4ECA-B63D-8A9A1557F302
Partition table holds up to 128 entries
First usable sector is 34, last usable sector is 3907029134
Partitions will be aligned on 2048-sector boundaries
Total free space is 2014 sectors (1007.0 KiB)

Number  Start (sector)    End (sector)  Size       Code Name
    1            2048      3907029134   1.8 TiB     8300 BTRFS MEDIA
GPT fdisk (gdisk) version 0.8.6

Partition table scan:
   MBR: protective
   BSD: not present
   APM: not present
   GPT: present

Found valid GPT with protective MBR; using GPT.
Disk /dev/sdd: 3907029168 sectors, 1.8 TiB
Logical sector size: 512 bytes
Disk identifier (GUID): 5214ED9D-769A-4DF8-886F-8EEC3FDD4D0D
Partition table holds up to 128 entries
First usable sector is 34, last usable sector is 3907029134
Partitions will be aligned on 8-sector boundaries
Total free space is 6 sectors (3.0 KiB)

Number  Start (sector)    End (sector)  Size       Code Name
    1              40      3907029134   1.8 TiB     8300 BTRFS MEDIA
GPT fdisk (gdisk) version 0.8.6

Partition table scan:
   MBR: protective
   BSD: not present
   APM: not present
   GPT: present

Found valid GPT with protective MBR; using GPT.
Disk /dev/sde: 234441648 sectors, 111.8 GiB
Logical sector size: 512 bytes
Disk identifier (GUID): D0E4B890-0002-4DA1-B011-24CE7FD435FE
Partition table holds up to 128 entries
First usable sector is 34, last usable sector is 234441614
Partitions will be aligned on 2048-sector boundaries
Total free space is 2925 sectors (1.4 MiB)

Number  Start (sector)    End (sector)  Size       Code Name
    1            2048          411647   200.0 MiB   EF00 EFI System 
Partition
    2          411648         1435647   500.0 MiB   0700 Primary /boot
    3         1435648       234440703   111.1 GiB   0700 Primary /home
GPT fdisk (gdisk) version 0.8.6

Partition table scan:
   MBR: protective
   BSD: not present
   APM: not present
   GPT: present

Found valid GPT with protective MBR; using GPT.
Disk /dev/sdf: 234441648 sectors, 111.8 GiB
Logical sector size: 512 bytes
Disk identifier (GUID): D1523F65-B975-4A94-8519-3D1679A50342
Partition table holds up to 128 entries
First usable sector is 34, last usable sector is 234441614
Partitions will be aligned on 2048-sector boundaries
Total free space is 2014 sectors (1007.0 KiB)

Number  Start (sector)    End (sector)  Size       Code Name
    1            2048          411647   200.0 MiB   EF00 EFI System
    2          411648         1435647   500.0 MiB   0700 Secondary /boot
    3         1435648       234441614   111.1 GiB   0700 Secondary /home

.....and one is aligned differently!

Could it be /dev/sdd that's the issue?  But it's aligned at 4096 -- so 
I'm not sure that's the issue after all.
