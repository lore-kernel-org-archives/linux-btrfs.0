Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:51311 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757134AbcCaTs5 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 31 Mar 2016 15:48:57 -0400
Date: Thu, 31 Mar 2016 12:52:12 -0700
From: Liu Bo <bo.li.liu@oracle.com>
To: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Cc: "Darrick J. Wong" <darrick.wong@oracle.com>,
        Christoph Hellwig <hch@infradead.org>, xfs@oss.sgi.com,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        linux-btrfs <linux-btrfs@vger.kernel.org>, linux-api@vger.kernel.org
Subject: Re: fallocate mode flag for "unshare blocks"?
Message-ID: <20160331195212.GB1415@localhost.localdomain>
Reply-To: bo.li.liu@oracle.com
References: <20160302155007.GB7125@infradead.org>
 <20160330182755.GC2236@birch.djwong.org>
 <20160331003242.GA5813@localhost.localdomain>
 <56FD079F.3060606@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <56FD079F.3060606@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Mar 31, 2016 at 07:18:55AM -0400, Austin S. Hemmelgarn wrote:
> On 2016-03-30 20:32, Liu Bo wrote:
> >On Wed, Mar 30, 2016 at 11:27:55AM -0700, Darrick J. Wong wrote:
> >>Hi all,
> >>
> >>Christoph and I have been working on adding reflink and CoW support to
> >>XFS recently.  Since the purpose of (mode 0) fallocate is to make sure
> >>that future file writes cannot ENOSPC, I extended the XFS fallocate
> >>handler to unshare any shared blocks via the copy on write mechanism I
> >>built for it.  However, Christoph shared the following concerns with
> >>me about that interpretation:
> >>
> >>>I know that I suggested unsharing blocks on fallocate, but it turns out
> >>>this is causing problems.  Applications expect falloc to be a fast
> >>>metadata operation, and copying a potentially large number of blocks
> >>>is against that expextation.  This is especially bad for the NFS
> >>>server, which should not be blocked for a long time in a synchronous
> >>>operation.
> >>>
> >>>I think we'll have to remove the unshare and just fail the fallocate
> >>>for a reflinked region for now.  I still think it makes sense to expose
> >>>an unshare operation, and we probably should make that another
> >>>fallocate mode.
> >
> >I'm expecting fallocate to be fast, too.
> >
> >Well, btrfs fallocate doesn't allocate space if it's a shared one
> >because it thinks the space is already allocated.  So a later overwrite
> >over this shared extent may hit enospc errors.
> And this _really_ should get fixed, otherwise glibc will add a check for
> running posix_fallocate against BTRFS and force emulation, and people _will_
> complain about performance.

Even if glibc adds a check like that and emulates fallocate by writing
zero to real blocks, btrfs still does cow and requests to allocate space
for new writes, so it's not only performance, but also getting ENOSPC in
extremely case though.

Thanks,

-liubo
