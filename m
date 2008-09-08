From: Andi Kleen <andi@firstfloor.org>
Subject: Re: btrfs_tree_lock & trylock
Date: Mon, 8 Sep 2008 15:54:14 +0200
Message-ID: <20080908135414.GG26079@one.firstfloor.org>
References: <20080908111059.GA8902@basil.nowhere.org> <1220881666.8537.3.camel@think.oraclecorp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andi Kleen <andi@firstfloor.org>, linux-btrfs@vger.kernel.org
To: Chris Mason <chris.mason@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1220881666.8537.3.camel@think.oraclecorp.com>
List-ID: <linux-btrfs.vger.kernel.org>

> The idea is to try to spin for a bit to avoid scheduling away, which is
> especially important for the high levels.  Most holders of the mutex
> let it go very quickly.

Ok but that surely should be implemented in the general mutex code then
or at least in a standard adaptive mutex wrapper? 

-Andi
-- 
ak@linux.intel.com
