Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtp2-g21.free.fr ([212.27.42.2]:24678 "EHLO smtp2-g21.free.fr"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728087AbeH3ODX (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 30 Aug 2018 10:03:23 -0400
Subject: Re: How to erase a RAID1 (+++)?
To: Qu Wenruo <quwenruo.btrfs@gmx.com>, linux-btrfs@vger.kernel.org
References: <04e4b43f-b21e-b6fd-dfad-0506ff35aff7@couderc.eu>
 <52b06c19-c9e2-29c1-b761-98d770c2d6c7@gmx.com>
 <2e47e913-104e-8d0c-8d49-69518681147b@couderc.eu>
 <f77df1e6-8030-716b-fc95-81ef3ae4f173@gmx.com>
 <22bd27f6-7107-7c34-110d-9cbed0c62790@couderc.eu>
 <1bc34cb7-7523-11e1-b12f-05aff161b3c6@gmx.com>
From: Pierre Couderc <pierre@couderc.eu>
Message-ID: <c67143ae-e845-1b01-fdee-a7c32a208e52@couderc.eu>
Date: Thu, 30 Aug 2018 12:01:55 +0200
MIME-Version: 1.0
In-Reply-To: <1bc34cb7-7523-11e1-b12f-05aff161b3c6@gmx.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 08/30/2018 11:35 AM, Qu Wenruo wrote:
>
> On 2018/8/30 下午5:13, Pierre Couderc wrote:
>> Trying to install a RAID1 on a debian stretch, I made some mistake and
>> got this, after installing on disk1 and trying to add second disk  :
>>
>>
>> root@server:~# fdisk -l
>> Disk /dev/sda: 1.8 TiB, 2000398934016 bytes, 3907029168 sectors
>> Units: sectors of 1 * 512 = 512 bytes
>> Sector size (logical/physical): 512 bytes / 512 bytes
>> I/O size (minimum/optimal): 512 bytes / 512 bytes
>> Disklabel type: dos
>> Disk identifier: 0x2a799300
>>
>> Device     Boot Start        End    Sectors  Size Id Type
>> /dev/sda1  *     2048 3907028991 3907026944  1.8T 83 Linux
>>
>>
>> Disk /dev/sdb: 1.8 TiB, 2000398934016 bytes, 3907029168 sectors
>> Units: sectors of 1 * 512 = 512 bytes
>> Sector size (logical/physical): 512 bytes / 512 bytes
>> I/O size (minimum/optimal): 512 bytes / 512 bytes
>> Disklabel type: dos
>> Disk identifier: 0x9770f6fa
>>
>> Device     Boot Start        End    Sectors  Size Id Type
>> /dev/sdb1  *     2048 3907029167 3907027120  1.8T  5 Extended
>>
>>
>> And :
>>
>> root@server:~# btrfs fi show
>> Label: none  uuid: eed65d24-6501-4991-94bd-6c3baf2af1ed
>>          Total devices 2 FS bytes used 1.10GiB
>>          devid    1 size 1.82TiB used 4.02GiB path /dev/sda1
>>          devid    2 size 1.00KiB used 0.00B path /dev/sdb1
>>
>> ...
>>
>> My purpose is a simple RAID1 main fs, with bootable flag on the 2 disks
>> in prder to start in degraded mode....
>> How to get out ofr that...?
> The 2nd device is indeed strange.
>
> Considering how old packages Debian tends to deliver, it should be some
> old btrfs-progs.
>
> You could just boot into the system and execute the following commands:
>
> # btrfs device remove 2 <mnt>
This works fine.
>
> Then add a new real device to the fs
>
> # btrfs device add <new device> <mnt>
>
>
Thnk you, this :

btrfs device add /dev/sdb1 /

  seems to work but  gives me the same :

root@server:~# btrfs fi show
Label: none  uuid: eed65d24-6501-4991-94bd-6c3baf2af1ed
         Total devices 2 FS bytes used 1.10GiB
         devid    1 size 1.82TiB used 4.02GiB path /dev/sda1
         devid    2 size 1.00KiB used 0.00B path /dev/sdb1

So I need to "prepare" or format /dev/sdb before adding /dev/sdb1
I have tried to format /dev/sdb and it works :
root@server:~# btrfs fi show
Label: none  uuid: eed65d24-6501-4991-94bd-6c3baf2af1ed
         Total devices 2 FS bytes used 1.10GiB
         devid    1 size 1.82TiB used 4.02GiB path /dev/sda1
         devid    2 size 1.82TiB used 0.00B path /dev/sdb

but I have no partition table and no booot flag for degraded mode....
