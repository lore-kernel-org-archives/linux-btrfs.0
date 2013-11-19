Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:43980 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751599Ab3KSQjv (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 19 Nov 2013 11:39:51 -0500
Message-ID: <528B9434.2090709@suse.com>
Date: Tue, 19 Nov 2013 11:39:16 -0500
From: Jeff Mahoney <jeffm@suse.com>
MIME-Version: 1.0
To: Filipe David Borba Manana <fdmanana@gmail.com>,
        linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] Btrfs: add missing sysfs group remove / fix leak
References: <1384877267-32046-1-git-send-email-fdmanana@gmail.com>
In-Reply-To: <1384877267-32046-1-git-send-email-fdmanana@gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="pTMMsUQM7uAS8WxRGKasQcGLBW8w7vd7m"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--pTMMsUQM7uAS8WxRGKasQcGLBW8w7vd7m
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 11/19/13, 11:07 AM, Filipe David Borba Manana wrote:
> From kmemleak:
>=20
>   hex dump (first 32 bytes):
>     03 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
>     00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
>   backtrace:
>     [<ffffffff8175f5f6>] kmemleak_alloc+0x26/0x50
>     [<ffffffff8118f284>] kmem_cache_alloc+0x114/0x200
>     [<ffffffff81219281>] sysfs_new_dirent+0x51/0x130
>     [<ffffffff812196d2>] create_dir+0x42/0xd0
>     [<ffffffff812199ff>] sysfs_create_subdir+0x1f/0x30
>     [<ffffffff8121b50e>] internal_create_group+0x5e/0x270
>     [<ffffffff8121b753>] sysfs_create_group+0x13/0x20
>     [<ffffffffa069c99e>] btrfs_sysfs_add_one+0x7e/0x280 [btrfs]
>     [<ffffffffa0682792>] open_ctree+0x17d2/0x21f0 [btrfs]
>     [<ffffffffa065883a>] btrfs_mount+0x53a/0x7d0 [btrfs]
>     [<ffffffff811a3ad3>] mount_fs+0x43/0x1b0
>     [<ffffffff811bfa56>] vfs_kern_mount+0x76/0x120
>     [<ffffffff811c1d77>] do_mount+0x237/0xa70
>     [<ffffffff811c2640>] SyS_mount+0x90/0xe0
>     [<ffffffff8177ef12>] system_call_fastpath+0x16/0x1b
>     [<ffffffffffffffff>] 0xffffffffffffffff
> unreferenced object 0xffff8804e37d45b8 (size 160):
>=20

Thanks, Filipe. I thought sysfs cleaned up during kobject_del, but it
skips directories (like groups).

> Signed-off-by: Filipe David Borba Manana <fdmanana@gmail.com>
Signed-off-by: Jeff Mahoney <jeffm@suse.com>

-Jeff

> ---
>  fs/btrfs/sysfs.c |    2 ++
>  1 file changed, 2 insertions(+)
>=20
> diff --git a/fs/btrfs/sysfs.c b/fs/btrfs/sysfs.c
> index 669fdf7..9576771 100644
> --- a/fs/btrfs/sysfs.c
> +++ b/fs/btrfs/sysfs.c
> @@ -424,6 +424,8 @@ void btrfs_sysfs_remove_one(struct btrfs_fs_info *f=
s_info)
>  	kobject_put(fs_info->device_dir_kobj);
>  	kobject_del(fs_info->space_info_kobj);
>  	kobject_put(fs_info->space_info_kobj);
> +	sysfs_remove_group(&fs_info->super_kobj,
> +			   &btrfs_feature_attr_group);
>  	kobject_del(&fs_info->super_kobj);
>  	kobject_put(&fs_info->super_kobj);
>  	wait_for_completion(&fs_info->kobj_unregister);
>=20


--=20
Jeff Mahoney
SUSE Labs


--pTMMsUQM7uAS8WxRGKasQcGLBW8w7vd7m
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG/MacGPG2 v2.0.19 (Darwin)

iQIcBAEBAgAGBQJSi5Q4AAoJEB57S2MheeWyQl4P/ReD0eZd6XtqG8GtwA0NIAGB
+1AEO+7U4wGzBgCXgeqjT9VYobOHggprPnXHlEEOiYvT27HhK1qX3sg+ow8f+Z9F
GzCSjRvUCHURbH9dPqoxgFwh3PzsMtFYoB0fBINqB9bVjSJWGNAz/omr8YQvpb43
7D0ZhQ7jIJF8jLgIQ19AltGSh68GsNX9PzUsJf/VhUOULDTvMJnfYai/kEjSI2Rs
6ZKermBwtqBi6WEafQgb832z5SUtHQQOkUp5CBO9t0yM4wz+NPpPQGfQEwsDO8hs
O5GMjy4a+bvDx4IMm9v3XW7ib7iczODAEUyvTPBrSwTU4C2hmuc7P/vaut7F9Zvj
ImdRScIh4zHZwsw8erHv9S5VRZWoovhmBPtXDIGPyqG2OW7qSEoGVw/ywogIXnve
CDrESybexkKQCs2eciXYLOtIK+N7j/nW0648h8FaY5lZjZ4GGBV6Frg3X3j4Npok
UaNnKP3fEKCqiqDCSdNm8F5w//WLeQOrMrkPryOWgDrypOhzpGP87bVna01NalPx
0xEedmw4DaE9KHZfy4y7yQHpfa6ay0kO4hURTrdxw6DK2SrbPtQdI/abaOJkmOKu
BTzKIwuphNABh74AEUvwP/F0s2cHK/PQSWXKbR2vDO4fRynJ1WlLjlDhkr5KI7h0
zNbLyuYjlxf20Auyqb18
=KZBn
-----END PGP SIGNATURE-----

--pTMMsUQM7uAS8WxRGKasQcGLBW8w7vd7m--
