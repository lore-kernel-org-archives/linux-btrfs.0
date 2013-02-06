Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:24932 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757170Ab3BFC1M (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 5 Feb 2013 21:27:12 -0500
Date: Wed, 6 Feb 2013 10:24:23 +0800
From: Liu Bo <bo.li.liu@oracle.com>
To: Moshe Melnikov <moshe@zadarastorage.com>
Cc: Josef Bacik <jbacik@fusionio.com>, linux-btrfs@vger.kernel.org
Subject: Re: btrfs wastes disk space after snapshot deletetion.
Message-ID: <20130206022422.GB2278@liubo.jp.oracle.com>
Reply-To: bo.li.liu@oracle.com
References: <997C7B3B2B234B0ABBD6CFA921215298@moshePC>
 <20130204155652.GB2275@localhost.localdomain>
 <B9CF5B4F4CCB49DDADED37C666FEB05A@moshePC>
 <20130205144119.GE2275@localhost.localdomain>
 <6CE8723DC6A74DD78EAFBA9073C06A95@moshePC>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <6CE8723DC6A74DD78EAFBA9073C06A95@moshePC>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Feb 05, 2013 at 05:27:45PM +0200, Moshe Melnikov wrote:
> 
> Is it possible in step 1) to create few smaller extents instead of 1
> gig data extent?

DIO or O_SYNC can help to create extents whose size is your 'bs=xxx',
but you know, this is not expected as fast as buffered write.

thanks,
liubo

> 
> Moshe
> 
> -----Original Message----- From: Josef Bacik
> Sent: Tuesday, February 05, 2013 4:41 PM
> To: Moshe
> Cc: Josef Bacik ; linux-btrfs@vger.kernel.org
> Subject: Re: btrfs wastes disk space after snapshot deletetion.
> 
> On Tue, Feb 05, 2013 at 02:09:02AM -0700, Moshe wrote:
> >Thanks for your reply Josef.
> >I want to experiment with extents size, to see how it influence size of
> >extent tree. Can you point me to code that I can change to limit size of
> >data extents?
> 
> 
> So it's not the size of the data extents, it's how we deal with
> references to
> them.  Let me map out what happens now
> 
> 1) we do a write and create a 1 gig data extent.
> 2) create a file extent item in the fs tree pointing to the extent
> 3) create an reference with a count of 1 for the entire extent
> 4) create a snapshot of the data extent
> 5) write 4k to the middle of the extent
> 6a) we cow down to the file extent item we need to split and add a
> ref to the
> original 1 gig extent because of the snapshot.
> 6b) split the file extent item in the fs tree into 3 extents.
> - one from 0 to the random offset
> - one from random offset to random offset + 4k
> - one from random offset + 4k to the end of the original extent
> this points to an offset within the original 1 gig extent
> 6c) in the split we increase the refcount of the original 1 gig extent by 1
> 7) add an extent reference for the 4k extent we wrote.
> 
> So at the end of this our original 1 gig extent has 3 references, 1 for the
> original snapshot with it's unmodified extent, 2 for the snapshot
> which includes
> a reference for each chunk of the split extent.  In order to free up
> this space
> you would either have to overwrite the entirety of the remaining
> chunks of the
> original extent in the snapshot and free up the extent in the original fs by
> some means.
> 
> So say you delete the file in the original file system, and then do
> something
> horrible like overwrite every other 4k block in the file you'd end up with
> around 1.5gig of data in use for logically 1 gig of actual space.
> The way to
> fix this is in 6c.
> 
> In file.c you have __btrfs_drop_extents which does this
> btrfs_inc_extent_ref on
> an extent it has to split on two sides.  Instead of doing this we
> would probably
> add another delayed extent operation for splitting the extent reference.  So
> instead of having file extents that span large areas and stick
> around forever,
> we just fix the extent references to account for the actual file extents, so
> when you drop a part you actually recover the space.  There is no
> code for this
> yet because this is kind of an overhaul of how things are done, and
> I'm still
> getting "if I do blah it panics the box" emails so I want to spend time
> stabilizing.  If this is something you want to tackle go for it, but
> be prepared
> to spend a few months on it.  Thanks,
> 
> Josef
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
