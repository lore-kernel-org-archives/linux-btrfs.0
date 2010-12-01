From: Chris Mason <chris.mason@oracle.com>
Subject: Re: What to do about subvolumes?
Date: Wed, 01 Dec 2010 11:01:37 -0500
Message-ID: <1291219269-sup-8392@think>
References: <20101201142136.GD427@dhcp231-156.rdu.redhat.com> <AANLkTin_xq7u1Xf9FVOskbKed5WDw1AAvDh8mhConCLX@mail.gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Cc: Josef Bacik <josef@redhat.com>,
	linux-btrfs <linux-btrfs@vger.kernel.org>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>, hch <hch@lst.de>,
	ssorce <ssorce@redhat.com>
To: C Anthony Risinger <anthony@extof.me>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-reply-to: <AANLkTin_xq7u1Xf9FVOskbKed5WDw1AAvDh8mhConCLX@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

Excerpts from C Anthony Risinger's message of 2010-12-01 09:51:55 -0500=
:
> On Wed, Dec 1, 2010 at 8:21 AM, Josef Bacik <josef@redhat.com> wrote:
> >
> > =3D=3D=3D How do we want subvolumes to work from a user perspective=
? =3D=3D=3D
> >
> > 1) Users need to be able to create their own subvolumes. =C2=A0The =
permission
> > semantics will be absolutely the same as creating directories, so I=
 don't think
> > this is too tricky. =C2=A0We want this because you can only take sn=
apshots of
> > subvolumes, and so it is important that users be able to create the=
ir own
> > discrete snapshottable targets.
> >
> > 2) Users need to be able to snapshot their subvolumes. =C2=A0This i=
s basically the
> > same as #1, but it bears repeating.
>=20
> could it be possible to convert a directory into a volume?  or at
> least base a snapshot off it?

I'm afraid this turns into the same complexity as creating a new volume
and copying all the files/dirs in by hand.

-chris
--
To unsubscribe from this list: send the line "unsubscribe linux-fsdevel=
" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
