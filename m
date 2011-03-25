From: Chris Mason <chris.mason@oracle.com>
Subject: Re: [RFC] Tree fragmentation and prefetching
Date: Fri, 25 Mar 2011 16:15:46 -0400
Message-ID: <1301084093-sup-5455@think>
References: <4D89F03A.9050306@gmx.net> <1300908672-sup-9552@think> <4D8CF7AB.4010102@gmx.net>
Content-Type: text/plain; charset=UTF-8
Cc: Linux Btrfs <linux-btrfs@vger.kernel.org>
To: Arne Jansen <sensille@gmx.net>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-reply-to: <4D8CF7AB.4010102@gmx.net>
List-ID: <linux-btrfs.vger.kernel.org>

Excerpts from Arne Jansen's message of 2011-03-25 16:14:35 -0400:
> On 23.03.2011 20:32, Chris Mason wrote:
> > Excerpts from Arne Jansen's message of 2011-03-23 09:06:02 -0400:
> >>
> >> For the implementation I'd need an interface which I haven't been able
> >> to find yet. Currently I can trigger the read of several pages / tree
> >> blocks and wait for the completion of each of them. What I'd need would
> >> be an interface that gives me a callback on each completion or a waiting
> >> function that wakes up on each completion with the information which
> >> pages just completed.
> >> One way to achieve this would be to add a hook, but I gladly take any
> >> implementation hints.
> >
> > We have the bio endio call backs for this, I think that's the only thing
> > you can use.
> >
> 
> ok, so I'll add a new extent state bit EXTENT_READAHEAD and test for it
> in btree_readpage_end_io_hook.

It's also common to use a chain of endio handlers.  If you're allocating
any state for the RA, you just save the original endio handler in your
new struct, and then use your own endio handler that does the readahead
smarts.

-chris
