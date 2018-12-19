Return-Path: <SRS0=k4qV=O4=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2E273C43387
	for <linux-btrfs@archiver.kernel.org>; Wed, 19 Dec 2018 20:39:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EE1CA20873
	for <linux-btrfs@archiver.kernel.org>; Wed, 19 Dec 2018 20:39:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729377AbeLSUjp (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 19 Dec 2018 15:39:45 -0500
Received: from mx2.suse.de ([195.135.220.15]:52966 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729306AbeLSUjp (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 19 Dec 2018 15:39:45 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay1.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 7C7FFB68D
        for <linux-btrfs@vger.kernel.org>; Wed, 19 Dec 2018 20:39:42 +0000 (UTC)
Subject: Re: [PATCH] btrfs: qgroup: Don't trigger backref walk at delayed ref
 insert time
To:     Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org
References: <20181211050237.19016-1-wqu@suse.com>
From:   Jeff Mahoney <jeffm@suse.com>
Message-ID: <b9cc10b8-7677-2d4f-bc92-52b760caf141@suse.com>
Date:   Wed, 19 Dec 2018 15:39:40 -0500
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:64.0)
 Gecko/20100101 Thunderbird/64.0
MIME-Version: 1.0
In-Reply-To: <20181211050237.19016-1-wqu@suse.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="XuXQszm77NjFggOuly02TXWk0FdRN5P2F"
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--XuXQszm77NjFggOuly02TXWk0FdRN5P2F
Content-Type: multipart/mixed; boundary="aZutX3u4rOKiB5uyLRDECzAzrO1H1t91I";
 protected-headers="v1"
From: Jeff Mahoney <jeffm@suse.com>
To: Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org
Message-ID: <b9cc10b8-7677-2d4f-bc92-52b760caf141@suse.com>
Subject: Re: [PATCH] btrfs: qgroup: Don't trigger backref walk at delayed ref
 insert time
References: <20181211050237.19016-1-wqu@suse.com>
In-Reply-To: <20181211050237.19016-1-wqu@suse.com>

--aZutX3u4rOKiB5uyLRDECzAzrO1H1t91I
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

FWIW, I can hit this repeatedly with btrfs/078 and qgroups enabled:

[ 2938.002109] fsstress        D    0 14791  14790 0x00000000
[ 2938.002111] Call Trace:
[ 2938.002116]  ? __schedule+0x333/0xb80
[ 2938.002123]  schedule+0x3c/0x90
[ 2938.017789]  btrfs_tree_read_lock+0xa5/0x110 [btrfs]
[ 2938.017794]  ? wait_woken+0x80/0x80
[ 2938.020626]  find_parent_nodes+0x362/0xf10 [btrfs]
[ 2938.020650]  btrfs_find_all_roots_safe+0xab/0x110 [btrfs]
[ 2938.020665]  btrfs_find_all_roots+0x62/0x80 [btrfs]
[ 2938.020679]  btrfs_qgroup_trace_extent_post+0x27/0x60 [btrfs]
[ 2938.020696]  btrfs_add_delayed_data_ref+0x22f/0x3d0 [btrfs]
[ 2938.029540]  ? add_pinned_bytes+0x60/0x60 [btrfs]
[ 2938.030888]  btrfs_inc_extent_ref+0x74/0x100 [btrfs]
[ 2938.030902]  __btrfs_mod_ref+0x13f/0x240 [btrfs]
[ 2938.030919]  update_ref_for_cow+0x223/0x300 [btrfs]
[ 2938.030941]  __btrfs_cow_block+0x209/0x590 [btrfs]
[ 2938.030954]  btrfs_cow_block+0xea/0x250 [btrfs]
[ 2938.030966]  btrfs_search_slot+0x4c2/0x9b0 [btrfs]
[ 2938.030982]  btrfs_lookup_file_extent+0x37/0x40 [btrfs]
[ 2938.030998]  __btrfs_drop_extents+0x155/0xda0 [btrfs]
[ 2938.031008]  ? kmem_cache_alloc+0x1a9/0x2b0
[ 2938.031021]  btrfs_drop_extents+0x76/0xa0 [btrfs]
[ 2938.031039]  btrfs_clone+0xac3/0x1160 [btrfs]
[ 2938.031060]  btrfs_extent_same_range+0x406/0x500 [btrfs]
[ 2938.031076]  btrfs_remap_file_range+0x2b5/0x2d0 [btrfs]
[ 2938.031083]  vfs_dedupe_file_range_one+0x105/0x160
[ 2938.031087]  vfs_dedupe_file_range+0x152/0x1f0
[ 2938.031091]  do_vfs_ioctl+0x23c/0x6a0
[ 2938.031094]  ? __do_sys_newfstat+0x29/0x40
[ 2938.031098]  ksys_ioctl+0x60/0x90
[ 2938.031101]  __x64_sys_ioctl+0x16/0x20
[ 2938.031103]  do_syscall_64+0x57/0x190
[ 2938.031106]  entry_SYSCALL_64_after_hwframe+0x49/0xbe

So it's not just snapshots.  This patch fixes this case as well.

-Jeff


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
> =20
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



--aZutX3u4rOKiB5uyLRDECzAzrO1H1t91I--

--XuXQszm77NjFggOuly02TXWk0FdRN5P2F
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEE8wzgbmZ74SnKPwtDHntLYyF55bIFAlwarIwACgkQHntLYyF5
5bK7+RAAnQN3+fIQS6bGRcN89ek61cjFnQ8BZ03O/71ZZyUrab464SL3P1/HZtor
qPRik4kSzlXt70QCnp2SZEtXHumItnx5wUnSVM8bHeFU79Ui8Ur4FMiAGaBcNIVu
wLJzf3meeLbclqEZAPAn4JW8A3+WQguDGaikPN0xuuo9bUQdfnj7vdiS650trqD+
c01MkcFjIZEC1vS/c/2CpHHEhuPKZtbnPJzqpKxrlqr72zD/RLxAUuY1AUCjytxF
olsw/0hjtrcZydDIKyeNkFrMysAct2S1rb5UOJlPvvWF06Z9zqTX8wVko4TLq2js
sFJbva6DaTagwt72AdcnI0khQRC+Sz/F7Y78iqzwNQnDJtC9e/piFevyz5gIUJLA
BGABvEjnh4afs6bimxhGNtMTW/MfdXC/JBMEYynOGviZXTpJCfsnPqe5GppIR6AV
ThZ9LuxDgHQ0BVJv/qXuOLHBZQAQv0adzeDfcIHZfQSpXPg3H0CMQRS/qzf7IoF2
QRk4p66kFFEoGVVvwQD7WG5+vKKsLFPYr3AvN0GnjOu3Ft0xwTUBZwTGwmtNDlVc
xFRNZWgPOzID+PJQArWmuGQ4Ew1KOhComsolank4U6MYDEoiCzUugsZUXcgJxYBK
m2eIorVME5sxrMB7o3556L/VKbVA9yA8C/7RScdhXmI4p8USrFo=
=BmKQ
-----END PGP SIGNATURE-----

--XuXQszm77NjFggOuly02TXWk0FdRN5P2F--
