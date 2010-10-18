From: Ian Kent <raven@themaw.net>
Subject: Re: [PATCH V2] Removing a subvolume by an ordinary user
Date: Mon, 18 Oct 2010 14:02:15 +0800
Message-ID: <1287381735.3114.13.camel@localhost>
References: <201010112008.31736.kreijack@libero.it>
	 <1286859944.3013.10.camel@localhost>
	 <201010171753.45661.kreijack@libero.it>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: linux-btrfs@vger.kernel.org
To: kreijack@libero.it
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <201010171753.45661.kreijack@libero.it>
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, 2010-10-17 at 17:53 +0200, Goffredo Baroncelli wrote:
> On Tuesday, 12 October, 2010, Ian Kent wrote:
> > On Mon, 2010-10-11 at 20:08 +0200, Goffredo Baroncelli wrote:
> [...]
> > > +	ret = btrfs_unlink_subvol(trans, root, dir,
> > > +				dest->root_key.objectid,
> > > +				dentry->d_name.name,
> > > +				dentry->d_name.len);
> > > +	BUG_ON(ret);
> > 
> > Is it really a good idea to add even more dead end BUG_ON() calls
> > instead of handling errors when they happen?
> > 
> 
> I agree with your comment, I copied these lines from the ioctl DESTROY_SUBVOL.
> Unfortunately I don't have the know-how to handle an error at this level. So I 
> can only leave the code as the original one.

Right, sadly someone is going to have to go through and reconcile all
these things at some point.

I picked a function and started analyzing what would be needed
(including dependent functions) to handle the error return instead of
BUG_ON()ing and it's not trivial at all.

Ian


