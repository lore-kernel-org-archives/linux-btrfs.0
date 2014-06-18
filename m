Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from slmp-550-94.slc.westdc.net ([50.115.112.57]:35063 "EHLO
	slmp-550-94.slc.westdc.net" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754633AbaFRUKr convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 18 Jun 2014 16:10:47 -0400
Content-Type: text/plain; charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 6.6 \(1510\))
Subject: Re: btrfs on whole disk (no partitions)
From: Chris Murphy <lists@colorremedies.com>
In-Reply-To: <CAPLrYESSX+D5tnY_qWcz0B+xUyyT1Ut-ALM=b9TfehACUq82GA@mail.gmail.com>
Date: Wed, 18 Jun 2014 14:10:46 -0600
Message-Id: <33D49915-811C-459F-B221-3F342F6D4944@colorremedies.com>
References: <CAPLrYESSX+D5tnY_qWcz0B+xUyyT1Ut-ALM=b9TfehACUq82GA@mail.gmail.com>
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>,
        =?utf-8?Q?Daniel_Cegie=C5=82ka?= <daniel.cegielka@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


On Jun 18, 2014, at 1:29 PM, Daniel Cegiełka <daniel.cegielka@gmail.com> wrote:

> Hi,
> I created btrfs directly to disk using such a scheme (no partitions):
> 
> dd if=/dev/zero of=/dev/sda bs=4096
> mkfs.btrfs -L dev_sda /dev/sda
> mount /dev/sda /mnt
> 
> cd /mnt
> btrfs subvolume create __active
> btrfs subvolume create __active/rootvol
> btrfs subvolume create __active/usr
> btrfs subvolume create __active/home
> btrfs subvolume create __active/var
> btrfs subvolume create __snapshots
> 
> cd /
> umount /mnt
> mount -o subvol=__active/rootvol /dev/sda /mnt
> mkdir /mnt/{usr,home,var}
> mount -o subvol=__active/usr /dev/sda /mnt/usr
> mount -o subvol=__active/home /dev/sda /mnt/home
> mount -o subvol=__active/var /dev/sda /mnt/var
> 
> # /etc/fstab
> UID=ID    /    btrfs rw,relative,space_cache,subvol=__active/rootvol    0 0
> UUID=ID    /usr    btrfs rw,relative,space_cache,subvol=__active/usr    0 0
> UUID=ID    /home    btrfs rw,relative,space_cache,subvol=__active/home    0 0
> UUID=ID    /var    btrfs rw,relative,space_cache,subvol=__active/var    0 0

rw and space_cache are redundant because they are default; and relative is not a valid mount option. All you need is subvol= 

> Everything works fine. Is such a solution is recommended? In my
> opinion, the creation of the partitions seems to be completely
> unnecessary if you can use btrfs.

It's firmware specific. Some BIOS firmwares will want to see a valid MBR partition map at LBA 0, not just boot code. Others only care to blindly execute the boot code which would be put in the Btrfs bootloader pad (64KB). I don't know if parted 3.1 recognizes partitionless disks with Btrfs though so it might slightly increase the risk that it's treated as something other than what it is.

For UEFI firmware, it would definitely need to be partitioned since an EFI System partition is required.

Chris Murphy