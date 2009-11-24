From: Chris Mason <chris.mason@oracle.com>
Subject: Re: [RFC] proposal for a btrfs filesystem layout
Date: Mon, 23 Nov 2009 20:27:50 -0500
Message-ID: <20091124012749.GG24068@think>
References: <200911201950.06662.kreijack@libero.it>
 <20091120195408.GA3110@think>
 <200911210031.06858.kreijack@libero.it>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-btrfs@vger.kernel.org
To: Goffredo Baroncelli <kreijack@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <200911210031.06858.kreijack@libero.it>
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, Nov 21, 2009 at 12:31:06AM +0100, Goffredo Baroncelli wrote:
> Hi Chris,
> 
> On Friday 20 November 2009, Chris Mason wrote:
> > On Fri, Nov 20, 2009 at 07:50:06PM +0100, Goffredo Baroncelli wrote:
> > > Hi all,
> > > 
> > > after the Chirs (Ball) email, I thought about a possible btrfs file-system 
> > > layout, which may permit to snapshot the root and mount (if required) an 
> old 
> > > snapshot of the root.
> > 
> > [ very clear description of a filesystem tree layout ]
> > > 
> > > 
> > > Any comments ? 
> > 
> > This is definitely possible, but not strictly required.  We'll be able
> > to create an ioctl (or mount option) that replaces the default subvolume
> > ('.' in your examples) pointer with a pointer to another subvolume, and
> > an ioctl to delete the old root.
> 
> That was my first thought... but so the risk is to implement with ioctl(s) 
> commands (rename, delete, list  ) that 
> a) already exist in the VFS abstraction.
> b) refer to objects that are like "directories" (in fact the differences 
> between a volume and a directory are very small)

The 'default' subvolume actually does live in a directory, just one you
can't see without the ioctl ;)

> 
> > Basically it will end up hiding the extra layer of indirection your
> > proposal adds.  
> 
> Yes, my idea introduces an extra layer, that
> a) is different from all other file-systems 
> b) is not useful if you don't use the snapshot at all
> And both a) and b) are not good point :((
> 
> > This doesn't mean your ideas were bad, my plan all along
> > has been to leave this up to the distros to work out with the users, and
> > give them enough tools that they have the flexibility to do what they
> > need.
> 
> My concern is about the btrfs user interface.
> The biggest difficult that I had to learn the btrfs capabilities is its "user-
> interface". I have to admit to be not the smartest person, but I spent a lot 
> of time in order to understand which was the difference between a btrfs 
> subvolume creation and a "mkfs + mount".
> Finally I concluded that there no is difference (except the COW behaviour and 
> other implementation detail). My impression was that in some area too often 
> the VFS and btrfs do the same things. [*]
> The point is that if btrfs do the same things of VFS, this may be called as 
> "flexibility". 
> But the history has highlight that from a long term point of view is the 
> orthogonality of the subsystems that leads to the flexibility of the system..

Well, btrfs is using the VFS to expose the subvolumes.  Basically a
subvolume is a special directory.

-chris

