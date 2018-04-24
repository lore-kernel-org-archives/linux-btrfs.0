Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.22]:43337 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751279AbeDXMD1 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 24 Apr 2018 08:03:27 -0400
Subject: Re: [PATCH v2 2/4] btrfs: Add incompat flags check for
 btrfs_check_super_valid()
To: dsterba@suse.cz, Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org
References: <20180424044809.29838-1-wqu@suse.com>
 <20180424044809.29838-3-wqu@suse.com> <20180424104800.GB21272@twin.jikos.cz>
 <057e31d8-f01d-267c-0498-50562a34d11b@gmx.com>
 <20180424113047.GD21272@twin.jikos.cz>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <e13af9c0-3cde-f4eb-f7ed-1f8113afef90@gmx.com>
Date: Tue, 24 Apr 2018 20:03:05 +0800
MIME-Version: 1.0
In-Reply-To: <20180424113047.GD21272@twin.jikos.cz>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="O8Ggyg1utx5cwP7NkVcohO2XpeDCeY5lE"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--O8Ggyg1utx5cwP7NkVcohO2XpeDCeY5lE
Content-Type: multipart/mixed; boundary="c4TUdwLNcAGkc7DfWY37iiIA3ZQWYWiy6";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: dsterba@suse.cz, Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org
Message-ID: <e13af9c0-3cde-f4eb-f7ed-1f8113afef90@gmx.com>
Subject: Re: [PATCH v2 2/4] btrfs: Add incompat flags check for
 btrfs_check_super_valid()
References: <20180424044809.29838-1-wqu@suse.com>
 <20180424044809.29838-3-wqu@suse.com> <20180424104800.GB21272@twin.jikos.cz>
 <057e31d8-f01d-267c-0498-50562a34d11b@gmx.com>
 <20180424113047.GD21272@twin.jikos.cz>
In-Reply-To: <20180424113047.GD21272@twin.jikos.cz>

--c4TUdwLNcAGkc7DfWY37iiIA3ZQWYWiy6
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2018=E5=B9=B404=E6=9C=8824=E6=97=A5 19:30, David Sterba wrote:
> On Tue, Apr 24, 2018 at 07:28:27PM +0800, Qu Wenruo wrote:
>>> I've read the discussion under previous version again, IMHO the best =
way
>>> to report what's going on is to use 2 functions for mount ant pre-com=
mit
>>> time.
>>
>> OK, next version will go that direction.
>>
>> Although it may still be a little tricky to split what we need in
>> btrfs_validate_super() and btrfs_precheck_super().
>>
>> What about this idea:
>> - btrfs_precheck_super() only checks the very basis:
>>   * magic
>>   * incompat flags
>>   * csum type
>>   Any mismatch will do friendly prompt ("no btrfs detected" or
>>   "unsupported flags/csum type" respectively)
>>
>> - btrfs_validate_super() do the comprehensive check:
>>   * Everything we did in this patchset
>>   * including magic, incompat flags and csum type
>>   Any mismatch will be considered as corruption.
>>
>> For mount time, we call btrfs_precheck_super() then btrfs_validate_sup=
er().
>>
>> For commit time, only btrfs_validate_super().
>>
>> How about this solution?
>=20
> I'd do that the other way around:
>=20
> * mount checks: btrfs_validate_super - the superblock on disk must be
>   valid before we mount it
>=20
>   btrfs_validate_super()
>=20
> * pre-commit checks: the superblock must be valid and we can also do
>   some additional checks to detect in-memory corruption
>=20
>   btrfs_super_precommit_check()
> 	  btrfs_validate_super()
> 	  if (incompat) {
> 		  ...
> 	  }

Understood.

I'll try this one in next one.

Thanks,
Qu

> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>=20


--c4TUdwLNcAGkc7DfWY37iiIA3ZQWYWiy6--

--O8Ggyg1utx5cwP7NkVcohO2XpeDCeY5lE
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEELd9y5aWlW6idqkLhwj2R86El/qgFAlrfHPkACgkQwj2R86El
/qjhQwf9G2I7l5jYLGZGPuV6mHkTeQWNVeWZLA3RYFK09BUCynl7+b1YAB9gxn7D
IKNdYaa/bUMFCKvYK8Leyzx4Tf1k/GwnNu23VqNLqke4G3Af6VUmFjsaqExZ6H/M
orLR/h6TIzQHAYSJv8hsiPS6I+WBgaJkkka3VBAd48+BYE+9lXPiJky2uVOfe2Zd
wVHYBhZkifbr6p/Nlp1J4+ByeazV/dOQTu2sTGa+ewPXE8K7GYZezuy9TKKfAo5P
ZqFTJ5k2JOeSPE/H+ELWMcMJz9GtvW8d9NmLVhLMYmLGOIgW51rjVJN5EEVPiAuc
lgz7Bf6+VoPsyGNBG4qrM94y+IvauQ==
=wjSk
-----END PGP SIGNATURE-----

--O8Ggyg1utx5cwP7NkVcohO2XpeDCeY5lE--
