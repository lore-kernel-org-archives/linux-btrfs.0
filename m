Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from qmta05.emeryville.ca.mail.comcast.net ([76.96.30.48]:52008 "EHLO
	qmta05.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752026Ab3ALFu7 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 12 Jan 2013 00:50:59 -0500
From: Chris Murphy <lists@colorremedies.com>
Content-Type: text/plain; charset=us-ascii
Subject: obscure out of space, df and fi df are way off
Message-Id: <A2AC222E-2F40-4B0A-BFA7-C9D2D3A5B193@colorremedies.com>
Date: Fri, 11 Jan 2013 22:50:56 -0700
To: "linux-btrfs@vger.kernel.org BTRFS" <linux-btrfs@vger.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 6.2 \(1499\))
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Very low priority.
No user data at risk.
8GB virtual disk being installed to, and the installer is puking. I'm trying to figure out why.

I first get an rsync error 12, followed by the installer crashing. What's interesting is this, deleting irrelevant source file systems, just showing the mounts for the installed system:

[root@localhost tmp]# df
Filesystem                 1K-blocks    Used Available Use% Mounted on
/dev/sda3                    3746816 3193172      1564 100% /mnt/sysimage
/dev/sda1                     495844   31509    438735   7% /mnt/sysimage/boot
/dev/sda3                    3746816 3193172      1564 100% /mnt/sysimage/home

So there's 1.5M of free space left according to conventional df. However:

[root@localhost tmp]# btrfs fi show
Label: 'fedora_f18v'  uuid: 0c9b2b62-5ec1-4610-ab2f-9f00c909428a
	Total devices 1 FS bytes used 2.87GB
	devid    1 size 3.57GB used 3.57GB path /dev/sda3

[root@localhost tmp]# btrfs fi df /mnt/sysimage
Data: total=2.69GB, used=2.69GB
System, DUP: total=8.00MB, used=4.00KB
System: total=4.00MB, used=0.00
Metadata, DUP: total=438.94MB, used=183.36MB
Metadata: total=8.00MB, used=0.00

And absolutely nothing in dmesg.

This is confusing. fi show says 3.57GB available and used. Whereas fi df says 2.69 available and used. So is it 3.57GB? Or is it 2.69? I suppose the simple answer is, it doesn't matter, in either case it's full. But it seems like the installer is underestimating Btrfs requirements and should be more conservative, somehow so I'd like to better understand the allocation.

But then, of course, it's a pretty small file system. This is a desktop installer, not embedded system, so the use case for an 8GB virtual disk itself calls into question the test perhaps.


Chris Murphy