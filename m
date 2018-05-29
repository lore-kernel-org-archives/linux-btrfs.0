Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:55584 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751091AbeE2Iv6 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 29 May 2018 04:51:58 -0400
Subject: Re: [PATCH v3 3/4] btrfs: lzo: Add header length check to avoid slab
 out of bounds access
To: Misono Tomohiro <misono.tomohiro@jp.fujitsu.com>,
        linux-btrfs@vger.kernel.org
References: <20180523082301.29874-1-wqu@suse.com>
 <20180523082301.29874-4-wqu@suse.com>
 <826ebc88-4fe8-2298-f022-1c3a9f49151c@jp.fujitsu.com>
From: Qu Wenruo <wqu@suse.de>
Message-ID: <57a16abe-a000-9ba0-c7a4-4d1015cf2384@suse.de>
Date: Tue, 29 May 2018 16:51:51 +0800
MIME-Version: 1.0
In-Reply-To: <826ebc88-4fe8-2298-f022-1c3a9f49151c@jp.fujitsu.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="g6Jw9GF4ABpVkIqVsYFrCDTzmgxRgmkUM"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--g6Jw9GF4ABpVkIqVsYFrCDTzmgxRgmkUM
Content-Type: multipart/mixed; boundary="Tz75Z6whbrOuFfnQy2ugFca2zOkkeAuV9";
 protected-headers="v1"
From: Qu Wenruo <wqu@suse.de>
To: Misono Tomohiro <misono.tomohiro@jp.fujitsu.com>,
 linux-btrfs@vger.kernel.org
Message-ID: <57a16abe-a000-9ba0-c7a4-4d1015cf2384@suse.de>
Subject: Re: [PATCH v3 3/4] btrfs: lzo: Add header length check to avoid slab
 out of bounds access
References: <20180523082301.29874-1-wqu@suse.com>
 <20180523082301.29874-4-wqu@suse.com>
 <826ebc88-4fe8-2298-f022-1c3a9f49151c@jp.fujitsu.com>
In-Reply-To: <826ebc88-4fe8-2298-f022-1c3a9f49151c@jp.fujitsu.com>

--Tz75Z6whbrOuFfnQy2ugFca2zOkkeAuV9
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2018=E5=B9=B405=E6=9C=8829=E6=97=A5 16:30, Misono Tomohiro wrote:
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
>=20
>=20
>> +		/*
>> +		 * Decompressed data length check.
>> +		 * The uncompressed data should not exceed uncompressed extent
>> +		 * size.
>> +		 */
>> +		if (tot_out + out_len > cb->len) {
>> +			ret =3D -EUCLEAN;
>> +			break;
>> +		}
>=20
> I observed this part causes some failure of lzo related xfstests (038, =
056, 103, 138).
>=20
> It seems that when pages to be read start from middle of (shared) exten=
ts,
> they needs to be decompressed from the beginning, and therefore (tot_ou=
t + out_len)
> can exceeds cb->len.
>=20
> Simplified version of btrfs/103 can be used to observe this:
> =3D=3D=3D=3D=3D
>  CLONER=3D/path/to/xfstest/src/cloner
>  mkfs.btrfs -fq $DEV
>  mount -o compress=3Dlzo $DEV /mnt
>=20
>  # make 1 extent (skip 1st 4k)
>  xfs_io -f \
>    -c "pwrite -S 0xaa 4096 4096" \
>    -c "pwrite -S 0xbb 8192 4096" \
>    /mnt/bar > /dev/null 2>&1
>  # clone second half of above extent to beginning of the file
>  $CLONER -s 8192 -d 0 -l 4096 /mnt/foo /mnt/foo
>=20
>  umount /mnt
>  mount $DEV /mnt
>=20
>  # Input/Output error happens
>  od -t x1 /mnt/foo
> =3D=3D=3D=3D=3D
>=20
> btrfs_decompress_buf2page() skips copy if decompressed region is not
> a part of pages to be read. Also, it will copy at most bio->bi_iter.bi_=
size as code says:
>=20
> (compression.c)
> 1183     bio_advance(bio, bytes);
> 1184     if (!bio->bi_iter.bi_size)
> 1185       return 0;
>=20
> cb->len is set to bio->bi_iter.bi_size in btrfs_submit_compressed_read(=
).
>=20
> So, I think it is ok to remove above "if (tot_out + out_len > cb->len)"=
=2E
> Or, should other conditions be checked?

Oh, right.

I just forgot that case.

I'll update the patch to fix it.

Thanks,
Qu

>=20
> Thanks,
> Tomohiro Misono
>=20
>> =20
>>  		buf_start =3D tot_out;
>>  		tot_out +=3D out_len;
>>
>=20
>=20


--Tz75Z6whbrOuFfnQy2ugFca2zOkkeAuV9--

--g6Jw9GF4ABpVkIqVsYFrCDTzmgxRgmkUM
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEELd9y5aWlW6idqkLhwj2R86El/qgFAlsNFKcACgkQwj2R86El
/qhtxwf5AZ4p0Kx5fnKV891GPdadgr1yebtE0hGycuuSaTA4vGsaYKLKXe8M5f9H
5lsAlGEn/3vZlYZhxwEiwwtJAltIB43dLZs3U2MRFoL20K1LQJ93wbZJVT3c0cV7
5JKKc2rOReNTSJG6653k0Dr0OPTPLsCU5LOzJb/lE5aHt/VlKYkJ9ki4FIY8Igaa
R/mwJowxGS3Vs22s1Y6LpaJbvlFZoPaFxS59XLvU6PMUF7yXbQk4djhbS2WUV4J8
CmJzMN1zR+ySh/nAz0egOEkl1pvaq4n6X0kmEUlSgjtfnWe5vzcjVIqormVDL8mX
YtmnBRqPqmvReJXqy3P4xEt3wllBpg==
=8aWu
-----END PGP SIGNATURE-----

--g6Jw9GF4ABpVkIqVsYFrCDTzmgxRgmkUM--
