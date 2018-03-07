Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:45422 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S934250AbeCGTma (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 7 Mar 2018 14:42:30 -0500
Subject: Re: [PATCH 6/8] btrfs-progs: qgroups: introduce btrfs_qgroup_query
To: Qu Wenruo <quwenruo.btrfs@gmx.com>, linux-btrfs@vger.kernel.org
References: <20180302184704.22399-1-jeffm@suse.com>
 <20180302184704.22399-7-jeffm@suse.com>
 <1e0bf346-bef4-c4e5-4054-9cbedb3fd36a@gmx.com>
From: Jeff Mahoney <jeffm@suse.com>
Message-ID: <f6162513-9d04-42f1-aad8-559c62951a57@suse.com>
Date: Wed, 7 Mar 2018 14:42:25 -0500
MIME-Version: 1.0
In-Reply-To: <1e0bf346-bef4-c4e5-4054-9cbedb3fd36a@gmx.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="3AQEZrbQywZyrYospsfm4pZeFihWOMwoZ"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--3AQEZrbQywZyrYospsfm4pZeFihWOMwoZ
Content-Type: multipart/mixed; boundary="P4X4c0FdfZUbHrfr8diSW3dxcgcBGphkr";
 protected-headers="v1"
From: Jeff Mahoney <jeffm@suse.com>
To: Qu Wenruo <quwenruo.btrfs@gmx.com>, linux-btrfs@vger.kernel.org
Message-ID: <f6162513-9d04-42f1-aad8-559c62951a57@suse.com>
Subject: Re: [PATCH 6/8] btrfs-progs: qgroups: introduce btrfs_qgroup_query
References: <20180302184704.22399-1-jeffm@suse.com>
 <20180302184704.22399-7-jeffm@suse.com>
 <1e0bf346-bef4-c4e5-4054-9cbedb3fd36a@gmx.com>
In-Reply-To: <1e0bf346-bef4-c4e5-4054-9cbedb3fd36a@gmx.com>

--P4X4c0FdfZUbHrfr8diSW3dxcgcBGphkr
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

On 3/7/18 12:58 AM, Qu Wenruo wrote:
>=20
>=20
> On 2018=E5=B9=B403=E6=9C=8803=E6=97=A5 02:47, jeffm@suse.com wrote:
>> diff --git a/qgroup.c b/qgroup.c
>> index b1be3311..2d0a6947 100644
>> --- a/qgroup.c
>> +++ b/qgroup.c
>> @@ -1267,6 +1249,66 @@ static int __qgroups_search(int fd, struct qgro=
up_lookup *qgroup_lookup)
>>  	return ret;
>>  }
>> =20
>> +static int qgroups_search_all(int fd, struct qgroup_lookup *qgroup_lo=
okup)
>> +{
>> +	struct btrfs_ioctl_search_args args =3D {
>> +		.key =3D {
>> +			.tree_id =3D BTRFS_QUOTA_TREE_OBJECTID,
>> +			.max_type =3D BTRFS_QGROUP_RELATION_KEY,
>> +			.min_type =3D BTRFS_QGROUP_STATUS_KEY,
>> +			.max_objectid =3D (u64)-1,
>> +			.max_offset =3D (u64)-1,
>> +			.max_transid =3D (u64)-1,
>> +			.nr_items =3D 4096,
>> +		},
>> +	};
>> +	int ret;
>> +
>> +	ret =3D __qgroups_search(fd, &args, qgroup_lookup);
>> +	if (ret =3D=3D -ENOTTY)
>> +		error("can't list qgroups: quotas not enabled");
>> +	else if (ret < 0)
>> +		error("can't list qgroups: %s", strerror(-ret));
>> +	return ret;
>> +}
>> +
>> +int btrfs_qgroup_query(int fd, u64 qgroupid, struct btrfs_qgroup_stat=
s *stats)
>> +{
>> +	struct btrfs_ioctl_search_args args =3D {
>> +		.key =3D {
>> +			.tree_id =3D BTRFS_QUOTA_TREE_OBJECTID,
>> +			.min_type =3D BTRFS_QGROUP_INFO_KEY,
>> +			.max_type =3D BTRFS_QGROUP_LIMIT_KEY,
>> +			.max_objectid =3D 0,
>> +			.max_offset =3D qgroupid,
>> +			.max_transid =3D (u64)-1,
>> +			.nr_items =3D 4096, /* should be 2, i think */
>=20
> 2 is not correct in fact.
>=20
> As QGROUP_INFO is smaller than QGROUP_LIMIT, to get a slice of all what=

> we need, we need to include all other unrelated items.
>=20
> One example will be:
> 	item 1 key (0 QGROUP_INFO 0/5) itemoff 16211 itemsize 40
> 	item 2 key (0 QGROUP_INFO 0/257) itemoff 16171 itemsize 40
> 	item 3 key (0 QGROUP_INFO 1/1) itemoff 16131 itemsize 40
> 	item 4 key (0 QGROUP_LIMIT 0/5) itemoff 16091 itemsize 40
> 	item 5 key (0 QGROUP_LIMIT 0/257) itemoff 16051 itemsize 40
> 	item 6 key (0 QGROUP_LIMIT 1/1) itemoff 16011 itemsize 40
>=20
> To query qgroup info about 0/257, above setup will get the following sl=
ice:
> 	item 1 key (0 QGROUP_INFO 0/5) itemoff 16211 itemsize 40
> 	item 2 key (0 QGROUP_INFO 0/257) itemoff 16171 itemsize 40
> 	item 3 key (0 QGROUP_INFO 1/1) itemoff 16131 itemsize 40
> 	item 4 key (0 QGROUP_LIMIT 0/5) itemoff 16091 itemsize 40
> 	item 5 key (0 QGROUP_LIMIT 0/257) itemoff 16051 itemsize 40
> So we still need that large @nr_items.
>=20
> Despite this comment it looks good.

Of course.  I use TREE_SEARCH so infrequently that I forget about this
every time so the pain is always fresh.

It should be .min_offset =3D qgroupid, .nr_items =3D 2, but of course tha=
t
doesn't work either for different reasons.  __qgroups_search's loop will
loop until it comes back with no more results and it sets the nr_items
itself to 4096 at the end of the loop.  The key comparison in the ioctl
only does a regular key comparison and offset doesn't get evaluated if
the types aren't equal.  That works fine when doing tree insertion or
searches for a single key but is wrong for searching for a range.  I
have a TREE_SEARCH_V3 lying around somewhere to address this ridiculous
behavior and should probably finish it up at some point.

This hasn't mattered for __qgroup_search until now since it hasn't used
anything other than -1 for the offset and objectid so I'll just add a
filter there.

-Jeff

--=20
Jeff Mahoney
SUSE Labs


--P4X4c0FdfZUbHrfr8diSW3dxcgcBGphkr--

--3AQEZrbQywZyrYospsfm4pZeFihWOMwoZ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQJDBAEBCAAtFiEE8wzgbmZ74SnKPwtDHntLYyF55bIFAlqgQKIPHGplZmZtQHN1
c2UuY29tAAoJEB57S2MheeWyblgP/1jzU5LW2f7QhO+GBYVccUdbIZ4hvZ8gr/0S
OVNmnVEwJjMv0ytFx+WtoA8gOF2j9bxG0GaGL2P43EMziJAPL0FPyba7sqQYhEdm
d0ZQqC84k5mta8iJIyfoRJjegD5dkhmKUTG4KDE5Pay4V8vLJ4G8aklnDmRgOKuQ
yjKgCMzAC+am0B4k+ibDotLPgu7kFSVTwHs+CFqH801mSU4grc/APucccVNker6J
4j3tILfiH4d6I23teGoWxQCNfRT3nDvxq/bcGnOAgRIp+YGJ8bPBdRZ4oh59cBJs
Cncav6dbilIUNK0uWS0dqMp7cGn3HYm/N/hLTINKfxNOS4I5Elfwf8lXnXZEjQoF
D4JKewugqID1gni9W2fgBomJrwaNesHMpd5qBNQ/6QztDFy6H/hqN/nruz9rhjU+
cLp7pQImkxUlfAN3kcEl5YIhbiIs36KhpNWgYWeU9OZX9a2V2hQQuATq/ksIe9sQ
Dc8bCKdbe69yPR9zQ1TlrOVelh0iQ+t8RnB5ffbcOX+yUodcYj5uC6JU9vV+Jpno
Aq91Such9I+XhBVlUv/vk0i6nwC1r4BfLW5TPazLqOcLTWXO1DRZWPdy5vwEzR40
5yZ4HbZLuIVCv9CixK0cO8M8CyMPu8HEKQKKkclr8yHj/vKFVkfGAKWsvriOWVVS
WnloAf0v
=0YiA
-----END PGP SIGNATURE-----

--3AQEZrbQywZyrYospsfm4pZeFihWOMwoZ--
