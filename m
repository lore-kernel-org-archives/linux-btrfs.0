Return-Path: <SRS0=1LDH=ON=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=FREEMAIL_FORGED_FROMDOMAIN,
	FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 15283C04EB8
	for <linux-btrfs@archiver.kernel.org>; Tue,  4 Dec 2018 10:15:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C97D920878
	for <linux-btrfs@archiver.kernel.org>; Tue,  4 Dec 2018 10:15:38 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org C97D920878
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=gmx.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726042AbeLDKPh (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 4 Dec 2018 05:15:37 -0500
Received: from mout.gmx.net ([212.227.17.20]:48959 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725613AbeLDKPh (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 4 Dec 2018 05:15:37 -0500
Received: from [0.0.0.0] ([149.28.201.231]) by mail.gmx.com (mrgmx101
 [212.227.17.174]) with ESMTPSA (Nemesis) id 0MPHrQ-1gYVRm2ysS-004VLh; Tue, 04
 Dec 2018 11:15:19 +0100
Subject: Re: [PATCH] btrfs: tree-checker: Don't check max block group size as
 current max chunk size limit is unreliable
To:     Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org,
        David Sterba <dsterba@suse.cz>
Cc:     stable@vger.kernel.org
References: <20181123010636.19363-1-wqu@suse.com>
From:   Qu Wenruo <quwenruo.btrfs@gmx.com>
Openpgp: preference=signencrypt
Autocrypt: addr=quwenruo.btrfs@gmx.com; prefer-encrypt=mutual; keydata=
 xsBNBFnVga8BCACyhFP3ExcTIuB73jDIBA/vSoYcTyysFQzPvez64TUSCv1SgXEByR7fju3o
 8RfaWuHCnkkea5luuTZMqfgTXrun2dqNVYDNOV6RIVrc4YuG20yhC1epnV55fJCThqij0MRL
 1NxPKXIlEdHvN0Kov3CtWA+R1iNN0RCeVun7rmOrrjBK573aWC5sgP7YsBOLK79H3tmUtz6b
 9Imuj0ZyEsa76Xg9PX9Hn2myKj1hfWGS+5og9Va4hrwQC8ipjXik6NKR5GDV+hOZkktU81G5
 gkQtGB9jOAYRs86QG/b7PtIlbd3+pppT0gaS+wvwMs8cuNG+Pu6KO1oC4jgdseFLu7NpABEB
 AAHNIlF1IFdlbnJ1byA8cXV3ZW5ydW8uYnRyZnNAZ214LmNvbT7CwJQEEwEIAD4CGwMFCwkI
 BwIGFQgJCgsCBBYCAwECHgECF4AWIQQt33LlpaVbqJ2qQuHCPZHzoSX+qAUCWdWCnQUJCWYC
 bgAKCRDCPZHzoSX+qAR8B/94VAsSNygx1C6dhb1u1Wp1Jr/lfO7QIOK/nf1PF0VpYjTQ2au8
 ihf/RApTna31sVjBx3jzlmpy+lDoPdXwbI3Czx1PwDbdhAAjdRbvBmwM6cUWyqD+zjVm4RTG
 rFTPi3E7828YJ71Vpda2qghOYdnC45xCcjmHh8FwReLzsV2A6FtXsvd87bq6Iw2axOHVUax2
 FGSbardMsHrya1dC2jF2R6n0uxaIc1bWGweYsq0LXvLcvjWH+zDgzYCUB0cfb+6Ib/ipSCYp
 3i8BevMsTs62MOBmKz7til6Zdz0kkqDdSNOq8LgWGLOwUTqBh71+lqN2XBpTDu1eLZaNbxSI
 ilaVzsBNBFnVga8BCACqU+th4Esy/c8BnvliFAjAfpzhI1wH76FD1MJPmAhA3DnX5JDORcga
 CbPEwhLj1xlwTgpeT+QfDmGJ5B5BlrrQFZVE1fChEjiJvyiSAO4yQPkrPVYTI7Xj34FnscPj
 /IrRUUka68MlHxPtFnAHr25VIuOS41lmYKYNwPNLRz9Ik6DmeTG3WJO2BQRNvXA0pXrJH1fN
 GSsRb+pKEKHKtL1803x71zQxCwLh+zLP1iXHVM5j8gX9zqupigQR/Cel2XPS44zWcDW8r7B0
 q1eW4Jrv0x19p4P923voqn+joIAostyNTUjCeSrUdKth9jcdlam9X2DziA/DHDFfS5eq4fEv
 ABEBAAHCwHwEGAEIACYWIQQt33LlpaVbqJ2qQuHCPZHzoSX+qAUCWdWBrwIbDAUJA8JnAAAK
 CRDCPZHzoSX+qA3xB/4zS8zYh3Cbm3FllKz7+RKBw/ETBibFSKedQkbJzRlZhBc+XRwF61mi
 f0SXSdqKMbM1a98fEg8H5kV6GTo62BzvynVrf/FyT+zWbIVEuuZttMk2gWLIvbmWNyrQnzPl
 mnjK4AEvZGIt1pk+3+N/CMEfAZH5Aqnp0PaoytRZ/1vtMXNgMxlfNnb96giC3KMR6U0E+siA
 4V7biIoyNoaN33t8m5FwEwd2FQDG9dAXWhG13zcm9gnk63BN3wyCQR+X5+jsfBaS4dvNzvQv
 h8Uq/YGjCoV1ofKYh3WKMY8avjq25nlrhzD/Nto9jHp8niwr21K//pXVA81R2qaXqGbql+zo
Message-ID: <3cd7ba2f-377f-604e-5996-fbf5086b9843@gmx.com>
Date:   Tue, 4 Dec 2018 18:15:13 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.3.1
MIME-Version: 1.0
In-Reply-To: <20181123010636.19363-1-wqu@suse.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="g6rgBG7u2rhmhBjNrgTdwXHeKcAxJkypS"
X-Provags-ID: V03:K1:g9uezsBzymy5dY3bN1C9m3eEilzaBmKKt96TNIbmZF3YW69HnGD
 nNrGiNtMvrwEXuM0X57SYHNv7CI+LQqAgzBNrDEfQd9EKyczfvTkY9oWH8VA4pkdKMuGUf3
 nOzovi+sbToZRNdxi0S7Nf62jOPmbwImlPU1Ja8yn8vNowJFHLfbuF6MNtyZpaB77fKKvhb
 g7s6f6bWZePX9lnkKUtXw==
X-UI-Out-Filterresults: notjunk:1;V03:K0:Ev8RZC2th1o=:oft/u2FQ8ml5Qrho4jhCV0
 dYgoe48+5+41063i37OTONrBoBZxdom6CxsgKINbIx62G2Z7G+ELq8SA7Fg1kuoq/gC0c9gjP
 i8HH1WKlYk1qV2+7g5AipbwYk4jG4Qv7YLdHcnSdWoTbhhVRy2E8QtWtZLQzp+psMbDmx5Oa6
 M/bQPH4Am2OA5e1X3eBWgkq48t7iTj4aCCABdeyyFra3yjeQmNi+Djmt4ggU8N5FtHcQVzizG
 cNeq+OxqRDqrSCsRU93ZsJSUWuRK7mDyspKazkTKSigQkM0QOrry77CKi3Z7Vzbc897rRre6P
 HZkFqvcSyVZbvH0zzBTxXZnT/BlVMVEXtE3gpOqdCfxwd9rTAM8mjFCG2GAtXxzYPbdkhH9un
 nMW+lJW1P+k2ru7aD5e6LCdb713TiKs8QwIgFKfT/oNsEwlmynnLqHMzTrma+CPBELvmQrjJh
 L61r2dHmOsZoC4WlqYGYx23hSTHjam1LdAmVfsMaf0iMYexrBDRXLiGK0rrbJ+zMSH3aOdCN0
 2Gf0CELkpDKv00bUk71gd6pQsAVHgFAAXI8ydsRU8QRI2gTCxoRQj7KizPfxj/Kt7qoTMv1TO
 CrQN7etl4SX/JKsHRG6Rz4Xl4hK+eZuv1ok5URlMLzdWde+MsHrHl0Vij6mKtDp2S1xsF1ul0
 PG5jBwBVUiCVzEMUTqNxenhuCShzj3vIdjmzgX9TbMSs0S3+F4iNruI67M5YfE8rd466D0T4h
 fjXvJ0Zu9+p8BlEnlOEfrOhfcgiPzRUQjyoU9DBak5U7exUYgWqnkibM1wc+gVuiALSFwpJCB
 DYHfURZa5nAZ0YT7gX5aGx5Y653qAckO5kShM++2I/jTQ1+ieXeJrZxr/tw7CGkxHjUbNmyZH
 cDWK4u+tUJT6i6WaV2mw2gKOz64yXkDdY5AJ+gmq5mJxp4EiEl05jSi65lff+q
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--g6rgBG7u2rhmhBjNrgTdwXHeKcAxJkypS
Content-Type: multipart/mixed; boundary="fOWB6VPNpiNZHP2DTCDxVojnoGH7ACVCX";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org,
 David Sterba <dsterba@suse.cz>
Cc: stable@vger.kernel.org
Message-ID: <3cd7ba2f-377f-604e-5996-fbf5086b9843@gmx.com>
Subject: Re: [PATCH] btrfs: tree-checker: Don't check max block group size as
 current max chunk size limit is unreliable
References: <20181123010636.19363-1-wqu@suse.com>
In-Reply-To: <20181123010636.19363-1-wqu@suse.com>

--fOWB6VPNpiNZHP2DTCDxVojnoGH7ACVCX
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

Gentle ping.

Please put this patch into current release as the new block group size
limit check introduced in v4.19 is causing at least 2 reports in mail lis=
t.

Thanks,
Qu

On 2018/11/23 =E4=B8=8A=E5=8D=889:06, Qu Wenruo wrote:
> [BUG]
> A completely valid btrfs will refuse to mount, with error message like:=

>   BTRFS critical (device sdb2): corrupt leaf: root=3D2 block=3D23968153=
6 slot=3D172 \
>     bg_start=3D12018974720 bg_len=3D10888413184, invalid block group si=
ze, \
>     have 10888413184 expect (0, 10737418240]
>=20
> Btrfs check returns no error, and all kernels used on this fs is later
> than 2011, which should all have the 10G size limit commit.
>=20
> [CAUSE]
> For a 12 devices btrfs, we could allocate a chunk larger than 10G due t=
o
> stripe stripe bump up.
>=20
> __btrfs_alloc_chunk()
> |- max_stripe_size =3D 1G
> |- max_chunk_size =3D 10G
> |- data_stripe =3D 11
> |- if (1G * 11 > 10G) {
>        stripe_size =3D 976128930;
>        stripe_size =3D round_up(976128930, SZ_16M) =3D 989855744
>=20
> However the final stripe_size (989855744) * 11 =3D 10888413184, which i=
s
> still larger than 10G.
>=20
> [FIX]
> For the comprehensive check, we need to do the full check at chunk
> read time, and rely on bg <-> chunk mapping to do the check.
>=20
> We could just skip the length check for now.
>=20
> Fixes: fce466eab7ac ("btrfs: tree-checker: Verify block_group_item")
> Cc: stable@vger.kernel.org # v4.19+
> Reported-by: Wang Yugui <wangyugui@e16-tech.com>
> Signed-off-by: Qu Wenruo <wqu@suse.com>
> ---
>  fs/btrfs/tree-checker.c | 8 +++-----
>  1 file changed, 3 insertions(+), 5 deletions(-)
>=20
> diff --git a/fs/btrfs/tree-checker.c b/fs/btrfs/tree-checker.c
> index cab0b1f1f741..d8bd5340fbbc 100644
> --- a/fs/btrfs/tree-checker.c
> +++ b/fs/btrfs/tree-checker.c
> @@ -389,13 +389,11 @@ static int check_block_group_item(struct btrfs_fs=
_info *fs_info,
> =20
>  	/*
>  	 * Here we don't really care about alignment since extent allocator c=
an
> -	 * handle it.  We care more about the size, as if one block group is
> -	 * larger than maximum size, it's must be some obvious corruption.
> +	 * handle it.  We care more about the size.
>  	 */
> -	if (key->offset > BTRFS_MAX_DATA_CHUNK_SIZE || key->offset =3D=3D 0) =
{
> +	if (key->offset =3D=3D 0) {
>  		block_group_err(fs_info, leaf, slot,
> -			"invalid block group size, have %llu expect (0, %llu]",
> -				key->offset, BTRFS_MAX_DATA_CHUNK_SIZE);
> +				"invalid block group size 0");
>  		return -EUCLEAN;
>  	}
> =20
>=20


--fOWB6VPNpiNZHP2DTCDxVojnoGH7ACVCX--

--g6rgBG7u2rhmhBjNrgTdwXHeKcAxJkypS
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEELd9y5aWlW6idqkLhwj2R86El/qgFAlwGU7EACgkQwj2R86El
/qgdPwf9EPA12WBTWXVEN3rxAjfSQlOJ6uakcIjWKeoK3AF2VhHVz3GZhx9zdh8C
BB49NP3bPl/avj78R2l/3dfpZ5hajmMBqfbzt1VxiTcV1S5TuY+vr633OlrwGZeQ
Y6UiDqBm0oSCpy4PQ94eBNBKnkp/L5CYCNaGgm4BgmzT6vIffTjGoSVdqyabjKew
I8G0w+Gn59LeKVQ4Pv4GGYU30HL1TRKu7kfSpUP6EIZLAZ1f+v7d44uiXmiJEFhS
AaodqHnqf2dzVCDFD70zgMBoCk7CxFF7PzZ/I47QKb+SXk/iyJNBuGSzchRLjhhc
iXzF23QFL5KsXqRl/r0oYI9M1HHykg==
=mNUs
-----END PGP SIGNATURE-----

--g6rgBG7u2rhmhBjNrgTdwXHeKcAxJkypS--
