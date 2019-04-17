Return-Path: <SRS0=+3PB=ST=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.7 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2B8EEC10F12
	for <linux-btrfs@archiver.kernel.org>; Wed, 17 Apr 2019 09:41:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DB33E2073F
	for <linux-btrfs@archiver.kernel.org>; Wed, 17 Apr 2019 09:41:11 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=gmx.net header.i=@gmx.net header.b="O1P9Uczw"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731554AbfDQJlK (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 17 Apr 2019 05:41:10 -0400
Received: from mout.gmx.net ([212.227.17.22]:40797 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726237AbfDQJlK (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 17 Apr 2019 05:41:10 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1555494064;
        bh=ZTkuiZ/pxWJqHBJ06Q5rU8eUtxYpYSYCv7siaENNN10=;
        h=X-UI-Sender-Class:Subject:To:References:From:Date:In-Reply-To;
        b=O1P9Uczw5S6Hn3I1u8b5IdVHPzHFqVGaII7iEMo+YPkLT4r2VhiR/eJ15vQzISf7D
         8jMjGRjGWbPas1nlo/HIvmoDXUI/er3el/nDvl1UEGYq2O9F2oklQKsiDcq0lhYeGy
         kO0EcYgXapFrydPOY4Vc3dP5BSnDtkWL9NspK1LI=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from [0.0.0.0] ([149.28.201.231]) by mail.gmx.com (mrgmx101
 [212.227.17.174]) with ESMTPSA (Nemesis) id 0MGWR2-1h3RVu2BP6-00DGQs; Wed, 17
 Apr 2019 11:41:03 +0200
Subject: Re: [PATCH] Btrfs: remove no longer used function to run delayed refs
 asynchronously
To:     fdmanana@kernel.org, linux-btrfs@vger.kernel.org
References: <20190417092847.17299-1-fdmanana@kernel.org>
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
Message-ID: <1155e422-9269-a863-3980-115c4d31edf0@gmx.com>
Date:   Wed, 17 Apr 2019 17:40:57 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <20190417092847.17299-1-fdmanana@kernel.org>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="I4EH1gpTRNujztUoJLt8tnCEAmNvwTEou"
X-Provags-ID: V03:K1:TUbxlvotp99Pjafk05bfwPLOFNSe7r1PtKXwlI/SEzcZfYpnyp/
 l9OSNn4qh4LBP85Y5ucPUTGeZWrdWvsP2PJxVasUosDCg98A5pQ67TAh1WQ3avkwWRpfP5T
 7k2y7wcQWyNJv7Ge8betNag6UjzvXtPn3pGr0QqEKawAxOFW8v43c+OD6e+14PE1CjZ9+vk
 GhrqNBxpDlvraF46pURsQ==
X-UI-Out-Filterresults: notjunk:1;V03:K0:laaBsYny1rg=:Emt0U8YkPRJX4GevoxoE/L
 +Z+Tzwwz/KOx5n0patHOppYQiDki4tqXEo7DVNLcOhy1p9LitEyGIiaqCpGNN6Qhm88CguVyP
 /rw+p22UigYzgPvYUDMFnh7ZRBqQTyPdDZSNYxSKDhZItZkUEgkUeCddkiG8e9VYmD4+77XI6
 QRr49CXx9t/NMQoCWxVY7cg2Ks4dFogex2xSNmsN+7DtCD7K/glCFGnsGv8wsAYgJh1j+d00L
 0gokfCQvpfi8wgUl9tfZxi47WRm+KcHF0NRFTAqmYsiSdclHhJZ4nGxhLmR6w3USSvSRV/LGb
 4Ahppxc9YBzlGWcEc90hfxipK/IqqpiZV2pxPKg7vb3aRzdWekXTuDooMdwkn6wbENozftEjD
 Awqkr4joTJbFwfxVWZ/Kb/HftfyhwFl7EChaU4srj5E+6qLyKoXTqpG4bOoNGmFUo1KiEWk52
 NCQAFClye5yQr52vQSsY6fVCHrFvNaaUcN2JRYEHbgUZeDboLeOq7HXPV7TfaCTeo6YiDLgVn
 DWVL/33GEBVxtQsG8iL80wUpjG8xr92EYpXYVB+YzjQqGWKNgWJKFrZuFPUGOVRQtK6Qezdd8
 S19/Yn56YiERmNlFhR1kh2igHmNYAwsvFK12raElRO4YqZwU35xGHUTBdFM6qxljLyz9hgM4V
 0ccpVJ+/uy72S+NJCNObaBKmNbgZa9mDh+AouwM8bx2wFzpcPez25HqiCnNpVAp17DQUJvP2k
 s3dLFQt2GNsJP/sdByY5Ta8SNnbieBHD8YeB2OfYFn75Uyac9IpkVwzA69xIpKjadfKMBsg9u
 t7RJWpI5rTOdOIv037CufDaMdKXPkWZQ/Mxr5iAKG5+NAtvm2sosVDsqRXNJQORQtFnuNQo2n
 W/yZ5Kx/iO04JQsS4YCvc2Xwv9qXDYi71CR9X7c47xBedwyVCy10KWhtnr06wu
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--I4EH1gpTRNujztUoJLt8tnCEAmNvwTEou
Content-Type: multipart/mixed; boundary="E5ZEIBgrHNRUgXSDuSkd6bAwi8ZBDxuJz";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: fdmanana@kernel.org, linux-btrfs@vger.kernel.org
Message-ID: <1155e422-9269-a863-3980-115c4d31edf0@gmx.com>
Subject: Re: [PATCH] Btrfs: remove no longer used function to run delayed refs
 asynchronously
References: <20190417092847.17299-1-fdmanana@kernel.org>
In-Reply-To: <20190417092847.17299-1-fdmanana@kernel.org>

--E5ZEIBgrHNRUgXSDuSkd6bAwi8ZBDxuJz
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2019/4/17 =E4=B8=8B=E5=8D=885:28, fdmanana@kernel.org wrote:
> From: Filipe Manana <fdmanana@suse.com>
>=20
> It used to be called from only two places (truncate path and releasing =
a
> transaction handle), but commits 28bad2125767c5 ("btrfs: fix truncate
> throttling") and db2462a6ad3dc4 ("btrfs: don't run delayed refs in the =
end
> transaction logic") removed their calls to this function, so it's not u=
sed
> anymore. Just remove it and all its helpers.
>=20
> Signed-off-by: Filipe Manana <fdmanana@suse.com>

Reviewed-by: Qu Wenruo <wqu@suse.com>

Glad to know that delayed refs can only be executed when committing a
transaction.

Thanks,
Qu
> ---
>  fs/btrfs/ctree.h       |  2 --
>  fs/btrfs/extent-tree.c | 91 ------------------------------------------=
--------
>  2 files changed, 93 deletions(-)
>=20
> diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
> index 0f4838e00fbc..a1c7effe6de4 100644
> --- a/fs/btrfs/ctree.h
> +++ b/fs/btrfs/ctree.h
> @@ -2698,8 +2698,6 @@ void btrfs_wait_nocow_writers(struct btrfs_block_=
group_cache *bg);
>  void btrfs_put_block_group(struct btrfs_block_group_cache *cache);
>  int btrfs_run_delayed_refs(struct btrfs_trans_handle *trans,
>  			   unsigned long count);
> -int btrfs_async_run_delayed_refs(struct btrfs_fs_info *fs_info,
> -				 unsigned long count, u64 transid, int wait);
>  void btrfs_cleanup_ref_head_accounting(struct btrfs_fs_info *fs_info,
>  				  struct btrfs_delayed_ref_root *delayed_refs,
>  				  struct btrfs_delayed_ref_head *head);
> diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
> index 5b33cf0a539b..22dccd691c1e 100644
> --- a/fs/btrfs/extent-tree.c
> +++ b/fs/btrfs/extent-tree.c
> @@ -2877,97 +2877,6 @@ int btrfs_should_throttle_delayed_refs(struct bt=
rfs_trans_handle *trans)
>  	return btrfs_check_space_for_delayed_refs(trans->fs_info);
>  }
> =20
> -struct async_delayed_refs {
> -	struct btrfs_root *root;
> -	u64 transid;
> -	int count;
> -	int error;
> -	int sync;
> -	struct completion wait;
> -	struct btrfs_work work;
> -};
> -
> -static inline struct async_delayed_refs *
> -to_async_delayed_refs(struct btrfs_work *work)
> -{
> -	return container_of(work, struct async_delayed_refs, work);
> -}
> -
> -static void delayed_ref_async_start(struct btrfs_work *work)
> -{
> -	struct async_delayed_refs *async =3D to_async_delayed_refs(work);
> -	struct btrfs_trans_handle *trans;
> -	struct btrfs_fs_info *fs_info =3D async->root->fs_info;
> -	int ret;
> -
> -	/* if the commit is already started, we don't need to wait here */
> -	if (btrfs_transaction_blocked(fs_info))
> -		goto done;
> -
> -	trans =3D btrfs_join_transaction(async->root);
> -	if (IS_ERR(trans)) {
> -		async->error =3D PTR_ERR(trans);
> -		goto done;
> -	}
> -
> -	/*
> -	 * trans->sync means that when we call end_transaction, we won't
> -	 * wait on delayed refs
> -	 */
> -	trans->sync =3D true;
> -
> -	/* Don't bother flushing if we got into a different transaction */
> -	if (trans->transid > async->transid)
> -		goto end;
> -
> -	ret =3D btrfs_run_delayed_refs(trans, async->count);
> -	if (ret)
> -		async->error =3D ret;
> -end:
> -	ret =3D btrfs_end_transaction(trans);
> -	if (ret && !async->error)
> -		async->error =3D ret;
> -done:
> -	if (async->sync)
> -		complete(&async->wait);
> -	else
> -		kfree(async);
> -}
> -
> -int btrfs_async_run_delayed_refs(struct btrfs_fs_info *fs_info,
> -				 unsigned long count, u64 transid, int wait)
> -{
> -	struct async_delayed_refs *async;
> -	int ret;
> -
> -	async =3D kmalloc(sizeof(*async), GFP_NOFS);
> -	if (!async)
> -		return -ENOMEM;
> -
> -	async->root =3D fs_info->tree_root;
> -	async->count =3D count;
> -	async->error =3D 0;
> -	async->transid =3D transid;
> -	if (wait)
> -		async->sync =3D 1;
> -	else
> -		async->sync =3D 0;
> -	init_completion(&async->wait);
> -
> -	btrfs_init_work(&async->work, btrfs_extent_refs_helper,
> -			delayed_ref_async_start, NULL, NULL);
> -
> -	btrfs_queue_work(fs_info->extent_workers, &async->work);
> -
> -	if (wait) {
> -		wait_for_completion(&async->wait);
> -		ret =3D async->error;
> -		kfree(async);
> -		return ret;
> -	}
> -	return 0;
> -}
> -
>  /*
>   * this starts processing the delayed reference count updates and
>   * extent insertions we have queued up so far.  count can be
>=20


--E5ZEIBgrHNRUgXSDuSkd6bAwi8ZBDxuJz--

--I4EH1gpTRNujztUoJLt8tnCEAmNvwTEou
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEELd9y5aWlW6idqkLhwj2R86El/qgFAly29KkACgkQwj2R86El
/qgPWAgAgjsDzKQeX4Ud6/iQdSjvKJrKF8lSiCOLOjHGedMliq781FKjS/tAjcow
tLeVwSW5s1lvPjV4LypgAqAVmswoT7Ws/70wq/EzjfOvjbV2v5RaEKUmvnGzrujP
+7ISwB+vH5PsQ9SpsUUaBrK/y0kD3mspvgHtpLrDS+z9X1vt2MwfP2ABquPDJbT7
cgCxPZ9Er3xGtWBs2IiDDk+T26P+1GpQLvmPM5VFnH23SmvduIyxI9ViZUfsBCpO
HmhThB2/mDXthscRdwaz3uk9aDiA8jSpjBw78r0LJj38OvdiLFhhYktI5seM2U2R
YkSqFMFEfZHaqDKsOydKPlUwcN6W/w==
=KpW6
-----END PGP SIGNATURE-----

--I4EH1gpTRNujztUoJLt8tnCEAmNvwTEou--
