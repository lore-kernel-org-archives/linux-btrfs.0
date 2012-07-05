Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mondschein.lichtvoll.de ([194.150.191.11]:59464 "EHLO
	mail.lichtvoll.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932339Ab2GENP5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 5 Jul 2012 09:15:57 -0400
From: Martin Steigerwald <Martin@lichtvoll.de>
To: kohler@umic.rwth-aachen.de, linux-btrfs@vger.kernel.org
Subject: Re: df shows wrong infos on btrfs raid (5gb and 3gb hdd)
Date: Thu, 5 Jul 2012 15:15:55 +0200
References: <4FF459A6.9080403@umic.rwth-aachen.de> (sfid-20120704_195448_565569_D8FE2752)
In-Reply-To: <4FF459A6.9080403@umic.rwth-aachen.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Message-Id: <201207051515.55689.Martin@lichtvoll.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Am Mittwoch, 4. Juli 2012 schrieb Bernd Kohler:
> Hi,

Hi Bernd,

> this is not really a bug in btrfs but to spread the info I will just
> drop this short message:
> 
> My System (VirtualBox VM, 3 virtual HDDs with 10G, 5G and 3G) is today
> installed Ubuntu 12.04 LTS 64bit with Kernel 3.2.0-26 generic, a
> /dev/sda hdd containing /boot with ext4 and / with btrfs.
> 
> After installation update/upgrade process I created a new partition on
> /dev/sdb and /dev/sdbc with max available size - 5G for sdb1 and 3G for
> sdc1.
> 
> Now I made my RAID:
> mkfs.btrfs -L MYRAID -d raid1 -m raid1 /dev/sdb1 /sdc1
[…]
> The infos, given by "btrfs fi show  /dev/sdb1" and "btrfs fi df /mnt"
> are ok, but df is "lieing":
> 
> Filesystem Size Used Avail Use% Mounted on
> /dev/sdc1  8.0G 5.2G 56k   100% /mnt
> 
> Don't get confused about used space, tried to write a 4G file on this
> RAID, which ended with "write error: no space left on device" - as
> expected

First read and understand:

https://btrfs.wiki.kernel.org/index.php/FAQ#Help.21_Btrfs_claims_I.27m_out_of_space.2C_but_it_looks_like_I_should_have_lots_left.21

Then re-examine your situation.

If you still think BTRFS is lying or have a good suggestion on how to 
change the current situation, post it here.

Thanks,
-- 
Martin 'Helios' Steigerwald - http://www.Lichtvoll.de
GPG: 03B0 0D6C 0040 0710 4AFA  B82F 991B EAAC A599 84C7
