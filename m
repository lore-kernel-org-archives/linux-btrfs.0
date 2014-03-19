Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:57720 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750812AbaCSS4y (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 19 Mar 2014 14:56:54 -0400
Date: Wed, 19 Mar 2014 18:56:51 +0000
From: Hugo Mills <hugo@carfax.org.uk>
To: Josef Bacik <jbacik@fb.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] Btrfs: take into account total references when doing
 backref lookup V2
Message-ID: <20140319185651.GC11122@carfax.org.uk>
References: <1395250514-28911-1-git-send-email-jbacik@fb.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Clx92ZfkiYIKRjnr"
In-Reply-To: <1395250514-28911-1-git-send-email-jbacik@fb.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--Clx92ZfkiYIKRjnr
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Mar 19, 2014 at 01:35:14PM -0400, Josef Bacik wrote:
> I added an optimization for large files where we would stop searching for
> backrefs once we had looked at the number of references we currently had =
for
> this extent.  This works great most of the time, but for snapshots that p=
oint to
> this extent and has changes in the original root this assumption falls on=
 it
> face.  So keep track of any delayed ref mods made and add in the actual r=
ef
> count as reported by the extent item and use that to limit how far down a=
n inode
> we'll search for extents.  Thanks,
>=20
> Reported-by: Hugo Mills <hugo@carfax.org.uk>

Reported-by: Hugo Mills <hugo@carfax.org.uk>

> Signed-off-by: Josef Bacik <jbacik@fb.com>

Tested-by: Hugo Mills <hugo@carfax.org.uk>

   Looks like it's worked. (Modulo the above typo in the metadata ;) )
I'll do a more complete test overnight.

   Hugo.

> ---
> V1->V2: Just use the extent ref count and any delayed ref counts, this wi=
ll work
> out right, whereas the shared thing doesn't work out in some cases.
>=20
>  fs/btrfs/backref.c | 29 ++++++++++++++++++-----------
>  1 file changed, 18 insertions(+), 11 deletions(-)
>=20
> diff --git a/fs/btrfs/backref.c b/fs/btrfs/backref.c
> index 0be0e94..10db21f 100644
> --- a/fs/btrfs/backref.c
> +++ b/fs/btrfs/backref.c
> @@ -220,7 +220,8 @@ static int __add_prelim_ref(struct list_head *head, u=
64 root_id,
> =20
>  static int add_all_parents(struct btrfs_root *root, struct btrfs_path *p=
ath,
>  			   struct ulist *parents, struct __prelim_ref *ref,
> -			   int level, u64 time_seq, const u64 *extent_item_pos)
> +			   int level, u64 time_seq, const u64 *extent_item_pos,
> +			   u64 total_refs)
>  {
>  	int ret =3D 0;
>  	int slot;
> @@ -249,7 +250,7 @@ static int add_all_parents(struct btrfs_root *root, s=
truct btrfs_path *path,
>  	if (path->slots[0] >=3D btrfs_header_nritems(path->nodes[0]))
>  		ret =3D btrfs_next_old_leaf(root, path, time_seq);
> =20
> -	while (!ret && count < ref->count) {
> +	while (!ret && count < total_refs) {
>  		eb =3D path->nodes[0];
>  		slot =3D path->slots[0];
> =20
> @@ -306,7 +307,7 @@ static int __resolve_indirect_ref(struct btrfs_fs_inf=
o *fs_info,
>  				  struct btrfs_path *path, u64 time_seq,
>  				  struct __prelim_ref *ref,
>  				  struct ulist *parents,
> -				  const u64 *extent_item_pos)
> +				  const u64 *extent_item_pos, u64 total_refs)
>  {
>  	struct btrfs_root *root;
>  	struct btrfs_key root_key;
> @@ -364,7 +365,7 @@ static int __resolve_indirect_ref(struct btrfs_fs_inf=
o *fs_info,
>  	}
> =20
>  	ret =3D add_all_parents(root, path, parents, ref, level, time_seq,
> -			      extent_item_pos);
> +			      extent_item_pos, total_refs);
>  out:
>  	path->lowest_level =3D 0;
>  	btrfs_release_path(path);
> @@ -377,7 +378,7 @@ out:
>  static int __resolve_indirect_refs(struct btrfs_fs_info *fs_info,
>  				   struct btrfs_path *path, u64 time_seq,
>  				   struct list_head *head,
> -				   const u64 *extent_item_pos)
> +				   const u64 *extent_item_pos, u64 total_refs)
>  {
>  	int err;
>  	int ret =3D 0;
> @@ -403,7 +404,8 @@ static int __resolve_indirect_refs(struct btrfs_fs_in=
fo *fs_info,
>  		if (ref->count =3D=3D 0)
>  			continue;
>  		err =3D __resolve_indirect_ref(fs_info, path, time_seq, ref,
> -					     parents, extent_item_pos);
> +					     parents, extent_item_pos,
> +					     total_refs);
>  		/*
>  		 * we can only tolerate ENOENT,otherwise,we should catch error
>  		 * and return directly.
> @@ -560,7 +562,7 @@ static void __merge_refs(struct list_head *head, int =
mode)
>   * smaller or equal that seq to the list
>   */
>  static int __add_delayed_refs(struct btrfs_delayed_ref_head *head, u64 s=
eq,
> -			      struct list_head *prefs)
> +			      struct list_head *prefs, u64 *total_refs)
>  {
>  	struct btrfs_delayed_extent_op *extent_op =3D head->extent_op;
>  	struct rb_node *n =3D &head->node.rb_node;
> @@ -596,6 +598,7 @@ static int __add_delayed_refs(struct btrfs_delayed_re=
f_head *head, u64 seq,
>  		default:
>  			BUG_ON(1);
>  		}
> +		*total_refs +=3D (node->ref_mod * sgn);
>  		switch (node->type) {
>  		case BTRFS_TREE_BLOCK_REF_KEY: {
>  			struct btrfs_delayed_tree_ref *ref;
> @@ -656,7 +659,8 @@ static int __add_delayed_refs(struct btrfs_delayed_re=
f_head *head, u64 seq,
>   */
>  static int __add_inline_refs(struct btrfs_fs_info *fs_info,
>  			     struct btrfs_path *path, u64 bytenr,
> -			     int *info_level, struct list_head *prefs)
> +			     int *info_level, struct list_head *prefs,
> +			     u64 *total_refs)
>  {
>  	int ret =3D 0;
>  	int slot;
> @@ -680,6 +684,7 @@ static int __add_inline_refs(struct btrfs_fs_info *fs=
_info,
> =20
>  	ei =3D btrfs_item_ptr(leaf, slot, struct btrfs_extent_item);
>  	flags =3D btrfs_extent_flags(leaf, ei);
> +	*total_refs +=3D btrfs_extent_refs(leaf, ei);
>  	btrfs_item_key_to_cpu(leaf, &found_key, slot);
> =20
>  	ptr =3D (unsigned long)(ei + 1);
> @@ -862,6 +867,7 @@ static int find_parent_nodes(struct btrfs_trans_handl=
e *trans,
>  	struct list_head prefs;
>  	struct __prelim_ref *ref;
>  	struct extent_inode_elem *eie =3D NULL;
> +	u64 total_refs =3D 0;
> =20
>  	INIT_LIST_HEAD(&prefs);
>  	INIT_LIST_HEAD(&prefs_delayed);
> @@ -920,7 +926,7 @@ again:
>  			}
>  			spin_unlock(&delayed_refs->lock);
>  			ret =3D __add_delayed_refs(head, time_seq,
> -						 &prefs_delayed);
> +						 &prefs_delayed, &total_refs);
>  			mutex_unlock(&head->mutex);
>  			if (ret)
>  				goto out;
> @@ -941,7 +947,8 @@ again:
>  		    (key.type =3D=3D BTRFS_EXTENT_ITEM_KEY ||
>  		     key.type =3D=3D BTRFS_METADATA_ITEM_KEY)) {
>  			ret =3D __add_inline_refs(fs_info, path, bytenr,
> -						&info_level, &prefs);
> +						&info_level, &prefs,
> +						&total_refs);
>  			if (ret)
>  				goto out;
>  			ret =3D __add_keyed_refs(fs_info, path, bytenr,
> @@ -961,7 +968,7 @@ again:
>  	__merge_refs(&prefs, 1);
> =20
>  	ret =3D __resolve_indirect_refs(fs_info, path, time_seq, &prefs,
> -				      extent_item_pos);
> +				      extent_item_pos, total_refs);
>  	if (ret)
>  		goto out;
> =20

--=20
=3D=3D=3D Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk=
 =3D=3D=3D
  PGP key: 65E74AC0 from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
      --- What's a Nazg=FBl like you doing in a place like this? ---     =
=20

--Clx92ZfkiYIKRjnr
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIVAwUBUynoc1heFHXiqx3kAQLnqQ/8CHopT31Daz6J9a4IHDtUghFuwDohTWsh
YSVzqTpYzeLT+at+XT6qQNKctnCeazF41duWlZjBBNdozsZCu9J9mJnffPEn/B2R
smJdRF4mmxGX/Y3M9CeXHscjayqwG76C22P/kwsqLwm1nJXQcmV5aN+e6lmeXMvY
wJkssqH8qJj3GY1XNpOkMqgQQLcROBQrpWOhjknk3Re25B7sKvJxv4ShyzpuNd3W
mdZJ/ZNmbaEson0GKi2aiTSpB7gAS7LA5MHDqTAARBf055tcFy/fLLRDXwHEs0zJ
uYCfODwjwpN1fqqGJT6PpvcPd9fMDqG68Bkok/5g1ADw409CAvBEa96ht7DD4pUP
i6GvsbjT8tE2aupwNvVzkAQKH9K1AlAICVqYfW3VX2FAds01PVbNksBKs16m+IbH
aAAuPsfF3q8OZUBeOnvTkoRcBZJnKhL4vAVCCP7lfwU/+wnc3ZMf3iBTkZXZ4KH/
Dgwr1egPMQ2VfCWwLWOAcTOcQqOhWWTaqn/TWT0UKeVzptbeR7WzW7+PraepOSXC
kt/sdlXazcLGz9yMxCcir06uveGkvnH0Vz9+XM5TNRgyFDEFihrJ13XcSn3cTNJd
HYHO+Apgw+BO5mYhH+d864698iBnDad/FGy3kQXEwefwAzaTiCYMcg14uswayc+j
rotjAYp+cFA=
=7KBX
-----END PGP SIGNATURE-----

--Clx92ZfkiYIKRjnr--
