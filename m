From: "Brian J. Murrell" <brian@interlinx.bc.ca>
Subject: Re: subvolume nomenclature
Date: Fri, 02 Mar 2012 14:44:53 -0500
Message-ID: <jir7vn$3uc$1@dough.gmane.org>
References: <jiqi3l$d4k$1@dough.gmane.org> <CAE5mzvhsb+O6xEvpOW5nh7iLgk5M+mgFD_ASVCpM0P==LSANqQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enigE443C62B63A84FF7510D90A3"
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <CAE5mzvhsb+O6xEvpOW5nh7iLgk5M+mgFD_ASVCpM0P==LSANqQ@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigE443C62B63A84FF7510D90A3
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On 12-03-02 08:36 AM, cwillu wrote:
>=20
> Try btrfs sub delete /etc/apt/oneiric, assuming that that's the path
> where you actually see it.

Well, there is a root filesystem at /etc/apt/oneiric:

# ls /etc/apt/oneiric/
bin   etc         initrd.img.old  mnt   root  selinux  tmp  vmlinuz
boot  home        lib             opt   run   srv      usr  vmlinuz.old
dev   initrd.img  media           proc  sbin  sys      var

but it doesn't delete:

# btrfs subvolume delete /etc/apt/oneiric
Delete subvolume '/etc/apt/oneiric'
ERROR: cannot delete '/etc/apt/oneiric' - Device or resource busy

and doesn't unmount:

# umount /etc/apt/oneiric
umount: /etc/apt/oneiric: not mounted

Cheers,
b.


--------------enigE443C62B63A84FF7510D90A3
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iEYEARECAAYFAk9RIzYACgkQl3EQlGLyuXC39wCg1fMo+DFlz1445zg5Kd3RocFB
3sEAoPtiL9SsKKx2gNn+RGIYLuBnQI8Z
=xaJz
-----END PGP SIGNATURE-----

--------------enigE443C62B63A84FF7510D90A3--

