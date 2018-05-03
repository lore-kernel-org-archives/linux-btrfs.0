Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.18]:55505 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751774AbeECFSL (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 3 May 2018 01:18:11 -0400
Subject: Re: [PATCH 01/20] btrfs-progs: quota: Add -W option to rescan to wait
 without starting rescan
To: jeffm@suse.com, linux-btrfs@vger.kernel.org
References: <20180308024047.10104-1-jeffm@suse.com>
 <20180308024047.10104-2-jeffm@suse.com>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <10d603cd-7727-c3e2-e138-c1c18e5e0f23@gmx.com>
Date: Thu, 3 May 2018 13:17:58 +0800
MIME-Version: 1.0
In-Reply-To: <20180308024047.10104-2-jeffm@suse.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="MeJX0MjT53r6XXWwBSgy1yPxfeKnE2kD1"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--MeJX0MjT53r6XXWwBSgy1yPxfeKnE2kD1
Content-Type: multipart/mixed; boundary="Vhqp8hVhuzcENI1VZLnUIZdvhXkzYlkaU";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: jeffm@suse.com, linux-btrfs@vger.kernel.org
Message-ID: <10d603cd-7727-c3e2-e138-c1c18e5e0f23@gmx.com>
Subject: Re: [PATCH 01/20] btrfs-progs: quota: Add -W option to rescan to wait
 without starting rescan
References: <20180308024047.10104-1-jeffm@suse.com>
 <20180308024047.10104-2-jeffm@suse.com>
In-Reply-To: <20180308024047.10104-2-jeffm@suse.com>

--Vhqp8hVhuzcENI1VZLnUIZdvhXkzYlkaU
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

Gentle ping.

This patch can be applied independently and is pretty critical to expose
rescan and transaction race.

It would be quite an important part for crafting test case.

Thanks,
Qu

On 2018=E5=B9=B403=E6=9C=8808=E6=97=A5 10:40, jeffm@suse.com wrote:
> From: Jeff Mahoney <jeffm@suse.com>
>=20
> This patch adds a new -W option to wait for a rescan without starting a=

> new operation.  This is useful for things like xfstests where we want
> do to do a "btrfs quota enable" and not continue until the subsequent
> rescan has finished.
>=20
> In addition to documenting the new option in the man page, I've cleaned=

> up the rescan entry to document the -w option a bit better.
>=20
> Reviewed-by: Qu Wenruo <wqu@suse.com>
> Signed-off-by: Jeff Mahoney <jeffm@suse.com>
> ---
>  Documentation/btrfs-quota.asciidoc | 10 +++++++---
>  cmds-quota.c                       | 20 ++++++++++++++------
>  2 files changed, 21 insertions(+), 9 deletions(-)
>=20
> diff --git a/Documentation/btrfs-quota.asciidoc b/Documentation/btrfs-q=
uota.asciidoc
> index 85ebf729..0b64a69b 100644
> --- a/Documentation/btrfs-quota.asciidoc
> +++ b/Documentation/btrfs-quota.asciidoc
> @@ -238,15 +238,19 @@ Disable subvolume quota support for a filesystem.=

>  *enable* <path>::
>  Enable subvolume quota support for a filesystem.
> =20
> -*rescan* [-s] <path>::
> +*rescan* [-s|-w|-W] <path>::
>  Trash all qgroup numbers and scan the metadata again with the current =
config.
>  +
>  `Options`
>  +
>  -s::::
> -show status of a running rescan operation.
> +Show status of a running rescan operation.
> +
>  -w::::
> -wait for rescan operation to finish(can be already in progress).
> +Start rescan operation and wait until it has finished before exiting. =
 If a rescan is already running, wait until it finishes and then exit wit=
hout starting a new one.
> +
> +-W::::
> +Wait for rescan operation to finish and then exit.  If a rescan is not=
 already running, exit silently.
> =20
>  EXIT STATUS
>  -----------
> diff --git a/cmds-quota.c b/cmds-quota.c
> index 745889d1..7f933495 100644
> --- a/cmds-quota.c
> +++ b/cmds-quota.c
> @@ -120,14 +120,20 @@ static int cmd_quota_rescan(int argc, char **argv=
)
>  	int wait_for_completion =3D 0;
> =20
>  	while (1) {
> -		int c =3D getopt(argc, argv, "sw");
> +		int c =3D getopt(argc, argv, "swW");
>  		if (c < 0)
>  			break;
>  		switch (c) {
>  		case 's':
>  			ioctlnum =3D BTRFS_IOC_QUOTA_RESCAN_STATUS;
>  			break;
> +		case 'W':
> +			ioctlnum =3D 0;
> +			wait_for_completion =3D 1;
> +			break;
>  		case 'w':
> +			/* Reset it in case the user did both -W and -w */
> +			ioctlnum =3D BTRFS_IOC_QUOTA_RESCAN;
>  			wait_for_completion =3D 1;
>  			break;
>  		default:
> @@ -135,8 +141,8 @@ static int cmd_quota_rescan(int argc, char **argv)
>  		}
>  	}
> =20
> -	if (ioctlnum !=3D BTRFS_IOC_QUOTA_RESCAN && wait_for_completion) {
> -		error("switch -w cannot be used with -s");
> +	if (ioctlnum =3D=3D BTRFS_IOC_QUOTA_RESCAN_STATUS && wait_for_complet=
ion) {
> +		error("switches -w/-W cannot be used with -s");
>  		return 1;
>  	}
> =20
> @@ -150,8 +156,10 @@ static int cmd_quota_rescan(int argc, char **argv)=

>  	if (fd < 0)
>  		return 1;
> =20
> -	ret =3D ioctl(fd, ioctlnum, &args);
> -	e =3D errno;
> +	if (ioctlnum) {
> +		ret =3D ioctl(fd, ioctlnum, &args);
> +		e =3D errno;
> +	}
> =20
>  	if (ioctlnum =3D=3D BTRFS_IOC_QUOTA_RESCAN_STATUS) {
>  		close_file_or_dir(fd, dirstream);
> @@ -167,7 +175,7 @@ static int cmd_quota_rescan(int argc, char **argv)
>  		return 0;
>  	}
> =20
> -	if (ret =3D=3D 0) {
> +	if (ioctlnum =3D=3D BTRFS_IOC_QUOTA_RESCAN && ret =3D=3D 0) {
>  		printf("quota rescan started\n");
>  		fflush(stdout);
>  	} else if (ret < 0 && (!wait_for_completion || e !=3D EINPROGRESS)) {=

>=20


--Vhqp8hVhuzcENI1VZLnUIZdvhXkzYlkaU--

--MeJX0MjT53r6XXWwBSgy1yPxfeKnE2kD1
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEELd9y5aWlW6idqkLhwj2R86El/qgFAlrqm4YACgkQwj2R86El
/qjhwAf+M6XvVnffMfn8bnJHyjdgns7kJ6J4SfukrGhpulz1UILWu6QgMMBFmEN3
o4+q/pORqDC9jWODH4xiRuH50Jcv2zNp2/f2J5rvP89Inn7t9GGAlGxn8a4ugL+V
c/N8+W+xv2ga+abMCWRuBH0ZmB6PjnwOpFo23NOXIebZpWNGYqFoYnza3b8JBVOg
Bg6KEF1nriChKrMva5iMAHqttwyF3UQ18XYHl5gunsnGGZMmqTnzTd6hT0fJHVTl
yJkBvMM/ubpQtQrv9k+wWaCUGEsB2MhH5S3KO39pTw60lbWhnyxxfG83UrOBzAzD
wGTDhOshpdO6+cM8onkozGn3AUmwPA==
=GH6+
-----END PGP SIGNATURE-----

--MeJX0MjT53r6XXWwBSgy1yPxfeKnE2kD1--
