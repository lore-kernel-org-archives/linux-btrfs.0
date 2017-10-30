Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.18]:50888 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751269AbdJ3IdD (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 30 Oct 2017 04:33:03 -0400
Subject: Re: [PATCH 1/2] btrfs-progs: mkfs: add uuid and otime to ROOT_ITEM of
 FS_TREE
To: "Misono, Tomohiro" <misono.tomohiro@jp.fujitsu.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
References: <c5cfe661-fb6a-8346-874b-b20cd9cf0d90@jp.fujitsu.com>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <b0bcf673-2611-b301-a4f8-6635a6c54a63@gmx.com>
Date: Mon, 30 Oct 2017 16:32:53 +0800
MIME-Version: 1.0
In-Reply-To: <c5cfe661-fb6a-8346-874b-b20cd9cf0d90@jp.fujitsu.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="LICMq4nudpBWlpRLB1rAs9pWXJ6HaASTQ"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--LICMq4nudpBWlpRLB1rAs9pWXJ6HaASTQ
Content-Type: multipart/mixed; boundary="Sp9Pp7ioPuCN24VeipdRxw87euPiVWCTS";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: "Misono, Tomohiro" <misono.tomohiro@jp.fujitsu.com>,
 linux-btrfs <linux-btrfs@vger.kernel.org>
Message-ID: <b0bcf673-2611-b301-a4f8-6635a6c54a63@gmx.com>
Subject: Re: [PATCH 1/2] btrfs-progs: mkfs: add uuid and otime to ROOT_ITEM of
 FS_TREE
References: <c5cfe661-fb6a-8346-874b-b20cd9cf0d90@jp.fujitsu.com>
In-Reply-To: <c5cfe661-fb6a-8346-874b-b20cd9cf0d90@jp.fujitsu.com>

--Sp9Pp7ioPuCN24VeipdRxw87euPiVWCTS
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2017=E5=B9=B410=E6=9C=8830=E6=97=A5 16:14, Misono, Tomohiro wrote:
> Currently, the top-level subvolume lacks the UUID. As a result, both
> non-snapshot subvolume and snapshot of top-level subvolume do not have
> Parent UUID and cannot be distinguisued. Therefore "fi show" of
> top-level lists all the subvolumes which lacks the UUID in
> "Snapshot(s)". Also, it lacks the otime information.

What about creating a wiki page for ROOT_ITEM and detailed restriction
for its members?

>=20
> Fix this by adding the UUID and otime at the mkfs time.  As a
> consequence, snapshots of top-level subvolume now have a Parent UUID an=
d
> UUID tree will create an entry for top-level subvolume at mount time.

This patch also inspires me about the btrfs_create_tree() function I'm
introducing should also populate its UUID and timespec.

>=20
> Signed-off-by: Tomohiro Misono <misono.tomohiro@jp.fujitsu.com>
> ---
>  ctree.h       |  5 +++++
>  mkfs/common.c | 14 ++++++++++++++
>  mkfs/main.c   |  3 +++
>  3 files changed, 22 insertions(+)
>=20
> diff --git a/ctree.h b/ctree.h
> index 2280659..5737978 100644
> --- a/ctree.h
> +++ b/ctree.h
> @@ -2071,6 +2071,11 @@ BTRFS_SETGET_STACK_FUNCS(root_stransid, struct b=
trfs_root_item,
>  			 stransid, 64);
>  BTRFS_SETGET_STACK_FUNCS(root_rtransid, struct btrfs_root_item,
>  			 rtransid, 64);
> +static inline void btrfs_set_root_uuid(struct btrfs_root_item *root_it=
em,
> +			 u8 uuid[BTRFS_UUID_SIZE])
> +{
> +	memcpy(root_item->uuid, uuid, BTRFS_UUID_SIZE);
> +}

This is the stack version.

However there is no extent buffer version to set uuid as we just call
write_extent_buffer(), so it seems unnecessary to me.

> =20
>  /* struct btrfs_root_backup */
>  BTRFS_SETGET_STACK_FUNCS(backup_tree_root, struct btrfs_root_backup,
> diff --git a/mkfs/common.c b/mkfs/common.c
> index c9ce10d..808d343 100644
> --- a/mkfs/common.c
> +++ b/mkfs/common.c
> @@ -44,6 +44,7 @@ static int btrfs_create_tree_root(int fd, struct btrf=
s_mkfs_config *cfg,
>  	u32 itemoff;
>  	int ret =3D 0;
>  	int blk;
> +	u8 uuid[BTRFS_UUID_SIZE];
> =20
>  	memset(buf->data + sizeof(struct btrfs_header), 0,
>  		cfg->nodesize - sizeof(struct btrfs_header));
> @@ -77,6 +78,19 @@ static int btrfs_create_tree_root(int fd, struct btr=
fs_mkfs_config *cfg,
>  		btrfs_set_item_offset(buf, btrfs_item_nr(nritems), itemoff);
>  		btrfs_set_item_size(buf, btrfs_item_nr(nritems),
>  				sizeof(root_item));
> +		if (blk =3D=3D MKFS_FS_TREE) {
> +			time_t now =3D time(NULL);
> +
> +			uuid_generate(uuid);
> +			btrfs_set_root_uuid(&root_item, uuid);
> +			btrfs_set_stack_timespec_sec(&root_item.otime, now);
> +			btrfs_set_stack_timespec_sec(&root_item.ctime, now);
> +		} else {
> +			memset(uuid, 0, BTRFS_UUID_SIZE);

This leads to the question about the UUID meaning of different trees.

AFAIK every tree created by kernel has its own UUID, no one uses all zero=
=2E

In kernel btrfs_create_tree(), it always calls uuid_le_gen() to generate
a new UUID.
So I'm wonder if such branch is really needed.
And maybe we fix all tree creation to generate UUID.

Despite the question about the meaning of UUID for root_item, I think
the patch really makes sense.

Thanks,
Qu

> +			btrfs_set_root_uuid(&root_item, uuid);
> +			btrfs_set_stack_timespec_sec(&root_item.otime, 0);
> +			btrfs_set_stack_timespec_sec(&root_item.ctime, 0);
> +		}
>  		write_extent_buffer(buf, &root_item,
>  			btrfs_item_ptr_offset(buf, nritems),
>  			sizeof(root_item));
> diff --git a/mkfs/main.c b/mkfs/main.c
> index 1b4cabc..4184a2d 100644
> --- a/mkfs/main.c
> +++ b/mkfs/main.c
> @@ -329,6 +329,7 @@ static int create_tree(struct btrfs_trans_handle *t=
rans,
>  	struct btrfs_key location;
>  	struct btrfs_root_item root_item;
>  	struct extent_buffer *tmp;
> +	u8 uuid[BTRFS_UUID_SIZE] =3D {0};
>  	int ret;
> =20
>  	ret =3D btrfs_copy_root(trans, root, root->node, &tmp, objectid);
> @@ -339,6 +340,8 @@ static int create_tree(struct btrfs_trans_handle *t=
rans,
>  	btrfs_set_root_bytenr(&root_item, tmp->start);
>  	btrfs_set_root_level(&root_item, btrfs_header_level(tmp));
>  	btrfs_set_root_generation(&root_item, trans->transid);
> +	/* clear uuid of source tree */
> +	btrfs_set_root_uuid(&root_item, uuid);
>  	free_extent_buffer(tmp);
> =20
>  	location.objectid =3D objectid;
>=20


--Sp9Pp7ioPuCN24VeipdRxw87euPiVWCTS--

--LICMq4nudpBWlpRLB1rAs9pWXJ6HaASTQ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQFLBAEBCAA1FiEELd9y5aWlW6idqkLhwj2R86El/qgFAln247UXHHF1d2VucnVv
LmJ0cmZzQGdteC5jb20ACgkQwj2R86El/qi8igf/TKCWlGb4lpyEqAQxTWp64zfB
LKJtmRj6Z5WC5KmZ5z5h4lSV/M3g2X/9fTsOYUFCsWxBpgdBbOp/SkoAxY7PmCJg
tqkR+QgkTTpMFK5PL63QJtaUDCh1lXHnapc6tTj+WEQr/HMChVinSaw61VCn8aR6
PeGKcSYTKmtX/nXqWpc762e4OIEJyYBat3Dlfav9Evl0aR64Xhn2Zlh+DuzNXZK7
mK4epqR6c/ghQhN3o39Os8IbBfjgoMlFmdA+a7bE90Iyn0E7xgY8HCLqKebIq/1z
qoKrLTrEykltKs/BY3qXnOzDXjOaFpCYb7bYSXfrju4gn816ViqUfSF6QHyiOQ==
=dAZm
-----END PGP SIGNATURE-----

--LICMq4nudpBWlpRLB1rAs9pWXJ6HaASTQ--
