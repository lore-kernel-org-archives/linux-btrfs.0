Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:46653 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755825AbbGVFZH (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 22 Jul 2015 01:25:07 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
	id 1ZHmWe-00078i-0U
	for linux-btrfs@vger.kernel.org; Wed, 22 Jul 2015 07:25:05 +0200
Received: from 210.94.41.89 ([210.94.41.89])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Wed, 22 Jul 2015 07:25:03 +0200
Received: from kthguru by 210.94.41.89 with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Wed, 22 Jul 2015 07:25:03 +0200
To: linux-btrfs@vger.kernel.org
From: Taeha Kim <kthguru@gmail.com>
Subject: resize: File too large
Date: Wed, 22 Jul 2015 05:19:40 +0000 (UTC)
Message-ID: <loom.20150722T071610-642@post.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello, 

I met a problem when resize btrfs as follows. The btrfs related sysinfo is 
attached at the end of this mail[1].

$ dd if=/dev/zero of=btrfs_5gb.img bs=1024 count=5000000 

$ mkfs.btrfs btrfs_5gb.img  

$ sudo mkdir -p /mnt/btrfs_5gb 

$ mount -t btrfs btrfs_5gb.img /mnt/btrfs_5gb 

$ btrfs filesystem resize +10g /mnt/btrfs_5gb  
Resize '/mnt/btrfs_5gb' of '+10g' 
ERROR: unable to resize '/mnt/btrfs_5gb' - File too large 

Is it a misuse case of resize? 

And I expected not the message "File too large" but different error message. 

Thanks. 


Sincerely yours, 
Taeha Kim, 
Senior Engineer, Samsung Electronics 


[1] The btrfs related sysinfo

$ btrfs --version
btrfs-progs v4.1.2

$ uname -r
4.0.8-300.fc22.x86_64

$ btrfs fi show /mnt/btrfs_5g
btrfs-progs v4.1

$ btrfs fi df /mnt/btrfs_5g
Data, single: total=8.00MiB, used=64.00KiB
System, DUP: total=8.00MiB, used=16.00KiB
System, single: total=4.00MiB, used=0.00B
Metadata, DUP: total=244.12MiB, used=112.00KiB
Metadata, single: total=8.00MiB, used=0.00B
GlobalReserve, single: total=16.00MiB, used=0.00B

$ dmesg | grep BTRFS
BTRFS info (device loop0): disk space caching is enabled
BTRFS: has skinny extents
BTRFS: flagging fs with big metadata feature
BTRFS: creating UUID tree
BTRFS info (device loop0): disk space caching is enabled
BTRFS: has skinny extents.


