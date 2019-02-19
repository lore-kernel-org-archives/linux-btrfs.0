Return-Path: <SRS0=T+sm=Q2=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=FREEMAIL_FORGED_FROMDOMAIN,
	FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B5E31C43381
	for <linux-btrfs@archiver.kernel.org>; Tue, 19 Feb 2019 00:54:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7FE6421773
	for <linux-btrfs@archiver.kernel.org>; Tue, 19 Feb 2019 00:54:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732518AbfBSAyH (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 18 Feb 2019 19:54:07 -0500
Received: from mout.gmx.net ([212.227.17.22]:50799 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726175AbfBSAyG (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 18 Feb 2019 19:54:06 -0500
Received: from [0.0.0.0] ([149.28.201.231]) by mail.gmx.com (mrgmx102
 [212.227.17.174]) with ESMTPSA (Nemesis) id 0MATlG-1gkO8i2Rv0-00Bevm; Tue, 19
 Feb 2019 01:54:01 +0100
Subject: Re: [PATCH 2/2] Btrfs: report and handle error on unexpected first
 key on extent buffer
To:     fdmanana@kernel.org, linux-btrfs@vger.kernel.org
References: <20190218165826.23549-1-fdmanana@kernel.org>
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
Message-ID: <a79f6d14-88bd-5a58-a508-8683428ad12f@gmx.com>
Date:   Tue, 19 Feb 2019 08:53:53 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.5.0
MIME-Version: 1.0
In-Reply-To: <20190218165826.23549-1-fdmanana@kernel.org>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="b9sndWf12NMGupe57KZEG8wg8Jyx2jHvi"
X-Provags-ID: V03:K1:3stC1lwOtGk8kItnpjqaa9SQE6KZDO4/KxZutPx9j3YYOStWBNp
 Drj6cCbw/+mCbBBmNKWb8VW4UEF/KA/7wpQozdtOIV8Hs1emvt4Gn4EZhek92+wRTG+sdJg
 xlmFEMwGDccgt+NTv2eEygpiFen3IpPGaNwY030xutbRzJiFpLJ9shwpdt9QV4uN5C3bBie
 DBtGKCruKHZlouRy/9BWA==
X-UI-Out-Filterresults: notjunk:1;V03:K0:JFFhyJdjxUo=:9TmWIS+Os/bc5Igl9UfJVA
 i/Sv1vvRAfDL2C8BIKf9RHU3JCzcpF6UnNqMZWxBPtSv+IB3QNB7pDbMfY2FIoOhzyla4X1No
 SdqAGRtEmmriBwqhRcRTgYM9Z6q026gFoY3PqThXQklm4H8lLVYkquJFrSJDR9xHKJZdPojM+
 5PwhA1j9UsC0jDPlmMAZwPAp96OUBJPkjvR1+gBrnfra82Q7nuwKqhsO7FTtZp+kutlOlGC+D
 fjBmUYj0w2iWVUwJeZ3ykBhziMkzqLFyb9sXTsj99DBwOLGQqXirUhjELEjn9Zihc+YRmnoMi
 cbGfL25u1dec/0LUP7IFHnBRaqCPXPWIcscynHO/RWd24tzvDNeR0AOaJp7HmDLWe2Ni/gxQV
 qMa9wnKDq74RBBdLy5IbIOQ7EIDYvsQQenEwc4y9sDGGJtp1f6zPJ3R9lvUU8hV8clsObCLX4
 cNasX1ptDmWIOeDpHEgteWqTvMEmHSXXSGh0gHmnaWvDcZAhZIZPe7+tZajDrcOiFzXbFHrA9
 r5yNZIRqFmqBeNF0vssv73MKwpTir9v7puNGdNkNwwYAITPqp+7ZbLp1Nj9LCe0uzfsAfvgcm
 3lvk+4xL7V4+MFgVeF2TO6IyzENa5Zu32nFXV5sXkAuWuvKm9d30uv2QNUxucmdXJpizM/1e/
 kH12VCQ0fzNj/+qRdJO/JR/d8/kP0nFRlTErLnTtONMmdgxhlJiyrxWrdy7pUYjJ6Y+35hxhJ
 rpN1JlOIhqudMKDl6NvTX5OAzFsOOsmpZAUe2GWqYdof065hdFBrKxhwnPSI9+8ZycOWOSo53
 +muo17yeDmkyAv6mUUEeJkOQnMb9A3XJluFmRUeYilIN1f+R8gHp1HsXPQ/vxX0errZkkqrzt
 C6YYNquzuZz/Wsqm+4kQa6+pWrwB3Gm4ZVDCPe8e7aXhIkw5fYPrNgrFkTO7/4
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--b9sndWf12NMGupe57KZEG8wg8Jyx2jHvi
Content-Type: multipart/mixed; boundary="xPcPHWQxNidRjBsNwfwErZP86fs4rGOLT";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: fdmanana@kernel.org, linux-btrfs@vger.kernel.org
Message-ID: <a79f6d14-88bd-5a58-a508-8683428ad12f@gmx.com>
Subject: Re: [PATCH 2/2] Btrfs: report and handle error on unexpected first
 key on extent buffer
References: <20190218165826.23549-1-fdmanana@kernel.org>
In-Reply-To: <20190218165826.23549-1-fdmanana@kernel.org>

--xPcPHWQxNidRjBsNwfwErZP86fs4rGOLT
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2019/2/19 =E4=B8=8A=E5=8D=8812:58, fdmanana@kernel.org wrote:
> From: Filipe Manana <fdmanana@suse.com>
>=20
> When there is a kind of corruption in an extent buffer such that its fi=
rst
> key does not match the key at the respective parent slot, one of two th=
ings
> happens:

Isn't that handled by read_tree_block() already?

Thanks,
Qu

>=20
> 1) When assertions are enabled, we effectively hit a BUG_ON() which
>    requires rebooting the machine later. This also does not tell any
>    information about which extent buffer is affected, from which root,
>    the expected and found keys, etc.
>=20
> 2) When assertions are disabled, we just ignore the mismatch and assume=

>    everything is ok, which can potentially lead to all sorts of unexpec=
ted
>    problems later after a tree search (in the worst case, could lead to=

>    further silent corruption).
>=20
> So improve this by always checking if the first key of an extent buffer=
 is
> what it's supposed to be, when doing a key search at key_search(), and
> report and return an appropriate error. The overhead is just comparing =
one
> key, which is minimal and is anyway just done in a special case where w=
e
> skip the more expensive binary search (the binary search in the parent
> node returned 0, exact key match).
>=20
> Signed-off-by: Filipe Manana <fdmanana@suse.com>
> ---
>  fs/btrfs/ctree.c | 38 +++++++++++++++++---------------------
>  1 file changed, 17 insertions(+), 21 deletions(-)
>=20
> diff --git a/fs/btrfs/ctree.c b/fs/btrfs/ctree.c
> index 5b9f602fb9e2..a0bd0278208d 100644
> --- a/fs/btrfs/ctree.c
> +++ b/fs/btrfs/ctree.c
> @@ -2529,35 +2529,31 @@ setup_nodes_for_search(struct btrfs_trans_handl=
e *trans,
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
> +	struct btrfs_key found_key;
> +
>  	if (*prev_cmp !=3D 0) {
>  		*prev_cmp =3D btrfs_bin_search(b, key, level, slot);
>  		return *prev_cmp;
>  	}
> =20
> -	key_search_validate(b, key, level);
> +	if (level =3D=3D 0)
> +		btrfs_item_key_to_cpu(b, &found_key, 0);
> +	else
> +		btrfs_node_key_to_cpu(b, &found_key, 0);
> +
> +	if (btrfs_comp_cpu_keys(&found_key, key) !=3D 0) {
> +		btrfs_crit(b->fs_info,
> +"unexpected first key for extent buffer: bytenr=3D%llu level=3D%d root=
=3D%llu expected key=3D(%llu %u %llu) found key=3D(%llu %u %llu)",
> +			   btrfs_header_bytenr(b), level, btrfs_header_owner(b),
> +			   key->objectid, key->type, key->offset,
> +			   found_key.objectid, found_key.type,
> +			   found_key.offset);
> +		return -EUCLEAN;
> +	}
> +
>  	*slot =3D 0;
> =20
>  	return 0;
>=20


--xPcPHWQxNidRjBsNwfwErZP86fs4rGOLT--

--b9sndWf12NMGupe57KZEG8wg8Jyx2jHvi
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEELd9y5aWlW6idqkLhwj2R86El/qgFAlxrU6EACgkQwj2R86El
/qiVDQf+NKSYBWjTr634y8MJHhNBwAReoZCnhulc52ITjujTe606wLoubCmPIwCG
GDrCAMpg9OT0+gziXSkki+t5zZ2kzD3EetCS0/tb/VlEozaGEbEOdDuYtG2JQ2YP
Hqm3pp9rkAKFpymsjucMGbqGn7J0zVRCO/g9XvMSvXfLmwl6rBO/N0Jk+mbt4Ry1
42mFRbX51ytiKmsX49pkQ57y/JjNkHB4Su4WnfxPhMW15b/hMMIaf3t2unKHH5K+
Fgn2yDarZ/3gjLkumIGnjv2jSlmJtM2pTrXfdkujoCxbc7bfvic4hhL+1BnqRAnw
dWxndv6TInc3Ghgqtcb7JtLE/al08g==
=n/SG
-----END PGP SIGNATURE-----

--b9sndWf12NMGupe57KZEG8wg8Jyx2jHvi--
