Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.21]:60816 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752784AbeAJBau (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 9 Jan 2018 20:30:50 -0500
Subject: Re: [RFC PATCH] btrfs: Fix slight df misreporting when listing mixed
 block groups fs
To: Nikolay Borisov <nborisov@suse.com>, linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz
References: <1515513845-3749-1-git-send-email-nborisov@suse.com>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <b9da1d4e-f32c-d923-1e9c-243f753ffa20@gmx.com>
Date: Wed, 10 Jan 2018 09:30:06 +0800
MIME-Version: 1.0
In-Reply-To: <1515513845-3749-1-git-send-email-nborisov@suse.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="Ugpx4N9bzQP4Tdyb095Z9hmIByfkynqWO"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--Ugpx4N9bzQP4Tdyb095Z9hmIByfkynqWO
Content-Type: multipart/mixed; boundary="6lDLZ6svpJnd87yZ8AoWpXjiJGd2jqIFY";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: Nikolay Borisov <nborisov@suse.com>, linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz
Message-ID: <b9da1d4e-f32c-d923-1e9c-243f753ffa20@gmx.com>
Subject: Re: [RFC PATCH] btrfs: Fix slight df misreporting when listing mixed
 block groups fs
References: <1515513845-3749-1-git-send-email-nborisov@suse.com>
In-Reply-To: <1515513845-3749-1-git-send-email-nborisov@suse.com>

--6lDLZ6svpJnd87yZ8AoWpXjiJGd2jqIFY
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2018=E5=B9=B401=E6=9C=8810=E6=97=A5 00:04, Nikolay Borisov wrote:
> Currently when df (resp. statfs) is executed on a btrfs instance the
> free space is calculated as the freespace of the block groups +
> any unallocated space on the devices, constituting this filesystem.
> There is a catch, however, in that the unallocated space from the
> devices has 1 mb subtracted from each device to closely follow btrfs'
> allocator behavior. This is all good except that when we have a file
> system and the system chunk's allocation profile is single (as is the
> default in mixed mode) it occupies the range 0..4mb and thus implicitly=

> prevents allocation starting in the range 0..1mb. In those cases
> additionally subtracting 1mb during statfs makes us misreport the
> actual free space and this causes generic/015 to fail.
>=20
> Signed-off-by: Nikolay Borisov <nborisov@suse.com>
> ---
> Hello,                                                                 =
        =20
>                                                                        =
        =20
> So with this patch and adding sync to generic/015 (which is a different=
 issue) =20
> I can make generic/015 pass. In any case I think this behavior is corre=
ct      =20
> though frankly I feel it's not really worth it, in the worst case we ar=
e       =20
> underreporting by at most 1mb per device.
>=20
>  fs/btrfs/super.c | 25 +++++++++++++------------
>  1 file changed, 13 insertions(+), 12 deletions(-)
>=20
> diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
> index f33a55272deb..a4dfc9701220 100644
> --- a/fs/btrfs/super.c
> +++ b/fs/btrfs/super.c
> @@ -1925,12 +1925,13 @@ static int btrfs_calc_avail_data_space(struct b=
trfs_fs_info *fs_info,
>  	struct btrfs_device_info *devices_info;
>  	struct btrfs_fs_devices *fs_devices =3D fs_info->fs_devices;
>  	struct btrfs_device *device;
> -	u64 skip_space;
>  	u64 type;
>  	u64 avail_space;
>  	u64 min_stripe_size;
>  	int min_stripes =3D 1, num_stripes =3D 1;
>  	int i =3D 0, nr_devices;
> +	bool sys_chunk_single =3D !(btrfs_system_alloc_profile(fs_info) &
> +				  ~BTRFS_BLOCK_GROUP_SYSTEM);
> =20
>  	/*
>  	 * We aren't under the device list lock, so this is racy-ish, but goo=
d
> @@ -1988,18 +1989,18 @@ static int btrfs_calc_avail_data_space(struct b=
trfs_fs_info *fs_info,
>  		/*
>  		 * In order to avoid overwriting the superblock on the drive,
>  		 * btrfs starts at an offset of at least 1MB when doing chunk
> -		 * allocation.
> +		 * allocation. There is one notable exception, and that is
> +		 * when the System chunk has allocation profile of single. In
> +		 * this case it occupies 0..4m  and we don't really need to
> +		 * subtract 1mb as it's implied

This is in fact a bug in mkfs.btrfs.

The problem is, current chunk allocator in mkfs.btrfs doesn't really
avoid the first 1M.

So temporary (profile SINGLE) chunks can still using that reserved 1M,
while normally such chunks get removed so reserved 1M will not be used,
but if we specified -m single, such chunks will just be used as is.

And such behavior makes unallocated space calculation pretty nasty.

>  		 */
> -		skip_space =3D SZ_1M;
> -
> -		/*
> -		 * we can use the free space in [0, skip_space - 1], subtract
> -		 * it from the total.
> -		 */
> -		if (avail_space && avail_space >=3D skip_space)
> -			avail_space -=3D skip_space;
> -		else
> -			avail_space =3D 0;
> +		if (device->devid !=3D 1 ||
> +		    (!sys_chunk_single && device->devid =3D=3D 1)) {
> +			if (avail_space && avail_space >=3D SZ_1M)
> +				avail_space -=3D SZ_1M;
> +			else
> +				avail_space =3D 0;
> +		}

Due to above reason, using system chunk profile and devid to check if we
need to reduce 1M is not reliable.

That system chunk can be relocated by balance, and in that case new
chunk may start beyond 1M.

So the most reliable method would be manually checking the the first
device extent of this device, and to determine if we should minus that 1M=
=2E

If the first device extent starts beyond 1M, reducing 1M would be good.
Or don't modify it.

Thanks,
Qu

> =20
>  		if (avail_space < min_stripe_size)
>  			continue;
>=20


--6lDLZ6svpJnd87yZ8AoWpXjiJGd2jqIFY--

--Ugpx4N9bzQP4Tdyb095Z9hmIByfkynqWO
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQFLBAEBCAA1FiEELd9y5aWlW6idqkLhwj2R86El/qgFAlpVbJ4XHHF1d2VucnVv
LmJ0cmZzQGdteC5jb20ACgkQwj2R86El/qheMwf+JDrq/ZyCtOYY+VMuCM3uquHr
NEVMMEZk1o8v75btRpNipiFiE9DaXpTIzn5FJzSdgW1D1TvFOzYOGgKuJAG977RM
5YMCk/Vg/gGkX6OiZViu1zQ9UoH8pO227ngXSPltNHAChsr76v/b4jL1tvqqkauw
PqtGoXi/z9HAYiiM06oFKlXARuwL1B2ldJWtA6sUl4hINUYNNFl9hjlU4g3CE+zY
rdL+HJN5EDnfiPRdVY514XU1PJgZ227hAAvZonn7HHLbabmJwzeLQce0P4iuaa9j
42dRlDwXN0u0bt+FR+At81AFFlsOLNZyuXgk3kCQgMF1ccbqHoDRADWe3ZrI4Q==
=ui+X
-----END PGP SIGNATURE-----

--Ugpx4N9bzQP4Tdyb095Z9hmIByfkynqWO--
