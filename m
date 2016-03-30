Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:32503 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753026AbcC3S2Z (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 30 Mar 2016 14:28:25 -0400
Date: Wed, 30 Mar 2016 11:27:55 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs@oss.sgi.com, linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        linux-btrfs <linux-btrfs@vger.kernel.org>, linux-api@vger.kernel.org
Subject: fallocate mode flag for "unshare blocks"?
Message-ID: <20160330182755.GC2236@birch.djwong.org>
References: <20160302155007.GB7125@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20160302155007.GB7125@infradead.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi all,

Christoph and I have been working on adding reflink and CoW support to
XFS recently.  Since the purpose of (mode 0) fallocate is to make sure
that future file writes cannot ENOSPC, I extended the XFS fallocate
handler to unshare any shared blocks via the copy on write mechanism I
built for it.  However, Christoph shared the following concerns with
me about that interpretation:

> I know that I suggested unsharing blocks on fallocate, but it turns out
> this is causing problems.  Applications expect falloc to be a fast
> metadata operation, and copying a potentially large number of blocks
> is against that expextation.  This is especially bad for the NFS
> server, which should not be blocked for a long time in a synchronous
> operation.
> 
> I think we'll have to remove the unshare and just fail the fallocate
> for a reflinked region for now.  I still think it makes sense to expose
> an unshare operation, and we probably should make that another
> fallocate mode.

With that in mind, how do you all think we ought to resolve this?
Should we add a new fallocate mode flag that means "unshare the shared
blocks"?  Obviously, this unshare flag cannot be used in conjunction
with hole punching, zero range, insert range, or collapse range.  This
breaks the expectation that writing to a file after fallocate won't
ENOSPC.

Or is it ok that fallocate could block, potentially for a long time as
we stream cows through the page cache (or however unshare works
internally)?  Those same programs might not be expecting fallocate to
take a long time.

Can we do better than either solution?  It occurs to me that XFS does
unshare by reading the file data into the pagecache, marking the pages
dirty, and flushing the dirty pages; performance could be improved by
skipping the flush at the end.  We won't ENOSPC, because the XFS
delalloc system is careful enough to check that there are enough free
blocks to handle both the allocation and the metadata updates.  The
only gap in this scheme that I can see is if we fallocate, crash, and
upon restart the program then tries to write without retrying the
fallocate.  Can we trade some performance for the added requirement
that we must fallocate -> write -> fsync, and retry the trio if we
crash before the fsync returns?  I think that's already an implicit
requirement, so we might be ok here.

Opinions?  I rather like the last option, though I've only just
thought of it and have not had time to examine it thoroughly, and it's
specific to XFS. :)

--D
