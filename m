Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:53567 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S933335AbeCGP2b (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 7 Mar 2018 10:28:31 -0500
Subject: Re: [PATCH 8/8] btrfs-progs: qgroups: export qgroups usage
 information as JSON
To: Qu Wenruo <quwenruo.btrfs@gmx.com>, linux-btrfs@vger.kernel.org
References: <20180302184704.22399-1-jeffm@suse.com>
 <20180302184704.22399-9-jeffm@suse.com>
 <2250ef0b-13a2-1a8f-cd19-ea69adf27e7b@gmx.com>
From: Jeff Mahoney <jeffm@suse.com>
Message-ID: <a5cf785d-f8a1-9396-99d7-260f3610d531@suse.com>
Date: Wed, 7 Mar 2018 10:28:27 -0500
MIME-Version: 1.0
In-Reply-To: <2250ef0b-13a2-1a8f-cd19-ea69adf27e7b@gmx.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="zBzsPJKDzH3nXga3QeBhwLaNBY5Q7XpcY"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--zBzsPJKDzH3nXga3QeBhwLaNBY5Q7XpcY
Content-Type: multipart/mixed; boundary="G5bnF40NU6tboLxXyleGj7W8PBf56l47V";
 protected-headers="v1"
From: Jeff Mahoney <jeffm@suse.com>
To: Qu Wenruo <quwenruo.btrfs@gmx.com>, linux-btrfs@vger.kernel.org
Message-ID: <a5cf785d-f8a1-9396-99d7-260f3610d531@suse.com>
Subject: Re: [PATCH 8/8] btrfs-progs: qgroups: export qgroups usage
 information as JSON
References: <20180302184704.22399-1-jeffm@suse.com>
 <20180302184704.22399-9-jeffm@suse.com>
 <2250ef0b-13a2-1a8f-cd19-ea69adf27e7b@gmx.com>
In-Reply-To: <2250ef0b-13a2-1a8f-cd19-ea69adf27e7b@gmx.com>

--G5bnF40NU6tboLxXyleGj7W8PBf56l47V
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

On 3/7/18 1:34 AM, Qu Wenruo wrote:
>=20
>=20
> On 2018=E5=B9=B403=E6=9C=8803=E6=97=A5 02:47, jeffm@suse.com wrote:
>> diff --git a/configure.ac b/configure.ac
>> index 56d17c3a..6aec672a 100644
>> --- a/configure.ac
>> +++ b/configure.ac
>> @@ -197,6 +197,12 @@ PKG_STATIC(UUID_LIBS_STATIC, [uuid])
>>  PKG_CHECK_MODULES(ZLIB, [zlib])
>>  PKG_STATIC(ZLIB_LIBS_STATIC, [zlib])
>> =20
>> +PKG_CHECK_MODULES(JSON, [json-c], [
>=20
> Json-c is quite common and also used by cryptsetup, so pretty good
> library choice.

Yep, so that puts it in the base system packages of most distros.

>> diff --git a/qgroup.c b/qgroup.c
>> index 2d0a6947..f632a45c 100644
>> --- a/qgroup.c
>> +++ b/qgroup.c
>>  	return ret;
>>  }
>> =20
>> +#ifdef HAVE_JSON
>> +static void format_qgroupid(char *buf, size_t size, u64 qgroupid)
>> +{
>> +	int ret;
>> +
>> +	ret =3D snprintf(buf, size, "%llu/%llu",
>> +		       btrfs_qgroup_level(qgroupid),
>> +		       btrfs_qgroup_subvid(qgroupid));
>> +	ASSERT(ret < sizeof(buf));
>=20
> This is designed to catch truncated snprintf(), right?
> This can be addressed by setting up the @buf properly.
> (See below)
>=20
> And in fact, due to that super magic number, we won't hit this ASSERT()=

> anyway.

Yep, but ASSERTs are there to detect/prevent developer mistakes.  This
should only trigger due to a simple bug, so we ASSERT rather than handle
the error gracefully.

[...]

>> +static bool export_one_qgroup(json_object *container,
>> +			     const struct btrfs_qgroup *qgroup, bool compat)
>> +{
>> +	json_object *obj =3D json_object_new_object();
>> +	json_object *tmp;
>> +	char buf[42];
>=20
> Answer to the ultimate question of life, the universe, and everything. =
:)
>=20
> Although according to the format level/subvolid, it should be
> count_digits(MAX_U16) + 1 + count_digits(MAX_U48) + 1. (1 for '/' and 1=

> for '\n')
>=20
> Could be defined as a macro as:
> #define QGROUP_FORMAT_BUF_LEN (count_digits(1ULL<<16) + 1 + \
>                                count_digits(1ULL<<48) + 1)

Which would mean we'd execute count_digits twice for every qgroup to
resolve a constant.  I'll replace the magic number with a define though.

> BTW, the result is just 22.
It's a worst-case.  We're using %llu, so 42 is the length of two 64-bit
numbers in base ten, plus the slash and nul terminator.  In practice we
won't hit the limit, but it doesn't hurt.

Thanks for the review.

-Jeff

--=20
Jeff Mahoney
SUSE Labs


--G5bnF40NU6tboLxXyleGj7W8PBf56l47V--

--zBzsPJKDzH3nXga3QeBhwLaNBY5Q7XpcY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQJDBAEBCAAtFiEE8wzgbmZ74SnKPwtDHntLYyF55bIFAlqgBRsPHGplZmZtQHN1
c2UuY29tAAoJEB57S2MheeWyaYMQAJmqIqfuHFjKOqnkDDX/jVejuDD5V8TV8j/E
rTuZdvxYdsOSvZWTDzm9NwxDtpVQcqZX3lCQo191WQAsyU+XirEZxqOEPTHUWqPA
1c3qzMe9cCqkJLGqWOyP99Lq6BMSeVED3UTzNwgyWVtw0G52AyzUBLbN5zuwR3H3
cP+nl4//SpF1GceFsT9RkQsoj3AGsiGqghx9A6MATClKoR5jnEFf2fmaOioRNKpq
sjas/aZegrhaLQFUl+LgZSca7zWz4VO9bo+K7vYtVdgxUEk/D0MMNOBT44VRmMKL
CD0U32lI/LUx1XXaC3eb84nxOiosabJ5xiODEddaBq0teCYLvKoM8vFSIeho0xsr
2PoMIDcjR2e3UMRe4s1/jRGgECl1aqPycc89Xsk+Fg4zk3r/zoG21XS0dXqqhDEn
/cwPOGqc6OOX6ybf/fCOe4s0nTNkIfS00Yr0ll+NWDHcy4bot9Dn239sOOqTjher
QGSeHoKXSw2jwEzjRO4y9S7Q556rL9ZSJ1xe3b/PecxyriAYtDo4BJ9kaFBJ83uy
xvQistP+j2AJig3NoydacmRjkMOU/z8Ln3mARfqWDDTFHisOtsZBn5tZ2q4rpwx9
KoLQdjstDdUBRJy1P165fkcsKFWTo6eUOdbH3wc7tO8rs3DpHt7Z9XVHrK5pu7L2
72HXUaO8
=Rd3z
-----END PGP SIGNATURE-----

--zBzsPJKDzH3nXga3QeBhwLaNBY5Q7XpcY--
