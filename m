Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:39744 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932368AbaAaWA4 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 31 Jan 2014 17:00:56 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1W9M8o-0001jm-Nz
	for linux-btrfs@vger.kernel.org; Fri, 31 Jan 2014 23:00:50 +0100
Received: from 78-32-127-104.static.enta.net ([78.32.127.104])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Fri, 31 Jan 2014 23:00:50 +0100
Received: from alex by 78-32-127-104.static.enta.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Fri, 31 Jan 2014 23:00:50 +0100
To: linux-btrfs@vger.kernel.org
From: Alex <alex@bpmit.com>
Subject: Re: Booting with syslinux not possible
Date: Fri, 31 Jan 2014 22:00:26 +0000 (UTC)
Message-ID: <loom.20140131T225403-745@post.gmane.org>
References: <52EBFD82.7080900@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Sorry KC:

All my VM's are on syslinux (actually extlinux) and btrfs:
   Device Boot      Start         End      Blocks   Id  System
/dev/vda1   *        2048     7938047     3968000   83  Linux
/dev/vda2         7938048     8388607      225280   82  Linux swap / Solaris

root@<VM> ~ # ll /boot
total 19452
-rw-r--r-- 1 root root  2319932 Jan 21 06:12 System.map-3.12-1-amd64
-rw-r--r-- 1 root root   149029 Jan 21 06:12 config-3.12-1-amd64
drwxr-xr-x 1 root root      176 Jan 28 22:32 extlinux/
-rw-r--r-- 1 root root 14240605 Jan 28 22:32 initrd.img-3.12-1-amd64
-rw-r--r-- 1 root root   176764 Nov 13  2011 memtest86+.bin
-rw-r--r-- 1 root root   178944 Nov 13  2011 memtest86+_multiboot.bin
-rw-r--r-- 1 root root  2842064 Jan 21 06:08 vmlinuz-3.12-1-amd64
root@china ~ #  

Occasionally I get excited and decide to fix it 'til it breaks (usually I
turn compression on, and /boot can't be accessed), but it's been working
fine for a few years now.

Kind regards.

Al.




