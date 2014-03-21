Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([74.208.4.201]:54167 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751613AbaCUDVe (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 20 Mar 2014 23:21:34 -0400
Received: from [192.168.0.201] ([75.203.7.21]) by mail.gmx.com (mrgmxus001)
 with ESMTPSA (Nemesis) id 0LeMmZ-1Wu5Q61ob7-00qBl3 for
 <linux-btrfs@vger.kernel.org>; Fri, 21 Mar 2014 04:21:32 +0100
Message-ID: <532BB037.90401@gmx.com>
Date: Thu, 20 Mar 2014 23:21:27 -0400
From: "sepero111@gmx.com" <sepero111@gmx.com>
MIME-Version: 1.0
To: linux-btrfs@vger.kernel.org
Subject: Especially broken btrfs
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello all. I submit bugs to different foss projects regularly, but I don't 
really have a bug report this time. I have a broken filesystem to report. And I 
have no idea how to reproduce it.

I am including a link to the filesystem itself, because it appears to be 
unrepairable and unrestorable. I have no personal information on the disk image. 
The filesystem is almost 512MB uncompressed. I was using it on an old usb drive 
with 512MB size limitation. I only used (abused?) it about 2 days before this 
corruption.

My goal was to use the usb as a bootable rescue system. I decided to try Btrfs 
instead of Ext4, because it supports filesystem compression.

BTRFS IMAGE LINK (please pardon my file hosting service)
http://www.mediafire.com/download/gdaydt3mz8uwtmm/sdb1.btrfs.xz


These are some things that may have helped to cause the corruption.

+Created btrfs with -M flag
+Installed Debian testing/unstable
+When mounting, I always used at least these options: 
ssd_spread,noatime,compression=zlib,autodefrag
+Occasionally force powering off computer.
+While booted into usb system, I was constantly running out of space while 
trying to install new packages.

It is my hope that this image might be used to improve the btrfs restore and 
btrfsck tools. Please let me know if I can provide any further information. Big 
thanks to everyone helping to further development of Btrfs.

Sepero

