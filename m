Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:60086 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751338AbdBOWEZ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 15 Feb 2017 17:04:25 -0500
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 3DC2AACD8
        for <linux-btrfs@vger.kernel.org>; Wed, 15 Feb 2017 22:04:23 +0000 (UTC)
Subject: Re: [PATCH 5/8] btrfs: btrfs_wait_cache_io_root doesn't use path
 argument
To: linux-btrfs@vger.kernel.org
References: <1487194114-12786-1-git-send-email-jeffm@suse.com>
 <1487194114-12786-6-git-send-email-jeffm@suse.com>
From: Jeff Mahoney <jeffm@suse.com>
Message-ID: <36908d97-3b6b-5920-7721-745244550619@suse.com>
Date: Wed, 15 Feb 2017 17:04:18 -0500
MIME-Version: 1.0
In-Reply-To: <1487194114-12786-6-git-send-email-jeffm@suse.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="mErFXWx4wFhXKxghAukj5QPWL1Js3TDEM"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--mErFXWx4wFhXKxghAukj5QPWL1Js3TDEM
Content-Type: multipart/mixed; boundary="wti8kWeDbu3N2WS532uLhhbpjl2JjpMJ9";
 protected-headers="v1"
From: Jeff Mahoney <jeffm@suse.com>
To: linux-btrfs@vger.kernel.org
Message-ID: <36908d97-3b6b-5920-7721-745244550619@suse.com>
Subject: Re: [PATCH 5/8] btrfs: btrfs_wait_cache_io_root doesn't use path
 argument
References: <1487194114-12786-1-git-send-email-jeffm@suse.com>
 <1487194114-12786-6-git-send-email-jeffm@suse.com>
In-Reply-To: <1487194114-12786-6-git-send-email-jeffm@suse.com>

--wti8kWeDbu3N2WS532uLhhbpjl2JjpMJ9
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 2/15/17 4:28 PM, jeffm@suse.com wrote:
> From: Jeff Mahoney <jeffm@suse.com>
>=20
> Signed-off-by: Jeff Mahoney <jeffm@suse.com>

This one is obsoleted by Dave's patch:
[PATCH 28/29] btrfs: remove unused parameters from __btrfs_write_out_cach=
e

-Jeff


> ---
>  fs/btrfs/free-space-cache.c | 11 +++--------
>  1 file changed, 3 insertions(+), 8 deletions(-)
>=20
> diff --git a/fs/btrfs/free-space-cache.c b/fs/btrfs/free-space-cache.c
> index 61a72fb..a1e15f6 100644
> --- a/fs/btrfs/free-space-cache.c
> +++ b/fs/btrfs/free-space-cache.c
> @@ -42,10 +42,6 @@ static int link_free_space(struct btrfs_free_space_c=
tl *ctl,
>  			   struct btrfs_free_space *info);
>  static void unlink_free_space(struct btrfs_free_space_ctl *ctl,
>  			      struct btrfs_free_space *info);
> -static int btrfs_wait_cache_io_root(struct btrfs_root *root,
> -			     struct btrfs_trans_handle *trans,
> -			     struct btrfs_io_ctl *io_ctl,
> -			     struct btrfs_path *path);
> =20
>  static struct inode *__lookup_free_space_inode(struct btrfs_root *root=
,
>  					       struct btrfs_path *path,
> @@ -1234,8 +1230,7 @@ static int __btrfs_write_out_cache(struct btrfs_r=
oot *root, struct inode *inode,
>  				   struct btrfs_free_space_ctl *ctl,
>  				   struct btrfs_block_group_cache *block_group,
>  				   struct btrfs_io_ctl *io_ctl,
> -				   struct btrfs_trans_handle *trans,
> -				   struct btrfs_path *path, u64 offset)
> +				   struct btrfs_trans_handle *trans, u64 offset)
>  {
>  	struct btrfs_fs_info *fs_info =3D root->fs_info;
>  	struct extent_state *cached_state =3D NULL;
> @@ -1393,7 +1388,7 @@ int btrfs_write_out_cache(struct btrfs_fs_info *f=
s_info,
> =20
>  	ret =3D __btrfs_write_out_cache(fs_info->tree_root, inode, ctl,
>  				      block_group, &block_group->io_ctl, trans,
> -				      path, block_group->key.objectid);
> +				      block_group->key.objectid);
>  	if (ret) {
>  #ifdef DEBUG
>  		btrfs_err(fs_info,
> @@ -3541,7 +3536,7 @@ int btrfs_write_out_ino_cache(struct btrfs_root *=
root,
> =20
>  	memset(&io_ctl, 0, sizeof(io_ctl));
>  	ret =3D __btrfs_write_out_cache(root, inode, ctl, NULL, &io_ctl,
> -				      trans, path, 0);
> +				      trans, 0);
>  	if (!ret) {
>  		/*
>  		 * At this point writepages() didn't error out, so our metadata
>=20


--=20
Jeff Mahoney
SUSE Labs


--wti8kWeDbu3N2WS532uLhhbpjl2JjpMJ9--

--mErFXWx4wFhXKxghAukj5QPWL1Js3TDEM
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG/MacGPG2 v2

iQIVAwUBWKTQZR57S2MheeWyAQiMKQ//fku8XGuhE9Bvt5qpozvy7I6lPtpGIH5q
9QJyyN4uab18/pishATG1dYZHcna/fmOJGVHt9R38j41mAckj8EguJS/gckSvfag
mX7b55w6E9gzT6NoQFwVkWGTb7pPvTZjDhhgrxD+arBkKILSeHvBvLrYU0XBHB71
tsS7hLKbJWDqJqlA3LtMGymnCoOqn9zTVlxy42GRtuBiO319v6sEdbILqqfL/4v4
7Nww5B9zHfbf2mLaYabbgzBYEzNsb/hfHRSUELO0kcUr0L8RY/70IkmybgKH31Kk
8FaUaWRqn8iiq0WidyOX6vGDROr6oq6OKMWGi6Jb4VQ6MZpKm5QAp5pRz5jp6QoB
J8lb5XTWn5txghIcSKJUG+YkDTw4+nR/f7CGR0yNIyrP6/ovuQZiy3xiSsEaGw1P
soyG7uQrTbjqUYRwgMtwXFGB08qppQ8fWU1wlCgsOo4oI/KILcXuyWi0lBRu9fLq
1oSJ5kpcvhbOmGwX0zZYFyhswEj2U2Z0J7Yg5dObqeK6dDje5AX4TjzJyx2csIb9
VhEBbIpnXftTmWKLDEvfeq3HSNBgN6LoWnOweBXdoo2LYxKA+9NVIMAmGdv5VYha
3BDXIUfGdKkIMPO01AsUCp57Lir+QetX0utDVb2M4KY2KS9+XWzHZ2VEp5Q506zL
4jeGtUxjs7Y=
=25yX
-----END PGP SIGNATURE-----

--mErFXWx4wFhXKxghAukj5QPWL1Js3TDEM--
