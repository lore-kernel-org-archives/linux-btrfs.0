Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from slmp-550-94.slc.westdc.net ([50.115.112.57]:41853 "EHLO
	slmp-550-94.slc.westdc.net" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751019AbaALVuF convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 12 Jan 2014 16:50:05 -0500
Received: from c-50-183-15-223.hsd1.co.comcast.net ([50.183.15.223]:56675 helo=[192.168.1.145])
	by slmp-550-94.slc.westdc.net with esmtpsa (TLSv1:AES128-SHA:128)
	(Exim 4.82)
	(envelope-from <lists@colorremedies.com>)
	id 1W2Suy-004C5t-Pq
	for linux-btrfs@vger.kernel.org; Sun, 12 Jan 2014 14:50:04 -0700
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 6.6 \(1510\))
Subject: Re: RAID 1 with no data on it when accidentally switched HDD
From: Chris Murphy <lists@colorremedies.com>
In-Reply-To: <b93a253364541dd18356eaefb64d3168@www.jitmail.de>
Date: Sun, 12 Jan 2014 14:50:03 -0700
Message-Id: <EF449A1E-2C53-43BB-883E-98EE848E60CB@colorremedies.com>
References: <b93a253364541dd18356eaefb64d3168@www.jitmail.de>
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


On Jan 12, 2014, at 2:40 PM, Ingo Ebel <ingo.ebel@ingoebel.de> wrote:

> Hi,
> 
>> I don't understand the exact sequence. How does a 3rd drive appear as sdc when
>> the 2nd drive is sdc and sdc1 is part of a Btrfs file system already? Did you
>> reboot and the 3rd drive became sdc? This needs to be explained better,
>> including the exact commands you used.
> 
> Ok i try to.
> 
> I made the btrfs with:
> mkfs.btrfs -f -m raid1 -d raid1 /dev/sdb1 /dev/sdc1
> 
> part of my /etc/fstab:
> 
> /dev/sdb1	/data	btrfs	defaults,compress	0 0
> /dev/sdb1 /usr/src/packages btrfs	defaults,compress,subvol=packages	0 0
> 
> No other special commands used.
> 
> Hardware Setup:
> 
> SATA-Port 1 - HDD with opensuse
> SATA-Port 2 - HDD /dev/sdb
> SATA-Port 3 - DVD
> SATA-Port 4 - HDD /dev/sdc
> 
> Put at SATA Port 3 an HDD instead an DVD and it got /dev/sdc after rebooting my system.

The drives on SATA port 2 and 4 are designated as what block devices after the reboot?

This change in block device designation is why using /dev/X in fstab is not a good idea, it's an ambiguous entry. I don't know what file system was actually mounted by fstab, and to what volume sdc was added. I suggest changing fstab to use fs UUID from blkid.

In the meantime what do you get for :
btrfs fi show
cat /proc/self/mountinfo | grep btrfs



Chris Murphy