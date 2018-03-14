Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.18]:56803 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751612AbeCNKyZ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 14 Mar 2018 06:54:25 -0400
Subject: Re: [PATCH 1/2] Btrfs-progs: check, fix false error reports for
 shared prealloc extents
To: Filipe Manana <fdmanana@kernel.org>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
References: <20180313184700.30173-1-fdmanana@kernel.org>
 <4287f45b-cfac-7188-51b2-1647b230f584@gmx.com>
 <CAL3q7H6jJ0Sfu6jWgAZaARgka=+KreSUCC-LqkGH3HaDrO3WRA@mail.gmail.com>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <d5f9313f-fec4-c5a2-ddfe-55b02cac84a4@gmx.com>
Date: Wed, 14 Mar 2018 18:54:16 +0800
MIME-Version: 1.0
In-Reply-To: <CAL3q7H6jJ0Sfu6jWgAZaARgka=+KreSUCC-LqkGH3HaDrO3WRA@mail.gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="YefTsNnVgB7XaRJTXTcG1FHQ8nUgJAKV0"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--YefTsNnVgB7XaRJTXTcG1FHQ8nUgJAKV0
Content-Type: multipart/mixed; boundary="ZDT7j4qxldrhhvPUZOLF5gc8oZfdAPLM1";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: Filipe Manana <fdmanana@kernel.org>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
Message-ID: <d5f9313f-fec4-c5a2-ddfe-55b02cac84a4@gmx.com>
Subject: Re: [PATCH 1/2] Btrfs-progs: check, fix false error reports for
 shared prealloc extents
References: <20180313184700.30173-1-fdmanana@kernel.org>
 <4287f45b-cfac-7188-51b2-1647b230f584@gmx.com>
 <CAL3q7H6jJ0Sfu6jWgAZaARgka=+KreSUCC-LqkGH3HaDrO3WRA@mail.gmail.com>
In-Reply-To: <CAL3q7H6jJ0Sfu6jWgAZaARgka=+KreSUCC-LqkGH3HaDrO3WRA@mail.gmail.com>

--ZDT7j4qxldrhhvPUZOLF5gc8oZfdAPLM1
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2018=E5=B9=B403=E6=9C=8814=E6=97=A5 18:33, Filipe Manana wrote:
> On Wed, Mar 14, 2018 at 1:32 AM, Qu Wenruo <quwenruo.btrfs@gmx.com> wro=
te:
>>
>>
>> On 2018=E5=B9=B403=E6=9C=8814=E6=97=A5 02:47, fdmanana@kernel.org wrot=
e:
>>> From: Filipe Manana <fdmanana@suse.com>
>>>
>>> Under some cases the filesystem checker reports an error when it find=
s
>>> checksum items for an extent that is referenced by an inode as a prea=
lloc
>>> extent. Such cases are not an error when the extent is actually share=
d
>>> (was cloned/reflinked) with other inodes and was written through one =
of
>>> those other inodes.
>>>
>>> Example:
>>>
>>>   $ mkfs.btrfs -f /dev/sdb
>>>   $ mount /dev/sdb /mnt
>>>
>>>   $ touch /mnt/foo
>>>   $ xfs_io -c "falloc 0 256K" /mnt/foo
>>>   $ sync
>>>
>>>   $ xfs_io -c "pwrite -S 0xab -b 0 256K" /mnt/foo
>>>   $ touch /mnt/bar
>>>   $ xfs_io -c "reflink /mnt/foo 0 0 256K" /mnt/bar
>>>   $ xfs_io -c "fsync" /mnt/bar
>>>
>>>   <power fail>
>>>   $ mount /dev/sdb /mnt
>>>   $ umount /mnt
>>>
>>>   $ btrfs check /dev/sdc
>>>   Checking filesystem on /dev/sdb
>>>   UUID: 52d3006e-ee3b-40eb-aa21-e56253a03d39
>>>   checking extents
>>>   checking free space cache
>>>   checking fs roots
>>>   root 5 inode 257 errors 800, odd csum item
>>>   ERROR: errors found in fs roots
>>>   found 688128 bytes used, error(s) found
>>>   total csum bytes: 256
>>>   total tree bytes: 163840
>>>   total fs tree bytes: 65536
>>>   total extent tree bytes: 16384
>>>   btree space waste bytes: 138819
>>>   file data blocks allocated: 10747904
>>>    referenced 10747904
>>>   $ echo $?
>>>   1
>>>
>>> So tech check to not report such cases as errors by checking if the
>>> extent is shared with other inodes and if so, consider it an error th=
e
>>> existence of checksum items only if all those other inodes are refere=
ncing
>>> the extent as a prealloc extent.
>>> This case can be hit often when running the generic/475 testcase from=

>>> fstests.
>>>
>>> A test case will follow in a separate patch.
>>>
>>> Signed-off-by: Filipe Manana <fdmanana@suse.com>
>>
>> Looks good overall, but still some small nitpicks.
>>
>> One is, the fix is only for original mode, while the fix itself has
>> nothing mode dependent, so it's better to put the check into
>> check/mode-original.[ch] so lowmem mode can also benefit from it.
>=20
> Ok, I started doing development on a release branch where the split
> doesn't exist, them moved to the development branch and wrongly
> assumed that shared code would be in main.c.
>>
>>> ---
>>>  check/main.c | 270 +++++++++++++++++++++++++++++++++++++++++++++++++=
+++++++++-
>>>  1 file changed, 268 insertions(+), 2 deletions(-)
>>>
>>> diff --git a/check/main.c b/check/main.c
>>> index 392195ca..bb816311 100644
>>> --- a/check/main.c
>>> +++ b/check/main.c
>>> @@ -1424,6 +1424,264 @@ static int process_inode_extref(struct extent=
_buffer *eb,
>>>
>>>  }
>>>
>>> +/*
>>> + * Check if the inode referenced by the given data reference uses th=
e extent
>>> + * at disk_bytenr as a non-prealloc extent.
>>> + *
>>> + * Returns 1 if true, 0 if false and < 0 on error.
>>> + */
>>
>> The check itself (along with check_prealloc_shared_data_ref) is good
>> enough to detect any regular file extents inside the prealloc extent.
>>
>> But when it finds any regular extents, it doesn't check if it's covere=
d
>> by csum correctly.
>>
>> For example:
>>
>> |<-------------- prealloc extent range -------------------------->|
>> |<- the *only* regular extent ->|
>> |<-------- range covered by csum -------->|
>>                                 |<- ODD ->|
>>
>> Or
>> |<-------------- prealloc extent range -------------------------->|
>> |<- the *only* regular extent ->|
>> |<- csum ->|
>>            |<------ ODD ------->|
>>
>> So at least in theory, the best solution is not to just check if there=

>> is any regular extents inside the large prealloc extent, but also chec=
k
>> how many csum bytes the regular extents contribute, and then compare i=
t
>> to the result of count_csum_range().
>=20
> Yes, I considered that initially but then moved to this simpler, but
> less accurate solution.
> So the problem is more complex then you think, as a prealloc extent
> can be partially written and then reflinked multiple times and
> fsync'ed.
> For example:
>=20
> create inode A with prealloc extent [0, 256k[
> sync
> write into prealloc extent, range [0, 128k[ through inode A
> reflink prealloc extent into inode B
> reflink prealloc extent into inode C
> reflink prealloc extent into inode D
> fsync inodes B, C and D
> power fail
> remount to replay log
>=20
> Now using a simple counter to count how many bytes the are covered by
> chekcsum items we would have, we would get 384K (128K * 3), more then
> the size of the extent.
> So we would have to track ranges and then ranges that partially
> overlap (due to non-zero offsets in the extent items).

Yep, I also find that we need that overlap check.

>=20
> And this could go even more complex. It's doable, but I wanted to keep
> things simple for now.

I'm mostly OK to keep it like this right now.
But still need some comment to info us about the possible problem for
later enhancement.

Thanks,
Qu

>=20
> thanks
>=20
>>
>> Thanks,
>> Qu
>>
>>> +static int check_prealloc_data_ref(struct btrfs_fs_info *fs_info,
>>> +                                u64 ino,
>>> +                                u64 disk_bytenr,
>>> +                                struct btrfs_extent_data_ref *dref,
>>> +                                struct extent_buffer *eb)
>>> +{
>>> +     u64 rootid =3D btrfs_extent_data_ref_root(eb, dref);
>>> +     u64 objectid =3D btrfs_extent_data_ref_objectid(eb, dref);
>>> +     u64 offset =3D btrfs_extent_data_ref_offset(eb, dref);
>>> +     struct btrfs_root *root;
>>> +     struct btrfs_key key;
>>> +     struct btrfs_path path;
>>> +     int ret;
>>> +
>>> +     if (objectid =3D=3D ino)
>>> +             return 0;
>>> +
>>> +     btrfs_init_path(&path);
>>> +     key.objectid =3D rootid;
>>> +     key.type =3D BTRFS_ROOT_ITEM_KEY;
>>> +     key.offset =3D (u64)-1;
>>> +     root =3D btrfs_read_fs_root(fs_info, &key);
>>> +     if (IS_ERR(root)) {
>>> +             ret =3D PTR_ERR(root);
>>> +             goto out;
>>> +     }
>>> +
>>> +     key.objectid =3D objectid;
>>> +     key.type =3D BTRFS_EXTENT_DATA_KEY;
>>> +     key.offset =3D offset;
>>> +     ret =3D btrfs_search_slot(NULL, root, &key, &path, 0, 0);
>>> +     if (ret > 0) {
>>> +             fprintf(stderr,
>>> +                     "Missing file extent item for inode %llu, root =
%llu, offset %llu",
>>> +                     objectid, rootid, offset);
>>> +             ret =3D -ENOENT;
>>> +     }
>>> +     if (ret < 0)
>>> +             goto out;
>>> +
>>> +     while (true) {
>>> +             struct btrfs_file_extent_item *fi;
>>> +             int extent_type;
>>> +
>>> +             if (path.slots[0] >=3D btrfs_header_nritems(path.nodes[=
0])) {
>>> +                     ret =3D btrfs_next_leaf(fs_info->extent_root, &=
path);
>>> +                     if (ret < 0)
>>> +                             goto out;
>>> +                     if (ret > 0)
>>> +                             break;
>>> +             }
>>> +
>>> +             btrfs_item_key_to_cpu(path.nodes[0], &key, path.slots[0=
]);
>>> +             if (key.objectid !=3D objectid ||
>>> +                 key.type !=3D BTRFS_EXTENT_DATA_KEY)
>>> +                     break;
>>> +
>>> +             fi =3D btrfs_item_ptr(path.nodes[0], path.slots[0],
>>> +                                 struct btrfs_file_extent_item);
>>> +             extent_type =3D btrfs_file_extent_type(path.nodes[0], f=
i);
>>> +             if (extent_type !=3D BTRFS_FILE_EXTENT_REG &&
>>> +                 extent_type !=3D BTRFS_FILE_EXTENT_PREALLOC)
>>> +                     goto next;
>>> +
>>> +             if (btrfs_file_extent_disk_bytenr(path.nodes[0], fi) !=3D=

>>> +                 disk_bytenr)
>>> +                     break;
>>> +
>>> +             if (extent_type =3D=3D BTRFS_FILE_EXTENT_REG) {
>>> +                     ret =3D 1;
>>> +                     goto out;
>>> +             }
>>> +next:
>>> +             path.slots[0]++;
>>> +     }
>>> +     ret =3D 0;
>>> + out:
>>> +     btrfs_release_path(&path);
>>> +     return ret;
>>> +}
>>> +
>>> +/*
>>> + * Check if a shared data reference points to a node that has a file=
 extent item
>>> + * pointing to the extent at disk_bytenr that is not of type preallo=
c and is
>>> + * associated to an inode with a number different from ino.
>>> + *
>>> + * Returns 1 if true, 0 if false and < 0 on error.
>>> + */
>>> +static int check_prealloc_shared_data_ref(struct btrfs_fs_info *fs_i=
nfo,
>>> +                                       u64 ino,
>>> +                                       u64 parent,
>>> +                                       u64 disk_bytenr)
>>> +{
>>> +     struct extent_buffer *eb;
>>> +     u32 nr;
>>> +     int i;
>>> +     int ret =3D 0;
>>> +
>>> +     eb =3D read_tree_block(fs_info, parent, 0);
>>> +     if (!extent_buffer_uptodate(eb)) {
>>> +             ret =3D -EIO;
>>> +             goto out;
>>> +     }
>>> +
>>> +     nr =3D btrfs_header_nritems(eb);
>>> +     for (i =3D 0; i < nr; i++) {
>>> +             struct btrfs_key key;
>>> +             struct btrfs_file_extent_item *fi;
>>> +             int extent_type;
>>> +
>>> +             btrfs_item_key_to_cpu(eb, &key, i);
>>> +             if (key.type !=3D BTRFS_EXTENT_DATA_KEY)
>>> +                     continue;
>>> +             if (key.objectid =3D=3D ino)
>>> +                     continue;
>>> +
>>> +             fi =3D btrfs_item_ptr(eb, i, struct btrfs_file_extent_i=
tem);
>>> +
>>> +             extent_type =3D btrfs_file_extent_type(eb, fi);
>>> +             if (extent_type !=3D BTRFS_FILE_EXTENT_REG &&
>>> +                 extent_type !=3D BTRFS_FILE_EXTENT_PREALLOC)
>>> +                     continue;
>>> +
>>> +             if (btrfs_file_extent_disk_bytenr(eb, fi) =3D=3D disk_b=
ytenr &&
>>> +                 extent_type =3D=3D BTRFS_FILE_EXTENT_REG) {
>>> +                     ret =3D 1;
>>> +                     break;
>>> +             }
>>> +     }
>>> + out:
>>> +     free_extent_buffer(eb);
>>> +     return ret;
>>> +}
>>> +
>>> +/*
>>> + * Check if a prealloc extent is shared by other inodes and if any i=
node has
>>> + * already written to that extent. This is to avoid emitting invalid=
 warnings
>>> + * about odd csum items (a inode has an extent entirely marked as pr=
ealloc
>>> + * but another inode shares it and has already written to it).
>>> + *
>>> + * Returns 0 if the prealloc extent was not written yet by any inode=
, 1 if
>>> + * at least one other inode has written to it, and < 0 on error.
>>> + */
>>> +static int check_prealloc_extent_written(struct btrfs_fs_info *fs_in=
fo,
>>> +                                      u64 ino,
>>> +                                      u64 disk_bytenr,
>>> +                                      u64 num_bytes)
>>> +{
>>> +     struct btrfs_path path;
>>> +     struct btrfs_key key;
>>> +     int ret;
>>> +     struct btrfs_extent_item *ei;
>>> +     u32 item_size;
>>> +     unsigned long ptr;
>>> +     unsigned long end;
>>> +
>>> +     key.objectid =3D disk_bytenr;
>>> +     key.type =3D BTRFS_EXTENT_ITEM_KEY;
>>> +     key.offset =3D num_bytes;
>>> +
>>> +     btrfs_init_path(&path);
>>> +     ret =3D btrfs_search_slot(NULL, fs_info->extent_root, &key, &pa=
th, 0, 0);
>>> +     if (ret > 0) {
>>> +             fprintf(stderr,
>>> +                     "Missing extent item in extent tree for disk_by=
tenr %llu, num_bytes %llu\n",
>>> +                     disk_bytenr, num_bytes);
>>> +             ret =3D -ENOENT;
>>> +     }
>>> +     if (ret < 0)
>>> +             goto out;
>>> +
>>> +     /* First check all inline refs. */
>>> +     ei =3D btrfs_item_ptr(path.nodes[0], path.slots[0],
>>> +                         struct btrfs_extent_item);
>>> +     item_size =3D btrfs_item_size_nr(path.nodes[0], path.slots[0]);=

>>> +     ptr =3D (unsigned long)(ei + 1);
>>> +     end =3D (unsigned long)ei + item_size;
>>> +     while (ptr < end) {
>>> +             struct btrfs_extent_inline_ref *iref;
>>> +             int type;
>>> +
>>> +             iref =3D (struct btrfs_extent_inline_ref *)ptr;
>>> +             type =3D btrfs_extent_inline_ref_type(path.nodes[0], ir=
ef);
>>> +             ASSERT(type =3D=3D BTRFS_EXTENT_DATA_REF_KEY ||
>>> +                    type =3D=3D BTRFS_SHARED_DATA_REF_KEY);
>>> +
>>> +             if (type =3D=3D BTRFS_EXTENT_DATA_REF_KEY) {
>>> +                     struct btrfs_extent_data_ref *dref;
>>> +
>>> +                     dref =3D (struct btrfs_extent_data_ref *)(&iref=
->offset);
>>> +                     ret =3D check_prealloc_data_ref(fs_info, ino, d=
isk_bytenr,
>>> +                                                   dref, path.nodes[=
0]);
>>> +                     if (ret !=3D 0)
>>> +                             goto out;
>>> +             } else if (type =3D=3D BTRFS_SHARED_DATA_REF_KEY) {
>>> +                     u64 parent;
>>> +
>>> +                     parent =3D btrfs_extent_inline_ref_offset(path.=
nodes[0],
>>> +                                                             iref);
>>> +                     ret =3D check_prealloc_shared_data_ref(fs_info,=

>>> +                                                          ino,
>>> +                                                          parent,
>>> +                                                          disk_byten=
r);
>>> +                     if (ret !=3D 0)
>>> +                             goto out;
>>> +             }
>>> +
>>> +             ptr +=3D btrfs_extent_inline_ref_size(type);
>>> +     }
>>> +
>>> +     /* Now check if there are any non-inlined refs. */
>>> +     path.slots[0]++;
>>> +     while (true) {
>>> +             if (path.slots[0] >=3D btrfs_header_nritems(path.nodes[=
0])) {
>>> +                     ret =3D btrfs_next_leaf(fs_info->extent_root, &=
path);
>>> +                     if (ret < 0)
>>> +                             goto out;
>>> +                     if (ret > 0) {
>>> +                             ret =3D 0;
>>> +                             break;
>>> +                     }
>>> +             }
>>> +
>>> +             btrfs_item_key_to_cpu(path.nodes[0], &key, path.slots[0=
]);
>>> +             if (key.objectid !=3D disk_bytenr)
>>> +                     break;
>>> +
>>> +             if (key.type =3D=3D BTRFS_EXTENT_DATA_REF_KEY) {
>>> +                     struct btrfs_extent_data_ref *dref;
>>> +
>>> +                     dref =3D btrfs_item_ptr(path.nodes[0], path.slo=
ts[0],
>>> +                                           struct btrfs_extent_data_=
ref);
>>> +                     ret =3D check_prealloc_data_ref(fs_info, ino, d=
isk_bytenr,
>>> +                                                   dref, path.nodes[=
0]);
>>> +                     if (ret !=3D 0)
>>> +                             goto out;
>>> +             } else if (key.type =3D=3D BTRFS_SHARED_DATA_REF_KEY) {=

>>> +                     ret =3D check_prealloc_shared_data_ref(fs_info,=

>>> +                                                          ino,
>>> +                                                          key.offset=
,
>>> +                                                          disk_byten=
r);
>>> +                     if (ret !=3D 0)
>>> +                             goto out;
>>> +             }
>>> +
>>> +             path.slots[0]++;
>>> +     }
>>> +out:
>>> +     btrfs_release_path(&path);
>>> +     return ret;
>>> +}
>>> +
>>>  static int process_file_extent(struct btrfs_root *root,
>>>                               struct extent_buffer *eb,
>>>                               int slot, struct btrfs_key *key,
>>> @@ -1515,8 +1773,16 @@ static int process_file_extent(struct btrfs_ro=
ot *root,
>>>                       if (found < num_bytes)
>>>                               rec->some_csum_missing =3D 1;
>>>               } else if (extent_type =3D=3D BTRFS_FILE_EXTENT_PREALLO=
C) {
>>> -                     if (found > 0)
>>> -                             rec->errors |=3D I_ERR_ODD_CSUM_ITEM;
>>> +                     if (found > 0) {
>>> +                             ret =3D check_prealloc_extent_written(r=
oot->fs_info,
>>> +                                                                 rec=
->ino,
>>> +                                                                 dis=
k_bytenr,
>>> +                                                                 num=
_bytes);
>>> +                             if (ret < 0)
>>> +                                     return ret;
>>> +                             if (ret =3D=3D 0)
>>> +                                     rec->errors |=3D I_ERR_ODD_CSUM=
_ITEM;
>>> +                     }
>>>               }
>>>       }
>>>       return 0;
>>>
>>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>=20


--ZDT7j4qxldrhhvPUZOLF5gc8oZfdAPLM1--

--YefTsNnVgB7XaRJTXTcG1FHQ8nUgJAKV0
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQFLBAEBCAA1FiEELd9y5aWlW6idqkLhwj2R86El/qgFAlqo/1gXHHF1d2VucnVv
LmJ0cmZzQGdteC5jb20ACgkQwj2R86El/qgtSQgAlTXjQ/vfMwAbw6RgheJb+tBl
dU1opMN3O2ulx64+cY/H/S4ZgxNuIpJyArpVsKi0obaSdNO0fD+bx0agp2PPCOIO
Yk4ensn7SaozIyckW/xjw8v2KjO1AScgyl/48ATsqqeazyG/D+Pl0e/2ezWen6LL
lAmrw/f7AupNd+D2JxY+bQcnanIBIszH673HceUCmc+hhKLhUFm20R/lduDtHcp0
zvT4gAfNcaEsGgdjM2YjTpdXOJG8ytMGrBgj6ysU1/9i/fjEwipUeLPMwzWEG6H5
hNzIFzbVf/un8rQ7yHWh5jeYQrteuAKz1gnif/yuMOxTlETDA3aHlIRu+T8MVw==
=OPXj
-----END PGP SIGNATURE-----

--YefTsNnVgB7XaRJTXTcG1FHQ8nUgJAKV0--
