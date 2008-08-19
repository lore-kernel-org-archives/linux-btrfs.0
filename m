From: Chris Mason <chris.mason@oracle.com>
Subject: Re: [PATCH] NFS support for btrfs - v2
Date: Tue, 19 Aug 2008 07:54:44 -0400
Message-ID: <1219146885.14063.54.camel@think.oraclecorp.com>
References: <200807210201.56690.balajirrao@gmail.com>
	 <200808171821.43874.balajirrao@gmail.com>
	 <1218977763.3184.288.camel@pmac.infradead.org>
	 <200808171854.14275.balajirrao@gmail.com>
	 <1218980439.3184.304.camel@pmac.infradead.org>
	 <1219087412.14063.22.camel@think.oraclecorp.com>
	 <1219088029.3184.413.camel@pmac.infradead.org>
	 <1219088859.14063.35.camel@think.oraclecorp.com>
	 <1219090839.3184.436.camel@pmac.infradead.org>
	 <1219091550.14063.44.camel@think.oraclecorp.com>
	 <1219096342.3184.453.camel@pmac.infradead.org>
Mime-Version: 1.0
Content-Type: text/plain
Cc: Balaji Rao <balajirrao@gmail.com>, linux-btrfs@vger.kernel.org
To: David Woodhouse <dwmw2@infradead.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1219096342.3184.453.camel@pmac.infradead.org>
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, 2008-08-18 at 22:52 +0100, David Woodhouse wrote:
> On Mon, 2008-08-18 at 16:32 -0400, Chris Mason wrote:
> > On Mon, 2008-08-18 at 21:20 +0100, David Woodhouse wrote:
> > > On Mon, 2008-08-18 at 15:47 -0400, Chris Mason wrote:
> > > > Lets pretend I had put in commments something like the code below.
> > > > The important part is that directories have only one link, so they
> > > > have only one backref.
> > > 
> > > OK. Now can I rip that code out anyway? The VFS will never call
> > > btrfs_lookup() for ".." -- not since the 2.2 kernel :)
> > > 
> > > I'm still a little confused about precisely what btrfs_search_slot()
> > > returns when it doesn't find a match -- that's probably where the
> > > documentation would be more useful.
> > > 
> > 
> > if btrfs_search_slot returns < 0, there was an error
> > if btrfs_search_slot returns > 1, path->slots[0] is the spot in the tree
> > where you'd want to insert the item.
> 
> What if the parent inode actually _is_ inode #0xffffffffffffffff? Can
> that happen? In that case it would return zero, and I shouldn't subtract
> 1 from the slot number -- I've actually found what I'm looking for?
> 

The max inode will be 2^64 - 1

> > In this case, if path->slots[0] == 0, there are no keys in the tree
> > smaller than your search key.                                  ^^^^
> 
> OK... what if the place I'd want to insert the item is the first slot in
> some node? There are keys in the _tree_ which are smaller, but just not
> in this node? I think that's where the root of my confusion lies.

In this case, you'll always end up in the last slot of the previous node
(which is what you were seeing when you put in the fix).

> 
> > If path->slots[0] == btrfs_header_nritems(path->nodes[0]), there are
> > no items in this node that have a key > than your search key.
>                    ^^^^
> Not in this node, but maybe in the next one? That's why my own fix for
> the bug involved using btrfs_next_leaf() and using the first item from
> that one?

Correct.

> 
> > > +	if (ret < 0 && slot == 0) {
> > 
> >               ^^^^^^^^^^^^^ should be ||, and should set ret to
> > something bad if slot == 0
> 
> Er, yes. Moment of stupidity there :)
> 
> We were ignoring 'ret' anyway -- none of this stuff should ever happen,
> and it's all just 'return ERR_PTR(-EINVAL)' at the out: label.
> 
> I've tested this, and added it to my tree:
> 

Looks good, thanks.

-chris


