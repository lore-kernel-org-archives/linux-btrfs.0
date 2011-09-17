From: Roman Mamedov <rm@romanrm.ru>
Subject: Re: Raid0 and drive failure.
Date: Sat, 17 Sep 2011 21:05:56 +0600
Message-ID: <20110917210556.051909f6@natsu>
References: <CAC_HdUrrEzUYp3K=ZAG9sQK=6totXmoy5FswGg=huTuxb6vtnw@mail.gmail.com>
	<CAAeznTp1eX8m--Mw-RFNY8VmU8O08kRNQeOmHAZo=cGNxvV7Tg@mail.gmail.com>
	<CAC_HdUrh+LhBfHTMKE8VTkuwEgJbcX2mBP3pJFYivk228-VctA@mail.gmail.com>
	<20110916151044.GF11031@carfax.org.uk>
	<CAC_HdUrxn__yW5o024iMZXdJaO0Kge6eav8fhZrTCrhicmTx2A@mail.gmail.com>
	<20110917113640.GA21530@carfax.org.uk>
	<CAC_HdUrwBYgVMGiFA8dHM5X=QSksQ37iyEWSSyDipqoKKTYEsw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/bhbkUT/LKCVGcWnZYoeg2Dg"; protocol="application/pgp-signature"
Cc: Hugo Mills <hugo@carfax.org.uk>,
	Leonidas Spyropoulos <artafinde@gmail.com>,
	linux-btrfs@vger.kernel.org
To: Henti Smith <henti@geekware.co.za>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <CAC_HdUrwBYgVMGiFA8dHM5X=QSksQ37iyEWSSyDipqoKKTYEsw@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

--Sig_/bhbkUT/LKCVGcWnZYoeg2Dg
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Sat, 17 Sep 2011 16:10:44 +0200
Henti Smith <henti@geekware.co.za> wrote:

> At it's core I'm looking for a way to do something similar windows
> drive extender that allows you to pool your drives without loosing all
> your data when one drive is lost.

Use mhddfs: http://romanrm.ru/en/mhddfs
Only one drive's files are lost when that drive fails, the rest will be com=
pletely intact.

--=20
With respect,
Roman

--Sig_/bhbkUT/LKCVGcWnZYoeg2Dg
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEARECAAYFAk50t1QACgkQTLKSvz+PZwiaigCeKO7YQVlUMxnRPwew7jeCRCM+
RkMAn3tohZjD66tU3bf1btp1gFuit0YO
=7cY7
-----END PGP SIGNATURE-----

--Sig_/bhbkUT/LKCVGcWnZYoeg2Dg--
