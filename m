From: Chris Mason <chris.mason@oracle.com>
Subject: Re: Balancing leaves when walking from top to down (was Btrfs:...)
Date: Thu, 24 Jun 2010 09:06:01 -0400
Message-ID: <20100624130601.GW23009@think>
References: <20100618155653.GC10919@shareable.org>
 <4C1BC924.30604@redhat.com>
 <20100618193555.GV27466@think>
 <4C1BED56.9010300@redhat.com>
 <20100621131528.GA17979@think>
 <20100621180013.GD17979@think>
 <4C20C4E9.60203@redhat.com>
 <20100622142006.GT23009@think>
 <4C221049.501@gmail.com>
 <20100623233759.GE7058@shareable.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Edward Shishkin <edward.shishkin@gmail.com>,
	Edward Shishkin <edward@redhat.com>,
	Mat <jackdachef@gmail.com>, LKML <linux-kernel@vger.kernel.org>,
	linux-fsdevel@vger.kernel.org, Ric Wheeler <rwheeler@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	The development of BTRFS <linux-btrfs@vger.kernel.org>
To: Jamie Lokier <jamie@shareable.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20100623233759.GE7058@shareable.org>
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Jun 24, 2010 at 12:37:59AM +0100, Jamie Lokier wrote:
> Edward Shishkin wrote:
> > Chris Mason wrote:
> > >On Tue, Jun 22, 2010 at 04:12:57PM +0200, Edward Shishkin wrote:
> > >  
> > >>Chris Mason wrote:
> > >>    
> > >>>On Mon, Jun 21, 2010 at 09:15:28AM -0400, Chris Mason wrote:
> > >>>      
> > >>>>I'll reproduce from your test case and provide a fix.  mount -o
> > >>>>max_inline=1500 would give us 50% usage in the worst case
> > >>>>        
> > >>This is a very strange statement: how did you calculate this lower bound?
> > >>    
> > >
> > >We want room for the extent and the inode item and the inode backref.
> > >It's a rough number that leaves some extra room.  But even with a 2K
> > >item we're getting very close to 50% usage of the metadata area.
> > >
> > >  
> > >>>>(minus the
> > >>>>balancing bug you hit).
> > >>>>        
> > >>>Ok, the balancing bug was interesting.  What happens is we create all
> > >>>the inodes and directory items nicely packed into the leaves.
> > >>>
> > >>>Then delayed allocation kicks in and starts inserting the big fat inline
> > >>>extents.  This often forces the balancing code to split a leaf twice in
> > >>>order to make room for the new inline extent.  The double split code
> > >>>wasn't balancing the bits that were left over on either side of our
> > >>>desired slot.
> > >>>
> > >>>The patch below fixes the problem for me, reducing the number of leaves
> > >>>that have more than 2K of free space down from 6% of the total to about
> > >>>74 leaves.  It could be zero, but the balancing code doesn't push
> > >>>items around if our leaf is in the first or last slot of the parent
> > >>>node (complexity vs benefit tradeoff).
> > >>>      
> > >>Nevertheless, I see leaves, which are not in the first or last slot,
> > >>but mergeable with their neighbors (test case is the same):
> > >>    
> > >
> > >Correct, but it was in the first or last slot when it was balanced (I
> > >confirmed this with printk).
> > >
> > >Then the higher layers were balanced and our leaves were no longer in
> > >the first/last slot.  We don't rebalance leaves when we balance level 1.
> > >
> > >  
> > >>leaf 269557760 items 22 free space 2323 generation 25 owner 2
> > >>fs uuid 614fb921-cfa9-403d-9feb-940021e72382
> > >>chunk uuid b1674882-a445-45f9-b250-0985e483d231
> > >>
> > >>leaf 280027136 items 18 free space 2627 generation 25 owner 2
> > >>fs uuid 614fb921-cfa9-403d-9feb-940021e72382
> > >>chunk uuid b1674882-a445-45f9-b250-0985e483d231
> > >>
> > >>node 269549568 level 1 items 60 free 61 generation 25 owner 2
> > >>fs uuid 614fb921-cfa9-403d-9feb-940021e72382
> > >>chunk uuid b1674882-a445-45f9-b250-0985e483d231
> > >>       key (175812608 EXTENT_ITEM 4096) block 175828992 (42927) gen 15
> > >>       key (176025600 EXTENT_ITEM 4096) block 176111616 (42996) gen 15
> > >>       key (176238592 EXTENT_ITEM 4096) block 176300032 (43042) gen 15
> > >>       key (176451584 EXTENT_ITEM 4096) block 216248320 (52795) gen 17
> > >>       key (176672768 EXTENT_ITEM 4096) block 216236032 (52792) gen 17
> > >>       key (176783360 EXTENT_ITEM 4096) block 216252416 (52796) gen 17
> > >>       key (176955392 EXTENT_ITEM 4096) block 138854400 (33900) gen 25
> > >>       key (177131520 EXTENT_ITEM 4096) block 280289280 (68430) gen 25
> > >>       key (177348608 EXTENT_ITEM 4096) block 280285184 (68429) gen 25
> > >>       key (177561600 EXTENT_ITEM 4096) block 269557760 (65810) gen 25
> > >>       key (177795072 EXTENT_ITEM 4096) block 280027136 (68366) gen 25
> > >>       key (178008064 EXTENT_ITEM 4096) block 280064000 (68375) gen 25
> > >>       key (178233344 EXTENT_ITEM 4096) block 285061120 (69595) gen 25
> > >>       key (178442240 EXTENT_ITEM 4096) block 178442240 (43565) gen 16
> > >>       key (178655232 EXTENT_ITEM 4096) block 178655232 (43617) gen 16
> > >>       key (178868224 EXTENT_ITEM 4096) block 178868224 (43669) gen 16
> > >>[...]
> > >>
> > >>    
> > >>>With the patch, I'm able to create 106894 files (2K each) on a 1GB FS.
> > >>>That doesn't sound like a huge improvement, but the default from
> > >>>mkfs.btrfs is to duplicate metadata.  After duplication, that's about
> > >>>417MB or about 40% of the overall space.
> > >>>
> > >>>When you factor in the space that we reserve to avoid exploding on
> > >>>enospc and the space that we have allocated for data extents, that's not
> > >>>a very surprising number.
> > >>>
> > >>>I'm still putting this patch through more testing, the double split code
> > >>>is used in some difficult corners and I need to make sure I've tried
> > >>>all of them.
> > >>>      
> > >>Chris, for the further code review we need documents, which reflect
> > >>the original ideas of the balancing, etc. Could you please provide them?
> > >>Obviously, I can not do it instead of you, as I don't know those ideas.
> > >>
> > >>    
> > >
> > >Which part are you most interested in?
> > >  
> > 
> > Balancing.
> > 
> > What conditions do we want to provide?
> > Why won't we get utilization slump in future?
> > How do we need to fix things when something goes wrong?
> > Whereas in accordance with the single existing paper Btrfs
> > design looks really broken, because:
> 
> > 1. the balancing condition n <= number_of_keys <= 2n+1
> >   is not satisfied (indeed, when number_of_keys is 1
> >   we have 1 <= 2n+1 -- false);
> 
> That doesn't matter.  It is not necessary (or desirable) to follow the
> classical B-tree algorithms to the letter to get sufficiently good
> properties.  B-trees are quite robust to changing the details, as long
> as you follow the generalised principles which make them work.

There are lots of different perspectives here, but it is important to
step back and look at what we're using the btree for.  We're making an
index to filesystem metadata.  The index is there so that we can find
that metadata with a reasonable number of IOs and in a reasonable amount
of time.

Because btrfs is COW, and because of the reference counted COW used to
maintain snapshots, the cost of updating the btree is different from
traditional btrees.  We do try to avoid balancing more and
intentionally allow the btree leaves to be less compact simply because
it allows us to avoid the higher cost of those operations.

The btree nodes are fairly strict.  They contain fixed records and are
balanced in a simple fashion.  When we are inserting a new key into a
node, if the node is completely full we split it.  When we are deleting
a key, if the node is less than half full we balance it.  Calculating
full on the btree nodes is a factor of the number of keys in them.

The leaves have fixed length keys that describe items of variable size.
On deletion merging is done when we're less than 1/3rd full and on
insertion we split when the item we're trying to shove in doesn't fit.
Calculating full on the btree leaves is a factor of the total size of
the items stored.

So, with all of that said, the nodes point to leaves and the leaves
contain inodes, directory entries and sometimes file data.

The most important part of the index is the higher levels of the tree.
The index of most filesystems points to but does not contain
inodes and file data, and so the higher levels of the btrfs btree are
more like a traditional FS index.

There's a knob here for the max inline item size and if someone wants to
fill their whole FS with 2K files, the default settings are not at all
suitable.  Filling with 3K files actually works better because we end
up with inode and file data in the same block much of the time.

> 
> (It is entirely possible that btrfs does not follow those principles
> though :-)

We try ;) Clearly there was a bug around splitting for large items.

> 
> All that matters to guarantee utilisation and algorithmic performance
> is to do enough merging on deletions, and avoid doing too many splits,
> to ensure that an amount X% of all used blocks (except the root) are
> at least Y% full.
> 
> Y is 50 and X is 100 in your description, but other numbers work too.
> Reducing X slightly improves utilisation in common filesystem
> scenarios where many blocks are filled in ascending key sequences.
> (But delayed allocation/writing, like btrfs does, is another way to
> achieve a similar result.)  Increasing Y improves minimum utilisation,
> which seems like a good thing to demand from a filesystem - for the
> actual data, anyway.
> 
> From what's been said in this thread, I'm getting the impression that
> btrfs does not guarantee a particular value of X, but rather depends
> heuristically on typical behaviour to give an equivalent outcome, and
> that that does not always work in some pathological cases.  And also
> that Y is/was not guaranteed, but that may be quite possibly an
> ordinary bug and might have been fixed by Chris during this thread.
> 
> I must admit that only getting 200GB of 2kB files into a formatted 1GB
> partition before it says ENOSPC - and that's after Chris's recent
> tweak - is a bit disappointing.  A little over 50% loss for 2kB files
> is quite reasonable - most filesystems would do that just due to
> padding to the next 4kB (the block size), and about 50% wastage in a
> B-tree is fair enough (at least if there is no sane pattern to the
> file's creation), as guaranteeing higher utilisation has a performance
> penalty.  But with the delayed allocation, I'd hope for better packing
> than the worst case, and I'd expect even the worst case to be better
> than 20% available for data.
> 
> Losing 80% of the space to utilisation loss and metadata duplication
> is disappointing (to me), and a bit suprising, given that one of the
> purposes of inline extents is to pack small files more efficiently
> than if they were padded to the block size.

I agree, in this case metadata duplication is not helping.  A new
default limit on the size of the inline data might be in order.

> 
> > 2. the trees mentioned in this paper don't allow keys of
> >   variable length.
> 
> Inline extents aren't the same as variable-length keys, because they
> aren't sorted or searched by content.  I showed in an earlier reply to
> you how to show that variable length *values*[1] don't cause
> unbalancing provided the splits are put in acceptable places.  But to
> make sense of that, you do have to grok the generalising of B-trees
> beyond the original algorithms.
> 
> [1] Think of the B-tree variants which contain (key,value) pairings
> where "value" is not ordered, rather than the type which contain just
> "keys" which are fully ordered.
> 
> Are there any true (fully ordered) variable-length keys in btrfs?

The keys are a fixed length, only the size of the items stored can vary.

-chris
