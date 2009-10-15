From: Tracy Reed <treed@ultraviolet.org>
Subject: Re: Mass-Hardlinking Oops
Date: Thu, 15 Oct 2009 10:55:41 -0700
Message-ID: <20091015175541.GI30805@tracyreed.org>
References: <4A74401B.90801@mccme.ru>
 <20090803145741.GC3765@think>
 <4A76FB78.5000207@wpkg.org>
 <20090803235920.C13173@mccme.ru>
 <87my3y3r8u.fsf@faran.nsc.liu.se>
 <3d0408630910111543t23bdf6c3u2274efc65f0fe06c@mail.gmail.com>
 <4AD2E3CF.6080701@wpkg.org>
 <20091012124726.GL2632@think>
 <87my3urf75.fsf@fftw.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="456aVgooXMVMmq4R"
Cc: linux-btrfs@vger.kernel.org
To: Matteo Frigo <athena@fftw.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <87my3urf75.fsf@fftw.org>
List-ID: <linux-btrfs.vger.kernel.org>


--456aVgooXMVMmq4R
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Oct 13, 2009 at 08:29:02PM -0400, Matteo Frigo spake thusly:
> Chris Mason <chris.mason@oracle.com> writes:
>=20
> > Please keep in mind this is only a limit on the number of links to a
> > single file where the links and the file are all in the same directory.
>=20
> For the record, the nnmaildir mail backend in Gnus (an Emacs package
> for reading news and email) creates multiple hardlinks to the same
> file in the same directory.  I had several thousands hardlinks at one
> time.

I just found out that my company uses BackupPC for backups. It uses
hard links extensively:

Features include:

    * A clever pooling scheme minimizes disk storage and disk
      I/O. Identical files across multiple backups of the same or
      different PC are stored only once (using hard links), resulting
      in substantial savings in disk storage and disk writes.

"clever" indeed. It creates filesystems with zillions of inodes which
are a pain to work with. This is the sort of large storage application
I would be looking to use btrfs for and apparently the currently
implementation would croak.

--=20
Tracy Reed
http://tracyreed.org

--456aVgooXMVMmq4R
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.5 (GNU/Linux)

iD8DBQFK12Id9PIYKZYVAq0RAmzJAKCOVzc2SwZyjhpbiouTBzB8fAHuKACaA9pG
0CEC058LgjIDUo2svMHVQhQ=
=vdsX
-----END PGP SIGNATURE-----

--456aVgooXMVMmq4R--
