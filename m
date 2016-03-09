Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:45503 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934210AbcCIV1a (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 9 Mar 2016 16:27:30 -0500
From: NeilBrown <neilb@suse.com>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>, linux-btrfs@vger.kernel.org,
        clm@fb.com
Date: Thu, 10 Mar 2016 08:27:22 +1100
Cc: Wang Xiaoguang <wangxg.fnst@cn.fujitsu.com>
Subject: Re: [PATCH v7 01/20] btrfs: dedup: Introduce dedup framework and its header
In-Reply-To: <1455774178-3595-2-git-send-email-quwenruo@cn.fujitsu.com>
References: <1455774178-3595-1-git-send-email-quwenruo@cn.fujitsu.com> <1455774178-3595-2-git-send-email-quwenruo@cn.fujitsu.com>
Message-ID: <87io0vjq9x.fsf@notabene.neil.brown.name>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha256; protocol="application/pgp-signature"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

--=-=-=
Content-Type: text/plain

On Thu, Feb 18 2016, Qu Wenruo wrote:

> +
> +/*
> + * Dedup storage backend
> + * On disk is persist storage but overhead is large
> + * In memory is fast but will lose all its hash on umount
> + */
> +#define BTRFS_DEDUP_BACKEND_INMEMORY		0
> +#define BTRFS_DEDUP_BACKEND_ONDISK		1
> +#define BTRFS_DEDUP_BACKEND_LAST		2

Hi,

This may seem petty, but I'm here to complain about the names. :-)

Firstly, "2" is *not* the LAST backend.  The LAST backed is clearly
"ONDISK" with is "1:.
"2" is the number of backends, or the count of them.
So
> +#define BTRFS_DEDUP_BACKEND_LAST		1

would be OK, as would

> +#define BTRFS_DEDUP_BACKEND_COUNT		2

but what you have is wrong.

The place where you use this define:

+	if (backend >= BTRFS_DEDUP_BACKEND_LAST)
+		return -EINVAL;

is correct, but it looks wrong.  It looks like it is saying that it is
invalid to use the LAST backend!

Secondly, you use "dup" as an abbreviation of "duplicate".
The ioctl FIDEDUPERANGE and the tool duperemove both use "dupe".
It would be nice if we could be consistent and all use the same
abbreviation.

Thanks,
NeilBrown

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJW4JU6AAoJEDnsnt1WYoG55g4P/3FoXp1IQNXMQkGB/Nf6E1L/
uMav3SJDp33N3XFmhHm66rj8gBhFrf7Mk0MlZZVDrxtO6i0wKvoeURFlKXN5aMKS
0rx7FBVVZPtkpI3yAOjNdPmIZM+5FmBJjZtHwABmYPSBqxV4XEMDgvHt2a5P2zQF
HvXMuAcCaKLYQv4l+1/NTN1J+nQHVAIHk0GKzKcFBQz7QxAYhXxQIKOlpFFG6GGH
TUctA4V3pTObCxpWUpoDW42TakmL9v64YDFuLyErmKZTasP0bUIFbYRgo0rcqCS3
Vl76YvF329kmos+PJGfJ7IQdwD3w9WpVMZK+gcSZ6iyZBM71oSDpBdXgWbynaH+d
pNYy7suC53oal9Tx1ypBlIAZmmeOwZRjD/6v+T24YvWRMXP6/Is3yw4MV84LkbhH
TyQ+EcHiNkQCG/sk+zmXB/e9cksylkaXt8x43y1rZGLmpryVlIMA4bBQiUVrZol9
bvz+M17u2rcubDQYYgNlD261fsQ8hb3I5XIsCIW3gg0/xhQiGHtOcyNuTlSXxt1C
/IQEdkd1hXDfdstEgTMx3B+BIhVsw8CsNSgS5e3zctOZP/siZ8wJItuDIuZRIyvX
vekSq+19Un5WIzHK7ptziMyO7dM7M+dRZbjtq8cWoj/Rlv62y2qame6mub/8XKH5
SyPX/QN+NIwOdvI9h9O6
=Mvli
-----END PGP SIGNATURE-----
--=-=-=--
