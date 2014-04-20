Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from noc.netops.me ([50.22.23.10]:42027 "EHLO noc.netops.me"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751303AbaDTSC7 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 20 Apr 2014 14:02:59 -0400
Received: from [174.77.42.16] (port=59950)
	by noc.netops.me with esmtpsa (TLSv1:DHE-RSA-AES128-SHA:128)
	(Exim 4.82)
	(envelope-from <adam@aeb.io>)
	id 1WbvWA-0007j1-O7
	for linux-btrfs@vger.kernel.org; Sun, 20 Apr 2014 12:27:02 -0500
Message-ID: <53540367.4050707@aeb.io>
Date: Sun, 20 Apr 2014 10:27:03 -0700
From: Adam Brenner <adam@aeb.io>
MIME-Version: 1.0
To: linux-btrfs@vger.kernel.org
Subject: Slow Write Performance w/ No Cache Enabled and Different Size Drives
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Howdy,

I recently setup a new BTRFS filesystem based on BTRFS version 3.12 on
Linux kernel 3.13-1 running Debian Jessie.

The BTRFS volume spans 3x 4TB disks, two of which are using the entire
raw block device, and one of them is using a partition (OS disks). The
setup is like so:


     root@gra-dfs:/data/tmp# btrfs filesystem show
     Label: none  uuid: 63d51c9b-f851-404f-b0f2-bf84d07df163
	    Total devices 3 FS bytes used 3.03TiB
	    devid    1 size 3.61TiB used 1.01TiB path /dev/sda3
	    devid    2 size 3.64TiB used 1.04TiB path /dev/sdb
	    devid    3 size 3.64TiB used 1.04TiB path /dev/sdc

     Btrfs v3.12
     root@gra-dfs:/data/tmp# btrfs filesystem df /data
     Data, single: total=3.07TiB, used=3.03TiB
     System, RAID1: total=8.00MiB, used=352.00KiB
     System, single: total=4.00MiB, used=0.00
     Metadata, RAID1: total=5.00GiB, used=3.60GiB
     Metadata, single: total=8.00MiB, used=0.00
     root@gra-dfs:/data/tmp#
     root@gra-dfs:/home# mount | grep /data
     /dev/sda3 on /data type btrfs (rw,noatime,space_cache)
     root@gra-dfs:/home#


The setup is supposed to be "RAID-0 like" but with different size drives
within the volume, I created the BTRFS filesystem using the following
command based on the WiKi[1]

     mkfs.btrfs -d single /dev/sda3 /dev/sdb /dev/sdc -f

Once setup, I transferred roughly 3.1TB of data and noticed the write 
speed was limited to 200MB/s. This is the same write speed that I would 
see across a single device. I used dd with oflag=direct and a block size 
of 1M and a count of 1024 from /dev/zero. Both showed the same speeds.

So my question is, should I have setup the BTRFS filesystem with -d 
raid0? Would this have worked with multiple devices with different sizes?

[1]: 
https://btrfs.wiki.kernel.org/index.php/Using_Btrfs_with_Multiple_Devices


-- 
Adam Brenner <adam@aeb.io>
