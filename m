Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.15]:59123 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750951AbeCGGMG (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 7 Mar 2018 01:12:06 -0500
Subject: Re: [PATCH 0/8] btrfs-progs: qgroups usability [corrected]
To: jeffm@suse.com, linux-btrfs@vger.kernel.org
References: <20180302184704.22399-1-jeffm@suse.com>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <d8061f8d-652c-2588-d958-6b92f4b00eef@gmx.com>
Date: Wed, 7 Mar 2018 14:11:56 +0800
MIME-Version: 1.0
In-Reply-To: <20180302184704.22399-1-jeffm@suse.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="8M7ufQFV2ZLi2vh2wyKoJ14sCZGY7ZtnC"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--8M7ufQFV2ZLi2vh2wyKoJ14sCZGY7ZtnC
Content-Type: multipart/mixed; boundary="HZ8bwVn1l0X6MNu9onJn1C1qGMJS08wwU";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: jeffm@suse.com, linux-btrfs@vger.kernel.org
Message-ID: <d8061f8d-652c-2588-d958-6b92f4b00eef@gmx.com>
Subject: Re: [PATCH 0/8] btrfs-progs: qgroups usability [corrected]
References: <20180302184704.22399-1-jeffm@suse.com>
In-Reply-To: <20180302184704.22399-1-jeffm@suse.com>

--HZ8bwVn1l0X6MNu9onJn1C1qGMJS08wwU
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2018=E5=B9=B403=E6=9C=8803=E6=97=A5 02:46, jeffm@suse.com wrote:
> From: Jeff Mahoney <jeffm@suse.com>
>=20
> Hi all -
>=20
> The following series addresses some usability issues with the qgroups U=
I.
>=20
> 1) Adds -W option so we can wait on a rescan completing without startin=
g one.
> 2) Adds qgroup information to 'btrfs subvolume show'
> 3) Adds a -P option to show pathnames for first-level qgroups (or membe=
r
>    of nested qgroups with -v)
> 4) Allows exporting the qgroup table in JSON format for use by external=

>    programs/scripts.
>=20
> -Jeff
>=20
> Jeff Mahoney (8):
>   btrfs-progs: quota: Add -W option to rescan to wait without starting
>     rescan
>   btrfs-progs: qgroups: fix misleading index check
>   btrfs-progs: constify pathnames passed as arguments

For patch 1~3 looks good.

Reviewed-by: Qu Wenruo <wqu@suse.com>

Thanks,
Qu

>   btrfs-progs: qgroups: add pathname to show output
>   btrfs-progs: qgroups: introduce and use info and limit structures
>   btrfs-progs: qgroups: introduce btrfs_qgroup_query
>   btrfs-progs: subvolume: add quota info to btrfs sub show
>   btrfs-progs: qgroups: export qgroups usage information as JSON
>=20
>  Documentation/btrfs-qgroup.asciidoc |   8 +
>  Documentation/btrfs-quota.asciidoc  |  10 +-
>  Makefile.inc.in                     |   4 +-
>  chunk-recover.c                     |   4 +-
>  cmds-device.c                       |   2 +-
>  cmds-fi-usage.c                     |   6 +-
>  cmds-qgroup.c                       |  49 +++-
>  cmds-quota.c                        |  21 +-
>  cmds-rescue.c                       |   4 +-
>  cmds-subvolume.c                    |  46 ++++
>  configure.ac                        |   6 +
>  kerncompat.h                        |   1 +
>  qgroup.c                            | 526 ++++++++++++++++++++++++++++=
++------
>  qgroup.h                            |  22 +-
>  send-utils.c                        |   4 +-
>  utils.c                             |  22 +-
>  utils.h                             |   2 +
>  17 files changed, 621 insertions(+), 116 deletions(-)
>=20


--HZ8bwVn1l0X6MNu9onJn1C1qGMJS08wwU--

--8M7ufQFV2ZLi2vh2wyKoJ14sCZGY7ZtnC
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQFLBAEBCAA1FiEELd9y5aWlW6idqkLhwj2R86El/qgFAlqfgqwXHHF1d2VucnVv
LmJ0cmZzQGdteC5jb20ACgkQwj2R86El/qiA6AgArRjRr2n19dYlpeplKMaCZAZU
Q2XYwd5rXmaPqjvdPzFph9qCauFD19ni0fRQ+d3ea15Gb7d5QO0JupOuzhy+oSwZ
VGZ18zqjdkDA+I2uZ0ABbxWZz5lK+tGOnCGNEOas2wCjQbXFzB15wtIDlG+V6oLj
KcV0FUuGfgFYxnTWxcvLvfirQi074U+caWUDe8MovS5CPDOqLHJFuZLaZwq2f+5m
J40KNbPBgUCHY4bJXNz3B1UDxrLlgWT8BAGWIJ+aSOKaFO6Lm/mGP/OjkLBqZ4yO
uEvDeuHaeD4sPZOMI8pDK1/Qdd1au4xCBrxmDkaA8SzFDgbZdxZRu8vD3m842A==
=3AIT
-----END PGP SIGNATURE-----

--8M7ufQFV2ZLi2vh2wyKoJ14sCZGY7ZtnC--
