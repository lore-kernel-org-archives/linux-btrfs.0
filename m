Return-Path: <SRS0=IJ3x=Q3=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=FREEMAIL_FORGED_FROMDOMAIN,
	FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3D572C4360F
	for <linux-btrfs@archiver.kernel.org>; Wed, 20 Feb 2019 11:45:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0C4FF2086C
	for <linux-btrfs@archiver.kernel.org>; Wed, 20 Feb 2019 11:45:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726396AbfBTLpP (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 20 Feb 2019 06:45:15 -0500
Received: from mout.gmx.net ([212.227.15.18]:48631 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726197AbfBTLpP (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 20 Feb 2019 06:45:15 -0500
Received: from [0.0.0.0] ([149.28.201.231]) by mail.gmx.com (mrgmx001
 [212.227.17.184]) with ESMTPSA (Nemesis) id 0LkfdE-1hUebA1uqK-00aSh7; Wed, 20
 Feb 2019 12:45:09 +0100
Subject: Re: [PATCH] Btrfs: remove assertion when searching for a key in a
 node/leaf
To:     fdmanana@kernel.org, linux-btrfs@vger.kernel.org
References: <20190220111143.15911-1-fdmanana@kernel.org>
From:   Qu Wenruo <quwenruo.btrfs@gmx.com>
Openpgp: preference=signencrypt
Autocrypt: addr=quwenruo.btrfs@gmx.com; prefer-encrypt=mutual; keydata=
 mQENBFnVga8BCACyhFP3ExcTIuB73jDIBA/vSoYcTyysFQzPvez64TUSCv1SgXEByR7fju3o
 8RfaWuHCnkkea5luuTZMqfgTXrun2dqNVYDNOV6RIVrc4YuG20yhC1epnV55fJCThqij0MRL
 1NxPKXIlEdHvN0Kov3CtWA+R1iNN0RCeVun7rmOrrjBK573aWC5sgP7YsBOLK79H3tmUtz6b
 9Imuj0ZyEsa76Xg9PX9Hn2myKj1hfWGS+5og9Va4hrwQC8ipjXik6NKR5GDV+hOZkktU81G5
 gkQtGB9jOAYRs86QG/b7PtIlbd3+pppT0gaS+wvwMs8cuNG+Pu6KO1oC4jgdseFLu7NpABEB
 AAG0IlF1IFdlbnJ1byA8cXV3ZW5ydW8uYnRyZnNAZ214LmNvbT6JAVQEEwEIAD4CGwMFCwkI
 BwIGFQgJCgsCBBYCAwECHgECF4AWIQQt33LlpaVbqJ2qQuHCPZHzoSX+qAUCWdWCnQUJCWYC
 bgAKCRDCPZHzoSX+qAR8B/94VAsSNygx1C6dhb1u1Wp1Jr/lfO7QIOK/nf1PF0VpYjTQ2au8
 ihf/RApTna31sVjBx3jzlmpy+lDoPdXwbI3Czx1PwDbdhAAjdRbvBmwM6cUWyqD+zjVm4RTG
 rFTPi3E7828YJ71Vpda2qghOYdnC45xCcjmHh8FwReLzsV2A6FtXsvd87bq6Iw2axOHVUax2
 FGSbardMsHrya1dC2jF2R6n0uxaIc1bWGweYsq0LXvLcvjWH+zDgzYCUB0cfb+6Ib/ipSCYp
 3i8BevMsTs62MOBmKz7til6Zdz0kkqDdSNOq8LgWGLOwUTqBh71+lqN2XBpTDu1eLZaNbxSI
 ilaVuQENBFnVga8BCACqU+th4Esy/c8BnvliFAjAfpzhI1wH76FD1MJPmAhA3DnX5JDORcga
 CbPEwhLj1xlwTgpeT+QfDmGJ5B5BlrrQFZVE1fChEjiJvyiSAO4yQPkrPVYTI7Xj34FnscPj
 /IrRUUka68MlHxPtFnAHr25VIuOS41lmYKYNwPNLRz9Ik6DmeTG3WJO2BQRNvXA0pXrJH1fN
 GSsRb+pKEKHKtL1803x71zQxCwLh+zLP1iXHVM5j8gX9zqupigQR/Cel2XPS44zWcDW8r7B0
 q1eW4Jrv0x19p4P923voqn+joIAostyNTUjCeSrUdKth9jcdlam9X2DziA/DHDFfS5eq4fEv
 ABEBAAGJATwEGAEIACYWIQQt33LlpaVbqJ2qQuHCPZHzoSX+qAUCWdWBrwIbDAUJA8JnAAAK
 CRDCPZHzoSX+qA3xB/4zS8zYh3Cbm3FllKz7+RKBw/ETBibFSKedQkbJzRlZhBc+XRwF61mi
 f0SXSdqKMbM1a98fEg8H5kV6GTo62BzvynVrf/FyT+zWbIVEuuZttMk2gWLIvbmWNyrQnzPl
 mnjK4AEvZGIt1pk+3+N/CMEfAZH5Aqnp0PaoytRZ/1vtMXNgMxlfNnb96giC3KMR6U0E+siA
 4V7biIoyNoaN33t8m5FwEwd2FQDG9dAXWhG13zcm9gnk63BN3wyCQR+X5+jsfBaS4dvNzvQv
 h8Uq/YGjCoV1ofKYh3WKMY8avjq25nlrhzD/Nto9jHp8niwr21K//pXVA81R2qaXqGbql+zo
Message-ID: <83dfeab3-15c0-9c11-bc1b-e4f1f067bd11@gmx.com>
Date:   Wed, 20 Feb 2019 19:45:04 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.5.0
MIME-Version: 1.0
In-Reply-To: <20190220111143.15911-1-fdmanana@kernel.org>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="MNOdXjBITTYXz6ZTuwMZSkYF5TnycTywP"
X-Provags-ID: V03:K1:281mlC9yMuLIc1BvOBjDgQwBIKXpmcf2PIsSgl4ksKcZYsJmDq4
 c5HMWaVOo9HdJFif8ZgM3q/Z1FXI9KS3e+r63SejsO+dMNEInSC16VWzKh3wnjCaHrj0SlU
 KXfmWs632bqCR+4UHc0SkzKuZKF1MfxMitsJjd3iSHLYhpXVD867EunCtZLFLDSiJv2/NNB
 N0KHOOfSl98YOryoPI5UQ==
X-UI-Out-Filterresults: notjunk:1;V03:K0:Q88jUHfM6Zk=:0dev8bIQHeSc9G9QKoYZMA
 +yGKgkRY0sh/rUFXdEYcSm4nkvLwhvUQAEzTUJfW2p5tabDDd/oGcjX6n/nFYLp8N8Gcovv20
 zbImmhCSImXqJribYaZtuiTG1bX+89q1WaT4WXhNb6tmm9MMZgw7geUN+3+Dj+6mdDn9TNtfO
 bOViv2lRyPV/h1LpZt8FfRlNm0rsouGZD4s8zIMKkgV+noPHzSdkixcvhOG+S5zEdm5RYQulX
 Z1Ou/FDe45wF2Xk2QmogpSw4y2NDW9IdwfUbiQTbcMSmAlFoO2LJ9UpMO0hZaa046d7jM8mdA
 c5AlOGI2T5m2KYfAXvL4NZyPHQWuoRqafURX+IXNedjjJ7IV3Pvng2Qq2PBLuNSj8WJ7JKv1o
 XXvMWfpZx8M3Un6XduL+a+X2FqluZWbRscjLIltd9Zc0aIpK3uaEXmR1KcujxjuyRqlL6JWyv
 vmMnal1g09pPBd5U5ajRRjIDzlgKkATAClg1ZsTnOBXll6Kr4/7bDygnJJNcOPdfcicSNgYRP
 81YVRSKJX7NgwVkNgnyaCaCLmvM2G4cb27GpUiRKURMGPyggAUjOufe0r7XMBG9i/gcqm6kKd
 qhehYmlMeE3zxhEIG7fTxuhd80qwhaIuImWAh3oezH2VwrtcnQH4nuAY3+8K3rWjsXp/EquD0
 XiGCwTLVNFhBbL96ImfX/9u2NVDNyxPxbqmegWFnsuv+qYNw2cDk+kaTiStSFBNs8VeflziCF
 Ccb8ERFJmVfxRNuCp8QcYJ850da/fX+33PMgSe2yycQdelo3/+8EsCn3BKldBlqLkZB7kIcoz
 7TkMiq7ykfHJm7I55JowGo1RvRAHBM/bzgz4ofcS4b3jUp+LGfyT32athdmL0htyhb8xXx1qw
 grQAjval/OMT/NHo5/DlZUr82CK/JKzlV3iBguSgTL7ZETrdg4PuXqtwUVIlig
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--MNOdXjBITTYXz6ZTuwMZSkYF5TnycTywP
Content-Type: multipart/mixed; boundary="Mmmem6rsAVD1YRmQo61s5rpN9OR60JCyx";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: fdmanana@kernel.org, linux-btrfs@vger.kernel.org
Message-ID: <83dfeab3-15c0-9c11-bc1b-e4f1f067bd11@gmx.com>
Subject: Re: [PATCH] Btrfs: remove assertion when searching for a key in a
 node/leaf
References: <20190220111143.15911-1-fdmanana@kernel.org>
In-Reply-To: <20190220111143.15911-1-fdmanana@kernel.org>

--Mmmem6rsAVD1YRmQo61s5rpN9OR60JCyx
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2019/2/20 =E4=B8=8B=E5=8D=887:11, fdmanana@kernel.org wrote:
> From: Filipe Manana <fdmanana@suse.com>
>=20
> At ctree.c:key_search(), the assertion that verifies the first key on a=

> child extent buffer corresponds to the key at a specific slot in the
> parent has a disadvantage: we effectively hit a BUG_ON() which requires=

> rebooting the machine later. It also does not tell any information abou=
t
> which extent buffer is affected, from which root, the expected and foun=
d
> keys, etc.
>=20
> However as of commit 581c1760415c48 ("btrfs: Validate child tree block'=
s
> level and first key"), that assertion is not needed since at the time w=
e
> read an extent buffer from disk we validate that its first key matches =
the
> key, at the respective slot, in the parent extent buffer. Therefore jus=
t
> remove the assertion at key_search().
>=20
> Signed-off-by: Filipe Manana <fdmanana@suse.com>

Reviewed-by: Qu Wenruo <wqu@suse.com>

Thanks,
Qu

> ---
>  fs/btrfs/ctree.c | 21 ---------------------
>  1 file changed, 21 deletions(-)
>=20
> diff --git a/fs/btrfs/ctree.c b/fs/btrfs/ctree.c
> index 5b9f602fb9e2..e754bd019618 100644
> --- a/fs/btrfs/ctree.c
> +++ b/fs/btrfs/ctree.c
> @@ -2529,26 +2529,6 @@ setup_nodes_for_search(struct btrfs_trans_handle=
 *trans,
>  	return ret;
>  }
> =20
> -static void key_search_validate(struct extent_buffer *b,
> -				const struct btrfs_key *key,
> -				int level)
> -{
> -#ifdef CONFIG_BTRFS_ASSERT
> -	struct btrfs_disk_key disk_key;
> -
> -	btrfs_cpu_key_to_disk(&disk_key, key);
> -
> -	if (level =3D=3D 0)
> -		ASSERT(!memcmp_extent_buffer(b, &disk_key,
> -		    offsetof(struct btrfs_leaf, items[0].key),
> -		    sizeof(disk_key)));
> -	else
> -		ASSERT(!memcmp_extent_buffer(b, &disk_key,
> -		    offsetof(struct btrfs_node, ptrs[0].key),
> -		    sizeof(disk_key)));
> -#endif
> -}
> -
>  static int key_search(struct extent_buffer *b, const struct btrfs_key =
*key,
>  		      int level, int *prev_cmp, int *slot)
>  {
> @@ -2557,7 +2537,6 @@ static int key_search(struct extent_buffer *b, co=
nst struct btrfs_key *key,
>  		return *prev_cmp;
>  	}
> =20
> -	key_search_validate(b, key, level);
>  	*slot =3D 0;
> =20
>  	return 0;
>=20


--Mmmem6rsAVD1YRmQo61s5rpN9OR60JCyx--

--MNOdXjBITTYXz6ZTuwMZSkYF5TnycTywP
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEELd9y5aWlW6idqkLhwj2R86El/qgFAlxtPcAACgkQwj2R86El
/qiA1Af/YX+sMkDmRHA5Fa1uICQAParrDvKZflT/VGXvnw0ExZTy9VuaFfPwiQOo
Qn3CPhDbHyz72UF+QbNsFycJSTttPPcOaEyz1EMcxOkMK2dRIqo5l5axkrBQ8mPu
5+OQ962pkZzJmuth4nFoilxrhxNZPZbrfq9O3MZS3xOY7jWQsyVk6aC9rXTsJoRR
W1/VOmG5c7ZGPJBlbKxse3T6RCzWajGWwCStXvH05t2bvDn2/XuxgevvyAwaEdO/
eNgQKDiTuvw2meWNYYPrlM2HVHRAgxba0TQZToJ8o6NozR0k4NBVhsuADzX2bEMb
voGUUior5p0deRNgeW4QtTIGIQc1zw==
=XEVk
-----END PGP SIGNATURE-----

--MNOdXjBITTYXz6ZTuwMZSkYF5TnycTywP--
