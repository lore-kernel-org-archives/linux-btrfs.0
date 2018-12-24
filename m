Return-Path: <SRS0=Gb2+=PB=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=FREEMAIL_FORGED_FROMDOMAIN,
	FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DF854C43387
	for <linux-btrfs@archiver.kernel.org>; Mon, 24 Dec 2018 12:05:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A4205218A4
	for <linux-btrfs@archiver.kernel.org>; Mon, 24 Dec 2018 12:05:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725601AbeLXMFM (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 24 Dec 2018 07:05:12 -0500
Received: from mout.gmx.net ([212.227.15.18]:49385 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725268AbeLXMFM (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 24 Dec 2018 07:05:12 -0500
Received: from [0.0.0.0] ([210.140.77.29]) by mail.gmx.com (mrgmx001
 [212.227.17.184]) with ESMTPSA (Nemesis) id 0MIMUZ-1gfWF7328l-004E20; Mon, 24
 Dec 2018 13:05:03 +0100
Subject: Re: [PATCH] btrfs: Validate generation of btrfs super blocks before
 writing it to disk
To:     Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org
Cc:     Peter Chant <pete@petezilla.co.uk>
References: <20181224074150.2722-1-wqu@suse.com>
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
Message-ID: <b5b0b4f4-5da6-948e-4a58-623b3fb5fa6d@gmx.com>
Date:   Mon, 24 Dec 2018 20:04:56 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.3.3
MIME-Version: 1.0
In-Reply-To: <20181224074150.2722-1-wqu@suse.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="jBNpPcEOaz2ByU5fH36nHpacG0POdV9Po"
X-Provags-ID: V03:K1:Li/uWP2xlZHbWOoRV2ozb0Et2SJYSdiwlsJorCn32favEdFODSy
 VgcgJpmCvjpE8JQ97sOc3h8flOtWOyHGuSnPeiMBCiaOTyt/pr5cR31sigdHmCSa5Rz7gLQ
 P962Lq+NLuy69fi/mvWVGhWC2e3Dan6ksKKlcCt7HEE+VDUsEuUpPIWgv1YGSBIF6MilsKq
 Aj3yr1fZrgKFDGroEsYOA==
X-UI-Out-Filterresults: notjunk:1;V03:K0:Lu074nCzpRo=:dPGI5314cWoQI83L20w1n6
 cXucwjf0sNIPkjXRrhqizfok48CoNnxXKzWObocUmgc5m3BIqI77edmtijPRHYYt4AL6EPPIY
 7gpSFYg8ayaNM51OCJANrvRYRL2mZgQNMQ47v4BM3PDY3TBVHC4Vu+zEgdDUTOOu49thFCVLc
 0KxJD0wGFdAp5sTFmsJ1bjzi/koLpwvPWvBCaT4FabL8yebE6q3IXmme7gxFp///DQABJb/Id
 9SpBBpX/pQZ5ogU29tkdELAL3sEKi6shhbHYJMkcvvgDhEh64ycgdsNeslr7L6q0ItGpcJ4oj
 u6Qhuup+FY0YN0tivwBiZ5RfhZxFyo0XiyxDoddb9pb+jjY/U0Xmi7faZxAhg5/KbNmRFv+2a
 sdPpxmNtuDVBxveKcUzwDRHkWePWiINg6nZCc4WoSlgmi1VPK5hE8Z7bkGcKTvbFaMXkchlLF
 4ZRAs/ql+LMh5vgLv7med41E0LMPiJ6OXrg0BfYap5yNv1ZjIJ4+cYnMDI8BXVhG/3PnDW8Uj
 PMl0rHzjeBbmas28f0YOVS6QREnqPtwT/Jz83NeHbCg4yNHtnV2ojeuQXMxaZApFuRS6mI2YZ
 tUkNkC9dGdBghg+iGWNs8+nwPt5pgys9W2uFvY+Vli2KDV7DEMBFaxgWZuYsMr5ypMH6nnLgi
 jxmNGA+Z8Z3THcz1/FJDVYSvLCW/ywc0dVlaaE94GT7HNiWFh7TWJhaNH7tMdePCd6ihwsZ2h
 FIhjXFbpbx7hQ4ZT4WVZWd7E9LU/CsYKVsuSWPHTEoaRi0+K4CFgb9I5+cdmsZ34W2fsT1Qlv
 C6TXCIkRhOTcubr260+sCroOtqqV0rhKvr518YcoHKZIDFKCxorkWii4S0UIR/t+OlCUWIU+q
 pNywGaj44pOBTLg6Q4UeRxgNWHHyzFpW3KdbmL8le+vPy/i/w3hDeelEfDwpGF
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--jBNpPcEOaz2ByU5fH36nHpacG0POdV9Po
Content-Type: multipart/mixed; boundary="uoWZcbW9ZOCiXCiOerYsDHfJJGwYKoCfR";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org
Cc: Peter Chant <pete@petezilla.co.uk>
Message-ID: <b5b0b4f4-5da6-948e-4a58-623b3fb5fa6d@gmx.com>
Subject: Re: [PATCH] btrfs: Validate generation of btrfs super blocks before
 writing it to disk
References: <20181224074150.2722-1-wqu@suse.com>
In-Reply-To: <20181224074150.2722-1-wqu@suse.com>

--uoWZcbW9ZOCiXCiOerYsDHfJJGwYKoCfR
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2018/12/24 =E4=B8=8B=E5=8D=883:41, Qu Wenruo wrote:
> [PROBLEM]
> One user reports strange super block generation like:
>   generation              7937947
>         backup 0:
>                 backup_tree_root:       1113909100544   gen: 7937935   =
 level: 1
>         backup 1:
>                 backup_tree_root:       1113907347456   gen: 7937936   =
 level: 1
>         backup 2:
>                 backup_tree_root:       1113911951360   gen: 7937937   =
 level: 1
>         backup 3:
>                 backup_tree_root:       1113907494912   gen: 7937934   =
 level: 1
>=20
> sb gen:		7937947 =3D 0x791f9b
> backup gen:	7937937 =3D 0x791f91
>=20
> The reason why such mismatch happens is still uknown, but one assumptio=
n
> is 2 bits flipped at runtime.
>=20
> [SOLUTION]
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
>   If we have any valid backup roots (new fs can have no backup root at
>   all), we should find one backup root matching the generation,

This part is too restrict to handle btrfs check --repair.

For kernel it's OK, but btrfs-progs transaction commit code won't update
backup roots, so it would cause false alerts.

I'll remove the match check in next version.

Thanks,
Qu

> and no
>   backup root newer than current generation.
>=20
> With above solution, at least we should be able to catch potential
> generation corruption early on.
>=20
> Reported-by: Peter Chant <pete@petezilla.co.uk>
> Signed-off-by: Qu Wenruo <wqu@suse.com>
> ---
>  fs/btrfs/disk-io.c     | 49 +++++++++++++++++++++++++++++++++++++++---=

>  fs/btrfs/disk-io.h     |  2 +-
>  fs/btrfs/transaction.c |  2 +-
>  fs/btrfs/tree-log.c    |  2 +-
>  4 files changed, 49 insertions(+), 6 deletions(-)
>=20
> diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
> index 5228320030a5..c972baafe664 100644
> --- a/fs/btrfs/disk-io.c
> +++ b/fs/btrfs/disk-io.c
> @@ -2573,9 +2573,14 @@ static int btrfs_validate_mount_super(struct btr=
fs_fs_info *fs_info)
>   * Extra checks like csum type and incompat flags will be done here.
>   */
>  static int btrfs_validate_write_super(struct btrfs_fs_info *fs_info,
> -				      struct btrfs_super_block *sb)
> +				      struct btrfs_super_block *sb,
> +				      u64 expected_gen)
>  {
> +	u64 sb_gen =3D btrfs_super_generation(sb);
> +	u64 newest_gen =3D 0;
> +	bool found =3D false;
>  	int ret;
> +	int i;
> =20
>  	ret =3D validate_super(fs_info, sb, -1);
>  	if (ret < 0)
> @@ -2594,6 +2599,44 @@ static int btrfs_validate_write_super(struct btr=
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
> +	/* check against backup roots */
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
> +		newest_gen =3D max(newest_gen, backup_gen);
> +		if (backup_gen =3D=3D expected_gen)
> +			found =3D true;
> +	}
> +
> +	/*
> +	 * If we have any valid backup roots but still fail to find one
> +	 * matching sb generation, either backup roots or sb itself is
> +	 * corrupted.
> +	 */
> +	if (newest_gen && !found && newest_gen < expected_gen) {
> +		ret =3D -EUCLEAN;
> +		btrfs_err(fs_info,
> +"no backup root generation matches current, found newest %llu expect %=
llu",
> +			  newest_gen, expected_gen);
> +	}
>  out:
>  	if (ret < 0)
>  		btrfs_err(fs_info,
> @@ -3721,7 +3764,7 @@ int btrfs_get_num_tolerated_disk_barrier_failures=
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
> @@ -3786,7 +3829,7 @@ int write_all_supers(struct btrfs_fs_info *fs_inf=
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


--uoWZcbW9ZOCiXCiOerYsDHfJJGwYKoCfR--

--jBNpPcEOaz2ByU5fH36nHpacG0POdV9Po
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEELd9y5aWlW6idqkLhwj2R86El/qgFAlwgy2kACgkQwj2R86El
/qg8RAgAr99LQM10vVB5qDE3J2ayBHcuyeh2ydB7QUjfBpD0tQ9wKIRbptD3D2AG
AYQ6ylixocaajayRIgHtxJ4puTK41kC5xxkcQ8hhVhpU3UH4ptz4Ket8FIhbm7yx
LHBPPZUuOJOAA/rQt4qNMKFy0TEmlIXpSTI92gkPzd/nqKTCsmFdDECWeSKVVfNl
UQoCH+1qADVOw700isyX/LWFrwXl7C7/sWxjOUJy420pdAR/H66IryP6mdBgb7tm
0J45j7dmIA/Fg+rdrB23wxc+8htLfBS7N/UbJw/J6aqNWxeM16fWEX3GNyjGMgeU
DRZpVakKdd0uQCZ6HkGdX+fbexHu5Q==
=LIrE
-----END PGP SIGNATURE-----

--jBNpPcEOaz2ByU5fH36nHpacG0POdV9Po--
