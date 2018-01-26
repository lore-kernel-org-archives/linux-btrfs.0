Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.15]:65294 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752649AbeAZJf4 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 26 Jan 2018 04:35:56 -0500
Subject: Re: [PATCH 02/15] btrfs-progs: lowmem check: find and guess inode
 filetype
To: Su Yue <suy.fnst@cn.fujitsu.com>, linux-btrfs@vger.kernel.org
References: <20180126083519.28373-1-suy.fnst@cn.fujitsu.com>
 <20180126083519.28373-3-suy.fnst@cn.fujitsu.com>
 <cafbed34-4b59-7cc3-3cf9-f52d9e74ba4f@gmx.com>
 <568ca340-ea42-0247-5594-cc75111eb748@cn.fujitsu.com>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <ba26c095-90f6-c96a-eced-11fb5354b1c4@gmx.com>
Date: Fri, 26 Jan 2018 17:35:49 +0800
MIME-Version: 1.0
In-Reply-To: <568ca340-ea42-0247-5594-cc75111eb748@cn.fujitsu.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="I8MKrtbQKttHw2jGJAyAEYXnEhd4U6SZd"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--I8MKrtbQKttHw2jGJAyAEYXnEhd4U6SZd
Content-Type: multipart/mixed; boundary="893luFQCyZHpxSyiIh2t23kb8F7eZDbMm";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: Su Yue <suy.fnst@cn.fujitsu.com>, linux-btrfs@vger.kernel.org
Message-ID: <ba26c095-90f6-c96a-eced-11fb5354b1c4@gmx.com>
Subject: Re: [PATCH 02/15] btrfs-progs: lowmem check: find and guess inode
 filetype
References: <20180126083519.28373-1-suy.fnst@cn.fujitsu.com>
 <20180126083519.28373-3-suy.fnst@cn.fujitsu.com>
 <cafbed34-4b59-7cc3-3cf9-f52d9e74ba4f@gmx.com>
 <568ca340-ea42-0247-5594-cc75111eb748@cn.fujitsu.com>
In-Reply-To: <568ca340-ea42-0247-5594-cc75111eb748@cn.fujitsu.com>

--893luFQCyZHpxSyiIh2t23kb8F7eZDbMm
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2018=E5=B9=B401=E6=9C=8826=E6=97=A5 17:31, Su Yue wrote:
>=20
>=20
> On 01/26/2018 05:14 PM, Qu Wenruo wrote:
>>
>>
>> On 2018=E5=B9=B401=E6=9C=8826=E6=97=A5 16:35, Su Yue wrote:
>>> Introduce find_file_type_lowmem() and guess_file_type_lowmem().
>>>
>>> find_file_type_lowmem() gets filetypes from inode_item, dir_item and
>>> dir_index. If two of three's filetype are same and valid, it thinks
>>> the value is correct.
>>>
>>> guess_file_type_lowmem() searches file_extent and dir_item/index then=

>>> returns with filetype.
>>>
>>> Signed-off-by: Su Yue <suy.fnst@cn.fujitsu.com>
>>> ---
>>> =C2=A0 cmds-check.c | 193
>>> +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
>>> =C2=A0 1 file changed, 193 insertions(+)
>>>
>>> diff --git a/cmds-check.c b/cmds-check.c
>>> index e3505a7f9d6b..b200fdccf0e5 100644
>>> --- a/cmds-check.c
>>> +++ b/cmds-check.c
>>> @@ -3306,6 +3306,199 @@ static int find_file_type(struct inode_record=

>>> *rec, u8 *type)
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 return -ENOENT;
>>> =C2=A0 }
>>> =C2=A0 +/*
>>> + * Fetch filetype from exited completed dir_item, dir_index and
>>> inode_item.
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0 ^^^^^^
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0 existing?
>=20
> Oh.. a Typo.
>>> + * If two of tree items'filetype are same, we think the type is
>>> trusted.
>>> + *
>>> + * Return 0 if file type is found and BTRFS_FT_* is stored into type=
=2E
>>> + * Return <0 if file type is not found.
>>
>> This also includes extra error like -EIO from btrfs_search_slot().
>>
>>> + */
>>> +static int find_file_type_lowmem(struct btrfs_root *root, u64 ino,
>>> u8 *type)
>>> +{
>>> +=C2=A0=C2=A0=C2=A0 struct btrfs_key key;
>>> +=C2=A0=C2=A0=C2=A0 struct btrfs_path path;
>>> +=C2=A0=C2=A0=C2=A0 struct btrfs_path path2;
>>> +=C2=A0=C2=A0=C2=A0 struct btrfs_inode_ref *iref;
>>> +=C2=A0=C2=A0=C2=A0 struct btrfs_dir_item *dir_item;
>>> +=C2=A0=C2=A0=C2=A0 struct btrfs_dir_item *dir_index;
>>> +=C2=A0=C2=A0=C2=A0 struct extent_buffer *eb;
>>> +=C2=A0=C2=A0=C2=A0 u64 dir;
>>> +=C2=A0=C2=A0=C2=A0 u64 index;
>>> +=C2=A0=C2=A0=C2=A0 char namebuf[BTRFS_NAME_LEN] =3D {0};
>>> +=C2=A0=C2=A0=C2=A0 u32 namelen;
>>> +=C2=A0=C2=A0=C2=A0 u8 inode_filetype =3D BTRFS_FT_UNKNOWN;
>>> +=C2=A0=C2=A0=C2=A0 u8 dir_item_filetype;
>>> +=C2=A0=C2=A0=C2=A0 u8 dir_index_filetype;
>>> +=C2=A0=C2=A0=C2=A0 u8 true_file_type;
>>> +=C2=A0=C2=A0=C2=A0 int slot;
>>> +=C2=A0=C2=A0=C2=A0 int ret;
>>> +
>>> +=C2=A0=C2=A0=C2=A0 key.objectid =3D ino;
>>> +=C2=A0=C2=A0=C2=A0 key.type =3D BTRFS_INODE_ITEM_KEY;
>>> +=C2=A0=C2=A0=C2=A0 key.offset =3D 0;
>>> +
>>> +=C2=A0=C2=A0=C2=A0 btrfs_init_path(&path);
>>> +=C2=A0=C2=A0=C2=A0 ret =3D btrfs_search_slot(NULL, root, &key, &path=
, 0, 0);
>>> +=C2=A0=C2=A0=C2=A0 if (ret < 0)
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 goto out;
>>> +=C2=A0=C2=A0=C2=A0 if (!ret) {
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 struct btrfs_inode_item *=
ii;
>>> +
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 ii =3D btrfs_item_ptr(pat=
h.nodes[0], path.slots[0],
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 struct btrfs_inode_item);
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 inode_filetype =3D imode_=
to_type(btrfs_inode_mode(path.nodes[0],
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 ii));
>>> +=C2=A0=C2=A0=C2=A0 }
>>> +
>>> +=C2=A0=C2=A0=C2=A0 key.objectid =3D ino;
>>> +=C2=A0=C2=A0=C2=A0 key.type =3D BTRFS_INODE_REF_KEY;
>>> +=C2=A0=C2=A0=C2=A0 key.offset =3D (u64)-1;
>>> +
>>> +=C2=A0=C2=A0=C2=A0 btrfs_release_path(&path);
>>> +=C2=A0=C2=A0=C2=A0 ret =3D btrfs_search_slot(NULL, root, &key, &path=
, 0, 0);
>>> +=C2=A0=C2=A0=C2=A0 if (ret < 0)
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 goto out;
>>> +=C2=A0=C2=A0=C2=A0 if (!ret) {
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 ret =3D -EIO;
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 goto out;
>>> +=C2=A0=C2=A0=C2=A0 }
>>> +
>>> +=C2=A0=C2=A0=C2=A0 btrfs_init_path(&path2);
>>> +next:
>>> +=C2=A0=C2=A0=C2=A0 btrfs_release_path(&path2)> +=C2=A0=C2=A0=C2=A0 r=
et =3D btrfs_previous_item(root,
>>> &path, ino, BTRFS_INODE_REF_KEY);
>>> +=C2=A0=C2=A0=C2=A0 if (ret) {
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 ret =3D -ENOENT;
>>
>> For ret < 0 case, return value is overwritten.
>>
> Will fix it.
>>
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 goto out;
>>> +=C2=A0=C2=A0=C2=A0 }
>>> +
>>> +=C2=A0=C2=A0=C2=A0 eb =3D path.nodes[0];
>>> +=C2=A0=C2=A0=C2=A0 slot =3D path.slots[0];
>>> +=C2=A0=C2=A0=C2=A0 btrfs_item_key_to_cpu(eb, &key, slot);
>>> +=C2=A0=C2=A0=C2=A0 dir =3D key.offset;
>>> +=C2=A0=C2=A0=C2=A0 iref =3D btrfs_item_ptr(eb, slot, struct btrfs_in=
ode_ref);
>>> +=C2=A0=C2=A0=C2=A0 index =3D btrfs_inode_ref_index(eb, iref);
>>> +=C2=A0=C2=A0=C2=A0 namelen =3D btrfs_inode_ref_name_len(eb, iref);
>>> +=C2=A0=C2=A0=C2=A0 read_extent_buffer(eb, namebuf, (unsigned long)(i=
ref + 1),
>>> namelen);
>>> +
>>> +=C2=A0=C2=A0=C2=A0 dir_index =3D btrfs_lookup_dir_index(NULL, root, =
&path2, dir,
>>> namebuf,
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 namelen, =
index, 0);
>>> +=C2=A0=C2=A0=C2=A0 if (!dir_index)
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 goto next;
>>> +=C2=A0=C2=A0=C2=A0 dir_index_filetype =3D btrfs_dir_type(path2.nodes=
[0], dir_index);
>>> +=C2=A0=C2=A0=C2=A0 btrfs_release_path(&path2);
>>> +=C2=A0=C2=A0=C2=A0 if (dir_index_filetype =3D=3D inode_filetype) {
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 true_file_type =3D inode_=
filetype;
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 goto found;
>>> +=C2=A0=C2=A0=C2=A0 }
>>> +
>>> +=C2=A0=C2=A0=C2=A0 dir_item =3D btrfs_lookup_dir_item(NULL, root, &p=
ath2, dir, namebuf,
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 namelen, 0);
>>> +=C2=A0=C2=A0=C2=A0 if (!dir_item)
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 goto next;
>>> +=C2=A0=C2=A0=C2=A0 dir_item_filetype =3D btrfs_dir_type(path2.nodes[=
0], dir_item);
>>> +=C2=A0=C2=A0=C2=A0 btrfs_release_path(&path2);
>>> +=C2=A0=C2=A0=C2=A0 if (dir_item_filetype =3D=3D inode_filetype) {
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 true_file_type =3D inode_=
filetype;
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 goto found;
>>> +=C2=A0=C2=A0=C2=A0 }
>>> +
>>> +=C2=A0=C2=A0=C2=A0 if (dir_index_filetype =3D=3D dir_item_filetype) =
{
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 true_file_type =3D dir_in=
dex_filetype;
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 goto found;
>>> +=C2=A0=C2=A0=C2=A0 }
>>> +=C2=A0=C2=A0=C2=A0 goto next;
>>> +found:
>>> +=C2=A0=C2=A0=C2=A0 /* rare case, two of three items are both corrupt=
ed */
>>> +=C2=A0=C2=A0=C2=A0 if (true_file_type =3D=3D BTRFS_FT_UNKNOWN ||
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 true_file_type >=3D BTRFS=
_FT_MAX)
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 goto next;
>>> +=C2=A0=C2=A0=C2=A0 *type =3D true_file_type;
>>> +=C2=A0=C2=A0=C2=A0 ret =3D 0;
>>> +out:
>>> +=C2=A0=C2=A0=C2=A0 btrfs_release_path(&path);
>>> +=C2=A0=C2=A0=C2=A0 return ret;
>>> +}
>>> +
>>> +static int find_normal_file_extent(struct btrfs_root *root, u64 ino)=
;
>>> +/*
>>> + * Try to determine inode type if type not found.
>>> + *
>>> + * For found regular file extent, it must be FILE.
>>> + * For found dir_item/index, it must be DIR.
>>> + *
>>> + * Return 0 if file type is confirmed and BTRFS_FT_* is stored into
>>> type.
>>> + * Return <0 if file type is unknown.
>>> + */
>>> +static int guess_file_type_lowmem(struct btrfs_root *root, u64 ino,
>>> u8 *type)
>>> +{
>>> +=C2=A0=C2=A0=C2=A0 struct btrfs_key key;
>>> +=C2=A0=C2=A0=C2=A0 struct btrfs_path *path =3D NULL;
>>> +=C2=A0=C2=A0=C2=A0 bool is_dir =3D false;
>>> +=C2=A0=C2=A0=C2=A0 bool is_file =3D false;
>>> +=C2=A0=C2=A0=C2=A0 int ret;
>>> +
>>> +=C2=A0=C2=A0=C2=A0 if (find_normal_file_extent(root, ino)) {
>>
>> Nice reusing the existing code.
>>
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 is_file =3D true;
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 goto out;
>>> +=C2=A0=C2=A0=C2=A0 }
>>> +
>>> +=C2=A0=C2=A0=C2=A0 key.objectid =3D ino;
>>> +=C2=A0=C2=A0=C2=A0 key.type =3D BTRFS_DIR_ITEM_KEY;
>>
>> You could merge the code together, using just one loop instead of usin=
g
>> two search separately for DIR_ITEM and DIR_INDEX.
>>
>> Search for key (ino, DIR_INDEX, -1), as DIR_INDEX is larger than
>> DIR_ITEM.
>>
>> And search backward, not using btrfs_previous_item() but manually
>> checking the type (and do prev_leaf() manually).
>> It should save you several lines.
>>
> I have thought up this way. I prefer to call btrfs_previous_item()
> instead because it make code more readable and manually move path
> pointer is pretty tricky.

Double btrfs_previous_item() call would save you.

Although you need to pay extra attention after first
btrfs_previous_item() found no DIR_INDEX items.

In that case, you need to manually check the key type before call
btrfs_preivous_item() for DIR_ITEM.

Thanks,
Qu

>=20
> Since your suggestion is more efficient, I will do it in next version.
>=20
> Thanks,
> Su
>=20
>> Thanks,
>> Qu
>>
>>> +=C2=A0=C2=A0=C2=A0 key.offset =3D (u64)-1;
>>> +
>>> +=C2=A0=C2=A0=C2=A0 path =3D btrfs_alloc_path();
>>> +=C2=A0=C2=A0=C2=A0 if (!path)
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 goto out;
>>> +=C2=A0=C2=A0=C2=A0 ret =3D btrfs_search_slot(NULL, root, &key, path,=
 0, 0);
>>> +=C2=A0=C2=A0=C2=A0 if (ret < 0)
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 goto out;
>>> +=C2=A0=C2=A0=C2=A0 /*
>>> +=C2=A0=C2=A0=C2=A0=C2=A0 * (u64)-1 may hit the hashed value in offse=
t.
>>> +=C2=A0=C2=A0=C2=A0=C2=A0 */
>>> +=C2=A0=C2=A0=C2=A0 if (!ret) {
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 is_dir =3D true;
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 goto out;
>>> +=C2=A0=C2=A0=C2=A0 }
>>> +
>>> +=C2=A0=C2=A0=C2=A0 ret =3D btrfs_previous_item(root, path, ino, BTRF=
S_DIR_ITEM_KEY);>
>>> +=C2=A0=C2=A0=C2=A0 if (!ret) {
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 is_dir =3D true;
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 goto out;
>>> +=C2=A0=C2=A0=C2=A0 }
>>> +
>>> +=C2=A0=C2=A0=C2=A0 key.type =3D BTRFS_DIR_INDEX_KEY;
>>> +=C2=A0=C2=A0=C2=A0 key.offset =3D (u64)-1;
>>> +
>>> +=C2=A0=C2=A0=C2=A0 btrfs_release_path(path);
>>> +=C2=A0=C2=A0=C2=A0 ret =3D btrfs_search_slot(NULL, root, &key, path,=
 0, 0);
>>> +=C2=A0=C2=A0=C2=A0 if (ret < 0)
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 goto out;
>>> +=C2=A0=C2=A0=C2=A0 if (!ret) {
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 is_dir =3D true;
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 goto out;
>>> +=C2=A0=C2=A0=C2=A0 }
>>> +=C2=A0=C2=A0=C2=A0 ret =3D btrfs_previous_item(root, path, ino, BTRF=
S_DIR_INDEX_KEY);
>>> +=C2=A0=C2=A0=C2=A0 if (!ret) {
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 is_dir =3D true;
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 goto out;
>>> +=C2=A0=C2=A0=C2=A0 }
>>> +out:
>>> +=C2=A0=C2=A0=C2=A0 if (path)
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 btrfs_release_path(path);=

>>> +
>>> +=C2=A0=C2=A0=C2=A0 if (is_dir) {
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 *type =3D BTRFS_FT_DIR;
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 ret =3D 0;
>>> +=C2=A0=C2=A0=C2=A0 } else if (is_file) {
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 *type =3D BTRFS_FT_REG_FI=
LE;
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 ret =3D 0;
>>> +=C2=A0=C2=A0=C2=A0 } else {
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 ret =3D -ENOENT;
>>> +=C2=A0=C2=A0=C2=A0 }
>>> +=C2=A0=C2=A0=C2=A0 return ret;
>>> +}
>>> +
>>> =C2=A0 /*
>>> =C2=A0=C2=A0 * To determine the file name for nlink repair
>>> =C2=A0=C2=A0 *
>>>
>>
>=20
>=20


--893luFQCyZHpxSyiIh2t23kb8F7eZDbMm--

--I8MKrtbQKttHw2jGJAyAEYXnEhd4U6SZd
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQFLBAEBCAA1FiEELd9y5aWlW6idqkLhwj2R86El/qgFAlpq9nUXHHF1d2VucnVv
LmJ0cmZzQGdteC5jb20ACgkQwj2R86El/qgEygf+KOSZTSZInePyKwYLAiT3oeGc
bXeRWc5KR2Ad8zYgbGJKf93aM4atAoqgkyPJwMjPY4OU+yMiPXa2bJ/CX2BMBnz4
WLTs5bWVgXijjqTEEi3J+Kchh/NX/YlSEMGJZoGVv3IhUXfyIcenzxPUmYE1zrAK
Qpf0LJmAr+bzviDhPpJnCvGBbNJ8b8vnKeVgUyKuvvZUPl0x759QKrEt0fPkgxcE
Ac/Eky+BG6ORXcupo/Ud7r2dprXT3PvaYoHERMneyKPEmiQBy7Mnztt2xxsDP336
2Vk6YDB+vUKkuJKlxhCZgt+b851GYKOnUmotPkJkN6yuWOpnqL5a4dPy7dNSRQ==
=YZgS
-----END PGP SIGNATURE-----

--I8MKrtbQKttHw2jGJAyAEYXnEhd4U6SZd--
