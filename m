Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.15]:55569 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752084AbeCMJEm (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 13 Mar 2018 05:04:42 -0400
Subject: Re: [PATCH v2 5/7] btrfs-progs: check/lowmem mode: Check inline
 extent size
To: Nikolay Borisov <nborisov@suse.com>, Qu Wenruo <wqu@suse.com>,
        linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz
References: <20180313015616.6574-1-wqu@suse.com>
 <20180313015616.6574-6-wqu@suse.com>
 <b357d3ce-50f3-03e7-5d57-396be9c35565@suse.com>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <f6bdcff3-b8eb-8795-3ecc-f6cdf55fb8c4@gmx.com>
Date: Tue, 13 Mar 2018 17:04:23 +0800
MIME-Version: 1.0
In-Reply-To: <b357d3ce-50f3-03e7-5d57-396be9c35565@suse.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="ZnFFDf0G3JMnNpnUBsGNZ4QpEgpVr7KP7"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--ZnFFDf0G3JMnNpnUBsGNZ4QpEgpVr7KP7
Content-Type: multipart/mixed; boundary="DhwpRsyU5pNpM9id6ZuhaYNKXpHmflATx";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: Nikolay Borisov <nborisov@suse.com>, Qu Wenruo <wqu@suse.com>,
 linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz
Message-ID: <f6bdcff3-b8eb-8795-3ecc-f6cdf55fb8c4@gmx.com>
Subject: Re: [PATCH v2 5/7] btrfs-progs: check/lowmem mode: Check inline
 extent size
References: <20180313015616.6574-1-wqu@suse.com>
 <20180313015616.6574-6-wqu@suse.com>
 <b357d3ce-50f3-03e7-5d57-396be9c35565@suse.com>
In-Reply-To: <b357d3ce-50f3-03e7-5d57-396be9c35565@suse.com>

--DhwpRsyU5pNpM9id6ZuhaYNKXpHmflATx
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2018=E5=B9=B403=E6=9C=8813=E6=97=A5 16:39, Nikolay Borisov wrote:
>=20
>=20
> On 13.03.2018 03:56, Qu Wenruo wrote:
>> Signed-off-by: Qu Wenruo <wqu@suse.com>
>> ---
>>  check/mode-lowmem.c | 28 ++++++++++++++++++++++++++++
>>  1 file changed, 28 insertions(+)
>>
>> diff --git a/check/mode-lowmem.c b/check/mode-lowmem.c
>> index 62bcf3d2e126..0d19b373c7af 100644
>> --- a/check/mode-lowmem.c
>> +++ b/check/mode-lowmem.c
>> @@ -1417,6 +1417,8 @@ static int check_file_extent(struct btrfs_root *=
root, struct btrfs_key *fkey,
>>  	u64 csum_found;		/* In byte size, sectorsize aligned */
>>  	u64 search_start;	/* Logical range start we search for csum */
>>  	u64 search_len;		/* Logical range len we search for csum */
>> +	u32 max_inline_extent_size =3D min_t(u32, root->fs_info->sectorsize =
- 1,
>> +				BTRFS_MAX_INLINE_DATA_SIZE(root->fs_info));
>>  	unsigned int extent_type;
>>  	unsigned int is_hole;
>>  	int compressed =3D 0;
>> @@ -1440,6 +1442,32 @@ static int check_file_extent(struct btrfs_root =
*root, struct btrfs_key *fkey,
>>  				root->objectid, fkey->objectid, fkey->offset);
>>  			err |=3D FILE_EXTENT_ERROR;
>>  		}
>> +		if (compressed) {
>> +			if (extent_num_bytes > root->fs_info->sectorsize) {
>> +				error(
>> +"root %llu EXTENT_DATA[%llu %llu] too large inline extent ram size, h=
ave %llu, max: %u",
>> +					root->objectid, fkey->objectid,
>> +					fkey->offset, extent_num_bytes,
>> +					root->fs_info->sectorsize);
> nit: shouldn't this really be sectorsize - 1 ?

Yep.

I'd update the github branch.

Thanks,
Qu

>> +				err |=3D FILE_EXTENT_ERROR;
>> +			}
>> +			if (item_inline_len > max_inline_extent_size) {
>> +				error(
>> +"root %llu EXTENT_DATA[%llu %llu] too large inline extent on-disk siz=
e, have %u, max: %u",
>> +					root->objectid, fkey->objectid,
>> +					fkey->offset, item_inline_len,
>> +					max_inline_extent_size);
>> +				err |=3D FILE_EXTENT_ERROR;
>> +			}
>> +		} else {
>> +			if (extent_num_bytes > max_inline_extent_size) {
>> + 			error(
>> + "root %llu EXTENT_DATA[%llu %llu] too large inline extent size, have=
 %llu, max: %u",
>> + 				root->objectid, fkey->objectid, fkey->offset,
>> + 				extent_num_bytes, max_inline_extent_size);
>> +				err |=3D FILE_EXTENT_ERROR;
>> +			}
>> +		}
>>  		if (!compressed && extent_num_bytes !=3D item_inline_len) {
>>  			error(
>>  		"root %llu EXTENT_DATA[%llu %llu] wrong inline size, have: %llu, ex=
pected: %u",
>>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>=20


--DhwpRsyU5pNpM9id6ZuhaYNKXpHmflATx--

--ZnFFDf0G3JMnNpnUBsGNZ4QpEgpVr7KP7
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQFLBAEBCAA1FiEELd9y5aWlW6idqkLhwj2R86El/qgFAlqnlBcXHHF1d2VucnVv
LmJ0cmZzQGdteC5jb20ACgkQwj2R86El/qi3HAf9E8k98yLapFvoesP0DF6l/nk6
frnecVklwZtSub/C8hkYnow8XrY8yBr01THM/LB1pHVEQzErBTOG93wxUucHpF7f
4w7RBp8CSzAbnIWS/eww61EDvQZomPBNRAmOJ5acgFl1kMa53He3/tC0ZBRYg3VP
wrbCrTAVjck+eHgySa2NcDjSVXM6FGPMgGHzIYCtEmYy25tTqRKWy5Cv2ElLplOa
ksxt4DjcfpTD08z+7tjI0HconRnDFXy8RC87106mqPGxhHAXplYXJNjmq9blntrU
T6alAfh3nz09vKSQ7cNedJyYa2YHfsn555YOEEHyMYyTCT80FeBNNOn+IlCW8Q==
=XFKX
-----END PGP SIGNATURE-----

--ZnFFDf0G3JMnNpnUBsGNZ4QpEgpVr7KP7--
