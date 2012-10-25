Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from col0-omc1-s5.col0.hotmail.com ([65.55.34.15]:25672 "EHLO
	col0-omc1-s5.col0.hotmail.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751387Ab2JYVne convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 25 Oct 2012 17:43:34 -0400
Message-ID: <COL002-W72E3D3908E97F64D9F1866B07F0@phx.gbl>
From: Kyle Gates <kylegates@hotmail.com>
To: sam tygier <samtygier@yahoo.co.uk>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: RE: problem replacing failing drive
Date: Thu, 25 Oct 2012 16:37:23 -0500
In-Reply-To: <k6c9ct$tb5$1@ger.gmane.org>
References: <k632c9$3df$1@ger.gmane.org>,<k6c9ct$tb5$1@ger.gmane.org>
Content-Type: text/plain; charset=US-ASCII
MIME-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

----------------------------------------
> To: linux-btrfs@vger.kernel.org
> From: samtygier@yahoo.co.uk
> Subject: Re: problem replacing failing drive
> Date: Thu, 25 Oct 2012 22:02:23 +0100
>
> On 22/10/12 10:07, sam tygier wrote:
> > hi,
> >
> > I have a 2 drive btrfs raid set up. It was created first with a single drive, and then adding a second and doing
> > btrfs fi balance start -dconvert=raid1 /data
> >
> > the original drive is showing smart errors so i want to replace it. i dont easily have space in my desktop for an extra disk, so i decided to proceed by shutting down. taking out the old failing drive and putting in the new drive. this is similar to the description at
> > https://btrfs.wiki.kernel.org/index.php/Using_Btrfs_with_Multiple_Devices#Replacing_Failed_Devices
> > (the other reason to try this is to simulate what would happen if a drive did completely fail).
> >
> > so after swapping the drives and rebooting, i try to mount as degraded. i instantly get a kernel panic, http://www.hep.man.ac.uk/u/sam/pub/IMG_5397_crop.png
> >
> > so far all this has been with 3.5 kernel. so i upgraded to 3.6.2 and tried to mount degraded again.
> >
> > first with just sudo mount /dev/sdd2 /mnt, then with sudo mount -o degraded /dev/sdd2 /mnt
> >
> > [ 582.535689] device label bdata devid 1 transid 25342 /dev/sdd2
> > [ 582.536196] btrfs: disk space caching is enabled
> > [ 582.536602] btrfs: failed to read the system array on sdd2
> > [ 582.536860] btrfs: open_ctree failed
> > [ 606.784176] device label bdata devid 1 transid 25342 /dev/sdd2
> > [ 606.784647] btrfs: allowing degraded mounts
> > [ 606.784650] btrfs: disk space caching is enabled
> > [ 606.785131] btrfs: failed to read chunk root on sdd2
> > [ 606.785331] btrfs warning page private not zero on page 3222292922368
> > [ 606.785408] btrfs: open_ctree failed
> > [ 782.422959] device label bdata devid 1 transid 25342 /dev/sdd2
> >
> > no panic is good progress, but something is still not right.
> >
> > my options would seem to be
> > 1) reconnect old drive (probably in a USB caddy), see if it mounts as if nothing ever happened. or possibly try and recover it back to a working raid1. then try again with adding the new drive first, then removing the old one.
> > 2) give up experimenting and create a new btrfs raid1, and restore from backup
> >
> > both leave me with a worry about what would happen if a disk in a raid 1 did die. (unless is was the panic that did some damage that borked the filesystem.)
>
> Some more details.
>
> If i reconnect the failing drive then I can mount the filesystem with no errors, a quick glance suggests that the data is all there.
>
> Label: 'bdata' uuid: 1f07081c-316b-48be-af73-49e6f76535cc
> Total devices 2 FS bytes used 2.50TB
> devid 2 size 2.73TB used 2.73TB path /dev/sde1 <-- this is the drive that i wish to remove
> devid 1 size 2.73TB used 2.73TB path /dev/sdd2
>
> sudo btrfs filesystem df /mnt
> Data, RAID1: total=2.62TB, used=2.50TB
> System, DUP: total=40.00MB, used=396.00KB
> System: total=4.00MB, used=0.00
> Metadata, DUP: total=112.00GB, used=3.84GB
> Metadata: total=8.00MB, used=0.00
>
> is the failure to mount when i remove sde due to it being dup, rather than raid1?

Yes, I would say so.
Try a
btrfs balance start -mconvert=raid1 /mnt
so all metadata is on each drive.

>
> is adding a second drive to a btrfs filesystem and running
> btrfs fi balance start -dconvert=raid1 /mnt
> not sufficient to create an array that can survive the loss of a disk? do i need -mconvert as well? is there an -sconvert for system?
>
> thanks
>
> Sam
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at http://vger.kernel.org/majordomo-info.html 		 	   		  