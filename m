Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:44591 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751727AbcFEVHZ (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sun, 5 Jun 2016 17:07:25 -0400
Date: Sun, 5 Jun 2016 21:07:21 +0000
From: Hugo Mills <hugo@carfax.org.uk>
To: Christoph Anton Mitterer <calestyo@scientia.net>
Cc: Henk Slager <eye1tm@gmail.com>, linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: btrfs
Message-ID: <20160605210721.GH24492@carfax.org.uk>
References: <1464819934.6742.71.camel@scientia.net>
 <d500a743-7a39-8ec5-c6ce-e5a3c70ede91@nv-systems.net>
 <1464975482.6679.11.camel@scientia.net>
 <6f18c0d1-8ac5-c325-0ba8-ffb949c54554@gmail.com>
 <1465005092.6648.39.camel@scientia.net>
 <CAPmG0jZGY841PNwYi6gaun38gjN83=OMQB0r_UiVrdL9iY2J9Q@mail.gmail.com>
 <1465160205.6702.38.camel@scientia.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="CNfT9TXqV7nd4cfk"
In-Reply-To: <1465160205.6702.38.camel@scientia.net>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--CNfT9TXqV7nd4cfk
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun, Jun 05, 2016 at 10:56:45PM +0200, Christoph Anton Mitterer wrote:
> On Sun, 2016-06-05 at 22:39 +0200, Henk Slager wrote:
> > > So the point I'm trying to make:
> > > People do probably not care so much whether their VM image/etc. is
> > > COWed or not, snapshots/etc. still work with that,... but they may
> > > likely care if the integrity feature is lost.
> > > So IMHO, nodatacow + checksumming deserves to be amongst the top
> > > priorities.
> > Have you tried blockdevice/HDD caching like bcache or dmcache in
> > combination with VMs on BTRFS?
> No yet,... my personal use case is just some VMs on the notebook, and
> for this, the above would seem a bit overkill.
> For the larger VM cluster at the institute,... puh to be honest I don't
> know by hard what we do there.
>=20
>=20
> > =A0=A0Or ZVOL for VMs in ZFS with L2ARC?
> Well but all this is an alternative solution,...
>=20
>=20
> > I assume the primary reason for wanting nodatacow + checksumming is
> > to
> > avoid long seektimes on HDDs due to growing fragmentation of the VM
> > images over time.
> Well the primary reason is wanting to have overall checksumming in the
> fs, regardless of which features one uses.

   The problem is that you can't guarantee consistency with
nodatacow+checksums. If you have nodatacow, then data is overwritten,
in place. If you do that, then you can't have a fully consistent
checksum -- there are always race conditions between the checksum and
the data being written (or the data and the checksum, depending on
which way round you do it).

> I think we already have some situations where tools use/set btrfs
> features by themselves (i.e. automatically)... wasn't systemd creating
> subvols per default in some locations, when there's btrfs?
> So it's no big step to postgresql/etc. setting nodatacow, making people
> loose integrity without them even knowing.
>=20
> Of course, avoiding the fragmentation is the reason for the desire to
> have nodatacow.
>=20
>=20
> >  But even if you have nodatacow + checksumming
> > implemented, it is then still HDD access and a VM imagefile itself is
> > not guaranteed to be continuous.
> Uhm... sure, but that's no difference to other filesystems?!
>=20
>=20
> > It is clear that for VM images the amount of extents will be large
> > over time (like 50k or so, autodefrag on),
> Wasn't it said, that autodefrag performs bad for anything larger than
> ~1G?

   I don't recall ever seeing someone saying that. Of course, I may
have forgotten seeing it...

> >  but with a modern SSD used
> > as cache, it doesn't matter. It is still way faster than just HDD(s),
> > even with freshly copied image with <100 extents.
> Well the fragmentation has also many other consequences and not just
> seeks (assuming everyone would use SSDs, which is and probably won't be
> the case for quite a while).
> Most obviously you get much more IOPS and btrfs itself will, AFAIU,
> also suffer from some issues due to the fragmentation.

   This is a fundamental problem with all CoW filesystems. There are
some mititgations that can be put in place (true CoW rather than
btrfs's redirect-on-write, like some databases do, where the original
data is copied elsewhere before overwriting; cache aggressively and
with knowledge of the CoW nature of the FS, like ZFS does), but they
all have their drawbacks and pathological cases.

   Hugo.

--=20
Hugo Mills             | How do you become King? You stand in the marketpla=
ce
hugo@... carfax.org.uk | and announce you're going to tax everyone. If you
http://carfax.org.uk/  | get out alive, you're King.
PGP: E2AB1DE4          |                                        Harry Harri=
son

--CNfT9TXqV7nd4cfk
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJXVJSJAAoJEFheFHXiqx3kHnMP/ixxJn/9S2JVPzRYuRfgQXWl
Hm9euigdrExURHvPYIZvBot81sEWC9gCPZKsT8pxJoXiQodiQG7wbaye7UGsnaO/
/jUyPPYK3sZ8is+auIgxqMXVjewF3riotyStRLJl5GCaCFu7cJw4agZlXGVygx9N
/DFLXOwdi7ao6dJPm5knUrJ6w/LAUDQLNMEOj0mqXJZrlEpHjpADH0+etrgMsXBY
TiZm4xNKoCKQB+NC8UwGi3CmJLYg8MvkajrFhwT0GLIocCx4kM4b1Bvf/24vepAj
lstdAUqQNAu6sCWjmVDLTaZ1IqJjy0QuIufbz85+f4LPaiO8aumhAoRnGn4zLQFl
UYYo4xknGCo5+A1UWynqYlvbEujnVl/GpHiLFuOQSVnHThkLlfN6yEZlwfMluBMY
X6w31QEMEZMitLjfHW071QbKW38Lx+T4i6B9rA7SFUjLU0Is7wOiLAqiQqomYxVp
oce0VRwUsp6qhED62qq+2xYkF792apYa/z4jk+vMabYepL1MWSnVdNRv5qY3xisv
j4LSDoGzLZxLf59VMvN3Qe3GnQz/JuxheygQwJLNhCJx3g2Csu7mO8X2cKD8E+Dr
byk6zPnmXyEQMj+nDSUbYhtJCsX+69qTN/Yr0VLlKIDaRCUIP4OL6EM/BEXUAOQM
iAb9D2RyDDk/5a8PcdlZ
=9gL6
-----END PGP SIGNATURE-----

--CNfT9TXqV7nd4cfk--
