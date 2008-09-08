From: Steve Long <slong@rathaus.eclipse.co.uk>
Subject: Re: btrfs_tree_lock & trylock
Date: Tue, 9 Sep 2008 00:26:34 +0100
Message-ID: <200809090026.34318.slong@rathaus.eclipse.co.uk>
References: <20080908111059.GA8902@basil.nowhere.org> <20080908080751.3d29fd61@extreme> <1220887714.8537.45.camel@think.oraclecorp.com>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1220887714.8537.45.camel@think.oraclecorp.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Monday 08 September 2008 16:28:34 Chris Mason wrote:
> > People seem to repeatedly come up with adaptive mutex based on intuitive
> > hunch, and never do much analysis before or afterwards.
>
> In my case, it very easy to measure.  Just watch the context switch rate
> on any metadata intensive workload.  The current code scores higher on
> benchmarks and uses less system time overall.
>
Given that it's system-dependent, perhaps making the 512 a #define'd value 
(defaulting to 512) while it's current, might be worth doing? That would 
allow users to test via different values passed to make, and so gather more 
data, or just use the setting they prefer, if they're bothered.

At least until the adaptive mutex API is worked out (which might well take the 
number of attempts to spin/relax as a parameter. I'd add a shouldYield [for 
before final acquisition] and keep the ifSleeping as implicit in another fn, 
based on what I've read, but thankfully that's not my problem.)
