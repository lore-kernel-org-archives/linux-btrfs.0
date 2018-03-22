Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.20]:36735 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1755317AbeCVNez (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 22 Mar 2018 09:34:55 -0400
Subject: Re: [PATCH 2/3] btrfs-progs: Remove deprecated btrfs-show-super
To: Nikolay Borisov <nborisov@suse.com>, linux-btrfs@vger.kernel.org
References: <1521724707-19180-1-git-send-email-nborisov@suse.com>
 <1521724707-19180-2-git-send-email-nborisov@suse.com>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <c1542132-6cff-0184-82b4-90580d78511e@gmx.com>
Date: Thu, 22 Mar 2018 21:34:43 +0800
MIME-Version: 1.0
In-Reply-To: <1521724707-19180-2-git-send-email-nborisov@suse.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="UAZ40Y6vd8WbSlr78C5F1QRxH3maarrJa"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--UAZ40Y6vd8WbSlr78C5F1QRxH3maarrJa
Content-Type: multipart/mixed; boundary="lvjGEQnASyAmBseHfMmjSg5YzfaxXpZi4";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: Nikolay Borisov <nborisov@suse.com>, linux-btrfs@vger.kernel.org
Message-ID: <c1542132-6cff-0184-82b4-90580d78511e@gmx.com>
Subject: Re: [PATCH 2/3] btrfs-progs: Remove deprecated btrfs-show-super
References: <1521724707-19180-1-git-send-email-nborisov@suse.com>
 <1521724707-19180-2-git-send-email-nborisov@suse.com>
In-Reply-To: <1521724707-19180-2-git-send-email-nborisov@suse.com>

--lvjGEQnASyAmBseHfMmjSg5YzfaxXpZi4
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2018=E5=B9=B403=E6=9C=8822=E6=97=A5 21:18, Nikolay Borisov wrote:
> Its function has been superseded by btrfs inspect-internal show-super.
> Furthermore the tools is currently not built by default. Just remove
> it.

Same missing sob tag.

> ---
>  Makefile           |  2 +-
>  btrfs-show-super.c | 39 ---------------------------------------

And it would be better to update
Documentation/btrfs-select-super.asciidoc which refers to this
deprecated tool.

Thanks,
Qu

>  2 files changed, 1 insertion(+), 40 deletions(-)
>  delete mode 100644 btrfs-show-super.c
>=20
> diff --git a/Makefile b/Makefile
> index 2a2a76855a26..087289b756ef 100644
> --- a/Makefile
> +++ b/Makefile
> @@ -215,7 +215,7 @@ progs_install =3D btrfs mkfs.btrfs btrfs-map-logica=
l btrfs-image \
>  	btrfs-select-super
> =20
>  # other tools, not built by default
> -progs_extra =3D btrfs-fragments btrfs-calc-size btrfs-show-super
> +progs_extra =3D btrfs-fragments btrfs-calc-size
> =20
>  progs_static =3D $(foreach p,$(progs),$(p).static)
> =20
> diff --git a/btrfs-show-super.c b/btrfs-show-super.c
> deleted file mode 100644
> index 4273e42dca3d..000000000000
> --- a/btrfs-show-super.c
> +++ /dev/null
> @@ -1,39 +0,0 @@
> -/*
> - * Copyright (C) 2012 STRATO AG.  All rights reserved.
> - *
> - * This program is free software; you can redistribute it and/or
> - * modify it under the terms of the GNU General Public
> - * License v2 as published by the Free Software Foundation.
> - *
> - * This program is distributed in the hope that it will be useful,
> - * but WITHOUT ANY WARRANTY; without even the implied warranty of
> - * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
> - * General Public License for more details.
> - *
> - * You should have received a copy of the GNU General Public
> - * License along with this program; if not, write to the
> - * Free Software Foundation, Inc., 59 Temple Place - Suite 330,
> - * Boston, MA 021110-1307, USA.
> - */
> -
> -#include "utils.h"
> -#include "commands.h"
> -#include "help.h"
> -
> -int main(int argc, char **argv)
> -{
> -
> -	int ret;
> -
> -	set_argv0(argv);
> -
> -	warning(
> -"\nthe tool has been deprecated, please use 'btrfs inspect-internal du=
mp-super' instead\n");
> -
> -	if (argc > 1 && !strcmp(argv[1], "--help"))
> -		usage(cmd_inspect_dump_super_usage);
> -
> -	ret =3D cmd_inspect_dump_super(argc, argv);
> -
> -	return ret;
> -}
>=20


--lvjGEQnASyAmBseHfMmjSg5YzfaxXpZi4--

--UAZ40Y6vd8WbSlr78C5F1QRxH3maarrJa
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQFLBAEBCAA1FiEELd9y5aWlW6idqkLhwj2R86El/qgFAlqzsPMXHHF1d2VucnVv
LmJ0cmZzQGdteC5jb20ACgkQwj2R86El/qhQvQgAiBKLp6lwBn4S/03LF8psF48F
hq/V45sFbyFVpdr02nrE8S/IZLq13+f+ut+oWHBfDltl48FQfeNGDnPBnngXMSPI
wtq8yewGJQBgw7mTRE7ZBVGX2qHtCZ0MO21UkMY6W9upUcp1zgBepJVSKCz6Pg90
JRRP7GhLB1YCQlAMIpC83SavYMjVrVhX02l8aKhEmg2Dj+rx6Bi2asXvig9IPCe0
o1NiVCma7uF0ggew4pN9Ffh8PWvYvBDO6sdLBmmt50ibhzJPfT+7sZmQjo+qB+MG
8/MIdDnA28dE7RC1XmMmoj9tgrvVOfJUe99hNA1NPnxDD8j8FoyDFdErsQRIhg==
=5il6
-----END PGP SIGNATURE-----

--UAZ40Y6vd8WbSlr78C5F1QRxH3maarrJa--
