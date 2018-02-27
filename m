Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.18]:45549 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751677AbeB0LWK (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 27 Feb 2018 06:22:10 -0500
Subject: Re: [PATCH 1/4] btrfs-progs: check: Check data csum for all copies
To: Nikolay Borisov <nborisov@suse.com>, Su Yue <suy.fnst@cn.fujitsu.com>,
        Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz
References: <20180227091259.10877-1-wqu@suse.com>
 <20180227091259.10877-2-wqu@suse.com>
 <241a459e-048b-e872-0e99-dc6263c9a6dd@cn.fujitsu.com>
 <7c580d98-7ac9-0a0e-5f4f-2caeb637becd@gmx.com>
 <523adf98-01bd-eb8b-e0d0-6d105e260f8f@suse.com>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <01a2ad71-43db-680b-addb-0bde1b8df239@gmx.com>
Date: Tue, 27 Feb 2018 19:21:48 +0800
MIME-Version: 1.0
In-Reply-To: <523adf98-01bd-eb8b-e0d0-6d105e260f8f@suse.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="LVLBJGO7U1AtLDKDBa9VOneeG6aD7qxPG"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--LVLBJGO7U1AtLDKDBa9VOneeG6aD7qxPG
Content-Type: multipart/mixed; boundary="cXfdHHurVoN8UhemtNWmvd8uc1S7j3K7G";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: Nikolay Borisov <nborisov@suse.com>, Su Yue <suy.fnst@cn.fujitsu.com>,
 Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz
Message-ID: <01a2ad71-43db-680b-addb-0bde1b8df239@gmx.com>
Subject: Re: [PATCH 1/4] btrfs-progs: check: Check data csum for all copies
References: <20180227091259.10877-1-wqu@suse.com>
 <20180227091259.10877-2-wqu@suse.com>
 <241a459e-048b-e872-0e99-dc6263c9a6dd@cn.fujitsu.com>
 <7c580d98-7ac9-0a0e-5f4f-2caeb637becd@gmx.com>
 <523adf98-01bd-eb8b-e0d0-6d105e260f8f@suse.com>
In-Reply-To: <523adf98-01bd-eb8b-e0d0-6d105e260f8f@suse.com>

--cXfdHHurVoN8UhemtNWmvd8uc1S7j3K7G
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2018=E5=B9=B402=E6=9C=8827=E6=97=A5 19:09, Nikolay Borisov wrote:
>=20
>=20
> On 27.02.2018 12:31, Qu Wenruo wrote:
>>
>>
>> On 2018=E5=B9=B402=E6=9C=8827=E6=97=A5 18:01, Su Yue wrote:
>>>
>>>
>>> On 02/27/2018 05:12 PM, Qu Wenruo wrote:
>>>> Original --check-data-csum option will skip the extra copy if the fi=
rst
>>>> copy matches csum.
>>>>
>>>> Since offline scrub (with recoverability report) is still out-of-tre=
e, at
>>>> least enhance --check-data-csum option to handle multiple copies.
>>>>
>>>> Signed-off-by: Qu Wenruo <wqu@suse.com>
>>>> ---
>>>> =C2=A0 check/main.c | 65
>>>> ++++++++++++++++++++++++++++++------------------------------
>>>> =C2=A0 1 file changed, 32 insertions(+), 33 deletions(-)
>>>>
>>>> diff --git a/check/main.c b/check/main.c
>>>> index 97baae583f04..f25fdc765d63 100644
>>>> --- a/check/main.c
>>>> +++ b/check/main.c
>>>> @@ -5381,42 +5381,37 @@ static int check_extent_csums(struct
>>>> btrfs_root *root, u64 bytenr,
>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (!data)
>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 return -ENOME=
M;
>>>> =C2=A0 +=C2=A0=C2=A0=C2=A0 num_copies =3D btrfs_num_copies(root->fs_=
info, bytenr, num_bytes);
>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 while (offset < num_bytes) {
>>>> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 mirror =3D 0;
>>>> -again:
>>>> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 read_len =3D num_bytes -=
 offset;
>>>> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 /* read as much space on=
ce a time */
>>>> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 ret =3D read_extent_data=
(fs_info, data + offset,
>>>> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0 bytenr + offset, &read_len, mirror);
>>>> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (ret)
>>>> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 =
goto out;
>>>> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 data_checked =3D 0;
>>>> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 /* verify every 4k data'=
s checksum */
>>>> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 while (data_checked < re=
ad_len) {
>>>> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 =
csum =3D ~(u32)0;
>>>> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 =
tmp =3D offset + data_checked;
>>>> -
>>>> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 =
csum =3D btrfs_csum_data((char *)data + tmp,
>>>> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0 csum, fs_info->sectorsize);
>>>> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 =
btrfs_csum_final(csum, (u8 *)&csum);
>>>> -
>>>> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 =
csum_offset =3D leaf_offset +
>>>> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0 tmp / fs_info->sectorsize * csum_size;
>>>> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 =
read_extent_buffer(eb, (char *)&csum_expected,
>>>> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 csum_offs=
et, csum_size);
>>>> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 =
/* try another mirror */
>>>> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 =
if (csum !=3D csum_expected) {
>>>> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0 fprintf(stderr, "mirror %d bytenr %llu csum %u
>>>> expected csum %u\n",
>>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 for (mirror =3D 1; mirro=
r <=3D num_copies; mirror++) {
>>>
>>> Got your point.
>>> But what confuses me is that why mirror starts from 1 here.
>>> The mirror influences btrfs_map_block() which is not related
>>> to this patch though.
>>
>> mirror number has different meanings in fact.
>>
>> For 0, it means try to read *ANY* valid copy, it can be the copy of a
>> duplication, or even rebuilt data from RAID5/6.
>>
>> For 1, it means the fist copy. Either the only copy of
>> SINGLE/RAID0/RAID5/6, or the first copy of RAID1/10.
>>
>> For 2, it means the 2nd copy, it can be real copy for RAID1/RAID10, or=

>> rebuilt data from RAID5/6.
>>
>> And in fact Liu Bo is adding new copy numbers for RAID5/6 to allow us =
to
>> specify how to build the missing data for RAID6.
>>
>> So here starting from mirror 1 is the correct behavior.
>=20
> Shouldn't those be documented?

Makes sense.

I'll add such comment for both kernel and btrfs-progs.

Thanks,
Quuu

>=20
>>
>> Thanks,
>> Qu
>>>
>>> Thanks,
>>> Su
>>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 =
read_len =3D num_bytes - offset;
>>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 =
/* read as much space once a time */
>>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 =
ret =3D read_extent_data(fs_info, data + offset,
>>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 bytenr + offset, &read_len,=
 mirror);
>>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 =
if (ret)
>>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0 goto out;
>>>> +
>>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 =
data_checked =3D 0;
>>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 =
/* verify every 4k data's checksum */
>>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 =
while (data_checked < read_len) {
>>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0 csum =3D ~(u32)0;
>>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0 tmp =3D offset + data_checked;
>>>> +
>>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0 csum =3D btrfs_csum_data((char *)data + tmp,
>>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 csu=
m, fs_info->sectorsize);
>>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0 btrfs_csum_final(csum, (u8 *)&csum);
>>>> +
>>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0 csum_offset =3D leaf_offset +
>>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 tmp / fs_info->sector=
size * csum_size;
>>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0 read_extent_buffer(eb, (char *)&csum_expected,
>>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0 csum_offset, csum_size);
>>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0 if (csum !=3D csum_expected)
>>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 fprintf(stderr,
>>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 =
"mirror %d bytenr %llu csum %u expected csum %u\n",
>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0 mirror, bytenr + tmp,
>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0 csum, csum_expected);
>>>> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0 num_copies =3D btrfs_num_copies(root->fs_info,
>>>> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 byt=
enr, num_bytes);
>>>> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0 if (mirror < num_copies - 1) {
>>>> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 mirror +=3D 1;
>>>> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 goto again;
>>>> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0 }
>>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0 data_checked +=3D fs_info->sectorsize;
>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0 }
>>>> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 =
data_checked +=3D fs_info->sectorsize;
>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 }
>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 offset +=3D r=
ead_len;
>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 }
>>>> @@ -5624,7 +5619,11 @@ static int check_csums(struct btrfs_root *roo=
t)
>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 leaf_offset =3D=
 btrfs_item_ptr_offset(leaf, path.slots[0]);
>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 ret =3D check=
_extent_csums(root, key.offset, data_len,
>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 leaf_offs=
et, leaf);
>>>> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (ret)
>>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 /*
>>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 * Only break for f=
atal errors, if mismatch is found,
>>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 * continue checkin=
g until all extents are checked.
>>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 */
>>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (ret < 0)
>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0 break;
>>>> =C2=A0 skip_csum_check:
>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (!num_byte=
s) {
>>>>
>>>
>>>
>>> --=20
>>> To unsubscribe from this list: send the line "unsubscribe linux-btrfs=
" in
>>> the body of a message to majordomo@vger.kernel.org
>>> More majordomo info at=C2=A0 http://vger.kernel.org/majordomo-info.ht=
ml
>>


--cXfdHHurVoN8UhemtNWmvd8uc1S7j3K7G--

--LVLBJGO7U1AtLDKDBa9VOneeG6aD7qxPG
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQFLBAEBCAA1FiEELd9y5aWlW6idqkLhwj2R86El/qgFAlqVP0wXHHF1d2VucnVv
LmJ0cmZzQGdteC5jb20ACgkQwj2R86El/qhgpggAgJcvN8cpVzMqvz1QR/Tg7/qm
ya9XfzT+j//MHkGkrr1LrdTkW65cwxdnZ1rUOe13hIK/MaUS+20WMTMiIqHIotL3
FwX1dA9shZ11LmVG5d3qi3BxHBvtwNvUP++Msle+kpO3kMono0x8NJfzDjwYAFos
SqDoHSb86ps1NNKCyaMzatDcAUUypkpXroP7jnI2QZpaGhCfUoFMkPtd5mK6/ORj
ftdlOhb8BFHZRl4Eyg8EZAvNSo/VOL6SZD9HPCRL+OBrjBZkUrydNwpKAVZCAjJf
mblsjRq1/KdgJkxOfq35AoxJeJf/eikeID12yaqn2N7gvgGe1ytnA1J4IkDImQ==
=XGUy
-----END PGP SIGNATURE-----

--LVLBJGO7U1AtLDKDBa9VOneeG6aD7qxPG--
