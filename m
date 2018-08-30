Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-oln040092066074.outbound.protection.outlook.com ([40.92.66.74]:5452
        "EHLO EUR01-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725996AbeH3TY1 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 30 Aug 2018 15:24:27 -0400
From: Alberto Bursi <alberto.bursi@outlook.it>
To: Pierre Couderc <pierre@couderc.eu>, Qu Wenruo <quwenruo.btrfs@gmx.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: How to erase a RAID1 (+++)?
Date: Thu, 30 Aug 2018 15:21:44 +0000
Message-ID: <VI1PR08MB08629058D1231A1E374A8C4292080@VI1PR08MB0862.eurprd08.prod.outlook.com>
References: <04e4b43f-b21e-b6fd-dfad-0506ff35aff7@couderc.eu>
 <52b06c19-c9e2-29c1-b761-98d770c2d6c7@gmx.com>
 <2e47e913-104e-8d0c-8d49-69518681147b@couderc.eu>
 <f77df1e6-8030-716b-fc95-81ef3ae4f173@gmx.com>
 <22bd27f6-7107-7c34-110d-9cbed0c62790@couderc.eu>
In-Reply-To: <22bd27f6-7107-7c34-110d-9cbed0c62790@couderc.eu>
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


On 8/30/2018 11:13 AM, Pierre Couderc wrote:
> Trying to install a RAID1 on a debian stretch, I made some mistake and 
> got this, after installing on disk1 and trying to add second disk :
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
> Device     Boot Start        End    Sectors  Size Id Type
> /dev/sda1  *     2048 3907028991 3907026944  1.8T 83 Linux
>
>
> Disk /dev/sdb: 1.8 TiB, 2000398934016 bytes, 3907029168 sectors
> Units: sectors of 1 * 512 = 512 bytes
> Sector size (logical/physical): 512 bytes / 512 bytes
> I/O size (minimum/optimal): 512 bytes / 512 bytes
> Disklabel type: dos
> Disk identifier: 0x9770f6fa
>
> Device     Boot Start        End    Sectors  Size Id Type
> /dev/sdb1  *     2048 3907029167 3907027120  1.8T  5 Extended
>
>
> And :
>
> root@server:~# btrfs fi show
> Label: none  uuid: eed65d24-6501-4991-94bd-6c3baf2af1ed
>         Total devices 2 FS bytes used 1.10GiB
>         devid    1 size 1.82TiB used 4.02GiB path /dev/sda1
>         devid    2 size 1.00KiB used 0.00B path /dev/sdb1
>
> ...
>
> My purpose is a simple RAID1 main fs, with bootable flag on the 2 
> disks in prder to start in degraded mode....
> How to get out ofr that...?
>
> Thnaks
> PC


sdb1 is an extended partition, you cannot format an extended partition.

change sdb1 into primary partition or add a logical partition into it.


-Alberto
