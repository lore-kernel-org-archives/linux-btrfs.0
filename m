Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:40461 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1755348AbeFNVbT (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 14 Jun 2018 17:31:19 -0400
Subject: Re: [PATCH] btrfs: Document __btrfs_inc_extent_ref
To: Nikolay Borisov <nborisov@suse.com>, linux-btrfs@vger.kernel.org
Cc: josef@toxicpanda.com
References: <1526649170-29815-1-git-send-email-nborisov@suse.com>
From: Jeff Mahoney <jeffm@suse.com>
Message-ID: <ba2eee88-e28d-342c-978c-a59e97b61a59@suse.com>
Date: Thu, 14 Jun 2018 17:31:14 -0400
MIME-Version: 1.0
In-Reply-To: <1526649170-29815-1-git-send-email-nborisov@suse.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="zZKMQyBKFbYrzhABodnNCJe8fuARDcIoZ"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--zZKMQyBKFbYrzhABodnNCJe8fuARDcIoZ
Content-Type: multipart/mixed; boundary="m6r4WKZBUCZkifVihAdvPxKVyGWE7CmNH";
 protected-headers="v1"
From: Jeff Mahoney <jeffm@suse.com>
To: Nikolay Borisov <nborisov@suse.com>, linux-btrfs@vger.kernel.org
Cc: josef@toxicpanda.com
Message-ID: <ba2eee88-e28d-342c-978c-a59e97b61a59@suse.com>
Subject: Re: [PATCH] btrfs: Document __btrfs_inc_extent_ref
References: <1526649170-29815-1-git-send-email-nborisov@suse.com>
In-Reply-To: <1526649170-29815-1-git-send-email-nborisov@suse.com>

--m6r4WKZBUCZkifVihAdvPxKVyGWE7CmNH
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

On 5/18/18 9:12 AM, Nikolay Borisov wrote:
> Here is a doc-only patch which tires to deobfuscate the terra-incognita=

> that arguments for delayed refs are.
>=20
> Signed-off-by: Nikolay Borisov <nborisov@suse.com>
> ---
> Hello,=20
>=20
> This patch needs revieweing since I'm not entirely sure I managed to ca=
pture=20
> the semantics of the "parent" and "owner" arguments. Specifically, pare=
nt is=20
> passed "ref->parent" only if we have a shared block, however looking at=
 the=20
> code where parent is passed to the add delayed tree/data refs, it seems=
 that=20
> parent is set to the eb->Start only if the tree where this extent comes=
 from is=20
> the data_reloc_tree, i.e the code in replace_path/replace_file_extents/=
do_relocation
> __btrfs_cow_block.

This makes sense.  When we create a new extent or add a reference to an
existing one, we have a root to use as a reference.  Those references
are created as indirect references.  When a reference is dropped and the
remaining references are either shared or implied from higher levels in
the tree, we need to create a shared reference.

The exception is relocation which is creating new extents in a literal
sense, but is really just moving them.  We only have the references
already in place to work with, so we'll need to insert updated shared
references to point to the new parent.

> For the "owner" argument in case of data extents it'set to the ino, for=
 metadata
> extents it's a bit trickier, what I think it always contains for such e=
xtents=20
> is the level of the parent block in the tree.=20

It contains the level of the buffer in the tree.

__btrfs_cow_block():

        level =3D btrfs_header_level(buf);

        if (level =3D=3D 0)
                btrfs_item_key(buf, &disk_key, 0);
        else
                btrfs_node_key(buf, &disk_key, 0);

Leaf node extents show up in the tree dump as (objectid METADATA_ITEM 0).=


If you're referring to the following comment, it was introduced in the
commit that added skinny metadata (3173a18f70554).
        /*
         * Owner is our parent level, so we can just add one to get the
level
         * for the block we are interested in.
         */

I think that Josef was maybe documenting why just using the level was
safe instead of using the full key + level as the old tree block refs
did.  It could probably be made more clear if that's the case.

> If this function is documented correctly then it wil be fairly trivial =
to=20
> document btrfs_add_delayed(tree|data)_ref ones as well.=20
>=20
>  fs/btrfs/extent-tree.c | 29 +++++++++++++++++++++++++++++
>  1 file changed, 29 insertions(+)
>=20
> diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
> index 2ce32f05812f..5a2f4a86dc71 100644
> --- a/fs/btrfs/extent-tree.c
> +++ b/fs/btrfs/extent-tree.c
> @@ -2207,6 +2207,35 @@ int btrfs_inc_extent_ref(struct btrfs_trans_hand=
le *trans,
>  	return ret;
>  }
> =20
> +/*
> + * __btrfs_inc_extent_ref - insert backreference for a given extent
> + *
> + * @trans:	    Handle of transaction
> + *
> + * @node:	    The delayed ref node used to get the bytenr/length for
> + *		    extent
> + *
> + * @parent:	    If this is a shared extent (BTRFS_SHARED_DATA_REF_KEY/=

> + *		    BTRFS_SHARED_BLOCK_REF_KEY) then parent *may* hold the> + *		 =
   logical bytenr of the parent block.

If this is a shared extent then parent holds the logical bytenr of the
parent block.  Since new extents are always created with indirect
references, this will only be the case when relocating a shared extent.
In that case, root_objectid will be BTRFS_TREE_RELOC_OBJECTID.
Otherwise, parent must be 0.

> + * @root_objectid: The id of the root where this modification has orig=
inated,
> + *		    this can be either one of the well-known metadata trees or
> + *		    the subvolume id which references this extent.
> + *
> + * @owner:	    For data extents it is the inode number of the owning f=
ile.
> + *		    For metadata extents this parameter holds the level in the
> + *		    tree of the parent block.
>

As mentioned above, it holds the level of the tree that contains the
block.  The parent can be looked up indirectly by taking this level and
adding 1 until we hit the level of the root node.

> + * @offset:	    For metadata extents this is always 0. For data extent=
s it
> + *		    is the fileoffset this extent belongs to.

For metadata extents, offset is ignored.  It just happens to be passed
as 0 in existing code.

-Jeff

--=20
Jeff Mahoney
SUSE Labs


--m6r4WKZBUCZkifVihAdvPxKVyGWE7CmNH--

--zZKMQyBKFbYrzhABodnNCJe8fuARDcIoZ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEE8wzgbmZ74SnKPwtDHntLYyF55bIFAlsi3qMACgkQHntLYyF5
5bLQIw/8CGHzj8gKXiBMr3gAKO0shYAL+LbukeYIdAD7FsOV+Uwxv0tQR8cNyHhu
vjDBdGMS1hQuCiaJpqO8VzT0f2jCt9dMYYAoaIRN2p08wAbdIWDjEkd/FCRTQN5B
S9ICtBZxqU3qYIaA7dCiC5zfKQF3y/WdvcIaHUx9LhcFlQDqbiEE9tMYzaY4qgO7
2PkuMbh7LPCt4dKy4Zc5xmLEcpkzgQEnlk4N04qDjPS5H+bZnpUg6zFfzRQnnSQC
MiDeClCzXDV+290B0hDpmjmz4bUN7v6jFOsE/ijdb4/dTebz/X/q2GP2YzLLNcNz
wU5XqkwM/druJ1KCjIgcG7mqnHRUvTRoMwZ3rsOXosh/6Y75GLiLxdFdiYu7CpYL
feGQG36JbVQekdzPv7MaAt/Jb07L2oVwGA/5iUXTcPjDWbwxcMi7OvaljLwmpx+B
V9DfJKA/FvJy/ODbtTHcZf0uCUz6fXqxhZOHi+ktwdigMR5OJcPL9nRdxtk8uWdD
rj32dobrABgAr2oI+qjPFIGnLfnG9ZVCjOMN5/2c5jPmc6KCK8Ou6E8XQHoiFSSm
hnv3jtIQnjvyamz2OXstvXJHCpNtVPXS0Eo61Rki3Huq3tdAOaFUW5fGcX+H4l51
pRHJyaqSDG6Ucz8SR/42gYXJ5i+oEnRxpRWb8P7pKUHQQcob5V0=
=9Shs
-----END PGP SIGNATURE-----

--zZKMQyBKFbYrzhABodnNCJe8fuARDcIoZ--
