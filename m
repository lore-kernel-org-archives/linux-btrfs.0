Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:43855 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751829Ab3HCL5S (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sat, 3 Aug 2013 07:57:18 -0400
Date: Sat, 3 Aug 2013 12:57:08 +0100
From: Hugo Mills <hugo@carfax.org.uk>
To: Mike Audia <mikey_a@gmx.com>
Cc: linux-btrfs@vger.kernel.org, David Sterba <dsterba@suse.cz>,
        sbehrens@giantdisaster.de
Subject: Re: [PATCH v2] btrfs: add mount option to set commit interval
Message-ID: <20130803115708.GA22967@carfax.org.uk>
References: <20130803113901.157540@gmx.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="pWyiEgJYm5f9v55/"
In-Reply-To: <20130803113901.157540@gmx.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--pWyiEgJYm5f9v55/
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sat, Aug 03, 2013 at 07:39:01AM -0400, Mike Audia wrote:
> > > Another newbie question is which version of the kernel do I need to
> > > have in order to cleanly apply this patch? =A0I am finding that it fa=
ils
> > > to apply to the current stable kernel code (as of now it is v3.10.4)
> > > which makes me think your patch has to be applied to a newer one? =A0=
Are
> > > you patching against the linux git tree meaning I have to use the 3.11
> > > series to try your code?
> >=20
> > Try Josef's btrfs-next repo:
> >=20
> > =A0https://btrfs.wiki.kernel.org/index.php/Btrfs_source_repositories#In=
tegration_repository_.28btrfs-next.29
>=20
> OK! =A0I can patch successfully into that git repo:
>=20
> % cd /tmp/work
> % git clone git://git.kernel.org/pub/scm/linux/kernel/git/josef/btrfs-nex=
t.git
> % cd btrfs
> % patch -Np1 -i btrfs_add_mount_option_to_set_commit_interval.patch
> patching file fs/btrfs/ctree.h
> patching file fs/btrfs/disk-io.c
> patching file fs/btrfs/super.c
> Hunk #3 succeeded at 647 (offset 19 lines).
> Hunk #4 succeeded at 1006 with fuzz 1 (offset 39 lines).

> If I am not mistaken, btrfs-next is the entire kernel's code? =A0The
> wiki suggests running anything compiled therein from the build dir.

   That'll be for the userspace tools, not the kernel. Obviously, one
doesn't tend to run kernels from the command line. :)

> =A0If I want to compile this into the official 3.10.4 tree, how can I
> do it?

   Add the "official" kernel repo as a remote to the same git repo
(with git remote add), fetch that repo, create a new branch to work
in, based on the btrfs-next branch, then merge in the other branch (or
vice-versa).

   Note that btrfs-next is usually based on the latest released kernel
anyway, so that's likely to be largely superfluous.

   Hugo.

--=20
=3D=3D=3D Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk=
 =3D=3D=3D
  PGP key: 65E74AC0 from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
     --- A gentleman doesn't do damage unless he's paid for it. ---     =20

--pWyiEgJYm5f9v55/
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIVAwUBUfzwFFheFHXiqx3kAQJowhAAmlbMvWcsnpRQnr5CvreHQb6H0EOx8JvD
4FT0CXvZpiaLfJwIVAi/Vrupqw6Ana/HeDvxWmiBeKiMfJzgrkw6XrB0AADBUcKg
TNLB/4v2wWToedTSDo06Hxz+usKDtJbUisWSNlzRgp6Hd9uGS+vTvkpB75zSZcbk
nJ9o/2EOnThSzzl3TRx/bNoO4fiXzKsZ36gkJd8TeoNUWpVK3YLyRpCKljBOqH1l
YCGewcSu38VOBTzgVPCR1HYJtFu/bzBm8OM3hrx46kcsJul4ZATX289wGefESip4
nz+NgnyCDYq1kgSoc/Wfr1d+HrFW3N3okic/04fYA9n/3MiCwAr/b/T/7MvpwqCs
uNCX5n6My2uta/A8qjWqk6t7ShVCMiu85wDiwz4ajkID0dO3vcFxtUegQVDtEzeV
E22PAKf/K8F2TBkMs3yyF3J+cKvvJFvjvXq7/vlqa8R3hg7BgNANPZiCrOdqVAQ6
emM9FGZ88kuqxJq6WLkjwmiA4GJLSLd4SaYi2GVj4+htjwlMyMTVZr3B87Udji3P
vdhT7R9YKnoGQR6CZyHzNrTZohIXgCSwd8Pu5kAq/ciFTz671OQ+CuP7KDQCqFMQ
0UMQ5H1CPd9u2YjpHl9dJsfDmpzubIO8y5gTsnp/kX0X0hHq/r+LGhjtUKWp9tr9
tbXhhXc1pcw=
=AM/a
-----END PGP SIGNATURE-----

--pWyiEgJYm5f9v55/--
