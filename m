Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from ipmail06.adl6.internode.on.net ([150.101.137.145]:63770 "EHLO
        ipmail06.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1753214AbcHWFyV (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 23 Aug 2016 01:54:21 -0400
Date: Tue, 23 Aug 2016 15:54:16 +1000
From: Dave Chinner <david@fromorbit.com>
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: Jeff Mahoney <jeffm@suse.com>, Tomokhov Alexander <alexoundos@ya.ru>,
        linux-btrfs@vger.kernel.org, Christoph Hellwig <hch@infradead.org>
Subject: Re: Will Btrfs have an official command to "uncow" existing files?
Message-ID: <20160823055416.GL22388@dastard>
References: <126611471805976@web2j.yandex.ru>
 <57BB5D1B.8040305@suse.com>
 <20160822230613.GA8256@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20160822230613.GA8256@birch.djwong.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Aug 22, 2016 at 04:06:13PM -0700, Darrick J. Wong wrote:
> [add Dave and Christoph to cc]
> 
> On Mon, Aug 22, 2016 at 04:14:19PM -0400, Jeff Mahoney wrote:
> > On 8/21/16 2:59 PM, Tomokhov Alexander wrote:
> > > Btrfs wiki FAQ gives a link to example Python script: https://github.com/stsquad/scripts/blob/master/uncow.py
> > > 
> > > But such a crucial and fundamental tool must exist in stock btrfs-progs. Filesystem with CoW technology at it's core must provide user sufficient control over CoW aspects. Running 3rd-party or manually written scripts for filesystem properties/metadata manipulation is not convenient, not safe and definitely not the way it must be done.
> > > 
> > > Also is it possible (at least in theory) to "uncow" files being currently opened in-place? Without the trickery with creation & renaming of files or directories. So that running "chattr +C" on a file would be sufficient. If possible, is it going to be implemented?
> > 
> > XFS is looking to do this via fallocate using a flag that all file
> > systems can choose to honor.  Once that lands, it would make sense for
> > btrfs to use it as well.  The idea is that when you pass the flag in, we
> > examine the range and CoW anything that has a refcount != 1.
> 
> There /was/ a flag to do that -- FALLOC_FL_UNSHARE_RANGE.  However,
> Christoph and Dave felt[1] that the fallocate call didn't need to have
> an explicit 'unshare' mode because unsharing shared blocks is
> necessary to guarantee that a subsequent write will not ENOSPC.  I
> felt that was sufficient justification to withdraw the unshare mode
> flag.  If you fallocate the entire length of a shared file on XFS, it
> will turn off CoW for that file until you reflink/dedupe it again.

>From the XFS POV that's all good...

> At the time I wondered whether or not the btrfs developers (the list
> was cc'd) would pipe up in support of the unshare flag, but nobody
> did.  Consequently it remains nonexistent.  Christoph commented a few
> months ago about unsharing fallocate over NFS atop XFS blocking for a
> long time, though nobody asked for 'unshare' to be reinstated as a
> separate fallocate mode, much less a 'don't unshare' flag for regular
> fallocate mode.

If there are other use cases, then we can easily implement it in
XFS. However, let's not overload the XFS reflink code with things
other fs devs have once said "that'd be nice to do"....

> (FWIW I'm ok with not having to fight for more VFS changes. :))
> 
> > That code hasn't landed yet though.  The last time I saw it posted was
> > June.  I don't speak with knowledge of the integration plan, but it
> > might just be queued up for the next merge window now that the reverse
> > mapping patches have landed in 4.8.
> 
> I am going to try to land XFS reflink in 4.9; I hope to have an eighth
> patchset out for review at the end of the week.
> 
> So... if the btrfs folks really want an unshare flag I can trivially
> re-add it to the VFS headers and re-enable it in the XFS
> implementation <cough> but y'all better speak up now and hammer out an
> acceptable definition.  I don't think XFS needs a new flag.

It's not urgent - it can be added at any time so I'd say it
something we should ignore on the XFS side of things until someone
actually requires an explicit "unshare" operation for another
filesystem....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
