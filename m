From: Goffredo Baroncelli <kreijack@libero.it>
Subject: Re: Adding a disk fails
Date: Thu, 20 Jan 2011 23:13:22 +0100
Message-ID: <4D38B382.1050709@libero.it>
References: <201101201318.40686.CACook@quantum-sci.com>
Reply-To: kreijack@inwind.it
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-btrfs@vger.kernel.org
To: Carl Cook <CACook@quantum-sci.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <201101201318.40686.CACook@quantum-sci.com>
List-ID: <linux-btrfs.vger.kernel.org>

On 01/20/2011 10:18 PM, Carl Cook wrote:
> 
> Well I've just tried to add a disk to another, but it fails.  I
> created the first (starting with no traditional partitions) with: #
> mkfs.btrfs /dev/sdb
> 
> Then I mounted it to /media/backups and put lots of files on it.  I
> shut down the system, added another disk.  Set it up with: #
> mkfs.btrfs /dev/sdc WARNING! - Btrfs Btrfs v0.19 IS EXPERIMENTAL 
> WARNING! - see http://btrfs.wiki.kernel.org before using fs created
> label (null) on /dev/sdc nodesize 4096 leafsize 4096 sectorsize 4096
> size 1.82TB Btrfs Btrfs v0.19 # btrfs device scan Scanning for Btrfs
> filesystems # (... Nothing?  Not even my known mounted sdb drive?) #
> btrfs device add /dev/sdc /media/backups ERROR: error adding the
> device '/dev/sdc'
> 
> It gives no clue as to what might possibly be the problem.  I want
> raid0.

To add another disk you don't have to run mkfs.btrfs. For example:

# add the first disk
mkfs.btrfs /dev/sdb
# mount the disk
mount /dev/sdb /media/backups

# add another disk to the first one
btrfs device add /dev/sdc /media/backup

Note1: the filesystem has to be mounted
Note2: the medatada will be in raid1, the data in raid0
If you shutdown the system, at the reboot you should "scan" all the
device in order to find the btrfs ones

# find the btrfs device
btrfs device scan

# mount the filesystem
mount /dev/sdb /media/backups 		# you can use also /dev/sdc



> 
> Also I can not understand this: "Note: While subvolumes can be
> created anywhere in the filesystem tree, in order to be mounted by
> name a subvolume or snapshot must be in the root of the btrfs
> filesystem."
> 
> I want to do this, but do not know what this means.  


Suppose to have a btrfs filesystem in /dev/sdb

mount /dev/sdb /media/backup

mkidr /media/backup/dir-1
<create a lot of file under /media/backup>

# make a snapshot
btrfs filesystem snapshot /media/backup /media/backup/snapshot-2

# make another snapshot
btrfs filesystem snapshot /media/backup /media/backup/dir-1/snapshot-3

# umount the filesystem
umount /media/backup

# mount snapshot-2 directly
mount -o subvol=snapshot-2 /dev/sdb /media/backup

# if you try to mount snapshot-3 directly, you fail because this
# snapshot is not under the root of the btrfs filesystem
mount -o subvol=dir-1/snapshot-3 /dev/sdb /media/backup	 # -> error

If you look at the output of the command "btrfs subvolume list <path>"
you can find the id of every subvolume. It is possible to use this ID to
mount directly a subvolume. This permits to mount a "non-root" subvolume.


> Tentatively I've
> created a BTRFS volume and mounted it on /media/backups.  I then
> created subvolumes as backup-hex, backup-droog, snaps-hex and
> snaps-droog.  When I created a snapshot it created a subdir under
> snaps-hex called hex-root.
> 
> It won't allow me to remove snapshots. (Debian Testing)

Which kenel version debian testing uses ?


> Also does anyone know how to create a shapshot with the current date
> in the name?

btrfs filesystem snapshot / /snapshot-$(date +"%Y-%m-%d")

> -- To unsubscribe from this list: send the line "unsubscribe
> linux-btrfs" in the body of a message to majordomo@vger.kernel.org 
> More majordomo info at  http://vger.kernel.org/majordomo-info.html .
> 

