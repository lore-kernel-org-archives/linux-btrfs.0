From: "Brian J. Murrell" <brian@interlinx.bc.ca>
Subject: Re: filesystem full when it's not?  out of inodes?  huh?
Date: Sun, 26 Feb 2012 01:14:21 -0500
Message-ID: <jiciju$imf$1@dough.gmane.org>
References: <jic3e1$gpe$1@dough.gmane.org> <4F499498.1040006@gmail.com> <jicgtv$bg2$1@dough.gmane.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enigB60FA5E5CBAF00440C1F6D9A"
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <jicgtv$bg2$1@dough.gmane.org>
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigB60FA5E5CBAF00440C1F6D9A
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 12-02-26 12:45 AM, Brian J. Murrell wrote:
>=20
> So I guess I need a 50G btrfs filesystem for 2.8G worth of data?

Interestingly enough, I was able to resize the filesystem back down to
5G after all of that:

# btrfs fi resize 5G /usr; df -h /usr
Resize '/usr' of '5G'
Filesystem            Size  Used Avail Use% Mounted on
/dev/mapper/rootvol-mint_usr
                      5.0G  2.8G  952M  75% /usr

Of course I have not done any integrity checking on the data in the
filesystem to be sure this resize was as successful as it's making out
to be.

Cheers,
b.



--------------enigB60FA5E5CBAF00440C1F6D9A
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iEYEARECAAYFAk9Jzb0ACgkQl3EQlGLyuXBarQCfcUO3gUxxk4dzdyJsSGpV5bZ7
QkMAoI8HJrYvM/1doRmzo2jlfQAC0QfG
=Eaim
-----END PGP SIGNATURE-----

--------------enigB60FA5E5CBAF00440C1F6D9A--

