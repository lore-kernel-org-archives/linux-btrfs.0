Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.15]:50151 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751142AbeCGMPA (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 7 Mar 2018 07:15:00 -0500
Subject: Re: [PATCH 2/2] Btrfs: fix fiemap extent SHARED flag error with range
 clone.
To: Nikolay Borisov <nborisov@suse.com>, robbieko <robbieko@synology.com>
Cc: linux-btrfs@vger.kernel.org, linux-btrfs-owner@vger.kernel.org
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <e08ae323-c757-ee37-20de-767836b9104b@gmx.com>
Date: Wed, 7 Mar 2018 20:14:36 +0800
MIME-Version: 1.0
In-Reply-To: <3b241323-0e2d-7428-ac91-1da3b3221c6a@suse.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="ZxhlcQE5X1tsjCsDq2XpGXHBMxFFf6h6u"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>
References: <1520410819-32405-3-git-send-email-robbieko@synology.com>
 <2ff9062e-54fa-50dd-8efa-352608746bc5@gmx.com>
 <2f3228e8-af87-d0aa-4f35-69e89873026b@gmx.com>
 <25bec3b50fe42a2f816f1391a438f624@synology.com>
 <81760b06-446f-494f-4b0b-dd5e07c76b35@gmx.com>
 <3b241323-0e2d-7428-ac91-1da3b3221c6a@suse.com>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--ZxhlcQE5X1tsjCsDq2XpGXHBMxFFf6h6u
Content-Type: multipart/mixed; boundary="OGYXTKcuZ5daCkHiywkDD7wssrLfNb2D1";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: Nikolay Borisov <nborisov@suse.com>, robbieko <robbieko@synology.com>
Cc: linux-btrfs@vger.kernel.org, linux-btrfs-owner@vger.kernel.org
Message-ID: <e08ae323-c757-ee37-20de-767836b9104b@gmx.com>
Subject: Re: [PATCH 2/2] Btrfs: fix fiemap extent SHARED flag error with range
 clone.
References: <1520410819-32405-1-git-send-email-robbieko@synology.com>
 <1520410819-32405-3-git-send-email-robbieko@synology.com>
 <2ff9062e-54fa-50dd-8efa-352608746bc5@gmx.com>
 <2f3228e8-af87-d0aa-4f35-69e89873026b@gmx.com>
 <25bec3b50fe42a2f816f1391a438f624@synology.com>
 <81760b06-446f-494f-4b0b-dd5e07c76b35@gmx.com>
 <3b241323-0e2d-7428-ac91-1da3b3221c6a@suse.com>
In-Reply-To: <3b241323-0e2d-7428-ac91-1da3b3221c6a@suse.com>

--OGYXTKcuZ5daCkHiywkDD7wssrLfNb2D1
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2018=E5=B9=B403=E6=9C=8807=E6=97=A5 19:27, Nikolay Borisov wrote:
>=20
>=20
> On  7.03.2018 13:18, Qu Wenruo wrote:
>>
>>
>> On 2018=E5=B9=B403=E6=9C=8807=E6=97=A5 19:01, robbieko wrote:
>>> Qu Wenruo =E6=96=BC 2018-03-07 18:42 =E5=AF=AB=E5=88=B0:
>>>> On 2018=E5=B9=B403=E6=9C=8807=E6=97=A5 18:33, Qu Wenruo wrote:
>>>>>
>>>>>
>>>>> On 2018=E5=B9=B403=E6=9C=8807=E6=97=A5 16:20, robbieko wrote:
>>>>>> From: Robbie Ko <robbieko@synology.com>
>>>>>>
>>>>>> [BUG]
>>>>>> Range clone can cause fiemap to return error result.
>>>>>> Like:
>>>>>> =C2=A0# mount /dev/vdb5 /mnt/btrfs
>>>>>> =C2=A0# dd if=3Dev/zero bs=16K count=3D2 oflag=3Ddsync of=3D/mnt/b=
trfs/file
>>>>>> =C2=A0# xfs_io -c "fiemap -v" /mnt/btrfs/file
>>>>>> =C2=A0/mnt/btrfs/file:
>>>>>> =C2=A0EXT: FILE-OFFSET=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 BLOCK-RANGE=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0 TOTAL FLAGS
>>>>>> =C2=A0=C2=A0 0: [0..63]:=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0 4241424..4241487=C2=A0=C2=A0=C2=A0 64=C2=A0=C2=A0 0x1
>>>>>>
>>>>>> =C2=A0# cloner -s $((16*1024)) /mnt/btrfs/file /mnt/btrfs/file_clo=
ne
>>>>>> =C2=A0# xfs_io -c "fiemap -v" /mnt/btrfs/file
>>>>>> =C2=A0/mnt/btrfs/file:
>>>>>> =C2=A0EXT: FILE-OFFSET=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 BLOCK-RANGE=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0 TOTAL FLAGS
>>>>>> =C2=A0=C2=A0 0: [0..63]:=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0 4241424..4241487=C2=A0=C2=A0=C2=A0 64=C2=A0=C2=A0 0x1
>>>>>> =C2=A0If we clone second file extent, we will get error FLAGS,
>>>>>> =C2=A0SHARED bit is not set.
>>>>>>
>>>>>> [REASON]
>>>>>> Btrfs only checks if the first extent in extent map is shared,
>>>>>> but extent may merge.
>>>>>>
>>>>>> [FIX]
>>>>>> Here we will check each extent with extent map range,
>>>>>> if one of them is shared, extent map is shared.
>>>>>>
>>>>>> [PATCH RESULT]
>>>>>> =C2=A0# xfs_io -c "fiemap -v" /mnt/btrfs/file
>>>>>> =C2=A0/mnt/btrfs/file:
>>>>>> =C2=A0EXT: FILE-OFFSET=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 BLOCK-RANGE=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0 TOTAL FLAGS
>>>>>> =C2=A0=C2=A0 0: [0..63]:=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0 4241424..4241487=C2=A0=C2=A0=C2=A0 64 0x2001
>>>>>>
>>>>>> Signed-off-by: Robbie Ko <robbieko@synology.com>
>>>>>> ---
>>>>>> =C2=A0fs/btrfs/extent_io.c | 146
>>>>>> +++++++++++++++++++++++++++++++++++++++++++++------
>>>>>> =C2=A01 file changed, 131 insertions(+), 15 deletions(-)
>>>>>>
>>>>>> diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
>>>>>> index 066b6df..5c6dca9 100644
>>>>>> --- a/fs/btrfs/extent_io.c
>>>>>> +++ b/fs/btrfs/extent_io.c
>>>>>> @@ -4394,8 +4394,8 @@ static int emit_fiemap_extent(struct
>>>>>> fiemap_extent_info *fieinfo,
>>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 */
>>>>>> =C2=A0=C2=A0=C2=A0=C2=A0 if (cache->offset + cache->len=C2=A0 =3Do=
ffset &&
>>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 cache->phys + cac=
he->len =3Dphys=C2=A0 &&
>>>>>> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 (cache->flags & ~FIEMA=
P_EXTENT_LAST) =3D>>>>> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0 (flags & ~FIEMAP_EXTENT_LAST)) {
>>>>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 (cache->flags & ~(FIEM=
AP_EXTENT_LAST|FIEMAP_EXTENT_SHARED)) =3D>>>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 (flags & ~(FIEMAP_EXTENT_LAST|FIE=
MAP_EXTENT_SHARED))) {
>>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 cache->len +=3Den=
;
>>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 cache->flags |=3D=
lags;
>>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 goto try_submit_l=
ast;
>>>>>> @@ -4450,6 +4450,134 @@ static int emit_last_fiemap_cache(struct
>>>>>> btrfs_fs_info *fs_info,
>>>>>> =C2=A0=C2=A0=C2=A0=C2=A0 return ret;
>>>>>> =C2=A0}
>>>>>>
>>>>>> +/*
>>>>>> + * Helper to check the file range is shared.
>>>>>> + *
>>>>>> + * Fiemap extent will be combined with many extents, so we need t=
o
>>>>>> examine
>>>>>> + * each extent, and if shared, the results are shared.
>>>>>> + *
>>>>>> + * Return: 0 if file range is not shared, 1 if it is shared, < 0 =
on
>>>>>> error.
>>>>>> + */
>>>>>> +static int extent_map_check_shared(struct inode *inode, u64 start=
,
>>>>>> u64 end)
>>>>>> +{
>>>>>> +=C2=A0=C2=A0=C2=A0 struct btrfs_fs_info *fs_info =3Dtrfs_sb(inode=
->i_sb);
>>>>>> +=C2=A0=C2=A0=C2=A0 struct btrfs_root *root =3DTRFS_I(inode)->root=
;
>>>>>> +=C2=A0=C2=A0=C2=A0 int ret =3D;
>>>>>> +=C2=A0=C2=A0=C2=A0 struct extent_buffer *leaf;
>>>>>> +=C2=A0=C2=A0=C2=A0 struct btrfs_path *path;
>>>>>> +=C2=A0=C2=A0=C2=A0 struct btrfs_file_extent_item *fi;
>>>>>> +=C2=A0=C2=A0=C2=A0 struct btrfs_key found_key;
>>>>>> +=C2=A0=C2=A0=C2=A0 int check_prev =3D;
>>>>>> +=C2=A0=C2=A0=C2=A0 int extent_type;
>>>>>> +=C2=A0=C2=A0=C2=A0 int shared =3D;
>>>>>> +=C2=A0=C2=A0=C2=A0 u64 cur_offset;
>>>>>> +=C2=A0=C2=A0=C2=A0 u64 extent_end;
>>>>>> +=C2=A0=C2=A0=C2=A0 u64 ino =3Dtrfs_ino(BTRFS_I(inode));
>>>>>> +=C2=A0=C2=A0=C2=A0 u64 disk_bytenr;
>>>>>> +
>>>>>> +=C2=A0=C2=A0=C2=A0 path =3Dtrfs_alloc_path();
>>>>>> +=C2=A0=C2=A0=C2=A0 if (!path) {
>>>>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 return -ENOMEM;
>>>>>> +=C2=A0=C2=A0=C2=A0 }
>>>>>> +
>>>>>> +=C2=A0=C2=A0=C2=A0 cur_offset =3Dtart;
>>>>>> +=C2=A0=C2=A0=C2=A0 while (1) {
>>>>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 ret =3Dtrfs_lookup_fil=
e_extent(NULL, root, path, ino,
>>>>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0 cur_offset, 0);
>>>>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (ret < 0)
>>>>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
 goto error;
>>>>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (ret > 0 && path->s=
lots[0] > 0 && check_prev) {
>>>>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
 leaf =3Dath->nodes[0];
>>>>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
 btrfs_item_key_to_cpu(leaf, &found_key,
>>>>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0 path->slots[0] - 1);
>>>>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
 if (found_key.objectid =3Dino &&
>>>>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0 found_key.type =3DBTRFS_EXTENT_DATA_KEY)
>>>>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0 path->slots[0]--;
>>>>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 }
>>>>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 check_prev =3D;
>>>>>> +next_slot:
>>>>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 leaf =3Dath->nodes[0];=

>>>>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (path->slots[0] >=3D=
trfs_header_nritems(leaf)) {
>>>>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
 ret =3Dtrfs_next_leaf(root, path);
>>>>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
 if (ret < 0)
>>>>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0 goto error;
>>>>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
 if (ret > 0)
>>>>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0 break;
>>>>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
 leaf =3Dath->nodes[0];
>>>>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 }
>>>>>> +
>>>>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 disk_bytenr =3D;
>>>>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 btrfs_item_key_to_cpu(=
leaf, &found_key, path->slots[0]);
>>>>>> +
>>>>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (found_key.objectid=
 > ino)
>>>>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
 break;
>>>>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (WARN_ON_ONCE(found=
_key.objectid < ino) ||
>>>>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
 found_key.type < BTRFS_EXTENT_DATA_KEY) {
>>>>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
 path->slots[0]++;
>>>>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
 goto next_slot;
>>>>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 }
>>>>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (found_key.type > B=
TRFS_EXTENT_DATA_KEY ||
>>>>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
 found_key.offset > end)
>>>>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
 break;
>>>>>> +
>>>>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 fi =3Dtrfs_item_ptr(le=
af, path->slots[0],
>>>>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 struct btrfs_file_extent=
_item);
>>>>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 extent_type =3Dtrfs_fi=
le_extent_type(leaf, fi);
>>>>>> +
>>>>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (extent_type =3DBTR=
FS_FILE_EXTENT_REG ||
>>>>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
 extent_type =3DBTRFS_FILE_EXTENT_PREALLOC) {
>>>>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
 disk_bytenr =3Dtrfs_file_extent_disk_bytenr(leaf, fi);
>>>>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
 extent_end =3Dound_key.offset +
>>>>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0 btrfs_file_extent_num_bytes(leaf, fi);
>>>>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
 if (extent_end <=3Dtart) {
>>>>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0 path->slots[0]++;
>>>>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0 goto next_slot;
>>>>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
 }
>>>>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
 if (disk_bytenr =3D0) {
>>>>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0 path->slots[0]++;
>>>>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0 goto next_slot;
>>>>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
 }
>>>>>> +
>>>>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
 btrfs_release_path(path);
>>>>>> +
>>>>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
 /*
>>>>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0 * As btrfs supports shared space, this information
>>>>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0 * can be exported to userspace tools via
>>>>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0 * flag FIEMAP_EXTENT_SHARED.=C2=A0 If fi_extents_max =3D0
>>>>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0 * then we're just getting a count and we can skip the
>>>>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0 * lookup stuff.
>>>>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0 */
>>>>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
 ret =3Dtrfs_check_shared(root,
>>>>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0 ino, disk_bytenr);
>>>>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
 if (ret < 0)
>>>>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0 goto error;
>>>>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
 if (ret)
>>>>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0 shared =3D;
>>>>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
 ret =3D;
>>>>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
 if (shared) {
>>>>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0 break;
>>>>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
 }
>>>>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 } else if (extent_type=
 =3DBTRFS_FILE_EXTENT_INLINE) {
>>>>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
 extent_end =3Dound_key.offset +
>>>>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0 btrfs_file_extent_inline_len(leaf,
>>>>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0 path->slots[0], fi);
>>>>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
 extent_end =3DLIGN(extent_end, fs_info->sectorsize);
>>>>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
 path->slots[0]++;
>>>>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
 goto next_slot;
>>>>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 } else {
>>>>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
 BUG_ON(1);
>>>>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 }
>>>>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 cur_offset =3Dxtent_en=
d;
>>>>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (cur_offset > end)
>>>>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
 break;
>>>>>> +=C2=A0=C2=A0=C2=A0 }
>>>>>> +
>>>>>> +=C2=A0=C2=A0=C2=A0 ret =3D;
>>>>>> +error:
>>>>>> +=C2=A0=C2=A0=C2=A0 btrfs_free_path(path);
>>>>>> +=C2=A0=C2=A0=C2=A0 return !ret ? shared : ret;
>>>>>> +}
>>>>>> +
>>>>>> =C2=A0int extent_fiemap(struct inode *inode, struct fiemap_extent_=
info
>>>>>> *fieinfo,
>>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 __u64 start, __u6=
4 len, get_extent_t *get_extent)
>>>>>> =C2=A0{
>>>>>> @@ -4587,19 +4715,7 @@ int extent_fiemap(struct inode *inode, stru=
ct
>>>>>> fiemap_extent_info *fieinfo,
>>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0 flags |=3DFIEMAP_EXTENT_DELALLOC |
>>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 FIEMAP_EXTENT_UNKNOWN);
>>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 } else if (fieinf=
o->fi_extents_max) {
>>>>>> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
 u64 bytenr =3Dm->block_start -
>>>>>> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0 (em->start - em->orig_start);
>>>>>> -
>>>>>> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
 /*
>>>>>> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0 * As btrfs supports shared space, this information
>>>>>> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0 * can be exported to userspace tools via
>>>>>> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0 * flag FIEMAP_EXTENT_SHARED.=C2=A0 If fi_extents_max =3D0
>>>>>> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0 * then we're just getting a count and we can skip the
>>>>>> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0 * lookup stuff.
>>>>>> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0 */
>>>>>> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
 ret =3Dtrfs_check_shared(root,
>>>>>> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0 btrfs_ino(BTRFS_I(inode)),
>>>>>> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0 bytenr);
>>>>>
>>>>> Since we're going to use the whole extent to determine the SHARED f=
lags,
>>>>> what about just passing the extent bytenr into btrfs_check_shared?
>>>>>
>>>>> In that case I think we could get correct shared flag without using=

>>>>> another helper function.
>>>>> (IIRC it's em->block_start)
>>>>
>>>> Well, it's not em->block_start, but a little more complex.
>>>> (For compressed one it's em->block_start, but for plaintext one, it'=
s
>>>> more complex)
>>>>
>>>> em->block_start =3Dile_extent_disk_bytenr +
>>>> file_extent_file_extent_offset
>>>>
>>>> We need extra calculation to determine the real extent bytenr
>>>> (file_extent_disk_bytenr).
>>>>
>>>> IIRC the correct calculation would be:
>>>> file_extent_disk_bytenr =3Dm->block_start - em->start + em->orig_sta=
rt.
>>>>
>>>> (Who thought out such anti-human calculation for extent map?!)
>>>>
>>>> Thanks,
>>>> Qu
>>>
>>> dd if=3Dev/zero bs=16K count=3D4 oflag=3Ddsync of=3Dfile
>>>
>>> btrfs-debugfs -f file
>>> (276 0): ram 16384 disk 2171609088 disk_size 16384
>>> (276 16384): ram 16384 disk 2171625472 disk_size 16384
>>> (276 32768): ram 16384 disk 2171641856 disk_size 16384
>>> (276 49152): ram 16384 disk 2171658240 disk_size 16384
>>> file: file extents 4 disk size 65536 logical size 65536 ratio 1.00
>>>
>>> xfs_io -c "fiemap -v" file
>>> file:
>>> =C2=A0EXT: FILE-OFFSET=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 BLOCK-RANGE=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0 TOTAL FLAGS
>>> =C2=A0=C2=A0 0: [0..127]:=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 4=
241424..4241551=C2=A0=C2=A0 128=C2=A0=C2=A0 0x1
>>>
>>> My point is that we have only one extent_map,
>>> but in fact it can correspond to many extents
>>> and each one has the potential to be cloned
>>> so we need to examine each one individually.
>>
>> Right, I missed this point.
>>
>> SHARED flag is determined after extent map merge, so here we can't rel=
y
>> on em here.
>=20
> Shouldn't extent maps correspond to 1:1 disk-state. I.e. they are just
> the memory cache of the extent state. So if we merge them, shouldn't we=

> also merge the on-disk extents as well ?

Not 1:1.

In memory one is merged maybe to save memory.

But on-disk file extents has size limit.
For compressed one it's 128K and 128M for uncompressed one.

And for on-disk file extent size limit, it could be reduce extent
booking space waste and other reasons.


Thanks,
Qu

>=20
>>
>> So the current helper function looks valid, unless we have method to
>> access the original extent map.
>>
>> Thanks,
>> Qu
>>
>>>
>>>
>>>>>
>>>>> Thanks,
>>>>> Qu
>>>>>
>>>>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
 ret =3Dxtent_map_check_shared(inode, em->start,
>>>>>> extent_map_end(em) - 1);
>>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0 if (ret < 0)
>>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 goto out_free;
>>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0 if (ret)
>>>>>> --=20
>>>>>> 1.9.1
>>>>>>
>>>>>> --=20
>>>>>> To unsubscribe from this list: send the line "unsubscribe
>>>>>> linux-btrfs" in
>>>>>> the body of a message to majordomo@vger.kernel.org
>>>>>> More majordomo info at=C2=A0 http://vger.kernel.org/majordomo-info=
=2Ehtml
>>>>>>
>>>>>
>>>
>>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>=20


--OGYXTKcuZ5daCkHiywkDD7wssrLfNb2D1--

--ZxhlcQE5X1tsjCsDq2XpGXHBMxFFf6h6u
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQFLBAEBCAA1FiEELd9y5aWlW6idqkLhwj2R86El/qgFAlqf16wXHHF1d2VucnVv
LmJ0cmZzQGdteC5jb20ACgkQwj2R86El/qjyCAgAnhIsvbI1GzjKGfbGXSELqsXM
tJFoW09eYUBlxDSzEsXp8+l99oxHyrWt1bj28Ac3u0wdDIltbmMP5GHGlCMJl8+P
jyQuveHewaOU4X+7H4Nd1RN+ySYxxrHhrmXxkU6rdUi+IEk/vQNYRYlQxSIyJWWl
cyurw5jt7yg/ygcvZ7pP/DTAByCjlvYKHpW5/a7GyJ4zPm8qYPgIvNzUhFeLOJmQ
JtrW2cw9K8WNGlQyALWU6cmz7fOAI77n6S/j93RYNN9towfA186sgpQi7LY3M+/h
CAA2xZqIuSIxyBYvj8TMZXm9u51BqW5XdiltRY+vo/9zJZhUpk2RFiTntYqPHw==
=clzH
-----END PGP SIGNATURE-----

--ZxhlcQE5X1tsjCsDq2XpGXHBMxFFf6h6u--
