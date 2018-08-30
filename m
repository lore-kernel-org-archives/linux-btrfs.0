Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lf1-f51.google.com ([209.85.167.51]:47060 "EHLO
        mail-lf1-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726235AbeH3VLg (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 30 Aug 2018 17:11:36 -0400
Received: by mail-lf1-f51.google.com with SMTP id e23-v6so7774191lfc.13
        for <linux-btrfs@vger.kernel.org>; Thu, 30 Aug 2018 10:08:30 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <22bd27f6-7107-7c34-110d-9cbed0c62790@couderc.eu>
References: <04e4b43f-b21e-b6fd-dfad-0506ff35aff7@couderc.eu>
 <52b06c19-c9e2-29c1-b761-98d770c2d6c7@gmx.com> <2e47e913-104e-8d0c-8d49-69518681147b@couderc.eu>
 <f77df1e6-8030-716b-fc95-81ef3ae4f173@gmx.com> <22bd27f6-7107-7c34-110d-9cbed0c62790@couderc.eu>
From: Chris Murphy <lists@colorremedies.com>
Date: Thu, 30 Aug 2018 11:08:28 -0600
Message-ID: <CAJCQCtTcCWavzu5k6ZnhCDU+jaHxWfzfuR5Whic1-ic0s+x+8g@mail.gmail.com>
Subject: Re: How to erase a RAID1 (+++)?
To: Pierre Couderc <pierre@couderc.eu>
Cc: Qu Wenruo <quwenruo.btrfs@gmx.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Aug 30, 2018 at 3:13 AM, Pierre Couderc <pierre@couderc.eu> wrote:
> Trying to install a RAID1 on a debian stretch, I made some mistake and got
> this, after installing on disk1 and trying to add second disk  :
>
>
> root@server:~# fdisk -l
> Disk /dev/sda: 1.8 TiB, 2000398934016 bytes, 3907029168 sectors
> Units: sectors of 1 * 512 = 512 bytes
> Sector size (logical/physical): 512 bytes / 512 bytes
> I/O size (minimum/optimal): 512 bytes / 512 bytes
> Disklabel type: dos
> Disk identifier: 0x2a799300
>
> Device     Boot Start        End    Sectors  Size Id Type
> /dev/sda1  *     2048 3907028991 3907026944  1.8T 83 Linux
>
>
> Disk /dev/sdb: 1.8 TiB, 2000398934016 bytes, 3907029168 sectors
> Units: sectors of 1 * 512 = 512 bytes
> Sector size (logical/physical): 512 bytes / 512 bytes
> I/O size (minimum/optimal): 512 bytes / 512 bytes
> Disklabel type: dos
> Disk identifier: 0x9770f6fa
>
> Device     Boot Start        End    Sectors  Size Id Type
> /dev/sdb1  *     2048 3907029167 3907027120  1.8T  5 Extended


Extended partition type is not a problem if you're using GRUB as the
bootloader; other bootloaders may not like this. Strictly speaking the
type code 0x05 is incorrect, GRUB ignores type code, as does the
kernel. GRUB also ignores the active bit (boot flag).


>
>
> And :
>
> root@server:~# btrfs fi show
> Label: none  uuid: eed65d24-6501-4991-94bd-6c3baf2af1ed
>         Total devices 2 FS bytes used 1.10GiB
>         devid    1 size 1.82TiB used 4.02GiB path /dev/sda1
>         devid    2 size 1.00KiB used 0.00B path /dev/sdb1

That's odd; and I know you've moved on from this problem but I would
have liked to see the super for /dev/sdb1 and also the installer log
for what commands were used for partitioning, including mkfs and
device add commands.

For what it's worth, 'btrfs dev add' formats the device being added,
it does not need to be formatted in advance, and also it resizes the
file system properly.



> My purpose is a simple RAID1 main fs, with bootable flag on the 2 disks in
> prder to start in degraded mode....

Good luck with this. The Btrfs archives are full of various
limitations of Btrfs raid1. There is no automatic degraded mount for
Btrfs. And if you persistently ask for degraded mount, you run the
risk of other problems if there's merely a delayed discovery of one of
the devices. Once a Btrfs volume is degraded, it does not
automatically resume normal operation just because the formerly
missing device becomes available.

So... this is flat out not suitable for use cases where you need
unattended raid1 degraded boot.



-- 
Chris Murphy
