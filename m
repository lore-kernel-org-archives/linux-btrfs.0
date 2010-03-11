From: Chris Mason <chris.mason@oracle.com>
Subject: Re: SSD Optimizations
Date: Thu, 11 Mar 2010 11:19:32 -0500
Message-ID: <20100311161932.GH6509@think>
References: <4B97F7CE.4030405@bobich.net>
 <20100311135909.a7acc23e.skraw@ithnet.com>
 <be59d9db8e9c4f9fa0dd856a95ed208b@localhost>
 <201003111501.55663.hka@qbs.com.pl>
 <20100311163533.0ea09173.skraw@ithnet.com>
 <0592c2cb505638c1110eaef97192eb60@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-btrfs@vger.kernel.org
To: Gordan Bobic <gordan@bobich.net>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <0592c2cb505638c1110eaef97192eb60@localhost>
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Mar 11, 2010 at 04:03:59PM +0000, Gordan Bobic wrote:
> On Thu, 11 Mar 2010 16:35:33 +0100, Stephan von Krawczynski
> <skraw@ithnet.com> wrote:
> 
> >> Besides, why shouldn't we help the drive firmware by 
> >> - writing the data only in erase-block sizes
> >> - trying to write blocks that are smaller than the erase-block in a way
> >> that won't cross the erase-block boundary
> > 
> > Because if the designing engineer of a good SSD controller wasn't able
> to
> > cope with that he will have no chance to design a second one.
> 
> You seem to be confusing quality of implementation with theoretical
> possibility.
> 
> >> This will not only increase the life of the SSD but also increase its 
> >> performance.
> > 
> > TRIM: maybe yes. Rest: pure handwaving.
> > 
> >> [...]
> >> > > And your guess is that intel engineers had no glue when designing
> >> > > the XE
> >> > > including its controller? You think they did not know what you and
> me
> >> > > know and
> >> > > therefore pray every day that some smart fs designer falls from
> >> > > heaven
> >> > > and saves their product from dying in between? Really?
> >> > 
> >> > I am saying that there are problems that CANNOT be solved on the disk
> >> > firmware level. Some problems HAVE to be addressed higher up the
> stack.
> >> 
> >> Exactly, you can't assume that the SSDs firmware understands any and
> all
> >> file
> >> system layouts, especially if they are on fragmented LVM or other
> >> logical
> >> volume manager partitions.
> > 
> > Hopefully the firmware understands exactly no fs layout at all. That
> would
> > be
> > braindead. Instead it should understand how to arrange incoming and
> > outgoing
> > data in a way that its own technical requirements are met as perfect as
> > possible. This is no spinning disk, it is completely irrelevant what the
> > data
> > layout looks like as long as the controller finds its way through and
> copes
> > best with read/write/erase cycles. It may well use additional RAM for
> > caching and data reordering.
> > Do you really believe ascending block numbers are placed in ascending
> > addresses inside the disk (as an example)? Why should they? What does
> that
> > mean for fs block ordering? If you don't know anyway what a controller
> > does to
> > your data ordering, how do you want to help it with its job?
> > Please accept that we are _not_ talking about trivial flash mem here or
> > pseudo-SSDs consisting of sd cards. The market has already evolved
> better
> > products. The dinosaurs are extincted even if some are still looking
> alive.
> 
> I am assuming that you are being deliberately facetious here (the
> alternative is less kind). The simple fact is that you cannot come up with
> some magical data (re)ordering method that nullifies problems of common
> use-cases that are quite nasty for flash based media.
> 
> For example - you have a disk that has had all it's addressable blocks
> tainted. A new write comes in - what do you do with it? Worse, a write
> comes in spanning two erase blocks as a consequence of the data
> re-alignment in the firmware. You have no choice but to wipe them both and
> re-write the data. You'd be better off not doing the magic and assuming
> that the FS is sensibly aligned.

Ok, how exactly would the FS help here?  We have a device with a 256kb
erasure size, and userland does a 4k write followed by an fsync.

If the FS were to be smart and know about the 256kb requirement, it
would do a read/modify/write cycle somewhere and then write the 4KB.

The underlying implementation is the same in the device.  It picks a
destination, reads it then writes it back.  You could argue (and many
people do) that this operation is risky and has a good chance of
destroying old data.  Perhaps we're best off if the FS does the rmw
cycle instead into an entirely safe location.

It's a great place for research and people are definitely looking at it.

But with all of that said, it has nothing to do with alignment or trim.
Modern ssds are a raid device with a large stripe size, and someone
somewhere is going to do a read/modify/write to service any small write.
You can force this up to the FS or the application, it'll happen
somewhere.

The filesystem metadata writes are a very small percentage of the
problem overall.  Sure we can do better and try to force larger metadata
blocks.  This was the whole point behind btrfs' support for large tree
blocks, which I'll be enabling again shortly.

-chris
