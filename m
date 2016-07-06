Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-vk0-f43.google.com ([209.85.213.43]:35107 "EHLO
	mail-vk0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751669AbcGFKab (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 6 Jul 2016 06:30:31 -0400
Received: by mail-vk0-f43.google.com with SMTP id v6so28706450vkb.2
        for <linux-btrfs@vger.kernel.org>; Wed, 06 Jul 2016 03:30:31 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAGGqMYQeAN3HR7s-Om864pfV2n_qfZN6Wyyamj=EwKmm4o5NgA@mail.gmail.com>
References: <CALLEBqG65hkAd+KyoNZudCKv58OuBm3L5VOjWcvMQ5GfGNCngA@mail.gmail.com>
 <CAGGqMYQeAN3HR7s-Om864pfV2n_qfZN6Wyyamj=EwKmm4o5NgA@mail.gmail.com>
From: Stanislaw Kaminski <stasheck.fora@gmail.com>
Date: Wed, 6 Jul 2016 12:30:11 +0200
Message-ID: <CALLEBqFOFCjMa27D4-9ywv_=1=L9kz66KY0=Uo6g5_DDogvM=g@mail.gmail.com>
Subject: Re: Out of space error even though there's 100 GB unused?
To: Alexander Fougner <fougner89@gmail.com>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Alex,
Thank for having a look.

"You're trying to resize a fs that is probably already fully using the
block device it's on. I don't see anything incorrect happening here,
but I might be missing something."
This was just to show that I can't do this, I know that it is already
utilizing the entire block device.

"The unallocated space will be allocated if you start writing files to it."
That's what I would expect, unfortunately it's kind of hard to write
files to it, as I get "Out of space" error. Tongue-in-cheek, if you
know how to ignore the issue and start writing files, it would solve
my issue.

Bottom line: if the disk is really full, then none of the tools shows
that. If it is not (and I suspect it's not - as I mentioned, I just
removed 50 GB of data from it), then why am I getting "out of space"?

As for block device size:
# fdisk -l
Disk /dev/sda: 1.8 TiB, 2000398934016 bytes, 3907029168 sectors
Units: sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 4096 bytes
I/O size (minimum/optimal): 4096 bytes / 4096 bytes
Disklabel type: gpt
Disk identifier: 6070B645-D738-4730-BEF7-989210EF1DD7

Device        Start        End    Sectors  Size Type
/dev/sda1      2048     133119     131072   64M Linux filesystem
/dev/sda2    133120    2230271    2097152    1G Linux swap
/dev/sda3   2230272   19007487   16777216    8G Linux filesystem
/dev/sda4  19007488 3907029134 3888021647  1.8T Linux home


Cheers,
Stan

2016-07-06 12:10 GMT+02:00 Alexander Fougner <fougner89@gmail.com>:
>
> Den 6 juli 2016 12:03 em skrev "Stanislaw Kaminski"
> <stasheck.fora@gmail.com>:
>>
>
>> Hi,
>> I am fighting with this since at least Monday - see
>>
>> https://superuser.com/questions/1096658/btrfs-out-of-space-even-though-there-should-be-10-left
>>
>> Here's the data:
>> #   uname -a
>> Linux archb3 4.6.3-2-ARCH #1 PREEMPT Wed Jun 29 07:15:33 MDT 2016
>> armv5tel GNU/Linux
>>
>> #   btrfs --version
>> btrfs-progs v4.6
>>
>> #   btrfs fi show
>> Label: 'home'  uuid: 1c7e35e8-f013-4f65-9d19-eaa168ac088b
>>         Total devices 1 FS bytes used 1.71TiB
>>         devid    1 size 1.81TiB used 1.71TiB path /dev/sda4
>>
>> #   btrfs fi df /home
>> Data, single: total=1.71TiB, used=1.71TiB
>> System, DUP: total=32.00MiB, used=224.00KiB
>> Metadata, DUP: total=4.00GiB, used=2.07GiB
>> GlobalReserve, single: total=512.00MiB, used=0.00B
>>
>> # btrfs f usage -T  /home
>> Overall:
>>     Device size:                   1.81TiB
>>     Device allocated:              1.71TiB
>>     Device unallocated:           97.89GiB
>>     Device missing:                  0.00B
>>     Used:                          1.71TiB
>>     Free (estimated):             98.22GiB      (min: 49.27GiB)
>>     Data ratio:                       1.00
>>     Metadata ratio:                   2.00
>>     Global reserve:              512.00MiB      (used: 0.00B)
>>
>>              Data    Metadata System
>> Id Path      single  DUP      DUP       Unallocated
>> -- --------- ------- -------- --------- -----------
>>  1 /dev/sda4 1.71TiB  8.00GiB  64.00MiB    97.89GiB
>> -- --------- ------- -------- --------- -----------
>>    Total     1.71TiB  4.00GiB  32.00MiB    97.89GiB
>>    Used      1.71TiB  2.07GiB 224.00KiB
>>
>> # btrfs fi du -s /home
>> Total Exclusive Set shared Filename
>> 1.60TiB 1.60TiB 0.00B /home
>>
>> # btrfs f resize 1:+1G /home/
>> Resize '/home/' of '1:+1G'
>> ERROR: unable to resize '/home/': no enough free space
>>
>
> You're trying to resize a fs that is probably already fully using the block
> device it's on. I don't see anything incorrect happening here, but I might
> be missing something.
>
> The used space amounting to 1.6TiB is not as reliable as the btrfs fi df
> tool.
> The unallocated space will be allocated if you start writing files to it.
> What size is the parent block device?
>
>> This all is after closely following:
>>
>> https://btrfs.wiki.kernel.org/index.php/FAQ#Help.21_I_ran_out_of_disk_space.21
>>
>> http://marc.merlins.org/perso/btrfs/post_2014-05-04_Fixing-Btrfs-Filesystem-Full-Problems.html
>>
>> So, already did full volume rebalance, defrag, rebooted multiple times
>> - still, "Error: out of disk space".
>>
>> To sum up:
>> - my files sum to 1.6 TiB
>> - disk usage is shown to be 1.71 TiB
>> - volume size is 1.81 TiB
>> - btrfs util shows I have ~98 GiB free space on the volume
>> - I am getting "out of space" message
>>
>> Bonus:
>> - I removed 50 GB of data from the drive and I still get "out of
>> space" message after writing ~1 GB.
>>
>> Help would be very appreciated.
>>
>> Cheers,
>> Stan
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
