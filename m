Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:30360 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753150AbcHXBEl (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 23 Aug 2016 21:04:41 -0400
Date: Tue, 23 Aug 2016 18:03:43 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
To: Jeff Mahoney <jeffm@jeffm.io>
Cc: Tomokhov Alexander <alexoundos@ya.ru>, linux-btrfs@vger.kernel.org,
        Dave Chinner <david@fromorbit.com>,
        Christoph Hellwig <hch@infradead.org>
Subject: Re: Will Btrfs have an official command to "uncow" existing files?
Message-ID: <20160824010343.GA12163@birch.djwong.org>
References: <126611471805976@web2j.yandex.ru>
 <57BB5D1B.8040305@suse.com>
 <20160822230613.GA8256@birch.djwong.org>
 <57BCEED4.8070703@jeffm.io>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <57BCEED4.8070703@jeffm.io>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Aug 23, 2016 at 08:48:20PM -0400, Jeff Mahoney wrote:
> On 8/22/16 7:06 PM, Darrick J. Wong wrote:
> > [add Dave and Christoph to cc]
> > 
> > On Mon, Aug 22, 2016 at 04:14:19PM -0400, Jeff Mahoney wrote:
> >> On 8/21/16 2:59 PM, Tomokhov Alexander wrote:
> >>> Btrfs wiki FAQ gives a link to example Python script: https://github.com/stsquad/scripts/blob/master/uncow.py
> >>>
> >>> But such a crucial and fundamental tool must exist in stock btrfs-progs. Filesystem with CoW technology at it's core must provide user sufficient control over CoW aspects. Running 3rd-party or manually written scripts for filesystem properties/metadata manipulation is not convenient, not safe and definitely not the way it must be done.
> >>>
> >>> Also is it possible (at least in theory) to "uncow" files being currently opened in-place? Without the trickery with creation & renaming of files or directories. So that running "chattr +C" on a file would be sufficient. If possible, is it going to be implemented?
> >>
> >> XFS is looking to do this via fallocate using a flag that all file
> >> systems can choose to honor.  Once that lands, it would make sense for
> >> btrfs to use it as well.  The idea is that when you pass the flag in, we
> >> examine the range and CoW anything that has a refcount != 1.
> > 
> > There /was/ a flag to do that -- FALLOC_FL_UNSHARE_RANGE.  However,
> > Christoph and Dave felt[1] that the fallocate call didn't need to have
> > an explicit 'unshare' mode because unsharing shared blocks is
> > necessary to guarantee that a subsequent write will not ENOSPC.  I
> > felt that was sufficient justification to withdraw the unshare mode
> > flag.  If you fallocate the entire length of a shared file on XFS, it
> > will turn off CoW for that file until you reflink/dedupe it again.
> 
> Is that a flag or just that it's reverting to "normal" XFS operation?

Inodes with shared extents have a 'reflink' flag to indicate that
somewhere in the data fork are (potentially) blocks that need CoW.
The 'fallocate the entire file' code turns off the flag after which
all writes revert to regular XFS overwrite behavior.

> We have a nocow flag for btrfs, but it's more like nocow* because it's
> still possible to create new references to the extents and those must be
> CoW'd later.  I think that's about all we can offer since the nocow flag
> set otherwise would imply that /every/ snapshot does a full copy of
> anything marked nocow and I don't think that's the expectation either.

Copy-everything is certainly not what it /does/. :)

> > At the time I wondered whether or not the btrfs developers (the list
> > was cc'd) would pipe up in support of the unshare flag, but nobody
> > did.  Consequently it remains nonexistent.  Christoph commented a few
> > months ago about unsharing fallocate over NFS atop XFS blocking for a
> > long time, though nobody asked for 'unshare' to be reinstated as a
> > separate fallocate mode, much less a 'don't unshare' flag for regular
> > fallocate mode.
> > 
> > (FWIW I'm ok with not having to fight for more VFS changes. :))
> 
> Agreed. :)
> 
> >> That code hasn't landed yet though.  The last time I saw it posted was
> >> June.  I don't speak with knowledge of the integration plan, but it
> >> might just be queued up for the next merge window now that the reverse
> >> mapping patches have landed in 4.8.
> > 
> > I am going to try to land XFS reflink in 4.9; I hope to have an eighth
> > patchset out for review at the end of the week.
> > 
> > So... if the btrfs folks really want an unshare flag I can trivially
> > re-add it to the VFS headers and re-enable it in the XFS
> > implementation <cough> but y'all better speak up now and hammer out an
> > acceptable definition.  I don't think XFS needs a new flag.
> 
> Thanks for the explanation, Darrick.  I'm not advocating for a flag.
> That was just the last state of the implementation as I remember it.  I
> missed the discussion turning to not needing it at all.
> 
> I suppose the only thing missing, and this applies to both XFS and a
> future btrfs implementation, is documentation for the user explaining
> that the guarantees fallocate makes about ENOSPC not failing are voided
> by operations that can re-share extents.

Indeed, updating the manpage for fallocate (and dedupe) is still on my list.

--D

> 
> -Jeff
> 
> -- 
> Jeff Mahoney
> SUSE Labs
> 
> 



