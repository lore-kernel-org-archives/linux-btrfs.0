Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.20]:60313 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751648AbeFTGod (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 20 Jun 2018 02:44:33 -0400
Subject: Re: About commit f8f84b2dfda5 ("btrfs: index check-integrity state
 hash by a dev_t")
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: Liu Bo <bo.liu@linux.alibaba.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
        David Sterba <dsterba@suse.cz>
References: <6c249625-8cb9-c220-a145-b5fec7d6caf4@gmx.com>
Message-ID: <aed008d4-b56a-b658-870a-610b68b925db@gmx.com>
Date: Wed, 20 Jun 2018 14:44:15 +0800
MIME-Version: 1.0
In-Reply-To: <6c249625-8cb9-c220-a145-b5fec7d6caf4@gmx.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="QmNW3PWfzOunlCYEVaqNb0iKFm6v8rSpV"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--QmNW3PWfzOunlCYEVaqNb0iKFm6v8rSpV
Content-Type: multipart/mixed; boundary="xkDkxEBwtif8wM56W8bTMSSOaI7eKag4J";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: Liu Bo <bo.liu@linux.alibaba.com>,
 "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
 David Sterba <dsterba@suse.cz>
Message-ID: <aed008d4-b56a-b658-870a-610b68b925db@gmx.com>
Subject: Re: About commit f8f84b2dfda5 ("btrfs: index check-integrity state
 hash by a dev_t")
References: <6c249625-8cb9-c220-a145-b5fec7d6caf4@gmx.com>
In-Reply-To: <6c249625-8cb9-c220-a145-b5fec7d6caf4@gmx.com>

--xkDkxEBwtif8wM56W8bTMSSOaI7eKag4J
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2018=E5=B9=B406=E6=9C=8820=E6=97=A5 14:36, Qu Wenruo wrote:
> Hi Liu and David,
>=20
> I see mainline kernel merged commit f8f84b2dfda5 ("btrfs: index
> check-integrity state hash by a dev_t"), and you reviewed it but I can'=
t
> find the mail in mail list, nor it's signed by David.
>=20
> Is this btrfs related commit merged without review from btrfs community=
?
> (Well, at least Liu reviewed it, but at least the mail is not CCed to
> btrfs mail list)
>=20
> And in fact this patch is causing check_int mount option fail to mount
> any fs degraded, by triggering a NULL pointer de-reference.
>=20
> Since in btrfsci_map_block() device->bdev can be NULL for missing
> device, no wonder device->bdev->bd_dev will trigger a NULL pointer
> dereference.
>=20
> I'm planning to fix the problem by using devid, but I'm a little
> surprised that such patch is not even CCed to btrfs mail list.


I'm just an idiot, my MUA cleaned up mails before 2017/09, no wonder I
failed to find that mail.

Thanks,
Qu

>=20
> Thanks,
> Qu
>=20


--xkDkxEBwtif8wM56W8bTMSSOaI7eKag4J--

--QmNW3PWfzOunlCYEVaqNb0iKFm6v8rSpV
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEELd9y5aWlW6idqkLhwj2R86El/qgFAlsp978ACgkQwj2R86El
/qieMwf/fOyZL7CAHKkxtTV5PKqz7Xga5nAgxLce5g6VoeKZQbQ6vV9GoK2rutwF
9o++6ywX8aPQfTyLz+QZOmVsN3hGS3+x9bKkDzz94Z0R+xhZZFeapX1vmb+2VbhG
S6zaSVoOZqWSa0rTCBC1o8Sr61AO/bpcXqbMJxAF7cN8CkG7aU3WHcG1pJEwjxTF
1rON9CCksXSxpP5zQVqx4LnL68ZSExuZBoysZTrwH9Tnl3qT8qMPPhQCI0hTdDdy
5JB2H7290Ds8j/05liiikQdYLYPCeezrlH7CoFXXRJ58gE10OmRPL/yJpCfgTXg9
6MNgT7xDMA/P5wrygC0GpknBTIZpEQ==
=H98R
-----END PGP SIGNATURE-----

--QmNW3PWfzOunlCYEVaqNb0iKFm6v8rSpV--
