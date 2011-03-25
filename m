From: Chris Mason <chris.mason@oracle.com>
Subject: Re: [RFC] Tree fragmentation and prefetching
Date: Fri, 25 Mar 2011 17:01:26 -0400
Message-ID: <1301086851-sup-5796@think>
References: <4D89F03A.9050306@gmx.net> <1300908672-sup-9552@think> <4D8CF7AB.4010102@gmx.net> <1301084093-sup-5455@think> <4D8D00C4.9020005@gmx.net>
Content-Type: text/plain; charset=UTF-8
Cc: Linux Btrfs <linux-btrfs@vger.kernel.org>
To: Arne Jansen <sensille@gmx.net>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-reply-to: <4D8D00C4.9020005@gmx.net>
List-ID: <linux-btrfs.vger.kernel.org>

Excerpts from Arne Jansen's message of 2011-03-25 16:53:24 -0400:
> On 25.03.2011 21:15, Chris Mason wrote:
> > Excerpts from Arne Jansen's message of 2011-03-25 16:14:35 -0400:
> >> On 23.03.2011 20:32, Chris Mason wrote:
> >>> Excerpts from Arne Jansen's message of 2011-03-23 09:06:02 -0400:
> >>>>
> >>>> For the implementation I'd need an interface which I haven't been able
> >>>> to find yet. Currently I can trigger the read of several pages / tree
> >>>> blocks and wait for the completion of each of them. What I'd need would
> >>>> be an interface that gives me a callback on each completion or a waiting
> >>>> function that wakes up on each completion with the information which
> >>>> pages just completed.
> >>>> One way to achieve this would be to add a hook, but I gladly take any
> >>>> implementation hints.
> >>>
> >>> We have the bio endio call backs for this, I think that's the only thing
> >>> you can use.
> >>>
> >>
> >> ok, so I'll add a new extent state bit EXTENT_READAHEAD and test for it
> >> in btree_readpage_end_io_hook.
> >
> > It's also common to use a chain of endio handlers.  If you're allocating
> > any state for the RA, you just save the original endio handler in your
> > new struct, and then use your own endio handler that does the readahead
> > smarts.
> >
> 
> Do you mean replacing the bio end_io handler or the
> readpage_end_io_hook? As I want the pages to end up in the page cache,
> I'd like to use as much of the existing infrastructure as possible.
> To intercept the bio deep down in the chain would mean to duplicate
> some code on the way down and on the way up again.

The end_io handler, see how we chain them around for the crc helper
threads.

-chris

