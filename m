From: Josef Bacik <josef@redhat.com>
Subject: Re: Fractal Tree Indexing over B-Trees?
Date: Wed, 28 Mar 2012 16:13:06 -0400
Message-ID: <20120328201306.GD1941@localhost.localdomain>
References: <loom.20120328T160525-464@post.gmane.org>
 <20120328184204.GB1941@localhost.localdomain>
 <20120328185720.GC1941@localhost.localdomain>
 <4F736B6F.2080805@zabbo.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Josef Bacik <josef@redhat.com>,
	Danny Piccirillo <danny.piccirillo@member.fsf.org>,
	linux-btrfs@vger.kernel.org
To: Zach Brown <zab@zabbo.net>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4F736B6F.2080805@zabbo.net>
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Mar 28, 2012 at 03:50:07PM -0400, Zach Brown wrote:
> 
> >but lets say O(log N/2) where N is the number of elements in the row.
> >So in the situation I describe you are looking at having to do minimum
> >of 29 reads, one for each row,
> 
> Hmm.
> 
> Levels are powers of two and are either full or empty.  So the total
> item count tells you which levels are full or empty.
> 
> (gdb) print/t 1000000000
> $3 = 111011100110101100101000000000
> 
> So no, definitely not reading 29 levels.
>

You are still going to have to have at least 29 levels to accomodate 1 billion
objects, though they won't all be full (sorry I missed the must be full or empty
bit).  So it looks like we'll have to actually search what 13 rows right?  So
still more rows than a b-tree, and again you are talking about binary searching
each row's blocks and then following its forward pointer down to the next one,
so maybe not 100's of times slower than a b-tree, but we're not talking about a
5-10% difference either, probably still measured in multiples.

> After realizing this, I have to be honest: I'm not finding your
> hand-wavey dismissal of the technology convincing at all. :)
> 

Hah my math was a little off I'll grant you but the basic idea still stands,
once we start getting into larger and larger rows we're going to have to binary
search just to find the right _block_ to use, which in my mind is much more of a
problem than having to binary search inside of multiple blocks.  At the very
least as the number of objects grows the time it takes to find something in the
tree increases exponentially.

> There's a *ton* of detail that they don't describe about how to actually
> translate the logical notion of power-of-two node sizes into coherent
> block IO that scales.  I don't doubt that it's possible.

I imagine there is, but based on what little information they've shown I don't
see how it's a hands down win against b-trees.  If anything we're talking about
having to solve really complex problems in order to get any sort of good
performance out of this thing.  Thanks,

Josef
