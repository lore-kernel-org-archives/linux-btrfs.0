Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:48054 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933282AbeEWPWm (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 23 May 2018 11:22:42 -0400
Date: Wed, 23 May 2018 08:22:39 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Kent Overstreet <kent.overstreet@gmail.com>
Cc: Christoph Hellwig <hch@infradead.org>,
        Matthew Wilcox <willy@infradead.org>, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Dave Chinner <dchinner@redhat.com>, darrick.wong@oracle.com,
        tytso@mit.edu, linux-btrfs@vger.kernel.org, clm@fb.com, jbacik@fb.com,
        viro@zeniv.linux.org.uk, peterz@infradead.org
Subject: Re: [PATCH 01/10] mm: pagecache add lock
Message-ID: <20180523152239.GA2425@infradead.org>
References: <20180518074918.13816-1-kent.overstreet@gmail.com>
 <20180518074918.13816-3-kent.overstreet@gmail.com>
 <20180518131305.GA6361@bombadil.infradead.org>
 <20180518155330.GA16931@infradead.org>
 <20180520224524.GC11495@kmo-pixel>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20180520224524.GC11495@kmo-pixel>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, May 20, 2018 at 06:45:24PM -0400, Kent Overstreet wrote:
> > 
> > Honestly I think this probably should be in the core.  But IFF we move
> > it to the core the existing users of per-fs locks need to be moved
> > over first.  E.g. XFS as the very first one, and at least ext4 and f2fs
> > that copied the approach, and probably more if you audit deep enough.
> 
> I'm not going to go and redo locking in XFS and ext4 as a prerequisite to
> merging bcachefs. Sorry, but that's a bit crazy.

It isn't crazy at all.  In general we expect people to do their fair
share of core work to get their pet feature in.  How much is acceptable
is a difficult question and not black and white.

But if you want to grow a critical core structure you better take a stab
at converting existing users.  Without that the tradeoff of growing
that core structure is simply not given.

Or to put it in words for this exact feature:  unless your new field
is also used by mainstream file systems it is not going to be added.
