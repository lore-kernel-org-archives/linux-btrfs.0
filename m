Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:60366 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753100AbeEVXie (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 22 May 2018 19:38:34 -0400
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 48134ADCC
        for <linux-btrfs@vger.kernel.org>; Tue, 22 May 2018 23:38:33 +0000 (UTC)
Subject: Re: [PATCH v2 3/4] btrfs: lzo: Add header length check to avoid slab
 out of bounds access
To: dsterba@suse.cz, Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org
References: <20180521051927.3715-1-wqu@suse.com>
 <20180521051927.3715-4-wqu@suse.com> <20180522150636.GN6649@twin.jikos.cz>
From: Qu Wenruo <wqu@suse.de>
Message-ID: <34f13170-f2cb-4efe-7f11-72ce7aa5c622@suse.de>
Date: Wed, 23 May 2018 07:38:28 +0800
MIME-Version: 1.0
In-Reply-To: <20180522150636.GN6649@twin.jikos.cz>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="X4Qc60wPQ5chg6p3Z7OjlBFKJ1YLf4HrF"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--X4Qc60wPQ5chg6p3Z7OjlBFKJ1YLf4HrF
Content-Type: multipart/mixed; boundary="5Edd0N5MOh1lx7ou0Hps3Riwbxhv6wLtc";
 protected-headers="v1"
From: Qu Wenruo <wqu@suse.de>
To: dsterba@suse.cz, Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org
Message-ID: <34f13170-f2cb-4efe-7f11-72ce7aa5c622@suse.de>
Subject: Re: [PATCH v2 3/4] btrfs: lzo: Add header length check to avoid slab
 out of bounds access
References: <20180521051927.3715-1-wqu@suse.com>
 <20180521051927.3715-4-wqu@suse.com> <20180522150636.GN6649@twin.jikos.cz>
In-Reply-To: <20180522150636.GN6649@twin.jikos.cz>

--5Edd0N5MOh1lx7ou0Hps3Riwbxhv6wLtc
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2018=E5=B9=B405=E6=9C=8822=E6=97=A5 23:06, David Sterba wrote:
> On Mon, May 21, 2018 at 01:19:26PM +0800, Qu Wenruo wrote:
>> James Harvey reported that some corrupted compressed extent data can
>> lead to various kernel memory corruption.
>>
>> Such corrupted extent data belongs to inode with NODATASUM flags, thus=

>> data csum won't help us detecting such bug.
>>
>> If lucky enough, kasan could catch it like:
>> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>> BUG: KASAN: slab-out-of-bounds in lzo_decompress_bio+0x384/0x7a0 [btrf=
s]
>> Write of size 4096 at addr ffff8800606cb0f8 by task kworker/u16:0/2338=

>>
>> CPU: 3 PID: 2338 Comm: kworker/u16:0 Tainted: G           O      4.17.=
0-rc5-custom+ #50
>> Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 0.0.0 02/06/2=
015
>> Workqueue: btrfs-endio btrfs_endio_helper [btrfs]
>> Call Trace:
>>  dump_stack+0xc2/0x16b
>>  print_address_description+0x6a/0x270
>>  kasan_report+0x260/0x380
>>  memcpy+0x34/0x50
>>  lzo_decompress_bio+0x384/0x7a0 [btrfs]
>>  end_compressed_bio_read+0x99f/0x10b0 [btrfs]
>>  bio_endio+0x32e/0x640
>>  normal_work_helper+0x15a/0xea0 [btrfs]
>>  process_one_work+0x7e3/0x1470
>>  worker_thread+0x1b0/0x1170
>>  kthread+0x2db/0x390
>>  ret_from_fork+0x22/0x40
>> ...
>> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>>
>> The offending compressed data has the following info:
>>
>> Header:			length 32768		(Looks completely valid)
>> Segment 0 Header:	length 3472882419	(Obvious out of bounds)
>>
>> Then when handling segment 0, since it's over the current page, we nee=
d
>> the compressed data to workspace, then such large size would trigger
>> out-of-bounds memory access, screwing up the whole kernel.
>>
>> Fix it by adding extra checks on header and segment headers to ensure =
we
>> won't access out-of-bounds, and even checks the decompressed data won'=
t
>> be out-of-bounds.
>=20
> Good, feel free to add more if you find them. The BUG_ON in
> lzo_decompress can be replaced by return -EUCLEAN and the total size ca=
n
> be compared with the segment size if they match too.
>=20
>> Reported-by: James Harvey <jamespharvey20@gmail.com>
>> Signed-off-by: Qu Wenruo <wqu@suse.com>
>> ---
>>  fs/btrfs/lzo.c | 35 ++++++++++++++++++++++++++++++++++-
>>  1 file changed, 34 insertions(+), 1 deletion(-)
>>
>> diff --git a/fs/btrfs/lzo.c b/fs/btrfs/lzo.c
>> index d0c6789ff78f..4c75dcba3f04 100644
>> --- a/fs/btrfs/lzo.c
>> +++ b/fs/btrfs/lzo.c
>> @@ -281,6 +281,7 @@ static int lzo_decompress_bio(struct list_head *ws=
, struct compressed_bio *cb)
>>  	unsigned long working_bytes;
>>  	size_t in_len;
>>  	size_t out_len;
>> +	size_t max_segment_len =3D lzo1x_worst_compress(PAGE_SIZE);
>=20
> The value is a compile-time constant, it does not need to be stored in =
a
> variable.

Just to save some long lines, as it's used several times.

>=20
>>  	unsigned long in_offset;
>>  	unsigned long in_page_bytes_left;
>>  	unsigned long tot_in;
>> @@ -294,6 +295,18 @@ static int lzo_decompress_bio(struct list_head *w=
s, struct compressed_bio *cb)
>> =20
>>  	data_in =3D kmap(pages_in[0]);
>>  	tot_len =3D read_compress_length(data_in);
>> +	/*
>> +	 * Compressed data header check.
>> +	 *
>> +	 * The real compressed size can't exceed extent length, and all page=
s
>> +	 * should be used (a full pending page is not possible).
>> +	 * If this happens it means the compressed extent is corrupted.
>> +	 */
>> +	if (tot_len > min_t(size_t, BTRFS_MAX_COMPRESSED, srclen) ||
>> +	    tot_len < srclen - PAGE_SIZE) {
>=20
> All such conditions can be put into unlikely() as this is an error
> handling shortcut.

I'm OK to put it into unlikely().

I'll update this in next version.

Thanks,
Qu

>=20
>> +		ret =3D -EUCLEAN;
>> +		goto done;
>> +	}
>> =20
>>  	tot_in =3D LZO_LEN;
>>  	in_offset =3D LZO_LEN;
>> @@ -308,6 +321,17 @@ static int lzo_decompress_bio(struct list_head *w=
s, struct compressed_bio *cb)
>>  		in_offset +=3D LZO_LEN;
>>  		tot_in +=3D LZO_LEN;
>> =20
>> +		/*
>> +		 * Segment header check.
>> +		 *
>> +		 * The segment length must not exceed max lzo compression
>> +		 * size, nor the total compressed size
>> +		 */
>> +		if (in_len > max_segment_len || tot_in + in_len > tot_len) {
>> +			ret =3D -EUCLEAN;
>> +			goto done;
>> +		}
>> +
>>  		tot_in +=3D in_len;
>>  		working_bytes =3D in_len;
>>  		may_late_unmap =3D need_unmap =3D false;
>> @@ -358,7 +382,7 @@ static int lzo_decompress_bio(struct list_head *ws=
, struct compressed_bio *cb)
>>  			}
>>  		}
>> =20
>> -		out_len =3D lzo1x_worst_compress(PAGE_SIZE);
>> +		out_len =3D max_segment_len;
>>  		ret =3D lzo1x_decompress_safe(buf, in_len, workspace->buf,
>>  					    &out_len);
>>  		if (need_unmap)
>> @@ -368,6 +392,15 @@ static int lzo_decompress_bio(struct list_head *w=
s, struct compressed_bio *cb)
>>  			ret =3D -EIO;
>>  			break;
>>  		}
>> +		/*
>> +		 * Decompressed data length check.
>> +		 * The uncompressed data should not exceed uncompressed extent
>> +		 * size.
>> +		 */
>> +		if (tot_out + out_len > cb->len) {
>> +			ret =3D -EUCLEAN;
>> +			break;
>> +		}
>> =20
>>  		buf_start =3D tot_out;
>>  		tot_out +=3D out_len;
>> --=20
>> 2.17.0
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-btrfs"=
 in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html


--5Edd0N5MOh1lx7ou0Hps3Riwbxhv6wLtc--

--X4Qc60wPQ5chg6p3Z7OjlBFKJ1YLf4HrF
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEELd9y5aWlW6idqkLhwj2R86El/qgFAlsEqfQACgkQwj2R86El
/qi1xAf9Hs9th/2m2MoHPZhWmOtszhJ0mt+wwxOBJczu0mYpp81z8DMQVq9eCOZd
yJsZ0aKmZzdlxUbgmakT+3V26LNMI6PITfOWmrdyFGa/4fUChtOPOM5IMmKwuaeB
L+ifH02vfBXTMjidoYJBnRBZpYpG6wMJF3pBuVHaMDhUnCor7Vp5Ji/O8J84NTQo
EjOSYlxbiKR7Fq72tJtuoK+SwSCw4VFuNgBV3/rfjI4osMXokNW/udkPpZuokXcF
IGWIDpM1qaNU0qS7PGqyx30DDo7pshwUn70fBzCUKu/+Llrh68JbdqYGivfk+XdF
+nSJdWlTq/63noyLEAGUzVgbILoGVg==
=ZnHe
-----END PGP SIGNATURE-----

--X4Qc60wPQ5chg6p3Z7OjlBFKJ1YLf4HrF--
