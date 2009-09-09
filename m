From: Nick Piggin <npiggin@suse.de>
Subject: Re: btrfs failing fsx-linux
Date: Wed, 9 Sep 2009 15:43:51 +0200
Message-ID: <20090909134351.GD6034@wotan.suse.de>
References: <20090818172641.GC30325@wotan.suse.de> <20090909131349.GB4522@think> <20090909133435.GC6034@wotan.suse.de> <20090909133729.GA3160@think>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: Chris Mason <chris.mason@oracle.com>, linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20090909133729.GA3160@think>
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Sep 09, 2009 at 09:37:29AM -0400, Chris Mason wrote:
> On Wed, Sep 09, 2009 at 03:34:35PM +0200, Nick Piggin wrote:
> > Which cases do set_page_dirty happen without page_mkwrite? For fsx-linux
> > I hope there shouldn't be any...
> 
> I've been assuming its the zap_pte_range part, but now I have enough
> code around it to make stack traces.

OK, because AFAIK we're _supposed_ to be able to close all that
up since the last round of page_mkwrite fixes here, so pte state
will not be out of state with page state.

Yes set_page_dirty still gets called there, for fses without
page_mkwrite or which don't try hard to keep in sync. But if you
return with the page locked from page_mkwrite, this set_page_diryt
call should always find the page dirty (I hope).


> > but one issue with btrfs's page_mkwrite
> > is that it still unlocks the page before page_mkwrite returns so if it
> > is anything like other filesystems, the page might get written out
> > between the page_mkwrite and the page fault's subsequent set_page_dirty.
> > 
> > So if that race is hitting, it might appear like set_page_dirty is
> > being called without a page_mkwrite.
> 
> Good point, I'll make sure.

Though if it has exposed a bug, that's a good thing too; you still
want to handle that case (for now) due to the get_uesr_pages problem.

