From: Chris Mason <chris.mason@oracle.com>
Subject: Re: Error handling: How to "lose" a transaction
Date: Fri, 23 Dec 2011 09:17:31 -0500
Message-ID: <20111223141731.GS19266@shiny>
References: <4EE7C7F2.2080905@suse.com>
 <20111214001319.GX31158@shiny>
 <4EF29D0C.90709@suse.de>
 <4EF2A24D.7040501@cn.fujitsu.com>
 <4EF2A641.7070308@suse.de>
 <4EF40DBF.4070505@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Liu Bo <liubo2009@cn.fujitsu.com>, Jeff Mahoney <jeffm@suse.com>,
	Mark Fasheh <mfasheh@suse.de>,
	Btrfs Development List <linux-btrfs@vger.kernel.org>
To: Jeff Mahoney <jeffm@suse.de>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4EF40DBF.4070505@suse.de>
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Dec 23, 2011 at 12:12:31AM -0500, Jeff Mahoney wrote:
> -----BEGIN PGP SIGNED MESSAGE-----
> Hash: SHA1
> 
> On 12/21/2011 10:38 PM, Jeff Mahoney wrote:
> > On 12/21/2011 10:21 PM, Liu Bo wrote:
> >> On 12/22/2011 10:59 AM, Jeff Mahoney wrote: Sorry I haven't 
> >> responded to this yet. I started digging right in and I've
> >> started to have some good results. It turns out there's already a
> >>  btrfs_cleanup_transaction call that will tear down outstanding 
> >> transactions. It's not perfect and I've fixed a few bugs in
> >> there, but it saved me a bunch of effort. I just wished I noticed
> >> it a day before since I had it half implemented myself. :)
> > 
> > 
> >>> Hi Jeff,
> > 
> >>> Yes, it should be, and I wrote this cleanup_transaction where
> >>> I should notice you earlier... Anyway, thanks for your effort.
> > 
> >>> The error handling part has lots of corner cases, so I just
> >>> pick up a brute way to tear down the current transaction in
> >>> order to make the FS RO.
> > 
> > Oh, and it's worked great. The brute force method is a good start
> > and will address the most severe problems (and most cases) well.
> > I've decided to ignore most cases of -ENOMEM for now. The biggest
> > bug I ran into so far was calling mutex_lock while holding a
> > spinlock. It was a quick fix.
> > 
> > The method I've generally used is to mark the transaction aborted
> > and pass the error up as quickly as possible, cleaning up the
> > local allocations and locks as I go. The transaction gets
> > completed normally, returns an error, isn't committed, and then is
> > destroyed (with others, potentially) when called from in 
> > btrfs_commit_transaction. Btrfs makes this super easy since we can 
> > just skip all the CoW writes.
> 
> 
> Now, just out of curiosity, would it be ok if I printed this when we
> ran out memory in deep call paths?
> 
>      FAIL WHALE!
> 
> W     W      W
> W        W  W     W
>               '.  W
>   .-""-._     \ \.--|
>  /       "-..__) .-'
> |     _         /
> \'-.__,   .__.,'
>  `'----'._\--'
> VVVVVVVVVVVVVVVVVVVVV
> 
> 
> Happy Holidays ;)

I'll take any patch you put into the suse kernel ;)

-chris

