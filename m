From: Josef Bacik <josef@redhat.com>
Subject: Re: Fractal Tree Indexing over B-Trees?
Date: Wed, 28 Mar 2012 14:57:21 -0400
Message-ID: <20120328185720.GC1941@localhost.localdomain>
References: <loom.20120328T160525-464@post.gmane.org>
 <20120328184204.GB1941@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Danny Piccirillo <danny.piccirillo@member.fsf.org>,
	linux-btrfs@vger.kernel.org
To: Josef Bacik <josef@redhat.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20120328184204.GB1941@localhost.localdomain>
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Mar 28, 2012 at 02:42:04PM -0400, Josef Bacik wrote:
> On Wed, Mar 28, 2012 at 02:25:39PM +0000, Danny Piccirillo wrote:
> > The case has been made on Phoronix for F-Trees: They makes use hard
> > drive speeds, not (relatively slow) access times; beat SSD's; and scale 
> > perfectly across multiple cores with hundreds of millions of entries.
> > 
> > http://en.wikipedia.org/wiki/TokuDB#Fractal_tree_indexes
> > 
> > How TokuDB Fractal Tree Databases Work
> > 
> > Via: http://www.phoronix.com/scan.php?page=news_item&px=MTA3NjM
> > 
> > Time for someone to get started on ftrfs? Or can it be implemented 
> > in Btrfs? 
> > https://bugzilla.kernel.org/show_bug.cgi?id=43004
> > 
> 
> This is dumber shit than usual out of phoronix.  I did some just basic
> calculations for worst case scenarios, let's say we max out btrfs's 8 level
> limit, so we have 7 levels of nodes and then our leaves.  Lets just for
> simplicity sake say we can fit 1 billion objects into this kind of tree, and for
> each node/leaf we can only hold 10 objects.  (Keep in mind these are just random
> numbers I'm pulling out of my ass and may not work out right with such a large
> tree, just work with me here).
> 
> So worst case scenario doing a binary search for an object with 10 objects is 4
> comparisons, so with a full 8 level btree we're doing 4 comparisons per level,
> so 32 comparisons worst possible case to find our object.
> 
> Now let's consider a fractal tree with 1 billion objects.  So that would have a
> 29 row fractal tree (if I did my math right).  Now I have to make some
> assumptions about how you would implement a fractal tree here, but let's assume
> that every level tells you it's min and max value to make it easier to tell
> which level you need to search in.  So worst case you're object is in the 29th
> level, so you have to read 29 blocks in and check the min/max levels to figure
> out which row to search.  Let's be fair and say these are in memory, we're still
> doing 29 comparisons right out of the gate to find the right row.  Now we have
> the right row, but this is a file system and the rows are split up into blocks,
> so we not only have to binary search each block, but the blocks themselves to
> find the right block with our object.  And we can't do this directed either
> because we have no way of indexing the individual blocks, so worst case scenario
> we're having to read in 268435456 blocks to then do a normal binary search on
> _each_ block!  Now lets again say just to give fractal trees an added benefit
> that each block has it's own min/max setting, we only have to binary search the
> one that will have our actual data, but we're still talking about reading in
> 33554432 times the number of blocks as compared to a btree!!!!!!
> 

Ok looks like I wasn't being completely fair here, part of the presentation they
show talks about using forward pointers to point to where the element would be
in the next row.  So if we assume we're using forward pointers and every row has
a min/max indicator you can walk down each row and do a binary search to get as
close as possible to what you want and then follow the forward pointer down to
the next level.  The problem with this is that in the worst case you end up
having to binary search on each row, which makes the SMP case even crappier
because you have to make sure nothing changes while you are walking down the
rows and following the forward pointers.  The math here is a little trickier
since I can't easily picture what the worst case scenario would be per level,
but lets say O(log N/2) where N is the number of elements in the row.  So in the
situation I describe you are looking at having to do minimum of 29 reads, one
for each row, and then add into that all the reads you need to binary search
from your forward pointer on to the end of the row, which is going to increase
as you go down the tree.  So probably not millions times more work than b-trees,
but at least 10s if not 100s of times more work in the worst case.  Thanks,

Josef
