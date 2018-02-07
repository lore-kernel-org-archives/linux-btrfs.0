Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.20]:43487 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753454AbeBGJVT (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 7 Feb 2018 04:21:19 -0500
Subject: Re: [PATCH] btrfs-progs: fsck-tests: Cleanup the restored image for
 028
To: Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org, dsterba@suse.cz
Cc: ralphgauges@googlemail.com
References: <20180207091746.10039-1-wqu@suse.com>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <26bce8f0-83ab-b64d-6841-bbb24e4f7976@gmx.com>
Date: Wed, 7 Feb 2018 17:21:03 +0800
MIME-Version: 1.0
In-Reply-To: <20180207091746.10039-1-wqu@suse.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="P8n8y9Cz64Mgkbp9zTCfTlBZUbhIkSipP"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--P8n8y9Cz64Mgkbp9zTCfTlBZUbhIkSipP
Content-Type: multipart/mixed; boundary="u712ERim5ZArCjfeWO2vMvn8d6LbPkcfw";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org, dsterba@suse.cz
Cc: ralphgauges@googlemail.com
Message-ID: <26bce8f0-83ab-b64d-6841-bbb24e4f7976@gmx.com>
Subject: Re: [PATCH] btrfs-progs: fsck-tests: Cleanup the restored image for
 028
References: <20180207091746.10039-1-wqu@suse.com>
In-Reply-To: <20180207091746.10039-1-wqu@suse.com>

--u712ERim5ZArCjfeWO2vMvn8d6LbPkcfw
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

Please ignore this one.

I just forgot to remove unrelated patch.

Thanks,
Qu

On 2018=E5=B9=B402=E6=9C=8807=E6=97=A5 17:17, Qu Wenruo wrote:
> Signed-off-by: Qu Wenruo <wqu@suse.com>
> ---
>  tests/fsck-tests/028-unaligned-super-dev-sizes/test.sh | 2 ++
>  1 file changed, 2 insertions(+)
>=20
> diff --git a/tests/fsck-tests/028-unaligned-super-dev-sizes/test.sh b/t=
ests/fsck-tests/028-unaligned-super-dev-sizes/test.sh
> index 3928f548c3f9..4bbcfbae662e 100755
> --- a/tests/fsck-tests/028-unaligned-super-dev-sizes/test.sh
> +++ b/tests/fsck-tests/028-unaligned-super-dev-sizes/test.sh
> @@ -21,3 +21,5 @@ run_check "$TOP/btrfs" check "$TEST_DEV"
>  # mount test
>  run_check_mount_test_dev
>  run_check_umount_test_dev "$TEST_MNT"
> +# don't forget to clean it up
> +rm "$TEST_DEV"
>=20


--u712ERim5ZArCjfeWO2vMvn8d6LbPkcfw--

--P8n8y9Cz64Mgkbp9zTCfTlBZUbhIkSipP
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQFLBAEBCAA1FiEELd9y5aWlW6idqkLhwj2R86El/qgFAlp6xP8XHHF1d2VucnVv
LmJ0cmZzQGdteC5jb20ACgkQwj2R86El/qhVawgApIx+pxUsrJB7swAvThikYMxA
OAc2dnNv3TgmnADCXUN8acXRK27Fr9sMCbHPZmsBVsfSudyBu631QfQnU15sz8LK
lWyuCiUs1AePZAMP4egQleRnodeiwEUfHVvG/V0AAdn2ooIjAQwZa+CF49drdGCm
1kI2IFJ9EDd5fiTYiQW3b21ZS9E0Hkc0acixvtgAqT8DMPUvilv81riOk8JbtK1t
vsJ6XDzGg5pCNhzW8AOj7jCeDdLiXnXO1C9Nw8GNg9CTJM4azPjqLYyJk51i3ZOn
MKzQSgwV/MeaM0qNtT5MOFarncwTAXNDhgSspIjBjhn6eGoXjWXovU06z28/zg==
=Unkj
-----END PGP SIGNATURE-----

--P8n8y9Cz64Mgkbp9zTCfTlBZUbhIkSipP--
