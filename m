Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.18]:54894 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752150AbdLGAc4 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 6 Dec 2017 19:32:56 -0500
Subject: Re: [PATCH] btrfs: tree-checker: use %zu format string for size_t
To: Arnd Bergmann <arnd@arndb.de>, Chris Mason <clm@fb.com>,
        Josef Bacik <jbacik@fb.com>, David Sterba <dsterba@suse.com>
Cc: Qu Wenruo <wqu@suse.com>, Su Yue <suy.fnst@cn.fujitsu.com>,
        Nikolay Borisov <nborisov@suse.com>, linux-btrfs@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20171206141844.788362-1-arnd@arndb.de>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <a05374d3-401f-bec3-03f4-45d4072d43f4@gmx.com>
Date: Thu, 7 Dec 2017 08:32:04 +0800
MIME-Version: 1.0
In-Reply-To: <20171206141844.788362-1-arnd@arndb.de>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="WOVne66d7EDv24WRx0t0thDtAeGuHDWk6"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--WOVne66d7EDv24WRx0t0thDtAeGuHDWk6
Content-Type: multipart/mixed; boundary="xh4mvJ0Bkvg2ew2c3FiVpHwoqCN4d204b";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: Arnd Bergmann <arnd@arndb.de>, Chris Mason <clm@fb.com>,
 Josef Bacik <jbacik@fb.com>, David Sterba <dsterba@suse.com>
Cc: Qu Wenruo <wqu@suse.com>, Su Yue <suy.fnst@cn.fujitsu.com>,
 Nikolay Borisov <nborisov@suse.com>, linux-btrfs@vger.kernel.org,
 linux-kernel@vger.kernel.org
Message-ID: <a05374d3-401f-bec3-03f4-45d4072d43f4@gmx.com>
Subject: Re: [PATCH] btrfs: tree-checker: use %zu format string for size_t
References: <20171206141844.788362-1-arnd@arndb.de>
In-Reply-To: <20171206141844.788362-1-arnd@arndb.de>

--xh4mvJ0Bkvg2ew2c3FiVpHwoqCN4d204b
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2017=E5=B9=B412=E6=9C=8806=E6=97=A5 22:18, Arnd Bergmann wrote:
> The return value of sizeof() is of type size_t, so we must print it
> using the %z format modifier rather than %l to avoid this warning
> on some architectures:
>=20
> fs/btrfs/tree-checker.c: In function 'check_dir_item':
> fs/btrfs/tree-checker.c:273:50: error: format '%lu' expects argument of=
 type 'long unsigned int', but argument 5 has type 'u32' {aka 'unsigned i=
nt'} [-Werror=3Dformat=3D]

Any idea about which architecture will cause such warning?
On x86_64 I always fail to get such warning.

>=20
> Fixes: 005887f2e3e0 ("btrfs: tree-checker: Add checker for dir item")

Reviewed-by: Qu Wenruo <wqu@suse.com>

Thanks,
Qu

> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> ---
>  fs/btrfs/tree-checker.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>=20
> diff --git a/fs/btrfs/tree-checker.c b/fs/btrfs/tree-checker.c
> index 66dac0a4b01f..7c55e3ba5a6c 100644
> --- a/fs/btrfs/tree-checker.c
> +++ b/fs/btrfs/tree-checker.c
> @@ -270,7 +270,7 @@ static int check_dir_item(struct btrfs_root *root,
>  		/* header itself should not cross item boundary */
>  		if (cur + sizeof(*di) > item_size) {
>  			dir_item_err(root, leaf, slot,
> -		"dir item header crosses item boundary, have %lu boundary %u",
> +		"dir item header crosses item boundary, have %zu boundary %u",
>  				cur + sizeof(*di), item_size);
>  			return -EUCLEAN;
>  		}
>=20


--xh4mvJ0Bkvg2ew2c3FiVpHwoqCN4d204b--

--WOVne66d7EDv24WRx0t0thDtAeGuHDWk6
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQFLBAEBCAA1FiEELd9y5aWlW6idqkLhwj2R86El/qgFAloojAQXHHF1d2VucnVv
LmJ0cmZzQGdteC5jb20ACgkQwj2R86El/qi6Wwf/Yua2tI7Wky7GbeY+PxTWK2th
TGAB51XihT39TQycGuKyQKp7dJx6LS8hFlX5uJHTnl2NcsewTfM/D3/VunTJLqcf
gCn7D6kOwmTfrkPJB/nqzi2w/nwM5D9eAmWtmnrQtuSzkgOqXafDHK7Z2zKykdEC
r6UZsr6n2FYXK4LgtwU3tw+lT5KbculPL0MMdaSF3cQ7hoUh+oY8YAYiiAHc9TaN
2mYhnOn8UhtyuQu0+VWGLvfpGV/LtyaDlgg4FkWH8vQ2++AibFbHOThqqpkxZSme
TvTJn32NyoQ2l25I2wEJqlBq5XgmTPTk3scVjLdypC8yvpKbdRYhmm4YoaoY+Q==
=0fbR
-----END PGP SIGNATURE-----

--WOVne66d7EDv24WRx0t0thDtAeGuHDWk6--
