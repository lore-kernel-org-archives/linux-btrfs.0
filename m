Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.gocept.net ([195.62.125.19]:37042 "EHLO mail.gocept.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752981AbdC0NVQ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 27 Mar 2017 09:21:16 -0400
From: Christian Theune <ct@flyingcircus.io>
Message-Id: <3558CE2F-0B8F-437B-966C-11C1392B81F2@flyingcircus.io>
Content-Type: multipart/signed;
 boundary="Apple-Mail=_D17AE07F-0B47-4A3E-AEC8-49D0F8CEA2BC";
 protocol="application/pgp-signature"; micalg=pgp-sha512
Mime-Version: 1.0 (Mac OS X Mail 10.2 \(3259\))
Subject: Re: Shrinking a device - performance?
Date: Mon, 27 Mar 2017 15:20:37 +0200
In-Reply-To: <20170327130730.GN11714@carfax.org.uk>
Cc: linux-btrfs@vger.kernel.org
To: Hugo Mills <hugo@carfax.org.uk>
References: <1CCB3887-A88C-41C1-A8EA-514146828A42@flyingcircus.io>
 <20170327130730.GN11714@carfax.org.uk>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--Apple-Mail=_D17AE07F-0B47-4A3E-AEC8-49D0F8CEA2BC
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=utf-8

Hi,

> On Mar 27, 2017, at 3:07 PM, Hugo Mills <hugo@carfax.org.uk> wrote:
>=20
>   On my hardware (consumer HDDs and SATA, RAID-1 over 6 devices), it
> takes about a minute to move 1 GiB of data. At that rate, it would
> take 1000 minutes (or about 16 hours) to move 1 TiB of data.
>=20
>   However, there are cases where some items of data can take *much*
> longer to move. The biggest of these is when you have lots of
> snapshots. When that happens, some (but not all) of the metadata can
> take a very long time. In my case, with a couple of hundred snapshots,
> some metadata chunks take 4+ hours to move.

Thanks for that info. The 1min per 1GiB is what I saw too - the =E2=80=9Ci=
t can take longer=E2=80=9D wasn=E2=80=99t really explainable to me.

As I=E2=80=99m not using snapshots: would large files (100+gb) with long =
chains of CoW history (specifically reflink copies) also hurt?

Something I=E2=80=99d like to verify: does having traffic on the volume =
have the potential to delay this infinitely? I.e. does the system write =
to any segments that we=E2=80=99re trying to free so it may have to work =
on the same chunk over and over again? If not, then this means it=E2=80=99=
s just slow and we=E2=80=99re looking forward to about 2 months worth of =
time shrinking this volume. (And then again on the next bigger server =
probably about 3-4 months).

(Background info: we=E2=80=99re migrating large volumes from btrfs to =
xfs and can only do this step by step: copying some data, shrinking the =
btrfs volume, extending the xfs volume, rinse repeat. If someone should =
have any suggestions to speed this up and not having to think in terms =
of _months_ then I=E2=80=99m all ears.)

Cheers,
Christian

--
Christian Theune =C2=B7 ct@flyingcircus.io =C2=B7 +49 345 219401 0
Flying Circus Internet Operations GmbH =C2=B7 http://flyingcircus.io
Forsterstra=C3=9Fe 29 =C2=B7 06112 Halle (Saale) =C2=B7 Deutschland
HR Stendal HRB 21169 =C2=B7 Gesch=C3=A4ftsf=C3=BChrer: Christian. =
Theune, Christian. Zagrodnick


--Apple-Mail=_D17AE07F-0B47-4A3E-AEC8-49D0F8CEA2BC
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename=signature.asc
Content-Type: application/pgp-signature;
	name=signature.asc
Content-Description: Message signed with OpenPGP

-----BEGIN PGP SIGNATURE-----
Comment: GPGTools - https://gpgtools.org

iQEcBAEBCgAGBQJY2RGmAAoJEKuh8lKpfGLOjNQIAJTaBifCkhT1uoJKIr9cFTql
0UHR9VsEJsjY/auGyIeewG5rrsjBvf66b1H9HzO+pYC5t3+z5oplxgCS1Z00TaoT
MZ4zEgTJ6cNpepgC9fbLTSXY9bghRN0MtAhYaDjXfqCYNLRrTlL7HLZM1ng9EeKg
obF23to0ZQ3bAoBAjZRax6Do3eQKba3svJR44utAs0sV1w6jJGCajgHMeQDCbIha
VxsCOEa0RHCzn4HuzJfBUUNf/WArFUIgdnShjzQebtMcSxJdh5IiE7ABEhU8IgEg
D2Vcr6e0K4jxlC3s6d+xiQsiR6MsrAevjHweDRi+ynLj5DV5ngS7j4++eVmhdCc=
=/XVu
-----END PGP SIGNATURE-----

--Apple-Mail=_D17AE07F-0B47-4A3E-AEC8-49D0F8CEA2BC--
