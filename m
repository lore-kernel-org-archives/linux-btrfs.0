From: Mitch Harder <mitch.harder@sabayonlinux.org>
Subject: Re: [PATCH] Btrfs: fix free space cache when there are pinned extents
 and clusters V2
Date: Mon, 4 Apr 2011 17:59:06 -0500
Message-ID: <BANLkTikmbw6V=YXWuJP7O1-mnyoXWGGejw@mail.gmail.com>
References: <1301601548-14612-1-git-send-email-josef@redhat.com>
	<1301669700-11078-1-git-send-email-josef@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-btrfs@vger.kernel.org
To: Josef Bacik <josef@redhat.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1301669700-11078-1-git-send-email-josef@redhat.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Apr 1, 2011 at 9:55 AM, Josef Bacik <josef@redhat.com> wrote:
> I noticed a huge problem with the free space cache that was presentin=
g as an
> early ENOSPC. =A0Turns out when writing the free space cache out I fo=
rgot to take
> into account pinned extents and more importantly clusters. =A0This wo=
uld result in
> us leaking free space everytime we unmounted the filesystem and remou=
nted it. =A0I
> fix this by making sure to check and see if the current block group h=
as a
> cluster and writing out any entries that are in the cluster to the ca=
che, as
> well as writing any pinned extents we currently have to the cache sin=
ce those
> will be available for us to use the next time the fs mounts. =A0This =
patch also
> adds a check to the end of load_free_space_cache to make sure we got =
the right
> amount of free space cache, and if not make sure to clear the cache a=
nd re-cache
> the old fashioned way. =A0Thanks,
>
> Signed-off-by: Josef Bacik <josef@redhat.com>
> ---
> V1->V2:
> - use block_group->free_space instead of
> =A0btrfs_block_group_free_space(block_group)
>
> =A0fs/btrfs/free-space-cache.c | =A0 82 +++++++++++++++++++++++++++++=
+++++++++++--
> =A01 files changed, 78 insertions(+), 4 deletions(-)
>
> diff --git a/fs/btrfs/free-space-cache.c b/fs/btrfs/free-space-cache.=
c
> index f03ef97..74bc432 100644
> --- a/fs/btrfs/free-space-cache.c
> +++ b/fs/btrfs/free-space-cache.c
> @@ -24,6 +24,7 @@
> =A0#include "free-space-cache.h"
> =A0#include "transaction.h"
> =A0#include "disk-io.h"
> +#include "extent_io.h"
>
> =A0#define BITS_PER_BITMAP =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0(PAGE_CACHE=
_SIZE * 8)
> =A0#define MAX_CACHE_BYTES_PER_GIG =A0 =A0 =A0 =A0(32 * 1024)
> @@ -222,6 +223,7 @@ int load_free_space_cache(struct btrfs_fs_info *f=
s_info,
> =A0 =A0 =A0 =A0u64 num_entries;
> =A0 =A0 =A0 =A0u64 num_bitmaps;
> =A0 =A0 =A0 =A0u64 generation;
> + =A0 =A0 =A0 u64 used =3D btrfs_block_group_used(&block_group->item)=
;
> =A0 =A0 =A0 =A0u32 cur_crc =3D ~(u32)0;
> =A0 =A0 =A0 =A0pgoff_t index =3D 0;
> =A0 =A0 =A0 =A0unsigned long first_page_offset;
> @@ -467,6 +469,17 @@ next:
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0index++;
> =A0 =A0 =A0 =A0}
>
> + =A0 =A0 =A0 spin_lock(&block_group->tree_lock);
> + =A0 =A0 =A0 if (block_group->free_space !=3D (block_group->key.offs=
et - used -
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 block_group->bytes_super)) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 spin_unlock(&block_group->tree_lock);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 printk(KERN_ERR "block group %llu has a=
n wrong amount of free "
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0"space\n", block_group->=
key.objectid);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 ret =3D 0;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto free_cache;
> + =A0 =A0 =A0 }
> + =A0 =A0 =A0 spin_unlock(&block_group->tree_lock);
> +
> =A0 =A0 =A0 =A0ret =3D 1;
> =A0out:
> =A0 =A0 =A0 =A0kfree(checksums);
> @@ -495,8 +508,11 @@ int btrfs_write_out_cache(struct btrfs_root *roo=
t,
> =A0 =A0 =A0 =A0struct list_head *pos, *n;
> =A0 =A0 =A0 =A0struct page *page;
> =A0 =A0 =A0 =A0struct extent_state *cached_state =3D NULL;
> + =A0 =A0 =A0 struct btrfs_free_cluster *cluster =3D NULL;
> + =A0 =A0 =A0 struct extent_io_tree *unpin =3D NULL;
> =A0 =A0 =A0 =A0struct list_head bitmap_list;
> =A0 =A0 =A0 =A0struct btrfs_key key;
> + =A0 =A0 =A0 u64 start, end, len;
> =A0 =A0 =A0 =A0u64 bytes =3D 0;
> =A0 =A0 =A0 =A0u32 *crc, *checksums;
> =A0 =A0 =A0 =A0pgoff_t index =3D 0, last_index =3D 0;
> @@ -505,6 +521,7 @@ int btrfs_write_out_cache(struct btrfs_root *root=
,
> =A0 =A0 =A0 =A0int entries =3D 0;
> =A0 =A0 =A0 =A0int bitmaps =3D 0;
> =A0 =A0 =A0 =A0int ret =3D 0;
> + =A0 =A0 =A0 bool next_page =3D false;
>
> =A0 =A0 =A0 =A0root =3D root->fs_info->tree_root;
>
> @@ -551,6 +568,18 @@ int btrfs_write_out_cache(struct btrfs_root *roo=
t,
> =A0 =A0 =A0 =A0 */
> =A0 =A0 =A0 =A0first_page_offset =3D (sizeof(u32) * num_checksums) + =
sizeof(u64);
>
> + =A0 =A0 =A0 /* Get the cluster for this block_group if it exists */
> + =A0 =A0 =A0 if (!list_empty(&block_group->cluster_list))
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 cluster =3D list_entry(block_group->clu=
ster_list.next,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0struct btrfs_free_cluster,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0block_group_list);
> +
> + =A0 =A0 =A0 /*
> + =A0 =A0 =A0 =A0* We shouldn't have switched the pinned extents yet =
so this is the
> + =A0 =A0 =A0 =A0* right one
> + =A0 =A0 =A0 =A0*/
> + =A0 =A0 =A0 unpin =3D root->fs_info->pinned_extents;
> +
> =A0 =A0 =A0 =A0/*
> =A0 =A0 =A0 =A0 * Lock all pages first so we can lock the extent safe=
ly.
> =A0 =A0 =A0 =A0 *
> @@ -580,6 +609,12 @@ int btrfs_write_out_cache(struct btrfs_root *roo=
t,
> =A0 =A0 =A0 =A0lock_extent_bits(&BTRFS_I(inode)->io_tree, 0, i_size_r=
ead(inode) - 1,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 0, &cached_state, GFP=
_NOFS);
>
> + =A0 =A0 =A0 /*
> + =A0 =A0 =A0 =A0* When searching for pinned extents, we need to star=
t at our start
> + =A0 =A0 =A0 =A0* offset.
> + =A0 =A0 =A0 =A0*/
> + =A0 =A0 =A0 start =3D block_group->key.objectid;
> +
> =A0 =A0 =A0 =A0/* Write out the extent entries */
> =A0 =A0 =A0 =A0do {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0struct btrfs_free_space_entry *entry;
> @@ -587,6 +622,8 @@ int btrfs_write_out_cache(struct btrfs_root *root=
,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0unsigned long offset =3D 0;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0unsigned long start_offset =3D 0;
>
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 next_page =3D false;
> +
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0if (index =3D=3D 0) {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0start_offset =3D first=
_page_offset;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0offset =3D start_offse=
t;
> @@ -598,7 +635,7 @@ int btrfs_write_out_cache(struct btrfs_root *root=
,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0entry =3D addr + start_offset;
>
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0memset(addr, 0, PAGE_CACHE_SIZE);
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 while (1) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 while (node && !next_page) {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0struct btrfs_free_spac=
e *e;
>
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0e =3D rb_entry(node, s=
truct btrfs_free_space, offset_index);
> @@ -614,12 +651,49 @@ int btrfs_write_out_cache(struct btrfs_root *ro=
ot,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0entry-=
>type =3D BTRFS_FREE_SPACE_EXTENT;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0}
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0node =3D rb_next(node)=
;
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (!node)
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 break;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (!node && cluster) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 node =3D=
 rb_first(&cluster->root);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 cluster=
 =3D NULL;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0offset +=3D sizeof(str=
uct btrfs_free_space_entry);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0if (offset + sizeof(st=
ruct btrfs_free_space_entry) >=3D
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0PAGE_CACHE_SIZ=
E)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 next_pa=
ge =3D true;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 entry++;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
> +
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 /*
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0* We want to add any pinned extents =
to our free space cache
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0* so we don't leak the space
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0*/
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 while (!next_page && (start < block_gro=
up->key.objectid +
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 block_group->key.offset)) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 ret =3D find_first_exte=
nt_bit(unpin, start, &start, &end,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 EXTENT_DIRTY);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (ret) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 ret =3D=
 0;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0break;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
> +
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 /* This pinned extent i=
s out of our range */
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (start >=3D block_gr=
oup->key.objectid +
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 block_group->ke=
y.offset)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 break;
> +
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 len =3D block_group->ke=
y.objectid +
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 block_g=
roup->key.offset - start;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 len =3D min(len, end + =
1 - start);
> +
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 entries++;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 entry->offset =3D cpu_t=
o_le64(start);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 entry->bytes =3D cpu_to=
_le64(len);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 entry->type =3D BTRFS_F=
REE_SPACE_EXTENT;
> +
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 start =3D end + 1;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 offset +=3D sizeof(stru=
ct btrfs_free_space_entry);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (offset + sizeof(str=
uct btrfs_free_space_entry) >=3D
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 PAGE_CACHE_SIZE=
)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 next_pa=
ge =3D true;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0entry++;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0}
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0*crc =3D ~(u32)0;
> @@ -650,7 +724,7 @@ int btrfs_write_out_cache(struct btrfs_root *root=
,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0page_cache_release(page);
>
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0index++;
> - =A0 =A0 =A0 } while (node);
> + =A0 =A0 =A0 } while (node || next_page);
>
> =A0 =A0 =A0 =A0/* Write out the bitmaps */
> =A0 =A0 =A0 =A0list_for_each_safe(pos, n, &bitmap_list) {
> --
> 1.7.2.3
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs=
" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
>

I've been testing this patch on a 2.6.38.2 kernel with the patches
from Chris' for-linus-unmerged branch.

I've received the following oops that I think is in the area affected
by this patch, so I'm posting here.

At the time of the oops, I was downloading a file to a separate ext3
partition, so I'm not sure what precipitated this oops.

I have btrfs on my root partition; however, space_cache is not enabled
on my root partition.

I have a build partition (with space_cache enabled, and I mounted with
clear_cache) that had just successfully finished building and
installing php, and was in the process of preparing to start building
another package when the oops was received.  The build routine should
not have been accessing the build partition at that time since it was
in the process of saving the source package to another partition.
Perhaps it was a delayed sync from the build that had just finished.

[261901.536430] BUG: unable to handle kernel NULL pointer dereference
at   (null)
[261901.536438] IP: [<c10189fe>] kmap+0xb/0x39
[261901.536449] *pde =3D 00000000
[261901.536453] Oops: 0000 [#1]
[261901.536456] last sysfs file: /sys/devices/virtual/dmi/id/bios_vendo=
r
[261901.536460] Modules linked in: nvidia(P) sl811_hcd
[261901.536465]
[261901.536470] Pid: 3622, comm: btrfs-transacti Tainted: P
2.6.38.2-sabayon #2    /MS-6570
[261901.536476] EIP: 0060:[<c10189fe>] EFLAGS: 00010246 CPU: 0
[261901.536480] EIP is at kmap+0xb/0x39
[261901.536483] EAX: 00000000 EBX: 00000000 ECX: 00000000 EDX: 00000000
[261901.536486] ESI: 00000000 EDI: 00001000 EBP: f00f5e08 ESP: f00f5e04
[261901.536490]  DS: 007b ES: 007b FS: 0000 GS: 0000 SS: 0068
[261901.536493] Process btrfs-transacti (pid: 3622, ti=3Df00f4000
task=3Df2057780 task.ti=3Df00f4000)
[261901.536496] Stack:
[261901.536498]  f3a9fc00 f00f5ed0 c123ce1e ff87f000 c1082936 00000000
00000022 f3a9fb00
[261901.536504]  f697206c f3a9fc00 00000048 0000000f 00000010 00000001
00000000 ff87f000
[261901.536511]  f3a9fb1c 00000040 f6719000 eead8780 00000efc 00000000
f24e0800 00010000
[261901.536517] Call Trace:
[261901.536527]  [<c123ce1e>] btrfs_write_out_cache+0x257/0x89f
[261901.536536]  [<c1082936>] ? page_address+0x20/0x92
[261901.536544]  [<c1204fe8>] ? btrfs_run_delayed_refs+0x7c/0x102
[261901.536549]  [<c12053f9>] btrfs_write_dirty_block_groups+0x38b/0x41=
a
[261901.536554]  [<c1210090>] commit_cowonly_roots+0xa9/0x178
[261901.536559]  [<c101ceaf>] ? need_resched+0x14/0x1e
[261901.536564]  [<c12110d6>] btrfs_commit_transaction+0x2e9/0x5a1
[261901.536572]  [<c10359cc>] ? autoremove_wake_function+0x0/0x2f
[261901.536578]  [<c120c58e>] transaction_kthread+0x10e/0x19d
[261901.536582]  [<c101d5b6>] ? complete+0x2d/0x36
[261901.536587]  [<c120c480>] ? transaction_kthread+0x0/0x19d
[261901.536591]  [<c1035756>] kthread+0x61/0x66
[261901.536596]  [<c10356f5>] ? kthread+0x0/0x66
[261901.536601]  [<c1002c76>] kernel_thread_helper+0x6/0x10
[261901.536603] Code: e8 1e 69 c0 f0 02 00 00 05 a0 90 7b c1 e8 5f fe
ff ff 85 c0 74 07 89 d8 e8 b8 9f 06 00 5b 5d c3 55 89 e5 53 89 c3 e8
bd c2 51 00 <8b> 03 c1 e8 1e 69 c0 f0 02 00 00 05 a0 90 7b c1 e8 31 fe
ff ff
[261901.536635] EIP: [<c10189fe>] kmap+0xb/0x39 SS:ESP 0068:f00f5e04
[261901.536640] CR2: 0000000000000000
[261901.536644] ---[ end trace eec3a32046e1c7b3 ]---
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
