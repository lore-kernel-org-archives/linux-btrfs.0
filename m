Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.19]:61089 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932187AbcGOJvX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 15 Jul 2016 05:51:23 -0400
From: Matt <langelino@gmx.net>
Content-Type: text/plain; charset=utf-8
Date: Fri, 15 Jul 2016 11:51:18 +0200
Subject: Data recovery from a linear multi-disk btrfs file system
To: linux-btrfs@vger.kernel.org
Message-Id: <A06BAA26-44FF-4947-B552-26ED228B5BF6@gmx.net>
Mime-Version: 1.0 (Mac OS X Mail 9.3 \(3124\))
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello

I glued together 6 disks in linear lvm fashion (no RAID) to obtain one large file system (see below).  One of the 6 disk failed. What is the best way to recover from this?

Thanks to RAID1 of the metadata I can still access the data residing on the remaining 5 disks after mounting ro,force.  What I would like to do now is to 

1) Find out the names of all the files with missing data
2) Make the file system fully functional (rw) again.

To achieve 2 I wanted to move the data of the disk. This, however, turns out to be rather difficult. 
 - rsync does not provide a immediate time-out option in case of an IO error
 - Even when I set the time-out for dd_rescue to a minimum, the transfer speed is still way too low to move the data
 (> 15TB) off the file system.
Both methods are too slow to move off the data within a reasonable time frame. 

Does anybody have a suggestion how to best recover from this? (Our backup is incomplete).
I am looking for either a tool to move off the  data — something which gives up immediately in case of IO error and log the affected files.
Alternatively I am looking for a btrfs command like  “ btrfs device delete missing “ for a non-RAID multi-disk btrfs filesystem.
Would some variant of  "btrfs balance" do something helpful?

Any help is appreciated!

Regards,
Matt

# btrfs fi show
Label: none  uuid: d82fff2c-0232-47dd-a257-04c67141fc83
	Total devices 6 FS bytes used 16.83TiB
	devid    1 size 3.64TiB used 3.47TiB path /dev/sdc
	devid    2 size 3.64TiB used 3.47TiB path /dev/sdd
	devid    3 size 3.64TiB used 3.47TiB path /dev/sde
	devid    4 size 3.64TiB used 3.47TiB path /dev/sdf
	devid    5 size 1.82TiB used 1.82TiB path /dev/sdb
	*** Some devices missing


# btrfs fi df /work
Data, RAID0: total=18.31TiB, used=16.80TiB
Data, single: total=8.00MiB, used=8.00MiB
System, RAID1: total=8.00MiB, used=896.00KiB
System, single: total=4.00MiB, used=0.00B
Metadata, RAID1: total=34.00GiB, used=30.18GiB
Metadata, single: total=8.00MiB, used=0.00B
GlobalReserve, single: total=512.00MiB, used=0.00B

