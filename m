From: Andi Kleen <andi@firstfloor.org>
Subject: Re: [RFC PATCH v2 0/3] Btrfs: apply the Probabilistic Skiplist on btrfs
Date: Fri, 13 Jan 2012 10:01:04 +0100
Message-ID: <20120113090104.GK11715@one.firstfloor.org>
References: <1326180696-3614-1-git-send-email-liubo2009@cn.fujitsu.com> <m21ur4sj9v.fsf@firstfloor.org> <4F0F945E.2040005@cn.fujitsu.com> <20120113041016.GG2806@dastard>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Liu Bo <liubo2009@cn.fujitsu.com>,
	Andi Kleen <andi@firstfloor.org>, linux-btrfs@vger.kernel.org,
	chris.mason@oracle.com, josef@redhat.com, dave@jikos.cz
To: Dave Chinner <david@fromorbit.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20120113041016.GG2806@dastard>
List-ID: <linux-btrfs.vger.kernel.org>


For the btrfs extent cache it's unclear if just RCUing is a good
fit anyways: some workloads are very write heavy and RCU only
performs well if you have a lot more reads than writes.
For write heavy RCUification usually slows it down.

> FWIW, I'm mentioning this out of self interest - I need a RCU safe
> tree structure to index extents for lookless lookups in the XFS
> buffer cache, but I've got a long list of things to do before I get
> to it. If someone else implements the tree, that's most of the work
> done for me. :)

FWIW there are fine grained rbtrees in papers too, but they are too fine 
grained imho: you may need to take a large number of locks for a single 
traversal. While atomics got a lot cheaper recently they are still
somewhat expensive and you don't want too many of them in your 
fast path. Also I found when there is actual contention having
too many bouncing locks is quite bad because the latencies of passing
the cache lines around really add up. In these cases uses less fine
locks is better.

Mathieu also did RCU rbtrees but they are quite complicated.

IMHO we would like to have something inbetween a global tree lock and a
fully fine grained tree where the lock complexity cannot get out of band.
May need a separate data structure for the locks.

I don't have a leading candidate for that currently.

There are some variants of rbtrees that are less strict and have
a simpler rebalance which are interesting. But also some
other tree data structures. Needs more work.

-Andi
-- 
ak@linux.intel.com -- Speaking for myself only.
