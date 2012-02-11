From: Roman Mamedov <rm@romanrm.ru>
Subject: Re: Freeing space over reboot question
Date: Sat, 11 Feb 2012 19:56:32 +0600
Message-ID: <20120211195632.59931608@natsu>
References: <20120209174232.318280@gmx.net>
	<20120210002055.6819f76c@natsu>
	<20120211134715.200530@gmx.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/t2TZTGxwBkUpL0nw.LOcXqQ"; protocol="application/pgp-signature"
Cc: linux-btrfs@vger.kernel.org
To: "Norbert Scheibner" <scno@gmx.net>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20120211134715.200530@gmx.net>
List-ID: <linux-btrfs.vger.kernel.org>

--Sig_/t2TZTGxwBkUpL0nw.LOcXqQ
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Sat, 11 Feb 2012 14:47:15 +0100
"Norbert Scheibner" <scno@gmx.net> wrote:

> Have You tried it Yourself? I think the problem was the remount
> before the space has been completely freed in background. It
> left a valid and working fs, with still work to do.

Yes, after some snapshot deletions the umount takes a really long time.

> In my opinion the kernel should either stall the umount till the
> space is given free

In my experience it seemed to do just that.

--=20
With respect,
Roman

~~~~~~~~~~~~~~~~~~~~~~~~~~~
"Stallman had a printer,
with code he could not see.
So he began to tinker,
and set the software free."

--Sig_/t2TZTGxwBkUpL0nw.LOcXqQ
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEARECAAYFAk82c5AACgkQTLKSvz+PZwjZhACffeVjXs+U+rtd6r4Fy7Z4z6ET
Q6wAn2RBu9iaY7i511T8L8MTETNhBqPY
=KS36
-----END PGP SIGNATURE-----

--Sig_/t2TZTGxwBkUpL0nw.LOcXqQ--
