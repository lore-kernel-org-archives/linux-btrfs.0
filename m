From: Roman Mamedov <rm@romanrm.ru>
Subject: Re: kernel BUG at fs/btrfs/inode.c:2299
Date: Fri, 9 Sep 2011 09:02:11 +0600
Message-ID: <20110909090211.50c35c0f@natsu>
References: <1314582311.2724.4.camel@picard>
	<4E5C82E8.9090400@cn.fujitsu.com>
	<1315530824.1957.4.camel@picard>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/RJfnypsmiTjjZb_FIOlx/K6"; protocol="application/pgp-signature"
Cc: linux-btrfs@vger.kernel.org
To: uzytkownik2@gmail.com
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1315530824.1957.4.camel@picard>
List-ID: <linux-btrfs.vger.kernel.org>

--Sig_/RJfnypsmiTjjZb_FIOlx/K6
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Fri, 09 Sep 2011 02:13:38 +0100
Maciej Marcin Piechotka <uzytkownik2@gmail.com> wrote:

> c) It usually happens a few minutes past 3 UTC. I have no idea what is
> casuing this but it is consistent.

Did you check if your /etc/crontab or /etc/cron.d/* have anything scheduled=
 for that time?

--=20
With respect,
Roman

--Sig_/RJfnypsmiTjjZb_FIOlx/K6
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEARECAAYFAk5pgbMACgkQTLKSvz+PZwgHIwCdHRwluxL65KadAR1FESnAD78E
IHQAnA4CzxznZD2S3RgYfCVB05U90LvH
=c59j
-----END PGP SIGNATURE-----

--Sig_/RJfnypsmiTjjZb_FIOlx/K6--
