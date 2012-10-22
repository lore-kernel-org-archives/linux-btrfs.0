Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from qmta01.emeryville.ca.mail.comcast.net ([76.96.30.16]:51643 "EHLO
	qmta01.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750828Ab2JVEcb convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 22 Oct 2012 00:32:31 -0400
From: Chris Murphy <lists@colorremedies.com>
Content-Type: text/plain; charset=us-ascii
Subject: device delete, error removing device
Message-Id: <D297D796-B7E9-4A65-AD72-EC394AD32D4C@colorremedies.com>
Date: Sun, 21 Oct 2012 22:32:26 -0600
To: linux-btrfs@vger.kernel.org
Mime-Version: 1.0 (Mac OS X Mail 6.2 \(1499\))
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Summary: 3 drive raid0 btrfs volume, in a VM. There is no data at risk at all. Purely a test. The volume is pretty much full. I added a larger drive /dev/sde to the existing btrfs volume; then tried to remove one of the smaller drives. I'm getting an error removing the device. It seems this should be possible, e.g. move extents on a failing device to a replacement prior to failure.

This is stock Fedora 18 beta kernel, 3.6.1-1.fc18.x86_64 #1 SMP Mon Oct 8 17:19:09 UTC 2012 x86_64 x86_64 x86_64 GNU/Linux


[root@f18v ~]# btrfs device add /dev/sde /mnt
[root@f18v ~]# btrfs fi show
failed to read /dev/sr0
Label: none  uuid: 6e96a96e-3357-4f23-b064-0f0713366d45
	Total devices 4 FS bytes used 7.52GB
	devid    4 size 12.00GB used 0.00 path /dev/sde
	devid    3 size 3.00GB used 3.00GB path /dev/sdd
	devid    2 size 3.00GB used 2.55GB path /dev/sdc
	devid    1 size 3.00GB used 3.00GB path /dev/sdb
	
[root@f18v ~]# btrfs fi df /mnt
Data, RAID0: total=7.61GB, used=7.51GB
System, RAID1: total=8.00MB, used=4.00KB
Metadata, RAID1: total=460.75MB, used=10.91MB
	
[root@f18v ~]# btrfs device delete /dev/sdb /mnt
ERROR: error removing the device '/dev/sdb' - No space left on device
	
[  570.379652] btrfs: relocating block group 29360128 flags 20
[  571.739126] btrfs: found 2717 extents
[  571.761061] btrfs: relocating block group 12582912 flags 1
[  571.787233] btrfs: relocating block group 4194304 flags 4
[  571.806878] btrfs: relocating block group 0 flags 2

Some time later (hours), I unmounted, remounted, and see this:

[root@f18v ~]# btrfs fi show
failed to read /dev/sr0
Label: none  uuid: 6e96a96e-3357-4f23-b064-0f0713366d45
	Total devices 4 FS bytes used 7.52GB
	devid    4 size 12.00GB used 460.75MB path /dev/sde
	devid    3 size 3.00GB used 2.55GB path /dev/sdd
	devid    2 size 3.00GB used 3.00GB path /dev/sdc
	devid    1 size 3.00GB used 2.53GB path /dev/sdb

Subsequent attempts cause the same failure, but no new entries in dmesg.

If I try with a different device, there is activity, but after a few seconds, another failure, similar errors in dmesg:

[root@f18v ~]# btrfs device delete /dev/sdc /mnt
ERROR: error removing the device '/dev/sdc' - No space left on device


[ 2478.017828] btrfs: relocating block group 8955363328 flags 20
[ 2478.059607] btrfs: relocating block group 8686927872 flags 20
[ 2479.405142] btrfs: found 2735 extents
[ 2479.436190] btrfs: relocating block group 8663859200 flags 9
[ 2479.458680] btrfs: relocating block group 8243118080 flags 9
[ 2481.949991] btrfs: found 4 extents
[ 2482.700146] btrfs: found 4 extents
[ 2482.717422] btrfs: relocating block group 20971520 flags 18
[ 2482.733835] btrfs: found 1 extents

User error? Known bug?


Chris Murphy