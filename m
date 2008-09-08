From: Chris Mason <chris.mason@oracle.com>
Subject: Re: btrfs_tree_lock & trylock
Date: Mon, 08 Sep 2008 10:02:30 -0400
Message-ID: <1220882551.8537.5.camel@think.oraclecorp.com>
References: <20080908111059.GA8902@basil.nowhere.org>
	 <1220881666.8537.3.camel@think.oraclecorp.com>
	 <20080908135414.GG26079@one.firstfloor.org>
Mime-Version: 1.0
Content-Type: text/plain
Cc: linux-btrfs@vger.kernel.org
To: Andi Kleen <andi@firstfloor.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20080908135414.GG26079@one.firstfloor.org>
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, 2008-09-08 at 15:54 +0200, Andi Kleen wrote:
> > The idea is to try to spin for a bit to avoid scheduling away, which is
> > especially important for the high levels.  Most holders of the mutex
> > let it go very quickly.
> 
> Ok but that surely should be implemented in the general mutex code then
> or at least in a standard adaptive mutex wrapper? 

That depends, am I the only one crazy enough to think its a good idea?

If it were in the general mutex code, that's probably a faster/smarter
way to spin.

-chris


