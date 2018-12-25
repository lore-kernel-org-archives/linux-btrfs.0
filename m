Return-Path: <SRS0=rxi5=PC=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=FREEMAIL_FORGED_FROMDOMAIN,
	FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6D91BC43387
	for <linux-btrfs@archiver.kernel.org>; Tue, 25 Dec 2018 05:36:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 21A5B2173B
	for <linux-btrfs@archiver.kernel.org>; Tue, 25 Dec 2018 05:36:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725857AbeLYFg3 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 25 Dec 2018 00:36:29 -0500
Received: from mout.gmx.net ([212.227.15.18]:34439 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725791AbeLYFg3 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 25 Dec 2018 00:36:29 -0500
Received: from [0.0.0.0] ([149.28.201.231]) by mail.gmx.com (mrgmx003
 [212.227.17.184]) with ESMTPSA (Nemesis) id 0MhRUQ-1gyAJV1t22-00MZFe; Tue, 25
 Dec 2018 06:36:20 +0100
Subject: Re: [PATCH v2] btrfs: Validate generation of btrfs super blocks
 before writing it to disk
To:     Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org
Cc:     Peter Chant <pete@petezilla.co.uk>
References: <20181225045058.28566-1-wqu@suse.com>
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
Message-ID: <d982b161-271e-2c4d-4f2f-58c5e3c3079a@gmx.com>
Date:   Tue, 25 Dec 2018 13:36:15 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.3.3
MIME-Version: 1.0
In-Reply-To: <20181225045058.28566-1-wqu@suse.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="9IwbLQVjUEcLqItp3jV2yUCNQ2AIQblVX"
X-Provags-ID: V03:K1:zsbBHWdjvRNBK1Xc55BmUXhsPE+yLKM1OUYII4TuuwECYAmygS/
 ZxPYqKbv3XnFm4hRz9F4LvAa6zOMru7Igwa0qMfIhwNxNbcIK/7j25WAzJ3q0/omdUkNn4E
 2ypz6j5/U3g2Kwt/M7kE4pk43L3uDAJZMC5JiovyGzl3Hh+eI9hloOW3HdveyC8jiXW5QjJ
 hfsH3e2HaFENSxZuc4iUg==
X-UI-Out-Filterresults: notjunk:1;V03:K0:b/9MMiX1ysA=:WhsTnrFtALbYhVVA9tv9cG
 HLHiQSwmI66rTha1D+yE9mY/MgGRBd4+C5hGdp8/isKnMvHxdDvGrkpkDBR/pk8SQGQoVUe5q
 KaGNxV+7/PlW56RpEeMbTpt47//+DpNJf9aJt647zYKuVDdJe+/yetThhby53919sNPvj71B9
 VDmIRXRDb4nQouEAMUri0gD7qa/KJGAwzAt4zaqhdHJ+pvu/1PUmtXqpOEdUowNzHK/9a+QnL
 5LmYQLpKpxPNZvWhBS6qg3mDw/AT0rs74soH6R6ws2Vruc6R/o0QTCMdebacRmJudfEuF7uwj
 94nL0uIbBmYAGXIb+IpaBD+YHQ61si07nFGKdvJUFSIKrzdBCLJTdW+5ZUL+Y0xxsAJeaGPUQ
 WCxrMWcxNgkPdsTHZMFz59YADUGh0hnJ8OldgT9DxWpSbnURcrB/mjnRK06Q7unb2MnB+xkVL
 E16xyeSFGbt5KgVgXENfICOWN7X8NxEAyMp0/ufP3eo58rPlIqk0etmXX9cvIj02wibA8IH/d
 LNOYqi6fXT637NZN0i6hU+UXfxnM5siuFdoMrWrFiZU8CT+ZPWzcagfsfp/1ah/eej2Sw7B+h
 D4Svk+hMl+gQcEPybe6FJU8qfsDORUvuXkGysEy0INfPBljtOC5WfUZ3YJIK3tu7MGiT1/jF1
 126gT01fUYPfqy4pExQW1nJRcqcTnpuoR2BGv3uxp9Jgm+Pvq4MsaQTSpztUSVmJbeBdQbmOd
 zy1vj7rdDo7syR2e4UMHRVyLPu8JJk8Dj+JfnWxpBE/ByRKatEkoSooBLt6mhfYUuv/oIkAIr
 Roa45iGKSsR5yNk3UTugct7RWax3nNiugz0t7iDT/UikFXU2WNurnoJC37Kdcu0APcb96qMSK
 0iJMmHMXUrpv6PlshxZ5WWrZf/9px/Uj2jIyVIOkljKW3h9LqR7bxGI51mdY9G
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--9IwbLQVjUEcLqItp3jV2yUCNQ2AIQblVX
Content-Type: multipart/mixed; boundary="YCpIXW3XLDuhT4IU16bHcPMSjxoyoAN7G";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org
Cc: Peter Chant <pete@petezilla.co.uk>
Message-ID: <d982b161-271e-2c4d-4f2f-58c5e3c3079a@gmx.com>
Subject: Re: [PATCH v2] btrfs: Validate generation of btrfs super blocks
 before writing it to disk
References: <20181225045058.28566-1-wqu@suse.com>
In-Reply-To: <20181225045058.28566-1-wqu@suse.com>

--YCpIXW3XLDuhT4IU16bHcPMSjxoyoAN7G
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2018/12/25 =E4=B8=8B=E5=8D=8812:50, Qu Wenruo wrote:
> Even we did super block verification in commit 75cb857d2618
> ("btrfs: Do super block verification before writing it to disk"), it
> doesn't check generation against transaction as generation corruption i=
s
> not that obvious.
> This allows super block generation corruption sneak in.
>=20
> So in this patch, btrfs will check super block generation by:
> - Check it against expected transid
>   We have 2 different callers who writes all super blocks:
>   * btrfs_commit_transaction()
>     The expected generation is trans->transid.
>   * btrfs_sync_log()
>     The expected generation is trans->transid - 1, since we only
>     update log_root, while not updating generation.
>=20
> - Chech it against backup roots
>   For backup roots, we should not have any backup roots newer than our
>   current expected generation.
>=20
>   NOTE: Normally we should have a backup root matching the expected
>         generation, but btrfs-progs doesn't update backup roots, which
>         makes a valid repaired fs undergoing fsync() to trigger false
>         alerts. So we don't require backup roots to match generation
>         yet.
>=20
> With above solution, at least we should be able to catch potential
> generation corruption early on.
>=20
> Reported-by: Peter Chant <pete@petezilla.co.uk>
> Signed-off-by: Qu Wenruo <wqu@suse.com>
> ---
Sorry I missed the changelog.

Changelog:
v2:
- Remove the requirement for backup root to match expected generation.
  This is for btrfs-progs modified fs with fsync() call.

Thanks,
Qu

>  fs/btrfs/disk-io.c     | 40 +++++++++++++++++++++++++++++++++++++---
>  fs/btrfs/disk-io.h     |  2 +-
>  fs/btrfs/transaction.c |  2 +-
>  fs/btrfs/tree-log.c    |  2 +-
>  4 files changed, 40 insertions(+), 6 deletions(-)
>=20
> diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
> index 5228320030a5..e9caf199e579 100644
> --- a/fs/btrfs/disk-io.c
> +++ b/fs/btrfs/disk-io.c
> @@ -2573,9 +2573,12 @@ static int btrfs_validate_mount_super(struct btr=
fs_fs_info *fs_info)
>   * Extra checks like csum type and incompat flags will be done here.
>   */
>  static int btrfs_validate_write_super(struct btrfs_fs_info *fs_info,
> -				      struct btrfs_super_block *sb)
> +				      struct btrfs_super_block *sb,
> +				      u64 expected_gen)
>  {
> +	u64 sb_gen =3D btrfs_super_generation(sb);
>  	int ret;
> +	int i;
> =20
>  	ret =3D validate_super(fs_info, sb, -1);
>  	if (ret < 0)
> @@ -2594,6 +2597,37 @@ static int btrfs_validate_write_super(struct btr=
fs_fs_info *fs_info,
>  			  (unsigned long long)BTRFS_FEATURE_INCOMPAT_SUPP);
>  		goto out;
>  	}
> +
> +	/* super block generation check */
> +	if (sb_gen !=3D expected_gen) {
> +		ret =3D -EUCLEAN;
> +		btrfs_err(fs_info,
> +			"invalid generation detected, has %llu expect %llu",
> +			sb_gen, expected_gen);
> +		goto out;
> +	}
> +
> +	/*
> +	 * check against backup roots
> +	 *
> +	 * NOTE: Normally we should have a backup root matching the expected
> +	 * generation, however for fsync() call on a btrfs-progs modified fs,=

> +	 * its backup roots aren't updated and could cause false alerts.
> +	 * So here we only check obvious corrupted backup roots.
> +	 */
> +	for (i =3D 0; i < BTRFS_NUM_BACKUP_ROOTS; i++) {
> +		struct btrfs_root_backup *root_backup =3D sb->super_roots + i;
> +		u64 backup_gen =3D btrfs_backup_tree_root_gen(root_backup);
> +
> +		if (backup_gen > sb_gen) {
> +			ret =3D -EUCLEAN;
> +			btrfs_err(fs_info,
> +	"invalid backup root generation detected, slot %u has %llu expect <%l=
lu",
> +				  i, backup_gen, sb_gen);
> +			goto out;
> +		}
> +	}
> +
>  out:
>  	if (ret < 0)
>  		btrfs_err(fs_info,
> @@ -3721,7 +3755,7 @@ int btrfs_get_num_tolerated_disk_barrier_failures=
(u64 flags)
>  	return min_tolerated;
>  }
> =20
> -int write_all_supers(struct btrfs_fs_info *fs_info, int max_mirrors)
> +int write_all_supers(struct btrfs_fs_info *fs_info, u64 gen, int max_m=
irrors)
>  {
>  	struct list_head *head;
>  	struct btrfs_device *dev;
> @@ -3786,7 +3820,7 @@ int write_all_supers(struct btrfs_fs_info *fs_inf=
o, int max_mirrors)
>  		flags =3D btrfs_super_flags(sb);
>  		btrfs_set_super_flags(sb, flags | BTRFS_HEADER_FLAG_WRITTEN);
> =20
> -		ret =3D btrfs_validate_write_super(fs_info, sb);
> +		ret =3D btrfs_validate_write_super(fs_info, sb, gen);
>  		if (ret < 0) {
>  			mutex_unlock(&fs_info->fs_devices->device_list_mutex);
>  			btrfs_handle_fs_error(fs_info, -EUCLEAN,
> diff --git a/fs/btrfs/disk-io.h b/fs/btrfs/disk-io.h
> index 4cccba22640f..9f8fd0a9a3a4 100644
> --- a/fs/btrfs/disk-io.h
> +++ b/fs/btrfs/disk-io.h
> @@ -53,7 +53,7 @@ int open_ctree(struct super_block *sb,
>  	       struct btrfs_fs_devices *fs_devices,
>  	       char *options);
>  void close_ctree(struct btrfs_fs_info *fs_info);
> -int write_all_supers(struct btrfs_fs_info *fs_info, int max_mirrors);
> +int write_all_supers(struct btrfs_fs_info *fs_info, u64 gen, int max_m=
irrors);
>  struct buffer_head *btrfs_read_dev_super(struct block_device *bdev);
>  int btrfs_read_dev_one_super(struct block_device *bdev, int copy_num,
>  			struct buffer_head **bh_ret);
> diff --git a/fs/btrfs/transaction.c b/fs/btrfs/transaction.c
> index d1eeef9ec5da..b61cec2780b9 100644
> --- a/fs/btrfs/transaction.c
> +++ b/fs/btrfs/transaction.c
> @@ -2241,7 +2241,7 @@ int btrfs_commit_transaction(struct btrfs_trans_h=
andle *trans)
>  		goto scrub_continue;
>  	}
> =20
> -	ret =3D write_all_supers(fs_info, 0);
> +	ret =3D write_all_supers(fs_info, trans->transid, 0);
>  	/*
>  	 * the super is written, we can safely allow the tree-loggers
>  	 * to go about their business
> diff --git a/fs/btrfs/tree-log.c b/fs/btrfs/tree-log.c
> index e07f3376b7df..4f84345fdbb6 100644
> --- a/fs/btrfs/tree-log.c
> +++ b/fs/btrfs/tree-log.c
> @@ -3155,7 +3155,7 @@ int btrfs_sync_log(struct btrfs_trans_handle *tra=
ns,
>  	 * the running transaction open, so a full commit can't hop
>  	 * in and cause problems either.
>  	 */
> -	ret =3D write_all_supers(fs_info, 1);
> +	ret =3D write_all_supers(fs_info, trans->transid - 1, 1);
>  	if (ret) {
>  		btrfs_set_log_full_commit(fs_info, trans);
>  		btrfs_abort_transaction(trans, ret);
>=20


--YCpIXW3XLDuhT4IU16bHcPMSjxoyoAN7G--

--9IwbLQVjUEcLqItp3jV2yUCNQ2AIQblVX
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEELd9y5aWlW6idqkLhwj2R86El/qgFAlwhwc8ACgkQwj2R86El
/qga3Qf/dlBVuggstQ4MDbwLOm7RtIVbJEYtipwMLFyx0+fc5OkxaKE+vxVydzS6
/SWyDzW4skZIswnpriVIOJXEB0IdMOqvr5hf0V4VgEsK6dorIPlupHpaQLExQ1Fc
tBx6TDYkWtd9AnQm5cYBI3VZMwxit0cekpJ7sHbpgnIGZGLGrm7AVEPig88dXFXx
RiDDl2rG/znkjHFg70HdHiYclymr6R+UhzK0o0yNGWTJR6qO/5zsPPqgzSH5SHmH
6jZEKrSfvsTDRZ1blUBTMGBbf/5Q4mdOl/s72c3O+45G0/iTsV9/5L9J+Av243qD
3b5HR/0prjnN+gzKbeTvhHeC5tfMsg==
=HLBc
-----END PGP SIGNATURE-----

--9IwbLQVjUEcLqItp3jV2yUCNQ2AIQblVX--
