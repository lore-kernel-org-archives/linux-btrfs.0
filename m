From: Chris Mason <chris.mason@oracle.com>
Subject: Re: btrfs_tree_lock & trylock
Date: Mon, 08 Sep 2008 11:28:34 -0400
Message-ID: <1220887714.8537.45.camel@think.oraclecorp.com>
References: <20080908111059.GA8902@basil.nowhere.org>
	 <1220881666.8537.3.camel@think.oraclecorp.com>
	 <20080908135414.GG26079@one.firstfloor.org>
	 <1220882551.8537.5.camel@think.oraclecorp.com>
	 <20080908142052.GK26079@one.firstfloor.org>
	 <20080908080751.3d29fd61@extreme>
Mime-Version: 1.0
Content-Type: text/plain
Cc: Andi Kleen <andi@firstfloor.org>, linux-btrfs@vger.kernel.org
To: Stephen Hemminger <shemminger@vyatta.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20080908080751.3d29fd61@extreme>
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, 2008-09-08 at 08:07 -0700, Stephen Hemminger wrote:
> On Mon, 8 Sep 2008 16:20:52 +0200
> Andi Kleen <andi@firstfloor.org> wrote:
> 
> > On Mon, Sep 08, 2008 at 10:02:30AM -0400, Chris Mason wrote:
> > > On Mon, 2008-09-08 at 15:54 +0200, Andi Kleen wrote:
> > > > > The idea is to try to spin for a bit to avoid scheduling away, which is
> > > > > especially important for the high levels.  Most holders of the mutex
> > > > > let it go very quickly.
> > > > 
> > > > Ok but that surely should be implemented in the general mutex code then
> > > > or at least in a standard adaptive mutex wrapper? 
> > > 
> > > That depends, am I the only one crazy enough to think its a good idea?
> > 
> > Adaptive mutexes are classic, a lot of other OS have it.
> 
> The problem is that they are a nuisance. It is impossible to choose
> the right trade off between spin an no-spin, also they optimize for
> a case that doesn't occur often enough to be justified.
> 
> People seem to repeatedly come up with adaptive mutex based on intuitive
> hunch, and never do much analysis before or afterwards.
> 

In my case, it very easy to measure.  Just watch the context switch rate
on any metadata intensive workload.  The current code scores higher on
benchmarks and uses less system time overall.

-chris


