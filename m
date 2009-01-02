From: Andi Kleen <andi@firstfloor.org>
Subject: Re: Btrfs for mainline
Date: Fri, 2 Jan 2009 22:01:04 +0100
Message-ID: <20090102210104.GC496@one.firstfloor.org>
References: <1230722935.4680.5.camel@think.oraclecorp.com> <20081231104533.abfb1cf9.akpm@linux-foundation.org> <1230765549.7538.8.camel@think.oraclecorp.com> <87r63ljzox.fsf@basil.nowhere.org> <1230924749.7538.35.camel@think.oraclecorp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andi Kleen <andi@firstfloor.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-kernel@vger.kernel.org,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	linux-btrfs <linux-btrfs@vger.kernel.org>
To: Chris Mason <chris.mason@oracle.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <1230924749.7538.35.camel@think.oraclecorp.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Jan 02, 2009 at 02:32:29PM -0500, Chris Mason wrote:
> > If combination spinlocks/mutexes are really a win they should be 
> > in the generic mutex framework. And I'm still dubious on the hardcoded 
> > numbers.
> 
> Sure, I'm happy to use a generic framework there (or help create one).
> They are definitely a win for btrfs, and show up in most benchmarks.

If they are such a big win then likely they will help other users
too and should be generic in some form.

> 
> > - compat.h needs to go
> 
> Projects that are out of mainline have a difficult task of making sure
> development can continue until they are in mainline and being clean
> enough to merge.  I'd rather get rid of the small amount of compat code
> that I have left after btrfs is in (compat.h is 32 lines).  

It's fine for an out of tree variant, but the in tree version
shouldn't have compat.h. For out of tree you just apply a patch
that adds the includes. e.g.compat-wireless and lots of other
projects do it this way. 

> 
> Yes, I tried to mark those as I did them (a very small number of
> functions).  In general they were copied to avoid adding exports, and
> that is easily fixed.
> 
> > - there should be manpages for all the ioctls and other interfaces.
> > - ioctl.c was not explicitely root protected. security issues?
> 
> Christoph added a CAP_SYS_ADMIN check to the trans start ioctl, but I do
> need to add one to the device add/remove/balance code as well.

Ok. Didn't see that.

It still needs to be carefully audited for security holes 
even with root checks.

Another thing is that once auto mounting is enabled each usb stick
with btrfs on it could be a root hole if you have buffer overflows
somewhere triggerable by disk data. I guess that would need some
checking too.

> The subvol/snapshot creation is meant to be user callable (controlled by
> something similar to quotas later on).

But right now that's not there so it should be root only.

> 
> >  Also there used to be a lot of BUG_ON()s on
> > memory allocation failure even.
> > - In general BUG_ONs need review I think. Lots of externally triggerable
> > ones.
> > - various checkpath.pl level problems I think (e.g. printk levels) 
> > - the printks should all include which file system they refer to
> > 
> > In general I think the whole thing needs more review.
> 
> I don't disagree, please do keep in mind that I'm not suggesting anyone
> use this in production yet.

When it's in mainline I suspect people will start using it for that.

-Andi

-- 
ak@linux.intel.com
