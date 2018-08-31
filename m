Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtp2-g21.free.fr ([212.27.42.2]:24222 "EHLO smtp2-g21.free.fr"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727178AbeHaKr5 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 31 Aug 2018 06:47:57 -0400
Subject: Re: How to erase a RAID1 (+++)?
To: Chris Murphy <lists@colorremedies.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
References: <04e4b43f-b21e-b6fd-dfad-0506ff35aff7@couderc.eu>
 <52b06c19-c9e2-29c1-b761-98d770c2d6c7@gmx.com>
 <2e47e913-104e-8d0c-8d49-69518681147b@couderc.eu>
 <f77df1e6-8030-716b-fc95-81ef3ae4f173@gmx.com>
 <22bd27f6-7107-7c34-110d-9cbed0c62790@couderc.eu>
 <CAJCQCtTcCWavzu5k6ZnhCDU+jaHxWfzfuR5Whic1-ic0s+x+8g@mail.gmail.com>
From: Pierre Couderc <pierre@couderc.eu>
Message-ID: <a9561141-96b3-35ca-bf0c-c8bbceeecd41@couderc.eu>
Date: Fri, 31 Aug 2018 08:41:52 +0200
MIME-Version: 1.0
In-Reply-To: <CAJCQCtTcCWavzu5k6ZnhCDU+jaHxWfzfuR5Whic1-ic0s+x+8g@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 08/30/2018 07:08 PM, Chris Murphy wrote:
> On Thu, Aug 30, 2018 at 3:13 AM, Pierre Couderc <pierre@couderc.eu> wrote:
>> Trying to install a RAID1 on a debian stretch, I made some mistake and got
>> this, after installing on disk1 and trying to add second disk  :
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
>
> Extended partition type is not a problem if you're using GRUB as the
> bootloader; other bootloaders may not like this. Strictly speaking the
> type code 0x05 is incorrect, GRUB ignores type code, as does the
> kernel. GRUB also ignores the active bit (boot flag).
>
>
>>
>> And :
>>
>> root@server:~# btrfs fi show
>> Label: none  uuid: eed65d24-6501-4991-94bd-6c3baf2af1ed
>>          Total devices 2 FS bytes used 1.10GiB
>>          devid    1 size 1.82TiB used 4.02GiB path /dev/sda1
>>          devid    2 size 1.00KiB used 0.00B path /dev/sdb1
> That's odd; and I know you've moved on from this problem but I would
> have liked to see the super for /dev/sdb1 and also the installer log
> for what commands were used for partitioning, including mkfs and
> device add commands.
>
> For what it's worth, 'btrfs dev add' formats the device being added,
> it does not need to be formatted in advance, and also it resizes the
> file system properly.
Thank you, in fact my system seems more and more broken, so I cannot go 
further..
For example, a simple
df gives me an IO error.
I prefer reinstall the whole.
But to avoid the same problems, is there somewhere an howto "install a 
basic RAID1 btrfs debian stretch system" ?
OK, I install strech on 1 disk and then how do I "format" and add the 
second disk ?
>
>
>> My purpose is a simple RAID1 main fs, with bootable flag on the 2 disks in
>> prder to start in degraded mode....
> Good luck with this. The Btrfs archives are full of various
> limitations of Btrfs raid1. There is no automatic degraded mount for
> Btrfs. And if you persistently ask for degraded mount, you run the
> risk of other problems if there's merely a delayed discovery of one of
> the devices. Once a Btrfs volume is degraded, it does not
> automatically resume normal operation just because the formerly
> missing device becomes available.
>
> So... this is flat out not suitable for use cases where you need
> unattended raid1 degraded boot.
>
Well, I understnad the lesson that there  is  no hope currently to boot 
a degraded system...
Thank you very much
