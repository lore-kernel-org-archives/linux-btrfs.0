Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:33738 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964842AbaEQRnZ (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 17 May 2014 13:43:25 -0400
Date: Sat, 17 May 2014 18:43:15 +0100
From: Hugo Mills <hugo@carfax.org.uk>
To: dsterba@suse.cz, Qu Wenruo <quwenruo@cn.fujitsu.com>,
        linux-btrfs@vger.kernel.org, clm@fb.com
Subject: Re: [PATCH 00/27] Replace the old man page with asciidoc and man
 page for each btrfs subcommand.
Message-ID: <20140517174315.GC2537@carfax.org.uk>
References: <1396427378-10487-1-git-send-email-quwenruo@cn.fujitsu.com>
 <20140416171219.GC29256@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="pAwQNkOnpTn9IO2O"
In-Reply-To: <20140416171219.GC29256@twin.jikos.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--pAwQNkOnpTn9IO2O
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Apr 16, 2014 at 07:12:19PM +0200, David Sterba wrote:
> On Wed, Apr 02, 2014 at 04:29:11PM +0800, Qu Wenruo wrote:
> > Convert the old btrfs man pages to new asciidoc and split the huge
> > btrfs man page into subcommand man page.
>=20
> I'm merging this patchset into the base series of integration because
> several patches need to update the docs and it's no longer feasible to
> keep it in a separate branch from the patches.

   I've just been poking around in the docs for a completely different
reason, and I think there's a fairly serious problem (well, as serious
as problems get with documentation).

   Take, for example, the format for btrfs fi resize:

'resize' [devid:][+/-]<size>[gkm]|[devid:]max <path>::

   Now, this has just thrown away all of the useful markup which
indicates the semantics of the command. The asciidoc renders all of
that text literally and unformatted, making alphasymbolic(*) soup of
the docs. Compare this to the old roff man page:

\fBbtrfs\fP \fBfilesystem resize\fP [\fIdevid\fP:][+/\-]\fI<size>\fP[gkm]|[=
\fIdevid\fP:]\fImax <path>\fP

   This isn't perfect -- we're missing a \fB around the "max" -- but
it has text in bold(=E2=81=91) and italics(=E2=81=82) and neither(=E2=98=83=
). I've just looked
at some of the other pages, and they've also got similar typographical
problems. This is a lot of fiddly tedious work to get it right, and if
it doesn't get done now in the initial commit, then we're going to end
up with poor examples copied for every new feature or docs update,
making the problem worse before anyone does the work to make it
better.

   Hugo.

(*) Or possibly alphashambolic. :)
(=E2=81=91) For literal text
(=E2=81=82) For variables that require substitution by the user
(=E2=98=83) For structural syntax indicators such as [] for optional parts,=
 |
    for alternation and ... to indicate optional continuation of a list

--=20
=3D=3D=3D Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk=
 =3D=3D=3D
  PGP key: 65E74AC0 from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
            --- There isn't a noun that can't be verbed. ---            =20

--pAwQNkOnpTn9IO2O
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIVAwUBU3efs1heFHXiqx3kAQKqoA/+OKGGErL2KONc0oq4b8QCRmseKnZY9iDG
Qp2bdwjiDOcmeG6mEhvAO9C7pX9PlGp5Zk7X/1JzChLVU+C2VYeCBH3yJTZcUBHS
O/vmSSMgLx2qdkvfzJ3Dk5abjtszJU/SV4Ttns7iT1TqVlmahQpDBFNpCLAeZXqN
4BzFIBq8mewUmRsMIFbVMt+0kHL4LMszQVCp8V1X+a29ijUERIx2f9ktzaMtIc1L
cPKtDAbpyPD5v9mSdgPAOUG3J9WyX+1/uRL1YuupGRdqbnf8u1oDAw9BHV7GlupL
fbsTZfyAbdcnsLmO4usB8rr1meHJEZmp3ddjv/y+eIbx5rhCjznvbodCD3HPuh1h
j87yvvQIyvWdczGty0acabKRRARlVNsEdUoo84ahn/auRu10HGC4ZyPwHDFVauz/
9z7GaKUFbR+R758UhlBZxAaI1Ubk8hEVVat7lG5Fbx4UFmL4FWJusLLXHwJwpHH7
qfiquzFgkk0nMLffQ+BUr+85NROkVZKqKSw4A+8rqXeaCKe8kv1fsyssHsw9M+z0
08cwxz411CcWz/0PrxFL+5AlUMFsrHKe2aY+S2XioQ4mfyeEvrBLyqTK0yzibsKv
CIo6MyWx4VvrECZW4JgInl65wb8RfY6noFIvh2o9uVGH4uodvUNwzuxzk08UllHb
ftibfq4mI+A=
=oOUa
-----END PGP SIGNATURE-----

--pAwQNkOnpTn9IO2O--
