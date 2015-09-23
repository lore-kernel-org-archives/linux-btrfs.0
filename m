Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:47739 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755153AbbIWNpj (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 23 Sep 2015 09:45:39 -0400
Date: Wed, 23 Sep 2015 13:45:35 +0000
From: Hugo Mills <hugo@carfax.org.uk>
To: Qu Wenruo <quwenruo.btrfs@gmx.com>
Cc: dsterba@suse.cz,
        Holger =?iso-8859-1?Q?Hoffst=E4tte?=
	<holger.hoffstaette@googlemail.com>,
        linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs: Fix no space bug caused by removing bg
Message-ID: <20150923134535.GN5918@carfax.org.uk>
References: <15fc8f8d002e4ffcdb46e769736f240ae7ace20b.1442839332.git.zhaolei@cn.fujitsu.com>
 <560150CD.6070301@suse.com>
 <5601596B.1020607@googlemail.com>
 <20150922134131.GH5918@carfax.org.uk>
 <20150922142333.GH12815@twin.jikos.cz>
 <20150922143602.GI5918@carfax.org.uk>
 <20150923131226.GA12815@twin.jikos.cz>
 <5602A6EA.8050107@gmx.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="dPW7zu3hTOhZvCDO"
In-Reply-To: <5602A6EA.8050107@gmx.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--dPW7zu3hTOhZvCDO
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Sep 23, 2015 at 09:19:38PM +0800, Qu Wenruo wrote:
> =E5=9C=A8 2015=E5=B9=B409=E6=9C=8823=E6=97=A5 21:12, David Sterba =E5=86=
=99=E9=81=93:
> >On Tue, Sep 22, 2015 at 02:36:02PM +0000, Hugo Mills wrote:
> >>>Yeah, right now there's no persistent default for the allocator. I'm
> >>>still hoping that the object properties will magically solve that.
> >>
> >>    There's no obvious place that filesystem-wide properties can be
> >>stored, though. There's a userspace tool to manipulate the few current
> >>FS-wide properties, but that's all special-cased to use the
> >>"historical" ioctls for those properties, with no generalisation of a
> >>property store, or even (IIRC) any external API for them.
> >
> > From the UI point, we proposed to add a specifier that would route the
> >property to either subvolume or the filesystem:
> >
> >$ btrfs prop set -t filesystem bgtype raid0
> >$ btrfs prop set -t subvolume bgtype raid1
> >
>=20
> BTW, is btrfs going to support different chunk/bg type for subvolume?!
> I thought data/meta/system chunk types are all per filesystem level,
> and was planning to use superblock to record it...

   Well, it's been talked about for a *long* time, and it's certainly
something for which there's use-cases, and non-zero demand from users.

> If really to support that, does it mean we will have different
> meta/data type for each subvolume?
> That's a little too flex for me....

   I think you'd have to have a single metadata type for the whole FS
-- it doesn't make much sense to try splitting that up "by subvolume",
as almost all of the data structures are common to all subvolumes. For
data, however, it should certainly be possible to specify that a
subvol's data be stored with a given replication policy.

   While David and Austin's suggestion of a special xattr on the top
level subvol for the FS default is one possible implementation, using
the superblock would work just as well -- with the minor detail that
you'd have to special-case it into the properties UI, whereas using
xattrs, there will be less special-casing involved.

   Hugo.

> Thanks,
> Qu
>=20
> >How this will get stored in the xattrs is another question. As there's
> >always only single instance of the filesystem properties, it coud be
> >something like 'btrfs.fs.bgtype' and be stored as a xattr of the
> >toplevel subvolume.

--=20
Hugo Mills             | 2 + 2 =3D 5, for sufficiently large values of 2.
hugo@... carfax.org.uk |
http://carfax.org.uk/  |
PGP: E2AB1DE4          |

--dPW7zu3hTOhZvCDO
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJWAqz/AAoJEFheFHXiqx3ksPcQAJM3ajFRaBUypQADQL1SKQXM
17xg+MO0R9PYydFe9HAVUopnAF0Fs1nKR87Eo7HvxjyyDdEkkGAlGW4WWyhgYKqq
RKj5weTgKRSdlvOwhnXLKBZh8rG05+VYIP2c1jDfiFPU5N4LrJKQT98dvI2+A27B
LmTFwfAIG1Ogq+JucKmmrtMGp0AYblQOvYXD9k2O7T1CuaVC/QLnZF4Od0ZLW0Uz
MPuwR3M18Xbo7zS52Vf69A4WBWLTjgAsm0gRr9uaC5cj7wrs+Jm5h2RSVk2ugxEz
cKn1BRADM8OVpYWW/bmb/W6oaz7cbQ8Ym6L5HAmev3dsysTnA38W7dXgwyBvuLUn
Xp3HVDKXEj6w7T0IVy5t6BU1Fa6cIamZ9nAORNBRJkq+Lpj5t3gFKn8IPqndw8BG
aIMghI+CkFmbfxu2S2Maypm4bFM4xNDqzc/2ePPukztkg9okZgTpOovFgrqF4AcS
bb4c6EaR+wzr8zJMXpbCZT3+cFS6135yZJkqmkxDmJAyZjnW3qEfP4xRf+ncVhUb
FbP2rAQCslCNtfVkJOO+vWxg3YnOWChWqxW876CC2CN1WEtp0W9wov00sZ3T+xsh
H2WBafbng/Cwv8Bj9i1jPs+puAz8e/GQmtD5w2vCGZicinQal1nc51zjk+OwNVUc
sMWJweibMo3v+DZN0Mbk
=3Qg/
-----END PGP SIGNATURE-----

--dPW7zu3hTOhZvCDO--
