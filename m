From: "Yan, Zheng " <yanzheng@21cn.com>
Subject: Re: [RFC] Btrfs design defect in extent backref ?
Date: Thu, 25 Aug 2011 16:47:57 +0800
Message-ID: <CAAM7YAkxNcC_dk4uUnYFUoynkzb2Mx2KmJrNT+GJ8oZGKp3JqA@mail.gmail.com>
References: <4E560018.9060005@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
	Yan@tang.cn.fujitsu.com, Zheng <zheng.z.yan@intel.com>
To: Li Zefan <lizf@cn.fujitsu.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4E560018.9060005@cn.fujitsu.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Aug 25, 2011 at 3:56 PM, Li Zefan <lizf@cn.fujitsu.com> wrote:
> We have an offset in file extent to indicate its position in the
> corresponding extent item in extent tree. We also have an offset in
> extent item to indicate the start position of the file extent that
> uses this item.
>
> The math is:
>
> =A0 =A0extent_item.extent_data_ref.offset =3D file_pos - file_extent.=
extent_offset.
>
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 e1
> disk extents: =A0 =A0|--------------|
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 ^
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 | =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
e2
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 | =A0 =A0 =A0 =A0 =A0|---------------=
--|
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 | =A0 =A0 =A0 =A0 =A0| =A0 ^
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 | =A0 =A0 =A0 =A0 =A0| =A0 |
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 v =A0 =A0 =A0 =A0 =A0v =A0 |
> file extents: =A0 =A0|----- f1 -----|----- f2 -----|
>
> So it looks like e2.offset points to f1 not f2. Therefore given an ex=
tent item,
> we'll have to search through all the file extents in an inode to find=
 the
> relative file extent in the worst case, which makes this field somewh=
at useless.
>

The reason for this is reducing number of file extent backref itmes.
we don't have to search all the file extents because the file extent si=
ze
is limited and we have extent_data_ref.count.

> What makes things worse is the above fomula can make the offset a neg=
ative
> value (cast to u64):
>
> =A0 =A0# touch /mnt/dst
> =A0 =A0# clone_range -s 8192 -d 4096 /mnt/src /mnt/dst
> =A0 =A0# umount /mnt
> =A0 =A0# btrfs-debug-tree /dev/sda7
> =A0 =A0...
> =A0 =A0 =A0 =A0item 2 key (12582912 EXTENT_ITEM 49152) itemoff 3865 i=
temsize 82
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0extent refs 2 gen 8 flags 1
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0extent data backref root 5 objectid 25=
8 offset 18446744073709543424 count 1
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0extent data backref root 5 objectid 25=
7 offset 0 count 1
> =A0 =A0...
>
> and relocation won't work in this case:
>
> =A0 =A0# mount /dev/sda7 /mnt
> =A0 =A0# rm /mnt/src
> =A0 =A0# sync
> =A0 =A0# btrfs fi bal /mnt
> =A0 =A0(kernel warning !!)
> =A0 =A0(hung up !!)
>
> I don't see the necessity or benefit of the substraction in the fomul=
a,
> and I think the correct one is:
>
> =A0 =A0extent_item.extent_data_ref.offset =3D file_pos
>
> (As a side effect thereafter we don't need extent_data_ref.count)
>
> That's what this patch does. Unfornately it is an incompatable change
> in disk format.
>
> So I think we have to live with this defect, just fix relocation for
> the negative offset case ?

I prefer fixing relocation.

>
> Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
> ---
> =A0fs/btrfs/extent-tree.c | =A0 =A01 -
> =A0fs/btrfs/file.c =A0 =A0 =A0 =A0| =A0 11 +++++------
> =A0fs/btrfs/inode.c =A0 =A0 =A0 | =A0 =A07 +++----
> =A0fs/btrfs/ioctl.c =A0 =A0 =A0 | =A0 =A02 +-
> =A0fs/btrfs/relocation.c =A0| =A0 =A01 -
> =A05 files changed, 9 insertions(+), 13 deletions(-)
>
> diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
> index f5be06a..3924e03 100644
> --- a/fs/btrfs/extent-tree.c
> +++ b/fs/btrfs/extent-tree.c
> @@ -2578,7 +2578,6 @@ static int __btrfs_mod_ref(struct btrfs_trans_h=
andle *trans,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0contin=
ue;
>
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0num_bytes =3D btrfs_fi=
le_extent_disk_num_bytes(buf, fi);
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 key.offset -=3D btrfs_f=
ile_extent_offset(buf, fi);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0ret =3D process_func(t=
rans, root, bytenr, num_bytes,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 parent, ref_root, key.objectid,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 key.offset);
> diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
> index e7872e4..7f65a27 100644
> --- a/fs/btrfs/file.c
> +++ b/fs/btrfs/file.c
> @@ -678,7 +678,7 @@ next_slot:
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0disk_bytenr, num_bytes, 0,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0root->root_key.objectid,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0new_key.objectid,
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 start - extent_offset);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 start);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0BUG_ON=
(ret);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0*hint_=
byte =3D disk_bytenr;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0}
> @@ -752,8 +752,7 @@ next_slot:
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0ret =3D=
 btrfs_free_extent(trans, root,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0disk_bytenr, num_bytes, 0,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0root->root_key.objectid,
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 key.objectid, key.offset -
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 extent_offset);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 key.objectid, key.offset);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0BUG_ON=
(ret);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0inode_=
sub_bytes(inode,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0extent_end - key.offset);
> @@ -962,7 +961,7 @@ again:
>
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0ret =3D btrfs_inc_extent_ref(trans, ro=
ot, bytenr, num_bytes, 0,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 root->root_key.objectid,
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0ino, orig_offset);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0ino, split);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0BUG_ON(ret);
>
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0if (split =3D=3D start) {
> @@ -989,7 +988,7 @@ again:
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0del_nr++;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0ret =3D btrfs_free_extent(trans, root,=
 bytenr, num_bytes,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A00, root->root_key.objectid,
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 ino, orig_offset);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 ino, other_start);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0BUG_ON(ret);
> =A0 =A0 =A0 =A0}
> =A0 =A0 =A0 =A0other_start =3D 0;
> @@ -1006,7 +1005,7 @@ again:
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0del_nr++;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0ret =3D btrfs_free_extent(trans, root,=
 bytenr, num_bytes,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A00, root->root_key.objectid,
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 ino, orig_offset);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 ino, other_end);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0BUG_ON(ret);
> =A0 =A0 =A0 =A0}
> =A0 =A0 =A0 =A0if (del_nr =3D=3D 0) {
> diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
> index 0ccc743..0158652 100644
> --- a/fs/btrfs/inode.c
> +++ b/fs/btrfs/inode.c
> @@ -3135,7 +3135,7 @@ int btrfs_truncate_inode_items(struct btrfs_tra=
ns_handle *trans,
> =A0 =A0 =A0 =A0struct btrfs_key found_key;
> =A0 =A0 =A0 =A0u64 extent_start =3D 0;
> =A0 =A0 =A0 =A0u64 extent_num_bytes =3D 0;
> - =A0 =A0 =A0 u64 extent_offset =3D 0;
> + =A0 =A0 =A0 u64 offset =3D 0;
> =A0 =A0 =A0 =A0u64 item_end =3D 0;
> =A0 =A0 =A0 =A0u64 mask =3D root->sectorsize - 1;
> =A0 =A0 =A0 =A0u32 found_type =3D (u8)-1;
> @@ -3256,8 +3256,7 @@ search_again:
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0extent=
_num_bytes =3D
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0btrfs_file_extent_disk_num_bytes(leaf,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 fi);
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 extent_=
offset =3D found_key.offset -
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 btrfs_file_extent_offset(leaf, fi);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 offset =
=3D found_key.offset;
>
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0/* FIX=
ME blocksize !=3D 4096 */
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0num_de=
c =3D btrfs_file_extent_num_bytes(leaf, fi);
> @@ -3314,7 +3313,7 @@ delete:
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0ret =3D btrfs_free_ext=
ent(trans, root, extent_start,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0extent_num_bytes, 0,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0btrfs_header_owner(leaf),
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 ino, extent_offset);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 ino, offset);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0BUG_ON(ret);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0}
>
> diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
> index 3351b1b..87e126f 100644
> --- a/fs/btrfs/ioctl.c
> +++ b/fs/btrfs/ioctl.c
> @@ -2379,7 +2379,7 @@ static noinline long btrfs_ioctl_clone(struct f=
ile *file, unsigned long srcfd,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0disko, diskl, 0,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0root->root_key.objectid,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0btrfs_ino(inode),
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 new_key.offset - datao);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 new_key.offset);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0BUG_ON(ret);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0}
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0} else if (type =3D=3D=
 BTRFS_FILE_EXTENT_INLINE) {
> diff --git a/fs/btrfs/relocation.c b/fs/btrfs/relocation.c
> index 59bb176..a8d0089 100644
> --- a/fs/btrfs/relocation.c
> +++ b/fs/btrfs/relocation.c
> @@ -1598,7 +1598,6 @@ int replace_file_extents(struct btrfs_trans_han=
dle *trans,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0btrfs_set_file_extent_disk_bytenr(leaf=
, fi, new_bytenr);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0dirty =3D 1;
>
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 key.offset -=3D btrfs_file_extent_offse=
t(leaf, fi);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0ret =3D btrfs_inc_extent_ref(trans, ro=
ot, new_bytenr,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 num_bytes, parent,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 btrfs_header_owner(leaf),
> --
> 1.7.3.1
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs=
" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
>
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
