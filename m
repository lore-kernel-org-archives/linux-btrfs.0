Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wi0-f172.google.com ([209.85.212.172]:52525 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757734Ab2JKLLh (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 11 Oct 2012 07:11:37 -0400
Received: by mail-wi0-f172.google.com with SMTP id hq12so8537290wib.1
        for <linux-btrfs@vger.kernel.org>; Thu, 11 Oct 2012 04:11:35 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1349868091-23041-1-git-send-email-list.btrfs@jan-o-sch.net>
References: <1349868091-23041-1-git-send-email-list.btrfs@jan-o-sch.net>
Date: Thu, 11 Oct 2012 13:11:35 +0200
Message-ID: <CAOcd+r2BXcrKxRZgf2Rx4n61wW2KHXLFoGZwd3AYFTVBni0FWQ@mail.gmail.com>
Subject: Re: [PATCH] Btrfs: extended inode refs support for send mechanism
From: Alex Lyakas <alex.btrfs@zadarastorage.com>
To: Jan Schmidt <list.btrfs@jan-o-sch.net>
Cc: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Jan,


On Wed, Oct 10, 2012 at 1:21 PM, Jan Schmidt <list.btrfs@jan-o-sch.net> wrote:
> This adds support for the new extended inode refs to btrfs send.
>
> Signed-off-by: Jan Schmidt <list.btrfs@jan-o-sch.net>
> ---
>  fs/btrfs/backref.c |   22 ++++-----
>  fs/btrfs/backref.h |    4 ++
>  fs/btrfs/send.c    |  129 ++++++++++++++++++++++++++++++++++------------------
>  3 files changed, 99 insertions(+), 56 deletions(-)
>
> diff --git a/fs/btrfs/backref.c b/fs/btrfs/backref.c
> index f318793..7fca771 100644
> --- a/fs/btrfs/backref.c
> +++ b/fs/btrfs/backref.c
> @@ -1177,11 +1177,10 @@ int btrfs_find_one_extref(struct btrfs_root *root, u64 inode_objectid,
>         return ret;
>  }
>
> -static char *ref_to_path(struct btrfs_root *fs_root,
> -                        struct btrfs_path *path,
> -                        u32 name_len, unsigned long name_off,
> -                        struct extent_buffer *eb_in, u64 parent,
> -                        char *dest, u32 size)
> +char *btrfs_ref_to_path(struct btrfs_root *fs_root, struct btrfs_path *path,
> +                       u32 name_len, unsigned long name_off,
> +                       struct extent_buffer *eb_in, u64 parent,
> +                       char *dest, u32 size)
>  {
>         int slot;
>         u64 next_inum;
> @@ -1266,10 +1265,10 @@ char *btrfs_iref_to_path(struct btrfs_root *fs_root,
>                          struct extent_buffer *eb_in, u64 parent,
>                          char *dest, u32 size)
>  {
> -       return ref_to_path(fs_root, path,
> -                          btrfs_inode_ref_name_len(eb_in, iref),
> -                          (unsigned long)(iref + 1),
> -                          eb_in, parent, dest, size);
> +       return btrfs_ref_to_path(fs_root, path,
> +                                btrfs_inode_ref_name_len(eb_in, iref),
> +                                (unsigned long)(iref + 1),
> +                                eb_in, parent, dest, size);
>  }
>
>  /*
> @@ -1715,9 +1714,8 @@ static int inode_to_path(u64 inum, u32 name_len, unsigned long name_off,
>                                         ipath->fspath->bytes_left - s_ptr : 0;
>
>         fspath_min = (char *)ipath->fspath->val + (i + 1) * s_ptr;
> -       fspath = ref_to_path(ipath->fs_root, ipath->btrfs_path, name_len,
> -                            name_off, eb, inum, fspath_min,
> -                            bytes_left);
> +       fspath = btrfs_ref_to_path(ipath->fs_root, ipath->btrfs_path, name_len,
> +                                  name_off, eb, inum, fspath_min, bytes_left);
>         if (IS_ERR(fspath))
>                 return PTR_ERR(fspath);
>
> diff --git a/fs/btrfs/backref.h b/fs/btrfs/backref.h
> index e755330..d61feca 100644
> --- a/fs/btrfs/backref.h
> +++ b/fs/btrfs/backref.h
> @@ -62,6 +62,10 @@ int btrfs_find_all_roots(struct btrfs_trans_handle *trans,
>  char *btrfs_iref_to_path(struct btrfs_root *fs_root, struct btrfs_path *path,
>                          struct btrfs_inode_ref *iref, struct extent_buffer *eb,
>                          u64 parent, char *dest, u32 size);
> +char *btrfs_ref_to_path(struct btrfs_root *fs_root, struct btrfs_path *path,
> +                       u32 name_len, unsigned long name_off,
> +                       struct extent_buffer *eb_in, u64 parent,
> +                       char *dest, u32 size);
>
>  struct btrfs_data_container *init_data_container(u32 total_bytes);
>  struct inode_fs_paths *init_ipath(s32 total_bytes, struct btrfs_root *fs_root,
> diff --git a/fs/btrfs/send.c b/fs/btrfs/send.c
> index c7beb54..26c8343 100644
> --- a/fs/btrfs/send.c
> +++ b/fs/btrfs/send.c
> @@ -745,31 +745,36 @@ typedef int (*iterate_inode_ref_t)(int num, u64 dir, int index,
>                                    void *ctx);
>
>  /*
> - * Helper function to iterate the entries in ONE btrfs_inode_ref.
> + * Helper function to iterate the entries in ONE btrfs_inode_ref or
> + * btrfs_inode_extref.
>   * The iterate callback may return a non zero value to stop iteration. This can
>   * be a negative value for error codes or 1 to simply stop it.
>   *
> - * path must point to the INODE_REF when called.
> + * path must point to the INODE_REF or INODE_EXTREF when called.
>   */
>  static int iterate_inode_ref(struct send_ctx *sctx,
>                              struct btrfs_root *root, struct btrfs_path *path,
>                              struct btrfs_key *found_key, int resolve,
>                              iterate_inode_ref_t iterate, void *ctx)
>  {
> -       struct extent_buffer *eb;
> +       struct extent_buffer *eb = path->nodes[0];
>         struct btrfs_item *item;
>         struct btrfs_inode_ref *iref;
> +       struct btrfs_inode_extref *extref;
>         struct btrfs_path *tmp_path;
>         struct fs_path *p;
> -       u32 cur;
> -       u32 len;
> +       u32 cur = 0;
>         u32 total;
> -       int slot;
> +       int slot = path->slots[0];
>         u32 name_len;
>         char *start;
>         int ret = 0;
> -       int num;
> +       int num = 0;
>         int index;
> +       u64 dir;
> +       unsigned long name_off;
> +       unsigned long elem_size;
> +       unsigned long ptr;
>
>         p = fs_path_alloc_reversed(sctx);
>         if (!p)
> @@ -781,24 +786,40 @@ static int iterate_inode_ref(struct send_ctx *sctx,
>                 return -ENOMEM;
>         }
>
> -       eb = path->nodes[0];
> -       slot = path->slots[0];
> -       item = btrfs_item_nr(eb, slot);
> -       iref = btrfs_item_ptr(eb, slot, struct btrfs_inode_ref);
> -       cur = 0;
> -       len = 0;
> -       total = btrfs_item_size(eb, item);
>
> -       num = 0;
> +       if (found_key->type == BTRFS_INODE_REF_KEY) {
> +               ptr = (unsigned long)btrfs_item_ptr(eb, slot,
> +                                                   struct btrfs_inode_ref);
> +               item = btrfs_item_nr(eb, slot);
> +               total = btrfs_item_size(eb, item);
> +               elem_size = sizeof(*iref);
> +       } else {
> +               ptr = btrfs_item_ptr_offset(eb, slot);
> +               total = btrfs_item_size_nr(eb, slot);
> +               elem_size = sizeof(*extref);
> +       }
> +
>         while (cur < total) {
>                 fs_path_reset(p);
>
> -               name_len = btrfs_inode_ref_name_len(eb, iref);
> -               index = btrfs_inode_ref_index(eb, iref);
> +               if (found_key->type == BTRFS_INODE_REF_KEY) {
> +                       iref = (struct btrfs_inode_ref *)(ptr + cur);
> +                       name_len = btrfs_inode_ref_name_len(eb, iref);
> +                       name_off = (unsigned long)(iref + 1);
> +                       index = btrfs_inode_ref_index(eb, iref);
> +                       dir = found_key->offset;
> +               } else {
> +                       extref = (struct btrfs_inode_extref *)(ptr + cur);
> +                       name_len = btrfs_inode_extref_name_len(eb, extref);
> +                       name_off = (unsigned long)&extref->name;
> +                       index = btrfs_inode_extref_index(eb, extref);
> +                       dir = btrfs_inode_extref_parent(eb, extref);
> +               }
> +
>                 if (resolve) {
> -                       start = btrfs_iref_to_path(root, tmp_path, iref, eb,
> -                                               found_key->offset, p->buf,
> -                                               p->buf_len);
> +                       start = btrfs_ref_to_path(root, tmp_path, name_len,
> +                                                 name_off, eb, dir,
> +                                                 p->buf, p->buf_len);
>                         if (IS_ERR(start)) {
>                                 ret = PTR_ERR(start);
>                                 goto out;
> @@ -809,9 +830,10 @@ static int iterate_inode_ref(struct send_ctx *sctx,
>                                                 p->buf_len + p->buf - start);
>                                 if (ret < 0)
>                                         goto out;
> -                               start = btrfs_iref_to_path(root, tmp_path, iref,
> -                                               eb, found_key->offset, p->buf,
> -                                               p->buf_len);
> +                               start = btrfs_ref_to_path(root, tmp_path,
> +                                                         name_len, name_off,
> +                                                         eb, dir,
> +                                                         p->buf, p->buf_len);
>                                 if (IS_ERR(start)) {
>                                         ret = PTR_ERR(start);
>                                         goto out;
> @@ -820,21 +842,16 @@ static int iterate_inode_ref(struct send_ctx *sctx,
>                         }
>                         p->start = start;
>                 } else {
> -                       ret = fs_path_add_from_extent_buffer(p, eb,
> -                                       (unsigned long)(iref + 1), name_len);
> +                       ret = fs_path_add_from_extent_buffer(p, eb, name_off,
> +                                                            name_len);
>                         if (ret < 0)
>                                 goto out;
>                 }
>
> -
> -               len = sizeof(*iref) + name_len;
> -               iref = (struct btrfs_inode_ref *)((char *)iref + len);
> -               cur += len;
> -
> -               ret = iterate(num, found_key->offset, index, p, ctx);
> +               cur += elem_size + name_len;
> +               ret = iterate(num, dir, index, p, ctx);
>                 if (ret)
>                         goto out;
> -
>                 num++;
>         }
>
> @@ -993,12 +1010,17 @@ static int get_inode_path(struct send_ctx *sctx, struct btrfs_root *root,
>         if (ret < 0)
>                 goto out;
>         if (ret) {
> -               ret = 1;
> -               goto out;
> +               key.type = BTRFS_INODE_EXTREF_KEY;
According to code, btrfs_search_slot_for_read(INODE_REF,
find_higher=1, return_any=0) returns 1, only in case btrfs_next_leaf()
returns 1, which means there are no more items at all (or, if you have
Josef's patch, no more items with the same objectid). Otherwise, it
may bring us to INODE_EXTREF, but key.type will still be INODE_REF,
while found_key.type will be INODE_EXTREF. So the test below that
compares key and found_key will make us return -ENOENT. And in case
btrfs_search_slot_for_read() returns 1, we don't have to search more,
I think.
So shouldn't it be something like:
ret = btrfs_search_slot_for_read(INODE_REF, find_higher=1, return_any=0)
if (ret) {
    ret =1
    goto out;
}
btrfs_item_key_to_cpu(p->nodes[0], &found_key, p->slots[0]);
if (found_key.objectid != ino || (found_key.type!= INODE_REF &&
found_key.type != INODE_EXTREF))
...



> +               ret = btrfs_search_slot_for_read(root, &key, p, 1, 0);
> +               if (ret < 0)
> +                       goto out;
> +               if (ret) {
> +                       ret = 1;
> +                       goto out;
> +               }
>         }
>         btrfs_item_key_to_cpu(p->nodes[0], &found_key, p->slots[0]);
> -       if (found_key.objectid != ino ||
> -               found_key.type != BTRFS_INODE_REF_KEY) {
> +       if (found_key.objectid != key.objectid || found_key.type != key.type) {
>                 ret = -ENOENT;
>                 goto out;
>         }
> @@ -1551,7 +1573,6 @@ static int get_first_ref(struct send_ctx *sctx,
>         struct btrfs_key key;
>         struct btrfs_key found_key;
>         struct btrfs_path *path;
> -       struct btrfs_inode_ref *iref;
>         int len;
>
>         path = alloc_path_for_send();
> @@ -1565,6 +1586,10 @@ static int get_first_ref(struct send_ctx *sctx,
>         ret = btrfs_search_slot_for_read(root, &key, path, 1, 0);
>         if (ret < 0)
>                 goto out;
> +       if (ret) {
> +               key.type = BTRFS_INODE_EXTREF_KEY;
> +               ret = btrfs_search_slot_for_read(root, &key, path, 1, 0);
Same here, I think.

> +       }
>         if (!ret)
>                 btrfs_item_key_to_cpu(path->nodes[0], &found_key,
>                                 path->slots[0]);
> @@ -1574,11 +1599,22 @@ static int get_first_ref(struct send_ctx *sctx,
>                 goto out;
>         }
>
> -       iref = btrfs_item_ptr(path->nodes[0], path->slots[0],
> -                       struct btrfs_inode_ref);
> -       len = btrfs_inode_ref_name_len(path->nodes[0], iref);
> -       ret = fs_path_add_from_extent_buffer(name, path->nodes[0],
> -                       (unsigned long)(iref + 1), len);
> +       if (key.type == BTRFS_INODE_REF_KEY) {
> +               struct btrfs_inode_ref *iref;
> +               iref = btrfs_item_ptr(path->nodes[0], path->slots[0],
> +                                     struct btrfs_inode_ref);
> +               len = btrfs_inode_ref_name_len(path->nodes[0], iref);
> +               ret = fs_path_add_from_extent_buffer(name, path->nodes[0],
> +                                                    (unsigned long)(iref + 1),
> +                                                    len);
> +       } else {
> +               struct btrfs_inode_extref *extref;
> +               extref = btrfs_item_ptr(path->nodes[0], path->slots[0],
> +                                       struct btrfs_inode_extref);
> +               len = btrfs_inode_extref_name_len(path->nodes[0], extref);
> +               ret = fs_path_add_from_extent_buffer(name, path->nodes[0],
> +                                       (unsigned long)&extref->name, len);
> +       }
>         if (ret < 0)
>                 goto out;
>         btrfs_release_path(path);
> @@ -3218,6 +3254,10 @@ static int process_all_refs(struct send_ctx *sctx,
>                 ret = btrfs_search_slot_for_read(root, &key, path, 1, 0);
>                 if (ret < 0)
>                         goto out;
> +               if (ret && key.type == BTRFS_INODE_REF_KEY) {
> +                       key.type = BTRFS_INODE_EXTREF_KEY;
> +                       continue;
> +               }
And here.

>                 if (ret)
>                         break;
>
> @@ -3987,7 +4027,7 @@ static int process_recorded_refs_if_needed(struct send_ctx *sctx, int at_end)
>         if (sctx->cur_ino == 0)
>                 goto out;
>         if (!at_end && sctx->cur_ino == sctx->cmp_key->objectid &&
> -           sctx->cmp_key->type <= BTRFS_INODE_REF_KEY)
> +           sctx->cmp_key->type <= BTRFS_INODE_EXTREF_KEY)
>                 goto out;
>         if (list_empty(&sctx->new_refs) && list_empty(&sctx->deleted_refs))
>                 goto out;
> @@ -4335,7 +4375,8 @@ static int changed_cb(struct btrfs_root *left_root,
>
>         if (key->type == BTRFS_INODE_ITEM_KEY)
>                 ret = changed_inode(sctx, result);
> -       else if (key->type == BTRFS_INODE_REF_KEY)
> +       else if (key->type == BTRFS_INODE_REF_KEY ||
> +                key->type == BTRFS_INODE_EXTREF_KEY)
>                 ret = changed_ref(sctx, result);
>         else if (key->type == BTRFS_XATTR_ITEM_KEY)
>                 ret = changed_xattr(sctx, result);
> --
> 1.7.1
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

Alex.
