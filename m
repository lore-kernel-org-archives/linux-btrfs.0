From: Maciej Marcin Piechotka <uzytkownik2@gmail.com>
Subject: Re: kernel BUG at fs/btrfs/inode.c:2299
Date: Fri, 09 Sep 2011 04:29:15 +0100
Message-ID: <1315538955.1957.7.camel@picard>
References: <1314582311.2724.4.camel@picard>
	 <4E5C82E8.9090400@cn.fujitsu.com> <1315530824.1957.4.camel@picard>
	 <20110909090211.50c35c0f@natsu>
Reply-To: uzytkownik2@gmail.com
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-ripemd160";
	protocol="application/pgp-signature"; boundary="=-plWHgAHkUVorQE1ouUnt"
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20110909090211.50c35c0f@natsu>
List-ID: <linux-btrfs.vger.kernel.org>


--=-plWHgAHkUVorQE1ouUnt
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, 2011-09-09 at 09:02 +0600, Roman Mamedov wrote:
> On Fri, 09 Sep 2011 02:13:38 +0100
> Maciej Marcin Piechotka <uzytkownik2@gmail.com> wrote:
>=20
> > c) It usually happens a few minutes past 3 UTC. I have no idea what is
> > casuing this but it is consistent.
>=20
> Did you check if your /etc/crontab or /etc/cron.d/* have anything schedul=
ed for that time?
>=20

It does:
 - logrotate (configured to do it weekly in /etc/logrotate)
 - makewhatis -u

Neither of which should touch /home. Before it snapshotted the volume
and I thought it was the direct cause.

Best regards

--=-plWHgAHkUVorQE1ouUnt
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIcBAABAwAGBQJOaYgLAAoJEJIdee2Vr4aP9pQP/3AZuNrk3CeHijaNXov/EPp9
IRZxWkLURevhO+FNJDNBHz2iOB+nCUNZJu7wegU+r9onRoMmMTx9fgIGPa00HHyt
s95qTdU00RC5zCPJUKioCO2NcCZ+Jjj+9X+g3IhRq7JUoFFSc3FL8C7G0XAGzDxP
icC5Zm473iY+VVFV3fxa0Lg1+MK7aTiMCkpcedKU7TrQTnjAzh8t9Vs9Mi8DtQPO
uhS8EjRaINSju4Tr568RQBrSE0Ii0CBk5cSXwNZczQh4A1+26ppXBYnXS3sb69IE
XLfroNDBXDYM7O/gUxabEaEoKdV5YVVFckHL5ydH3pRtTPGdBrS/TAsCTGCFbNu+
G46Ui+a5/ulqBVRt6g9ZGXROv2CzbE2thNv7OVfzYUT6K5FUjrbeCweYwVSxA38N
koT/Sbm1yCwmO1sVdxl1qb+IzpdJsxgUnvUPPaav6P57ZJJH2zM8AeizJHbW/J8F
5pZn/Y81WFlX29vCy3nF5tY8UUNA9/gxKlo3NmTbKNiSYO1rny2gf7fLvX/z8ep4
qQo3WDIc89mqXvO2tg+3clxEm1BSw82rwMw0NBNBEK1RQG/iLhamOvbzU84mIcBZ
J2FJ0fsJDdP/G7fFcQYESGkeA8E9TDNoMVn40fb9CXg9o9NGm4d+VJxslqFlIJKi
A/XhZkPF8G2/d1j67wCm
=ahyz
-----END PGP SIGNATURE-----

--=-plWHgAHkUVorQE1ouUnt--


