From: Chris Mason <chris.mason@oracle.com>
Subject: Re: assertion failures
Date: Fri, 26 Feb 2010 14:15:44 -0500
Message-ID: <20100226191544.GK12841@think>
References: <20100226175927.GG12841@think>
 <20100226181157.50F73414B9@viridian.itc.virginia.edu>
 <93cdabd21002261111v211e77e6ic789a2487461a420@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Cc: Bill Pemberton <wfp5p@viridian.itc.virginia.edu>,
	linux-btrfs@vger.kernel.org
To: Mike Fedyk <mfedyk@mikefedyk.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <93cdabd21002261111v211e77e6ic789a2487461a420@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Feb 26, 2010 at 11:11:07AM -0800, Mike Fedyk wrote:
> On Fri, Feb 26, 2010 at 10:11 AM, Bill Pemberton
> <wfp5p@viridian.itc.virginia.edu> wrote:
> >>
> >> Does the array have any kind of writeback cache?
> >>
> >
> > Yes, the array has a writeback cache.
> >
> >>
> >> Are all of the filesystems spread across all of the drives? =A0Or =
do some
> >> filesystems use some drives only?
> >>
> >
> > In all cases the array is presenting 1 physical volume to the host
> > system (which is RAID 6 on the array itself). =A0That physical volu=
me is
> > made into a volume group and the filesystems are on logical volumes=
 in
> > that volume group.
> >
>=20
> I wonder if the barrier messages are making it to this write back
> cache.  Do you see any messages about barriers in your kernel logs?

Most drives with writeback caches will honor the barriers.  Most arrays
with writeback caches will ignore them.  Usually they also have their
own battery backup, which should be safe enough to continue using the
writeback cache.

But, that depends on the array.

Bill, I've got a great little application that you can use to test the
safety of the array against power failures.  You'll have to pull the
plug on the poor machine about 10 times to be sure, just let me know if
you're interested.

If the raid array works, the power failure test won't hurt any of the
existing filesystems.  If not, it's possible they will all get
corrupted, so I wouldn't blame you for not wanting to run it.

-chris

--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
