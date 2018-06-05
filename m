Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.15]:43773 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751099AbeFEBF6 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 4 Jun 2018 21:05:58 -0400
Subject: Re: Questions from aspiring btrfs mini-debugger/mini-developer
To: james harvey <jamespharvey20@gmail.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
References: <CA+X5Wn6yTE5+U16fXZZHFrAeybXUDrwjk3DdOJU+OG9qXgFPEw@mail.gmail.com>
 <f790eb48-480c-5798-8b75-847da22b8623@gmx.com>
 <CA+X5Wn5H9643dWbw-YoQ_tLy7Az=EBNLrs1CnDZVv12yOOjrQQ@mail.gmail.com>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <6ac66452-928a-0609-3be5-438dcb67f8e7@gmx.com>
Date: Tue, 5 Jun 2018 09:05:49 +0800
MIME-Version: 1.0
In-Reply-To: <CA+X5Wn5H9643dWbw-YoQ_tLy7Az=EBNLrs1CnDZVv12yOOjrQQ@mail.gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="rbt9JmddiA10RG5v2m9SLI1YuxVSyjzJT"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--rbt9JmddiA10RG5v2m9SLI1YuxVSyjzJT
Content-Type: multipart/mixed; boundary="CT6L9Ih9ENvPtFV5wInC0SmffwoCj136T";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: james harvey <jamespharvey20@gmail.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Message-ID: <6ac66452-928a-0609-3be5-438dcb67f8e7@gmx.com>
Subject: Re: Questions from aspiring btrfs mini-debugger/mini-developer
References: <CA+X5Wn6yTE5+U16fXZZHFrAeybXUDrwjk3DdOJU+OG9qXgFPEw@mail.gmail.com>
 <f790eb48-480c-5798-8b75-847da22b8623@gmx.com>
 <CA+X5Wn5H9643dWbw-YoQ_tLy7Az=EBNLrs1CnDZVv12yOOjrQQ@mail.gmail.com>
In-Reply-To: <CA+X5Wn5H9643dWbw-YoQ_tLy7Az=EBNLrs1CnDZVv12yOOjrQQ@mail.gmail.com>

--CT6L9Ih9ENvPtFV5wInC0SmffwoCj136T
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2018=E5=B9=B406=E6=9C=8805=E6=97=A5 08:27, james harvey wrote:
> On Mon, May 28, 2018 at 8:48 AM, Qu Wenruo <quwenruo.btrfs@gmx.com> wro=
te:
>> On 2018=E5=B9=B405=E6=9C=8828=E6=97=A5 17:21, james harvey wrote:
>>> #29, through btrfs-tree-debug, is:
>>>
>>>         item 49 key (71469 EXTENT_DATA 3768320) itemoff 13232 itemsiz=
e 53
>>>                 generation 218 type 1 (regular)
>>>                 extent data disk byte 2373160960 nr 8384512
>>>                 extent data offset 3764224 nr 425984 ram 8384512
>>>                 extent compression 0 (none)
>>>
>>> Its extents without a data offset (i.e. filefrag #30) look like:
>>>
>>>         item 50 key (71469 EXTENT_DATA 4194304) itemoff 13179 itemsiz=
e 53
>>>                 generation 310 type 1 (regular)
>>>                 extent data disk byte 2445152256 nr 49152
>>>                 extent data offset 0 nr 131072 ram 131072
>>>                 extent compression 2 (lzo)
>>>
>>> So, item 49 is saying there's 8,384,512 bytes on disk, but for this
>>> file extent, only read starting 3,764,224 into the extent_data, and
>>> only read 425,984 bytes?
>>
>> Yep, reading from on-disk logical address 2373160960 + 3764224, len 42=
5984.
>>
>>>  This is a snapshotted file.  At first, I was
>>> thinking this might mean most of this extent had changed, but 425,984=

>>> bytes in the "middle" were the same, so btrfs was re-using that
>>> portion.  Is that's why data_offset is used?
>>
>> Yep.
>=20
> Thanks for taking all the time to respond!  Been working through all
> this (and some other things) since your response.  Few follow-up
> questions.
>=20
> Can a compressed COW file wind up with an offset, like this hypothetica=
l output:

It is completely allowed.
And can be created easily.

	item 6 key (257 EXTENT_DATA 0) itemoff 15816 itemsize 53
		generation 11 type 1 (regular)
		extent data disk byte 13897728 nr 16384
		extent data offset 0 nr 16384 ram 16384
		extent compression 0 (none)
	item 7 key (257 EXTENT_DATA 16384) itemoff 15763 itemsize 53
		generation 9 type 1 (regular)
		extent data disk byte 13893632 nr 4096
		extent data offset 16384 nr 98304 ram 131072 <<<
		extent compression 2 (lzo)
	item 8 key (257 EXTENT_DATA 114688) itemoff 15710 itemsize 53
		generation 11 type 1 (regular)
		extent data disk byte 13914112 nr 16384
		extent data offset 0 nr 16384 ram 16384
		extent compression 0 (none)


>=20
>          item 50 key (71469 EXTENT_DATA 4194304) itemoff 13179 itemsize=
 53
>                  generation 310 type 1 (regular)
>                  extent data disk byte 2445152256 nr 49152
>                  extent data offset 4096 nr 65536 ram 131072
>                  extent compression 2 (lzo)
>=20
> I checked my main volume, and don't see any with compression and an
> offset.  So, I'm thinking it might not be allowed.
>=20
> If it is allowed, things get a bit confusing.  Is the offset for
> on-disk (compressed) data?

No, always for uncompressed data.

>  Would it be reading from on-disk logical
> address 2445152256  + 4096, len 65536 of the compressed data?
>=20
> Or, is the offset for in-memory (uncompressed) data?  If this is the ca=
se, un
>=20
> But, with it being on the second line here (maybe that's just for line
> length though), and being referred to as btrfs_file_extent_offset
> rather than btrfs_file_extent_***disk****_offset, it makes me think
> offset might always be an in memory (uncompressed) offset.

Yep

>=20
> With checksums being on 4k blocks, in theory, it seems to me like
> on-disk offsetting should be able to happen.

Although, csum only works for on-disk data, that to say, for
compression, csum only works for disk_bytenr and disk_len.

>=20
>=20
>>> Am I right that preallocated means no data has actually been written
>>> there?
>>
>> Yes, but space must be allocated for later possible write.
>> That's why we call it pre-allocated.
>=20
> Ahh, I was misunderstanding pre-allocated to mean before allocation.
>=20
>=20
>>> Given an extent_buffer, btrfs_item, slot, and btrfs_file_extent_item,=

>>> if the extent type is BTRFS_FILE_EXTENT_INLINE, how would one get the=

>>> on-disk (so if compressed, in compressed format) data?
>>
>> Read from the leaf.
>> Just as the name inline, the data directly recorded into the leaf, and=

>> there is no need to use disk_bytenr.
>> In fact starting from the offset of where disk_bytenr should be, inlin=
ed
>> data is recorded there directly.
>>
>>>  With
>>> non-inline, non-prealloc extents, I'm using bytenr as location and
>>> num_bytes as length, and code based off btrfs-map-logical, which wind=
s
>>> up using read_extent_data with a mirror number argument, which uses
>>> btrfs_map_block() on that logical address and mirror and pread64() to=

>>> do the read.  For inline data, there's no logical address.
>=20
> Sorry, my question wasn't clear.  Assuming its mirrored, I was
> wondering how to get both copies of the metadata,

You don't really need to care or worry about this.

In theory, you could read out the mirror in btrfs-progs using mirror
number. (0 means the first good copy, 1 means the first copy, 2 means
the second copy for RAID1)

But normally it won't cause anything wrong, as we have checksum for
metadata, thus it won't be a problem.

> which would give
> both copies of the inline data, so the mirrored data could be
> compared.

We have csum for the whole tree block, which means before you could read
anything from the leaf, it must match with its csum.
Thus less possible to cause problem.

>  I've since realized that since it's in the metadata, the
> metadata checksumming which (I think) can't be turned off will cover
> it.  So, there's no need to examine these whatsoever in the context of
> checking for mismatched mirrored data.  A NOCOW/NODATASUM flag on the
> inode would be irrelevant.  Am I right here?

Yep.

>=20
> Does scrub cover inline data marked NOCOW/NODATASUM?

Nope.
Btrfs scrub only checks extent.
For inline data, they don't have any extent. Only the tree leaf
containing the inlined data is an extent.

In that case, btrfs just checks the csum of the tree block.

Further more, since metadata is always CoWed, even we have
NOCOW/NODATASUM flag, it doesn't make any sense for inlined data.

Thanks,
Qu

> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>=20


--CT6L9Ih9ENvPtFV5wInC0SmffwoCj136T--

--rbt9JmddiA10RG5v2m9SLI1YuxVSyjzJT
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEELd9y5aWlW6idqkLhwj2R86El/qgFAlsV4e0ACgkQwj2R86El
/qh8zgf/fhT6otC7m+yfsitxx1loO7V91tUCaQAM4Aa4CYZoMk+7+atvG5kZRRg1
6aHqn+Px2ymNvti1pwD92LlpTleKvjv1wBDoLkNdn37UI47NdtZQY/meotZvxp7N
Uqwu0IdWigRcMAE0/fKS/E1VaCB1l4yVgkcHLZoQfrHZpRKLAjix/EaLO7nCNkiQ
uCc3Bsii6wFuZ1aXYA6OvtdwaY3Nn9BA235rEVXBNRngQxvMDy5nwEMk45+Kq/C0
8TleNJ6MKjdUxLFAjGZCny15asUdoXNxu3jJsegOqbs/P1zivV+l4UcElZ/ZeS/X
7SStaSSOJ9RMni5WMh81/VRUK3A9Tg==
=F1yV
-----END PGP SIGNATURE-----

--rbt9JmddiA10RG5v2m9SLI1YuxVSyjzJT--
