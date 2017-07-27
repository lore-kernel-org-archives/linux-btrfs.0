Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:49887 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751570AbdG0V3g (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 27 Jul 2017 17:29:36 -0400
Subject: Re: [PATCH 1/3] btrfs-progs: convert: properly handle reserved ranges
 while iterating files
From: Jeff Mahoney <jeffm@suse.com>
To: Qu Wenruo <quwenruo.btrfs@gmx.com>, linux-btrfs@vger.kernel.org
References: <20170725205443.29874-1-jeffm@suse.com>
 <b9faaaad-1d57-918d-2f9a-3f14160d7811@gmx.com>
 <040281e8-680a-561e-1302-771be2eea4e1@suse.com>
Message-ID: <a0220785-58fd-a8aa-cf80-c64d5228ebb0@suse.com>
Date: Thu, 27 Jul 2017 17:29:21 -0400
MIME-Version: 1.0
In-Reply-To: <040281e8-680a-561e-1302-771be2eea4e1@suse.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="vgLRgVngprWmW8w03gXGBL2kQKFqq9Sg9"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--vgLRgVngprWmW8w03gXGBL2kQKFqq9Sg9
Content-Type: multipart/mixed; boundary="Im67PTllhgVP7n8vC3T6G7GKH6VgExI9M";
 protected-headers="v1"
From: Jeff Mahoney <jeffm@suse.com>
To: Qu Wenruo <quwenruo.btrfs@gmx.com>, linux-btrfs@vger.kernel.org
Message-ID: <a0220785-58fd-a8aa-cf80-c64d5228ebb0@suse.com>
Subject: Re: [PATCH 1/3] btrfs-progs: convert: properly handle reserved ranges
 while iterating files
References: <20170725205443.29874-1-jeffm@suse.com>
 <b9faaaad-1d57-918d-2f9a-3f14160d7811@gmx.com>
 <040281e8-680a-561e-1302-771be2eea4e1@suse.com>
In-Reply-To: <040281e8-680a-561e-1302-771be2eea4e1@suse.com>

--Im67PTllhgVP7n8vC3T6G7GKH6VgExI9M
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

On 7/27/17 12:38 PM, Jeff Mahoney wrote:
> On 7/26/17 9:35 PM, Qu Wenruo wrote:
>>
>>
>> On 2017=E5=B9=B407=E6=9C=8826=E6=97=A5 04:54, jeffm@suse.com wrote:
>>> From: Jeff Mahoney <jeffm@suse.com>
>>>
>>> Commit 522ef705e38 (btrfs-progs: convert: Introduce function to calcu=
late
>>> the available space) changed how we handle migrating file data so tha=
t
>>> we never have btrfs space associated with the reserved ranges.  This
>>> works pretty well and when we iterate over the file blocks, the
>>> associations are redirected to the migrated locations.
>>>
>>> This commit missed the case in block_iterate_proc where we just check=

>>> for intersection with a superblock location before looking up a block=

>>> group.  intersect_with_sb checks to see if the range intersects with
>>> a stripe containing a superblock but, in fact, we've reserved the
>>> full 0-1MB range at the start of the disk.  So a file block located
>>> at e.g. 160kB will fall in the reserved region but won't be excepted
>>> in block_iterate_block.  We ultimately hit a BUG_ON when we fail
>>> to look up the block group for that location.
>>
>> The description of the problem  is indeed correct.
>>
>>>
>>> This is reproducible using convert-tests/003-ext4-basic.
>>
>> Thanks for pointing this out, I also reproduced it.
>>
>> While it would be nicer if you could upload a special crafted image as=

>> indicated test case.
>> IIRC the test passed without problem several versions ago, so there ma=
y
>> be some factors preventing the bug from being exposed.
>>
>>>
>>> The fix is to have intersect_with_sb and block_iterate_proc understan=
d
>>> the full size of the reserved ranges.  Since we use the range to
>>> determine the boundary for the block iterator, let's just return the
>>> boundary.  0 isn't a valid boundary and means that we proceed normall=
y
>>> with block group lookup.
>>
>> I'm OK with current fix as it indeed fix the bug and has minimal impac=
t
>> on current code.
>>
>> So feel free to add:
>> Reviewed-by: Qu Wenruo <quwenruo.btrfs@gmx.com>
>>
>> While I think there is a better way to solve it more completely.
>>
>> As when we run into block_iterate_proc(), we have already created
>> ext2_save/image.
>> So we can use the the image as ext2 <-> btrfs position mapping, just a=
s
>> we have already done in record_file_blocks().
>>
>> That's to say, we don't need too much care about the intersection with=

>> reserved range, but just letting record_file_blocks() to handle it wil=
l
>> be good enough.
>>
>> What do you think about this idea?
>=20
> I think you're right.  It should do the mapping already so we don't nee=
d
> to do anything special in block_iterate_proc.  I can test that in a bit=
=2E

So the idea works and, in fact, we could really get rid of most of
block_iterate_proc and still get correct results.  This code is an
optimization so that we can quickly assemble larger extents and not have
to grow on-disk extents repeatedly.  The code as it is does the right
thing most of the time but the boundary condition triggers the barrier
for every block in a migrated range and record_file_blocks must do the
growing.  The end result works fine, it's just slower than it needs to
be for that 0-1MB range.  I'm not sure I care enough to invest the time
to fix that.

-Jeff

> -Jeff
>=20
>> Thanks,
>> Qu
>>
>>>
>>> Cc: Qu Wenruo <quwenruo.btrfs@gmx.com>
>>> Signed-off-by: Jeff Mahoney <jeffm@suse.com>
>>> ---
>>>   convert/source-fs.c | 25 +++++++++++--------------
>>>   1 file changed, 11 insertions(+), 14 deletions(-)
>>>
>>> diff --git a/convert/source-fs.c b/convert/source-fs.c
>>> index 80e4e41..09f6995 100644
>>> --- a/convert/source-fs.c
>>> +++ b/convert/source-fs.c
>>> @@ -28,18 +28,16 @@ const struct simple_range btrfs_reserved_ranges[3=
]
>>> =3D {
>>>       { BTRFS_SB_MIRROR_OFFSET(2), SZ_64K }
>>>   };
>>>   -static int intersect_with_sb(u64 bytenr, u64 num_bytes)
>>> +static u64 intersect_with_reserved(u64 bytenr, u64 num_bytes)
>>>   {
>>>       int i;
>>> -    u64 offset;
>>>   -    for (i =3D 0; i < BTRFS_SUPER_MIRROR_MAX; i++) {
>>> -        offset =3D btrfs_sb_offset(i);
>>> -        offset &=3D ~((u64)BTRFS_STRIPE_LEN - 1);
>>> +    for (i =3D 0; i < ARRAY_SIZE(btrfs_reserved_ranges); i++) {
>>> +        const struct simple_range *range =3D &btrfs_reserved_ranges[=
i];
>>>   -        if (bytenr < offset + BTRFS_STRIPE_LEN &&
>>> -            bytenr + num_bytes > offset)
>>> -            return 1;
>>> +        if (bytenr < range_end(range) &&
>>> +            bytenr + num_bytes >=3D range->start)
>>> +            return range_end(range);
>>>       }
>>>       return 0;
>>>   }
>>> @@ -64,14 +62,14 @@ int block_iterate_proc(u64 disk_block, u64
>>> file_block,
>>>                         struct blk_iterate_data *idata)
>>>   {
>>>       int ret =3D 0;
>>> -    int sb_region;
>>> +    u64 reserved_boundary;
>>>       int do_barrier;
>>>       struct btrfs_root *root =3D idata->root;
>>>       struct btrfs_block_group_cache *cache;
>>>       u64 bytenr =3D disk_block * root->sectorsize;
>>>   -    sb_region =3D intersect_with_sb(bytenr, root->sectorsize);
>>> -    do_barrier =3D sb_region || disk_block >=3D idata->boundary;
>>> +    reserved_boundary =3D intersect_with_reserved(bytenr,
>>> root->sectorsize);
>>> +    do_barrier =3D reserved_boundary || disk_block >=3D idata->bound=
ary;
>>>       if ((idata->num_blocks > 0 && do_barrier) ||
>>>           (file_block > idata->first_block + idata->num_blocks) ||
>>>           (disk_block !=3D idata->disk_block + idata->num_blocks)) {
>>> @@ -91,9 +89,8 @@ int block_iterate_proc(u64 disk_block, u64 file_blo=
ck,
>>>                   goto fail;
>>>           }
>>>   -        if (sb_region) {
>>> -            bytenr +=3D BTRFS_STRIPE_LEN - 1;
>>> -            bytenr &=3D ~((u64)BTRFS_STRIPE_LEN - 1);
>>> +        if (reserved_boundary) {
>>> +            bytenr =3D reserved_boundary;
>>>           } else {
>>>               cache =3D btrfs_lookup_block_group(root->fs_info, byten=
r);
>>>               BUG_ON(!cache);
>>>
>> --=20
>> To unsubscribe from this list: send the line "unsubscribe linux-btrfs"=
 in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>
>=20
>=20


--=20
Jeff Mahoney
SUSE Labs


--Im67PTllhgVP7n8vC3T6G7GKH6VgExI9M--

--vgLRgVngprWmW8w03gXGBL2kQKFqq9Sg9
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG/MacGPG2 v2

iQIVAwUBWXpbMR57S2MheeWyAQj7wQ/9EfgqdkeuVMsTigf/ItkC1PXRGyRkPz7k
QjElYzu5aL38BUzkAjMYCTCMhDBV+pOMDgdnODJ6tKwPAG0eKJ/6SkQoysMVTvRo
6nmHWnNoa92g+SnV0Ex5AtgzDvTsXH70g8sgsvxHYnlK0/UON5H20/hOzXpsE/O/
R0h98aYHyzYcWQzSOoBvkJklRjMN/ibjCJ0MiHNzioxaacUEgFShP5eJ2djiBCJK
oMfBUEafzXWTMNWJeRe/YkMkmGCbibGxUP8o0ehch1dp0wosFHFTkdrDO06gVNDe
nlHJw1MxC4t18MT0UtmY7dC7RlL0L2OoeE+rzqtQdUtdPPA3lg8LSqFRYauqCeXC
hgLak4jZzElYtWq35sLibMRTjhqSVKuml8xeUYgMk9aJ9eCoT1SJeLSNWxrjGpgw
1KfJBRDdgPu92cnNRJApk0RBrydu9i7Ri1PZgpTWTUo6lfb8VwM+auuLr7GKBjo9
okpkL+9Eh0umes75d/1udo8f36CJ4rNmhROvbA+npS6x8Vm+Z9PHlJyAwuGyLxSZ
UWNq7xisuCr5P/e7lfDb89y4/0I4cjrfFhcG/hc0cMeNMdP0fi02gx6kPsXQFlyw
6y+Zl+vnUO6yQ286K/r2w3y+01fXDTBbqA1nf9CJMzwpfX14OBnAqQ3T+yNTH4oW
3X3r9LEasg4=
=W0t/
-----END PGP SIGNATURE-----

--vgLRgVngprWmW8w03gXGBL2kQKFqq9Sg9--
