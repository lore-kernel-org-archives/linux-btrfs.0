Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from dkim2.fusionio.com ([66.114.96.54]:39478 "EHLO
	dkim2.fusionio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966335Ab3HHUi6 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 8 Aug 2013 16:38:58 -0400
Received: from mx1.fusionio.com (unknown [10.101.1.160])
	by dkim2.fusionio.com (Postfix) with ESMTP id C96759A06C1
	for <linux-btrfs@vger.kernel.org>; Thu,  8 Aug 2013 14:38:57 -0600 (MDT)
Date: Thu, 8 Aug 2013 16:38:55 -0400
From: Josef Bacik <jbacik@fusionio.com>
To: John Williams <jwilliams4200@gmail.com>
CC: <linux-btrfs@vger.kernel.org>
Subject: Re: Why does btrfs benchmark so badly in this case?
Message-ID: <20130808203855.GI16712@localhost.localdomain>
References: <CAJBj3vcfSrWC3sxxxin93GYYPZY_z_MJnAHoMxB45MFqEXYXkA@mail.gmail.com>
 <20130808194015.GH16712@localhost.localdomain>
 <CAJBj3vfrHPDhM579JZDhUQgmyd2PnUtrgwYX0718tOrK8MzNCA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <CAJBj3vfrHPDhM579JZDhUQgmyd2PnUtrgwYX0718tOrK8MzNCA@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Aug 08, 2013 at 01:23:22PM -0700, John Williams wrote:
> On Thu, Aug 8, 2013 at 12:40 PM, Josef Bacik <jbacik@fusionio.com> wrote:
> > On Thu, Aug 08, 2013 at 09:13:04AM -0700, John Williams wrote:
> >> Phoronix periodically runs benchmarks on filesystems, and one thing I
> >> have noticed is that btrfs always does terribly on their fio "Intel
> >> IOMeter fileserver access pattern" benchmark:
> >>
> >> http://www.phoronix.com/scan.php?page=article&item=linux_310_10fs&num=2
> 
> > So the reason this workload sucks for btrfs is because we fall back on buffered
> > IO because fio does not do block size aligned writes for this workload.  If you
> > add
> >
> > ba=4k
> >
> > to the iometer fio file then we go the same speed as xfs and ext4.  Not a whole
> > lot we can do about this since unaligned writes means we have to read in pages
> > to cow the block properly, which is why we fall back to buffered.  Once we do
> > that we end up having a lot of page locking stuff that gets in the way and makes
> > us twice as slow.  Thanks,
> 
> Thanks for looking into it.
> 
> So I guess the reason that ZFS does well with that workload is that
> ZFS is using smaller blocks, maybe just 512B ?
> 

Yeah I'm not sure what ZFS does, but if you are writing over a block and the
size/offset isn't aligned then you'd see similar issues with ZFS since it would
have to read+modify+write.  It is likely that ZFS just is using a smaller
blocksize.

> I wonder how common these type of non-4K aligned workloads are.
> Apparently, people with such workloads should avoid btrfs, but maybe
> these types of workloads are very rare?

So most people who use AIO/O_DIRECT have really specific setups which generally
can adjust how they align stuff (databases for example this would be the db page
and those are usually large, like 16k-32k), or with virtual images which will
hopefully be doing things in block aligned io's, but this depends on the host
OS.  Like I said there isn't a whole lot we can do about this, you can do NOCOW
if you want to get around it without changing your application or you can change
the app to be blocksize aligned.  Thanks,

Josef
