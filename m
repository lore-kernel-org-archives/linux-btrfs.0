Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from ipmail06.adl2.internode.on.net ([150.101.137.129]:28127 "EHLO
	ipmail06.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750942AbaB1EVi (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 27 Feb 2014 23:21:38 -0500
Date: Fri, 28 Feb 2014 15:21:32 +1100
From: Dave Chinner <david@fromorbit.com>
To: Chris Murphy <lists@colorremedies.com>
Cc: otakujunction@gmail.com, Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Subject: Re: Help with space
Message-ID: <20140228042132.GB13647@dastard>
References: <CAAmRLYx1L=o7a2PMSAiJbr7qH_JiuYG2-ncHG-mHLyLcM3Z-GQ@mail.gmail.com>
 <DCDC90E8-4834-416A-AC00-B11FC9A66281@colorremedies.com>
 <82E08C64-154E-460E-A052-E60BC00D662C@colorremedies.com>
 <B2988EF9-46EB-4804-A024-EE3B3A9E8771@gmail.com>
 <819E17EB-E4C2-4BD7-8D55-8C8DF9B8573B@colorremedies.com>
 <20140228001250.GA13647@dastard>
 <C6A844E6-3258-4405-9024-282D1EBD06CB@colorremedies.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <C6A844E6-3258-4405-9024-282D1EBD06CB@colorremedies.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Feb 27, 2014 at 05:27:48PM -0700, Chris Murphy wrote:
> 
> On Feb 27, 2014, at 5:12 PM, Dave Chinner <david@fromorbit.com>
> wrote:
> 
> > On Thu, Feb 27, 2014 at 02:11:19PM -0700, Chris Murphy wrote:
> >> 
> >> On Feb 27, 2014, at 1:49 PM, otakujunction@gmail.com wrote:
> >> 
> >>> Yes it's an ancient 32 bit machine.  There must be a complex
> >>> bug involved as the system, when originally mounted, claimed
> >>> the correct free space and only as used over time did the
> >>> discrepancy between used and free grow.  I'm afraid I chose
> >>> btrfs because it appeared capable of breaking the 16 tera
> >>> limit on a 32 bit system.  If this isn't the case then it's
> >>> incredible that I've been using this file system for about a
> >>> year without difficulty until now.
> >> 
> >> Yep, it's not a good bug. This happened some years ago on XFS
> >> too, where people would use the file system for a long time and
> >> then at 16TB+1byte written to the volume, kablewy! And then it
> >> wasn't usable at all, until put on a 64-bit kernel.
> >> 
> >> http://oss.sgi.com/pipermail/xfs/2014-February/034588.html
> > 
> > Well, no, that's not what I said.
> 
> What are you thinking I said you said? I wasn't quoting or
> paraphrasing anything you've said above. I had done a google
> search on this early and found some rather old threads where some
> people had this experience of making a large file system on a
> 32-bit kernel, and only after filling it beyond 16TB did they run
> into the problem. Here is one of them:
> 
> http://lists.centos.org/pipermail/centos/2011-April/109142.html

<sigh>

No, he didn't fill it with 16TB of data and then have it fail. He
made a new filesystem *larger* than 16TB and tried to mount it:

| On a CentOS 32-bit backup server with a 17TB LVM logical volume on
| EMC storage.  Worked great, until it rolled 16TB.  Then it quit
| working.  Altogether.  /var/log/messages told me that the
| filesystem was too large to be mounted. Had to re-image the VM as
| a 64-bit CentOS, and then re-attached the RDM's to the LUNs
| holding the PV's for the LV, and it mounted instantly, and we
| kept on trucking.

This just backs up what I told you originally - that XFS has always
refused to mount >16TB filesystems on 32 bit systems.

> > I said that it was limited on XFS, not that the limit was a
> > result of a user making a filesystem too large and then finding
> > out it didn't work. Indeed, you can't do that on XFS - mkfs will
> > refuse to run on a block device it can't access the last block
> > on, and the kernel has the same "can I access the last block of
> > the filesystem" sanity checks that are run at mount and growfs
> > time.
> 
> Nope. What I reported on the XFS list, I had used mkfs.xfs while
> running 32bit kernel on a 20TB virtual disk. It did not fail to
> make the file system, it failed only to mount it.

You said no such thing. All you said was you couldn't mount a
filesystem > 16TB - you made no mention of how you made the fs, what
the block device was or any other details.

> It was the same
> booted virtual machine, I created the file system and immediately
> mounted it. If you want the specifics, I'll post on the XFS list
> with versions and reproduce steps.

Did you check to see whether the block device silently wrapped at
16TB? There's a real good chance it did - but you might have got
lucky because mkfs.xfs uses direct IO and *maybe* that works
correctly on block devices on 32 bit systems. I wouldn't bet on it,
though, given it's something we don't support and therefore never
test....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
