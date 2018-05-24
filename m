Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.19]:36983 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750718AbeEXECS (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 24 May 2018 00:02:18 -0400
Subject: Re: [PATCH v3 3/4] btrfs: lzo: Add header length check to avoid slab
 out of bounds access
To: Misono Tomohiro <misono.tomohiro@jp.fujitsu.com>, Qu Wenruo <wqu@suse.com>,
        linux-btrfs@vger.kernel.org
References: <20180523082301.29874-1-wqu@suse.com>
 <20180523082301.29874-4-wqu@suse.com>
 <dc3e15b8-0dbb-3a6e-5bec-a95c3fbd7080@jp.fujitsu.com>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <5f114aed-4ed7-0155-fbd7-fc88dcfabeac@gmx.com>
Date: Thu, 24 May 2018 12:01:57 +0800
MIME-Version: 1.0
In-Reply-To: <dc3e15b8-0dbb-3a6e-5bec-a95c3fbd7080@jp.fujitsu.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="ZHgUlLjlyat2ww1eFqK8qAD31KBSwP7TM"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--ZHgUlLjlyat2ww1eFqK8qAD31KBSwP7TM
Content-Type: multipart/mixed; boundary="xL9smAwCCGHfPvnyX9tQbZWrLICqh2hPj";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: Misono Tomohiro <misono.tomohiro@jp.fujitsu.com>, Qu Wenruo
 <wqu@suse.com>, linux-btrfs@vger.kernel.org
Message-ID: <5f114aed-4ed7-0155-fbd7-fc88dcfabeac@gmx.com>
Subject: Re: [PATCH v3 3/4] btrfs: lzo: Add header length check to avoid slab
 out of bounds access
References: <20180523082301.29874-1-wqu@suse.com>
 <20180523082301.29874-4-wqu@suse.com>
 <dc3e15b8-0dbb-3a6e-5bec-a95c3fbd7080@jp.fujitsu.com>
In-Reply-To: <dc3e15b8-0dbb-3a6e-5bec-a95c3fbd7080@jp.fujitsu.com>

--xL9smAwCCGHfPvnyX9tQbZWrLICqh2hPj
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2018=E5=B9=B405=E6=9C=8824=E6=97=A5 10:09, Misono Tomohiro wrote:
> On 2018/05/23 17:23, Qu Wenruo wrote:
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
>>
>> Reported-by: James Harvey <jamespharvey20@gmail.com>
>> Signed-off-by: Qu Wenruo <wqu@suse.com>
>> ---
>>  fs/btrfs/lzo.c | 35 ++++++++++++++++++++++++++++++++++-
>>  1 file changed, 34 insertions(+), 1 deletion(-)
>>
>> diff --git a/fs/btrfs/lzo.c b/fs/btrfs/lzo.c
>> index ec5db393c758..4f4de460b08d 100644
>> --- a/fs/btrfs/lzo.c
>> +++ b/fs/btrfs/lzo.c
>> @@ -293,6 +293,7 @@ static int lzo_decompress_bio(struct list_head *ws=
, struct compressed_bio *cb)
>>  	unsigned long working_bytes;
>>  	size_t in_len;
>>  	size_t out_len;
>> +	size_t max_segment_len =3D lzo1x_worst_compress(PAGE_SIZE);
>>  	unsigned long in_offset;
>>  	unsigned long in_page_bytes_left;
>>  	unsigned long tot_in;
>> @@ -306,6 +307,18 @@ static int lzo_decompress_bio(struct list_head *w=
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
>> +		ret =3D -EUCLEAN;
>> +		goto done;
>> +	}
>> =20
>>  	tot_in =3D LZO_LEN;
>>  	in_offset =3D LZO_LEN;
>=20
> Just 1 line below here is:
>         tot_len =3D min_t(size_t, srclen, tot_len);
> but this is not needed because always tot_len <=3D srclen, considered a=
bove if, right?

Right, github version updated.

Thanks,
Qu


>=20
>> @@ -320,6 +333,17 @@ static int lzo_decompress_bio(struct list_head *w=
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
>> @@ -370,7 +394,7 @@ static int lzo_decompress_bio(struct list_head *ws=
, struct compressed_bio *cb)
>>  			}
>>  		}
>> =20
>> -		out_len =3D lzo1x_worst_compress(PAGE_SIZE);
>> +		out_len =3D max_segment_len;
>>  		ret =3D lzo1x_decompress_safe(buf, in_len, workspace->buf,
>>  					    &out_len);
>>  		if (need_unmap)
>> @@ -380,6 +404,15 @@ static int lzo_decompress_bio(struct list_head *w=
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
>>
>=20
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>=20


--xL9smAwCCGHfPvnyX9tQbZWrLICqh2hPj--

--ZHgUlLjlyat2ww1eFqK8qAD31KBSwP7TM
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEELd9y5aWlW6idqkLhwj2R86El/qgFAlsGOTUACgkQwj2R86El
/qg+hAf9HKt5TF9QlYf56U1M4kzETskw4Y2ExaC5LEXyepG2Sh7qo/RdIAKo5xhQ
2x01F2jEm3w9BxJRyTCGZ8KLh/d4AFd2yVi8P8OrxQZcGLR43TTzbACHmo2xtY+w
oXX5pTSDJKoX12/CqQSzblfGbYXlovpeQEb6QzdTwHa77jI6iKkM583vyp8b4fuA
YzU0OO4Wj9gEnLthruC1SX+O1AFXl2VJ+Earxa4Ip/gzFI0oudBwGKIsww5H/FfW
ba7CfQupk1PA3mbKUW+oRfO8obGtKMpQea5VJP5Mfi7zIIRkaeCt2IAKShk+3aHE
9g0PDgHwxCOuMsnYT2WAJTuihAxfNg==
=mfnH
-----END PGP SIGNATURE-----

--ZHgUlLjlyat2ww1eFqK8qAD31KBSwP7TM--
