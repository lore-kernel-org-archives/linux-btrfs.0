Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from relais.videotron.ca ([24.201.245.36]:15402 "EHLO
	relais.videotron.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932940Ab2ESDD3 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 18 May 2012 23:03:29 -0400
MIME-version: 1.0
Content-type: text/plain; CHARSET=US-ASCII; format=flowed
Received: from CentOS6-A.si.polymtl.ca ([184.161.170.13])
 by VL-VM-MR003.ip.videotron.ca
 (Oracle Communications Messaging Exchange Server 7u4-22.01 64bit (built Apr 21
 2011)) with ESMTP id <0M49008JT1TTH820@VL-VM-MR003.ip.videotron.ca> for
 linux-btrfs@vger.kernel.org; Fri, 18 May 2012 23:03:29 -0400 (EDT)
Message-id: <4FB70D80.4030300@polymtl.ca>
Date: Fri, 18 May 2012 23:03:28 -0400
From: Christian Robert <christian.robert@polymtl.ca>
To: linux-btrfs@vger.kernel.org
Subject: btrfs: Probably the larger filesystem I will see for a long time
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Probably the larger filesystem I will ever see. Tryed 8 Exabytes but it failed.

[root@CentOS6-A:/root] # df
Filesystem                    1K-blocks      Used         Available  Use%  Mounted
/dev/mapper/vg01-root          17915884  11533392           5513572   68%  /
/dev/sda1                        508745    140314            342831   30%  /boot
/dev/mapper/data_0             66993872   1644372          61994060    3%  /mnt/data_0
/dev/mapper/data_1     7881299347898368    508360  7881248224091896    1%  /mnt/data_1

[root@CentOS6-A:/root] # df -h
Filesystem             Size  Used  Avail  Use%  Mounted
/dev/mapper/vg01-root   18G   11G   5.3G   68%  /
/dev/sda1              497M  138M   335M   30%  /boot
/dev/mapper/data_0      64G  1.6G    60G    3%  /mnt/data_0
/dev/mapper/data_1     7.0E  497M   7.0E    1%  /mnt/data_1

[root@CentOS6-A:/root] # df -Th
Filesystem              Type  Size  Used  Avail  Use%
/dev/mapper/vg01-root   ext4   18G   11G   5.3G  68%
/dev/sda1               ext4  497M  138M   335M  30%
/dev/mapper/data_0      ext4   64G  1.6G    60G  3%
/dev/mapper/data_1     btrfs  7.0E  499M   7.0E  1%
[root@CentOS6-A:/root] #


[root@CentOS6-A:/root] # uname -rv
3.4.0-rc7+ #23 SMP Wed May 16 20:20:47 EDT 2012


made with a dm-thin device sitting on a device pair composed of (metadata 256Megs and data 23 Gigs)

running on my laptop at home.

yes, this is 7 Exabytes or 7,168 Petabytes or ( 7,340,032 Terabytes ) or 7,516,192,768 Gigabytes.


please do not answer, it is just a statement of a fact at 3.4-rc7 (was not working at 3.4-rc3 if I remember).


Xtian.
