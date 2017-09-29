Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtp-16-i6.italiaonline.it ([213.209.14.16]:32888 "EHLO
        libero.it" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1752123AbdI2VEM (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 29 Sep 2017 17:04:12 -0400
Reply-To: kreijack@inwind.it
Subject: Re: Can't remove device -> I/O error
To: Dirk Diggler <docmax1978@gmail.com>, linux-btrfs@vger.kernel.org
References: <CACJO8mcmabFc1CdhVr+Xj=NH1h2zy5eMOeD-8+UGkXODH34rVQ@mail.gmail.com>
From: Goffredo Baroncelli <kreijack@libero.it>
Message-ID: <3b9a14cb-a88c-4604-6d36-d2706796acfd@libero.it>
Date: Fri, 29 Sep 2017 23:04:09 +0200
MIME-Version: 1.0
In-Reply-To: <CACJO8mcmabFc1CdhVr+Xj=NH1h2zy5eMOeD-8+UGkXODH34rVQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 09/29/2017 10:00 PM, Dirk Diggler wrote:
> Hi,
> 
> is there any chance to get my device removed?

I simulated a device removing in KVM with

	echo 1 >/sys/block/sdj/device/delete

then 

	btrfs dev del 6 /mnt/....


And I got success. But I am not sure if this is the right thing todo.

You can use "btrfs replace start -r ....". But you need another device.

Otherwise, you can shutdown the filesystem, removing (physically) the disk then remount with a "mount -o degraded ...." followed by a "btrfs dev del missing /..."
Before doing so, please tell us which kernel you are using.

RAID5/6 until few months ago has a lot of bugs, so if you have an old kernel it is very difficult to remove a device with success.

> Scrub literally takes months to complete (SATA 2/3 mix, about 1 minute
> per gigabyte) and i'm not sure if that helps.
> I guess same with balance. Mabye there is a quicker way. I can do
> without some data if it's corrupted. I have a backup, but i want to
> avoid to copy all data from scratch!
> 
> Whenever i try to remove dev 6, i get:
> 
> console:
> ERROR: error removing device '/dev/sdj': Input/output error
> 
> dmesg (i/o error right after this):
> BTRFS warning (device sdl): csum failed root -9 ino 365 off 3675115520
> csum 0x98f94189 expected csum 0x585e5744 mirror 1
> BTRFS warning (device sdl): csum failed root -9 ino 365 off 3675119616
> csum 0x98f94189 expected csum 0xcefd2ae0 mirror 1
> BTRFS warning (device sdl): csum failed root -9 ino 365 off 3675115520
> csum 0x98f94189 expected csum 0x585e5744 mirror 1
> BTRFS warning (device sdl): csum failed root -9 ino 365 off 3675119616
> csum 0x98f94189 expected csum 0xcefd2ae0 mirror 1
> BTRFS warning (device sdl): csum failed root -9 ino 365 off 3675115520
> csum 0x4023cac1 expected csum 0x585e5744 mirror 2
> BTRFS warning (device sdl): csum failed root -9 ino 365 off 3675119616
> csum 0xea91b663 expected csum 0xcefd2ae0 mirror 2
> BTRFS warning (device sdl): csum failed root -9 ino 365 off 3675115520
> csum 0x98f94189 expected csum 0x585e5744 mirror 1
> BTRFS warning (device sdl): csum failed root -9 ino 365 off 3675115520
> csum 0x4023cac1 expected csum 0x585e5744 mirror 2
> 
> My setup:
> /dev/sdf, ID: 3
>    Device size:             2.73TiB
>    Device slack:              0.00B
>    Data,RAID5:            333.00GiB
>    Data,RAID5:              5.00GiB
>    Unallocated:             2.40TiB
> 
> /dev/sdg, ID: 2
>    Device size:             1.82TiB
>    Device slack:              0.00B
>    Data,RAID5:            333.00GiB
>    Data,RAID5:            955.00GiB
>    Data,RAID5:              5.57GiB
>    Metadata,RAID1:          3.00GiB
>    Unallocated:           566.44GiB
> 
> /dev/sdh, ID: 4
>    Device size:             1.82TiB
>    Device slack:              0.00B
>    Data,RAID5:            333.00GiB
>    Data,RAID5:            955.00GiB
>    Data,RAID5:              5.57GiB
>    Metadata,RAID1:          2.00GiB
>    System,RAID1:           32.00MiB
>    Unallocated:           567.41GiB
> 
> /dev/sdi, ID: 7
>    Device size:             2.73TiB
>    Device slack:              0.00B
>    Data,RAID5:            333.00GiB
>    Data,RAID5:            955.00GiB
>    Data,RAID5:              5.57GiB
>    Metadata,RAID1:         11.00GiB
>    System,RAID1:           32.00MiB
>    Unallocated:             1.45TiB
> 
> /dev/sdj, ID: 6
>    Device size:           465.76GiB
>    Device slack:              0.00B
>    Data,RAID5:            333.00GiB
>    Data,RAID5:            587.38MiB
>    Unallocated:           132.19GiB
> 
> /dev/sdk, ID: 1
>    Device size:             1.82TiB
>    Device slack:              0.00B
>    Data,RAID5:            333.00GiB
>    Data,RAID5:            955.00GiB
>    Data,RAID5:              5.57GiB
>    Metadata,RAID1:          3.00GiB
>    Unallocated:           566.44GiB
> 
> /dev/sdl, ID: 5
>    Device size:             1.82TiB
>    Device slack:              0.00B
>    Data,RAID5:            333.00GiB
>    Data,RAID5:            955.00GiB
>    Data,RAID5:              5.57GiB
>    Metadata,RAID1:          3.00GiB
>    Unallocated:           566.44GiB
> 
> Thanks,
> DocMAX
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 


-- 
gpg @keyserver.linux.it: Goffredo Baroncelli <kreijackATinwind.it>
Key fingerprint BBF5 1610 0B64 DAC6 5F7D  17B2 0EDA 9B37 8B82 E0B5
