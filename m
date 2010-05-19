From: Bruce Guenter <bruce@untroubled.org>
Subject: Re: Rename+crash behaviour of btrfs - nearly ext3!
Date: Tue, 18 May 2010 19:05:59 -0600
Message-ID: <20100519010559.GA10860@untroubled.org>
References: <4BF18525.8080904@gmail.com>
 <20100517193652.GC8635@think>
 <4BF1DBCD.7060208@gmail.com>
 <20100518003032.GK8635@think>
 <20100518005926.GM8635@think>
 <4BF28225.2000908@gmail.com>
 <20100518131304.GX8635@think>
 <4BF31C29.7080403@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="envbJBWh7q8WU6mo"
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4BF31C29.7080403@redhat.com>
List-ID: <linux-btrfs.vger.kernel.org>


--envbJBWh7q8WU6mo
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, May 18, 2010 at 07:00:57PM -0400, Ric Wheeler wrote:
> Just to weigh in here, I think that you have the right behaviour=20
> already. If an application wants to force this to sync the data to disk,=
=20
> it should use fsync() after the rename.

Actually, it pretty much has to fsync before the rename (to ensure the
contents are on disk) and possibly fsync the directory after to ensure
the rename hits the disk.  If you fsync after the rename, there is still
no guarantee that a crash won't cause partial data on disk with the new
filename, unless you assume the filesystem orders the writes so the
rename happens after the data hits the disk.  AFAIK most filesystems
make no such guarantee.

--=20
Bruce Guenter <bruce@untroubled.org>                http://untroubled.org/

--envbJBWh7q8WU6mo
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.14 (GNU/Linux)

iEYEARECAAYFAkvzOXcACgkQ6W+y3GmZgOgSggCeIvl5qSO1l69yuFQ0XIwdyiLp
iL0AnitaFxj9OtaDP/UTLHVHPW1WA/iH
=vXl1
-----END PGP SIGNATURE-----

--envbJBWh7q8WU6mo--
