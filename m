Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.21]:42717 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751234AbeDXL2o (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 24 Apr 2018 07:28:44 -0400
Subject: Re: [PATCH v2 2/4] btrfs: Add incompat flags check for
 btrfs_check_super_valid()
To: dsterba@suse.cz, Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org
References: <20180424044809.29838-1-wqu@suse.com>
 <20180424044809.29838-3-wqu@suse.com> <20180424104800.GB21272@twin.jikos.cz>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <057e31d8-f01d-267c-0498-50562a34d11b@gmx.com>
Date: Tue, 24 Apr 2018 19:28:27 +0800
MIME-Version: 1.0
In-Reply-To: <20180424104800.GB21272@twin.jikos.cz>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="v3FOJB5BtjLIXpfpwWDB2M79HogPa1w5k"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--v3FOJB5BtjLIXpfpwWDB2M79HogPa1w5k
Content-Type: multipart/mixed; boundary="CRmRfdDEsctOMC4REVqIGwqZTy2DqcjbH";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: dsterba@suse.cz, Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org
Message-ID: <057e31d8-f01d-267c-0498-50562a34d11b@gmx.com>
Subject: Re: [PATCH v2 2/4] btrfs: Add incompat flags check for
 btrfs_check_super_valid()
References: <20180424044809.29838-1-wqu@suse.com>
 <20180424044809.29838-3-wqu@suse.com> <20180424104800.GB21272@twin.jikos.cz>
In-Reply-To: <20180424104800.GB21272@twin.jikos.cz>

--CRmRfdDEsctOMC4REVqIGwqZTy2DqcjbH
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2018=E5=B9=B404=E6=9C=8824=E6=97=A5 18:48, David Sterba wrote:
> On Tue, Apr 24, 2018 at 12:48:07PM +0800, Qu Wenruo wrote:
>> Although we have already checked incompat flags manually before really=

>> mounting it, we could still enhance btrfs_check_super_valid() to check=

>> incompat flags for later write time super block validation check.
>=20
> But the calls are in reverse. First the validation is called and then
> the incompat bits are verified if the filesystem is mountable.
>=20
> With change in this patch, any uknonwn incompat bit at mount time will
> be reported as corruption. This does not make sense.

Oh sorry, I just though incompat flags is checked before calling
btrfs_validate_super().

>=20
> I've read the discussion under previous version again, IMHO the best wa=
y
> to report what's going on is to use 2 functions for mount ant pre-commi=
t
> time.

OK, next version will go that direction.

Although it may still be a little tricky to split what we need in
btrfs_validate_super() and btrfs_precheck_super().

What about this idea:
- btrfs_precheck_super() only checks the very basis:
  * magic
  * incompat flags
  * csum type
  Any mismatch will do friendly prompt ("no btrfs detected" or
  "unsupported flags/csum type" respectively)

- btrfs_validate_super() do the comprehensive check:
  * Everything we did in this patchset
  * including magic, incompat flags and csum type
  Any mismatch will be considered as corruption.

For mount time, we call btrfs_precheck_super() then btrfs_validate_super(=
).

For commit time, only btrfs_validate_super().

How about this solution?

Thanks,
Qu
>=20
> We can't expect that random user will understand that new unsupported
> flags actually mean corruption or that unsupported bits at mount time
> are not really a corruption.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>=20


--CRmRfdDEsctOMC4REVqIGwqZTy2DqcjbH--

--v3FOJB5BtjLIXpfpwWDB2M79HogPa1w5k
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEELd9y5aWlW6idqkLhwj2R86El/qgFAlrfFNsACgkQwj2R86El
/qiqWAf/eFsdE/KTehcQPii9KGmShZSH/5wzAwTrGPrbFTp2lxvKhb/VCWqegwzu
whQKMeChsXQ/gvKzj80AJgqWIZ7a6SRTPPOeviDyGia5WtDtxjuHberCShUjzrSZ
CH6UfCuMLBj4/97Po+TYrLJje5gb5HX916SxNxguTXONozu6KK0En/HnLWc4qXF3
d1vH5er3KXsVWbi4lXNrSctjnowyPw9CcLG4Ll37zBFu/RGlrOlsGy3F3rVm2u0B
GmW5zrZcwxzhmP+0VOPURd2WilTfcXsCkh42UnbmdparsTDCtkZGY5Scc5ZD7qOa
yrH/HSbbqPwQKVlk4j54gAF3zdEIuQ==
=fk7M
-----END PGP SIGNATURE-----

--v3FOJB5BtjLIXpfpwWDB2M79HogPa1w5k--
