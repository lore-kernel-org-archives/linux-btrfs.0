Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.20]:49872 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753740AbdLTAmE (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 19 Dec 2017 19:42:04 -0500
Subject: Re: [PATCH] btrfs-progs: qgroup: Remove support for specifying
 inherit type
To: "Misono, Tomohiro" <misono.tomohiro@jp.fujitsu.com>,
        Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz
References: <20171219105331.9636-1-wqu@suse.com>
 <0441718e-9a39-fbf5-b026-d54bec6fe36b@jp.fujitsu.com>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <6e371a7c-c8fd-79e8-c4ad-351501d9cd6b@gmx.com>
Date: Wed, 20 Dec 2017 08:41:42 +0800
MIME-Version: 1.0
In-Reply-To: <0441718e-9a39-fbf5-b026-d54bec6fe36b@jp.fujitsu.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="JC3GEogtszOByrjDwsNuIu2npQY4stpZP"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--JC3GEogtszOByrjDwsNuIu2npQY4stpZP
Content-Type: multipart/mixed; boundary="GLW2gStlQmrsUrZ4K8tQwquCCWfbH0ZNu";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: "Misono, Tomohiro" <misono.tomohiro@jp.fujitsu.com>,
 Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz
Message-ID: <6e371a7c-c8fd-79e8-c4ad-351501d9cd6b@gmx.com>
Subject: Re: [PATCH] btrfs-progs: qgroup: Remove support for specifying
 inherit type
References: <20171219105331.9636-1-wqu@suse.com>
 <0441718e-9a39-fbf5-b026-d54bec6fe36b@jp.fujitsu.com>
In-Reply-To: <0441718e-9a39-fbf5-b026-d54bec6fe36b@jp.fujitsu.com>

--GLW2gStlQmrsUrZ4K8tQwquCCWfbH0ZNu
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2017=E5=B9=B412=E6=9C=8820=E6=97=A5 08:34, Misono, Tomohiro wrote:
> On 2017/12/19 19:53, Qu Wenruo wrote:
>> Since kernel is deprecating the support for specifying inherit type,
>> remove the support in btrfs-progs too.
>>
>> Thankfully, the options for qgroup inheritance is hidden and not
>> documented, so user shouldn't be affected at all.
>>
>> Signed-off-by: Qu Wenruo <wqu@suse.com>
>> ---
>>  cmds-subvolume.c | 21 ---------------------
>>  qgroup.c         | 42 ------------------------------------------
>>  qgroup.h         |  3 ---
>>  3 files changed, 66 deletions(-)
>>
>> diff --git a/cmds-subvolume.c b/cmds-subvolume.c
>> index dc626a6495e5..e0839da7d8f8 100644
>> --- a/cmds-subvolume.c
>> +++ b/cmds-subvolume.c
>> @@ -134,13 +134,6 @@ static int cmd_subvol_create(int argc, char **arg=
v)
>>  			break;
>> =20
>>  		switch (c) {
>> -		case 'c':
>> -			res =3D qgroup_inherit_add_copy(&inherit, optarg, 0);
>> -			if (res) {
>> -				retval =3D res;
>> -				goto out;
>> -			}
>> -			break;
>>  		case 'i':
>>  			res =3D qgroup_inherit_add_group(&inherit, optarg);
>>  			if (res) {
>=20
> No harm, but we should remove "c:" from getopt() too.
> Tomohiro

Oh, I forgot that.

Thanks for pointing this out,
Qu

>=20
>> @@ -670,13 +663,6 @@ static int cmd_subvol_snapshot(int argc, char **a=
rgv)
>>  			break;
>> =20
>>  		switch (c) {
>> -		case 'c':
>> -			res =3D qgroup_inherit_add_copy(&inherit, optarg, 0);
>> -			if (res) {
>> -				retval =3D res;
>> -				goto out;
>> -			}
>> -			break;
>>  		case 'i':
>>  			res =3D qgroup_inherit_add_group(&inherit, optarg);
>>  			if (res) {
>> @@ -687,13 +673,6 @@ static int cmd_subvol_snapshot(int argc, char **a=
rgv)
>>  		case 'r':
>>  			readonly =3D 1;
>>  			break;
>> -		case 'x':
>> -			res =3D qgroup_inherit_add_copy(&inherit, optarg, 1);
>> -			if (res) {
>> -				retval =3D res;
>> -				goto out;
>> -			}
>> -			break;
>>  		default:
>>  			usage(cmd_subvol_snapshot_usage);
>>  		}
>> diff --git a/qgroup.c b/qgroup.c
>> index 156825fd431d..e9158a260251 100644
>> --- a/qgroup.c
>> +++ b/qgroup.c
>> @@ -1310,45 +1310,3 @@ int qgroup_inherit_add_group(struct btrfs_qgrou=
p_inherit **inherit, char *arg)
>> =20
>>  	return 0;
>>  }
>> -
>> -int qgroup_inherit_add_copy(struct btrfs_qgroup_inherit **inherit, ch=
ar *arg,
>> -			    int type)
>> -{
>> -	int ret;
>> -	u64 qgroup_src;
>> -	u64 qgroup_dst;
>> -	char *p;
>> -	int pos =3D 0;
>> -
>> -	p =3D strchr(arg, ':');
>> -	if (!p) {
>> -bad:
>> -		error("invalid copy specification, missing separator :");
>> -		return -EINVAL;
>> -	}
>> -	*p =3D 0;
>> -	qgroup_src =3D parse_qgroupid(arg);
>> -	qgroup_dst =3D parse_qgroupid(p + 1);
>> -	*p =3D ':';
>> -
>> -	if (!qgroup_src || !qgroup_dst)
>> -		goto bad;
>> -
>> -	if (*inherit)
>> -		pos =3D (*inherit)->num_qgroups +
>> -		      (*inherit)->num_ref_copies * 2 * type;
>> -
>> -	ret =3D qgroup_inherit_realloc(inherit, 2, pos);
>> -	if (ret)
>> -		return ret;
>> -
>> -	(*inherit)->qgroups[pos++] =3D qgroup_src;
>> -	(*inherit)->qgroups[pos++] =3D qgroup_dst;
>> -
>> -	if (!type)
>> -		++(*inherit)->num_ref_copies;
>> -	else
>> -		++(*inherit)->num_excl_copies;
>> -
>> -	return 0;
>> -}
>> diff --git a/qgroup.h b/qgroup.h
>> index 875fbdf37f5f..3fc57123dc2d 100644
>> --- a/qgroup.h
>> +++ b/qgroup.h
>> @@ -92,7 +92,4 @@ int btrfs_qgroup_setup_comparer(struct btrfs_qgroup_=
comparer_set **comp_set,
>>  				int is_descending);
>>  int qgroup_inherit_size(struct btrfs_qgroup_inherit *p);
>>  int qgroup_inherit_add_group(struct btrfs_qgroup_inherit **inherit, c=
har *arg);
>> -int qgroup_inherit_add_copy(struct btrfs_qgroup_inherit **inherit, ch=
ar *arg,
>> -			    int type);
>> -
>>  #endif
>>
>=20
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>=20


--GLW2gStlQmrsUrZ4K8tQwquCCWfbH0ZNu--

--JC3GEogtszOByrjDwsNuIu2npQY4stpZP
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQFLBAEBCAA1FiEELd9y5aWlW6idqkLhwj2R86El/qgFAlo5sccXHHF1d2VucnVv
LmJ0cmZzQGdteC5jb20ACgkQwj2R86El/qjapAf/Vc+gcdvfPePYYoxmzHg56qBn
K3Jsd8tjbQwk8vu2BgMWD8L5oNTSngoyp54l5hkTYNASOnu75hWZT3phYUZnfRxM
LSZE2pdQPJG/4O4cLCDfR4ub9m33tKQifwvhBdr8/iXl12W34dPolkV4JBCnKlBC
0oWySV2vM7dt74/wCFZWIavi0sDIQztGR+3HmVQgYvXk7I3fJPmBgqMC1IbWBXOc
y23pRsmN2Ame9YfSKjWQVhY979cjtekxMywzZW+AaVaAvAq2j30LhArdxaf/ZgL7
szQEUd0gsQeMx0lzsReXnMzUFhyGzHL1TeslW1AE2auUMN9oFrER4HtyZN6MgA==
=iYK+
-----END PGP SIGNATURE-----

--JC3GEogtszOByrjDwsNuIu2npQY4stpZP--
