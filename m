From: Mike Hommey <mh@glandium.org>
Subject: Re: What to do about subvolumes?
Date: Wed, 1 Dec 2010 17:31:57 +0100
Message-ID: <20101201163157.GB30236@glandium.org>
References: <20101201142136.GD427@dhcp231-156.rdu.redhat.com>
 <AANLkTin_xq7u1Xf9FVOskbKed5WDw1AAvDh8mhConCLX@mail.gmail.com>
 <1291219269-sup-8392@think>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Cc: C Anthony Risinger <anthony@extof.me>,
	Josef Bacik <josef@redhat.com>,
	linux-btrfs <linux-btrfs@vger.kernel.org>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>, hch <hch@lst.de>,
	ssorce <ssorce@redhat.com>
To: Chris Mason <chris.mason@oracle.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <1291219269-sup-8392@think>
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Dec 01, 2010 at 11:01:37AM -0500, Chris Mason wrote:
> Excerpts from C Anthony Risinger's message of 2010-12-01 09:51:55 -05=
00:
> > On Wed, Dec 1, 2010 at 8:21 AM, Josef Bacik <josef@redhat.com> wrot=
e:
> > >
> > > =3D=3D=3D How do we want subvolumes to work from a user perspecti=
ve? =3D=3D=3D
> > >
> > > 1) Users need to be able to create their own subvolumes. =C2=A0Th=
e permission
> > > semantics will be absolutely the same as creating directories, so=
 I don't think
> > > this is too tricky. =C2=A0We want this because you can only take =
snapshots of
> > > subvolumes, and so it is important that users be able to create t=
heir own
> > > discrete snapshottable targets.
> > >
> > > 2) Users need to be able to snapshot their subvolumes. =C2=A0This=
 is basically the
> > > same as #1, but it bears repeating.
> >=20
> > could it be possible to convert a directory into a volume?  or at
> > least base a snapshot off it?
>=20
> I'm afraid this turns into the same complexity as creating a new volu=
me
> and copying all the files/dirs in by hand.

Except you wouldn't have to copy data, only metadata.

Mike
--
To unsubscribe from this list: send the line "unsubscribe linux-fsdevel=
" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
