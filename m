Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lj1-f194.google.com ([209.85.208.194]:35366 "EHLO
        mail-lj1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726674AbeH3Vgd (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 30 Aug 2018 17:36:33 -0400
Received: by mail-lj1-f194.google.com with SMTP id p10-v6so7955048ljg.2
        for <linux-btrfs@vger.kernel.org>; Thu, 30 Aug 2018 10:33:20 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <VI1PR08MB08629058D1231A1E374A8C4292080@VI1PR08MB0862.eurprd08.prod.outlook.com>
References: <04e4b43f-b21e-b6fd-dfad-0506ff35aff7@couderc.eu>
 <52b06c19-c9e2-29c1-b761-98d770c2d6c7@gmx.com> <2e47e913-104e-8d0c-8d49-69518681147b@couderc.eu>
 <f77df1e6-8030-716b-fc95-81ef3ae4f173@gmx.com> <22bd27f6-7107-7c34-110d-9cbed0c62790@couderc.eu>
 <VI1PR08MB08629058D1231A1E374A8C4292080@VI1PR08MB0862.eurprd08.prod.outlook.com>
From: Chris Murphy <lists@colorremedies.com>
Date: Thu, 30 Aug 2018 11:33:19 -0600
Message-ID: <CAJCQCtT9CREHP=bkeMMEBS46mT=ra8GqGuVbUXKrxm=PmScbgA@mail.gmail.com>
Subject: Re: How to erase a RAID1 (+++)?
To: Alberto Bursi <alberto.bursi@outlook.it>
Cc: Pierre Couderc <pierre@couderc.eu>, Qu Wenruo <quwenruo.btrfs@gmx.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Aug 30, 2018 at 9:21 AM, Alberto Bursi <alberto.bursi@outlook.it> wrote:
>
> On 8/30/2018 11:13 AM, Pierre Couderc wrote:
>> Trying to install a RAID1 on a debian stretch, I made some mistake and
>> got this, after installing on disk1 and trying to add second disk :
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
>> Device     Boot Start        End    Sectors  Size Id Type
>> /dev/sda1  *     2048 3907028991 3907026944  1.8T 83 Linux
>>
>>
>> Disk /dev/sdb: 1.8 TiB, 2000398934016 bytes, 3907029168 sectors
>> Units: sectors of 1 * 512 = 512 bytes
>> Sector size (logical/physical): 512 bytes / 512 bytes
>> I/O size (minimum/optimal): 512 bytes / 512 bytes
>> Disklabel type: dos
>> Disk identifier: 0x9770f6fa
>>
>> Device     Boot Start        End    Sectors  Size Id Type
>> /dev/sdb1  *     2048 3907029167 3907027120  1.8T  5 Extended
>>
>>
>> And :
>>
>> root@server:~# btrfs fi show
>> Label: none  uuid: eed65d24-6501-4991-94bd-6c3baf2af1ed
>>         Total devices 2 FS bytes used 1.10GiB
>>         devid    1 size 1.82TiB used 4.02GiB path /dev/sda1
>>         devid    2 size 1.00KiB used 0.00B path /dev/sdb1
>>
>> ...
>>
>> My purpose is a simple RAID1 main fs, with bootable flag on the 2
>> disks in prder to start in degraded mode....
>> How to get out ofr that...?
>>
>> Thnaks
>> PC
>
>
> sdb1 is an extended partition, you cannot format an extended partition.
>
> change sdb1 into primary partition or add a logical partition into it.

Ahh you're correct. There is special treatment of 0x05, it's a logical
container with the start address actually pointing to the address
where the EBR is. And that EBR's first record contains the actual real
extended partition information.

So this represents two bugs in the installer:
1. If there's only one partition on a drive, it should be primary by
default, not extended.
2. But if extended, it must point to an EBR, and the EBR must be
created at that location. Obviously since there is no /dev/sdb2, this
EBR is not present.




-- 
Chris Murphy
