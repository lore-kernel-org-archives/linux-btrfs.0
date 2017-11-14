Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.22]:51784 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750734AbdKNFjK (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 14 Nov 2017 00:39:10 -0500
Subject: Re: btrfs check fails with: btrfs_alloc_chunk: BUG_ON `ret`
 triggered, value -28
To: Chris Murphy <lists@colorremedies.com>,
        Omar Sandoval <osandov@osandov.com>,
        Filipe Manana <fdmanana@gmail.com>
Cc: Ben Hooper <ben@ayrton.com.au>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
References: <SY3PR01MB1465C3E1A99997C75685BE0FF9280@SY3PR01MB1465.ausprd01.prod.outlook.com>
 <CAJCQCtTKNL9bjpeZFKU0r99R0kkMB4NQ_UE16CYX=9dDyWaXWA@mail.gmail.com>
 <CAJCQCtQ3_pxXbt=t+L8zuHCzUmfBrLnSOSDS1aUB9mjbR5z+Pw@mail.gmail.com>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <72dbdb0e-df11-7a04-dc21-3969f4a58f69@gmx.com>
Date: Tue, 14 Nov 2017 13:38:52 +0800
MIME-Version: 1.0
In-Reply-To: <CAJCQCtQ3_pxXbt=t+L8zuHCzUmfBrLnSOSDS1aUB9mjbR5z+Pw@mail.gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="BXimRDFTJBTEwTTif1mbRm3JSIhdsoIg2"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--BXimRDFTJBTEwTTif1mbRm3JSIhdsoIg2
Content-Type: multipart/mixed; boundary="bdd7QTg6cuQM8pqCreDHRnRilqDFC8CfU";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: Chris Murphy <lists@colorremedies.com>,
 Omar Sandoval <osandov@osandov.com>, Filipe Manana <fdmanana@gmail.com>
Cc: Ben Hooper <ben@ayrton.com.au>,
 "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Message-ID: <72dbdb0e-df11-7a04-dc21-3969f4a58f69@gmx.com>
Subject: Re: btrfs check fails with: btrfs_alloc_chunk: BUG_ON `ret`
 triggered, value -28
References: <SY3PR01MB1465C3E1A99997C75685BE0FF9280@SY3PR01MB1465.ausprd01.prod.outlook.com>
 <CAJCQCtTKNL9bjpeZFKU0r99R0kkMB4NQ_UE16CYX=9dDyWaXWA@mail.gmail.com>
 <CAJCQCtQ3_pxXbt=t+L8zuHCzUmfBrLnSOSDS1aUB9mjbR5z+Pw@mail.gmail.com>
In-Reply-To: <CAJCQCtQ3_pxXbt=t+L8zuHCzUmfBrLnSOSDS1aUB9mjbR5z+Pw@mail.gmail.com>

--bdd7QTg6cuQM8pqCreDHRnRilqDFC8CfU
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2017=E5=B9=B411=E6=9C=8814=E6=97=A5 11:50, Chris Murphy wrote:
> On Mon, Nov 13, 2017 at 8:45 PM, Chris Murphy <lists@colorremedies.com>=
 wrote:
>> On Mon, Nov 13, 2017 at 8:08 PM, Ben Hooper <ben@ayrton.com.au> wrote:=

>>
>>> [28205.454029] Code: 79 ff ff ff 49 8b 7c 24 60 89 da 48 c7 c6 68 c7 =
be a0 31 c0 e8 12 4e fe ff eb 9b 89 de 48 c7 c7 38 c7 be a0 31 c0 e8 53 1=
1 5a e0 <0f> ff eb 87 66 90 66 2e 0f 1f 84 00 00 00 00 00 66 66 66 66 90
>>> [28205.456407] ---[ end trace 77358f42ce65a0d0 ]---
>>> [28205.457579] BTRFS: error (device sdl) in btrfs_create_pending_bloc=
k_groups:10254: errno=3D-27 unknown
>>> [28206.172366] BTRFS: error (device sdl) in btrfs_create_pending_bloc=
k_groups:10254: errno=3D-27 unknown
>>> [28206.178599] BTRFS warning (device sdl): Skipping commit of aborted=
 transaction.
>>> [28206.179840] BTRFS: error (device sdl) in cleanup_transaction:1873:=
 errno=3D-5 IO failure
>>> [28206.256720] BTRFS error (device sdl): pending csums is 1368064
>>
>> The mysterious -27. But then also IO failure. Are there any other
>> storage related kernel messages in the ~2 to 5 minutes prior to this
>> trace? I'm wondering if there's something misbehaving: cable,
>> controller, drive, other.
>>
>=20
> Found a similar trace from July 2015 that Omar ran into and Filipe
> thought he was close to tracking it down. It was also a pretty big
> file system. Maybe they have an idea here. But btrfs check blowing up
> isn't good in any case.

The BUG_ON in btrfs check is pretty obvious, btrfs check --repair runs
out of space.

Of course, you won't hit it if using default btrfs check which is readonl=
y.

IIRC I have submitted patch to make it end more gracefully.

Thanks,
Qu
>=20
>=20
>=20


--bdd7QTg6cuQM8pqCreDHRnRilqDFC8CfU--

--BXimRDFTJBTEwTTif1mbRm3JSIhdsoIg2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQFLBAEBCAA1FiEELd9y5aWlW6idqkLhwj2R86El/qgFAloKgWwXHHF1d2VucnVv
LmJ0cmZzQGdteC5jb20ACgkQwj2R86El/qjuCwf/awgyertihd1zKdxmPawfPC9z
3UPXLoo0q+URDYpGpZc88XUeSnwpnWp75OiOHS8hLZc4AwaZuvs9Ns7V9LeKzf5a
kkEsuaIX4CFIlZO19XB9wQrdZ1pyeXXT2RUgGoaz+sUIzPW8iVytoaMuvMCvOedv
RFeBObfOqNT9RkyyzqLFKdUsaGQ8tlAtu+z1f3QKXf+o9xmP8Dmi5/7K9TEinOhN
mNYCEJ5TX4mUeefSIym67s0MOQGoH1hmzlAWSmdhg/jIE8iqAHh9iBiH4B4dQjwI
0TR1yhSmDVQFa35v4r3zrDTTZEGuRBW2NCK4OZoiacuegJ3yjva/JpKItUtoIw==
=Ah+V
-----END PGP SIGNATURE-----

--BXimRDFTJBTEwTTif1mbRm3JSIhdsoIg2--
