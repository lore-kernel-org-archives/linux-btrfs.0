Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:38100 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932620AbbD0Nn5 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 27 Apr 2015 09:43:57 -0400
Date: Mon, 27 Apr 2015 06:43:49 -0700
From: Christoph Hellwig <hch@infradead.org>
To: NeilBrown <neilb@suse.de>
Cc: David Howells <dhowells@redhat.com>, Chris Mason <clm@fb.com>,
        Al Viro <viro@ZenIV.linux.org.uk>, Josef Bacik <jbacik@fb.com>,
        David Sterba <dsterba@suse.cz>, Dave Chinner <david@fromorbit.com>,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 3/3] btrfs: set FS_SUPPORTS_SEEK_HOLE flag.
Message-ID: <20150427134349.GA11928@infradead.org>
References: <20150420193347.29378d69@notabene.brown>
 <20150420052752.26554.13596.stgit@notabene.brown>
 <20150420052558.26554.97143.stgit@notabene.brown>
 <30419.1429519662@warthog.procyon.org.uk>
 <31824.1429523209@warthog.procyon.org.uk>
 <20150420094855.GA21116@infradead.org>
 <20150427154133.65f58366@notabene.brown>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20150427154133.65f58366@notabene.brown>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Apr 27, 2015 at 03:41:33PM +1000, NeilBrown wrote:
> Are you sure about NFSv4.2?
> 
> I see that it *can* report holes, but is there any guarantee that if you
> create a new file and write only the 5th block, then READ_PLUS will reliably
> report that the first 4 block are holes??

FYI, I'm talking about SEEK here, not READ_PLUS but the issue is the
same.

> Because if it doesn't guarantee that, then NFSv4.2 doesn't fit the with the
> others where SEEK_HOLE reliable reports holes.
> On the other hand if NFSv4.2 *does* guarantee that then the current READ_PLUS
> server patches are broken because they just use vfs_llseek and assume that
> trust what it says.

There is no quality of implementation guarantee in NFS, just like there
isn't any in Linux.  It's very hard to have any hard guarantees without
leaking specific implementation details like a block size.

> It would be really nice if SEEK_{DATA,HOLE} either reported holes reliably or
> returned ENXIO, but I guess there was a goo reason not to do that.

It would hav been useful, but we went with the Solaris way of reporting
a giant hole.  Solaris at least has a pathconf value telling you if
real SEEK_{DATA,HOLE} are supported, but with Linus' hatred of that
syscall we only have a bad emulation in glibc that isn't of much help
here.
