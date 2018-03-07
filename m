Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:49003 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S965148AbeCGUY1 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 7 Mar 2018 15:24:27 -0500
Subject: Re: [PATCH 6/8] btrfs-progs: qgroups: introduce btrfs_qgroup_query
To: "Misono, Tomohiro" <misono.tomohiro@jp.fujitsu.com>,
        linux-btrfs@vger.kernel.org
References: <20180302184704.22399-1-jeffm@suse.com>
 <20180302184704.22399-7-jeffm@suse.com>
 <08a5b635-cb47-7395-4785-71f14a1ab146@jp.fujitsu.com>
From: Jeff Mahoney <jeffm@suse.com>
Message-ID: <9149ed1f-8273-6ced-fc58-c591c9de3eac@suse.com>
Date: Wed, 7 Mar 2018 15:24:23 -0500
MIME-Version: 1.0
In-Reply-To: <08a5b635-cb47-7395-4785-71f14a1ab146@jp.fujitsu.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="YTxRyF7t0AGJGnoLXsHZsucaYCm8EuYFA"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--YTxRyF7t0AGJGnoLXsHZsucaYCm8EuYFA
Content-Type: multipart/mixed; boundary="IwbjCayvd5qyco5rwlGGTlFaBtEbW6Yje";
 protected-headers="v1"
From: Jeff Mahoney <jeffm@suse.com>
To: "Misono, Tomohiro" <misono.tomohiro@jp.fujitsu.com>,
 linux-btrfs@vger.kernel.org
Message-ID: <9149ed1f-8273-6ced-fc58-c591c9de3eac@suse.com>
Subject: Re: [PATCH 6/8] btrfs-progs: qgroups: introduce btrfs_qgroup_query
References: <20180302184704.22399-1-jeffm@suse.com>
 <20180302184704.22399-7-jeffm@suse.com>
 <08a5b635-cb47-7395-4785-71f14a1ab146@jp.fujitsu.com>
In-Reply-To: <08a5b635-cb47-7395-4785-71f14a1ab146@jp.fujitsu.com>

--IwbjCayvd5qyco5rwlGGTlFaBtEbW6Yje
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

On 3/7/18 3:02 AM, Misono, Tomohiro wrote:
> On 2018/03/03 3:47, jeffm@suse.com wrote:
>> From: Jeff Mahoney <jeffm@suse.com>
>>
>> The only mechanism we have in the progs for searching qgroups is to lo=
ad
>> all of them and filter the results.  This works for qgroup show but
>> to add quota information to 'btrfs subvoluem show' it's pretty wastefu=
l.
>>
>> This patch splits out setting up the search and performing the search =
so
>> we can search for a single qgroupid more easily.
>>
>> Signed-off-by: Jeff Mahoney <jeffm@suse.com>
>> ---
>>  qgroup.c | 98 +++++++++++++++++++++++++++++++++++++++++++++----------=
---------
>>  qgroup.h |  7 +++++
>>  2 files changed, 77 insertions(+), 28 deletions(-)
>>
>> diff --git a/qgroup.c b/qgroup.c
>> index b1be3311..2d0a6947 100644
>> --- a/qgroup.c
>> +++ b/qgroup.c
>> @@ -1146,11 +1146,11 @@ static inline void print_status_flag_warning(u=
64 flags)
>>  		warning("qgroup data inconsistent, rescan recommended");
>>  }
>> =20
>> -static int __qgroups_search(int fd, struct qgroup_lookup *qgroup_look=
up)
>> +static int __qgroups_search(int fd, struct btrfs_ioctl_search_args *a=
rgs,
>> +			    struct qgroup_lookup *qgroup_lookup)
>>  {
>>  	int ret;
>> -	struct btrfs_ioctl_search_args args;
>> -	struct btrfs_ioctl_search_key *sk =3D &args.key;
>> +	struct btrfs_ioctl_search_key *sk =3D &args->key;
>>  	struct btrfs_ioctl_search_header *sh;
>>  	unsigned long off =3D 0;
>>  	unsigned int i;
>> @@ -1161,30 +1161,12 @@ static int __qgroups_search(int fd, struct qgr=
oup_lookup *qgroup_lookup)
>>  	u64 qgroupid;
>>  	u64 qgroupid1;
>> =20
>> -	memset(&args, 0, sizeof(args));
>> -
>> -	sk->tree_id =3D BTRFS_QUOTA_TREE_OBJECTID;
>> -	sk->max_type =3D BTRFS_QGROUP_RELATION_KEY;
>> -	sk->min_type =3D BTRFS_QGROUP_STATUS_KEY;
>> -	sk->max_objectid =3D (u64)-1;
>> -	sk->max_offset =3D (u64)-1;
>> -	sk->max_transid =3D (u64)-1;
>> -	sk->nr_items =3D 4096;
>> -
>>  	qgroup_lookup_init(qgroup_lookup);
>> =20
>>  	while (1) {
>> -		ret =3D ioctl(fd, BTRFS_IOC_TREE_SEARCH, &args);
>> +		ret =3D ioctl(fd, BTRFS_IOC_TREE_SEARCH, args);
>>  		if (ret < 0) {
>> -			if (errno =3D=3D ENOENT) {
>> -				error("can't list qgroups: quotas not enabled");
>> -				ret =3D -ENOTTY;
>> -			} else {
>> -				error("can't list qgroups: %s",
>> -				       strerror(errno));
>> -				ret =3D -errno;
>> -			}
>> -
>> +			ret =3D -errno;
>=20
> Originally, -ENOTTY would be returned when qgroup is disabled
> but this changes to return -ENOENT. so, it seems that error check
> in 7th patch would not work correctly when qgroup is disabled.
>=20

Good catch.

Thanks,

-Jeff

--=20
Jeff Mahoney
SUSE Labs


--IwbjCayvd5qyco5rwlGGTlFaBtEbW6Yje--

--YTxRyF7t0AGJGnoLXsHZsucaYCm8EuYFA
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQJDBAEBCAAtFiEE8wzgbmZ74SnKPwtDHntLYyF55bIFAlqgSncPHGplZmZtQHN1
c2UuY29tAAoJEB57S2MheeWyAkIP/j/y99htkSjK4FEW/1/KRJQwRN/X2GHGMtis
qqhZVCcscvQTCokPfpOSN5WB4y3OggT54YjTRQ69cPuMsQiIylb9SUfDUepvmTcx
fmdLD/TAyJUCo4MkEfkE193hT/F5BWfQeTDVJRispMB+QGMriaY/eZhH5bfvEDaX
Expp6nZ+57BRLg45MxrVvJYE4xRylrP0h2A8Z+bYGIJ9ilmeWdywvDRLsyRe9t0k
k6bpbvMC/2RJKC1X61Fotd8858Yhn0d4/2xdwlLi3vx6tZfHIsbdKsAFI9tu2dsT
hr/vibsjk+7geNbNHh4xR/acux6Xdbm+S+6yoQrdZVThsVaLcqXRSGNJNykt/fBR
GiR7+LSxWy88bttqkQczPlHNvH2XrL9fIqfRHhlXBJHrgz2IdhilHFgpmuKm9PZf
aTubf4grvK4V9xv+WmeMDcWflyZ1Bb1nH9RuXKPhBGcfCUuKyvfwkdlDMQYdw8Hz
wrY8yISobpGGT922fz5C+ZTH05NnCDDpAASKKcxfZltMGuFtyEBnSCgoPCtXyWtF
R3H9CmjJdYS6cpAsGdO1JXVKIX8N36uWdjmrFrbX14wjN1fC9/uGzB+0XlIQoLvV
BdCyoGi5NYoQawofFS2fYuJH0/+zo9u8hOhqjknEU0EIZu4UETME5okAgqRlH8Nq
sGbM9BWc
=tZAj
-----END PGP SIGNATURE-----

--YTxRyF7t0AGJGnoLXsHZsucaYCm8EuYFA--
