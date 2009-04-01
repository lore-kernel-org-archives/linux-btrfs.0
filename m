From: "Brian J. Murrell" <brian@interlinx.bc.ca>
Subject: Re: interesting use case for multiple devices and delayed raid?
Date: Wed, 1 Apr 2009 21:04:32 +0000 (UTC)
Message-ID: <gr0kt0$t9l$3@ger.gmane.org>
References: <1238577447.9099.150.camel@pc.interlinx.bc.ca>
	<3a7f57190904010313q230f004chf7db770bb1169daa@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, 01 Apr 2009 21:13:19 +1100, Dmitri Nikulin wrote:

On Wed, 2009-04-01 at 21:13 +1100, Dmitri Nikulin wrote:
> 
> I assume you mean read bandwidth, since write bandwidth cannot be
> increased by mirroring, only striping.

No, I mean write bandwidth.  You can get increased write bandwidth with
RAID 0 if you only write to one side of the mirror (initially),
effectively, striping.  You would update the other half of the mirror
"lazily" (iow, "delayed") when the filesystem has idle bandwidth.  One
of the stipulations was that the use pattern is peaks and valleys, not
sustained usage.

Yes, you would lose the data that was written to a failed mirror before
the filesystem got a chance to do the lazy mirror updating later on.
That was a stipulation in my original requirements too.

> If you intend to stripe first,
> then mirror later as time permits,

Yeah, that's one way to describe it.

> this is the kind of sophistication
> you will need to write in the program code itself.

Why?  A filesystem that does already does it's own mirroring and
striping (as I understand btrfs does) should be able to handle this
itself.  Much better in the filesystem than for each application to have
to handle it itself.

> A filesystem is a handy abstraction, but you are by no means limited
> to using it. If you have very special needs, you can get pretty far by
> writing your own meta-filesystem to add semantics you don't have in
> your kernel filesystem of choice.

Of course.  But I am floating this idea as a feature of btrfs given that
it already has much of the components needed.

> This is handled by DragonFly BSD's HAMMER filesystem. A master gets
> written to, and asynchronously updates a slave, even over a network.
> It is transactionally consistent and virtually impossible to corrupt
> as long as the disk media is stable. However as far as I know it won't
> spread reads, so you'll still get the performance of one disk.

More importantly, it won't spread writes.

> A more complete solution, that requires no software changes, would be
> to have 3 or 4 disks. A stripe for really fast reads and writes, and
> another disk (or another stripe) to act as a slave to the data being
> written to the primary stripe. This seems to do what you want, at a
> small price premium.

No.  That's not really what I am describing at all.

I apologize if my original description was unclear.  Hopefully it is
more so now.

b.


