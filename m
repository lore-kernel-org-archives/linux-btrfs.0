Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.15]:60025 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751130AbeCGLST (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 7 Mar 2018 06:18:19 -0500
Subject: Re: [PATCH 2/2] Btrfs: fix fiemap extent SHARED flag error with range
 clone.
To: robbieko <robbieko@synology.com>
Cc: linux-btrfs@vger.kernel.org, linux-btrfs-owner@vger.kernel.org
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <81760b06-446f-494f-4b0b-dd5e07c76b35@gmx.com>
Date: Wed, 7 Mar 2018 19:18:05 +0800
MIME-Version: 1.0
In-Reply-To: <25bec3b50fe42a2f816f1391a438f624@synology.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="kQDwUPdgswlhRFemwvk9iyV0pit7NeOeo"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>
References: <1520410819-32405-3-git-send-email-robbieko@synology.com>
 <2ff9062e-54fa-50dd-8efa-352608746bc5@gmx.com>
 <2f3228e8-af87-d0aa-4f35-69e89873026b@gmx.com>
 <25bec3b50fe42a2f816f1391a438f624@synology.com>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--kQDwUPdgswlhRFemwvk9iyV0pit7NeOeo
Content-Type: multipart/mixed; boundary="G81fqjn3caQl9LR1yGwH12IPDJxKcoJ1t";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: robbieko <robbieko@synology.com>
Cc: linux-btrfs@vger.kernel.org, linux-btrfs-owner@vger.kernel.org
Message-ID: <81760b06-446f-494f-4b0b-dd5e07c76b35@gmx.com>
Subject: Re: [PATCH 2/2] Btrfs: fix fiemap extent SHARED flag error with range
 clone.
References: <1520410819-32405-1-git-send-email-robbieko@synology.com>
 <1520410819-32405-3-git-send-email-robbieko@synology.com>
 <2ff9062e-54fa-50dd-8efa-352608746bc5@gmx.com>
 <2f3228e8-af87-d0aa-4f35-69e89873026b@gmx.com>
 <25bec3b50fe42a2f816f1391a438f624@synology.com>
In-Reply-To: <25bec3b50fe42a2f816f1391a438f624@synology.com>

--G81fqjn3caQl9LR1yGwH12IPDJxKcoJ1t
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2018=E5=B9=B403=E6=9C=8807=E6=97=A5 19:01, robbieko wrote:
> Qu Wenruo =E6=96=BC 2018-03-07 18:42 =E5=AF=AB=E5=88=B0:
>> On 2018=E5=B9=B403=E6=9C=8807=E6=97=A5 18:33, Qu Wenruo wrote:
>>>
>>>
>>> On 2018=E5=B9=B403=E6=9C=8807=E6=97=A5 16:20, robbieko wrote:
>>>> From: Robbie Ko <robbieko@synology.com>
>>>>
>>>> [BUG]
>>>> Range clone can cause fiemap to return error result.
>>>> Like:
>>>> =C2=A0# mount /dev/vdb5 /mnt/btrfs
>>>> =C2=A0# dd if=3D/dev/zero bs=3D16K count=3D2 oflag=3Ddsync of=3D/mnt=
/btrfs/file
>>>> =C2=A0# xfs_io -c "fiemap -v" /mnt/btrfs/file
>>>> =C2=A0/mnt/btrfs/file:
>>>> =C2=A0EXT: FILE-OFFSET=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 BLOCK-RANGE=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0 TOTAL FLAGS
>>>> =C2=A0=C2=A0 0: [0..63]:=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0 4241424..4241487=C2=A0=C2=A0=C2=A0 64=C2=A0=C2=A0 0x1
>>>>
>>>> =C2=A0# cloner -s $((16*1024)) /mnt/btrfs/file /mnt/btrfs/file_clone=

>>>> =C2=A0# xfs_io -c "fiemap -v" /mnt/btrfs/file
>>>> =C2=A0/mnt/btrfs/file:
>>>> =C2=A0EXT: FILE-OFFSET=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 BLOCK-RANGE=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0 TOTAL FLAGS
>>>> =C2=A0=C2=A0 0: [0..63]:=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0 4241424..4241487=C2=A0=C2=A0=C2=A0 64=C2=A0=C2=A0 0x1
>>>> =C2=A0If we clone second file extent, we will get error FLAGS,
>>>> =C2=A0SHARED bit is not set.
>>>>
>>>> [REASON]
>>>> Btrfs only checks if the first extent in extent map is shared,
>>>> but extent may merge.
>>>>
>>>> [FIX]
>>>> Here we will check each extent with extent map range,
>>>> if one of them is shared, extent map is shared.
>>>>
>>>> [PATCH RESULT]
>>>> =C2=A0# xfs_io -c "fiemap -v" /mnt/btrfs/file
>>>> =C2=A0/mnt/btrfs/file:
>>>> =C2=A0EXT: FILE-OFFSET=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 BLOCK-RANGE=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0 TOTAL FLAGS
>>>> =C2=A0=C2=A0 0: [0..63]:=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0 4241424..4241487=C2=A0=C2=A0=C2=A0 64 0x2001
>>>>
>>>> Signed-off-by: Robbie Ko <robbieko@synology.com>
>>>> ---
>>>> =C2=A0fs/btrfs/extent_io.c | 146
>>>> +++++++++++++++++++++++++++++++++++++++++++++------
>>>> =C2=A01 file changed, 131 insertions(+), 15 deletions(-)
>>>>
>>>> diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
>>>> index 066b6df..5c6dca9 100644
>>>> --- a/fs/btrfs/extent_io.c
>>>> +++ b/fs/btrfs/extent_io.c
>>>> @@ -4394,8 +4394,8 @@ static int emit_fiemap_extent(struct
>>>> fiemap_extent_info *fieinfo,
>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 */
>>>> =C2=A0=C2=A0=C2=A0=C2=A0 if (cache->offset + cache->len=C2=A0 =3D=3D=
 offset &&
>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 cache->phys + cache=
->len =3D=3D phys=C2=A0 &&
>>>> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 (cache->flags & ~FIEMAP_=
EXTENT_LAST) =3D=3D
>>>> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 =
(flags & ~FIEMAP_EXTENT_LAST)) {
>>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 (cache->flags & ~(FIEMAP=
_EXTENT_LAST|FIEMAP_EXTENT_SHARED)) =3D=3D
>>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 =
(flags & ~(FIEMAP_EXTENT_LAST|FIEMAP_EXTENT_SHARED))) {
>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 cache->len +=3D len=
;
>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 cache->flags |=3D f=
lags;
>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 goto try_submit_las=
t;
>>>> @@ -4450,6 +4450,134 @@ static int emit_last_fiemap_cache(struct
>>>> btrfs_fs_info *fs_info,
>>>> =C2=A0=C2=A0=C2=A0=C2=A0 return ret;
>>>> =C2=A0}
>>>>
>>>> +/*
>>>> + * Helper to check the file range is shared.
>>>> + *
>>>> + * Fiemap extent will be combined with many extents, so we need to
>>>> examine
>>>> + * each extent, and if shared, the results are shared.
>>>> + *
>>>> + * Return: 0 if file range is not shared, 1 if it is shared, < 0 on=

>>>> error.
>>>> + */
>>>> +static int extent_map_check_shared(struct inode *inode, u64 start,
>>>> u64 end)
>>>> +{
>>>> +=C2=A0=C2=A0=C2=A0 struct btrfs_fs_info *fs_info =3D btrfs_sb(inode=
->i_sb);
>>>> +=C2=A0=C2=A0=C2=A0 struct btrfs_root *root =3D BTRFS_I(inode)->root=
;
>>>> +=C2=A0=C2=A0=C2=A0 int ret =3D 0;
>>>> +=C2=A0=C2=A0=C2=A0 struct extent_buffer *leaf;
>>>> +=C2=A0=C2=A0=C2=A0 struct btrfs_path *path;
>>>> +=C2=A0=C2=A0=C2=A0 struct btrfs_file_extent_item *fi;
>>>> +=C2=A0=C2=A0=C2=A0 struct btrfs_key found_key;
>>>> +=C2=A0=C2=A0=C2=A0 int check_prev =3D 1;
>>>> +=C2=A0=C2=A0=C2=A0 int extent_type;
>>>> +=C2=A0=C2=A0=C2=A0 int shared =3D 0;
>>>> +=C2=A0=C2=A0=C2=A0 u64 cur_offset;
>>>> +=C2=A0=C2=A0=C2=A0 u64 extent_end;
>>>> +=C2=A0=C2=A0=C2=A0 u64 ino =3D btrfs_ino(BTRFS_I(inode));
>>>> +=C2=A0=C2=A0=C2=A0 u64 disk_bytenr;
>>>> +
>>>> +=C2=A0=C2=A0=C2=A0 path =3D btrfs_alloc_path();
>>>> +=C2=A0=C2=A0=C2=A0 if (!path) {
>>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 return -ENOMEM;
>>>> +=C2=A0=C2=A0=C2=A0 }
>>>> +
>>>> +=C2=A0=C2=A0=C2=A0 cur_offset =3D start;
>>>> +=C2=A0=C2=A0=C2=A0 while (1) {
>>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 ret =3D btrfs_lookup_fil=
e_extent(NULL, root, path, ino,
>>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0 cur_offset, 0);
>>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (ret < 0)
>>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 =
goto error;
>>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (ret > 0 && path->slo=
ts[0] > 0 && check_prev) {
>>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 =
leaf =3D path->nodes[0];
>>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 =
btrfs_item_key_to_cpu(leaf, &found_key,
>>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0 path->slots[0] - 1);
>>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 =
if (found_key.objectid =3D=3D ino &&
>>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0 found_key.type =3D=3D BTRFS_EXTENT_DATA_KEY)
>>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0 path->slots[0]--;
>>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 }
>>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 check_prev =3D 0;
>>>> +next_slot:
>>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 leaf =3D path->nodes[0];=

>>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (path->slots[0] >=3D =
btrfs_header_nritems(leaf)) {
>>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 =
ret =3D btrfs_next_leaf(root, path);
>>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 =
if (ret < 0)
>>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0 goto error;
>>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 =
if (ret > 0)
>>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0 break;
>>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 =
leaf =3D path->nodes[0];
>>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 }
>>>> +
>>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 disk_bytenr =3D 0;
>>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 btrfs_item_key_to_cpu(le=
af, &found_key, path->slots[0]);
>>>> +
>>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (found_key.objectid >=
 ino)
>>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 =
break;
>>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (WARN_ON_ONCE(found_k=
ey.objectid < ino) ||
>>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 =
found_key.type < BTRFS_EXTENT_DATA_KEY) {
>>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 =
path->slots[0]++;
>>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 =
goto next_slot;
>>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 }
>>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (found_key.type > BTR=
FS_EXTENT_DATA_KEY ||
>>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 =
found_key.offset > end)
>>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 =
break;
>>>> +
>>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 fi =3D btrfs_item_ptr(le=
af, path->slots[0],
>>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 struct btrfs_file_extent_it=
em);
>>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 extent_type =3D btrfs_fi=
le_extent_type(leaf, fi);
>>>> +
>>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (extent_type =3D=3D B=
TRFS_FILE_EXTENT_REG ||
>>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 =
extent_type =3D=3D BTRFS_FILE_EXTENT_PREALLOC) {
>>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 =
disk_bytenr =3D btrfs_file_extent_disk_bytenr(leaf, fi);
>>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 =
extent_end =3D found_key.offset +
>>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0 btrfs_file_extent_num_bytes(leaf, fi);
>>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 =
if (extent_end <=3D start) {
>>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0 path->slots[0]++;
>>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0 goto next_slot;
>>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 =
}
>>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 =
if (disk_bytenr =3D=3D 0) {
>>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0 path->slots[0]++;
>>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0 goto next_slot;
>>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 =
}
>>>> +
>>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 =
btrfs_release_path(path);
>>>> +
>>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 =
/*
>>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0 * As btrfs supports shared space, this information
>>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0 * can be exported to userspace tools via
>>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0 * flag FIEMAP_EXTENT_SHARED.=C2=A0 If fi_extents_max =3D=3D 0
>>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0 * then we're just getting a count and we can skip the
>>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0 * lookup stuff.
>>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0 */
>>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 =
ret =3D btrfs_check_shared(root,
>>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
 ino, disk_bytenr);
>>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 =
if (ret < 0)
>>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0 goto error;
>>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 =
if (ret)
>>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0 shared =3D 1;
>>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 =
ret =3D 0;
>>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 =
if (shared) {
>>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0 break;
>>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 =
}
>>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 } else if (extent_type =3D=
=3D BTRFS_FILE_EXTENT_INLINE) {
>>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 =
extent_end =3D found_key.offset +
>>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0 btrfs_file_extent_inline_len(leaf,
>>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0 path->slots[0], fi);
>>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 =
extent_end =3D ALIGN(extent_end, fs_info->sectorsize);
>>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 =
path->slots[0]++;
>>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 =
goto next_slot;
>>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 } else {
>>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 =
BUG_ON(1);
>>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 }
>>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 cur_offset =3D extent_en=
d;
>>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (cur_offset > end)
>>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 =
break;
>>>> +=C2=A0=C2=A0=C2=A0 }
>>>> +
>>>> +=C2=A0=C2=A0=C2=A0 ret =3D 0;
>>>> +error:
>>>> +=C2=A0=C2=A0=C2=A0 btrfs_free_path(path);
>>>> +=C2=A0=C2=A0=C2=A0 return !ret ? shared : ret;
>>>> +}
>>>> +
>>>> =C2=A0int extent_fiemap(struct inode *inode, struct fiemap_extent_in=
fo
>>>> *fieinfo,
>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 __u64 start, __u64 =
len, get_extent_t *get_extent)
>>>> =C2=A0{
>>>> @@ -4587,19 +4715,7 @@ int extent_fiemap(struct inode *inode, struct=

>>>> fiemap_extent_info *fieinfo,
>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0 flags |=3D (FIEMAP_EXTENT_DELALLOC |
>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 FIEMAP_EXTENT_UNKNOWN);
>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 } else if (fieinfo-=
>fi_extents_max) {
>>>> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 =
u64 bytenr =3D em->block_start -
>>>> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0 (em->start - em->orig_start);
>>>> -
>>>> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 =
/*
>>>> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0 * As btrfs supports shared space, this information
>>>> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0 * can be exported to userspace tools via
>>>> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0 * flag FIEMAP_EXTENT_SHARED.=C2=A0 If fi_extents_max =3D=3D 0
>>>> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0 * then we're just getting a count and we can skip the
>>>> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0 * lookup stuff.
>>>> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0 */
>>>> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 =
ret =3D btrfs_check_shared(root,
>>>> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
 btrfs_ino(BTRFS_I(inode)),
>>>> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
 bytenr);
>>>
>>> Since we're going to use the whole extent to determine the SHARED fla=
gs,
>>> what about just passing the extent bytenr into btrfs_check_shared?
>>>
>>> In that case I think we could get correct shared flag without using
>>> another helper function.
>>> (IIRC it's em->block_start)
>>
>> Well, it's not em->block_start, but a little more complex.
>> (For compressed one it's em->block_start, but for plaintext one, it's
>> more complex)
>>
>> em->block_start =3D file_extent_disk_bytenr +
>> file_extent_file_extent_offset
>>
>> We need extra calculation to determine the real extent bytenr
>> (file_extent_disk_bytenr).
>>
>> IIRC the correct calculation would be:
>> file_extent_disk_bytenr =3D em->block_start - em->start + em->orig_sta=
rt.
>>
>> (Who thought out such anti-human calculation for extent map?!)
>>
>> Thanks,
>> Qu
>=20
> dd if=3D/dev/zero bs=3D16K count=3D4 oflag=3Ddsync of=3Dfile
>=20
> btrfs-debugfs -f file
> (276 0): ram 16384 disk 2171609088 disk_size 16384
> (276 16384): ram 16384 disk 2171625472 disk_size 16384
> (276 32768): ram 16384 disk 2171641856 disk_size 16384
> (276 49152): ram 16384 disk 2171658240 disk_size 16384
> file: file extents 4 disk size 65536 logical size 65536 ratio 1.00
>=20
> xfs_io -c "fiemap -v" file
> file:
> =C2=A0EXT: FILE-OFFSET=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 BLOCK-RANGE=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0 TOTAL FLAGS
> =C2=A0=C2=A0 0: [0..127]:=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 424=
1424..4241551=C2=A0=C2=A0 128=C2=A0=C2=A0 0x1
>=20
> My point is that we have only one extent_map,
> but in fact it can correspond to many extents
> and each one has the potential to be cloned
> so we need to examine each one individually.

Right, I missed this point.

SHARED flag is determined after extent map merge, so here we can't rely
on em here.

So the current helper function looks valid, unless we have method to
access the original extent map.

Thanks,
Qu

>=20
>=20
>>>
>>> Thanks,
>>> Qu
>>>
>>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 =
ret =3D extent_map_check_shared(inode, em->start,
>>>> extent_map_end(em) - 1);
>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0 if (ret < 0)
>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0 goto out_free;
>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0 if (ret)
>>>> --=20
>>>> 1.9.1
>>>>
>>>> --=20
>>>> To unsubscribe from this list: send the line "unsubscribe
>>>> linux-btrfs" in
>>>> the body of a message to majordomo@vger.kernel.org
>>>> More majordomo info at=C2=A0 http://vger.kernel.org/majordomo-info.h=
tml
>>>>
>>>
>=20


--G81fqjn3caQl9LR1yGwH12IPDJxKcoJ1t--

--kQDwUPdgswlhRFemwvk9iyV0pit7NeOeo
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQFLBAEBCAA1FiEELd9y5aWlW6idqkLhwj2R86El/qgFAlqfym0XHHF1d2VucnVv
LmJ0cmZzQGdteC5jb20ACgkQwj2R86El/qjmvwf+I/95bxREJJC+5GCK2kxIM9Z8
g7EpUGcK9fMBHf+60tKqjakkro8jsdgFXIh2AmKSPynQ6Pg6dTmgGY+PZmbRTc59
6wW/QCVJrxi2jVPSiNYptkBVNgSVo42SqPgjoPbfpAxH4hey6IVHJopqSzCTUXeT
EEFSA/URAPwF1ABz20UcVjgBYEReb5icUEi4iur1MDMwQdliG0fNOgLIZMRaPxk3
pvAWdPpGcHqoWmLS5hE/DpwfLgSE3EF+Ct910dLmTuH/BaS1COgigzqrTuBZobzg
M9AQnwiN+XZE/Kn8fIxAV+mAonwEGh0WHV0d2rHJGUUOFJKxwyy4fK+ppK5qAQ==
=RM7+
-----END PGP SIGNATURE-----

--kQDwUPdgswlhRFemwvk9iyV0pit7NeOeo--
