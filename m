Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wm0-f52.google.com ([74.125.82.52]:33977 "EHLO
	mail-wm0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752057AbcGVQGa (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 22 Jul 2016 12:06:30 -0400
Received: by mail-wm0-f52.google.com with SMTP id q128so9309765wma.1
        for <linux-btrfs@vger.kernel.org>; Fri, 22 Jul 2016 09:06:30 -0700 (PDT)
Date: Fri, 22 Jul 2016 12:06:16 -0400
From: Sanidhya Solanki <lkml.page@gmail.com>
To: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs-progs: Make RAID stripesize configurable
Message-ID: <20160722120616.35f5ad2d@ad>
In-Reply-To: <f7de852d-86de-b438-e79f-c57666c7d0e4@gmail.com>
References: <1469194929-27647-1-git-send-email-lkml.page@gmail.com>
	<f7de852d-86de-b438-e79f-c57666c7d0e4@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, 22 Jul 2016 10:58:59 -0400
"Austin S. Hemmelgarn" <ahferroin7@gmail.com> wrote:

> On 2016-07-22 09:42, Sanidhya Solanki wrote:
> > +*stripesize=<number>*;;
> > +Specifies the new stripe size for a filesystem instance. Multiple BTrFS
> > +filesystems mounted in parallel with varying stripe size are supported, the only
> > +limitation being that the stripe size provided to balance in this option must
> > +be a multiple of 512 bytes, and greater than 512 bytes, but not larger than
> > +16 KiBytes. These limitations exist in the user's best interest. due to sizes too
> > +large or too small leading to performance degradations on modern devices.
> > +
> > +It is recommended that the user try various sizes to find one that best suit the
> > +performance requirements of the system. This option renders the RAID instance as
> > +in-compatible with previous kernel versions, due to the basis for this operation
> > +being implemented through FS metadata.
> > +  
> I'm actually somewhat curious to see numbers for sizes larger than 16k. 
> In most cases, that probably will be either higher or lower than the 
> point at which performance starts suffering.  On an set of fast SSD's, 
> that's almost certainly lower than the turnover point (I can't give an 
> opinion on BTRFS, but for DM-RAID, the point at which performance starts 
> degrading significantly is actually 64k on the SSD's I use), while on a 
> set of traditional hard drives, it may be as low as 4k (yes, I have 
> actually seen systems where this is the case).  I think that we should 
> warn about sizes larger than 16k, not refuse to use them, especially 
> because the point of optimal performance will shift when we get proper 
> I/O parallelization.  Or, better yet, warn about changing this at all, 
> and assume that if the user continues they know what they're doing.

I agree with you from a limited point of view. Your considerations are
relevant for a more broad, but general, set of circumstances. 

My consideration is worst case scenario, particularly on SSDs, where,
say, you pick 8KiB or 16 KiB, write out all your data, then delete a
block, which will have to be read-erase-written on a multi-page level,
usually 4KiB in size.

On HDDs, this will make the problem of fragmenting even worse. On HDDs,
I would only recommend setting stripe block size to the block level
(usually 4KiB native, 512B emulated), but this just me focusing on the
worst case scenario.

Maybe I will add these warnings in a follow-on patch, if others agree
with these statements and concerns.

Thanks
Sanidhya
