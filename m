Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:48306 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S966263AbeFSTbf (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 19 Jun 2018 15:31:35 -0400
Received: from relay1.suse.de (charybdis-ext-too.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id CA6CFACDB
        for <linux-btrfs@vger.kernel.org>; Tue, 19 Jun 2018 19:31:33 +0000 (UTC)
Subject: Re: [PATCH 1/3] btrfs: Remove fs_info argument from
 __btrfs_inc_extent_ref
To: Nikolay Borisov <nborisov@suse.com>, linux-btrfs@vger.kernel.org
References: <1529323166-29931-1-git-send-email-nborisov@suse.com>
 <1529323166-29931-2-git-send-email-nborisov@suse.com>
From: Jeff Mahoney <jeffm@suse.com>
Message-ID: <cad42e02-c494-a10e-5e12-f21cd209579c@suse.com>
Date: Tue, 19 Jun 2018 15:31:30 -0400
MIME-Version: 1.0
In-Reply-To: <1529323166-29931-2-git-send-email-nborisov@suse.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="Rrb51IOF2nh3eh04IU13TSEzErCzccgEm"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--Rrb51IOF2nh3eh04IU13TSEzErCzccgEm
Content-Type: multipart/mixed; boundary="S5lHDSMJWXfWRIOdG395tK6A8zx5ZWzsq";
 protected-headers="v1"
From: Jeff Mahoney <jeffm@suse.com>
To: Nikolay Borisov <nborisov@suse.com>, linux-btrfs@vger.kernel.org
Message-ID: <cad42e02-c494-a10e-5e12-f21cd209579c@suse.com>
Subject: Re: [PATCH 1/3] btrfs: Remove fs_info argument from
 __btrfs_inc_extent_ref
References: <1529323166-29931-1-git-send-email-nborisov@suse.com>
 <1529323166-29931-2-git-send-email-nborisov@suse.com>
In-Reply-To: <1529323166-29931-2-git-send-email-nborisov@suse.com>

--S5lHDSMJWXfWRIOdG395tK6A8zx5ZWzsq
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

On 6/18/18 7:59 AM, Nikolay Borisov wrote:
> This function already takes a transaction which holds a reference to
> the fs_info struct. Use that reference and remove the extra arg. No
> functional changes.

I like the idea here.  I wasn't sold at first, but I think if we can
standardize on taking only a trans handle when one is required and both
a trans and fs_info when it's optional, it'll make the code clearer.
This cleanup can percolate up the stack to cover pretty much all of
delayed refs.

Reviewed-by: Jeff Mahoney <jeffm@suse.com>

> Signed-off-by: Nikolay Borisov <nborisov@suse.com>
> ---
>  fs/btrfs/extent-tree.c | 15 ++++++---------
>  1 file changed, 6 insertions(+), 9 deletions(-)
>=20
> diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
> index 4850e538ab10..59645ced6fbc 100644
> --- a/fs/btrfs/extent-tree.c
> +++ b/fs/btrfs/extent-tree.c
> @@ -2208,12 +2208,12 @@ int btrfs_inc_extent_ref(struct btrfs_trans_han=
dle *trans,
>  }
> =20
>  static int __btrfs_inc_extent_ref(struct btrfs_trans_handle *trans,
> -				  struct btrfs_fs_info *fs_info,
>  				  struct btrfs_delayed_ref_node *node,
>  				  u64 parent, u64 root_objectid,
>  				  u64 owner, u64 offset, int refs_to_add,
>  				  struct btrfs_delayed_extent_op *extent_op)
>  {
> +	struct btrfs_fs_info *fs_info =3D trans->fs_info;
>  	struct btrfs_path *path;
>  	struct extent_buffer *leaf;
>  	struct btrfs_extent_item *item;
> @@ -2297,10 +2297,9 @@ static int run_delayed_data_ref(struct btrfs_tra=
ns_handle *trans,
>  						 ref->objectid, ref->offset,
>  						 &ins, node->ref_mod);
>  	} else if (node->action =3D=3D BTRFS_ADD_DELAYED_REF) {
> -		ret =3D __btrfs_inc_extent_ref(trans, fs_info, node, parent,
> -					     ref_root, ref->objectid,
> -					     ref->offset, node->ref_mod,
> -					     extent_op);
> +		ret =3D __btrfs_inc_extent_ref(trans, node, parent, ref_root,
> +					     ref->objectid, ref->offset,
> +					     node->ref_mod, extent_op);
>  	} else if (node->action =3D=3D BTRFS_DROP_DELAYED_REF) {
>  		ret =3D __btrfs_free_extent(trans, fs_info, node, parent,
>  					  ref_root, ref->objectid,
> @@ -2450,10 +2449,8 @@ static int run_delayed_tree_ref(struct btrfs_tra=
ns_handle *trans,
>  		BUG_ON(!extent_op || !extent_op->update_flags);
>  		ret =3D alloc_reserved_tree_block(trans, node, extent_op);
>  	} else if (node->action =3D=3D BTRFS_ADD_DELAYED_REF) {
> -		ret =3D __btrfs_inc_extent_ref(trans, fs_info, node,
> -					     parent, ref_root,
> -					     ref->level, 0, 1,
> -					     extent_op);
> +		ret =3D __btrfs_inc_extent_ref(trans, node, parent, ref_root,
> +					     ref->level, 0, 1, extent_op);
>  	} else if (node->action =3D=3D BTRFS_DROP_DELAYED_REF) {
>  		ret =3D __btrfs_free_extent(trans, fs_info, node,
>  					  parent, ref_root,
>=20


--=20
Jeff Mahoney
SUSE Labs


--S5lHDSMJWXfWRIOdG395tK6A8zx5ZWzsq--

--Rrb51IOF2nh3eh04IU13TSEzErCzccgEm
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEE8wzgbmZ74SnKPwtDHntLYyF55bIFAlspWhMACgkQHntLYyF5
5bLIxxAAtb9tltPo1OKRgRi2KDZmNFRQp16mMkcwo2a7Lzt3AdHWlzY/WXucxSV/
0AvY8dG/qFDg+Q8qmsnryVbjF5LJorDeFJGOl+21QDsvhI5LcWbh3Fu9kSZYNe7G
VI4GT6731RNxabbHH06dD+t/00ayfVjleV0coLDcmGQKj0ekyv9ZhP7D61fqADrB
xSs9AFrew3rewPj8E/8lQKp/MkT11h5rpt04exydAA0Uwci225JZYczCvZMvvVEH
HKyLh5PhG78t6v9RrCxgSr13P6Db2S/pj4CUf23yhD/Kx7VlJ4gp+H9/YLVEmTIh
Iruru9g3ZC43g1b7992PbeUa2sYQZz+JqJ1gGsAnjnNnMAZMachZ9npTz4GlRaXf
gGJss+9ec/HbEzR479ZqRaMDmY2sKrwJG0dvJDNhvfOyLAGfmyk4gLjCfunDH7cw
/1lHAO3QWvNCcdcrS/wUn0JadGPq0TNHzF5mgDMgI2YnoLzCSBTr5lS/ZckEPP1w
BuZDqQ92DxlVNyZiAX0VlwV88XkwzMYjHoCtahDSv3BEC6N7XW/TOYKdq579ZnBh
n8JO8N7DZhSPWIC+QkkhaIwPnwDbvB0gtEg21BYd3WNCSXimuDB2t24ZTzBGMbFL
4SINnV4zQkTahQdROJO9nTR86kVBY7FcRYDCyAevo/utrLpFFu8=
=XumD
-----END PGP SIGNATURE-----

--Rrb51IOF2nh3eh04IU13TSEzErCzccgEm--
