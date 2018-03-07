Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:48756 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S965162AbeCGUVZ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 7 Mar 2018 15:21:25 -0500
Subject: Re: [PATCH 7/8] btrfs-progs: subvolume: add quota info to btrfs sub
 show
To: Qu Wenruo <quwenruo.btrfs@gmx.com>, linux-btrfs@vger.kernel.org
References: <20180302184704.22399-1-jeffm@suse.com>
 <20180302184704.22399-8-jeffm@suse.com>
 <51ceaf6c-17e5-734c-478e-38893c9304f7@gmx.com>
From: Jeff Mahoney <jeffm@suse.com>
Message-ID: <636ab1e0-e928-29cc-58ec-4d6ec0ad9f0a@suse.com>
Date: Wed, 7 Mar 2018 15:21:20 -0500
MIME-Version: 1.0
In-Reply-To: <51ceaf6c-17e5-734c-478e-38893c9304f7@gmx.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="z0Hb8zDxPuzktKypnwUUmu3LWimfxaKMd"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--z0Hb8zDxPuzktKypnwUUmu3LWimfxaKMd
Content-Type: multipart/mixed; boundary="8g6a3Mb7RgnHtz78x9OJp6V9Vz7I6fTJh";
 protected-headers="v1"
From: Jeff Mahoney <jeffm@suse.com>
To: Qu Wenruo <quwenruo.btrfs@gmx.com>, linux-btrfs@vger.kernel.org
Message-ID: <636ab1e0-e928-29cc-58ec-4d6ec0ad9f0a@suse.com>
Subject: Re: [PATCH 7/8] btrfs-progs: subvolume: add quota info to btrfs sub
 show
References: <20180302184704.22399-1-jeffm@suse.com>
 <20180302184704.22399-8-jeffm@suse.com>
 <51ceaf6c-17e5-734c-478e-38893c9304f7@gmx.com>
In-Reply-To: <51ceaf6c-17e5-734c-478e-38893c9304f7@gmx.com>

--8g6a3Mb7RgnHtz78x9OJp6V9Vz7I6fTJh
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

On 3/7/18 1:09 AM, Qu Wenruo wrote:
>=20
>=20
> On 2018=E5=B9=B403=E6=9C=8803=E6=97=A5 02:47, jeffm@suse.com wrote:
>> From: Jeff Mahoney <jeffm@suse.com>
>>
>> This patch reports on the first-level qgroup, if any, associated with
>> a particular subvolume.  It displays the usage and limit, subject
>> to the usual unit parameters.
>>
>> Signed-off-by: Jeff Mahoney <jeffm@suse.com>
>> ---
>>  cmds-subvolume.c | 46 ++++++++++++++++++++++++++++++++++++++++++++++
>>  1 file changed, 46 insertions(+)
>>
>> diff --git a/cmds-subvolume.c b/cmds-subvolume.c
>> index 8a473f7a..29d0e0e5 100644
>> --- a/cmds-subvolume.c
>> +++ b/cmds-subvolume.c
>> @@ -972,6 +972,7 @@ static const char * const cmd_subvol_show_usage[] =
=3D {
>>  	"Show more information about the subvolume",
>>  	"-r|--rootid   rootid of the subvolume",
>>  	"-u|--uuid     uuid of the subvolume",
>> +	HELPINFO_UNITS_SHORT_LONG,
>>  	"",
>>  	"If no option is specified, <subvol-path> will be shown, otherwise",=

>>  	"the rootid or uuid are resolved relative to the <mnt> path.",
>> @@ -993,6 +994,13 @@ static int cmd_subvol_show(int argc, char **argv)=

>>  	int by_uuid =3D 0;
>>  	u64 rootid_arg;
>>  	u8 uuid_arg[BTRFS_UUID_SIZE];
>> +	struct btrfs_qgroup_stats stats;
>> +	unsigned int unit_mode;
>> +	const char *referenced_size;
>> +	const char *referenced_limit_size =3D "-";
>> +	unsigned field_width =3D 0;
>> +
>> +	unit_mode =3D get_unit_mode_from_arg(&argc, argv, 1);
>> =20
>>  	while (1) {
>>  		int c;
>> @@ -1112,6 +1120,44 @@ static int cmd_subvol_show(int argc, char **arg=
v)
>>  	btrfs_list_subvols_print(fd, filter_set, NULL, BTRFS_LIST_LAYOUT_RAW=
,
>>  			1, raw_prefix);
>> =20
>> +	ret =3D btrfs_qgroup_query(fd, get_ri.root_id, &stats);
>> +	if (ret < 0) {
>> +		if (ret =3D=3D -ENODATA)
>> +			printf("Quotas must be enabled for per-subvolume usage\n");
>=20
> This seems a little confusing.
> If quota is disabled, we get ENOTTY not ENODATA.
>=20
> For ENODATA we know quota is enabled but just no info for this qgroup.

Yep.

Thanks,

-Jeff


> Thanks,
> Qu
>=20
>> +		else if (ret !=3D -ENOTTY)
>> +			fprintf(stderr,
>> +				"\nERROR: BTRFS_IOC_QUOTA_QUERY failed: %s\n",
>> +				strerror(errno));
>> +		goto out;
>> +	}
>> +
>> +	printf("\tQuota Usage:\t\t");
>> +	fflush(stdout);
>> +
>> +	referenced_size =3D pretty_size_mode(stats.info.referenced, unit_mod=
e);
>> +	if (stats.limit.max_referenced)
>> +	       referenced_limit_size =3D pretty_size_mode(
>> +						stats.limit.max_referenced,
>> +						unit_mode);
>> +	field_width =3D max(strlen(referenced_size),
>> +			  strlen(referenced_limit_size));
>> +
>> +	printf("%-*s referenced, %s exclusive\n ", field_width,
>> +	       referenced_size,
>> +	       pretty_size_mode(stats.info.exclusive, unit_mode));
>> +
>> +	printf("\tQuota Limits:\t\t");
>> +	if (stats.limit.max_referenced || stats.limit.max_exclusive) {
>> +		const char *excl =3D "-";
>> +
>> +		if (stats.limit.max_exclusive)
>> +		       excl =3D pretty_size_mode(stats.limit.max_exclusive,
>> +					       unit_mode);
>> +		printf("%-*s referenced, %s exclusive\n", field_width,
>> +		       referenced_limit_size, excl);
>> +	} else
>> +		printf("None\n");
>> +
>>  out:
>>  	/* clean up */
>>  	free(get_ri.path);
>>
>=20


--=20
Jeff Mahoney
SUSE Labs


--8g6a3Mb7RgnHtz78x9OJp6V9Vz7I6fTJh--

--z0Hb8zDxPuzktKypnwUUmu3LWimfxaKMd
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQJDBAEBCAAtFiEE8wzgbmZ74SnKPwtDHntLYyF55bIFAlqgScEPHGplZmZtQHN1
c2UuY29tAAoJEB57S2MheeWyvkoP/1ZJG+xZMjNZuiUgKA+HnNBqAE20FjypuL1c
uaJT1qN4uEfSby18pGVALcv5XtEOQRFy5lO45JWl3Z6A68cVfDhzI/rM3hSjlfBA
LVvyYPsrCYoaZFC9jPh4USL+l772EEdoW7T0SLbe0HMrqVLeo16N2EfK1Hiom91x
LbGa/74Fp3u9VrLip2Tbi2vl6NMcaeCvX2O4jnwOAkuozedgxc8DayMoqG2ol+0N
Kqll78w9WP2ZzA9GqEeu6GfkwSdpgxxx/N1Uz8GVQnugp9Tk33W0OGxMTxRF9wt+
iwO3OlgE/kPVI/yXia6gtq7WwdMXG7WgQa3J3xIgCzkSxjm5HtOJ4a3sy+7psTmz
mIJNN8BFeY1dgwiWlcge9Srkxcv5VqRILV2vXvudMUi0ni8doEwOdFrtP1vRPqHQ
W5NUxtQl7hbCl3zzCggPwKDwUM5t2FTfftUS1x3H1YAL6Cu+baRS+C03G+GhV8fJ
tJ4bztyfbPIPTkxb7510lzCZijEQ/gYwGhZmVRqm62P1YyJw6+cRsTlJXaXG3hHT
ub+desSx/AS7WrRYCcrnlc0RifWYlG39NQLGo3pOryM/DOdV/NvzrEAFhae71MRS
jWOgO819NQztYzc+48nxC0ww52sdlnstEBGU/RZNtI4m+FFJvUBAtd6aXH/0+p9n
UFYsc4F2
=/wb7
-----END PGP SIGNATURE-----

--z0Hb8zDxPuzktKypnwUUmu3LWimfxaKMd--
