From: Chris Mason <chris.mason@oracle.com>
Subject: Re: worse than expected compression ratios with -o compress
Date: Thu, 21 Jan 2010 15:07:50 -0500
Message-ID: <20100121200750.GC23006@think>
References: <alpine.DEB.2.00.1001161048330.16549@alumni-linux.ccs.neu.edu>
 <20100118141240.GA10710@localhost.localdomain>
 <20100118212951.GC4065@think>
 <alpine.DEB.2.00.1001181706590.31608@alumni-linux.ccs.neu.edu>
 <20100120163011.GE3001@think>
 <alpine.DEB.2.00.1001211224530.19136@alumni-linux.ccs.neu.edu>
 <e692861c1001211204u7b16efe9tf7ee5703054caf76@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Cc: Jim Faulkner <jfaulkne@ccs.neu.edu>,
	Josef Bacik <josef@redhat.com>, linux-btrfs@vger.kernel.org
To: Gregory Maxwell <gmaxwell@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <e692861c1001211204u7b16efe9tf7ee5703054caf76@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Jan 21, 2010 at 03:04:56PM -0500, Gregory Maxwell wrote:
> On Thu, Jan 21, 2010 at 1:16 PM, Jim Faulkner <jfaulkne@ccs.neu.edu> =
wrote:
> >
> > On Wed, 20 Jan 2010, Chris Mason wrote:
> >
> >> Please let me know if this improves your ratios
> >
> > It most certainly does! =C2=A0It also greatly reduced the time requ=
ired to copy
> > the data to my (not very fast) disk. =C2=A0All my testing was done =
on 2.6.32.4.
> > The line numbers in your patch were a little off for 2.6.32.4, but =
I did
> > manage to apply it cleanly. =C2=A0Here's the results of my testing:
> [snip]
> > I'd be very happy to see the -o compress-force option in the mainli=
ne kernel
> > someday!
>=20
>=20
> Sweet. But I think a force mount option is an unreasonably blunt tool=
=2E
>=20
> I think two things would be nice:
>=20
> (1) Fix the compression decision, I think this example suggests that
> something is broken. (I'd noticed poorer than expected compression on
> my laptop, but I'd chalked it up to the 64k blocks=E2=80=A6 now I'm n=
ot so
> confident)

The current code assumes that files have consistent data in them.  This
is very true for the average data set, but it'll be horribly wrong for
something like a database file.

>=20
> (2) An IOCTL for compression control.  Userspace knows best, some
> files ought to have a different compression policy.

Yes, we'll get #2 added.

-chris

--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
