From: Ben Hutchings <ben@decadent.org.uk>
Subject: Re: Bug#624131: linux-image-2.6.39-rc4-686-pae: Can somewhat
 reliably produce kernel panic in btrfs code
Date: Mon, 25 Apr 2011 21:15:26 +0100
Message-ID: <1303762526.3032.296.camel@localhost>
References: <BANLkTikiVMbH0BU4xTZirNDUu=GhG0ooyg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha512"; protocol="application/pgp-signature"; boundary="=-XQ13NExDGyC+4CegyQbh"
Cc: 624131@bugs.debian.org, linux-btrfs@vger.kernel.org
To: Maik Zumstrull <maik@zumstrull.net>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <BANLkTikiVMbH0BU4xTZirNDUu=GhG0ooyg@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>


--=-XQ13NExDGyC+4CegyQbh
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, 2011-04-25 at 22:05 +0200, Maik Zumstrull wrote:
> Package: linux-image-2.6.39-rc4-686-pae
> Version: 2.6.39~rc4-1~experimental.1
> Severity: normal
> Tags: experimental
>=20
> By simply stressing the system with some I/O, I can make it crash within
> seconds. I'm not setting a higher severity because the bug is in an
> experimental file system in an experimental kernel.

I assume this doesn't happen in 2.6.38?

> Here's the important bits (by my guess) I have on screen from the kernel =
panic:
>=20
> Bug at fs/btrfs/free-space-cache.c:1246
> Bug type: invalid opcode: 0000
> Kernel not tainted, running on an ASUSTek 1005HAG
> EIP is at btrfs_add_free_space+0x285/0x39a [btrfs]

You will probably need to provide a more complete copy of the panic
message.  Let's see what the btrfs developers say.

Ben.

--=20
Ben Hutchings
Once a job is fouled up, anything done to improve it makes it worse.

--=-XQ13NExDGyC+4CegyQbh
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIVAwUATbXWXee/yOyVhhEJAQoUAw//dIybiHgQBGsXcEQ+ZcTqqEL7/tcgQkTM
RgjWVgK8ayKexe50QoNrMALJWrNWM6JLpmSoypC+034KvA6Sv3YJR3H31IUUjIWF
LKyD6v5cLP0kOiyVMsOf1TEK3L+28pFghaV6OmFrA6VykTYYj8+Hyad4UcQpldsq
qC2AnmKaWPEuxRUXy+Zy4QRBXhv3wYZ43Elha6pgk5xkLrPnvW8w9Y2TSpZExIkQ
pH61q3EPQ2jXdcwdouFz+qs6eFTuWl6rcmFIrebwXI71NnDu8PW3JEW0sQdjsNUR
kaUgzMlMRYtCL1HBaIAp8kcReRftmlLUBhjsnALnEUhcGgnYdd2JlYUzKGnaLGoM
5UweN6nqNqoo2HgJR2DAY5wCbOo4DY16dq2US5zm5XKO7vh4u1NDM/KiI+wRmg+W
vkEFmzlM2fx9hLocWUh6Y5mYCmajF9DEOViFh2bMooo33o4bFxVwBqYzj+/Pu1Di
GmqdHIaFB9xOi+fH73F0YEihyRA/BovSpq6NHN3GzEkzb1sd8YW0Es1sdfCENibx
9MXVHOcIOMEdSsBqMVAhvxfewGD/QWLF3UKvFAJdscvGKM4n7dhTD/ArQ9l0uiL7
MKNK+KVSqnsK5J2vqZFjFYP/nah+5jTXwZL0il0fTNEYmYiw2H73xlCGaKumlnmG
HN2NLOPY8EM=
=PPl9
-----END PGP SIGNATURE-----

--=-XQ13NExDGyC+4CegyQbh--
