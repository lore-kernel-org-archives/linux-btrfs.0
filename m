From: Ben Hutchings <ben@decadent.org.uk>
Subject: Re: Bug#624131: linux-image-2.6.39-rc4-686-pae: Can somewhat
 reliably produce kernel panic in btrfs code
Date: Tue, 26 Apr 2011 04:59:03 +0100
Message-ID: <1303790343.3032.352.camel@localhost>
References: <BANLkTikiVMbH0BU4xTZirNDUu=GhG0ooyg@mail.gmail.com>
	 <1303762526.3032.296.camel@localhost>
	 <BANLkTikyqs0Zx-V+0+431fEAA-XWsGo73g@mail.gmail.com>
	 <20110425205008.11135.qmail@stuge.se>
	 <BANLkTi=VMW1bsOduH2Xn27NUQkpHiHngqw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha512"; protocol="application/pgp-signature"; boundary="=-JySlvyllXgDebeB1SlVu"
Cc: Maik Zumstrull <maik@zumstrull.net>, 624131@bugs.debian.org,
	linux-btrfs@vger.kernel.org, cwillu <cwillu@cwillu.com>
To: Chris Mason <chris.mason@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <BANLkTi=VMW1bsOduH2Xn27NUQkpHiHngqw@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>


--=-JySlvyllXgDebeB1SlVu
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, 2011-04-25 at 15:05 -0600, cwillu wrote:
> On Mon, Apr 25, 2011 at 2:50 PM, Peter Stuge <peter@stuge.se> wrote:
> > Maik Zumstrull wrote:
> >> >> Bug at fs/btrfs/free-space-cache.c:1246
> >> >> Bug type: invalid opcode: 0000
> >> >> Kernel not tainted, running on an ASUSTek 1005HAG
> >> >> EIP is at btrfs_add_free_space+0x285/0x39a [btrfs]
> >> >
> >> > You will probably need to provide a more complete copy of the panic
> >> > message.
> >>
> >> I thought as much, but other than taking a picture of the screen, I
> >> don't know how.
> >
> > Take a picture and ideally transcribe it after reboot.
>=20
> Known issue;  josef sent a patch
> (http://permalink.gmane.org/gmane.comp.file-systems.btrfs/10261) that
> should fix it, or you can mount with clear_cache on each boot as a
> workaround.

This fix doesn't seem to be in your for-linux branch yet.  Please can
you ensure that this (or an alternate fix) is included in 2.6.39.

Ben.

--=20
Ben Hutchings
Once a job is fouled up, anything done to improve it makes it worse.

--=-JySlvyllXgDebeB1SlVu
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIVAwUATbZDB+e/yOyVhhEJAQpQixAAodOHCCPXZnK+lzwCP9YG41v190VZmc7u
Rq1bP6X0AVTcnjfEqP653CfkbPFtqsyadKMhlcR63ALj5gndJFrrtQgYAoXNPEmC
uDgnHeP8nvVttRHkUi2iSBO1+qlFaXl3wPX9ztLoOl7Uuvy8eEDOT++md3hsE1GY
6qUxmyoqKfXVXezDPLeK1nRwx68Igwt8ndMTKIS149gof3Rlo/3E+RnDswgizKph
pUOu/rEr0gNp5XMLQWln9YXbES3muddkXDKR0CSAajY+KZTF3LoM68piOhY9XeFT
ogvQNA1L+SkvhbX/k5BsFRfCEUgp0YGedfIj9BsOXZgiPTzKx7vC/GWLWzcz470B
J6Je7fzpYE7QIJ55m9lL+AC6NpSdTdYJxYMrXGFSK7tkoFvhuyf4S1Spby6kWOBN
ODgMeVcBf8H+WlZyPU4J/fep1vxcsVscx2K1IwIo9qHViBK9zPnwYmDhYS+wGqQ+
D6QqrPSfYHyJQf41DRCoqQN0ZtFAylyEDxRnLcS54IIhuRiPd4f3yR0Z66/kI0d5
eooInkQqiZ9uxJWjMPHj6+t7Jc9KklVhlxugkyAZlKRZv32nrvG3qhqpY+nwRf1Q
PKSfKEKuXz56rW3X0mdBZulDBKcJ/K1ZjA0fEnrVwUA4i1dIs33t0uqCGoBEnl6W
Sg60uqXL6jA=
=sa2n
-----END PGP SIGNATURE-----

--=-JySlvyllXgDebeB1SlVu--
