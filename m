From: Martin Steigerwald <ms@teamix.de>
Subject: btrfs-tools backport for Debian Lenny
Date: Wed, 17 Feb 2010 16:32:37 +0100
Message-ID: <201002171632.38310.ms@teamix.de>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="nextPart3893830.zBPlv6H8Oo";
	protocol="application/pgp-signature"; micalg=pgp-sha1
Cc: Daniel Baumann <daniel@debian.org>, backports-users@lists.backports.org
To: linux-btrfs@vger.kernel.org
Return-path: <backports-users-bounces@lists.backports.org>
List-Unsubscribe: <http://lists.backports.org/mailman/listinfo/backports-users>,
	<mailto:backports-users-request@lists.backports.org?subject=unsubscribe>
List-Archive: <http://lists.backports.org/lurker/list/backports-users.html>
List-Post: <mailto:backports-users@lists.backports.org>
List-Help: <mailto:backports-users-request@lists.backports.org?subject=help>
List-Subscribe: <http://lists.backports.org/mailman/listinfo/backports-users>,
	<mailto:backports-users-request@lists.backports.org?subject=subscribe>
Errors-To: backports-users-bounces@lists.backports.org
List-ID: <linux-btrfs.vger.kernel.org>

--nextPart3893830.zBPlv6H8Oo
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

Cc'd backports-users mailing list, cc'd package maintainer Daniel Baumann a=
s=20
well.


Hi!

JFYI - most of you might prefer to run btrfs-tools from git -, I made a=20
btrfs-tools 0.19 backport for Debian Lenny from the package in Debian Squee=
ze=20
and put it online at:

http://people.teamix.net/~ms/debian/lenny-backports/btrfs-tools/

You can find discussion on sponsoring it here:

http://lists.backports.org/lurker-bpo/thread/20100217.143508.41736c9f.en.ht=
ml

I think it won't work with the latest backports 2.6.30 kernel due to btrfs=
=20
format changes, I test it with a self compiled 2.6.32.3. A 2.6.32 for=20
backports org should be due soon and then my btrfs-tools backport might=20
appear in the bpo archive as well.

It basically works, but I am wondering it the RAID options work correctly. =
I=20
used:

mkfs.btrfs -d raid1 -m=20
raid1 /dev/mango1/homelokal1 /dev/mango2/homelokal2

on two 200 GiB logical volumes and get=20

mango:~# df -hT /mnt/zeit
Dateisystem   Typ    Gr=F6=DFe Benut  Verf Ben% Eingeh=E4ngt auf
/dev/mapper/mango1-homelokal1
             btrfs    400G  101M  400G   1% /mnt/zeit

Shouldn't that be 200GiB for a BTRFS Raid 1 setup?

Ciao,
=2D-=20
Martin Steigerwald - team(ix) GmbH - http://www.teamix.de
gpg: 19E3 8D42 896F D004 08AC A0CA 1E10 C593 0399 AE90

--nextPart3893830.zBPlv6H8Oo
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAkt8DBYACgkQHhDFkwOZrpDX1QCfSPzpuqOZf4HXd3w6RQwVP3AM
h1QAmgJiqoA6BNugjcAyDz+tfamTohTX
=hPe7
-----END PGP SIGNATURE-----

--nextPart3893830.zBPlv6H8Oo--
