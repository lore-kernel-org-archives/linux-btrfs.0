Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.22]:35909 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752864AbeDRF2a (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 18 Apr 2018 01:28:30 -0400
Subject: Re: [PATCH v2 07/10] btrfs-progs: undelete-subvol: introduce
 btrfs_undelete_intact_subvols
To: Lu Fengqi <lufq.fnst@cn.fujitsu.com>, linux-btrfs@vger.kernel.org
References: <20180327070658.13064-1-lufq.fnst@cn.fujitsu.com>
 <20180327070658.13064-8-lufq.fnst@cn.fujitsu.com>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <75e88792-55d8-93ea-f7cf-489c4410a16e@gmx.com>
Date: Wed, 18 Apr 2018 13:28:23 +0800
MIME-Version: 1.0
In-Reply-To: <20180327070658.13064-8-lufq.fnst@cn.fujitsu.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="F5e7zcgTu3DfkUdEIlrkXNCbjWBnxNL2a"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--F5e7zcgTu3DfkUdEIlrkXNCbjWBnxNL2a
Content-Type: multipart/mixed; boundary="XIuAFKdnAWK6jbTy4gWe21qgSiUKpPJv9";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: Lu Fengqi <lufq.fnst@cn.fujitsu.com>, linux-btrfs@vger.kernel.org
Message-ID: <75e88792-55d8-93ea-f7cf-489c4410a16e@gmx.com>
Subject: Re: [PATCH v2 07/10] btrfs-progs: undelete-subvol: introduce
 btrfs_undelete_intact_subvols
References: <20180327070658.13064-1-lufq.fnst@cn.fujitsu.com>
 <20180327070658.13064-8-lufq.fnst@cn.fujitsu.com>
In-Reply-To: <20180327070658.13064-8-lufq.fnst@cn.fujitsu.com>

--XIuAFKdnAWK6jbTy4gWe21qgSiUKpPJv9
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2018=E5=B9=B403=E6=9C=8827=E6=97=A5 15:06, Lu Fengqi wrote:
> The function default will traverse the all orphan items on the tree roo=
t,
> and recover the all intact subvolumes. If subvol_id is specified, then =
only
> the corresponding subvolume will be recovered.
>=20
> Signed-off-by: Lu Fengqi <lufq.fnst@cn.fujitsu.com>
> ---
> v2: add subvol_id argumenta to specify subvol_id instead of recovering
> all subvolumes.
>=20
>  undelete-subvol.c | 70 +++++++++++++++++++++++++++++++++++++++++++++++=
++++++++
>  undelete-subvol.h |  2 ++
>  2 files changed, 72 insertions(+)
>=20
> diff --git a/undelete-subvol.c b/undelete-subvol.c
> index 9243e35545c5..5b494ca086ab 100644
> --- a/undelete-subvol.c
> +++ b/undelete-subvol.c
> @@ -15,6 +15,7 @@
>  #include "transaction.h"
>  #include "disk-io.h"
>  #include "messages.h"
> +#include "undelete-subvol.h"
> =20
>  /*
>   * Determines whether the subvolume is intact, according to the drop_p=
rogress
> @@ -182,3 +183,72 @@ static int link_subvol_to_lostfound(struct btrfs_r=
oot *root, u64 subvol_id)
>  out:
>  	return ret;
>  }
> +
> +/*
> + * Traverse all orphan items on the root tree, restore them to the los=
t+found
> + * directory if the corresponding subvolumes are still intact left on =
the disk.
> + *
> + * @root	the root of the root tree.

Same comment here.

> + * @subvol_id	if not set to 0, skip other subvolumes and only recover =
the
> + *		subvolume specified by @subvol_id.
> + *
> + * Return 0 if no error occurred even if no subvolume was recovered.
> + */
> +int btrfs_undelete_intact_subvols(struct btrfs_root *root, u64 subvol_=
id)

I prefer to remove the word "_intact".

> +{
> +	struct btrfs_key key;
> +	struct btrfs_path path;
> +	u64 found_count =3D 0;
> +	u64 recovered_count =3D 0;
> +	int ret =3D 0;
> +
> +	key.objectid =3D BTRFS_ORPHAN_OBJECTID;
> +	key.type =3D BTRFS_ORPHAN_ITEM_KEY;
> +	key.offset =3D subvol_id ? subvol_id + 1 : (u64)-1;
> +
> +	btrfs_init_path(&path);

I would prefer to do btrfs_search_slot() here, and then use
btrfs_previous_item() to iterate, other than calling btrfs_search_slot()
several times.

> +	while (subvol_id !=3D key.offset) {
> +		ret =3D btrfs_search_slot(NULL, root, &key, &path, 0, 0);
> +		if (ret < 0) {
> +			error("search ORPHAN_ITEM for %llu failed.\n",
> +			      key.offset);
> +			break;
> +		}
> +
> +		path.slots[0]--;

Btrfs_previous_item() is much better here.

Especially when above btrfs_search_slot() could return 0 (key found) and
path.slots[0] could be 0.
That's also the reason why I prefer btrfs_search_slot() then
btrfs_previous_item() in the loop.

Thanks,
Qu

> +		btrfs_item_key_to_cpu(path.nodes[0], &key, path.slots[0]);
> +
> +		btrfs_release_path(&path);
> +
> +		/* No more BTRFS_ORPHAN_ITEM, so we don't need to continue. */
> +		if (key.type !=3D BTRFS_ORPHAN_ITEM_KEY) {
> +			ret =3D 0;
> +			break;
> +		}
> +
> +		/* If subvol_id is non-zero, skip other deleted subvolume. */
> +		if (subvol_id && subvol_id !=3D key.offset) {
> +			ret =3D -ENOENT;
> +			break;
> +		}
> +
> +		if (!is_subvol_intact(root, key.offset))
> +			continue;
> +
> +		/* Here we can confirm there is an intact subvolume. */
> +		found_count++;
> +		ret =3D link_subvol_to_lostfound(root, key.offset);
> +		if (ret =3D=3D 0) {
> +			recovered_count++;
> +			printf(
> +		"Recovered subvolume %llu to lost+found successfully.\n",
> +				key.offset);
> +		}
> +
> +	}
> +
> +	printf("Found %llu subvols left intact\n", found_count);
> +	printf("Recovered %llu subvols\n", found_count);
> +
> +	return ret;
> +}
> diff --git a/undelete-subvol.h b/undelete-subvol.h
> index 7cfd100cce37..f773210c46fe 100644
> --- a/undelete-subvol.h
> +++ b/undelete-subvol.h
> @@ -14,4 +14,6 @@
>  #ifndef __BTRFS_UNDELETE_SUBVOLUME_H__
>  #define __BTRFS_UNDELETE_SUBVOLUME_H__
> =20
> +int btrfs_undelete_intact_subvols(struct btrfs_root *root, u64 subvol_=
id);
> +
>  #endif
>=20


--XIuAFKdnAWK6jbTy4gWe21qgSiUKpPJv9--

--F5e7zcgTu3DfkUdEIlrkXNCbjWBnxNL2a
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEELd9y5aWlW6idqkLhwj2R86El/qgFAlrW13cACgkQwj2R86El
/qhohgf/WEfAvywcnG4S91JSeXsod2GhaTQQ/K6NdNzC/zLxRJ9xWDAMhALAgmlh
FtOvXNY3xgC99Ntc3Q/Hz0n/2TrzTRrx1qeTtEdkfeNtQE58MCc1yW/o80hEAbSq
IQMr1/t2xhSFWV8rsWmA8v4JLAZ2wECtT5RJOGyy6lC+1SwHczPcnYTWIrZi3MaS
STflWR6pMPSloROqt4K2am97JqSR7fDH+QXQX3JYUm44x9932Pre2GQjZAGMG9XJ
DrmW85hPAmCL6ZVS/JNBuwhT5QiHXxij9ZLb1rvrMRzBkMLLOatRe2xMiSgldX4p
OLZoRMe2uNAfcZgld0SzVTONnX0duQ==
=rE8j
-----END PGP SIGNATURE-----

--F5e7zcgTu3DfkUdEIlrkXNCbjWBnxNL2a--
