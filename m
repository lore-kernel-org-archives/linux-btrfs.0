Return-Path: <SRS0=ilb6=O5=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DCE6CC43387
	for <linux-btrfs@archiver.kernel.org>; Thu, 20 Dec 2018 16:12:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AD17720811
	for <linux-btrfs@archiver.kernel.org>; Thu, 20 Dec 2018 16:12:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732289AbeLTQMQ (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 20 Dec 2018 11:12:16 -0500
Received: from mx2.suse.de ([195.135.220.15]:34362 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1730955AbeLTQMQ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 20 Dec 2018 11:12:16 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay1.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 71960AEC5
        for <linux-btrfs@vger.kernel.org>; Thu, 20 Dec 2018 16:12:11 +0000 (UTC)
Subject: Re: [PATCH] btrfs: qgroup: Don't trigger backref walk at delayed ref
 insert time
To:     Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org
References: <20181211050237.19016-1-wqu@suse.com>
From:   Jeff Mahoney <jeffm@suse.com>
Message-ID: <a73aeace-e6c0-93e3-d9d5-a99c57f65d9d@suse.com>
Date:   Thu, 20 Dec 2018 11:12:08 -0500
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:64.0)
 Gecko/20100101 Thunderbird/64.0
MIME-Version: 1.0
In-Reply-To: <20181211050237.19016-1-wqu@suse.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="76DJNlkA8Vs66GrkuBNWd6giGF3ouE0yH"
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--76DJNlkA8Vs66GrkuBNWd6giGF3ouE0yH
Content-Type: multipart/mixed; boundary="42zgPTG5HcZ0h1gnmaxx4mXMiNG4WQ418";
 protected-headers="v1"
From: Jeff Mahoney <jeffm@suse.com>
To: Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org
Message-ID: <a73aeace-e6c0-93e3-d9d5-a99c57f65d9d@suse.com>
Subject: Re: [PATCH] btrfs: qgroup: Don't trigger backref walk at delayed ref
 insert time
References: <20181211050237.19016-1-wqu@suse.com>
In-Reply-To: <20181211050237.19016-1-wqu@suse.com>

--42zgPTG5HcZ0h1gnmaxx4mXMiNG4WQ418
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

On 12/11/18 12:02 AM, Qu Wenruo wrote:
> [BUG]
> Since fb235dc06fac ("btrfs: qgroup: Move half of the qgroup accounting
> time out of commit trans"), kernel may lockup with quota enabled.
>=20
> There is one backref trace triggered by snapshot dropping along with
> write operation in the source subvolume.
> The example can be stably reproduced.
>=20
>   btrfs-cleaner   D    0  4062      2 0x80000000
>   Call Trace:
>    schedule+0x32/0x90
>    btrfs_tree_read_lock+0x93/0x130 [btrfs]
>    find_parent_nodes+0x29b/0x1170 [btrfs]
>    btrfs_find_all_roots_safe+0xa8/0x120 [btrfs]
>    btrfs_find_all_roots+0x57/0x70 [btrfs]
>    btrfs_qgroup_trace_extent_post+0x37/0x70 [btrfs]
>    btrfs_qgroup_trace_leaf_items+0x10b/0x140 [btrfs]
>    btrfs_qgroup_trace_subtree+0xc8/0xe0 [btrfs]
>    do_walk_down+0x541/0x5e3 [btrfs]
>    walk_down_tree+0xab/0xe7 [btrfs]
>    btrfs_drop_snapshot+0x356/0x71a [btrfs]
>    btrfs_clean_one_deleted_snapshot+0xb8/0xf0 [btrfs]
>    cleaner_kthread+0x12b/0x160 [btrfs]
>    kthread+0x112/0x130
>    ret_from_fork+0x27/0x50
>=20
> [CAUSE]
> When dropping snapshots with qgroup enabled, we will trigger backref
> walk.
>=20
> However such backref walk at that timing is pretty dangerous, as if one=

> of the parent nodes get WRITE locked by other thread, we could cause a
> dead lock.
>=20
> For example:
>=20
>            FS 260     FS 261 (Dropped)
>             node A        node B
>            /      \      /      \
>        node C      node D      node E
>       /   \         /  \        /     \
>   leaf F|leaf G|leaf H|leaf I|leaf J|leaf K
>=20
> The lock sequence would be:
>=20
>       Thread A (cleaner)             |       Thread B (other writer)
> -----------------------------------------------------------------------=

> write_lock(B)                        |
> write_lock(D)                        |
> ^^^ called by walk_down_tree()       |
>                                      |       write_lock(A)
>                                      |       write_lock(D) << Stall
> read_lock(H) << for backref walk     |
> read_lock(D) << lock owner is        |
>                 the same thread A    |
>                 so read lock is OK   |
> read_lock(A) << Stall                |
>=20
> So thread A hold write lock D, and needs read lock A to unlock.
> While thread B holds write lock A, while needs lock D to unlock.
>=20
> This will cause a dead lock.
>=20
> This is not only limited to snapshot dropping case.
> As the backref walk, even only happens on commit trees, is breaking the=

> normal top-down locking order, makes it deadlock prone.
>=20
> [FIX]
> The solution is not to trigger backref walk with any write lock hold.
> This means we can't do backref walk at delayed ref insert time.
>=20
> So this patch will mostly revert commit fb235dc06fac ("btrfs: qgroup:
> Move half of the qgroup accounting time out of commit trans").
>=20
> Reported-by: David Sterba <dsterba@suse.cz>
> Reported-by: Filipe Manana <fdmanana@suse.com>
> Fixes: fb235dc06fac ("btrfs: qgroup: Move half of the qgroup accounting=
 time out of commit trans")
> Signed-off-by: Qu Wenruo <wqu@suse.com>
> ---
>  fs/btrfs/delayed-ref.c |  6 ------
>  fs/btrfs/qgroup.c      | 35 ++---------------------------------
>  2 files changed, 2 insertions(+), 39 deletions(-)
>=20
> diff --git a/fs/btrfs/delayed-ref.c b/fs/btrfs/delayed-ref.c
> index 9301b3ad9217..7aaae8436986 100644
> --- a/fs/btrfs/delayed-ref.c
> +++ b/fs/btrfs/delayed-ref.c
> @@ -788,9 +788,6 @@ int btrfs_add_delayed_tree_ref(struct btrfs_trans_h=
andle *trans,
>  	if (ret > 0)
>  		kmem_cache_free(btrfs_delayed_tree_ref_cachep, ref);
> =20
> -	if (qrecord_inserted)
> -		btrfs_qgroup_trace_extent_post(fs_info, record);
> -
>  	return 0;
>  }
> =20
> @@ -869,9 +866,6 @@ int btrfs_add_delayed_data_ref(struct btrfs_trans_h=
andle *trans,
>  	if (ret > 0)
>  		kmem_cache_free(btrfs_delayed_data_ref_cachep, ref);
> =20
> -
> -	if (qrecord_inserted)
> -		return btrfs_qgroup_trace_extent_post(fs_info, record);
>  	return 0;
>  }


This looks good but is leaving some cruft behind.

These were the only uses for qrecord_inserted so we don't need it in
either function and we don't need to pass it to add_delayed_ref_head.

-Jeff

> diff --git a/fs/btrfs/qgroup.c b/fs/btrfs/qgroup.c
> index 45868fd76209..7d485b1e0efb 100644
> --- a/fs/btrfs/qgroup.c
> +++ b/fs/btrfs/qgroup.c
> @@ -1553,33 +1553,6 @@ int btrfs_qgroup_trace_extent_nolock(struct btrf=
s_fs_info *fs_info,
>  	return 0;
>  }
> =20
> -int btrfs_qgroup_trace_extent_post(struct btrfs_fs_info *fs_info,
> -				   struct btrfs_qgroup_extent_record *qrecord)
> -{
> -	struct ulist *old_root;
> -	u64 bytenr =3D qrecord->bytenr;
> -	int ret;
> -
> -	ret =3D btrfs_find_all_roots(NULL, fs_info, bytenr, 0, &old_root, fal=
se);
> -	if (ret < 0) {
> -		fs_info->qgroup_flags |=3D BTRFS_QGROUP_STATUS_FLAG_INCONSISTENT;
> -		btrfs_warn(fs_info,
> -"error accounting new delayed refs extent (err code: %d), quota incons=
istent",
> -			ret);
> -		return 0;
> -	}
> -
> -	/*
> -	 * Here we don't need to get the lock of
> -	 * trans->transaction->delayed_refs, since inserted qrecord won't
> -	 * be deleted, only qrecord->node may be modified (new qrecord insert=
)
> -	 *
> -	 * So modifying qrecord->old_roots is safe here
> -	 */
> -	qrecord->old_roots =3D old_root;
> -	return 0;
> -}
> -
>  int btrfs_qgroup_trace_extent(struct btrfs_trans_handle *trans, u64 by=
tenr,
>  			      u64 num_bytes, gfp_t gfp_flag)
>  {
> @@ -1607,7 +1580,7 @@ int btrfs_qgroup_trace_extent(struct btrfs_trans_=
handle *trans, u64 bytenr,
>  		kfree(record);
>  		return 0;
>  	}
> -	return btrfs_qgroup_trace_extent_post(fs_info, record);
> +	return 0;
>  }
> =20
>  int btrfs_qgroup_trace_leaf_items(struct btrfs_trans_handle *trans,
> @@ -2557,11 +2530,7 @@ int btrfs_qgroup_account_extents(struct btrfs_tr=
ans_handle *trans)
>  		trace_btrfs_qgroup_account_extents(fs_info, record);
> =20
>  		if (!ret) {
> -			/*
> -			 * Old roots should be searched when inserting qgroup
> -			 * extent record
> -			 */
> -			if (WARN_ON(!record->old_roots)) {
> +			if (!record->old_roots) {
>  				/* Search commit root to find old_roots */
>  				ret =3D btrfs_find_all_roots(NULL, fs_info,
>  						record->bytenr, 0,
>=20

--=20
Jeff Mahoney
SUSE Labs



--42zgPTG5HcZ0h1gnmaxx4mXMiNG4WQ418--

--76DJNlkA8Vs66GrkuBNWd6giGF3ouE0yH
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEE8wzgbmZ74SnKPwtDHntLYyF55bIFAlwbv1kACgkQHntLYyF5
5bKogA/9F2ktzC2aebGzMPq5exbbpV50jMWt/gEQyR4dwW3Wlaz9/TsXi8TkH7Ut
lwkA9SIapifMYS29DMLKBJHL2/Ouu738q0AkAtQAe7SDfcnwjP7qOUj7zDt60UN9
JP8Sei9Sio+mtXaK2cbXEP9QI+42kn+izPyMIFwyBgHdT24cCIEKEL64y5IYFcud
wpi36vAyWljnEzLKhVvhkXUVv+5/FJor3VkS8YoIBqQ8tsCbz1bl8xkR/KEjvFul
sMdilwLI+cO0xIBwe2DesJ6ca50Z+HTm6AU+sEjo5E2Tye492TFa8bR7CUK7IBE4
6gjbYwjoO0DzD14xP6PVIXbz76WU6O8DTwSUB0k+eWgClRZScd+k3s9sCMQXb371
ypPnPbWgJFARH9j3LIQHfjbXPmnZZJoeo9D3EOtsJVvYHHegVBbH7K93kRHJ2MlH
X4GDa8SVef4fdsdEr37JFolnZ9CAJZ0lfRkIhpAVZ8W+8S8WLvTfoRH83dRxO0bZ
bOWA5wnn0pxBJKdodTuuTnO/GmkY7yPNIdVqe45TkmJE+szQknSihLpCL4rORm4H
ldhsOSbNXTBupx4M5HkvP9uDZ8oXGMDKYhAuGtowKTudU2POqnZkw+vfK+Ga8Ow/
VLrDhYaROvoQ2PERMvDS/+22wKp847YBcMbES7pvtMCtivgJMnI=
=2czy
-----END PGP SIGNATURE-----

--76DJNlkA8Vs66GrkuBNWd6giGF3ouE0yH--
