Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.15]:53162 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751059AbdLGKAk (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 7 Dec 2017 05:00:40 -0500
Subject: Re: [PATCH v2] btrfs-progs: Replace usage of list_for_each with
 list_for_each_entry
To: Nikolay Borisov <nborisov@suse.com>, linux-btrfs@vger.kernel.org
References: <1512463189-24724-5-git-send-email-nborisov@suse.com>
 <1512637805-11712-1-git-send-email-nborisov@suse.com>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <7662ec44-e047-9136-5919-e787193cb5ca@gmx.com>
Date: Thu, 7 Dec 2017 17:59:58 +0800
MIME-Version: 1.0
In-Reply-To: <1512637805-11712-1-git-send-email-nborisov@suse.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="LJ1plf6Rk7xCAbhMbB0bB6wuQiN65AN04"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--LJ1plf6Rk7xCAbhMbB0bB6wuQiN65AN04
Content-Type: multipart/mixed; boundary="XI3SSNapJ7HLMa2289NiPTxcTlb0uVVj2";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: Nikolay Borisov <nborisov@suse.com>, linux-btrfs@vger.kernel.org
Message-ID: <7662ec44-e047-9136-5919-e787193cb5ca@gmx.com>
Subject: Re: [PATCH v2] btrfs-progs: Replace usage of list_for_each with
 list_for_each_entry
References: <1512463189-24724-5-git-send-email-nborisov@suse.com>
 <1512637805-11712-1-git-send-email-nborisov@suse.com>
In-Reply-To: <1512637805-11712-1-git-send-email-nborisov@suse.com>

--XI3SSNapJ7HLMa2289NiPTxcTlb0uVVj2
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2017=E5=B9=B412=E6=9C=8807=E6=97=A5 17:10, Nikolay Borisov wrote:
> There are a couple of places where instead of the more succinct
> list_for_each_entry the code uses list_for_each. This results in
> slightly more code with no additional benefit as well as no
> coherent pattern. This patch makes the code uniform. No functional
> changes
>=20
> Signed-off-by: Nikolay Borisov <nborisov@suse.com>

Reviewed-by: Qu Wenruo <wqu@suse.com>

Thanks,
Qu

> ---
>  cmds-filesystem.c |  3 +--
>  disk-io.c         |  4 +---
>  utils.c           |  7 +------
>  volumes.c         | 15 ++++-----------
>  4 files changed, 7 insertions(+), 22 deletions(-)
>=20
> diff --git a/cmds-filesystem.c b/cmds-filesystem.c
> index 7728430f16a1..7c154589a15f 100644
> --- a/cmds-filesystem.c
> +++ b/cmds-filesystem.c
> @@ -182,8 +182,7 @@ static int uuid_search(struct btrfs_fs_devices *fs_=
devices, const char *search)
>  	if (!strncmp(uuidbuf, search, search_len))
>  		return 1;
> =20
> -	list_for_each(cur, &fs_devices->devices) {
> -		device =3D list_entry(cur, struct btrfs_device, dev_list);
> +	list_for_each_entry(device, &fs_devices->devices, dev_list) {
>  		if ((device->label && strcmp(device->label, search) =3D=3D 0) ||
>  		    strcmp(device->name, search) =3D=3D 0)
>  			return 1;
> diff --git a/disk-io.c b/disk-io.c
> index f5edc4796619..3d8785d5bb37 100644
> --- a/disk-io.c
> +++ b/disk-io.c
> @@ -1556,7 +1556,6 @@ static int write_dev_supers(struct btrfs_fs_info =
*fs_info,
> =20
>  int write_all_supers(struct btrfs_fs_info *fs_info)
>  {
> -	struct list_head *cur;
>  	struct list_head *head =3D &fs_info->fs_devices->devices;
>  	struct btrfs_device *dev;
>  	struct btrfs_super_block *sb;
> @@ -1566,8 +1565,7 @@ int write_all_supers(struct btrfs_fs_info *fs_inf=
o)
> =20
>  	sb =3D fs_info->super_copy;
>  	dev_item =3D &sb->dev_item;
> -	list_for_each(cur, head) {
> -		dev =3D list_entry(cur, struct btrfs_device, dev_list);
> +	list_for_each_entry(dev, head, dev_list) {
>  		if (!dev->writeable)
>  			continue;
> =20
> diff --git a/utils.c b/utils.c
> index 6c0d9fc1bebf..65383282b512 100644
> --- a/utils.c
> +++ b/utils.c
> @@ -804,14 +804,9 @@ static int blk_file_in_dev_list(struct btrfs_fs_de=
vices* fs_devices,
>  		const char* file)
>  {
>  	int ret;
> -	struct list_head *head;
> -	struct list_head *cur;
>  	struct btrfs_device *device;
> =20
> -	head =3D &fs_devices->devices;
> -	list_for_each(cur, head) {
> -		device =3D list_entry(cur, struct btrfs_device, dev_list);
> -
> +	list_for_each_entry(device, &fs_devices->devices, dev_list) {
>  		if((ret =3D is_same_loop_file(device->name, file)))
>  			return ret;
>  	}
> diff --git a/volumes.c b/volumes.c
> index ce3a540578fd..2e1fb4a46465 100644
> --- a/volumes.c
> +++ b/volumes.c
> @@ -58,10 +58,8 @@ static struct btrfs_device *__find_device(struct lis=
t_head *head, u64 devid,
>  					  u8 *uuid)
>  {
>  	struct btrfs_device *dev;
> -	struct list_head *cur;
> =20
> -	list_for_each(cur, head) {
> -		dev =3D list_entry(cur, struct btrfs_device, dev_list);
> +	list_for_each_entry(dev, head, dev_list) {
>  		if (dev->devid =3D=3D devid &&
>  		    !memcmp(dev->uuid, uuid, BTRFS_UUID_SIZE)) {
>  			return dev;
> @@ -72,11 +70,9 @@ static struct btrfs_device *__find_device(struct lis=
t_head *head, u64 devid,
> =20
>  static struct btrfs_fs_devices *find_fsid(u8 *fsid)
>  {
> -	struct list_head *cur;
>  	struct btrfs_fs_devices *fs_devices;
> =20
> -	list_for_each(cur, &fs_uuids) {
> -		fs_devices =3D list_entry(cur, struct btrfs_fs_devices, list);
> +	list_for_each_entry(fs_devices, &fs_uuids, list) {
>  		if (memcmp(fsid, fs_devices->fsid, BTRFS_FSID_SIZE) =3D=3D 0)
>  			return fs_devices;
>  	}
> @@ -234,13 +230,10 @@ void btrfs_close_all_devices(void)
>  int btrfs_open_devices(struct btrfs_fs_devices *fs_devices, int flags)=

>  {
>  	int fd;
> -	struct list_head *head =3D &fs_devices->devices;
> -	struct list_head *cur;
>  	struct btrfs_device *device;
>  	int ret;
> =20
> -	list_for_each(cur, head) {
> -		device =3D list_entry(cur, struct btrfs_device, dev_list);
> +	list_for_each_entry(device, &fs_devices->devices, dev_list) {
>  		if (!device->name) {
>  			printk("no name for device %llu, skip it now\n", device->devid);
>  			continue;
> @@ -1726,7 +1719,7 @@ int btrfs_check_chunk_valid(struct btrfs_fs_info =
*fs_info,
>  		return -EIO;
>  	}
>  	if (btrfs_chunk_sector_size(leaf, chunk) !=3D sectorsize) {
> -		error("invalid chunk sectorsize %llu",=20
> +		error("invalid chunk sectorsize %llu",
>  		      (unsigned long long)btrfs_chunk_sector_size(leaf, chunk));
>  		return -EIO;
>  	}
>=20


--XI3SSNapJ7HLMa2289NiPTxcTlb0uVVj2--

--LJ1plf6Rk7xCAbhMbB0bB6wuQiN65AN04
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQFLBAEBCAA1FiEELd9y5aWlW6idqkLhwj2R86El/qgFAlopER4XHHF1d2VucnVv
LmJ0cmZzQGdteC5jb20ACgkQwj2R86El/qiTnwf+JF8QeDcwiTan6o7MWXEzg4Xp
tLgSj93dpIOq9xLmJqzuUjBWbP/d3f+GeoMI2PX9hxqPUdt67LmVCQ9+Sk7iYyfb
bgpq1KzyC4cWAWnB7ShpuTEZH5uUt9lAPtUTWzTGZIRi9nVQgFJ8/EirPYuQ3DzD
+ciSfGIpLlEH4+BSaGHTY6tDvejLFmrBb+pE9cQfz4McLYKqfq9jOmb3UfQw3TC9
T4NVnSb1cfRYDwpoiZTXMPh9MJbX3iU+ROoc4VVh+7icma6vsWfj71QVoKIJwF7+
Bf+VA5YzBJFscN7IOSyFSOFIlhexl9tSxRVwMaH+0LubLH2wTHKt6e7fh2S5mQ==
=s7fG
-----END PGP SIGNATURE-----

--LJ1plf6Rk7xCAbhMbB0bB6wuQiN65AN04--
