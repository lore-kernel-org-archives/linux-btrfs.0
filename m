Return-Path: <SRS0=huBW=PW=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.0 required=3.0 tests=FREEMAIL_FORGED_FROMDOMAIN,
	FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SIGNED_OFF_BY,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BAB4CC43387
	for <linux-btrfs@archiver.kernel.org>; Mon, 14 Jan 2019 06:28:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7FFE120659
	for <linux-btrfs@archiver.kernel.org>; Mon, 14 Jan 2019 06:28:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726449AbfANG2r (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 14 Jan 2019 01:28:47 -0500
Received: from mout.gmx.net ([212.227.17.20]:50603 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726067AbfANG2r (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 14 Jan 2019 01:28:47 -0500
Received: from [0.0.0.0] ([210.140.77.29]) by mail.gmx.com (mrgmx101
 [212.227.17.174]) with ESMTPSA (Nemesis) id 0MP0LT-1geGtm46sB-006SJO; Mon, 14
 Jan 2019 07:28:39 +0100
Subject: Re: [PATCH 08/10] btrfs: rework btrfs_check_space_for_delayed_refs
To:     Josef Bacik <josef@toxicpanda.com>, linux-btrfs@vger.kernel.org,
        kernel-team@fb.com
References: <20181203152038.21388-1-josef@toxicpanda.com>
 <20181203152038.21388-9-josef@toxicpanda.com>
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
Message-ID: <fe91b104-8be5-031e-daf8-2d8b50414e32@gmx.com>
Date:   Mon, 14 Jan 2019 14:28:33 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.4.0
MIME-Version: 1.0
In-Reply-To: <20181203152038.21388-9-josef@toxicpanda.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="YXXJcjiqZuOqQiIP3CKzQZMcDds14EdLe"
X-Provags-ID: V03:K1:NDunIFm8bAi32TqVfiKu3rJjqrTxfqKgBSANwVeLLxNQgPagwlP
 PtvWJ40PeoiS0FipyIp2h2Pi+qJ/gwv41nuhy+O/cItpVuEMFCinG9prpXTSmf8lPBz39Gs
 b0Idwyh3l4soY6ACSrdUt2TdWBmwFrO4esjfk9VlXuSCQ3FhBXpLGf9PTz/yDqJm0e6dVYv
 tlLPuV+9++VezskmgNNlA==
X-UI-Out-Filterresults: notjunk:1;V03:K0:I1htjZcMMmQ=:Z9GKprZgAF6XfO8qQYQSCe
 5VmDNx0YCoYhuzcK0eQJ6GCtG/dzsuQ4svSPAG1ns0yH35gi8mFqJPLEo5splMaz+mrdTvmy9
 PwdHOLII4J1ZeKqtnfqhuXC7i7m2PAxF2Y8uKQ03rIu9tBQHdVbjNWlnda7topPIbNN6/g3lk
 TZhk9pUvRZoIIyVvft7Fo6WDdprBAtBhYg17Cyhcl9sihbQIWr5zpFCa9kgj0UVgk1838vXvQ
 BXOhSp2OqNMmY9KB+usZhzJY5N3Drlbk/yK0KFukdurQD0OD1tPtFyHw8pUIfY9nWhbGle9gs
 5UthmIwPcov5P1xU6QRFk3LZQzeh+cB1XbmPEhFhCv6cwx6TgNKact2cjw9KC5WaMLqCUyfD2
 wMzIGr6MSFMtT7aCWfnqJqKf4M3VnKXXjgYKdBwDUuDsx0jO+FOdR3V6/J4qISNHail4cnr+s
 cxZdz6IUBT4vk7cr8gMkjsWajTA0YAws9cEYoXVIkiOAgl86PI/0ZdFf5jQeCsQZUu6o8Jk/G
 y2g662cPChgHV0KySi/pomhvKLaQGhcbMasfqd/fFbXtrq4crFgZHlB7ako9ioX6f3zcM30Qo
 UphoVkoYYrjsVZrqV+iJcdeh2AV9GDW54gI+5eJFaP3tQYos6Vc+wk8EjmwLBtj4wB6bwgJcR
 7ygNeWAC17tQogHvP4i8ruh64Qqd554nXuCHwWqV+iEr82+9OwNZW5VihctWEFJGPFYoIdNHa
 hsOo6cfdatqmrWwqm0l8Fd7GisrAT604e3UYeq/OCjjq9Es0heY82IeUFBQgVlCVfvhfCwqcy
 BMH7hs+qpzNwGrJEznpQCluFqG1qcnd0a+nkhAATWmrkGyE9GCM+i4HhLfkDnBhaVjSQ7rO8m
 mClqtN798za11E8GFE2UTBWsb3lWw1sv0Lrt6y7nOhsVOBvqQIL/9laW6s5O2y
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--YXXJcjiqZuOqQiIP3CKzQZMcDds14EdLe
Content-Type: multipart/mixed; boundary="e355WOQM1yXuyt2jqExuORCQMwhYoV8OQ";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: Josef Bacik <josef@toxicpanda.com>, linux-btrfs@vger.kernel.org,
 kernel-team@fb.com
Message-ID: <fe91b104-8be5-031e-daf8-2d8b50414e32@gmx.com>
Subject: Re: [PATCH 08/10] btrfs: rework btrfs_check_space_for_delayed_refs
References: <20181203152038.21388-1-josef@toxicpanda.com>
 <20181203152038.21388-9-josef@toxicpanda.com>
In-Reply-To: <20181203152038.21388-9-josef@toxicpanda.com>

--e355WOQM1yXuyt2jqExuORCQMwhYoV8OQ
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2018/12/3 =E4=B8=8B=E5=8D=8811:20, Josef Bacik wrote:
> Now with the delayed_refs_rsv we can now know exactly how much pending
> delayed refs space we need.  This means we can drastically simplify
> btrfs_check_space_for_delayed_refs by simply checking how much space we=

> have reserved for the global rsv (which acts as a spill over buffer) an=
d
> the delayed refs rsv.  If our total size is beyond that amount then we
> know it's time to commit the transaction and stop any more delayed refs=

> from being generated.

This patch is causing obvious large performance regression for metadata
relocation.
Bisect leads to this patch.

I'm using a script copying /usr (around 3.5G) into a subvolume, and do
16 snapshots, then touching 3 random files in each snapshot.

Then do a *metadata* balance.
Please note, quota is *DISABLED* here.

The full scripts can be found here:
https://gist.github.com/adam900710/e0a9719441e770a4d0d7b32c4a88bf95

Before this patch, it's around 5s to relocate 3 metadata block groups.
(VM is using unsafe cache mode, so IO is as fast as memory speed).

After this patch, I don't know how long it will take, as it doesn't even
finish before I reset the VM.

I also found during the super slow relocation, the generation of the fs
is increasing like crazy.
So something is definitely causing a ton of transaction commit.

Thanks,
Qu

>=20
> Signed-off-by: Josef Bacik <josef@toxicpanda.com>
> ---
>  fs/btrfs/ctree.h       |  2 +-
>  fs/btrfs/extent-tree.c | 48 ++++++++++++++++++------------------------=
------
>  fs/btrfs/inode.c       |  4 ++--
>  fs/btrfs/transaction.c |  2 +-
>  4 files changed, 22 insertions(+), 34 deletions(-)
>=20
> diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
> index 2eba398c722b..30da075c042e 100644
> --- a/fs/btrfs/ctree.h
> +++ b/fs/btrfs/ctree.h
> @@ -2631,7 +2631,7 @@ static inline u64 btrfs_calc_trunc_metadata_size(=
struct btrfs_fs_info *fs_info,
>  }
> =20
>  int btrfs_should_throttle_delayed_refs(struct btrfs_trans_handle *tran=
s);
> -int btrfs_check_space_for_delayed_refs(struct btrfs_trans_handle *tran=
s);
> +bool btrfs_check_space_for_delayed_refs(struct btrfs_fs_info *fs_info)=
;
>  void btrfs_dec_block_group_reservations(struct btrfs_fs_info *fs_info,=

>  					 const u64 start);
>  void btrfs_wait_block_group_reservations(struct btrfs_block_group_cach=
e *bg);
> diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
> index 5a2d0b061f57..07ef1b8087f7 100644
> --- a/fs/btrfs/extent-tree.c
> +++ b/fs/btrfs/extent-tree.c
> @@ -2839,40 +2839,28 @@ u64 btrfs_csum_bytes_to_leaves(struct btrfs_fs_=
info *fs_info, u64 csum_bytes)
>  	return num_csums;
>  }
> =20
> -int btrfs_check_space_for_delayed_refs(struct btrfs_trans_handle *tran=
s)
> +bool btrfs_check_space_for_delayed_refs(struct btrfs_fs_info *fs_info)=

>  {
> -	struct btrfs_fs_info *fs_info =3D trans->fs_info;
> -	struct btrfs_block_rsv *global_rsv;
> -	u64 num_heads =3D trans->transaction->delayed_refs.num_heads_ready;
> -	u64 csum_bytes =3D trans->transaction->delayed_refs.pending_csums;
> -	unsigned int num_dirty_bgs =3D trans->transaction->num_dirty_bgs;
> -	u64 num_bytes, num_dirty_bgs_bytes;
> -	int ret =3D 0;
> +	struct btrfs_block_rsv *delayed_refs_rsv =3D &fs_info->delayed_refs_r=
sv;
> +	struct btrfs_block_rsv *global_rsv =3D &fs_info->global_block_rsv;
> +	bool ret =3D false;
> +	u64 reserved;
> =20
> -	num_bytes =3D btrfs_calc_trans_metadata_size(fs_info, 1);
> -	num_heads =3D heads_to_leaves(fs_info, num_heads);
> -	if (num_heads > 1)
> -		num_bytes +=3D (num_heads - 1) * fs_info->nodesize;
> -	num_bytes <<=3D 1;
> -	num_bytes +=3D btrfs_csum_bytes_to_leaves(fs_info, csum_bytes) *
> -							fs_info->nodesize;
> -	num_dirty_bgs_bytes =3D btrfs_calc_trans_metadata_size(fs_info,
> -							     num_dirty_bgs);
> -	global_rsv =3D &fs_info->global_block_rsv;
> +	spin_lock(&global_rsv->lock);
> +	reserved =3D global_rsv->reserved;
> +	spin_unlock(&global_rsv->lock);
> =20
>  	/*
> -	 * If we can't allocate any more chunks lets make sure we have _lots_=
 of
> -	 * wiggle room since running delayed refs can create more delayed ref=
s.
> +	 * Since the global reserve is just kind of magic we don't really wan=
t
> +	 * to rely on it to save our bacon, so if our size is more than the
> +	 * delayed_refs_rsv and the global rsv then it's time to think about
> +	 * bailing.
>  	 */
> -	if (global_rsv->space_info->full) {
> -		num_dirty_bgs_bytes <<=3D 1;
> -		num_bytes <<=3D 1;
> -	}
> -
> -	spin_lock(&global_rsv->lock);
> -	if (global_rsv->reserved <=3D num_bytes + num_dirty_bgs_bytes)
> -		ret =3D 1;
> -	spin_unlock(&global_rsv->lock);
> +	spin_lock(&delayed_refs_rsv->lock);
> +	reserved +=3D delayed_refs_rsv->reserved;
> +	if (delayed_refs_rsv->size >=3D reserved)
> +		ret =3D true;
> +	spin_unlock(&delayed_refs_rsv->lock);
>  	return ret;
>  }
> =20
> @@ -2891,7 +2879,7 @@ int btrfs_should_throttle_delayed_refs(struct btr=
fs_trans_handle *trans)
>  	if (val >=3D NSEC_PER_SEC / 2)
>  		return 2;
> =20
> -	return btrfs_check_space_for_delayed_refs(trans);
> +	return btrfs_check_space_for_delayed_refs(trans->fs_info);
>  }
> =20
>  struct async_delayed_refs {
> diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
> index a097f5fde31d..8532a2eb56d1 100644
> --- a/fs/btrfs/inode.c
> +++ b/fs/btrfs/inode.c
> @@ -5326,8 +5326,8 @@ static struct btrfs_trans_handle *evict_refill_an=
d_join(struct btrfs_root *root,
>  		 * Try to steal from the global reserve if there is space for
>  		 * it.
>  		 */
> -		if (!btrfs_check_space_for_delayed_refs(trans) &&
> -		    !btrfs_block_rsv_migrate(global_rsv, rsv, rsv->size, false))
> +		if (!btrfs_check_space_for_delayed_refs(fs_info) &&
> +		    !btrfs_block_rsv_migrate(global_rsv, rsv, rsv->size, 0))
>  			return trans;
> =20
>  		/* If not, commit and try again. */
> diff --git a/fs/btrfs/transaction.c b/fs/btrfs/transaction.c
> index a21c4defad92..2d8401bf8df9 100644
> --- a/fs/btrfs/transaction.c
> +++ b/fs/btrfs/transaction.c
> @@ -789,7 +789,7 @@ static int should_end_transaction(struct btrfs_tran=
s_handle *trans)
>  {
>  	struct btrfs_fs_info *fs_info =3D trans->fs_info;
> =20
> -	if (btrfs_check_space_for_delayed_refs(trans))
> +	if (btrfs_check_space_for_delayed_refs(fs_info))
>  		return 1;
> =20
>  	return !!btrfs_block_rsv_check(&fs_info->global_block_rsv, 5);
>=20


--e355WOQM1yXuyt2jqExuORCQMwhYoV8OQ--

--YXXJcjiqZuOqQiIP3CKzQZMcDds14EdLe
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEELd9y5aWlW6idqkLhwj2R86El/qgFAlw8LBEACgkQwj2R86El
/qgAgQf/XUHKI6+VFlG6FK1AWoDyFr/FLn5xbVFsCzfI+L1Do8QKrdG/DoEPEqEy
Vo2LNPpoCjW6R2RGG80JyoWCgKDTVeB7k1jlPsfFgFSg9sqwkIdvHIIhS4ihVdzo
5FUVxmdyizIypVTR09mA9ORJ9zaHjAe6R8hWEpwlvBFAinnRub13StMSt25h9EQC
u2un4pvSkxNdpoB15dnMqWCzPukod0/YZiAEGsBCt3nBHAdxHoqIIGW56yCN2R0H
+17wVwhxl8kWUpZJ0C5qfIhFkidJCqRaBg5W9JBoYSgQJr/R7prcLiGgHN/MXnyO
iDsNf6q5ilRQY9gb3R78nLnTn9GV3A==
=6frz
-----END PGP SIGNATURE-----

--YXXJcjiqZuOqQiIP3CKzQZMcDds14EdLe--
