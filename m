From: Dmitri Nikulin <dnikulin@gmail.com>
Subject: Re: interesting use case for multiple devices and delayed raid?
Date: Wed, 1 Apr 2009 21:13:19 +1100
Message-ID: <3a7f57190904010313q230f004chf7db770bb1169daa@mail.gmail.com>
References: <1238577447.9099.150.camel@pc.interlinx.bc.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: Linux btrfs <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1238577447.9099.150.camel@pc.interlinx.bc.ca>
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Apr 1, 2009 at 8:17 PM, Brian J. Murrell <brian@interlinx.bc.ca=
> wrote:
> I have a use case that I wonder if anyone might find interesting
> involving multiple device support and delayed raid.
>
> Let's say I have a system with two disks of equal size (to make it ea=
sy)
> which has sporadic, heavy, write requirements. =C2=A0At some points i=
n time
> there will be multiple files being appended to simultaneously and at
> other times, there will be no activity at all.
>
> The write activity is time sensitive, however, so the filesystem must=
 be
> able to provide guaranteed (only in a loose sense -- not looking for
> real QoS reservation semantics) bandwidths at times. =C2=A0Let's say =
slightly
> (but within the realm of reality) less than the bandwidth of the two
> disks combined.

I assume you mean read bandwidth, since write bandwidth cannot be
increased by mirroring, only striping. If you intend to stripe first,
then mirror later as time permits, this is the kind of sophistication
you will need to write in the program code itself.

A filesystem is a handy abstraction, but you are by no means limited
to using it. If you have very special needs, you can get pretty far by
writing your own meta-filesystem to add semantics you don't have in
your kernel filesystem of choice. That's what every single database
application does. You can get even further by writing a complete
user-space filesystem as part of your program, or a shared daemon, and
the performance isn't really that bad.

> I also want both the metadata and file data mirrored between the two
> disks so that I can afford to lose one of the disks and not lose (mos=
t
> of) my data. =C2=A0It is not a strict requirement that all data be
> immediately mirrored however.

This is handled by DragonFly BSD's HAMMER filesystem. A master gets
written to, and asynchronously updates a slave, even over a network.
It is transactionally consistent and virtually impossible to corrupt
as long as the disk media is stable. However as far as I know it won't
spread reads, so you'll still get the performance of one disk.

A more complete solution, that requires no software changes, would be
to have 3 or 4 disks. A stripe for really fast reads and writes, and
another disk (or another stripe) to act as a slave to the data being
written to the primary stripe. This seems to do what you want, at a
small price premium.

--=20
Dmitri Nikulin

Centre for Synchrotron Science
Monash University
Victoria 3800, Australia
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
