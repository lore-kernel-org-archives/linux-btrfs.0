From: jim owens <jowens@hp.com>
Subject: Re: btrfs_tree_lock & trylock
Date: Mon, 08 Sep 2008 12:13:06 -0400
Message-ID: <48C54F12.3040702@hp.com>
References: <20080908111059.GA8902@basil.nowhere.org>	 <1220881666.8537.3.camel@think.oraclecorp.com>	 <20080908135414.GG26079@one.firstfloor.org>	 <1220882551.8537.5.camel@think.oraclecorp.com>	 <20080908142052.GK26079@one.firstfloor.org>	 <20080908080751.3d29fd61@extreme>	 <20080908154714.GM26079@one.firstfloor.org>	 <20080908085054.21acbe77@extreme> <1220889313.8537.50.camel@think.oraclecorp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Cc: Stephen Hemminger <shemminger@vyatta.com>,
	Andi Kleen <andi@firstfloor.org>, linux-btrfs@vger.kernel.org
To: Chris Mason <chris.mason@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1220889313.8537.50.camel@think.oraclecorp.com>
List-ID: <linux-btrfs.vger.kernel.org>

Chris Mason wrote:
>> My guess is that the improvement happens mostly from the first couple of tries,
>> not from repeated spinning. And since it is a mutex, you could even do:
> 
> I started with lower spin counts, I really didn't want to spin at all
> but the current values came from trial and error.

Exactly the problem Steven is saying about adaptive locking.

Using benchmarks (or any test), on a small sample of systems
leads you to conclude "this design/tuning combination is better".

I've been burned repeatedly by that... ugly things happen
as you move away from your design testing center.

I'm not saying your code does not work, just that we need
a lot more proof with different configurations and loads
to see that is "at least no worse".

jim
