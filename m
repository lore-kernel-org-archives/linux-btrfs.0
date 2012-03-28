From: "Niels de Carpentier" <niels@decarpentier.com>
Subject: Re: Fractal Tree Indexing over B-Trees?
Date: Wed, 28 Mar 2012 22:44:03 +0200
Message-ID: <c15ca7b1e51f4bbbd2b96bf2651b72ae.squirrel@webmail.decarpentier.com>
References: <loom.20120328T160525-464@post.gmane.org>
    <20120328184204.GB1941@localhost.localdomain>
    <20120328185720.GC1941@localhost.localdomain>
    <4F736B6F.2080805@zabbo.net>
    <20120328201306.GD1941@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Cc: "Zach Brown" <zab@zabbo.net>, "Josef Bacik" <josef@redhat.com>,
	"Danny Piccirillo" <danny.piccirillo@member.fsf.org>,
	linux-btrfs@vger.kernel.org
To: "Josef Bacik" <josef@redhat.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20120328201306.GD1941@localhost.localdomain>
List-ID: <linux-btrfs.vger.kernel.org>


>
> You are still going to have to have at least 29 levels to accomodate 1
> billion
> objects, though they won't all be full (sorry I missed the must be full or
> empty
> bit).  So it looks like we'll have to actually search what 13 rows right?
> So
> still more rows than a b-tree, and again you are talking about binary
> searching
> each row's blocks and then following its forward pointer down to the next
> one,
> so maybe not 100's of times slower than a b-tree, but we're not talking
> about a
> 5-10% difference either, probably still measured in multiples.

They say that they can do the block pointers in a way that limits the
number for searches per row to a constant, so it's not that bad. They do
less random seeks, but bigger ones at the cost of more cpu usage.
>
> Hah my math was a little off I'll grant you but the basic idea still
> stands,
> once we start getting into larger and larger rows we're going to have to
> binary
> search just to find the right _block_ to use, which in my mind is much
> more of a
> problem than having to binary search inside of multiple blocks.  At the
> very
> least as the number of objects grows the time it takes to find something
> in the
> tree increases exponentially.

That's not what they say. A lot of info is missing though.
>
>> There's a *ton* of detail that they don't describe about how to actually
>> translate the logical notion of power-of-two node sizes into coherent
>> block IO that scales.  I don't doubt that it's possible.
>
> I imagine there is, but based on what little information they've shown I
> don't
> see how it's a hands down win against b-trees.  If anything we're talking
> about
> having to solve really complex problems in order to get any sort of good
> performance out of this thing.  Thanks,

They don't claim to win hands down for the search case, they say they are
similar for the search case, but much better at inserts.

I don't think it's good for the linux fs general use case, but it's not as
bad as you think. But it will be very hard to implement anyway unless they
release more details.

Niels

