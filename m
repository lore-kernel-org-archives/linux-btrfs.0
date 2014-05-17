Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:33999 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030217AbaEQSWq (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 17 May 2014 14:22:46 -0400
Date: Sat, 17 May 2014 19:22:36 +0100
From: Hugo Mills <hugo@carfax.org.uk>
To: dsterba@suse.cz, Qu Wenruo <quwenruo@cn.fujitsu.com>,
        linux-btrfs@vger.kernel.org, clm@fb.com
Subject: Re: [PATCH 00/27] Replace the old man page with asciidoc and man
 page for each btrfs subcommand.
Message-ID: <20140517182236.GD2537@carfax.org.uk>
References: <1396427378-10487-1-git-send-email-quwenruo@cn.fujitsu.com>
 <20140416171219.GC29256@twin.jikos.cz>
 <20140517174315.GC2537@carfax.org.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="oj4kGyHlBMXGt3Le"
In-Reply-To: <20140517174315.GC2537@carfax.org.uk>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--oj4kGyHlBMXGt3Le
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sat, May 17, 2014 at 06:43:15PM +0100, Hugo Mills wrote:
> On Wed, Apr 16, 2014 at 07:12:19PM +0200, David Sterba wrote:
> > On Wed, Apr 02, 2014 at 04:29:11PM +0800, Qu Wenruo wrote:
> > > Convert the old btrfs man pages to new asciidoc and split the huge
> > > btrfs man page into subcommand man page.
> >=20
> > I'm merging this patchset into the base series of integration because
> > several patches need to update the docs and it's no longer feasible to
> > keep it in a separate branch from the patches.
>=20
>    I've just been poking around in the docs for a completely different
> reason, and I think there's a fairly serious problem (well, as serious
> as problems get with documentation).
>=20
>    Take, for example, the format for btrfs fi resize:
>=20
> 'resize' [devid:][+/-]<size>[gkm]|[devid:]max <path>::
>=20
>    Now, this has just thrown away all of the useful markup which
> indicates the semantics of the command. The asciidoc renders all of
> that text literally and unformatted, making alphasymbolic(*) soup of
> the docs. Compare this to the old roff man page:
>=20
> \fBbtrfs\fP \fBfilesystem resize\fP [\fIdevid\fP:][+/\-]\fI<size>\fP[gkm]=
|[\fIdevid\fP:]\fImax <path>\fP
>=20
>    This isn't perfect -- we're missing a \fB around the "max" -- but
> it has text in bold(=E2=81=91) and italics(=E2=81=82) and neither(=E2=98=
=83). I've just looked
> at some of the other pages, and they've also got similar typographical
> problems. This is a lot of fiddly tedious work to get it right, and if
> it doesn't get done now in the initial commit, then we're going to end
> up with poor examples copied for every new feature or docs update,
> making the problem worse before anyone does the work to make it
> better.

   Oh, and asciidoc appears to be the most horrible capricious
inconsistent parser in existence. I've just spent 5 minutes getting
this one line of text to do what I want it to:

=3D=3D=3D=3D=3D
__N__**c**[\[_Mmin_**-**]__Mmax__**s**[_P_**p**]]
=3D=3D=3D=3D=3D

   I had to run through the list of block quote operators one at a
time in order to find the one I needed for this (the =3D=3D=3D=3D=3D); it's
still not indenting it correctly on the resulting man page.

   Note also the fun things like the fact that [[]] is special, so you
have to quote the opening part of it -- but if you try quoting the
first [ with a \ you get a literal \[ in the output. You get the right
output from quoting the *second* [ only.

   The Nc can only be italicised and emboldened properly with __ and
** because _ and * require whitespace around them in order to work
(seriously, WTF?). However, we can't be consistent with that in the
_Mmin_**-** because the quoted \[ appears to count as whitespace, so
using __Mmin__ gives us a leading literal _. The closing __ appears to
close the single opening _ correctly in that case, though.

   Seriously, this is meant to be _easy_ to use? I think I'd rather
type docbook by hand that have to struggle with this. Even the troff
macros for man pages are simpler to get right.

   Hugo.

>    Hugo.
>=20
> (*) Or possibly alphashambolic. :)
> (=E2=81=91) For literal text
> (=E2=81=82) For variables that require substitution by the user
> (=E2=98=83) For structural syntax indicators such as [] for optional part=
s, |
>     for alternation and ... to indicate optional continuation of a list
>=20

--=20
=3D=3D=3D Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk=
 =3D=3D=3D
  PGP key: 65E74AC0 from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
       --- Great oxymorons of the world, no. 1: Family Holiday ---      =20

--oj4kGyHlBMXGt3Le
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIUAwUBU3eo7FheFHXiqx3kAQLIDw/zBLjATGWVQWubFmD61uoBUZ3BkCFPxW7P
LvhwB4QJ+Bxw9t0d+6W6BfCeuuA1VtArFXrruad1E+O9suzuLKHSahMgFYEBIksC
3yKi/LjyB4gZQXCebuKfQ/oMKpzgX6tNeIPJQ8EfXRvQTY4H/z+Ot2q4EMp/kPxp
OarLu/ZFB3tT00cCeCEi7ZuG9FipcmujfGkW44UTWKQ2icqJmNoxq9XuzCuDI49/
ykNxEvF4XrCBccw+xmoCoN+l46H8u1ceJyMbKb2ox2m1/3SUX1Iz5+NBO8cJroZy
CSVjwrnDzvlMXC1UAuY08f2sgh8rL6GSjGW4psAta2C1j8rEiWMISmUtITI0jdi3
gJyMMK9GE+dKzDMQ19hKaddEYHuPFkxhSyfVkLl2AXeC7n/u/C0Wit5ysYPksh23
AzvOezF3Ae5Rvji8FifVgv4yaMJUZQkdQotDQYmOtuMDrmRlqrv/p9PpPUVRhqUJ
YIQE6r/y6cw2sSf71QpaSy0v64K4SRnzEzrsLs/2XMPYW0qHYhQo08NgopFHgjG6
sTKJi8HAg+2Gf9ZVrePb9Yia/TD5y85/ZzMlTq1N1mmtqveLfs3k34SWYn0FS/H8
G7YJkWQWHvRZFXytAen2MeHBrhbnwy7DcB9luFSF+i1XWYGN/bZLCWgg2hNYUryL
TbPg19bjJA==
=+O53
-----END PGP SIGNATURE-----

--oj4kGyHlBMXGt3Le--
