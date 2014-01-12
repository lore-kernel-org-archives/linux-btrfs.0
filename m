Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail01.jit-creatives.de ([188.40.162.6]:55469 "EHLO
	mail01.jit-creatives.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751038AbaALVkg (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 12 Jan 2014 16:40:36 -0500
To: <linux-btrfs@vger.kernel.org>
Subject: Re: RAID 1 with no data on it when accidentally switched HDD
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Date: Sun, 12 Jan 2014 22:40:34 +0100
From: Ingo Ebel <ingo.ebel@ingoebel.de>
Message-ID: <b93a253364541dd18356eaefb64d3168@www.jitmail.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

> I don't understand the exact sequence. How does a 3rd drive appear as 
> sdc when
> the 2nd drive is sdc and sdc1 is part of a Btrfs file system already? 
> Did you
> reboot and the 3rd drive became sdc? This needs to be explained 
> better,
> including the exact commands you used.

Ok i try to.

I made the btrfs with:
mkfs.btrfs -f -m raid1 -d raid1 /dev/sdb1 /dev/sdc1

part of my /etc/fstab:

/dev/sdb1	/data	btrfs	defaults,compress	0 0
/dev/sdb1 /usr/src/packages btrfs	defaults,compress,subvol=packages	0 0

No other special commands used.

Hardware Setup:

SATA-Port 1 - HDD with opensuse
SATA-Port 2 - HDD /dev/sdb
SATA-Port 3 - DVD
SATA-Port 4 - HDD /dev/sdc

Put at SATA Port 3 an HDD instead an DVD and it got /dev/sdc after 
rebooting my system.

Regards

Ingo
