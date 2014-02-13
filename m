Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from luka.romanrm.net ([213.163.64.74]:51773 "EHLO luka.romanrm.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751738AbaBMTXw (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 13 Feb 2014 14:23:52 -0500
Date: Fri, 14 Feb 2014 01:23:43 +0600
From: Roman Mamedov <rm@romanrm.net>
To: kreijack@inwind.it
Cc: kreijack@libero.it, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 7/8] Add btrfs device disk-usage command
Message-ID: <20140214012343.19792fb0@natsu>
In-Reply-To: <52FD1AEC.1020700@libero.it>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/+2i068ms_v_6U3.nZ3qcV2v"; protocol="application/pgp-signature"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>
References: <52FD1AEC.1020700@libero.it>

--Sig_/+2i068ms_v_6U3.nZ3qcV2v
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Thu, 13 Feb 2014 20:20:12 +0100
Goffredo Baroncelli <kreijack@libero.it> wrote:

>=20
> Signed-off-by: Goffredo Baroncelli <kreijack@inwind.it>
> ---
>  cmds-device.c        |   3 ++
>  cmds-fi-disk_usage.c | 136 +++++++++++++++++++++++++++++++++++++++++++++=
++++++
>  cmds-fi-disk_usage.h |   3 ++
>  3 files changed, 142 insertions(+)
>=20
> diff --git a/cmds-device.c b/cmds-device.c
> index bc4a8dc..f25dbfa 100644
> --- a/cmds-device.c
> +++ b/cmds-device.c
> @@ -28,6 +28,7 @@
>  #include "ctree.h"
>  #include "ioctl.h"
>  #include "utils.h"
> +#include "cmds-fi-disk_usage.h"
> =20
>  #include "commands.h"
> =20
> @@ -401,6 +402,8 @@ const struct cmd_group device_cmd_group =3D {
>  		{ "scan", cmd_scan_dev, cmd_scan_dev_usage, NULL, 0 },
>  		{ "ready", cmd_ready_dev, cmd_ready_dev_usage, NULL, 0 },
>  		{ "stats", cmd_dev_stats, cmd_dev_stats_usage, NULL, 0 },
> +		{ "disk-usage", cmd_device_disk_usage,
> +			cmd_device_disk_usage_usage, NULL, 0 },
>  		NULL_CMD_STRUCT

Why not just name it "du"? Think about the current handy feature of shorten=
ing
commands by only specifying parts of the keywords. "btrfs dev du" would seem
more intuitive than calling it as "btrfs dev disk" or "btrfs dev disk-u".

Or simply "usage", because "...device disk..." is redundant, device is alre=
ady
a disk, so it can easily be "btrfs device usage".

--=20
With respect,
Roman

--Sig_/+2i068ms_v_6U3.nZ3qcV2v
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iEYEARECAAYFAlL9G78ACgkQTLKSvz+PZwi6IwCfemSROxoe4EKb05jKiviDNuN7
/P0An0R/b+mz4zExa29X/rH72qudJb/f
=TbMP
-----END PGP SIGNATURE-----

--Sig_/+2i068ms_v_6U3.nZ3qcV2v--
