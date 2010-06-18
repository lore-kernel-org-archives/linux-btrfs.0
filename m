From: Jamie Lokier <jamie@shareable.org>
Subject: Re: Btrfs: broken file system design (was Unbound(?) internal fragmentation in Btrfs)
Date: Fri, 18 Jun 2010 16:56:53 +0100
Message-ID: <20100618155653.GC10919@shareable.org>
References: <4C07C321.8010000@redhat.com> <AANLkTilKw2onQkdNlZjg7WVnPu2dsNpDSvoxrO_FA2z_@mail.gmail.com> <4C1B7560.1000806@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Mat <jackdachef@gmail.com>, LKML <linux-kernel@vger.kernel.org>,
	linux-fsdevel@vger.kernel.org,
	Chris Mason <chris.mason@oracle.com>,
	Ric Wheeler <rwheeler@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	The development of BTRFS <linux-btrfs@vger.kernel.org>
To: Edward Shishkin <edward.shishkin@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <4C1B7560.1000806@gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

Edward Shishkin wrote:
> If you decide to base your file system on some algorithms then please
> use the original ones from proper academic papers. DO NOT modify the
> algorithms in solitude: this is very fragile thing! All such
> modifications must be reviewed by specialists in the theory of
> algorithms. Such review can be done in various scientific magazines of
> proper level.
> 
> Personally I don't see any way to improve the situation with Btrfs
> except full redesigning the last one. If you want to base your file
> system on the paper of Ohad Rodeh, then please, use *exactly* the
> Bayer's B-trees that he refers to. That said, make sure that all
> records you put to the tree has equal length and all non-root nodes of
> your tree are at least half filled.

First, thanks Edward for identifying a specific problem with the
current btrfs implementation.

I've studied modified B-trees quite a lot and know enough to be sure
that they are quite robust when you modify them in all sorts of ways.

Moreover, you are incorrect to say there's an intrinsic algorithmic
problem with variable-length records.  It is not true; if Knuth said
so, Knuth was mistaken.

This is easily shown by modelling variable-length records (key ->
string) as a range of fixed length records ([key,index] -> byte) and
apply the standard B-tree algorithms to that, which guarantees
algorithm properties such as space utilisation and time; then you can
substitute a "compressed" representation of contiguous index runs,
which amounts to nothing more than just storing the strings (split
where the algorithm says to do so) and endpoint indexes , and because
this compression does not expand (in any way that matters), classic
algorithmic properties are still guaranteed.

Variable-length keys are a different business.  Those are trickier,
but as far as I know, btrfs doesn't use them.

> As to current Btrfs code: *NOT ACK*!!! I don't think we need such
> "file systems".

Btrfs provides many useful features that other filesystems don't.  We
definitely need it, or something like it.  You have identified a bug.
It's not a corruption bug, but it's definitely a bug, and probably
affects performance as well as space utilisation.

It is not deep design bug; it is just a result of the packing and
balancing heuristics.

If you are still interested, please apply your knowledge of B-tree
algorithms to understanding why btrfs fails to balance the tree
sufficiently well, and then propose a fix.

Note that it's not necessarily a problem to have a few nodes with low
utilisation.  Deliberate violation of the classic balancing heuristic
is often useful for performance.[*]  The problem you've found is only a
real problem when there are _too many_ nodes with low utilisation.

[*] For example when filling a tree by inserting contiguously
ascending keys, the classic "split into two when full" heuristic gives
the worst possible results (50% lost space), and deliberately
underfilling the most actively updated nodes, which is not permitted
at all by the classic algorithm, gives denser packing in the end
(almost zero lost space).  It's also faster.  The trick is to make
sure there's just the right number of underfilled nodes...

-- Jamie
