Return-Path: <SRS0=yZnd=N7=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.7 required=3.0 tests=FREEMAIL_FORGED_FROMDOMAIN,
	FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EF6C3C43441
	for <linux-btrfs@archiver.kernel.org>; Tue, 20 Nov 2018 00:34:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B2CB52080C
	for <linux-btrfs@archiver.kernel.org>; Tue, 20 Nov 2018 00:34:07 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org B2CB52080C
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=gmx.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732190AbeKTLAZ (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 20 Nov 2018 06:00:25 -0500
Received: from mout.gmx.net ([212.227.17.20]:58197 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731351AbeKTLAY (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 20 Nov 2018 06:00:24 -0500
Received: from [0.0.0.0] ([149.28.201.231]) by mail.gmx.com (mrgmx103
 [212.227.17.174]) with ESMTPSA (Nemesis) id 0Lq9Ma-1flQQy0bfE-00drXc; Tue, 20
 Nov 2018 01:34:01 +0100
Subject: Re: [PATCH] Btrfs: fix race between enabling quotas and subvolume
 creation
To:     fdmanana@kernel.org, linux-btrfs@vger.kernel.org
References: <20181119162034.13132-1-fdmanana@kernel.org>
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
Message-ID: <25aa831b-5562-aaab-ef69-ef3e45c81fc4@gmx.com>
Date:   Tue, 20 Nov 2018 08:33:57 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.3.1
MIME-Version: 1.0
In-Reply-To: <20181119162034.13132-1-fdmanana@kernel.org>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="ZRBZs2IQ3rhnzt83VXLfiYZaAZAbnboQ3"
X-Provags-ID: V03:K1:2EJO0m7LddmbfC096Vhvzbz9JBKKfrqJBtARCG1iFOJo3H2MKoa
 mdV8E+l5ECh1AxDW435dD5P2IHAyse8SfmdzjGK9lcT/dbUG1uMLCTxzkkwWEojCQy01EmP
 u9bwzRf+4dpLclhFj14c2sfpoiwQQsMrlD59WS7SYeM80Kf2BXrbC1EXXyFghAL46ngrwLA
 z7ksGUw9y2MRHOi7q9p3g==
X-UI-Out-Filterresults: notjunk:1;V01:K0:8PN/PxRpmNk=:eH04/vcG/8nzyvb8wiJK5E
 iZVfBzOyS+1McA0GWcvy0LkmGcYpZ5CD+e2TfJX9jks8KhSTNCRt+lAhwn8lrUgs5CvXebKrI
 GaSEavb5X5y38S6YoYirI2fU6tcKxlbWh+1kKbh+miz5+SgCruLg7rbQXy+sEh39Ul1Ujvgx7
 iGXW/fL8pH7xtWqHueJYuoUjK+cE1vispnU8CMuqY22+JlKZ2LYpiLg5VPvDRWG++AWl28pFY
 M0c6JXgQ+bcC1rYE2jkt8l15m5M5/o+BI8scBA+0Ur3McKmwaaoTnZsGXW2ljhwG8rTSeqo7E
 td1yi9ryJTyhTxYRGziwFeXLdAyi7lcQClZj7bBVHKD+uaBAbVQ00+TjQRfa3kdOThJut7z/e
 k3jzmAx1fRWJWy9L8Jp2FVcnIaqUuHQr16kXMrQT1yKEyp9KPpQW7cji4FDU9u/fPkyCiXmRk
 5jLfQR5ptfSs2YvVdvC/2LHEGxVpiI3NOagp5co0ZZZAP7vLLnZmH6IFm2KERCkoZ3YJRk/w8
 u05cwzZACI51JXFKuq5raNKjIjUQtgNb0PDC/6tFEVdnG9E9PiB7kCxOmNesLF6qF/gtx2HhF
 Iv2owwaOhtxygeMEtls4qiL9CF0ocDlvi/0SgmiA12/0+RKvtMc7NhoEHPLT5gIA2yB7tqUPp
 ksS2+/b1EBYKG8j90pJK1GKwroKWePc2VDv4Tn36wFcfG2u84HWQ3bBz2kg3LtGkN4L5Vaw6u
 7OhxjPoqDKOXWznRaf1caRBf9youkTpc0FdKjmi4RVBpH04l6L5KaFa+NbUZ+35KSlGttLK+F
 nQGOMJC2rFQBBhwNphQ1CxziVaIk8pJxYvFcwhz/ha0/byWOSCKrQSKdODXde14yuVS4rnSOS
 zGf4VCg4GtnR+D6MnB5pogYmOGRTrT2ltMawYGBPurbZa+s6HD/vUU0Ku/lBDj
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--ZRBZs2IQ3rhnzt83VXLfiYZaAZAbnboQ3
Content-Type: multipart/mixed; boundary="e5AtejLN1BEm6ML0PtIloWT9Lia45hF6b";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: fdmanana@kernel.org, linux-btrfs@vger.kernel.org
Message-ID: <25aa831b-5562-aaab-ef69-ef3e45c81fc4@gmx.com>
Subject: Re: [PATCH] Btrfs: fix race between enabling quotas and subvolume
 creation
References: <20181119162034.13132-1-fdmanana@kernel.org>
In-Reply-To: <20181119162034.13132-1-fdmanana@kernel.org>

--e5AtejLN1BEm6ML0PtIloWT9Lia45hF6b
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2018/11/20 =E4=B8=8A=E5=8D=8812:20, fdmanana@kernel.org wrote:
> From: Filipe Manana <fdmanana@suse.com>
>=20
> We have a race between enabling quotas end subvolume creation that caus=
e
> subvolume creation to fail with -EINVAL, and the following diagram show=
s
> how it happens:
>=20
>               CPU 0                                          CPU 1
>=20
>  btrfs_ioctl()
>   btrfs_ioctl_quota_ctl()
>    btrfs_quota_enable()
>     mutex_lock(fs_info->qgroup_ioctl_lock)
>=20
>                                                   btrfs_ioctl()
>                                                    create_subvol()
>                                                     btrfs_qgroup_inheri=
t()
>                                                      -> save fs_info->q=
uota_root
>                                                         into quota_root=

>                                                      -> stores a NULL v=
alue
>                                                      -> tries to lock t=
he mutex
>                                                         qgroup_ioctl_lo=
ck
>                                                         -> blocks waiti=
ng for
>                                                            the task at =
CPU0
>=20
>    -> sets BTRFS_FS_QUOTA_ENABLED in fs_info
>    -> sets quota_root in fs_info->quota_root
>       (non-NULL value)
>=20
>    mutex_unlock(fs_info->qgroup_ioctl_lock)
>=20
>                                                      -> checks quota en=
abled
>                                                         flag is set
>                                                      -> returns -EINVAL=
 because
>                                                         fs_info->quota_=
root was
>                                                         NULL before it =
acquired
>                                                         the mutex
>                                                         qgroup_ioctl_lo=
ck
>                                                    -> ioctl returns -EI=
NVAL
>=20
> Returning -EINVAL to user space will be confusing if all the arguments
> passed to the subvolume creation ioctl were valid.
>=20
> Fix it by grabbing the value from fs_info->quota_root after acquiring
> the mutex.
>=20
> Signed-off-by: Filipe Manana <fdmanana@suse.com>

Reviewed-by: Qu Wenruo <wqu@suse.com>

Thanks,
Qu

> ---
>  fs/btrfs/qgroup.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
>=20
> diff --git a/fs/btrfs/qgroup.c b/fs/btrfs/qgroup.c
> index ae1358253b7b..0bdf28499790 100644
> --- a/fs/btrfs/qgroup.c
> +++ b/fs/btrfs/qgroup.c
> @@ -2250,7 +2250,7 @@ int btrfs_qgroup_inherit(struct btrfs_trans_handl=
e *trans, u64 srcid,
>  	int i;
>  	u64 *i_qgroups;
>  	struct btrfs_fs_info *fs_info =3D trans->fs_info;
> -	struct btrfs_root *quota_root =3D fs_info->quota_root;
> +	struct btrfs_root *quota_root;
>  	struct btrfs_qgroup *srcgroup;
>  	struct btrfs_qgroup *dstgroup;
>  	u32 level_size =3D 0;
> @@ -2260,6 +2260,7 @@ int btrfs_qgroup_inherit(struct btrfs_trans_handl=
e *trans, u64 srcid,
>  	if (!test_bit(BTRFS_FS_QUOTA_ENABLED, &fs_info->flags))
>  		goto out;
> =20
> +	quota_root =3D fs_info->quota_root;
>  	if (!quota_root) {
>  		ret =3D -EINVAL;
>  		goto out;
>=20


--e5AtejLN1BEm6ML0PtIloWT9Lia45hF6b--

--ZRBZs2IQ3rhnzt83VXLfiYZaAZAbnboQ3
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEELd9y5aWlW6idqkLhwj2R86El/qgFAlvzVnUACgkQwj2R86El
/qjrCQf/TPwAyTQwF3ecH+P7WVspYRKMtp6QQQTfM5MLOVj+WoBaiYvIqzIiZQT7
rO2e6lzAQcv2++SSt9atGoOnLJRLiWjyEJJa578/WxfJkkWWs+e1WFpa907vNDi1
DFHWzmBDBB4fDiUnKQ2ELEMcIzYkFoE1mwzMydmATwZLcKcC3Ws7P95ZO9C+TBdZ
B6xFlS5B9Yd6dyD0WPb0oA7jDgEGqn2eX9ld2vJRTsnD6VGqkzW9jp5xwaWNhe/O
j6PgD92swVshq5YR5c5C0g5I8/PZy55dr1p4tYHhS8gtoJIK2igYXCK+qeKLXF0X
wRKvpML3ZpYvzZEnZc71qCYXS/cZpA==
=FJ92
-----END PGP SIGNATURE-----

--ZRBZs2IQ3rhnzt83VXLfiYZaAZAbnboQ3--
