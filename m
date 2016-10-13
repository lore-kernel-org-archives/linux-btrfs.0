Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from tartarus.angband.pl ([89.206.35.136]:39031 "EHLO
        tartarus.angband.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755218AbcJMEiM (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 13 Oct 2016 00:38:12 -0400
Date: Thu, 13 Oct 2016 05:40:11 +0200
From: Adam Borowski <kilobyte@angband.pl>
To: Zygo Blaxell <ce3g8jdj@umail.furryterror.org>
Cc: Qu Wenruo <quwenruo@cn.fujitsu.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: RAID system with adaption to changed number of disks
Message-ID: <20161013034011.GB17385@angband.pl>
References: <D379E551-1272-4548-9601-0CE4C1A8C012@unige.ch>
 <20161011160601.GI7683@carfax.org.uk>
 <CAJCQCtSY2Y5AsW2FC5FGP3x3Vaz6Y10=EbAE-0FKFQAqg0oGkg@mail.gmail.com>
 <3da9a459-c63b-570c-5b42-c7186b3a74fd@cn.fujitsu.com>
 <20161012043718.GW21290@hungrycats.org>
 <37578baa-556b-d3f7-45bd-10843124dea1@cn.fujitsu.com>
 <20161012171936.GD26140@hungrycats.org>
 <20161012195528.GB4800@angband.pl>
 <20161012211017.GJ26140@hungrycats.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20161012211017.GJ26140@hungrycats.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Oct 12, 2016 at 05:10:18PM -0400, Zygo Blaxell wrote:
> On Wed, Oct 12, 2016 at 09:55:28PM +0200, Adam Borowski wrote:
> > On Wed, Oct 12, 2016 at 01:19:37PM -0400, Zygo Blaxell wrote:
> > > I had been thinking that we could inject "plug" extents to fill up
> > > RAID5 stripes.
> > Your idea sounds good, but there's one problem: most real users don't
> > balance.  Ever.  Contrary to the tribal wisdom here, this actually works
> > fine, unless you had a pathologic load skewed to either data or metadata on
> > the first write then fill the disk to near-capacity with a load skewed the
> > other way.
> 
> > Most usage patterns produce a mix of transient and persistent data (and at
> > write time you don't know which file is which), meaning that with time every
> > stripe will contain a smidge of cold data plus a fill of plug extents.
> 
> Yes, it'll certainly reduce storage efficiency.  I think all the
> RMW-avoidance strategies have this problem.  The alternative is to risk
> losing data or the entire filesystem on disk failure, so any of the
> RMW-avoidance strategies are probably a worthwhile tradeoff.  Big RAID5/6
> arrays tend to be used mostly for storing large sequentially-accessed
> files which are less susceptible to this kind of problem.
> 
> If the pattern is lots of small random writes then performance on raid5
> will be terrible anyway (though it may even be improved by using plug
> extents, since RMW stripe updates would be replaced with pure CoW).

I've looked at some simple scenarios, and it appears that, with your scheme,
the total amount of I/O would increase, but it would not hinder performance
as increases happen only when the disk would be otherwise idle.  There's
also a latency win and a fragmentation win -- all while fixing the write
hole!

Let's assume leaf size 16KB, stripe size 64KB.  The disk has four stripes,
each 75% full 25% deleted.  '*' marks cold data, '.' deleted/plug space, 'x'
new data.  I'm not drawing entirely empty stripes.
***.
***.
***.
***.
The user wants to write 64KB of data.
RMW needs to read 12 leafs, write 16, no matter if the data comes in one
commit or four.
***x
***x
***x
***x
Latency 28 (big commit)/7 per commit (small commits), total I/O 28.

The plug extents scheme requires compaction (partial balance):
****
****
****
I/O so far 24.
Big commit:
****
****
****
xxxx
Latency 4, total I/O 28.
If we had to compact on-demand, the latency is 28 (assuming we can do
stripe-sized balance).

Small commits, no concurrent writes:
****
****
****
x...
x...
x...
x...
Latency 1 per commit, I/O so far 28, need another compaction:
****
****
****
xxxx
Total I/O 32.

Small io, concurrent writes that peg the disk:
****
****
****
xyyy
xyyy
xyyy
xyyy
Total I/O 28 (not counting concurrent writes).


Other scenarios I've analyzed give similar results.

I'm not sure if my thinking is correct, but if it is, the outcome is quite
surprising: no performance loss even though we had to rewrite the stripes!

> > Thus, while the plug extents idea doesn't suffer from problems of big
> > sectors you just mentioned, we'd need some kind of auto-balance.
> 
> Another way to approach the problem is to relocate the blocks in
> partially filled RMW stripes so they can be effectively CoW stripes;
> however, the requirement to do full extent relocations leads to some
> nasty write amplification and performance ramifications.  Balance is
> hugely heavy I/O load and there are good reasons not to incur it at
> unexpected times.

We don't need balance in btrfs sense, it's enough to compact stripes -- ie,
something akin to balance except done at stripe level rather than allocation
block level.

As for write amplification, F2FS guys solved the issue by having two types
of cleaning (balancing):
* on demand (when there is no free space and thus it needs to be done NOW)
* in the background (done only on cold data)

The on-demand clean goes for juiciest targets first (least data/stripe),
background clean on the other hand uses a formula that takes into account
both the amount of space to reclaim and age of the stripe.  If the data is
hot, it shouldn't be cleaned yet -- it's likely to be deleted/modified soon.


Meow!
-- 
A MAP07 (Dead Simple) raspberry tincture recipe: 0.5l 95% alcohol, 1kg
raspberries, 0.4kg sugar; put into a big jar for 1 month.  Filter out and
throw away the fruits (can dump them into a cake, etc), let the drink age
at least 3-6 months.
