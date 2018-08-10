Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.22]:37099 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727598AbeHJK2h (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 10 Aug 2018 06:28:37 -0400
Subject: Re: Mount stalls indefinitely after enabling quota groups.
To: Dan Merillat <dan.merillat@gmail.com>, BTRFS <linux-btrfs@vger.kernel.org>
References: <CAPL5yKfaoujn4gOcejJKwvXHhnuRgFLACKHxxy=bXQz0tE0YMA@mail.gmail.com>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <06f0c899-bb33-54d5-8a87-20f138642f70@gmx.com>
Date: Fri, 10 Aug 2018 15:59:49 +0800
MIME-Version: 1.0
In-Reply-To: <CAPL5yKfaoujn4gOcejJKwvXHhnuRgFLACKHxxy=bXQz0tE0YMA@mail.gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="wWmlGU3G3QI1YtGeRmMDob3o5TWCNPhDL"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--wWmlGU3G3QI1YtGeRmMDob3o5TWCNPhDL
Content-Type: multipart/mixed; boundary="9Fs6npsLioK7xAKggKn3P8B5EDhBHBYMr";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: Dan Merillat <dan.merillat@gmail.com>, BTRFS <linux-btrfs@vger.kernel.org>
Message-ID: <06f0c899-bb33-54d5-8a87-20f138642f70@gmx.com>
Subject: Re: Mount stalls indefinitely after enabling quota groups.
References: <CAPL5yKfaoujn4gOcejJKwvXHhnuRgFLACKHxxy=bXQz0tE0YMA@mail.gmail.com>
In-Reply-To: <CAPL5yKfaoujn4gOcejJKwvXHhnuRgFLACKHxxy=bXQz0tE0YMA@mail.gmail.com>

--9Fs6npsLioK7xAKggKn3P8B5EDhBHBYMr
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 8/10/18 3:40 PM, Dan Merillat wrote:
> Kernel 4.17.9, 11tb BTRFS device (md-backed, not btrfs raid)
>=20
> I was testing something out and enabled quota groups and started gettin=
g
> 2-5 minute long pauses where a btrfs-transaction thread spun at 100%.

Looks pretty like a running balance and quota.

Would you please try with balance disabled (temporarily) with
skip_balance mount option to see if it works.

If it works, then either try resume balance, or just cancel the balance.

Nowadays balance is not needed routinely, especially when you still have
unallocated space and enabled quota.

Thanks,
Qu

>=20
> Post-reboot the mount process spinds at 100% CPU, occasinally yielding
> to a btrfs-transaction thread at 100% CPU.  The switchover is marked
> by a burst of disk activity in btrace.
>=20
> Btrace shows all disk activity is returning promptly - no hanging submi=
ts.
>=20
> Currently the mount is at 6+ hours.
>=20
> Suggestions on how to go about debugging this?
>=20


--9Fs6npsLioK7xAKggKn3P8B5EDhBHBYMr--

--wWmlGU3G3QI1YtGeRmMDob3o5TWCNPhDL
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEELd9y5aWlW6idqkLhwj2R86El/qgFAlttRfUACgkQwj2R86El
/qgvfAf/UXyyvaqX5SkrwnhXfUCzUzMu42528DtQAutXN8hVy5ciAFfGuRIj4Rf7
cv0yQgHdWySApydBeKC/iPEWMARvAnlGN8PX2H0zYpPe50SkMNHZR+xTs1obnokf
0Uf6HTXVYOHbTYGPINrMcZTxetX2i30PaUWVCAAfaxuAda7RRvldNkfnp49Nj1eq
z7GD7SEkjG2u73EGaBXvgE59mcjSjUjABaj1YV2h0K3ysP/s4Tz2koM39RDRHFWw
relqUeRa4pPjIKYnv1fNMKLgbG/QJPh/QQT02f9p9hRD/e36m2p3nSfol0DGOMBw
GqHiSzByzfDJ4WgaKBGn3lEe3mBqNQ==
=qVZK
-----END PGP SIGNATURE-----

--wWmlGU3G3QI1YtGeRmMDob3o5TWCNPhDL--
