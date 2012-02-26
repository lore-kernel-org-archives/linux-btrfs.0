From: "Brian J. Murrell" <brian@interlinx.bc.ca>
Subject: Re: filesystem full when it's not? out of inodes? huh?
Date: Sun, 26 Feb 2012 14:43:34 -0500
Message-ID: <4F4A8B66.4060009@interlinx.bc.ca>
References: <jic3e1$gpe$1@dough.gmane.org> <4F499498.1040006@gmail.com> <jicgtv$bg2$1@dough.gmane.org> <jiciju$imf$1@dough.gmane.org> <CALJXSJrhyOYoU-g-NOnj=1NfqryaCTZav6mBN-Qc_X2mSpx0qQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig5CB614F39842EB46D4CD0C01"
Cc: linux-btrfs@vger.kernel.org
To: unlisted-recipients:; (no To-header on input)
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <CALJXSJrhyOYoU-g-NOnj=1NfqryaCTZav6mBN-Qc_X2mSpx0qQ@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig5CB614F39842EB46D4CD0C01
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On 12-02-26 02:19 AM, J=C3=A9r=C3=B4me Poulin wrote:
>=20
> What would be interesting is getting an eye on btrfs fi df of your
> filesystem to see what part is getting full, or maybe just do a
> balance.

I did try a balance.  As I had mentioned subsequently, I ended up having
to grow the filesystem to 10x (somewhere between 20 and 50GB) it's data
requirement in order to get that kernel headers .deb to unpack, and
after it unpacked I was successful in shrinking back down to 5G, so it
seems the problem was something worse than just "not ideal" metadata
allocation.

> I have been running 3.0.0 for quite a while without any problem,
> metadata grew a bit too much (1.5 TB for 2 TB of data) and balance
> fixed it back to 50 GB of metadata then 20 GB after deleting some
> snapshots.

Interesting data point, thanks.

b.




--------------enig5CB614F39842EB46D4CD0C01
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iEYEARECAAYFAk9Ki2YACgkQl3EQlGLyuXCHygCfb7F4Ol6JqVKHdipfxPVkke5J
FjoAoOcZAve+PNLitPX/4M5z9f8RR5eP
=NNy1
-----END PGP SIGNATURE-----

--------------enig5CB614F39842EB46D4CD0C01--
