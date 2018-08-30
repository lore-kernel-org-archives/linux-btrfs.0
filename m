Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from wie.mywh.net ([62.109.39.47]:48726 "EHLO wie.mywh.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728595AbeH3QFR (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 30 Aug 2018 12:05:17 -0400
From: Kai Stian Olstad <btrfs+list@olstad.com>
To: Pierre Couderc <pierre@couderc.eu>
Cc: Qu Wenruo <quwenruo.btrfs@gmx.com>, linux-btrfs@vger.kernel.org
Subject: Re: How to erase a RAID1 (+++)?
Date: Thu, 30 Aug 2018 13:45:55 +0200
Message-ID: <2010862.shSW6Xocsf@x1>
In-Reply-To: <c67143ae-e845-1b01-fdee-a7c32a208e52@couderc.eu>
References: <04e4b43f-b21e-b6fd-dfad-0506ff35aff7@couderc.eu> <1bc34cb7-7523-11e1-b12f-05aff161b3c6@gmx.com> <c67143ae-e845-1b01-fdee-a7c32a208e52@couderc.eu>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thursday, 30 August 2018 12:01:55 CEST Pierre Couderc wrote:
> 
> On 08/30/2018 11:35 AM, Qu Wenruo wrote:
> >
> > On 2018/8/30 下午5:13, Pierre Couderc wrote:
> >> Trying to install a RAID1 on a debian stretch, I made some mistake and
> >> got this, after installing on disk1 and trying to add second disk  :
> >>
> >>
> >> root@server:~# fdisk -l
> >> Disk /dev/sda: 1.8 TiB, 2000398934016 bytes, 3907029168 sectors
> >> Units: sectors of 1 * 512 = 512 bytes
> >> Sector size (logical/physical): 512 bytes / 512 bytes
> >> I/O size (minimum/optimal): 512 bytes / 512 bytes
> >> Disklabel type: dos
> >> Disk identifier: 0x2a799300
> >>
> >> Device     Boot Start        End    Sectors  Size Id Type
> >> /dev/sda1  *     2048 3907028991 3907026944  1.8T 83 Linux
> >>
> >>
> >> Disk /dev/sdb: 1.8 TiB, 2000398934016 bytes, 3907029168 sectors
> >> Units: sectors of 1 * 512 = 512 bytes
> >> Sector size (logical/physical): 512 bytes / 512 bytes
> >> I/O size (minimum/optimal): 512 bytes / 512 bytes
> >> Disklabel type: dos
> >> Disk identifier: 0x9770f6fa
> >>
> >> Device     Boot Start        End    Sectors  Size Id Type
> >> /dev/sdb1  *     2048 3907029167 3907027120  1.8T  5 Extended
> >>
> >>
> >> And :
> >>
> >> root@server:~# btrfs fi show
> >> Label: none  uuid: eed65d24-6501-4991-94bd-6c3baf2af1ed
> >>          Total devices 2 FS bytes used 1.10GiB
> >>          devid    1 size 1.82TiB used 4.02GiB path /dev/sda1
> >>          devid    2 size 1.00KiB used 0.00B path /dev/sdb1

I think your problem is that sdb1 is a extended partition and not a primary one or you'll need to make a logical partition inside the extended partition and use that.


-- 
Kai Stian Olstad
