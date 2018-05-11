Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:44685 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751164AbeEKRIb (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 11 May 2018 13:08:31 -0400
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id A81C0AFD9
        for <linux-btrfs@vger.kernel.org>; Fri, 11 May 2018 17:08:29 +0000 (UTC)
Subject: Re: [PATCH] btrfs: qgroup: Search commit root for rescan to avoid
 missing extent
To: Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org
References: <20180503072052.22002-1-wqu@suse.com>
From: Jeff Mahoney <jeffm@suse.com>
Message-ID: <45b3b2f9-2133-bbb6-0806-6582c2cd64cd@suse.com>
Date: Fri, 11 May 2018 13:08:27 -0400
MIME-Version: 1.0
In-Reply-To: <20180503072052.22002-1-wqu@suse.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="Zn6acPSGeotCMRrAyHcmNRgXxAobLVHvl"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--Zn6acPSGeotCMRrAyHcmNRgXxAobLVHvl
Content-Type: multipart/mixed; boundary="xfn1FKUg7OppkrAhNVBPc0ULNExiM3q4o";
 protected-headers="v1"
From: Jeff Mahoney <jeffm@suse.com>
To: Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org
Message-ID: <45b3b2f9-2133-bbb6-0806-6582c2cd64cd@suse.com>
Subject: Re: [PATCH] btrfs: qgroup: Search commit root for rescan to avoid
 missing extent
References: <20180503072052.22002-1-wqu@suse.com>
In-Reply-To: <20180503072052.22002-1-wqu@suse.com>

--xfn1FKUg7OppkrAhNVBPc0ULNExiM3q4o
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

On 5/3/18 3:20 AM, Qu Wenruo wrote:
> When doing qgroup rescan using the following script (modified from
> btrfs/017 test case), we can sometimes hit qgroup corruption.
>=20
> ------
> umount $dev &> /dev/null
> umount $mnt &> /dev/null
>=20
> mkfs.btrfs -f -n 64k $dev
> mount $dev $mnt
>=20
> extent_size=3D8192
>=20
> xfs_io -f -d -c "pwrite 0 $extent_size" $mnt/foo > /dev/null
> btrfs subvolume snapshot $mnt $mnt/snap
>=20
> xfs_io -f -c "reflink $mnt/foo" $mnt/foo-reflink > /dev/null
> xfs_io -f -c "reflink $mnt/foo" $mnt/snap/foo-reflink > /dev/null
> xfs_io -f -c "reflink $mnt/foo" $mnt/snap/foo-reflink2 > /dev/unll
> btrfs quota enable $mnt
>=20
>  # -W is the new option to only wait rescan while not starting new one
> btrfs quota rescan -W $mnt
> btrfs qgroup show -prce $mnt
>=20
>  # Need to patch btrfs-progs to report qgroup mismatch as error
> btrfs check $dev || _fail
> ------
>=20
> For fast machine, we can hit some corruption which missed accounting
> tree blocks:
> ------
> qgroupid         rfer         excl     max_rfer     max_excl parent  ch=
ild
> --------         ----         ----     --------     -------- ------  --=
---
> 0/5           8.00KiB        0.00B         none         none ---     --=
-
> 0/257         8.00KiB        0.00B         none         none ---     --=
-
> ------
>=20
> This is due to the fact that we're always searching commit root for
> btrfs_find_all_roots() at qgroup_rescan_leaf(), but the leaf we get is
> from current transaction, not commit root.
>=20
> And if our tree blocks get modified in current transaction, we won't
> find any owner in commit root, thus causing the corruption.
>=20
> Fix it by searching commit root for extent tree for
> qgroup_rescan_leaf().
>=20
> Reported-by: Nikolay Borisov <nborisov@suse.com>
> Signed-off-by: Qu Wenruo <wqu@suse.com>
> ---
>=20
> Please keep in mind that it is possible to hit another type of race
> which double accounting tree blocks:
> ------
> qgroupid         rfer         excl     max_rfer     max_excl parent  ch=
ild
> --------         ----         ----     --------     -------- ------  --=
---
> 0/5          136.00KiB     128.00KiB         none         none ---     =
---
> 0/257        136.00KiB     128.00KiB         none         none ---     =
---
> ------
> For this type of corruption, this patch could reduce the possibility,
> but the root cause is race between transaction commit and qgroup rescan=
,
> which needs to be addressed in another patch.
> ---
>  fs/btrfs/qgroup.c | 5 +++++
>  1 file changed, 5 insertions(+)
>=20
> diff --git a/fs/btrfs/qgroup.c b/fs/btrfs/qgroup.c
> index 4baa4ba2d630..829e8fe5c97e 100644
> --- a/fs/btrfs/qgroup.c
> +++ b/fs/btrfs/qgroup.c
> @@ -2681,6 +2681,11 @@ static void btrfs_qgroup_rescan_worker(struct bt=
rfs_work *work)
>  	path =3D btrfs_alloc_path();
>  	if (!path)
>  		goto out;
> +	/*
> +	 * Rescan should only search for commit root, and any later differenc=
e
> +	 * should be recorded by qgroup
> +	 */
> +	path->search_commit_root =3D 1;
> =20
>  	err =3D 0;
>  	while (!err && !btrfs_fs_closing(fs_info)) {
>=20

If we're searching the commit root here, do we need the tree mod
sequence number dance in qgroup_rescan_leaf anymore?

-Jeff

--=20
Jeff Mahoney
SUSE Labs


--xfn1FKUg7OppkrAhNVBPc0ULNExiM3q4o--

--Zn6acPSGeotCMRrAyHcmNRgXxAobLVHvl
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEE8wzgbmZ74SnKPwtDHntLYyF55bIFAlr1zgsACgkQHntLYyF5
5bIpfBAAst1yrMSosK0pzoRDIHbahjFubNEFrIpwcOCfA0uJQM+2165OPn5iIY3A
oHQqbnB1AgTlfqTQ3szkcMdqVo7ufLuBaClBcsLRpbldzS2S39f9GxAy8zZsd4e5
XXm27UiQ3cFQt5nCuZfnTQbchgqAGrWuNeKJI3rp8sb8sHWg0A0eQVVn0Lle3qhf
fEIJM3rrabaTBKcjyVFmb4vPlhx9dAonb2b/3VE/7zNzm1h/Lz/BgioVnFQDjeeH
qAAl0XtPNascO4QLSoKNz/Q9hDQE42ekNnSh4ZxatWypv7dTvlik8pJGeomnbuOs
ywledv+CZeR6nsehaGDa8weukYVGeYnKawFVV7tFoMrsyer/6ko0lLxjEBjEJRF5
Gl8Di0lb7uwYRdkCu6a773uFRDdB+3qc9JMuoA9BeQrcHNIJbgRxD+SRb+XaI48P
6tbK7Z0THPZGR5T1IBHMCmAciEqUj57D1fYVyGAOGwERymDRhJEhX8X6raLVwo17
V5G0aW5iQUXcLgrbksx6ZOt08gyajuwQEFKxf50gTX3XMS14UOM/3L3Atburvqmg
HGokMV0NXAz53DxZA0l4SBYYUmlQhO0VbpV/Gv6maTWGLCBSeVysSirxLP1kVGmg
oBE5KY9I0sOpsIeMv7RT8uYeeuzZVSC4p75Btzvt46MCWRsUjq8=
=MK4p
-----END PGP SIGNATURE-----

--Zn6acPSGeotCMRrAyHcmNRgXxAobLVHvl--
