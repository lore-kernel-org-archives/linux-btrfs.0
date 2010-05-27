From: Adrian von Bidder <avbidder@fortytwo.ch>
Subject: Re: btrfsck: doesn't correct errors
Date: Thu, 27 May 2010 22:02:43 +0200
Message-ID: <201005272202.44266@fortytwo.ch>
References: <201005271846.16832@fortytwo.ch> <20100527181553.GF25333@dhcp231-156.rdu.redhat.com>
Mime-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1419975.ya2Y4iN4UR";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Cc: linux-btrfs@vger.kernel.org
To: Josef Bacik <josef@redhat.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20100527181553.GF25333@dhcp231-156.rdu.redhat.com>
List-ID: <linux-btrfs.vger.kernel.org>

--nextPart1419975.ya2Y4iN4UR
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

Thanks for taking the time to answer.

(And what I didn't say: as a pure user, for desktop and for the backup=20
appliance mentioned, I'm using btrfs so far without any problems.  I'm not=
=20
hard on it on purpose, but stuff like failed wake-up after suspend to ram=20
does happen occasionally on the laptop.)

cheers
=2D- vbi

On Thursday 27 May 2010 20.15:53 Josef Bacik wrote:
> On Thu, May 27, 2010 at 06:46:04PM +0200, Adrian von Bidder wrote:
> > Heyho!
> >=20
> > (This is using btrfs from Debian's 2.6.32	2.6.32-3-kirkwood kernel (-9
> > package; btrfs tools is v0.19-16-g075587c)
> >=20
> > A few observations about btrfsck:
> >=20
> > a btrfsck run on a 2T volume (4 disks) on a QNAP appliance (512M ram)
> > got killed by Mr. OOM Killer.  Initially, I was quite surprised.  I'm
> > only moderately surprised now since it might well be that I forgot to
> > enable swap.
>=20
> Yes, btrfsck keeps the entire extent tree in memory, so the bigger the
> fs, the more RAM it's going to use.
>=20
> > A btrfsck run (on a remote machine this time, with nbd) showed quite a
> > few errors like:
> > root 268 inode 34001 errors 2000
> > root 268 inode 34002 errors 2000
> > root 268 inode 34074 errors 2000
> > root 268 inode 34102 errors 2000
> > root 268 inode 34103 errors 2000
> > root 268 inode 34104 errors 2000
> > root 268 inode 34132 errors 2000
> > root 268 inode 34133 errors 2000
> >=20
> > 2nd observation: am I supposed to know what this means?
>=20
> No not really, atm it's just for us developers.
>=20
> > And 3rd observation: btrfsck apparently doesn't correct this kind of
> > error. Running btrfsck again still shows the error.
>=20
> Yeah btrfsck doesn't fix problems yet.  Thats being worked on.  Thanks,
>=20
> Josef

=2D-=20
Wenn Windows 98 die Antwort ist, wie bl=F6d ist dann die Frage gewesen?

--nextPart1419975.ya2Y4iN4UR
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)
Comment: get my key from http://fortytwo.ch/gpg/92082481

iKcEABECAGcFAkv+z+NgGmh0dHA6Ly9mb3J0eXR3by5jaC9sZWdhbC9ncGcvZW1h
aWwuMjAwMjA4MjI/dmVyc2lvbj0xLjUmbWQ1c3VtPTVkZmY4NjhkMTE4NDMyNzYw
NzFiMjVlYjcwMDZkYTNlAAoJECqqZti935l6InoAn0IcqAPDNH8y9n5HiaWtm6J5
50ySAJ48id7IP9D9yUYkskmVCkXwKhvtkA==
=ABwe
-----END PGP SIGNATURE-----

--nextPart1419975.ya2Y4iN4UR--
