Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.jrs-s.net ([173.230.137.22]:47838 "EHLO mail.jrs-s.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756040AbaAFWYn (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 6 Jan 2014 17:24:43 -0500
Message-ID: <52CB2D29.4070302@jrs-s.net>
Date: Mon, 06 Jan 2014 17:24:41 -0500
From: Jim Salter <jim@jrs-s.net>
MIME-Version: 1.0
To: Chris Murphy <lists@colorremedies.com>
CC: Chris Samuel <chris@csamuel.org>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: btrfs raid1 and btrfs raid10 arrays NOT REDUNDANT
References: <52C73987.7000106@jrs-s.net> <52C87A41.9030701@jrs-s.net> <05C97109-682D-4A62-B074-4EDCF8E9CE1E@colorremedies.com> <1416119.lWHlh5idGF@quad> <C7E0F781-5F46-4C76-BCC9-0DE416553046@colorremedies.com> <52CB031C.7060403@jrs-s.net> <1FC5CA49-4BEE-49D5-B475-5E16DD76BF06@colorremedies.com>
In-Reply-To: <1FC5CA49-4BEE-49D5-B475-5E16DD76BF06@colorremedies.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

No, the installer is completely unaware. What I was getting at is that 
rebalancing (and installing the bootloader) is dead easy, so it doesn't 
bug me personally much.  It'd be nice to eventually get something in the 
installer to make it obvious to the oblivious that it can be done and 
how, but in the meantime, it's frankly easier to set up btrfs-raid 
WITHOUT installer support than it is to set up mdraid WITH installer support

Install process for 4-drive btrfs-raid10 root on Ubuntu (desktop or server):

1. do single-disk install on first disk, default all the way through 
except picking btrfs instead of ext4 for /
2. sfdisk -d /dev/sda | sfdisk /dev/sdb ; sfdisk -d /dev/sda | sfdisk 
/dev/sdc ; sfdisk -d /dev/sda | sfdisk /dev/sdd
3. btrfs dev add /dev/sdb1 /dev/sdc1 /dev/sdd1 /
4. btrfs balance start -dconvert=raid10 -mconvert=raid10 /
5. grub-install /dev/sdb ; grub-install /dev/sdc ; grub-install /dev/sdd

Done. The rebalancing takes less than a minute, and the system's 
responsive while it happens.  Once you've done the grub-install on the 
additional drives, you're good to go - Ubuntu already uses the UUID 
instead of a device ID for GRUB and fstab, so the btrfs mount will scan 
all drives and find any that are there. The only hitch is the need to 
mount degraded that I Chicken Littled about earlier so loudly. =)

On 01/06/2014 05:05 PM, Chris Murphy wrote:
> On Jan 6, 2014, at 12:25 PM, Jim Salter <jim@jrs-s.net> wrote:
>
>> FWIW, Ubuntu (and I presume Debian) will work just fine with a single / on btrfs, single or multi disk.
>>
>> I currently have two machines booting to a btrfs-raid10 / with no separate /boot, one booting to a btrfs single disk / with no /boot, and one booting to a btrfs-raid10 / with an ext4-on-mdraid1 /boot.
> Did you create the multiple device layouts outside of the installer first?
>
> What I'm seeing in the Ubuntu 12.03.04 installer is a choice of which disk to put the bootloader. If that's reliable UI, then it won't put it on both disks which means a single point of failure in which case -o degraded not being automatic with Btrfs is essentially pointless if we don't have a bootloader. I also see no way in the UI to even create Btrfs raid of any sort.
>
> Chris Murphy

