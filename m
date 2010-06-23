From: Jamie Lokier <jamie@shareable.org>
Subject: Re: Btrfs: broken file system design (was Unbound(?) internal fragmentation in Btrfs)
Date: Thu, 24 Jun 2010 00:57:26 +0100
Message-ID: <20100623235726.GG7058@shareable.org>
References: <4C07C321.8010000@redhat.com> <AANLkTilKw2onQkdNlZjg7WVnPu2dsNpDSvoxrO_FA2z_@mail.gmail.com> <4C1B7560.1000806@gmail.com> <20100618155653.GC10919@shareable.org> <4C1BC924.30604@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Edward Shishkin <edward.shishkin@gmail.com>,
	Mat <jackdachef@gmail.com>, LKML <linux-kernel@vger.kernel.org>,
	linux-fsdevel@vger.kernel.org,
	Chris Mason <chris.mason@oracle.com>,
	Ric Wheeler <rwheeler@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	The development of BTRFS <linux-btrfs@vger.kernel.org>
To: Edward Shishkin <edward@redhat.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <4C1BC924.30604@redhat.com>
List-ID: <linux-btrfs.vger.kernel.org>

Edward Shishkin wrote:
> I'll try to help, but I am rather pessimistic here: working out
> algorithms is something, which doesn't like timelines..

Nonsense.  Working out algorithms is just work to an algorithm
designer, just like programming is work to a programmer.  Sure, some
things are harder than others, and there's an element of creativity.
But lots of it is just cranking the handle, even in algorithm design.

> >Note that it's not necessarily a problem to have a few nodes with low
> >utilisation.  Deliberate violation of the classic balancing heuristic
> >is often useful for performance.[*]
> 
> Ok, let's violate this, but not in the detriment of utilisation:
> Internal fragmentation is a horror for file systems, the enemy #1
> (which is completely defeated in the last century BTW).
> 
> >  The problem you've found is only a
> >real problem when there are _too many_ nodes with low utilisation.
> 
> IMHO this is a problem, as we can not estimate number of such nodes.
> Do you have any sane upper boundary for this number? I don't know such one.
> Maybe I have missed something?

Well, I don't know if btrfs maintains enough statistics or other
implicit processes to guarantee a sane upper boundary for this.  The
impression I'm getting from the thread is that it relies on heuristic
behaviour which is usually sufficient (and perhaps a bit faster than
updating statistics on the disk would be), but that it does not
provide a hard upper boundary.  I'm really not sure, though.  I
haven't read the code.

> >[*] For example when filling a tree by inserting contiguously
> >ascending keys, the classic "split into two when full" heuristic gives
> >the worst possible results (50% lost space), and deliberately
> >underfilling the most actively updated nodes, which is not permitted
> >at all by the classic algorithm, gives denser packing in the end
> >(almost zero lost space).
> 
> At the end of what?

At the end of inserting keys in ascending order.  Just think about the
classic B-tree when that is done: Node[1] fills to 100% utilisation,
then is split into two nodes at 50% (call them node[1] and node[2]).
Node[2] fills to 100%, then splits into node[2] at 50% and node[3].
Etc etc: Result is a million nodes at 50% utilisation, except the last
one.

If instead you fill node[1], then *don't* split it but permit node[2]
to have 0% to start with, let that fill to 100%, then don't split
node[2] and let node[3] start with 0%, etc. etc: Result is half a
million nodes at 100% utilisation, except the last one.

Both fit the desired bounds, but the second is more desirable in
practice, especially as it's common behaviour to fill with contiguous,
ascending keys in a filesystem (or blob-filled database) where data
extents are part of the tree :-)

To handle the cases of multiple independent ascending runs of keys
being written in parallel, you generalise to maintain more than one
below-50% block, near the "active insertion heads".

The above describes classic B-trees where updates are assumed to be
written immediately.  Things are different when there's a memory cache
and delayed allocation/writing, and packing can be reorganised in
memory before sending to storage.

> I hope you don't speak about on-line defragmentation?

No, not at all.

> Can you point me to the paper (if any)?

Sorry, no, I haven't seen this described in a paper.  Imho it's
obvious when you think about it.  But maybe it's not obvious to
everyone - perhaps this is even the heuristic modification missing
from btrfs which it would need to avoid the scenario which started
this thread?

-- Jamie
