From: Carl Cook <CACook@quantum-sci.com>
Subject: Re: Adding a disk fails
Date: Thu, 20 Jan 2011 15:10:54 -0800
Message-ID: <201101201510.54418.CACook@quantum-sci.com>
References: <201101201318.40686.CACook@quantum-sci.com> <4D38B382.1050709@libero.it>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4D38B382.1050709@libero.it>
List-ID: <linux-btrfs.vger.kernel.org>

On Thu 20 January 2011 14:13:22 Goffredo Baroncelli wrote:
> To add another disk you don't have to run mkfs.btrfs. For example:
> 
> # add the first disk
> mkfs.btrfs /dev/sdb
> # mount the disk
> mount /dev/sdb /media/backups
> 
> # add another disk to the first one
> btrfs device add /dev/sdc /media/backup

Thanks Goffredo but as I say, I did this and it responds with 
 "ERROR: error adding the device '/dev/sdc'"
... it doesn't give a clue.


> Note1: the filesystem has to be mounted
> Note2: the medatada will be in raid1, the data in raid0
> If you shutdown the system, at the reboot you should "scan" all the
> device in order to find the btrfs ones
> 
> # find the btrfs device
> btrfs device scan

This must be done at every boot?  If so, where is recommended, in rc.local? 


> # if you try to mount snapshot-3 directly, you fail because this
> # snapshot is not under the root of the btrfs filesystem
> mount -o subvol=dir-1/snapshot-3 /dev/sdb /media/backup	 # -> error

This is how I'd understood it, but when creating a subvolume in the root and putting a snalshot into it, it seems to make a further subvolume (or directory) with a redundant name.  This would not be under the root, and may not be mountable?


> Which kenel version debian testing uses ?

2.6.32-5-amd64 with Debian patches.


> btrfs filesystem snapshot / /snapshot-$(date +"%Y-%m-%d")

Oh thank you.



