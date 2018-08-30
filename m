Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtp1-g21.free.fr ([212.27.42.1]:19711 "EHLO smtp1-g21.free.fr"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727836AbeH3NOs (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 30 Aug 2018 09:14:48 -0400
Subject: Re: How to erase a RAID1 (+++)?
To: Qu Wenruo <quwenruo.btrfs@gmx.com>, linux-btrfs@vger.kernel.org
References: <04e4b43f-b21e-b6fd-dfad-0506ff35aff7@couderc.eu>
 <52b06c19-c9e2-29c1-b761-98d770c2d6c7@gmx.com>
 <2e47e913-104e-8d0c-8d49-69518681147b@couderc.eu>
 <f77df1e6-8030-716b-fc95-81ef3ae4f173@gmx.com>
From: Pierre Couderc <pierre@couderc.eu>
Message-ID: <22bd27f6-7107-7c34-110d-9cbed0c62790@couderc.eu>
Date: Thu, 30 Aug 2018 11:13:34 +0200
MIME-Version: 1.0
In-Reply-To: <f77df1e6-8030-716b-fc95-81ef3ae4f173@gmx.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Trying to install a RAID1 on a debian stretch, I made some mistake and 
got this, after installing on disk1 and trying to add second disk  :


root@server:~# fdisk -l
Disk /dev/sda: 1.8 TiB, 2000398934016 bytes, 3907029168 sectors
Units: sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes
Disklabel type: dos
Disk identifier: 0x2a799300

Device     Boot Start        End    Sectors  Size Id Type
/dev/sda1  *     2048 3907028991 3907026944  1.8T 83 Linux


Disk /dev/sdb: 1.8 TiB, 2000398934016 bytes, 3907029168 sectors
Units: sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes
Disklabel type: dos
Disk identifier: 0x9770f6fa

Device     Boot Start        End    Sectors  Size Id Type
/dev/sdb1  *     2048 3907029167 3907027120  1.8T  5 Extended


And :

root@server:~# btrfs fi show
Label: none  uuid: eed65d24-6501-4991-94bd-6c3baf2af1ed
         Total devices 2 FS bytes used 1.10GiB
         devid    1 size 1.82TiB used 4.02GiB path /dev/sda1
         devid    2 size 1.00KiB used 0.00B path /dev/sdb1

...

My purpose is a simple RAID1 main fs, with bootable flag on the 2 disks 
in prder to start in degraded mode....
How to get out ofr that...?

Thnaks
PC
