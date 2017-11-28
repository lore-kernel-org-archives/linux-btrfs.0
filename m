Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.18]:52355 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752411AbdK1AlS (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 27 Nov 2017 19:41:18 -0500
Subject: Re: [PATCH v4 1/4] btrfs-progs: mkfs: Enhance minimal device size
 calculation to fix mkfs failure on small file
To: dsterba@suse.cz, Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org
References: <20171101013043.19294-1-wqu@suse.com>
 <20171101013043.19294-2-wqu@suse.com> <20171127232131.GK3553@twin.jikos.cz>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <a84fe81d-980a-e349-9643-fbdddc50ac44@gmx.com>
Date: Tue, 28 Nov 2017 08:40:47 +0800
MIME-Version: 1.0
In-Reply-To: <20171127232131.GK3553@twin.jikos.cz>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="ILax9w6GrG8kj9KBqAhUt2Wewdsdd5QHA"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--ILax9w6GrG8kj9KBqAhUt2Wewdsdd5QHA
Content-Type: multipart/mixed; boundary="LPetPs4XXiL2QJWd6FkxQ8bxgORRwdOGF";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: dsterba@suse.cz, Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org
Message-ID: <a84fe81d-980a-e349-9643-fbdddc50ac44@gmx.com>
Subject: Re: [PATCH v4 1/4] btrfs-progs: mkfs: Enhance minimal device size
 calculation to fix mkfs failure on small file
References: <20171101013043.19294-1-wqu@suse.com>
 <20171101013043.19294-2-wqu@suse.com> <20171127232131.GK3553@twin.jikos.cz>
In-Reply-To: <20171127232131.GK3553@twin.jikos.cz>

--LPetPs4XXiL2QJWd6FkxQ8bxgORRwdOGF
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2017=E5=B9=B411=E6=9C=8828=E6=97=A5 07:21, David Sterba wrote:
> On Wed, Nov 01, 2017 at 09:30:40AM +0800, Qu Wenruo wrote:
>> +u64 btrfs_min_dev_size(u32 nodesize, int mixed, u64 meta_profile,
>> +		       u64 data_profile)
>> +{
>> +	u64 reserved =3D 0;
>> +	u64 meta_size;
>> +	u64 data_size;
>> +
>> +	if (mixed)
>> +		return 2 * (BTRFS_MKFS_SYSTEM_GROUP_SIZE +
>> +			    btrfs_min_global_blk_rsv_size(nodesize));
>> +
>> +	/*
>> +	 * minimal size calculation is complex due to several factors:
>> +	 * 1) Temporary chunk resue
>> +	 *    If specified chunk profile is SINGLE, we can resue
>> +	 *    temporary chunks, no need to alloc new chunks.
>> +	 *
>> +	 * 2) Different minimal chunk size for different profile
>> +	 *    For initial sys chunk, chunk size is fixed to 4M.
>> +	 *    For single profile, minimal chunk size is 8M for all.
>> +	 *    For other profiles, minimal chunk and stripe size
>> +	 *    differs from 8M to 64M.
>> +	 *
>> +	 * To calculate it a little easier, here we assume we don't
>> +	 * reuse any temporary chunk, and calculate the size all
>> +	 * by ourselves.
>> +	 *
>> +	 * Temporary chunks sizes are always fixed:
>> +	 * One initial sys chunk, one SINGLE meta, and one SINGLE data.
>> +	 * The latter two are all 8M, accroding to @calc_size of
>> +	 * btrfs_alloc_chunk().
>> +	 */
>> +	reserved +=3D BTRFS_MKFS_SYSTEM_GROUP_SIZE + SZ_8M * 2;
>> +
>> +	/*
>> +	 * For real chunks, we need to refer different sizes:
>> +	 * For SINGLE, it's still fixed to 8M (@calc_size).
>> +	 * For other profiles, refer to max(@min_stripe_size, @calc_size).
>> +	 *
>> +	 * And use the stripe size to calculate its physical used space.
>> +	 */
>> +	if (meta_profile & BTRFS_BLOCK_GROUP_PROFILE_MASK)
>> +		meta_size =3D SZ_8M + SZ_32M;
>> +	else
>> +		meta_size =3D SZ_8M + SZ_8M;
>> +	/* Only metadata put 2 stripes into one disk */
>=20
> 'mkfs.btrfs -d dup' also works, so I think this should be handled here
> the same way as metadata, right?

Just a few lines under.
>=20
>> +	if (meta_profile & BTRFS_BLOCK_GROUP_DUP)
>> +		meta_size *=3D 2;
>> +	reserved +=3D meta_size;
>> +
>> +	if (data_profile & BTRFS_BLOCK_GROUP_PROFILE_MASK)
>> +		data_size =3D SZ_64M;
>> +	else
>> +		data_size =3D SZ_8M;
>> +	if (data_profile & BTRFS_BLOCK_GROUP_DUP)
>> +		data_size *=3D 2;
Here data DUP is also handled.

So the problem is about the word "Only".

Do I need to re-submit the whole patchset or just a separate patch to
update the comment?

Thanks,
Qu

>> +	reserved +=3D data_size;
>> +	return reserved;
>> +}
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>=20


--LPetPs4XXiL2QJWd6FkxQ8bxgORRwdOGF--

--ILax9w6GrG8kj9KBqAhUt2Wewdsdd5QHA
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQFLBAEBCAA1FiEELd9y5aWlW6idqkLhwj2R86El/qgFAlocsI8XHHF1d2VucnVv
LmJ0cmZzQGdteC5jb20ACgkQwj2R86El/qi0MAgAp50d3lkbWxqK7pxD/JaOOojT
JBKyDFVf//tgt3m3YvhK4Tgj6mjoBZ2cM+upO/EJoDbD2SA9XaQq+TpE0f1cAghq
bIuLXYe1LYQLH9RvDdFMiptVPEcex1eLmd1O7w1czj5CzZhqI9N3BQru3gRk4aOp
xZpkdkt7UeHnFxZ1B5sPQn23OOD1Y9q/OstH3hHVKU8vghj8tCalQtSoZfwZGoHn
vFHiDHjzddA2Em7egOrgUb1Y5mMdG7JD0j7MDoeYbItUSHBkW896r/JLbMRCNriz
lfD2kXYCv0e9/DGSoRb4ytPLM4Yrasjl6vrLXAS2OAJupT1wl3zASBQTeEQQ4Q==
=zWpO
-----END PGP SIGNATURE-----

--ILax9w6GrG8kj9KBqAhUt2Wewdsdd5QHA--
