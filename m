Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from meiko.romanrm.net ([195.154.92.155]:59164 "EHLO
	meiko.romanrm.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756117AbbIYNnE (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 25 Sep 2015 09:43:04 -0400
Date: Fri, 25 Sep 2015 18:43:00 +0500
From: Roman Mamedov <rm@romanrm.net>
To: Rich Freeman <r-btrfs@thefreemanclan.net>
Cc: Austin S Hemmelgarn <ahferroin7@gmail.com>, Sjoerd <sjoerd@sjomar.eu>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Subject: Re: Latest kernel to use?
Message-ID: <20150925184300.1d67254b@natsu>
In-Reply-To: <CAGfcS_nFn=AH6Y-4dFQEmy42KVJLBvLuaEHRtoYrBDUtNategw@mail.gmail.com>
References: <4362384.AA8xu4anSN@hoefnix>
	<56052E0D.3090702@gmail.com>
	<CAGfcS_nFn=AH6Y-4dFQEmy42KVJLBvLuaEHRtoYrBDUtNategw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/xwAkMO4UMUTFKitUS3H9Hxg"; protocol="application/pgp-signature"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

--Sig_/xwAkMO4UMUTFKitUS3H9Hxg
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Fri, 25 Sep 2015 09:12:15 -0400
Rich Freeman <r-btrfs@thefreemanclan.net> wrote:

> I'll just say that my btrfs stability has gone WAY up when I stopped
> following this advice and instead followed a recent longterm.  Right
> now I'm following 3.18.  There were some really bad corruption issues
> in 3.17/18/19 that burned me, and today while considering moving up to
> 4.1 I'm still seeing a lot of threads about issues during balance/etc.
> I still run into the odd issue with 3.18, but not nearly to the degree
> that I used to.
>=20
> Now, I would stick with a recent longterm.  The older longterms go
> back to a time when btrfs was far more experimental.  Even 3.16
> probably has a lot of issues that are fixed in 3.18.

Absolutely that! I was pondering whether or not to chime in with my praise =
of
"longterm" as far as Btrfs stability goes, but apparently it's not just me =
who
uses it. In my experience 3.18 just works* and is very stable, and before t=
hat
it was 3.14, which by luck(?) happened to go longterm IIRC just before Btrfs
transitioned to "kernel worker threads" in 3.15 (and that caused ALL sorts =
of
trouble initially).

[*] at least in a relatively simple scenario -- with snapshots, but without
using any of the multi-device features or stuff such as qgroups or
send/receive.

--=20
With respect,
Roman

--Sig_/xwAkMO4UMUTFKitUS3H9Hxg
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iEYEARECAAYFAlYFT2QACgkQTLKSvz+PZwiKTwCeNvnQ3uI6kozJi7kYIUOSBi9p
pCUAnRLwqKLjzJtYWc0IRDCc6O4pzkHH
=CCzp
-----END PGP SIGNATURE-----

--Sig_/xwAkMO4UMUTFKitUS3H9Hxg--
