Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.15]:50917 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752741AbeGCA4T (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 2 Jul 2018 20:56:19 -0400
Subject: Re: [PATCH v2] btrfs: tree-checker: Verify block_group_item
To: dsterba@suse.cz, Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org
References: <20180702083414.13670-1-wqu@suse.com>
 <20180702144856.GA3126@twin.jikos.cz>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <3685215a-b02d-1bac-5f34-541b90df891c@gmx.com>
Date: Tue, 3 Jul 2018 08:56:02 +0800
MIME-Version: 1.0
In-Reply-To: <20180702144856.GA3126@twin.jikos.cz>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="pFZ4J2cfns8fGAsDqzfPTe6iV13yO7sY6"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--pFZ4J2cfns8fGAsDqzfPTe6iV13yO7sY6
Content-Type: multipart/mixed; boundary="PlB0jIT8urVXiJDKU086sHwSYVDVC3Ggj";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: dsterba@suse.cz, Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org
Message-ID: <3685215a-b02d-1bac-5f34-541b90df891c@gmx.com>
Subject: Re: [PATCH v2] btrfs: tree-checker: Verify block_group_item
References: <20180702083414.13670-1-wqu@suse.com>
 <20180702144856.GA3126@twin.jikos.cz>
In-Reply-To: <20180702144856.GA3126@twin.jikos.cz>

--PlB0jIT8urVXiJDKU086sHwSYVDVC3Ggj
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2018=E5=B9=B407=E6=9C=8802=E6=97=A5 22:48, David Sterba wrote:
> On Mon, Jul 02, 2018 at 04:34:14PM +0800, Qu Wenruo wrote:
>> As reported in https://bugzilla.kernel.org/show_bug.cgi?id=3D199849,
>> a crafted image with invalid block group items could make free space c=
ache
>> code to cause panic.
>>
>> We could early detect such invalid block group item by checking:
>> 1) Size (key)
>>    We have a up limit on block group item (10G)
>=20
>> +	if (key->offset > 10ULL * SZ_1G) {
>> +		block_group_err(fs_info, leaf, slot,
>> +			"invalid block group size, have %llu expect (0, %llu)",
>> +				key->offset, 10ULL * SZ_1G);
>=20
> Can you please make this magic constant a define and explain in a
> comment how it's calculated? Thanks.

Of course, it's used in btrfs_alloc_chunk(), and I'll make it a constant
define.

Thanks,
Qu

> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>=20


--PlB0jIT8urVXiJDKU086sHwSYVDVC3Ggj--

--pFZ4J2cfns8fGAsDqzfPTe6iV13yO7sY6
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEELd9y5aWlW6idqkLhwj2R86El/qgFAls6yaMACgkQwj2R86El
/qj80wgApl0tZOlXzF+n1RscU/nWR0o/I4d27+R2qZ/1T+ugw808e6VjmCRSza5I
dObI88nco+Ui9sieEg+N/yzgxegNEB3OB5kAU7zwzw+taxP+p64RbYma/PSw7BIu
aWLP/JBUyzMa4urO8sEN/pysYzXEp7WdL2v3rxNe0GKfT0/04pSDszYssWwHSrpj
wKgnnQ/MPWxeq7X5+WSmi8D6ZOnhd9eqU0CenwJbcRTQWEbn2bvGNBz0j0IPq0sk
n+SlPpD3cy1abgSZRPaKRxRTWObQSPATmVT2z7pmFB2NULoabLmTxOmfk5pG823x
3W/szVoS8PYrQ9Cb8SWLjwR8jTXAvw==
=n9Aw
-----END PGP SIGNATURE-----

--pFZ4J2cfns8fGAsDqzfPTe6iV13yO7sY6--
