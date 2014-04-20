Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from slmp-550-94.slc.westdc.net ([50.115.112.57]:60698 "EHLO
	slmp-550-94.slc.westdc.net" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755407AbaDTU0l convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 20 Apr 2014 16:26:41 -0400
Received: from c-75-70-18-61.hsd1.co.comcast.net ([75.70.18.61]:63136 helo=[192.168.1.145])
	by slmp-550-94.slc.westdc.net with esmtpsa (TLSv1:AES128-SHA:128)
	(Exim 4.82)
	(envelope-from <lists@colorremedies.com>)
	id 1WbyJy-000uYF-4t
	for linux-btrfs@vger.kernel.org; Sun, 20 Apr 2014 14:26:38 -0600
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 6.6 \(1510\))
Subject: Re: btrfs fi df "unknown" chunk type
From: Chris Murphy <lists@colorremedies.com>
In-Reply-To: <9C28A5D6-F223-400F-9471-85C0F88FA939@colorremedies.com>
Date: Sun, 20 Apr 2014 14:26:37 -0600
Message-Id: <1B7A7ABD-FF67-4ED0-A5E8-F24C0BBA4B0D@colorremedies.com>
References: <9C28A5D6-F223-400F-9471-85C0F88FA939@colorremedies.com>
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


On Apr 20, 2014, at 2:18 PM, Chris Murphy <lists@colorremedies.com> wrote:
> What is unknown?


/dev/sd[bcd] are 2GB, 3GB, and 4GB respectively.

[root@localhost ~]# mkfs.btrfs -d raid0 -m raid1 /dev/sd[bcd]

WARNING! - Btrfs v3.14 IS EXPERIMENTAL
WARNING! - see http://btrfs.wiki.kernel.org before using

Performing full device TRIM (2.00GiB) ...
Turning ON incompat feature 'extref': increased hardlink limit per file to 65536
Performing full device TRIM (3.00GiB) ...
adding device /dev/sdc id 2
Performing full device TRIM (4.00GiB) ...
adding device /dev/sdd id 3
fs created label (null) on /dev/sdb
	nodesize 16384 leafsize 16384 sectorsize 4096 size 9.00GiB

[root@localhost ~]# mount /dev/sdb /mnt
[root@localhost ~]# btrfs fi show
Label: none  uuid: ff85abb0-3398-40a0-b06c-8146cb1bfda0
	Total devices 3 FS bytes used 112.00KiB
	devid    1 size 2.00GiB used 787.94MiB path /dev/sdb
	devid    2 size 3.00GiB used 315.19MiB path /dev/sdc
	devid    3 size 4.00GiB used 775.94MiB path /dev/sdd

[root@localhost ~]# btrfs fi df /mnt
Data, RAID0: total=921.56MiB, used=256.00KiB
Data, single: total=8.00MiB, used=0.00
System, RAID1: total=8.00MiB, used=16.00KiB
System, single: total=4.00MiB, used=0.00
Metadata, RAID1: total=460.75MiB, used=112.00KiB
Metadata, single: total=8.00MiB, used=0.00
unknown, single: total=16.00MiB, used=0.00

[root@localhost ~]# btrfs balance start /mnt
Done, had to relocate 6 out of 6 chunks

[root@localhost ~]# btrfs fi show
Label: none  uuid: ff85abb0-3398-40a0-b06c-8146cb1bfda0
	Total devices 3 FS bytes used 384.00KiB
	devid    1 size 2.00GiB used 0.00 path /dev/sdb
	devid    2 size 3.00GiB used 288.00MiB path /dev/sdc
	devid    3 size 4.00GiB used 1.19GiB path /dev/sdd

[root@localhost ~]# btrfs fi df /mnt
Data, single: total=928.00MiB, used=256.00KiB
System, RAID1: total=32.00MiB, used=16.00KiB
Metadata, RAID1: total=256.00MiB, used=112.00KiB
unknown, single: total=16.00MiB, used=0.00


An unknown chunk type here too, exists even after a balance. Along with a weird allocation different merely due to balancing an empty file system.


Chris Murphy