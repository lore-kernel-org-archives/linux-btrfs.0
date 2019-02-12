Return-Path: <SRS0=Udpi=QT=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=FREEMAIL_FORGED_FROMDOMAIN,
	FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0028BC282C4
	for <linux-btrfs@archiver.kernel.org>; Tue, 12 Feb 2019 11:10:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C178C2184A
	for <linux-btrfs@archiver.kernel.org>; Tue, 12 Feb 2019 11:10:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729254AbfBLLKI (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 12 Feb 2019 06:10:08 -0500
Received: from mout.gmx.net ([212.227.15.19]:42819 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728796AbfBLLKI (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 12 Feb 2019 06:10:08 -0500
Received: from [0.0.0.0] ([149.28.201.231]) by mail.gmx.com (mrgmx002
 [212.227.17.184]) with ESMTPSA (Nemesis) id 0MexFh-1girnA425x-00Ob4v; Tue, 12
 Feb 2019 12:09:58 +0100
Subject: Re: [PATCH] btrfs: qgroup: Make qgroup async transaction commit more
 aggressive
To:     Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org
References: <20190124235527.5563-1-wqu@suse.com>
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
Message-ID: <34ea4641-127a-2931-dfff-ead9a30c5efb@gmx.com>
Date:   Tue, 12 Feb 2019 19:09:54 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.5.0
MIME-Version: 1.0
In-Reply-To: <20190124235527.5563-1-wqu@suse.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="c7z3mXzKn0LaxP19zI0dDxMmKliDJL9Pd"
X-Provags-ID: V03:K1:GMVABg8mRzYh1XgLzR7sULXi8b3ZZ/z+Huwg3I54KKMpvXlRLJK
 4+5bnsoQW0spIogTQ4MKb9Z4CAbUmVR/4yVQVaJlRus9HDu4sFb1mFjyicfxArSaHZMPvyL
 1taDS2/1VkVpDltPanV6dV6GTeOjge2hUENhRf4Z3HxVuaKylwuS4pDaT1Zh9yym/Eu9ipR
 zThYSksJx4CUA+it9xksw==
X-UI-Out-Filterresults: notjunk:1;V03:K0:s3m/EguhkAo=:Y/VqJBfhLzQZ3bIGC3jX3s
 09oR8ZDi6ykZ1x+EY7JgRAiw0AQlxaiVVIWIJq+4o+ffepC6h74lNpO9yjSWIY8RPpEOOrx+O
 1y+DRu4QhlOF1T4jNO72Xmmatkjhj4dFWZyrM4Zy725W9oORdEOmfWIyHjWUFEBgAmKmgSoLo
 rIvV3ZirEs1S06Yh93HAIFybH2+xgshXQ0xGHUCYTW8iKjjYgUIi/v8MhA9HHzY74kKBTG8XY
 OBaVKSdHMKkSVNggULaDB0/Mrnr8lw1F4I6BI1MkwWKCgi31z+feUjreK5Ey0E4DI13H2IZ5F
 nlCQ2P/MONCd8CWpFI+REr4fphxqFgEtsAZgfcBW/AqKbw93ShiaBs1ObNBDEsdUpSwePnBUs
 OgjWh0A6q8Xc7oJT0WdBqx4S4Ca86iPiuTXwPVFyFFs3UbS1aS8KN0I5E+k54DEh4GMQcC279
 VB38fGBouJuJ4M8qTV6v/+ZdSu/FXSYGpHce9xwNFEsVxKH/P2P2BhPyWRJGsI+Vb/PflgwHU
 vEDYF1yR5ipJiTHqS0Q1ViroAbddWu84CKn6j1rECSfJYrOkD3zT+8AZE/IScyXJGgdXnOhYb
 q+MLixz3BaQj4PuE2Qr1rYl2RDv31ajt1uLlrRV+9c/I4/TOAF4sRZlibiBShFvji43fRjdP5
 B13JLXzf59tyXKDzZYV4k8HZjPjimNfth2Tnkbyt9nxCedDkItWFqDNlunsK4fAfXMyKYN1vl
 dAUUor5ENj3ohQqzAhTDbf2Sb8DNmd85Herjr923LvS6B4EtEZ5nTkV8sL0gHM5GAKDtl5UtF
 8P8ym1JythmKU0MY35sInEqUnWMERHcIqo6tMdLo+KpFFSmWvOCznOCgg4YkCCQQamD31bPzF
 OfOwqbW7N1QCQmh+gmiOE7FAakHAS5w9OWEDZKMyyrLO0jskdlqT9pLqVeQEZw
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--c7z3mXzKn0LaxP19zI0dDxMmKliDJL9Pd
Content-Type: multipart/mixed; boundary="NQJ3D7WN2AvthWRyU6aQ2RBjtRuDeDcQS";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org
Message-ID: <34ea4641-127a-2931-dfff-ead9a30c5efb@gmx.com>
Subject: Re: [PATCH] btrfs: qgroup: Make qgroup async transaction commit more
 aggressive
References: <20190124235527.5563-1-wqu@suse.com>
In-Reply-To: <20190124235527.5563-1-wqu@suse.com>

--NQJ3D7WN2AvthWRyU6aQ2RBjtRuDeDcQS
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

Gentle ping?

It would be pretty nice to make it into the next merge windows (v5.1).

Thanks,
Qu

On 2019/1/25 =E4=B8=8A=E5=8D=887:55, Qu Wenruo wrote:
> [BUG]
> Btrfs qgroup will still hit EDQUOT under the following case:
>=20
>   #!/bin/bash
>=20
>   dev=3D/dev/test/test
>   mnt=3D/mnt/btrfs
>   umount $mnt &> /dev/null
>   umount $dev &> /dev/null
>=20
>   mkfs.btrfs -f $dev
>   mount $dev $mnt -o nospace_cache
>=20
>   btrfs subv create $mnt/subv
>   btrfs quota enable $mnt
>   btrfs quota rescan -w $mnt
>   btrfs qgroup limit -e 1G $mnt/subv
>=20
>   fallocate -l 900M $mnt/subv/padding
>   sync
>=20
>   rm $mnt/subv/padding
>=20
>   # Hit EDQUOT
>   xfs_io -f -c "pwrite 0 512M" $mnt/subv/real_file
>=20
> [CAUSE]
> Since commit a514d63882c3 ("btrfs: qgroup: Commit transaction in advanc=
e
> to reduce early EDQUOT"), btrfs is not forced to commit transaction to
> reclaim more quota space.
>=20
> Instead, we just check pertrans metadata reservation against some
> threshold and try to do asynchronously transaction commit.
>=20
> However in above case, the pertrans metadata reservation is pretty smal=
l
> thus it will never trigger asynchronous transaction commit.
>=20
> [FIX]
> Instead of only accounting pertrans metadata reservation, we calculate
> how much free space we have, and if there isn't much free space left,
> commit transaction asynchronously to try to free some space.
>=20
> This may slow down the fs when we have less than 32M free qgroup space,=

> but should reduce a lot of false EDQUOT, so the cost should be
> acceptable.
>=20
> Signed-off-by: Qu Wenruo <wqu@suse.com>
> ---
>  fs/btrfs/qgroup.c | 29 ++++++++++++++++-------------
>  1 file changed, 16 insertions(+), 13 deletions(-)
>=20
> diff --git a/fs/btrfs/qgroup.c b/fs/btrfs/qgroup.c
> index 4e473a998219..f0b7425bf289 100644
> --- a/fs/btrfs/qgroup.c
> +++ b/fs/btrfs/qgroup.c
> @@ -2843,15 +2843,15 @@ int btrfs_qgroup_inherit(struct btrfs_trans_han=
dle *trans, u64 srcid,
>   * Two limits to commit transaction in advance.
>   *
>   * For RATIO, it will be 1/RATIO of the remaining limit
> - * (excluding data and prealloc meta) as threshold.
> + * as threshold.
>   * For SIZE, it will be in byte unit as threshold.
>   */
> -#define QGROUP_PERTRANS_RATIO		32
> -#define QGROUP_PERTRANS_SIZE		SZ_32M
> +#define QGROUP_FREE_RATIO		32
> +#define QGROUP_FREE_SIZE		SZ_32M
>  static bool qgroup_check_limits(struct btrfs_fs_info *fs_info,
>  				const struct btrfs_qgroup *qg, u64 num_bytes)
>  {
> -	u64 limit;
> +	u64 free;
>  	u64 threshold;
> =20
>  	if ((qg->lim_flags & BTRFS_QGROUP_LIMIT_MAX_RFER) &&
> @@ -2870,20 +2870,23 @@ static bool qgroup_check_limits(struct btrfs_fs=
_info *fs_info,
>  	 */
>  	if ((qg->lim_flags & (BTRFS_QGROUP_LIMIT_MAX_RFER |
>  			      BTRFS_QGROUP_LIMIT_MAX_EXCL))) {
> -		if (qg->lim_flags & BTRFS_QGROUP_LIMIT_MAX_EXCL)
> -			limit =3D qg->max_excl;
> -		else
> -			limit =3D qg->max_rfer;
> -		threshold =3D (limit - qg->rsv.values[BTRFS_QGROUP_RSV_DATA] -
> -			    qg->rsv.values[BTRFS_QGROUP_RSV_META_PREALLOC]) /
> -			    QGROUP_PERTRANS_RATIO;
> -		threshold =3D min_t(u64, threshold, QGROUP_PERTRANS_SIZE);
> +		if (qg->lim_flags & BTRFS_QGROUP_LIMIT_MAX_EXCL) {
> +			free =3D (qg->max_excl - qgroup_rsv_total(qg) -
> +				     qg->excl);
> +			threshold =3D min_t(u64, qg->max_excl / QGROUP_FREE_RATIO,
> +					  QGROUP_FREE_SIZE);
> +		} else {
> +			free =3D (qg->max_rfer - qgroup_rsv_total(qg) -
> +				     qg->rfer);
> +			threshold =3D min_t(u64, qg->max_rfer / QGROUP_FREE_RATIO,
> +					  QGROUP_FREE_SIZE);
> +		}
> =20
>  		/*
>  		 * Use transaction_kthread to commit transaction, so we no
>  		 * longer need to bother nested transaction nor lock context.
>  		 */
> -		if (qg->rsv.values[BTRFS_QGROUP_RSV_META_PERTRANS] > threshold)
> +		if (free < threshold)
>  			btrfs_commit_transaction_locksafe(fs_info);
>  	}
> =20
>=20


--NQJ3D7WN2AvthWRyU6aQ2RBjtRuDeDcQS--

--c7z3mXzKn0LaxP19zI0dDxMmKliDJL9Pd
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEELd9y5aWlW6idqkLhwj2R86El/qgFAlxiqYIACgkQwj2R86El
/qiWRQf+LMWHGxfZJKOhyd6kYYp+FU2hintWQdMmsrVjtbDQsveOdvovNZB8uvl3
o/x1d98EGisQSBbzcwi4UHwoeowRUK7RLD7N35s2ctIqy3y8nkdKsIukr6FBYvvM
SGEW9U3Q3fskQYuWTX+ub4djmdz5OtZhW1QyccvVLMUs0gSxVqWQMaVo/hodHeKW
Svz0aSjw4AJPhkGoiU47jT1f4Fyjghrr6VEXePjPWbKCIBFhAYngUPZFE6T7IQz/
IMiSxCd2/dlbSFEdzg4YNTelqvQtK3ebBP5db6n/0x4pNqO9QdxzZ09HAZXYpMaI
UC8AaOHlGj2OMczh4p5lGMOrxf4dIw==
=cPOC
-----END PGP SIGNATURE-----

--c7z3mXzKn0LaxP19zI0dDxMmKliDJL9Pd--
