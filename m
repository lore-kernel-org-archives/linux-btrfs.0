Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from bear.techie.net ([205.134.185.202]:42787 "EHLO bear.techie.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752311AbcAUUEH (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 21 Jan 2016 15:04:07 -0500
Received: from bear.techie.net (localhost [127.0.0.1])
	by bear.techie.net (8.14.4/8.14.4/Debian-4.1ubuntu1) with ESMTP id u0LJoSNo009780
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
	for <linux-btrfs@vger.kernel.org>; Thu, 21 Jan 2016 14:50:28 -0500
Received: from localhost (talbert@localhost)
	by bear.techie.net (8.14.4/8.14.4/Submit) with ESMTP id u0LJoRks009777
	for <linux-btrfs@vger.kernel.org>; Thu, 21 Jan 2016 14:50:27 -0500
Date: Thu, 21 Jan 2016 14:50:27 -0500 (EST)
From: Scott Talbert <swt@techie.net>
To: linux-btrfs@vger.kernel.org
Subject: RAID1 root filesystem - same device shows up twice in 'btrfs fi
 show'
Message-ID: <alpine.DEB.2.10.1601211432430.9575@bear.techie.net>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=US-ASCII
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

I'm using:

Kernel 4.2.6
btrfs-progs v4.3
Debian Wheezy

I have a RAID1 root filesystem with two devices.  When the system 
initially boots up, "btrfs fi show" will show the same device twice:

Label: none  uuid: 49f7413a-99ad-41b0-8783-06c9406e2280
 	Total devices 2 FS bytes used 1.19GiB
 	devid    1 size 7.60GiB used 3.03GiB path /dev/sdf2
 	devid    2 size 7.60GiB used 3.01GiB path /dev/sdf2

The filesystem seems to work fine (as best as I can tell) in this state. 
If I then run another "btrfs device scan", it will correct itself:

Label: none  uuid: 49f7413a-99ad-41b0-8783-06c9406e2280
         Total devices 2 FS bytes used 1.19GiB
         devid    1 size 7.60GiB used 3.03GiB path /dev/sde2
         devid    2 size 7.60GiB used 3.01GiB path /dev/sdf2

Any idea what might be going on here?  On Debian it appears that the 
initial "btrfs device scan" is being done by an initramfs local-premount 
script where it does:

modprobe btrfs
/bin/btrfs device scan 2>/dev/null

Does there perhaps need to be some delay between inserting the kernel 
module and running a scan?

Thanks,
Scott
