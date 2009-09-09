From: Chris Mason <chris.mason@oracle.com>
Subject: Re: btrfs failing fsx-linux
Date: Wed, 9 Sep 2009 09:37:29 -0400
Message-ID: <20090909133729.GA3160@think>
References: <20090818172641.GC30325@wotan.suse.de>
 <20090909131349.GB4522@think>
 <20090909133435.GC6034@wotan.suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-btrfs@vger.kernel.org
To: Nick Piggin <npiggin@suse.de>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20090909133435.GC6034@wotan.suse.de>
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Sep 09, 2009 at 03:34:35PM +0200, Nick Piggin wrote:
> On Wed, Sep 09, 2009 at 09:13:49AM -0400, Chris Mason wrote:
> > On Tue, Aug 18, 2009 at 07:26:41PM +0200, Nick Piggin wrote:
> > > Hi Chris,
> > > 
> > > Don't know if this is a known issue, but I have btrfs (after my previous
> > > inode_tree fixup patch) failing fsx-linux in Linus's current git tree.
> > > 
> > > This makes it a bit hard for me to test my btrfs truncate conversion patch
> > > unfortunately, though it does seem pretty stable so I will probably just
> > > send it out anyway.
> > > 
> > > Anyway, just a head's up. Oh, the way I reproduce is to create btrfs
> > > on 1GB rd, run 4 instances of fsx-linux on different files in the root
> > > directory, and run `while true ; do sync ; echo 3 > /proc/sys/vm/drop_caches;
> > > done` at the same time.
> > 
> > Just an update, I think I've tracked this down.  Our fixup code for when
> > set_page_dirty was called without page_mkwrite wasn't catching every
> > case.  I'm hitting other problems because I'm testing on my new
> > performance code, but hopefully this will all be nailed down soon.
> 
> Which cases do set_page_dirty happen without page_mkwrite? For fsx-linux
> I hope there shouldn't be any...

I've been assuming its the zap_pte_range part, but now I have enough
code around it to make stack traces.

> but one issue with btrfs's page_mkwrite
> is that it still unlocks the page before page_mkwrite returns so if it
> is anything like other filesystems, the page might get written out
> between the page_mkwrite and the page fault's subsequent set_page_dirty.
> 
> So if that race is hitting, it might appear like set_page_dirty is
> being called without a page_mkwrite.

Good point, I'll make sure.

-chris

