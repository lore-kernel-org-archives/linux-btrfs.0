From: Jordan Patterson <jordanp@gmail.com>
Subject: Re: BUG: unable to handle kernel NULL pointer dereference at (null)
Date: Wed, 6 Apr 2011 14:47:28 -0600
Message-ID: <BANLkTi=hZ2i-kj70yq+=E74oSZZu9G7wtw@mail.gmail.com>
References: <201104051938.14319.johannes.hirte@fem.tu-ilmenau.de>
	<201104060000.11403.johannes.hirte@fem.tu-ilmenau.de>
	<20110405215752.GE484@dhcp231-156.rdu.redhat.com>
	<201104061310.38951.johannes.hirte@fem.tu-ilmenau.de>
	<20110406171541.GA5574@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-btrfs@vger.kernel.org
To: Josef Bacik <josef@redhat.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20110406171541.GA5574@localhost.localdomain>
List-ID: <linux-btrfs.vger.kernel.org>

Hi Josef:

I tried your latest patch, since I had the same issue from the first
email.  With the patch applied, I am now hitting the
BUG_ON(block_group->total_bitmaps >=3D max_bitmaps); in add_new_bitmap
in
fs/btrfs/free-space-cache.c:1246 as soon as I mount the filesystem,
with or without -o clear_cache.

It works fine in 2.6.38.  I get the same error after mounting with
clear_cache under 2.6.38 and rebooting into the current kernel with
your patch.

Jordan

On Wed, Apr 6, 2011 at 11:15 AM, Josef Bacik <josef@redhat.com> wrote:
> On Wed, Apr 06, 2011 at 01:10:38PM +0200, Johannes Hirte wrote:
>> On Tuesday 05 April 2011 23:57:53 Josef Bacik wrote:
>> > > Now it hit
>> >
>> > Man I cannot catch a break. =A0I hope this is the last one. =A0Tha=
nks,
>> >
>
> Ok I give up, I just cleaned it all up and don't mark the pages as di=
rty unless
> we're actually going to succeed at writing them. =A0This should fix e=
verything
>
> ---
> =A0fs/btrfs/ctree.h =A0 =A0 =A0 =A0 =A0 =A0| =A0 =A05 ++
> =A0fs/btrfs/file.c =A0 =A0 =A0 =A0 =A0 =A0 | =A0 21 +++----
> =A0fs/btrfs/free-space-cache.c | =A0117 ++++++++++++++++++++---------=
--------------
> =A03 files changed, 69 insertions(+), 74 deletions(-)
>
> diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
> index 3458b57..0d00a07 100644
> --- a/fs/btrfs/ctree.h
> +++ b/fs/btrfs/ctree.h
> @@ -2576,6 +2576,11 @@ int btrfs_drop_extents(struct btrfs_trans_hand=
le *trans, struct inode *inode,
> =A0int btrfs_mark_extent_written(struct btrfs_trans_handle *trans,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0struct ino=
de *inode, u64 start, u64 end);
> =A0int btrfs_release_file(struct inode *inode, struct file *file);
> +void btrfs_drop_pages(struct page **pages, size_t num_pages);
> +int btrfs_dirty_pages(struct btrfs_root *root, struct inode *inode,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 struct page **pages, size_t=
 num_pages,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 loff_t pos, size_t write_by=
tes,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 struct extent_state **cache=
d);
>
> =A0/* tree-defrag.c */
> =A0int btrfs_defrag_leaves(struct btrfs_trans_handle *trans,
> diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
> index e621ea5..75899a0 100644
> --- a/fs/btrfs/file.c
> +++ b/fs/btrfs/file.c
> @@ -104,7 +104,7 @@ static noinline int btrfs_copy_from_user(loff_t p=
os, int num_pages,
> =A0/*
> =A0* unlocks pages after btrfs_file_write is done with them
> =A0*/
> -static noinline void btrfs_drop_pages(struct page **pages, size_t nu=
m_pages)
> +void btrfs_drop_pages(struct page **pages, size_t num_pages)
> =A0{
> =A0 =A0 =A0 =A0size_t i;
> =A0 =A0 =A0 =A0for (i =3D 0; i < num_pages; i++) {
> @@ -127,16 +127,13 @@ static noinline void btrfs_drop_pages(struct pa=
ge **pages, size_t num_pages)
> =A0* this also makes the decision about creating an inline extent vs
> =A0* doing real data extents, marking pages dirty and delalloc as req=
uired.
> =A0*/
> -static noinline int dirty_and_release_pages(struct btrfs_root *root,
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 struct file *file,
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 struct page **pages,
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 size_t num_pages,
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 loff_t pos,
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 size_t write_bytes)
> +int btrfs_dirty_pages(struct btrfs_root *root, struct inode *inode,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 struct page **pages, size_t=
 num_pages,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 loff_t pos, size_t write_by=
tes,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 struct extent_state **cache=
d)
> =A0{
> =A0 =A0 =A0 =A0int err =3D 0;
> =A0 =A0 =A0 =A0int i;
> - =A0 =A0 =A0 struct inode *inode =3D fdentry(file)->d_inode;
> =A0 =A0 =A0 =A0u64 num_bytes;
> =A0 =A0 =A0 =A0u64 start_pos;
> =A0 =A0 =A0 =A0u64 end_of_last_block;
> @@ -149,7 +146,7 @@ static noinline int dirty_and_release_pages(struc=
t btrfs_root *root,
>
> =A0 =A0 =A0 =A0end_of_last_block =3D start_pos + num_bytes - 1;
> =A0 =A0 =A0 =A0err =3D btrfs_set_extent_delalloc(inode, start_pos, en=
d_of_last_block,
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 NULL);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 cached);
> =A0 =A0 =A0 =A0if (err)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0return err;
>
> @@ -992,9 +989,9 @@ static noinline ssize_t __btrfs_buffered_write(st=
ruct file *file,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0}
>
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0if (copied > 0) {
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 ret =3D dirty_and_relea=
se_pages(root, file, pages,
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 dirty_pages, pos,
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 copied);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 ret =3D btrfs_dirty_pag=
es(root, inode, pages,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 dirty_pages, pos, copied,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 NULL);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0if (ret) {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0btrfs_=
delalloc_release_space(inode,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0dirty_pages << PAGE_CACHE_SHIFT);
> diff --git a/fs/btrfs/free-space-cache.c b/fs/btrfs/free-space-cache.=
c
> index f561c95..a3f420d 100644
> --- a/fs/btrfs/free-space-cache.c
> +++ b/fs/btrfs/free-space-cache.c
> @@ -508,6 +508,7 @@ int btrfs_write_out_cache(struct btrfs_root *root=
,
> =A0 =A0 =A0 =A0struct inode *inode;
> =A0 =A0 =A0 =A0struct rb_node *node;
> =A0 =A0 =A0 =A0struct list_head *pos, *n;
> + =A0 =A0 =A0 struct page **pages;
> =A0 =A0 =A0 =A0struct page *page;
> =A0 =A0 =A0 =A0struct extent_state *cached_state =3D NULL;
> =A0 =A0 =A0 =A0struct btrfs_free_cluster *cluster =3D NULL;
> @@ -517,13 +518,13 @@ int btrfs_write_out_cache(struct btrfs_root *ro=
ot,
> =A0 =A0 =A0 =A0u64 start, end, len;
> =A0 =A0 =A0 =A0u64 bytes =3D 0;
> =A0 =A0 =A0 =A0u32 *crc, *checksums;
> - =A0 =A0 =A0 pgoff_t index =3D 0, last_index =3D 0;
> =A0 =A0 =A0 =A0unsigned long first_page_offset;
> - =A0 =A0 =A0 int num_checksums;
> + =A0 =A0 =A0 int index =3D 0, num_pages =3D 0;
> =A0 =A0 =A0 =A0int entries =3D 0;
> =A0 =A0 =A0 =A0int bitmaps =3D 0;
> =A0 =A0 =A0 =A0int ret =3D 0;
> =A0 =A0 =A0 =A0bool next_page =3D false;
> + =A0 =A0 =A0 bool out_of_space =3D false;
>
> =A0 =A0 =A0 =A0root =3D root->fs_info->tree_root;
>
> @@ -551,24 +552,31 @@ int btrfs_write_out_cache(struct btrfs_root *ro=
ot,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0return 0;
> =A0 =A0 =A0 =A0}
>
> - =A0 =A0 =A0 last_index =3D (i_size_read(inode) - 1) >> PAGE_CACHE_S=
HIFT;
> + =A0 =A0 =A0 num_pages =3D (i_size_read(inode) + PAGE_CACHE_SIZE - 1=
) >>
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 PAGE_CACHE_SHIFT;
> =A0 =A0 =A0 =A0filemap_write_and_wait(inode->i_mapping);
> =A0 =A0 =A0 =A0btrfs_wait_ordered_range(inode, inode->i_size &
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 ~(roo=
t->sectorsize - 1), (u64)-1);
>
> =A0 =A0 =A0 =A0/* We need a checksum per page. */
> - =A0 =A0 =A0 num_checksums =3D i_size_read(inode) / PAGE_CACHE_SIZE;
> - =A0 =A0 =A0 crc =3D checksums =A0=3D kzalloc(sizeof(u32) * num_chec=
ksums, GFP_NOFS);
> + =A0 =A0 =A0 crc =3D checksums =3D kzalloc(sizeof(u32) * num_pages, =
GFP_NOFS);
> =A0 =A0 =A0 =A0if (!crc) {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0iput(inode);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0return 0;
> =A0 =A0 =A0 =A0}
>
> + =A0 =A0 =A0 pages =3D kzalloc(sizeof(struct page *) * num_pages, GF=
P_NOFS);
> + =A0 =A0 =A0 if (!pages) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 kfree(crc);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 iput(inode);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 return 0;
> + =A0 =A0 =A0 }
> +
> =A0 =A0 =A0 =A0/* Since the first page has all of our checksums and o=
ur generation we
> =A0 =A0 =A0 =A0 * need to calculate the offset into the page that we =
can start writing
> =A0 =A0 =A0 =A0 * our entries.
> =A0 =A0 =A0 =A0 */
> - =A0 =A0 =A0 first_page_offset =3D (sizeof(u32) * num_checksums) + s=
izeof(u64);
> + =A0 =A0 =A0 first_page_offset =3D (sizeof(u32) * num_pages) + sizeo=
f(u64);
>
> =A0 =A0 =A0 =A0/* Get the cluster for this block_group if it exists *=
/
> =A0 =A0 =A0 =A0if (!list_empty(&block_group->cluster_list))
> @@ -590,20 +598,18 @@ int btrfs_write_out_cache(struct btrfs_root *ro=
ot,
> =A0 =A0 =A0 =A0 * after find_get_page at this point. =A0Just putting =
this here so people
> =A0 =A0 =A0 =A0 * know and don't freak out.
> =A0 =A0 =A0 =A0 */
> - =A0 =A0 =A0 while (index <=3D last_index) {
> + =A0 =A0 =A0 while (index < num_pages) {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0page =3D grab_cache_page(inode->i_mapp=
ing, index);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0if (!page) {
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 pgoff_t i =3D 0;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 int i;
>
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 while (i < index) {
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 page =3D=
 find_get_page(inode->i_mapping, i);
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 unlock_=
page(page);
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 page_ca=
che_release(page);
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 page_ca=
che_release(page);
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 i++;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 for (i =3D 0; i < num_p=
ages; i++) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 unlock_=
page(pages[i]);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 page_ca=
che_release(pages[i]);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0}
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0goto out_free;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0}
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 pages[index] =3D page;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0index++;
> =A0 =A0 =A0 =A0}
>
> @@ -631,7 +637,12 @@ int btrfs_write_out_cache(struct btrfs_root *roo=
t,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0offset =3D start_offse=
t;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0}
>
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 page =3D find_get_page(inode->i_mapping=
, index);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (index >=3D num_pages) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 out_of_space =3D true;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 break;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
> +
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 page =3D pages[index];
>
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0addr =3D kmap(page);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0entry =3D addr + start_offset;
> @@ -708,23 +719,6 @@ int btrfs_write_out_cache(struct btrfs_root *roo=
t,
>
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0bytes +=3D PAGE_CACHE_SIZE;
>
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 ClearPageChecked(page);
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 set_page_extent_mapped(page);
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 SetPageUptodate(page);
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 set_page_dirty(page);
> -
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 /*
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0* We need to release our reference w=
e got for grab_cache_page,
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0* except for the first page which wi=
ll hold our checksums, we
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0* do that below.
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0*/
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (index !=3D 0) {
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 unlock_page(page);
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 page_cache_release(page=
);
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
> -
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 page_cache_release(page);
> -
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0index++;
> =A0 =A0 =A0 =A0} while (node || next_page);
>
> @@ -734,6 +728,10 @@ int btrfs_write_out_cache(struct btrfs_root *roo=
t,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0struct btrfs_free_space *entry =3D
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0list_entry(pos, struct=
 btrfs_free_space, list);
>
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (index >=3D num_pages) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 out_of_space =3D true;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 break;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0page =3D find_get_page(inode->i_mappin=
g, index);
>
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0addr =3D kmap(page);
> @@ -745,64 +743,58 @@ int btrfs_write_out_cache(struct btrfs_root *ro=
ot,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0crc++;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0bytes +=3D PAGE_CACHE_SIZE;
>
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 ClearPageChecked(page);
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 set_page_extent_mapped(page);
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 SetPageUptodate(page);
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 set_page_dirty(page);
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 unlock_page(page);
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 page_cache_release(page);
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 page_cache_release(page);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0list_del_init(&entry->list);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0index++;
> =A0 =A0 =A0 =A0}
>
> + =A0 =A0 =A0 if (out_of_space) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 btrfs_drop_pages(pages, num_pages);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 unlock_extent_cached(&BTRFS_I(inode)->i=
o_tree, 0,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0i_size_read(inode) - 1, &cached_state,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0GFP_NOFS);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 ret =3D 0;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto out_free;
> + =A0 =A0 =A0 }
> +
> =A0 =A0 =A0 =A0/* Zero out the rest of the pages just to make sure */
> - =A0 =A0 =A0 while (index <=3D last_index) {
> + =A0 =A0 =A0 while (index < num_pages) {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0void *addr;
>
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 page =3D find_get_page(inode->i_mapping=
, index);
> -
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 page =3D pages[index];
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0addr =3D kmap(page);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0memset(addr, 0, PAGE_CACHE_SIZE);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0kunmap(page);
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 ClearPageChecked(page);
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 set_page_extent_mapped(page);
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 SetPageUptodate(page);
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 set_page_dirty(page);
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 unlock_page(page);
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 page_cache_release(page);
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 page_cache_release(page);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0bytes +=3D PAGE_CACHE_SIZE;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0index++;
> =A0 =A0 =A0 =A0}
>
> - =A0 =A0 =A0 btrfs_set_extent_delalloc(inode, 0, bytes - 1, &cached_=
state);
> -
> =A0 =A0 =A0 =A0/* Write the checksums and trans id to the first page =
*/
> =A0 =A0 =A0 =A0{
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0void *addr;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0u64 *gen;
>
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 page =3D find_get_page(inode->i_mapping=
, 0);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 page =3D pages[0];
>
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0addr =3D kmap(page);
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 memcpy(addr, checksums, sizeof(u32) * n=
um_checksums);
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 gen =3D addr + (sizeof(u32) * num_check=
sums);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 memcpy(addr, checksums, sizeof(u32) * n=
um_pages);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 gen =3D addr + (sizeof(u32) * num_pages=
);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0*gen =3D trans->transid;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0kunmap(page);
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 ClearPageChecked(page);
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 set_page_extent_mapped(page);
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 SetPageUptodate(page);
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 set_page_dirty(page);
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 unlock_page(page);
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 page_cache_release(page);
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 page_cache_release(page);
> =A0 =A0 =A0 =A0}
> - =A0 =A0 =A0 BTRFS_I(inode)->generation =3D trans->transid;
>
> + =A0 =A0 =A0 ret =3D btrfs_dirty_pages(root, inode, pages, num_pages=
, 0,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 bytes, &cached_state);
> + =A0 =A0 =A0 btrfs_drop_pages(pages, num_pages);
> =A0 =A0 =A0 =A0unlock_extent_cached(&BTRFS_I(inode)->io_tree, 0,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 i_size_read(i=
node) - 1, &cached_state, GFP_NOFS);
>
> + =A0 =A0 =A0 if (ret) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 ret =3D 0;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto out_free;
> + =A0 =A0 =A0 }
> +
> + =A0 =A0 =A0 BTRFS_I(inode)->generation =3D trans->transid;
> +
> =A0 =A0 =A0 =A0filemap_write_and_wait(inode->i_mapping);
>
> =A0 =A0 =A0 =A0key.objectid =3D BTRFS_FREE_SPACE_OBJECTID;
> @@ -853,6 +845,7 @@ out_free:
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0BTRFS_I(inode)->generation =3D 0;
> =A0 =A0 =A0 =A0}
> =A0 =A0 =A0 =A0kfree(checksums);
> + =A0 =A0 =A0 kfree(pages);
> =A0 =A0 =A0 =A0btrfs_update_inode(trans, root, inode);
> =A0 =A0 =A0 =A0iput(inode);
> =A0 =A0 =A0 =A0return ret;
> --
> 1.7.2.3
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
