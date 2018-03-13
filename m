Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.19]:36687 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751957AbeCMJG6 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 13 Mar 2018 05:06:58 -0400
Subject: Re: [PATCH v2 4/7] btrfs-progs: check/original mode: Check inline
 extent size
To: Nikolay Borisov <nborisov@suse.com>, Qu Wenruo <wqu@suse.com>,
        linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz
References: <20180313015616.6574-1-wqu@suse.com>
 <20180313015616.6574-5-wqu@suse.com>
 <2d0c3fac-7a3b-e3cf-4cef-d7415608382e@suse.com>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <4b39d6d3-28ab-4025-bb06-19c208d34723@gmx.com>
Date: Tue, 13 Mar 2018 17:06:41 +0800
MIME-Version: 1.0
In-Reply-To: <2d0c3fac-7a3b-e3cf-4cef-d7415608382e@suse.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="wX2ZfJgsWXzstSQEdks6SNaXipMyvmHQY"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--wX2ZfJgsWXzstSQEdks6SNaXipMyvmHQY
Content-Type: multipart/mixed; boundary="I8evSVleigKbpur7LcioNkGr22nzyLspZ";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: Nikolay Borisov <nborisov@suse.com>, Qu Wenruo <wqu@suse.com>,
 linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz
Message-ID: <4b39d6d3-28ab-4025-bb06-19c208d34723@gmx.com>
Subject: Re: [PATCH v2 4/7] btrfs-progs: check/original mode: Check inline
 extent size
References: <20180313015616.6574-1-wqu@suse.com>
 <20180313015616.6574-5-wqu@suse.com>
 <2d0c3fac-7a3b-e3cf-4cef-d7415608382e@suse.com>
In-Reply-To: <2d0c3fac-7a3b-e3cf-4cef-d7415608382e@suse.com>

--I8evSVleigKbpur7LcioNkGr22nzyLspZ
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2018=E5=B9=B403=E6=9C=8813=E6=97=A5 16:40, Nikolay Borisov wrote:
>=20
>=20
> On 13.03.2018 03:56, Qu Wenruo wrote:
>> For inline compressed file extent, kernel doesn't allow inline extent
>> ram size larger than sector size and on-disk inline extent size should=

>> not exceed BTRFS_MAX_INLINE_DATA_SIZE().
>>
>> For inline uncompressed file extent, kernel doesn't allow inline exten=
t
>> ram and on-disk size larger than either BTRFS_MAX_INLINE_DATA_SIZE() o=
r
>> sector size.
>>
>> Check it in original mode.
>>
>> Signed-off-by: Qu Wenruo <wqu@suse.com>
>> ---
>>  check/main.c          | 16 ++++++++++++++++
>>  check/mode-original.h |  1 +
>>  2 files changed, 17 insertions(+)
>>
>> diff --git a/check/main.c b/check/main.c
>> index 97baae583f04..7821faa929a3 100644
>> --- a/check/main.c
>> +++ b/check/main.c
>> @@ -560,6 +560,8 @@ static void print_inode_error(struct btrfs_root *r=
oot, struct inode_record *rec)
>>  		fprintf(stderr, ", bad file extent");
>>  	if (errors & I_ERR_FILE_EXTENT_OVERLAP)
>>  		fprintf(stderr, ", file extent overlap");
>> +	if (errors & I_ERR_FILE_EXTENT_TOO_LARGE)
>> +		fprintf(stderr, ", inline file extent too large");
>=20
> offtopic:
>=20
> So in lowmem mode when the error is printed the user is informed what i=
s
> the maximum expected size, but in normal mode this is not case? Why is
> that? I can see other error messages also don't print out expected valu=
es?

The difference is in how different mode handles error.

For normal mode, we use bitmap to indicate error, which can only tell us
what's wrong, but without extra info.

In lowmem mode, we just output the error when we found it, so we have
extra info.

I'm not sure the difference makes sense or not, but at least lowmem mode
is a little more friendly for developer. (For end user, I don't know if
such detailed output would help)


Thanks,
Qu

>=20
>>  	if (errors & I_ERR_FILE_EXTENT_DISCOUNT)
>>  		fprintf(stderr, ", file extent discount");
>>  	if (errors & I_ERR_DIR_ISIZE_WRONG)
>> @@ -1433,6 +1435,8 @@ static int process_file_extent(struct btrfs_root=
 *root,
>>  	u64 disk_bytenr =3D 0;
>>  	u64 extent_offset =3D 0;
>>  	u64 mask =3D root->fs_info->sectorsize - 1;
>> +	u32 max_inline_size =3D min_t(u32, mask,
>> +				BTRFS_MAX_INLINE_DATA_SIZE(root->fs_info));
>>  	int extent_type;
>>  	int ret;
>> =20
>> @@ -1458,9 +1462,21 @@ static int process_file_extent(struct btrfs_roo=
t *root,
>>  	extent_type =3D btrfs_file_extent_type(eb, fi);
>> =20
>>  	if (extent_type =3D=3D BTRFS_FILE_EXTENT_INLINE) {
>> +		u8 compression =3D btrfs_file_extent_compression(eb, fi);
>> +		struct btrfs_item *item =3D btrfs_item_nr(slot);
>> +
>>  		num_bytes =3D btrfs_file_extent_inline_len(eb, slot, fi);
>>  		if (num_bytes =3D=3D 0)
>>  			rec->errors |=3D I_ERR_BAD_FILE_EXTENT;
>> +		if (compression) {
>> +			if (btrfs_file_extent_inline_item_len(eb, item) >
>> +			    max_inline_size ||
>> +			    num_bytes > root->fs_info->sectorsize)
>> +				rec->errors |=3D I_ERR_FILE_EXTENT_TOO_LARGE;
>> +		} else {
>> +			if (num_bytes > max_inline_size)
>> +				rec->errors |=3D I_ERR_FILE_EXTENT_TOO_LARGE;
>> +		}
>>  		rec->found_size +=3D num_bytes;
>>  		num_bytes =3D (num_bytes + mask) & ~mask;
>>  	} else if (extent_type =3D=3D BTRFS_FILE_EXTENT_REG ||
>> diff --git a/check/mode-original.h b/check/mode-original.h
>> index f859af478f0f..368de692fdd1 100644
>> --- a/check/mode-original.h
>> +++ b/check/mode-original.h
>> @@ -185,6 +185,7 @@ struct file_extent_hole {
>>  #define I_ERR_SOME_CSUM_MISSING		(1 << 12)
>>  #define I_ERR_LINK_COUNT_WRONG		(1 << 13)
>>  #define I_ERR_FILE_EXTENT_ORPHAN	(1 << 14)
>> +#define I_ERR_FILE_EXTENT_TOO_LARGE	(1 << 15)
>> =20
>>  struct inode_record {
>>  	struct list_head backrefs;
>>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>=20


--I8evSVleigKbpur7LcioNkGr22nzyLspZ--

--wX2ZfJgsWXzstSQEdks6SNaXipMyvmHQY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQFLBAEBCAA1FiEELd9y5aWlW6idqkLhwj2R86El/qgFAlqnlKEXHHF1d2VucnVv
LmJ0cmZzQGdteC5jb20ACgkQwj2R86El/qgJIwgAqWtIhn3v/evybIhZhU03nw3P
8XmU3voBL/YHcZGoJRmn0ONaGazsHzzMazh7G8VUQ4aFrR9/kKBL1+RXIGnPNEPK
bF1osuEylNM40bEOoypd7vLRStjJfRs95n38NjFz40oQ/4lRENj55MIZ/GHr+22f
+nhy6o9Cb4+zUFr/NZXukADLp5vaC8rW5EMb1FUwU3zOVHrRuO43ys+CyQUi21bG
fbnBldQZQMMdVGc/mNLEfq/AsI65B+5n3VA8Lm9TodkzW9RLYyO6de0pqsdZrGLQ
6kRxZF53iDa49N8N/1luQAjqhY7kzE+Y/VT0YISbYpclOJECoa7dEvR3nuwI7g==
=ZwoV
-----END PGP SIGNATURE-----

--wX2ZfJgsWXzstSQEdks6SNaXipMyvmHQY--
