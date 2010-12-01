From: Chris Mason <chris.mason@oracle.com>
Subject: Re: What to do about subvolumes?
Date: Wed, 01 Dec 2010 11:13:16 -0500
Message-ID: <1291219974-sup-7182@think>
References: <20101201142136.GD427@dhcp231-156.rdu.redhat.com> <AANLkTin_xq7u1Xf9FVOskbKed5WDw1AAvDh8mhConCLX@mail.gmail.com> <1291219269-sup-8392@think> <AANLkTikU6UDsGF2-qeDypU4Wprq8NkGD4E4j8otZ-tK7@mail.gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Cc: Josef Bacik <josef@redhat.com>,
	linux-btrfs <linux-btrfs@vger.kernel.org>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>, hch <hch@lst.de>,
	ssorce <ssorce@redhat.com>
To: C Anthony Risinger <anthony@extof.me>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-reply-to: <AANLkTikU6UDsGF2-qeDypU4Wprq8NkGD4E4j8otZ-tK7@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

Excerpts from C Anthony Risinger's message of 2010-12-01 11:03:23 -0500=
:
> On Wed, Dec 1, 2010 at 10:01 AM, Chris Mason <chris.mason@oracle.com>=
 wrote:
> > Excerpts from C Anthony Risinger's message of 2010-12-01 09:51:55 -=
0500:
> >> On Wed, Dec 1, 2010 at 8:21 AM, Josef Bacik <josef@redhat.com> wro=
te:
> >> >
> >> > =3D=3D=3D How do we want subvolumes to work from a user perspect=
ive? =3D=3D=3D
> >> >
> >> > 1) Users need to be able to create their own subvolumes. =C2=A0T=
he permission
> >> > semantics will be absolutely the same as creating directories, s=
o I don't think
> >> > this is too tricky. =C2=A0We want this because you can only take=
 snapshots of
> >> > subvolumes, and so it is important that users be able to create =
their own
> >> > discrete snapshottable targets.
> >> >
> >> > 2) Users need to be able to snapshot their subvolumes. =C2=A0Thi=
s is basically the
> >> > same as #1, but it bears repeating.
> >>
> >> could it be possible to convert a directory into a volume? =C2=A0o=
r at
> >> least base a snapshot off it?
> >
> > I'm afraid this turns into the same complexity as creating a new vo=
lume
> > and copying all the files/dirs in by hand.
>=20
> ok; if i create an empty volume, and use cp --reflink, it would have
> the desired affect though, right?

Almost, for no good reason at all our cp --reflink doesn't reflink
across subvols.  I'll get that fixed up.

-chris
--
To unsubscribe from this list: send the line "unsubscribe linux-fsdevel=
" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
