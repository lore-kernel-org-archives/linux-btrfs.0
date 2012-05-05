From: Mike Sampson <mike@sambodata.com>
Subject: Is it possible to reclaim block groups once they are allocated to
 data or metadata?
Date: Sat, 5 May 2012 22:37:01 +1000
Message-ID: <CALzgn9tppzTem57mD6ORK7SXCK2vM6hcsWxphdHLr4eNwFTPQg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hello list,

recently reformatted my home partition from XFS to RAID1 btrfs. I used
the default options to mkfs.btrfs except for enabling raid1 for data
as well as metadata. Filesystem is made up of two 1TB drives.

mike@mercury (0) pts/3 ~ $ sudo btrfs filesystem show
Label: none  uuid: f08a8896-e03e-4064-9b94-9342fb547e47
	Total devices 2 FS bytes used 888.06GB
	devid    1 size 931.51GB used 931.51GB path /dev/sdb1
	devid    2 size 931.51GB used 931.49GB path /dev/sdc1

Btrfs Btrfs v0.19

mike@mercury (0) pts/3 ~ $ btrfs filesystem df /home
Data, RAID1: total=893.48GB, used=886.60GB
Data: total=8.00MB, used=0.00
System, RAID1: total=8.00MB, used=136.00KB
System: total=4.00MB, used=0.00
Metadata, RAID1: total=38.00GB, used=2.54GB
Metadata: total=8.00MB, used=0.00

As can be seen I don't have a lot of free space left and while I am
planning on adding more storage soon I would like to gain a little
breathing room until I can do this. While I don't have a lot of space
remaining in Data, RAID1 I do have a good chunk in Metadata, RAID1.
2.5GB used out of 38GB. Does this excess become available
automatically to the file system when the block groups in Data, RAID1
are exhausted or, if not, is there a way to manually reallocate them?

Regards,

Mike
