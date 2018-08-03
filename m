Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.15]:45747 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732074AbeHCQBe (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 3 Aug 2018 12:01:34 -0400
Subject: Re: [PATCH 1/2] btrfs-progs: completion: Use _filedir() to replace
 _btrfs_devs()
To: dsterba@suse.cz, Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org
References: <20180717061532.11857-1-wqu@suse.com>
 <20180717061532.11857-2-wqu@suse.com> <20180803140031.GY3218@twin.jikos.cz>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <8fe52888-1562-9ff7-e6a3-38cf00aad95c@gmx.com>
Date: Fri, 3 Aug 2018 22:04:50 +0800
MIME-Version: 1.0
In-Reply-To: <20180803140031.GY3218@twin.jikos.cz>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="oyX037tDNjMc39cN4FpsRxMUkRlrYb3bF"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--oyX037tDNjMc39cN4FpsRxMUkRlrYb3bF
Content-Type: multipart/mixed; boundary="apIt8zGYmQwQIrQgru3Ua1GTjmZKPdKlE";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: dsterba@suse.cz, Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org
Message-ID: <8fe52888-1562-9ff7-e6a3-38cf00aad95c@gmx.com>
Subject: Re: [PATCH 1/2] btrfs-progs: completion: Use _filedir() to replace
 _btrfs_devs()
References: <20180717061532.11857-1-wqu@suse.com>
 <20180717061532.11857-2-wqu@suse.com> <20180803140031.GY3218@twin.jikos.cz>
In-Reply-To: <20180803140031.GY3218@twin.jikos.cz>

--apIt8zGYmQwQIrQgru3Ua1GTjmZKPdKlE
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2018=E5=B9=B408=E6=9C=8803=E6=97=A5 22:00, David Sterba wrote:
> On Tue, Jul 17, 2018 at 02:15:31PM +0800, Qu Wenruo wrote:
>> For developers it's pretty common to call "btrfs check" on a raw image=

>> dump other than real block device.
>=20
> I'd be less concerned about developers' environment rather than the
> situations where users want to run check and won't accidentally screw
> up. So completing from filenames should be safe here, the typical
> use will probably want something starting with /dev/ and confusion with=

> random files named 'sda' is highly unlikely.

Yep, _filedir() is just a superset of the original devices.
So for original user case, user only needs extra "/de" to initial the
completion and then it should work mostly fine.

Although it could be further enhanced to only complete certain types,
including regular file (for raw dump), block devices (end user use case).=


>=20
>> So current _btrfs_devs() is really making things worse. Use _filedir()=

>> to replace _btrfs_devs() so it can complete any filenames, no matter i=
f
>> it's just a file or a real block device.
>>
>> Signed-off-by: Qu Wenruo <wqu@suse.com>
>> ---
>>  btrfs-completion | 4 +---
>>  1 file changed, 1 insertion(+), 3 deletions(-)
>>
>> diff --git a/btrfs-completion b/btrfs-completion
>> index ae683f4ecf61..33830e827977 100644
>> --- a/btrfs-completion
>> +++ b/btrfs-completion
>> @@ -6,9 +6,7 @@
>> =20
>>  _btrfs_devs()
>>  {
>> -	local DEVS
>> -	DEVS=3D''; while read dev; do DEVS+=3D"$dev "; done < <(lsblk -pnro =
name)
>> -	COMPREPLY+=3D( $( compgen -W "$DEVS" -- "$cur" ) )
>> +	_filedir
>=20
> This is not a good style, the function is says "devices" and actually
> does "all files". It's used for several other commands where completing=

> files might not be a good idea.
>=20
> If you want to use _filedir, then use it and don't obscure it.

Right, I'll just discard the _btrfs_devs() wrapper.

Thanks,
Qu

>=20


--apIt8zGYmQwQIrQgru3Ua1GTjmZKPdKlE--

--oyX037tDNjMc39cN4FpsRxMUkRlrYb3bF
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEELd9y5aWlW6idqkLhwj2R86El/qgFAltkYQIACgkQwj2R86El
/qh4rAf+JeT/nWYKoYUdbu49kJFRaKTJPSDoLyOrpL1dkgJt2dMOD/EbkZkJYT5c
WMfuy4RZb4wmaVvAFJR5ea/C2VZ+GmQNnUcha7CRm7AeoRz6zxXAX6cSWgArbQCV
gq9zJtMjDA3ImAYGsjiFbYjaSwO4Vk9NCJc72X5H4cR9a+F8Zl6zghNvt6j4kib9
nJlsUtFm2R509SXsv7nq99P5+0TkAji/qvGYPvEdSGj36Z0dVRqpQeS+dKg22+IV
bEOhFoDhzvQP9u3u7zDVVGaBe4c1fS2FUzp5E1OoPhnlbeXoKn6xZ3eBaE/Vy1/N
8mN0+3ebiDT8RXNYxKV6V10LuUH9hg==
=zssS
-----END PGP SIGNATURE-----

--oyX037tDNjMc39cN4FpsRxMUkRlrYb3bF--
