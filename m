From: Josef Bacik <josef@redhat.com>
Subject: Re: [PATCH] Btrfs: force delalloc flushing when things get
	desperate
Date: Tue, 30 Mar 2010 22:07:26 -0400
Message-ID: <20100331020726.GD2352@localhost.localdomain>
References: <20100312212309.GC2332@localhost.localdomain> <20100331012554.GU13190@think>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: Chris Mason <chris.mason@oracle.com>,
	Josef Bacik <josef@redhat.com>, linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20100331012554.GU13190@think>
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Mar 30, 2010 at 09:25:54PM -0400, Chris Mason wrote:
> On Fri, Mar 12, 2010 at 04:23:09PM -0500, Josef Bacik wrote:
> > When testing with max_extents=4k, we enospc out really really early.  The reason
> > for this is we really overwhelm the system with our worst case calculation.
> > When we try to flush delalloc, we don't want everybody to wait around forever,
> > so we wake up the waiters when we've done some of the work in hopes that its
> > enough work to get everything they need done.  The problem with this is we don't
> > wait long enough sometimes.  So if we've already done a flush_delalloc and
> > didn't find what we need, do it again and this time wait for the flushing to be
> > completely finished before returning.  This makes my ENOSPC test actually
> > finish, instead of finishing in about 20 seconds.  Thanks,
> 
> Thanks Josef, was this one against the per-cpu work?  It doesn't apply
> cleanly but is simple enough that I can just bang it in there ;)
> 

Yeah I think it was, I can redo it if you like.  It's not as big of a deal
without max_extent, but it could still be usefull for some corner cases.
Thanks,

Josef
