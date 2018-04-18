Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.20]:40861 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752543AbeDRFMW (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 18 Apr 2018 01:12:22 -0400
Subject: Re: [PATCH v2 04/10] btrfs-progs: undelete-subvol: introduce
 is_subvol_intact
To: Lu Fengqi <lufq.fnst@cn.fujitsu.com>, linux-btrfs@vger.kernel.org
References: <20180327070658.13064-1-lufq.fnst@cn.fujitsu.com>
 <20180327070658.13064-5-lufq.fnst@cn.fujitsu.com>
Cc: David Sterba <dsterba@suse.cz>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <c4bd3079-c431-4c99-f140-bb02493d708b@gmx.com>
Date: Wed, 18 Apr 2018 13:12:10 +0800
MIME-Version: 1.0
In-Reply-To: <20180327070658.13064-5-lufq.fnst@cn.fujitsu.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="DurMcTYTkAk6EvPP64l3TA4bckWCO8KI4"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--DurMcTYTkAk6EvPP64l3TA4bckWCO8KI4
Content-Type: multipart/mixed; boundary="4I8ioX9cc0T2T2rhceOGnlmvz2ByVxDFJ";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: Lu Fengqi <lufq.fnst@cn.fujitsu.com>, linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.cz>
Message-ID: <c4bd3079-c431-4c99-f140-bb02493d708b@gmx.com>
Subject: Re: [PATCH v2 04/10] btrfs-progs: undelete-subvol: introduce
 is_subvol_intact
References: <20180327070658.13064-1-lufq.fnst@cn.fujitsu.com>
 <20180327070658.13064-5-lufq.fnst@cn.fujitsu.com>
In-Reply-To: <20180327070658.13064-5-lufq.fnst@cn.fujitsu.com>

--4I8ioX9cc0T2T2rhceOGnlmvz2ByVxDFJ
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2018=E5=B9=B403=E6=9C=8827=E6=97=A5 15:06, Lu Fengqi wrote:
> The function is used to determine whether the subvolume is intact.
>=20
> Signed-off-by: Lu Fengqi <lufq.fnst@cn.fujitsu.com>
> ---
>  Makefile          |  3 ++-
>  undelete-subvol.c | 53 +++++++++++++++++++++++++++++++++++++++++++++++=
++++++
>  undelete-subvol.h | 17 +++++++++++++++++
>  3 files changed, 72 insertions(+), 1 deletion(-)
>  create mode 100644 undelete-subvol.c
>  create mode 100644 undelete-subvol.h
>=20
> diff --git a/Makefile b/Makefile
> index 6065522a615f..cb38984c7386 100644
> --- a/Makefile
> +++ b/Makefile
> @@ -116,7 +116,8 @@ objects =3D ctree.o disk-io.o kernel-lib/radix-tree=
=2Eo extent-tree.o print-tree.o \
>  	  qgroup.o free-space-cache.o kernel-lib/list_sort.o props.o \
>  	  kernel-shared/ulist.o qgroup-verify.o backref.o string-table.o task=
-utils.o \
>  	  inode.o file.o find-root.o free-space-tree.o help.o send-dump.o \
> -	  fsfeatures.o kernel-lib/tables.o kernel-lib/raid56.o transaction.o
> +	  fsfeatures.o kernel-lib/tables.o kernel-lib/raid56.o transaction.o =
\
> +	  undelete-subvol.o
>  cmds_objects =3D cmds-subvolume.o cmds-filesystem.o cmds-device.o cmds=
-scrub.o \
>  	       cmds-inspect.o cmds-balance.o cmds-send.o cmds-receive.o \
>  	       cmds-quota.o cmds-qgroup.o cmds-replace.o check/main.o \
> diff --git a/undelete-subvol.c b/undelete-subvol.c
> new file mode 100644
> index 000000000000..00fcc4895778
> --- /dev/null
> +++ b/undelete-subvol.c
> @@ -0,0 +1,53 @@
> +/*
> + * Copyright (C) 2018 Fujitsu.  All rights reserved.

IIRC David will remove all such copy right line.
Is there some principle about this, David?

> + *
> + * This program is free software; you can redistribute it and/or
> + * modify it under the terms of the GNU General Public
> + * License v2 as published by the Free Software Foundation.
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
> + * General Public License for more details.
> + */
> +
> +#include "ctree.h"
> +
> +/*
> + * Determines whether the subvolume is intact, according to the drop_p=
rogress
> + * of the root item specified by subvol_id.
> + *
> + * Return true if the subvolume is intact, otherwise return false.
> + */
> +static bool is_subvol_intact(struct btrfs_root *root, u64 subvol_id)

Here we have 2 parameters which can represent a root, so please explain
the meaning of each parameter.

And after looking into the code, @root should be tree root, and in that
case, I prefer passing @fs_info here to get rid of any confusion.

> +{
> +	struct btrfs_path path;
> +	struct btrfs_key key;
> +	struct extent_buffer *leaf;
> +	struct btrfs_root_item root_item;
> +	u64 offset;
> +	int ret;
> +
> +	key.objectid =3D subvol_id;
> +	key.type =3D BTRFS_ROOT_ITEM_KEY;
> +	key.offset =3D 0;
> +
> +	btrfs_init_path(&path);
> +	ret =3D btrfs_search_slot(NULL, root, &key, &path, 0, 0);

Instead of setting up keys and search manually, what about using
btrfs_read_fs_root()?

> +	if (ret) {
> +		ret =3D false;
> +		goto out;
> +	}
> +
> +	leaf =3D path.nodes[0];
> +	offset =3D btrfs_item_ptr_offset(leaf, path.slots[0]);
> +
> +	read_extent_buffer(leaf, &root_item, offset, sizeof(root_item));
> +
> +	/* the subvolume is intact if the objectid of drop_progress =3D=3D 0 =
*/
> +	ret =3D btrfs_disk_key_objectid(&root_item.drop_progress) ? false : t=
rue;
> +
> +out:
> +	btrfs_release_path(&path);
> +	return ret;
> +}
> diff --git a/undelete-subvol.h b/undelete-subvol.h
> new file mode 100644
> index 000000000000..7cfd100cce37
> --- /dev/null
> +++ b/undelete-subvol.h
> @@ -0,0 +1,17 @@
> +/*
> + * Copyright (C) 2018 Fujitsu.  All rights reserved.
> + *
> + * This program is free software; you can redistribute it and/or
> + * modify it under the terms of the GNU General Public
> + * License v2 as published by the Free Software Foundation.
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
> + * General Public License for more details.
> + */
> +
> +#ifndef __BTRFS_UNDELETE_SUBVOLUME_H__
I think the empty header is not really needed here.
What about introducing it when we have something here?

Thanks,
Qu

> +#define __BTRFS_UNDELETE_SUBVOLUME_H__
> +
> +#endif
>=20


--4I8ioX9cc0T2T2rhceOGnlmvz2ByVxDFJ--

--DurMcTYTkAk6EvPP64l3TA4bckWCO8KI4
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEELd9y5aWlW6idqkLhwj2R86El/qgFAlrW06oACgkQwj2R86El
/qjR1AgAm5i2qcsJK2z1267j7IO7JAm+XPTfwXf5UYgTSwc0yqaKgqr3mZuAo59A
jRvYjPsoZ1FBkwgQOiF5RMsD4TLaBVAVoWJlK1J5tzElEneQxWa9h8jqBEDY/Fuk
W1BNYHGsgOa+BvAZi492b4ZZ3eTEoaQ2YHGQymlSi5oug5nTCXBXkZl+riGPjC4W
YSF2ApTWVosPnhl4VmLXvmWBydmVsWvWM3PAIDUU0rnYm86aCyImtptUMyY5wX5H
61sltIkwW20IQ15OXD+XIygEdkHg7U5eCQ8lOX4gccFXM/zd6SKWh1B5dkk5Fh8W
ytz2Dj11OXGURpVYuHW3SNE+VuYGtA==
=k1yn
-----END PGP SIGNATURE-----

--DurMcTYTkAk6EvPP64l3TA4bckWCO8KI4--
