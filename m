Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qt0-f193.google.com ([209.85.216.193]:44929 "EHLO
        mail-qt0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751030AbeETWp2 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 20 May 2018 18:45:28 -0400
Date: Sun, 20 May 2018 18:45:24 -0400
From: Kent Overstreet <kent.overstreet@gmail.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: Matthew Wilcox <willy@infradead.org>, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Dave Chinner <dchinner@redhat.com>, darrick.wong@oracle.com,
        tytso@mit.edu, linux-btrfs@vger.kernel.org, clm@fb.com, jbacik@fb.com,
        viro@zeniv.linux.org.uk, peterz@infradead.org
Subject: Re: [PATCH 01/10] mm: pagecache add lock
Message-ID: <20180520224524.GC11495@kmo-pixel>
References: <20180518074918.13816-1-kent.overstreet@gmail.com>
 <20180518074918.13816-3-kent.overstreet@gmail.com>
 <20180518131305.GA6361@bombadil.infradead.org>
 <20180518155330.GA16931@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20180518155330.GA16931@infradead.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, May 18, 2018 at 08:53:30AM -0700, Christoph Hellwig wrote:
> On Fri, May 18, 2018 at 06:13:06AM -0700, Matthew Wilcox wrote:
> > > Historically, the only problematic case has been direct IO, and people
> > > have been willing to say "well, if you mix buffered and direct IO you
> > > get what you deserve", and that's probably not unreasonable. But now we
> > > have fallocate insert range and collapse range, and those are broken in
> > > ways I frankly don't want to think about if they can't ensure consistency
> > > with the page cache.
> > 
> > ext4 manages collapse-vs-pagefault with the ext4-specific i_mmap_sem.
> > You may get pushback on the grounds that this ought to be a
> > filesystem-specific lock rather than one embedded in the generic inode.
> 
> Honestly I think this probably should be in the core.  But IFF we move
> it to the core the existing users of per-fs locks need to be moved
> over first.  E.g. XFS as the very first one, and at least ext4 and f2fs
> that copied the approach, and probably more if you audit deep enough.

I'm not going to go and redo locking in XFS and ext4 as a prerequisite to
merging bcachefs. Sorry, but that's a bit crazy.

I am more than happy to work on the locking itself if we can agree on what
semantics we want out of it. We have two possible approaches, and we're going to
have to pick one first: the locking can be done at the top of the IO stack (like
ext4 and I'm guessing xfs), but then we're adding locking overhead to buffered
reads and writes that don't need it because they're only touching pages that are
already in cache.

Or we can go with my approach, pushing down the locking to only when we need to
add pages to the page cache. I think if we started out by merging my approach,
it would be pretty easy to have it make use of Mathew's fancy xarray based range
locking when that goes in, the semantics should be similar enough.

If people are ok with and willing to use my approach, I can polish it up - add
lockdep support and whatever else I can think of, and attempt to get rid of the
stupid recursive part.

But that's got to be decided first, where in the call stack the locking should
be done.
