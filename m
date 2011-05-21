From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 1/2] fs: add a DCACHE_NEED_LOOKUP flag for d_flags
Date: Sat, 21 May 2011 14:11:15 +1000
Message-ID: <20110521041114.GX32466@dastard>
References: <1305827929-18491-1-git-send-email-josef@redhat.com>
 <m2hb8pyw4b.fsf@firstfloor.org>
 <7B320C9C-0748-419B-9E40-7A15397E0064@dilger.ca>
 <20110520213112.GS12317@one.firstfloor.org>
 <4DD7079B.6070302@redhat.com>
 <20110521030050.GT12317@one.firstfloor.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Josef Bacik <josef@redhat.com>, Andreas Dilger <adilger@dilger.ca>,
	"linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
	"linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
	"viro@ZenIV.linux.org.uk" <viro@ZenIV.linux.org.uk>,
	"hch@lst.de" <hch@lst.de>,
	"aarcange@redhat.com" <aarcange@redhat.com>
To: Andi Kleen <andi@firstfloor.org>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <20110521030050.GT12317@one.firstfloor.org>
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, May 21, 2011 at 05:00:50AM +0200, Andi Kleen wrote:
> On Fri, May 20, 2011 at 08:30:19PM -0400, Josef Bacik wrote:
> > On 05/20/2011 05:31 PM, Andi Kleen wrote:
> > >> Putting them at the end of the cache LRU instead of the head would allow them to be dropped quickly under memory pressure. 
> > > 
> > > This still would fill up your memory for find /, potentially pushing
> > > out other stuff.
> > > 
> > > -Andi
> > 
> > So these things are just hashed on dput, so they don't have any
> > references to them and they are automatically put on the LRU list, so if
> > we get under memory pressure they will be easily discarded, especially
> > if nobody is actually stating them.  Thanks,
> 
> They are allocated. The allocation will push out other things too.
> There's no mechanism to only push dentries when allocating other dentries,
> or limit the total consumption from the dcache.

FWIW, I'm in the process of resurrecting my per-superblock VFS cache
shrinker patch which would make doing such limiting easier.  That
is, the fake dentries could be accounted and tracked on their own
per-sb LRU and when over a threshold (global and/or per-sb) the
per-sb shrinker could be called directly to free a number of fake
dentries. That way the sb generating them all would self-limit
without greatly affecting the working set of dentries on other
filesystems...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
