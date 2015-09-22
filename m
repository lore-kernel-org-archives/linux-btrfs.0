Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:44245 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757711AbbIVOgE (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 22 Sep 2015 10:36:04 -0400
Date: Tue, 22 Sep 2015 14:36:02 +0000
From: Hugo Mills <hugo@carfax.org.uk>
To: dsterba@suse.cz,
        Holger =?iso-8859-1?Q?Hoffst=E4tte?=
	<holger.hoffstaette@googlemail.com>,
        linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs: Fix no space bug caused by removing bg
Message-ID: <20150922143602.GI5918@carfax.org.uk>
References: <15fc8f8d002e4ffcdb46e769736f240ae7ace20b.1442839332.git.zhaolei@cn.fujitsu.com>
 <560150CD.6070301@suse.com>
 <5601596B.1020607@googlemail.com>
 <20150922134131.GH5918@carfax.org.uk>
 <20150922142333.GH12815@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="gTY1JhLGodeuSBqf"
In-Reply-To: <20150922142333.GH12815@twin.jikos.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--gTY1JhLGodeuSBqf
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Sep 22, 2015 at 04:23:33PM +0200, David Sterba wrote:
> On Tue, Sep 22, 2015 at 01:41:31PM +0000, Hugo Mills wrote:
> > On Tue, Sep 22, 2015 at 03:36:43PM +0200, Holger Hoffst=E4tte wrote:
> > > On 09/22/15 14:59, Jeff Mahoney wrote:
> > > (snip)
> > > > So if they way we want to prevent the loss of raid type info is by
> > > > maintaining the last block group allocated with that raid type, fin=
e,
> > > > but that's a separate discussion.  Personally, I think keeping 1GB
> > >=20
> > > At this point I'm much more surprised to learn that the RAID type can
> > > apparently get "lost" in the first place, and is not persisted
> > > separately. I mean..wat?
> >=20
> >    It's always been like that, unfortunately.
> >=20
> >    The code tries to use the RAID type that's already present to work
> > out what the next allocation should be. If there aren't any chunks in
> > the FS, the configuration is lost, because it's not stored anywhere
> > else. It's one of the things that tripped me up badly when I was
> > failing to rewrite the chunk allocator last year.
>=20
> Yeah, right now there's no persistent default for the allocator. I'm
> still hoping that the object properties will magically solve that.

   There's no obvious place that filesystem-wide properties can be
stored, though. There's a userspace tool to manipulate the few current
FS-wide properties, but that's all special-cased to use the
"historical" ioctls for those properties, with no generalisation of a
property store, or even (IIRC) any external API for them.

   We're nominally using xattrs in the btrfs: namespace on directories
and files, and presumably on the top directory of a subvolume for
subvol-wide properties, but it's not clear where the FS-wide values
should go: in the top directory of subvolid=3D5 would be confusing,
because then you couldn't separate the properties for *that subvol*
=66rom the ones for the whole FS (say, the default replication policy,
where you might want the top subvol to have different properties from
everything else).

   Hugo.

--=20
Hugo Mills             | Putting U back in Honor, Valor, and Trth.
hugo@... carfax.org.uk |
http://carfax.org.uk/  |
PGP: E2AB1DE4          |

--gTY1JhLGodeuSBqf
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJWAWdRAAoJEFheFHXiqx3kEowP/3jlzu/2C4LYF1VowB63MBWT
Cd4pxLB90pOrrdUBJ9wsQPm8Cq/sjn+CoXAtc1Q5qzgDbfgNbZuhUfQqw+1/fi6C
nOV1YP0wCQVBu4jc2bLlOdzcPK/ffpuVOXbi/GuRmd9zyqi4T7Ppxvd36tq+h/aY
2gf7/O7KNM1rlCOvSgOQGR1t0HKPBuwtpDZfqS+geqYjimqqtYJXyNZ6+e1as0Sl
ZKOrTWQ2CtTtUsnvaVlTYIqDFoUTuRebXp3mY30iXcz6YADlm73JqfqJYj//c7Ia
ccWHnvNGTQvWOVaV4gKKoNx6XHzLWYfdtKwI2QYq6IQQbk8gP5QxubJ4ncTWhz1U
6ZFip8l1wY+U/YRK/SUbA8X+vwLAqmSqRUNzGZ7/nR8LbLlcoVCh10bjexZoKr/d
qtYKJGlMZ6ZI1aBC7nwd/UQqxJT4RdomarjW2nHtdK0QmOk0twq3+yc4EapGayp8
TYqdW25Ljk2jYr7Yu3m4DbFmAmY6DkFfZx3MIMthDzc4a9KkEz1FBbyxxl0NqtN5
zzBIqPLXhArfjrE4+UMokgb0hCjZ044EfLAIw7Qoaorzm6eTEitFfQjJbWSVvyv8
0hANDSPu9GzMflUoIajmNjDOZDfNRZkjcdKaKx0QviUs+gWUKssx/gG7VoicHzb1
BxHrPUGhBlsowOIIsJ6H
=fYsD
-----END PGP SIGNATURE-----

--gTY1JhLGodeuSBqf--
