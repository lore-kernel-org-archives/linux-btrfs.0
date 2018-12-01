Return-Path: <SRS0=eQkg=OK=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.7 required=3.0 tests=FREEMAIL_FORGED_FROMDOMAIN,
	FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 773E4C04EB8
	for <linux-btrfs@archiver.kernel.org>; Sat,  1 Dec 2018 00:19:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 30B4D20673
	for <linux-btrfs@archiver.kernel.org>; Sat,  1 Dec 2018 00:19:54 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 30B4D20673
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=gmx.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726340AbeLALa7 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Sat, 1 Dec 2018 06:30:59 -0500
Received: from mout.gmx.net ([212.227.17.22]:43413 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725867AbeLALa7 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 1 Dec 2018 06:30:59 -0500
Received: from [0.0.0.0] ([149.28.201.231]) by mail.gmx.com (mrgmx102
 [212.227.17.174]) with ESMTPSA (Nemesis) id 0MSY2q-1guM2n09Lg-00RbJI; Sat, 01
 Dec 2018 01:19:45 +0100
Subject: Re: [PATCH 1/2] btrfs: catch cow on deleting snapshots
To:     Josef Bacik <josef@toxicpanda.com>, linux-btrfs@vger.kernel.org,
        kernel-team@fb.com
Cc:     Josef Bacik <jbacik@fb.com>
References: <20181130165214.17883-1-josef@toxicpanda.com>
 <20181130165214.17883-2-josef@toxicpanda.com>
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
Message-ID: <4a9577f2-9c3b-eb9e-a6a5-b3878769cd2e@gmx.com>
Date:   Sat, 1 Dec 2018 08:19:40 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.3.1
MIME-Version: 1.0
In-Reply-To: <20181130165214.17883-2-josef@toxicpanda.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="x6Q4ffyH4VaAnupsSc9sdbJwRVPpJgzUM"
X-Provags-ID: V03:K1:PBxKUPq2ik9Z9QgTRr2y60UeBJaWrDzxLnZzHsboEcRKoVWpAtU
 X0WXyKcavJKaA0HHECsHXH7c4U9cOYF6fSdgGvud4CUsTBY66Hd9OiNuY/Usi4GY/I+BW4o
 Ttl6jEmfH9MHOqD2zaTsDZyXrtZcXuCDKyNOgeZgwPvEI4VH71JYMZXmfBsPpUzJUsAShYn
 q02zgkTXVZxaC4CJYl1Ng==
X-UI-Out-Filterresults: notjunk:1;V03:K0:MzW/dH2xEJs=:81FlunJB8bJht3SclDdRGa
 i7YK54ZXt0pqLOH0X7Sz7yaDEDfo75bQs1AL3x7l4AikGu2ILTd7N7B4wuSHjlwfKSeYyy6oU
 HIJMFmeS4fmo5rnAc67O599dc+Axdb9+4pSy4IFdv+JioMXhF1xD4lTOdVkoTq7h6rPsbWSIY
 MSdkMG0xZVpQCp1HsbhoCuPgx6HWsL1BbNi4lHZGAtRS97uXTpIhtgdxkupRB/uH1ZAtoyqCO
 jdOIKujqy7jflCqVKmeMcW4cGBFBFMOocKjFvOSQiLcve0Ret/oZk02vzCyUIsZ8y1pHNTSi0
 M7CNw4BbLgbenQpujRbqfqEX8nTvz2TRhF+Yp43Ccijzhvk+0e5Cbm9CLQd8so4BjOa1yGSjB
 qzYgSPqn/kC/GlCka8A4WtlD5AoIPi7eXxks7Nn291oDxvqjddpHnDl/vHeyUDrFIlGZmLuHj
 Q/GHkOfXkHBaDGCRjw3QgeVl29gW7FOnY94Caz5Hl1xYpYg2dzkiq1pvd7IaFk7p/sZQH18UO
 TQE5RHDsbl+bs4ee0inBA1mlAr7D6a22rklC8PaX52+aCAlbxgriZEmoUn9aIUcXcQJMAHyUv
 p4/OMEIodksm2K/YUnTavAQLeUZ//eb/3z1YYF/eT97TzlRP41V1jh3580bhBkYVzOpEI1E5Z
 wQnsU5GSXc4QT6aBYeGchQODx7TSiGjAQfE4XjadyNUCIsWALCHuHvF+YivQ40HiMqcAbaD2j
 y0T51FmtvRcM1zeO/0XzFPYMJWn1gXz9f1EkqoxOLkIdV77LjacN+rrIGZMMSR61zMM1TYPDB
 AoELi58Hws47f2q12ZbsbtzYzm9Ec/4GMWym69Bz2+LshSje1DmuVSINdidIzusrxDg0Sru/D
 jiCjW6+YioyTmW7uL0mviFILUDipWSrwMM79BIrq89RIL4YvINp3PLTIXezaNQ
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--x6Q4ffyH4VaAnupsSc9sdbJwRVPpJgzUM
Content-Type: multipart/mixed; boundary="DwNVpvVOHnmfFX9EBsC0io2wxt3KnVDOW";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: Josef Bacik <josef@toxicpanda.com>, linux-btrfs@vger.kernel.org,
 kernel-team@fb.com
Cc: Josef Bacik <jbacik@fb.com>
Message-ID: <4a9577f2-9c3b-eb9e-a6a5-b3878769cd2e@gmx.com>
Subject: Re: [PATCH 1/2] btrfs: catch cow on deleting snapshots
References: <20181130165214.17883-1-josef@toxicpanda.com>
 <20181130165214.17883-2-josef@toxicpanda.com>
In-Reply-To: <20181130165214.17883-2-josef@toxicpanda.com>

--DwNVpvVOHnmfFX9EBsC0io2wxt3KnVDOW
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2018/12/1 =E4=B8=8A=E5=8D=8812:52, Josef Bacik wrote:
> From: Josef Bacik <jbacik@fb.com>
>=20
> When debugging some weird extent reference bug I suspected that we were=

> changing a snapshot while we were deleting it, which could explain my
> bug.

May I ask under which case we're going to modify an unlinked snapshot?

Maybe metadata relocation?

Thanks,
Qu

> This was indeed what was happening, and this patch helped me
> verify my theory.  It is never correct to modify the snapshot once it's=

> being deleted, so mark the root when we are deleting it and make sure w=
e
> complain about it when it happens.
>=20
> Signed-off-by: Josef Bacik <josef@toxicpanda.com>
> ---
>  fs/btrfs/ctree.c       | 3 +++
>  fs/btrfs/ctree.h       | 1 +
>  fs/btrfs/extent-tree.c | 9 +++++++++
>  3 files changed, 13 insertions(+)
>=20
> diff --git a/fs/btrfs/ctree.c b/fs/btrfs/ctree.c
> index 5912a97b07a6..5f82f86085e8 100644
> --- a/fs/btrfs/ctree.c
> +++ b/fs/btrfs/ctree.c
> @@ -1440,6 +1440,9 @@ noinline int btrfs_cow_block(struct btrfs_trans_h=
andle *trans,
>  	u64 search_start;
>  	int ret;
> =20
> +	if (test_bit(BTRFS_ROOT_DELETING, &root->state))
> +		WARN(1, KERN_CRIT "cow'ing blocks on a fs root thats being dropped\n=
");
> +
>  	if (trans->transaction !=3D fs_info->running_transaction)
>  		WARN(1, KERN_CRIT "trans %llu running %llu\n",
>  		       trans->transid,
> diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
> index facde70c15ed..5a3a94ccb65c 100644
> --- a/fs/btrfs/ctree.h
> +++ b/fs/btrfs/ctree.h
> @@ -1199,6 +1199,7 @@ enum {
>  	BTRFS_ROOT_FORCE_COW,
>  	BTRFS_ROOT_MULTI_LOG_TASKS,
>  	BTRFS_ROOT_DIRTY,
> +	BTRFS_ROOT_DELETING,
>  };
> =20
>  /*
> diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
> index 581c2a0b2945..dcb699dd57f3 100644
> --- a/fs/btrfs/extent-tree.c
> +++ b/fs/btrfs/extent-tree.c
> @@ -9333,6 +9333,15 @@ int btrfs_drop_snapshot(struct btrfs_root *root,=

>  	if (block_rsv)
>  		trans->block_rsv =3D block_rsv;
> =20
> +	/*
> +	 * This will help us catch people modifying the fs tree while we're
> +	 * dropping it.  It is unsafe to mess with the fs tree while it's bei=
ng
> +	 * dropped as we unlock the root node and parent nodes as we walk dow=
n
> +	 * the tree, assuming nothing will change.  If something does change
> +	 * then we'll have stale information and drop references to blocks we=
've
> +	 * already dropped.
> +	 */
> +	set_bit(BTRFS_ROOT_DELETING, &root->state);
>  	if (btrfs_disk_key_objectid(&root_item->drop_progress) =3D=3D 0) {
>  		level =3D btrfs_header_level(root->node);
>  		path->nodes[level] =3D btrfs_lock_root_node(root);
>=20


--DwNVpvVOHnmfFX9EBsC0io2wxt3KnVDOW--

--x6Q4ffyH4VaAnupsSc9sdbJwRVPpJgzUM
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEELd9y5aWlW6idqkLhwj2R86El/qgFAlwB05wACgkQwj2R86El
/qhAbgf9HXjfc53I/nKhRlQjbIULt5AoJ9kEvnf7Qg9ff0jcZ2xAKfn+9dJaW/g7
01hV6yMJ4hDv8Nu9c/ToCN7OGWm575UOJfTlr2SDXxMIJTDftKNm90m27QM2sVNg
jcpR5Us9tkhGUb7UIiaMP/hSOp+sgnZ2yzOywGsENfQ+SKWFao9wOKKXkmfp4Yf5
erjcut+KvVZZgKupO9pj+0QW+wSzwB0qd9i4vaSxwgS78EAufa0lOuSekrc5QuWf
guJSrPYDJvPRi/mkg03n4anGXUXK9tHqjyQrW8LMVLZCE5zKDqJKHFyWJhjFR6EB
SOlka8z51IklsqdCzykJ8D5oIKqDNg==
=ufm5
-----END PGP SIGNATURE-----

--x6Q4ffyH4VaAnupsSc9sdbJwRVPpJgzUM--
