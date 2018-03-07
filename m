Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.19]:34125 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751023AbeCGGJN (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 7 Mar 2018 01:09:13 -0500
Subject: Re: [PATCH 7/8] btrfs-progs: subvolume: add quota info to btrfs sub
 show
To: jeffm@suse.com, linux-btrfs@vger.kernel.org
References: <20180302184704.22399-1-jeffm@suse.com>
 <20180302184704.22399-8-jeffm@suse.com>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <51ceaf6c-17e5-734c-478e-38893c9304f7@gmx.com>
Date: Wed, 7 Mar 2018 14:09:02 +0800
MIME-Version: 1.0
In-Reply-To: <20180302184704.22399-8-jeffm@suse.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="ST3gfh7Sko006KzY9aNJxHRdrGZdPweRL"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--ST3gfh7Sko006KzY9aNJxHRdrGZdPweRL
Content-Type: multipart/mixed; boundary="8NBvlZcS1n6w0uqkjtvvHqz2563UJu4Rc";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: jeffm@suse.com, linux-btrfs@vger.kernel.org
Message-ID: <51ceaf6c-17e5-734c-478e-38893c9304f7@gmx.com>
Subject: Re: [PATCH 7/8] btrfs-progs: subvolume: add quota info to btrfs sub
 show
References: <20180302184704.22399-1-jeffm@suse.com>
 <20180302184704.22399-8-jeffm@suse.com>
In-Reply-To: <20180302184704.22399-8-jeffm@suse.com>

--8NBvlZcS1n6w0uqkjtvvHqz2563UJu4Rc
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2018=E5=B9=B403=E6=9C=8803=E6=97=A5 02:47, jeffm@suse.com wrote:
> From: Jeff Mahoney <jeffm@suse.com>
>=20
> This patch reports on the first-level qgroup, if any, associated with
> a particular subvolume.  It displays the usage and limit, subject
> to the usual unit parameters.
>=20
> Signed-off-by: Jeff Mahoney <jeffm@suse.com>
> ---
>  cmds-subvolume.c | 46 ++++++++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 46 insertions(+)
>=20
> diff --git a/cmds-subvolume.c b/cmds-subvolume.c
> index 8a473f7a..29d0e0e5 100644
> --- a/cmds-subvolume.c
> +++ b/cmds-subvolume.c
> @@ -972,6 +972,7 @@ static const char * const cmd_subvol_show_usage[] =3D=
 {
>  	"Show more information about the subvolume",
>  	"-r|--rootid   rootid of the subvolume",
>  	"-u|--uuid     uuid of the subvolume",
> +	HELPINFO_UNITS_SHORT_LONG,
>  	"",
>  	"If no option is specified, <subvol-path> will be shown, otherwise",
>  	"the rootid or uuid are resolved relative to the <mnt> path.",
> @@ -993,6 +994,13 @@ static int cmd_subvol_show(int argc, char **argv)
>  	int by_uuid =3D 0;
>  	u64 rootid_arg;
>  	u8 uuid_arg[BTRFS_UUID_SIZE];
> +	struct btrfs_qgroup_stats stats;
> +	unsigned int unit_mode;
> +	const char *referenced_size;
> +	const char *referenced_limit_size =3D "-";
> +	unsigned field_width =3D 0;
> +
> +	unit_mode =3D get_unit_mode_from_arg(&argc, argv, 1);
> =20
>  	while (1) {
>  		int c;
> @@ -1112,6 +1120,44 @@ static int cmd_subvol_show(int argc, char **argv=
)
>  	btrfs_list_subvols_print(fd, filter_set, NULL, BTRFS_LIST_LAYOUT_RAW,=

>  			1, raw_prefix);
> =20
> +	ret =3D btrfs_qgroup_query(fd, get_ri.root_id, &stats);
> +	if (ret < 0) {
> +		if (ret =3D=3D -ENODATA)
> +			printf("Quotas must be enabled for per-subvolume usage\n");

This seems a little confusing.
If quota is disabled, we get ENOTTY not ENODATA.

For ENODATA we know quota is enabled but just no info for this qgroup.

Thanks,
Qu

> +		else if (ret !=3D -ENOTTY)
> +			fprintf(stderr,
> +				"\nERROR: BTRFS_IOC_QUOTA_QUERY failed: %s\n",
> +				strerror(errno));
> +		goto out;
> +	}
> +
> +	printf("\tQuota Usage:\t\t");
> +	fflush(stdout);
> +
> +	referenced_size =3D pretty_size_mode(stats.info.referenced, unit_mode=
);
> +	if (stats.limit.max_referenced)
> +	       referenced_limit_size =3D pretty_size_mode(
> +						stats.limit.max_referenced,
> +						unit_mode);
> +	field_width =3D max(strlen(referenced_size),
> +			  strlen(referenced_limit_size));
> +
> +	printf("%-*s referenced, %s exclusive\n ", field_width,
> +	       referenced_size,
> +	       pretty_size_mode(stats.info.exclusive, unit_mode));
> +
> +	printf("\tQuota Limits:\t\t");
> +	if (stats.limit.max_referenced || stats.limit.max_exclusive) {
> +		const char *excl =3D "-";
> +
> +		if (stats.limit.max_exclusive)
> +		       excl =3D pretty_size_mode(stats.limit.max_exclusive,
> +					       unit_mode);
> +		printf("%-*s referenced, %s exclusive\n", field_width,
> +		       referenced_limit_size, excl);
> +	} else
> +		printf("None\n");
> +
>  out:
>  	/* clean up */
>  	free(get_ri.path);
>=20


--8NBvlZcS1n6w0uqkjtvvHqz2563UJu4Rc--

--ST3gfh7Sko006KzY9aNJxHRdrGZdPweRL
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQFLBAEBCAA1FiEELd9y5aWlW6idqkLhwj2R86El/qgFAlqfgf4XHHF1d2VucnVv
LmJ0cmZzQGdteC5jb20ACgkQwj2R86El/qgZEggAnG+hEjbI6RgWDVWMeMRVJr8j
pRGfqDvkDvdtpo/evR20g3HJgd+9rAUCAs3raoY6+TTp2CKPYtL3W13t8gd5of/H
J8pVlFF9jEGmmkaEnQhCC9emVaT/5AKrvwJLM9Cn2q7NpDQnSfRJ+Rb0mXBPqSG+
0Wjmo2d6iNKQLtS0hAxXHc729i2h1StzmCvzh8nTbm1uXzTRg4Jhm2qP7omHC+ag
gbnrtMD3qx8OnDTrOseO4mtlMhQSuGi3eqdqphiypV3LNGG+YNza4KRiN4BGcM30
BZ3D3aPkNP2p+n4mw2YhInNGalEaOeLrsyEAorXO5GMnwyrw8pQnwqX9E5zxVQ==
=o5AS
-----END PGP SIGNATURE-----

--ST3gfh7Sko006KzY9aNJxHRdrGZdPweRL--
