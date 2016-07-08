Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:36935 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753775AbcGHBcm (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 7 Jul 2016 21:32:42 -0400
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
	by mx2.suse.de (Postfix) with ESMTP id 9BBB3AAF4
	for <linux-btrfs@vger.kernel.org>; Fri,  8 Jul 2016 01:32:40 +0000 (UTC)
Subject: Re: [PATCH 05/31] btrfs: tests, require fs_info for root
To: linux-btrfs@vger.kernel.org, David Sterba <DSterba@suse.com>
References: <1466806524-27508-1-git-send-email-jeffm@suse.com>
 <1466806524-27508-6-git-send-email-jeffm@suse.com>
From: Jeff Mahoney <jeffm@suse.com>
Message-ID: <dda2dc27-7422-c261-a59b-0b271ca94195@suse.com>
Date: Thu, 7 Jul 2016 21:32:37 -0400
MIME-Version: 1.0
In-Reply-To: <1466806524-27508-6-git-send-email-jeffm@suse.com>
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="1Ax2R1O1sdQjfwrbWsR6ewigRu3ALsAHS"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--1Ax2R1O1sdQjfwrbWsR6ewigRu3ALsAHS
Content-Type: multipart/mixed; boundary="6uaD7wn5i8MTQRwSlwGmLidj931IEECvc"
From: Jeff Mahoney <jeffm@suse.com>
To: linux-btrfs@vger.kernel.org, David Sterba <DSterba@suse.com>
Message-ID: <dda2dc27-7422-c261-a59b-0b271ca94195@suse.com>
Subject: Re: [PATCH 05/31] btrfs: tests, require fs_info for root
References: <1466806524-27508-1-git-send-email-jeffm@suse.com>
 <1466806524-27508-6-git-send-email-jeffm@suse.com>
In-Reply-To: <1466806524-27508-6-git-send-email-jeffm@suse.com>

--6uaD7wn5i8MTQRwSlwGmLidj931IEECvc
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 6/24/16 6:14 PM, jeffm@suse.com wrote:
> From: Jeff Mahoney <jeffm@suse.com>
>=20
> This allows the upcoming patchset to push nodesize and sectorsize into
> fs_info.
>=20
> Signed-off-by: Jeff Mahoney <jeffm@suse.com>
> ---
>  fs/btrfs/ctree.h                       |  1 +
>  fs/btrfs/disk-io.c                     | 15 +++++++----
>  fs/btrfs/disk-io.h                     |  3 ++-
>  fs/btrfs/tests/btrfs-tests.c           | 20 ++++++++++++---
>  fs/btrfs/tests/btrfs-tests.h           |  1 +
>  fs/btrfs/tests/extent-buffer-tests.c   | 23 +++++++++++------
>  fs/btrfs/tests/free-space-tests.c      | 14 +++++++----
>  fs/btrfs/tests/free-space-tree-tests.c | 18 +++++++------
>  fs/btrfs/tests/inode-tests.c           | 46 ++++++++++++++++++--------=
--------
>  fs/btrfs/tests/qgroup-tests.c          | 23 +++++++++--------
>  10 files changed, 103 insertions(+), 61 deletions(-)
>=20
> diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
> index 100d2ea..4781057 100644
> --- a/fs/btrfs/ctree.h
> +++ b/fs/btrfs/ctree.h
> @@ -117,6 +117,7 @@ static inline unsigned long btrfs_chunk_item_size(i=
nt num_stripes)
>  #define BTRFS_FS_STATE_REMOUNTING	1
>  #define BTRFS_FS_STATE_TRANS_ABORTED	2
>  #define BTRFS_FS_STATE_DEV_REPLACING	3
> +#define BTRFS_FS_STATE_DUMMY_FS_INFO	4
> =20
>  #define BTRFS_BACKREF_REV_MAX		256
>  #define BTRFS_BACKREF_REV_SHIFT		56
> diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
> index 8f27127..418163d 100644
> --- a/fs/btrfs/disk-io.c
> +++ b/fs/btrfs/disk-io.c
> @@ -1233,6 +1233,7 @@ static void __setup_root(u32 nodesize, u32 sector=
size, u32 stripesize,
>  			 struct btrfs_root *root, struct btrfs_fs_info *fs_info,
>  			 u64 objectid)
>  {
> +	bool dummy =3D test_bit(BTRFS_FS_STATE_DUMMY_FS_INFO, &fs_info->fs_st=
ate);
>  	root->node =3D NULL;
>  	root->commit_root =3D NULL;
>  	root->sectorsize =3D sectorsize;
> @@ -1287,14 +1288,14 @@ static void __setup_root(u32 nodesize, u32 sect=
orsize, u32 stripesize,
>  	root->log_transid =3D 0;
>  	root->log_transid_committed =3D -1;
>  	root->last_log_commit =3D 0;
> -	if (fs_info)
> +	if (dummy)

This should be:
if (!dummy)

>  		extent_io_tree_init(&root->dirty_log_pages,
>  				     fs_info->btree_inode->i_mapping);
> =20
>  	memset(&root->root_key, 0, sizeof(root->root_key));
>  	memset(&root->root_item, 0, sizeof(root->root_item));
>  	memset(&root->defrag_progress, 0, sizeof(root->defrag_progress));
> -	if (fs_info)
> +	if (dummy)

So should this.

-Jeff

--=20
Jeff Mahoney
SUSE Labs


--6uaD7wn5i8MTQRwSlwGmLidj931IEECvc--

--1Ax2R1O1sdQjfwrbWsR6ewigRu3ALsAHS
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG/MacGPG2 v2.0.19 (Darwin)
Comment: GPGTools - http://gpgtools.org

iQIcBAEBAgAGBQJXfwK1AAoJEB57S2MheeWyiM4P/idkcGhNeFrxu+XKJzQlrMk8
2IFDP21PbGeLajtMpAUnfzbFW3oCcNfKf25CkArZq4V2TMT9pTrceONUhlg5AMtq
jMQpaEgHeXP0wxaMvOQ7T0v2IRbofBsW73t2ATGsLlBaYBatWtKZM6mq4xzEiOqD
8sT9alh0LKbc57uL8cQYmoLrpWlRP/n23KEaRBCWOxig5BZoo7MPxwCm9hVZp2Tg
R0YcA6ZQUOz6JUBtAN9Zwa22NymXamxbosN2oEk6ZcciyXANDHYp8qBlmFh6jZgu
XRHfYoSyxzA7QradrJ4LFgE7eOwUx/CsV3ewgwZfvLhIVUxNlKoEq1SR1eaiAtzs
yymaUrx0Mdsn0yVixAJ68IsLiBAufPIarniRdv9PyUzYfi+2hIg7zN8Kl8Vkcys0
yJ2QErJh0AScSx4oZl5YrTEL8uwktSeBHS5rga0sdrnaCP2WVyngKHPaYBNBBXnM
JLRXZoDehj7kIajz23JdzTL8io9xq34bmovAwcMETJmq+h5X5i8BxPF8foe/1Okl
2Q1ElF2rGZOsbCbjH64gST7qY9mE2cZn9+GlSqtuXRfXS9dpA6R0qFgD9nqEO7TZ
yDsgJX7KxXII85o3j3CEDSinC1XNwyO9ZmkW0KEPW9XMna1uTCEmYPLk4M/kh5QP
/jwANlH9dy1mzIOnNmCt
=bugO
-----END PGP SIGNATURE-----

--1Ax2R1O1sdQjfwrbWsR6ewigRu3ALsAHS--
