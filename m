From: Andi Kleen <andi@firstfloor.org>
Subject: Re: btrfs_tree_lock & trylock
Date: Mon, 8 Sep 2008 16:20:52 +0200
Message-ID: <20080908142052.GK26079@one.firstfloor.org>
References: <20080908111059.GA8902@basil.nowhere.org> <1220881666.8537.3.camel@think.oraclecorp.com> <20080908135414.GG26079@one.firstfloor.org> <1220882551.8537.5.camel@think.oraclecorp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andi Kleen <andi@firstfloor.org>, linux-btrfs@vger.kernel.org
To: Chris Mason <chris.mason@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1220882551.8537.5.camel@think.oraclecorp.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Sep 08, 2008 at 10:02:30AM -0400, Chris Mason wrote:
> On Mon, 2008-09-08 at 15:54 +0200, Andi Kleen wrote:
> > > The idea is to try to spin for a bit to avoid scheduling away, which is
> > > especially important for the high levels.  Most holders of the mutex
> > > let it go very quickly.
> > 
> > Ok but that surely should be implemented in the general mutex code then
> > or at least in a standard adaptive mutex wrapper? 
> 
> That depends, am I the only one crazy enough to think its a good idea?

Adaptive mutexes are classic, a lot of other OS have it.

Gregory et.al. also saw big improvements in the RT kernel (they 
posted a patchkit a few times) 

But a lot of people don't like them for some reason. Anyways
hiding them in a fs is probably wrong.

-Andi
-- 
ak@linux.intel.com
