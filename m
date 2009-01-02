From: Chris Mason <chris.mason@oracle.com>
Subject: Re: Btrfs for mainline
Date: Fri, 02 Jan 2009 16:35:12 -0500
Message-ID: <1230932112.7538.82.camel@think.oraclecorp.com>
References: <1230722935.4680.5.camel@think.oraclecorp.com>
	 <20081231104533.abfb1cf9.akpm@linux-foundation.org>
	 <1230765549.7538.8.camel@think.oraclecorp.com>
	 <87r63ljzox.fsf@basil.nowhere.org>
	 <1230924749.7538.35.camel@think.oraclecorp.com>
	 <20090102210104.GC496@one.firstfloor.org>
Mime-Version: 1.0
Content-Type: text/plain
Cc: Andrew Morton <akpm@linux-foundation.org>,
	linux-kernel@vger.kernel.org,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	linux-btrfs <linux-btrfs@vger.kernel.org>
To: Andi Kleen <andi@firstfloor.org>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <20090102210104.GC496@one.firstfloor.org>
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, 2009-01-02 at 22:01 +0100, Andi Kleen wrote:
> On Fri, Jan 02, 2009 at 02:32:29PM -0500, Chris Mason wrote:
> > > If combination spinlocks/mutexes are really a win they should be 
> > > in the generic mutex framework. And I'm still dubious on the hardcoded 
> > > numbers.
> > 
> > Sure, I'm happy to use a generic framework there (or help create one).
> > They are definitely a win for btrfs, and show up in most benchmarks.
> 
> If they are such a big win then likely they will help other users
> too and should be generic in some form.
> 

I don't disagree.  It's about 6 lines of code though, and just hasn't
been at the top of my list.  I'm sure the generic version will be
faster, as it could add checks to see if the holder of the lock was
actually running.

> > 
> > > - compat.h needs to go
> > 
> > Projects that are out of mainline have a difficult task of making sure
> > development can continue until they are in mainline and being clean
> > enough to merge.  I'd rather get rid of the small amount of compat code
> > that I have left after btrfs is in (compat.h is 32 lines).  
> 
> It's fine for an out of tree variant, but the in tree version
> shouldn't have compat.h. For out of tree you just apply a patch
> that adds the includes. e.g.compat-wireless and lots of other
> projects do it this way. 
> 

It helps debugging that my standalone tree is generated from and exactly
the same as fs/btrfs in the full kernel tree.  I'll switch to a pull and
merge system for the standalone tree.

> > 
> > Yes, I tried to mark those as I did them (a very small number of
> > functions).  In general they were copied to avoid adding exports, and
> > that is easily fixed.
> > 
> > > - there should be manpages for all the ioctls and other interfaces.
> > > - ioctl.c was not explicitely root protected. security issues?
> > 
> > Christoph added a CAP_SYS_ADMIN check to the trans start ioctl, but I do
> > need to add one to the device add/remove/balance code as well.
> 
> Ok. Didn't see that.
> 
> It still needs to be carefully audited for security holes 
> even with root checks.

Yes, the most important one is the device scan ioctl (also missing the
root check, will fix).

> 
> Another thing is that once auto mounting is enabled each usb stick
> with btrfs on it could be a root hole if you have buffer overflows
> somewhere triggerable by disk data. I guess that would need some
> checking too.
> 
> > The subvol/snapshot creation is meant to be user callable (controlled by
> > something similar to quotas later on).
> 
> But right now that's not there so it should be root only.
> 

I'll switch to checking against directory permissions for now.
subvol/snapshot creation are basically mkdir anyway, so this fits well.

> > 
> > >  Also there used to be a lot of BUG_ON()s on
> > > memory allocation failure even.
> > > - In general BUG_ONs need review I think. Lots of externally triggerable
> > > ones.
> > > - various checkpath.pl level problems I think (e.g. printk levels) 
> > > - the printks should all include which file system they refer to
> > > 
> > > In general I think the whole thing needs more review.
> > 
> > I don't disagree, please do keep in mind that I'm not suggesting anyone
> > use this in production yet.
> 
> When it's in mainline I suspect people will start using it for that.

I think the larger question here is where we want development to happen.
I'm definitely not pretending that btrfs is perfect, but I strongly
believe that it will be a better filesystem if the development moves to
mainline where it will attract more eyeballs and more testers.

-chris


