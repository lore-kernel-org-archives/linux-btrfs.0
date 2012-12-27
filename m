Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from qmta03.emeryville.ca.mail.comcast.net ([76.96.30.32]:57776 "EHLO
	qmta03.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752749Ab2L0QzY convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 27 Dec 2012 11:55:24 -0500
Content-Type: text/plain; charset=iso-8859-1
Mime-Version: 1.0 (Mac OS X Mail 6.2 \(1499\))
Subject: Re: Another novice question & comment
From: Chris Murphy <lists@colorremedies.com>
In-Reply-To: <50DC7BA0.2080401@petaramesh.org>
Date: Thu, 27 Dec 2012 09:55:22 -0700
Message-Id: <95393023-B40D-4331-A429-3D488B9D0576@colorremedies.com>
References: <50DC5B51.9060506@czarc.net> <20121227150328.GV19051@carfax.org.uk> <50DC7BA0.2080401@petaramesh.org>
To: linux-btrfs Mailing list <linux-btrfs@vger.kernel.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


On Dec 27, 2012, at 9:47 AM, Swâmi Petaramesh <swami@petaramesh.org> wrote:

> Le 27/12/2012 16:03, Hugo Mills a écrit :
>>   Right now, no, there isn't any way of telling which subvolume is
>> mounted at a given location.
> 
> Er... Check "subvol=" here...
> 
> root@tethys:/# mount | grep btrfs
> /dev/mapper/VG1-BTR_POOL on / type btrfs
> (rw,relatime,subvol=UBUNTU/@,autodefrag,compress=lzo)
> /dev/mapper/VG1-BTR_POOL on /tmp type btrfs
> (rw,relatime,subvol=UBUNTU/@tmp,compress=lzo)
> /dev/sda2 on /boot type btrfs (rw,relatime,subvol=UBUNTU/@boot,autodefrag)
> /dev/mapper/VG1-BTR_POOL on /home type btrfs
> (rw,relatime,subvol=UBUNTU/@home,autodefrag,compress=lzo)
> /dev/mapper/VG1-BTR_POOL on /storage type btrfs
> (rw,relatime,subvol=STORAGE,autodefrag,compress=lzo)
> /dev/mapper/VG1-BTR_POOL on /data/BIG type btrfs
> (rw,noatime,subvol=DATA/BIG,compress=lzo)


That would only seem to work with btrfs on LVM which I'd think is uncommon and complicated.


Chris Murphy