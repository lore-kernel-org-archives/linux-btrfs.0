Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from prv3-mh.provo.novell.com ([137.65.250.26]:40453 "EHLO
        prv3-mh.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751122AbeCHX2A (ORCPT
        <rfc822;groupwise-linux-btrfs@vger.kernel.org:0:0>);
        Thu, 8 Mar 2018 18:28:00 -0500
Subject: Re: [PATCH v2] btrfs-progs: free-space-cache: Enhance free space
 cache free space check
To: Nikolay Borisov <nborisov@suse.com>, linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz
References: <20180308070231.28876-1-wqu@suse.com>
 <4fa56a5c-dfa4-048f-936e-9a36c997a33e@suse.com>
From: Qu Wenruo <wqu@suse.com>
Message-ID: <4cba0a52-2b0d-ff20-a52b-6cf90535f525@suse.com>
Date: Fri, 9 Mar 2018 07:27:48 +0800
MIME-Version: 1.0
In-Reply-To: <4fa56a5c-dfa4-048f-936e-9a36c997a33e@suse.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="RiUYt7p2a84GOiWRY49yjBi3UiW3CQ3NF"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--RiUYt7p2a84GOiWRY49yjBi3UiW3CQ3NF
Content-Type: multipart/mixed; boundary="xt7hDK7CZrSWImAHPSYVhlBquP9kcEeHi";
 protected-headers="v1"
From: Qu Wenruo <wqu@suse.com>
To: Nikolay Borisov <nborisov@suse.com>, linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz
Message-ID: <4cba0a52-2b0d-ff20-a52b-6cf90535f525@suse.com>
Subject: Re: [PATCH v2] btrfs-progs: free-space-cache: Enhance free space
 cache free space check
References: <20180308070231.28876-1-wqu@suse.com>
 <4fa56a5c-dfa4-048f-936e-9a36c997a33e@suse.com>
In-Reply-To: <4fa56a5c-dfa4-048f-936e-9a36c997a33e@suse.com>

--xt7hDK7CZrSWImAHPSYVhlBquP9kcEeHi
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2018=E5=B9=B403=E6=9C=8808=E6=97=A5 22:05, Nikolay Borisov wrote:
>=20
>=20
> On  8.03.2018 09:02, Qu Wenruo wrote:
>> When we found free space difference between free space cache and block=

>> group item, we just discard this free space cache.
>>
>> Normally such difference is caused by btrfs_reserve_extent() called by=

>> delalloc which is out of a transaction.
>> And since all btrfs_release_extent() is called with a transaction, und=
er
>> heavy race free space cache can have less free space than block group
>> item.
>>
>> Normally kernel will detect such difference and just discard that cach=
e.
>>
>> However we must be more careful if free space cache has more free spac=
e
>> cache, and if that happens, paried with above race one invalid free
>> space cache can be loaded into kernel.
>>
>> So if we find any free space cache who has more free space then block
>> group item, we report it as an error other than ignoring it.
>>
>> Signed-off-by: Qu Wenruo <wqu@suse.com>
>> ---
>> v2:
>>   Fix the timming of free space output.
>> ---
>>  check/main.c       |  4 +++-
>>  free-space-cache.c | 32 ++++++++++++++++++++++++--------
>>  2 files changed, 27 insertions(+), 9 deletions(-)
>>
>> diff --git a/check/main.c b/check/main.c
>> index 97baae583f04..bc31f7e32061 100644
>> --- a/check/main.c
>> +++ b/check/main.c
>> @@ -5339,7 +5339,9 @@ static int check_space_cache(struct btrfs_root *=
root)
>>  			error +=3D ret;
>>  		} else {
>>  			ret =3D load_free_space_cache(root->fs_info, cache);
>> -			if (!ret)
>> +			if (ret < 0)
>> +				error++;
>> +			if (ret <=3D 0)
>>  				continue;
>>  		}
>> =20
>> diff --git a/free-space-cache.c b/free-space-cache.c
>> index f933f9f1cf3f..9b83a71ca59a 100644
>> --- a/free-space-cache.c
>> +++ b/free-space-cache.c
>> @@ -438,7 +438,8 @@ int load_free_space_cache(struct btrfs_fs_info *fs=
_info,
>>  	struct btrfs_path *path;
>>  	u64 used =3D btrfs_block_group_used(&block_group->item);
>>  	int ret =3D 0;
>> -	int matched;
>> +	u64 bg_free;
>> +	s64 diff;
>> =20
>>  	path =3D btrfs_alloc_path();
>>  	if (!path)
>> @@ -448,18 +449,33 @@ int load_free_space_cache(struct btrfs_fs_info *=
fs_info,
>>  				      block_group->key.objectid);
>>  	btrfs_free_path(path);
>> =20
>> -	matched =3D (ctl->free_space =3D=3D (block_group->key.offset - used =
-
>> -				       block_group->bytes_super));
>> -	if (ret =3D=3D 1 && !matched) {
>> -		__btrfs_remove_free_space_cache(ctl);
>> +	bg_free =3D block_group->key.offset - used - block_group->bytes_supe=
r;
>> +	diff =3D ctl->free_space - bg_free;
>> +	if (ret =3D=3D 1 && diff) {
>>  		fprintf(stderr,
>> -		       "block group %llu has wrong amount of free space\n",
>> -		       block_group->key.objectid);
>> +		       "block group %llu has wrong amount of free space, free space=
 cache has %llu block group has %llu\n",nit: Always put units when printi=
ng numbers. In this case we are talking
> about bytes.
>> +		       block_group->key.objectid, ctl->free_space, bg_free);
>> +		__btrfs_remove_free_space_cache(ctl);
>> +		/*
>> +		 * Due to btrfs_reserve_extent() can happen out of > +		 * transact=
ion, but all btrfs_release_extent() happens inside
>> +		 * a transaction, so under heavy race it's possible that free
>> +		 * space cache has less free space, and both kernel just discard
>> +		 * such cache. But if we find some case where free space cache
>> +		 * has more free space, this means under certain case such
>> +		 * cache can be loaded and cause double allocate.
>> +		 *
>> +		 * Detect such possibility here.
>> +		 */
>> +		if (diff > 0)
>> +			error(
>> +"free space cache has more free space than block group item, this cou=
ld leads to serious corruption, please contact btrfs developers");
>=20
> I'm not entirely happy with this message. So they will post to the
> mailing list saying something along the lines of "I got this message
> what do I do no, please help".  Better to output actionable data so tha=
t
> the user can post it immediately.

Unfortunately, this is already the situation we don't expect to see.

What we really need is to know this could happen, and if possible some
info about the situation.
There is not much actionable data here.

Thanks,
Qu

>=20
>>  		ret =3D -1;
>>  	}
>> =20
>>  	if (ret < 0) {
>> -		ret =3D 0;
>> +		if (diff <=3D 0)
>> +			ret =3D 0;
>> =20
>>  		fprintf(stderr,
>>  		       "failed to load free space cache for block group %llu\n",
>>


--xt7hDK7CZrSWImAHPSYVhlBquP9kcEeHi--

--RiUYt7p2a84GOiWRY49yjBi3UiW3CQ3NF
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQFBBAEBCAArFiEELd9y5aWlW6idqkLhwj2R86El/qgFAlqhxvQNHHdxdUBzdXNl
LmNvbQAKCRDCPZHzoSX+qNb/CACtnMUSurRcyxBO3s6+CuVXwid7gmz2ZasNGPJM
QqcK4OFe4TYMBwaBc1jc/03Hs7mXUNSXruYjxwLJlydiXCdXVv9xhai8njArCuVo
oRWUlBlGhlqmhOtmquixIC6ycIIlSbghylFtJh/68veATTpcHcuMLO7tBEPcq5Rv
+/XSVPO1NH7lPIe4aif6WGDDuCtQ0EAw0p8c2/z6JMYGFNNymmoe2EKmiDOidRGW
BLtz/ExSm60R9RDk3S7v9vHvYIIdt2Ss/vfkeiDRxsU+FwTfYHNPUrj39y9XV/A+
2gXWbjPINe9mFBo0fJFYMUkvzkBrotDuG6qiNpTSlZaKsFsK
=Aw0S
-----END PGP SIGNATURE-----

--RiUYt7p2a84GOiWRY49yjBi3UiW3CQ3NF--
