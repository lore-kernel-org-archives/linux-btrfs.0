Return-Path: <SRS0=ig1K=R7=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.7 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C990DC43381
	for <linux-btrfs@archiver.kernel.org>; Thu, 28 Mar 2019 00:00:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7DA0F2082F
	for <linux-btrfs@archiver.kernel.org>; Thu, 28 Mar 2019 00:00:58 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=gmx.net header.i=@gmx.net header.b="EyM6m1u/"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727537AbfC1AA5 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 27 Mar 2019 20:00:57 -0400
Received: from mout.gmx.net ([212.227.17.22]:47929 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725601AbfC1AA5 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 27 Mar 2019 20:00:57 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1553731249;
        bh=fvJt4yfv7tatTK/9pAsUh6uwLxnZPjrB94off2IqSKQ=;
        h=X-UI-Sender-Class:Subject:To:References:From:Date:In-Reply-To;
        b=EyM6m1u/1H0Ycd+0zHGaHH/4j5xmpBNOWZmsOS5515o0ESD6vLWd821ZZmocCYZVI
         wmM0LauKf3QxXWhftpH3vhAwIhwAvho9xizoNj2jnaJOXZRGURaS0wdFhZd/jDdkRX
         9v11xUcKxbyq8SFdLcAc9Y1XRTBZNUEQ00fEDR50=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from [0.0.0.0] ([54.250.245.166]) by mail.gmx.com (mrgmx101
 [212.227.17.174]) with ESMTPSA (Nemesis) id 0LwF9u-1gtafB2Hz4-01873F; Thu, 28
 Mar 2019 01:00:49 +0100
Subject: Re: [PATCH] btrfs: qgroup: remove obsolete fs_info members
To:     David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org
References: <20190327160245.27181-1-dsterba@suse.com>
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
Message-ID: <33e22248-efed-8341-4835-774af490c179@gmx.com>
Date:   Thu, 28 Mar 2019 08:00:42 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.5.3
MIME-Version: 1.0
In-Reply-To: <20190327160245.27181-1-dsterba@suse.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="ENmOuGZtxSVgoHgKFhnlSGjeKrmULGT7Y"
X-Provags-ID: V03:K1:ygEGO7aohN17rElwgYxPD87kD+JiCvApBg65qAgxHP5LLOcQErb
 tJXDCJzA4ABOOHKIdhE3ayCFYwD0SG08Z4cYEZfMK38KyZ3VB0gDfCB3fwpeFmBL9y1U+mj
 OVmNn1rg9uh+vqLFgbxvyKtjXY1iDGJM7MDjTq6dXUfwEBEJzTy+0skyBudlaGxnuaqAD6h
 6CKrIjmkoKhDDrMWVWDrg==
X-UI-Out-Filterresults: notjunk:1;V03:K0:EFoprCKJGp8=:Ri3mmnk3I7S82182zfqx/b
 Na6EC2UVdaWa3Mxc8ePbWsR6re0GQbMlVEOplNWZZgYwonp3+KeO8BsbceTQg78+20mUPpBXz
 CRaSRBYfH4tmjwnutjMHZ9C6DKfgnbMMwl0QafQkCSwcmUd8T1GzTZKWEb+suTnD4gUoksouK
 4siIUvmrox1r9hX1PMZoK17DCJ85N/53VgQsiHcvaqYYUHPXVOdpFnIYA87BBaUDd6IeUqf5e
 h+jude1zjbtSUmdj24d7dCr+eG7Vv5tUfHI9XE33hUuOhQ7SEM3bNWyY9+znaU1DK8VO3jMKK
 Jv95IVx5RK4f6tJSSACH3nFe3g1nwDF9xQznyedDCUmyOCZDfLRxCXxq817Cd9pekn2i0pspK
 UpzEfsE+LDKQajWKQbz2UHxx/g4I9KvMEgTOvbo47KzvtIOpeo9KiMTqTKGt4B7RgHseaxbJv
 /vBpT6CcSBOPWPiPpwP8EOmQBv0fHogrehYU+v4mZlqz6BsWHoTOBQ0lutPiMjtVBn++KnTBa
 iL7CiY4ynhk51piFo5vXiT8wAb09Uyhc3FK/ytZEd1f08LEnr68NerEvSpMalinVZ4LnQ148M
 uMSep8nBlL5V2AfMOUv2tyNo7ABEp8/k1DFBQzw4i91kBgrO2WGZCMNsTBy65ENegz26y6N+E
 dAEdPZ41wVTlZEpGg6yw9NelaT+0UjEjWFUSahPVvmFl3/2uf9oVv+eG7zWPhGBVh9WrKz1+2
 XWH3yy2prYGS8eRyKrBkXZFUNuQVzWuVDaaRkhBgltchadVbEDauUjUZsuOoiXxuXIql4T3ZP
 3W4vhn3YTjhSvz9fk2f6ZXDhJvEeMap9fHY3WSWYYmklPM4yr7Ub8FcNTneyE1QtrmybmD5dR
 DBpdOS4dYzdzi5ebBYJNBdfB9MfC5mWHYbynpLXj6eYPurE/3m/Uys5Lnb15VR
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--ENmOuGZtxSVgoHgKFhnlSGjeKrmULGT7Y
Content-Type: multipart/mixed; boundary="v4CEWPO9d3nB1E91tk588k8tdpw1TkXuX";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org
Message-ID: <33e22248-efed-8341-4835-774af490c179@gmx.com>
Subject: Re: [PATCH] btrfs: qgroup: remove obsolete fs_info members
References: <20190327160245.27181-1-dsterba@suse.com>
In-Reply-To: <20190327160245.27181-1-dsterba@suse.com>

--v4CEWPO9d3nB1E91tk588k8tdpw1TkXuX
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2019/3/28 =E4=B8=8A=E5=8D=8812:02, David Sterba wrote:
> The commit fcebe4562dec ("Btrfs: rework qgroup accounting") reworked
> qgroups and added some new structures. Another rework of qgroup
> mechanics e69bcee37692 ("btrfs: qgroup: Cleanup the old
> ref_node-oriented mechanism.") stopped using them and left uncleaned.
>=20
> Signed-off-by: David Sterba <dsterba@suse.com>

Reviewed-by: Qu Wenruo <wqu@suse.com>

Thanks,
Qu

> ---
>  fs/btrfs/ctree.h   | 3 ---
>  fs/btrfs/disk-io.c | 3 ---
>  2 files changed, 6 deletions(-)
>=20
> diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
> index 1d1e12400552..5d85c55032dd 100644
> --- a/fs/btrfs/ctree.h
> +++ b/fs/btrfs/ctree.h
> @@ -1092,10 +1092,7 @@ struct btrfs_fs_info {
> =20
>  	/* holds configuration and tracking. Protected by qgroup_lock */
>  	struct rb_root qgroup_tree;
> -	struct rb_root qgroup_op_tree;
>  	spinlock_t qgroup_lock;
> -	spinlock_t qgroup_op_lock;
> -	atomic_t qgroup_op_seq;
> =20
>  	/*
>  	 * used to avoid frequently calling ulist_alloc()/ulist_free()
> diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
> index 8740152cce1f..c3b89584dad6 100644
> --- a/fs/btrfs/disk-io.c
> +++ b/fs/btrfs/disk-io.c
> @@ -2174,7 +2174,6 @@ static void btrfs_init_qgroup(struct btrfs_fs_inf=
o *fs_info)
>  	spin_lock_init(&fs_info->qgroup_lock);
>  	mutex_init(&fs_info->qgroup_ioctl_lock);
>  	fs_info->qgroup_tree =3D RB_ROOT;
> -	fs_info->qgroup_op_tree =3D RB_ROOT;
>  	INIT_LIST_HEAD(&fs_info->dirty_qgroups);
>  	fs_info->qgroup_seq =3D 1;
>  	fs_info->qgroup_ulist =3D NULL;
> @@ -2679,7 +2678,6 @@ int open_ctree(struct super_block *sb,
>  	spin_lock_init(&fs_info->defrag_inodes_lock);
>  	spin_lock_init(&fs_info->tree_mod_seq_lock);
>  	spin_lock_init(&fs_info->super_lock);
> -	spin_lock_init(&fs_info->qgroup_op_lock);
>  	spin_lock_init(&fs_info->buffer_lock);
>  	spin_lock_init(&fs_info->unused_bgs_lock);
>  	rwlock_init(&fs_info->tree_mod_log_lock);
> @@ -2706,7 +2704,6 @@ int open_ctree(struct super_block *sb,
> =20
>  	atomic_set(&fs_info->async_delalloc_pages, 0);
>  	atomic_set(&fs_info->defrag_running, 0);
> -	atomic_set(&fs_info->qgroup_op_seq, 0);
>  	atomic_set(&fs_info->reada_works_cnt, 0);
>  	atomic_set(&fs_info->nr_delayed_iputs, 0);
>  	atomic64_set(&fs_info->tree_mod_seq, 0);
>=20


--v4CEWPO9d3nB1E91tk588k8tdpw1TkXuX--

--ENmOuGZtxSVgoHgKFhnlSGjeKrmULGT7Y
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEELd9y5aWlW6idqkLhwj2R86El/qgFAlycDqoACgkQwj2R86El
/qgZyAf+J7ihDZ9x5hh6ViukcC/JVCZM7uNx8Jr9D1VuZXuVTLpIInObbWO+rk7u
N0YDNP/YWNFtr2XB0XNHTYiF+uF1y5hmRjR7nfdmlnc3u7DMfwZwc00cCe6btj3B
KeZkgWHE9kFx9EhFehf+sgHjKAyenqzs3xnhKreJUi3UVMTSxA47bYvYSUWefbzZ
Sj51GLAx+K2+Zmx1AM+8gVEvKLR5xTWHTLGjDn+ZZyeOLYMzqRLYClPYhp6WpoJ8
kXaAIIAK+3Pfmx0zz6/2erFMgr30MkzB7LypokTpcmGzGb4fkbuJllEIYs+LZs+m
mfGmmikjD/QirUiB3NPLD5ngG/wq1w==
=fDsi
-----END PGP SIGNATURE-----

--ENmOuGZtxSVgoHgKFhnlSGjeKrmULGT7Y--
