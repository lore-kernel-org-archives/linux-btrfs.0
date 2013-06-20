Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:49298 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757851Ab3FTOk0 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 20 Jun 2013 10:40:26 -0400
Date: Thu, 20 Jun 2013 22:40:15 +0800
From: Liu Bo <bo.li.liu@oracle.com>
To: Josef Bacik <jbacik@fusionio.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 4/4] Btrfs-progs: exhance btrfs-image to restore image
 onto multiple disks
Message-ID: <20130620144014.GA23986@localhost.localdomain>
Reply-To: bo.li.liu@oracle.com
References: <1371729930-22497-1-git-send-email-bo.li.liu@oracle.com>
 <1371729930-22497-5-git-send-email-bo.li.liu@oracle.com>
 <20130620122432.GA4288@localhost.localdomain>
 <20130620123919.GB4288@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20130620123919.GB4288@localhost.localdomain>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Jun 20, 2013 at 08:39:19AM -0400, Josef Bacik wrote:
> On Thu, Jun 20, 2013 at 08:24:32AM -0400, Josef Bacik wrote:
> > On Thu, Jun 20, 2013 at 08:05:30PM +0800, Liu Bo wrote:
> > > This adds a 'btrfs-image -m' option, which let us restore an image that
> > > is built from a btrfs of multiple disks onto several disks altogether.
> > > 
> > > This aims to address the following case,
> > > $ mkfs.btrfs -m raid0 sda sdb
> > > $ btrfs-image sda image.file
> > > $ btrfs-image -r image.file sdc
> > > ---------
> > > so we can only restore metadata onto sdc, and another thing is we can
> > > only mount sdc with degraded mode as we don't provide informations of
> > > another disk.  And, it's built as RAID0 and we have only one disk,
> > > so after mount sdc we'll get into readonly mode.
> > > 
> > 
> > Um that shouldn't be happening, the restore will mask out the RAID parts of the
> > chunk tree and it should work just fine.  Are you using the most recent version
> > of btrfs-image?  If this is happening it's a bug and we need to fix it, but I've
> > restored several file systems from users with raid0/10 file systems onto a
> > single disk and it's worked just fine.  Thanks,
> > 
> 
> Well apparently I've been hallucinating because it definitely doesn't work.  I'd
> rather fix the device tree so it only restores onto one disk, since the raid
> level shouldn't matter and it does in fact get masked out.  So the only thing
> left would be to fix the device tree so the only device it knows about is the
> device we're restoring to.  Thanks,

I just check the latest progs code, in
commit ef2a8889ef813ba77061f6a92f4954d047a78932
Btrfs-progs: make image restore with the original device offsets,
we suffer from an huge pain and take a great amount of efforts to map
logical offset to physical offset.

But with this patch, we'll build the same whole logical-physical mapping
on the disks we're restoring to with what it is on the disks that
generate the image file, so we can get rid of those pain causing by
mapping issues.

thanks,
liubo
