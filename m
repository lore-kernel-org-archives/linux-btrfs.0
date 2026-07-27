Received: from mail-wm1-f41.google.com (mail-wm1-f41.google.com [209.85.128.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4638831714F
	for <linux-btrfs@vger.kernel.org>; Mon, 27 Jul 2026 08:43:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.128.41
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785141830; cv=pass; b=POCuR0mkV7tVP46vyfUy/Y/cVcNCqC6C3CWqXOnchpvcaj7t+ecJJK7m5wz66bqIr18a3NRDeqCTiNNe3H1WMBtm8CesdnPkxn4iCiOOCjz03KEygvPvkn4+YyHgLtcKAKnyADxD5BxN4pk+1izn/XrQX5UCwa1zhFLJoE64DXU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785141830; c=relaxed/simple;
	bh=NqjSIjq3Hto+izLhh9wf+S20YdAZ51IrTg6YW6lJk38=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Lnm5/Sbwt5BzE40QNnZOaK7aA/pBc0wIG5OAOab1HNVinmVdE9232H+Q4D8K5M2OVPk38Vq9TGI3lqfeDiAy7AL9+jaHxDIhBJ11ALqfJ+EVWdASwBJclHV5XfX1jpO0+OAvtrqRcjpzR0KnsazOCr7qlDE7EU0+ex3nzp8tBVU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=WATBBvWK; arc=pass smtp.client-ip=209.85.128.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="WATBBvWK"
Received: by mail-wm1-f41.google.com with SMTP id 5b1f17b1804b1-49550ec592cso21564245e9.0
        for <linux-btrfs@vger.kernel.org>; Mon, 27 Jul 2026 01:43:47 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1785141826; cv=none;
        d=google.com; s=arc-20260327;
        b=OgsJRSPB6gGpRSlC5xDcOLYN6jyDrZSGerIn4HLdV4ralqQaEIsvGqTSTrcsijY3YM
         5NKOI02pcbkvWQp8AsbQBrxIiLdg1WgRfHSFbiXdUdI/uWHfODU5NkqrcViIeUGQDd2n
         j+LS6wLMPzGygV2K1+xbZcAieVA4ff/HwQtJSnu70c0bDEILgcczBtdvOe1TDqVKpP5s
         u0l2yuPSNJxOxiJRMJYWjcXe9E8SOOHD0Vq+J0ucJOOBKZldbpqIRN9l7vmvxzw4dwz7
         ODt7MPEq5rS545H/aIYNgOATSbHKbaHO/bgkrYQlkrQfS0vopjPaCnoqwvU7PIFieJ7C
         iMqw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=aC0OmtiCKoTlc/uLaZgba/Jwdxxjf3ffy2kkrft60vA=;
        fh=gccavu6KskZuhdxKZGGZqKbRpE8AZv+Jw1v9OVMw784=;
        b=jqiODd6GI1axKDJyNj9g+vRTpw/uGLeILM8ljHScAwF+m4913IGtAhTb2ysabZcSZ6
         S9eMQ/qW3iqCdwQO7LlBZqhAGT0sHWxOPSDxd4pXvE/BXMR4J3udVtO6mwBi1yBJ1jHl
         kRAoYTlpKp8Kv//U3YGX1xnjb8gCbVZL/qZ3S1mde6M4j3RGz1YHpZSy9vSDs3yComUe
         q5EiWnsszwwVAx3G1Xkes+RY085nyEG7t9rV//Hx3eKbXbiGSM/dwk81Qxi1+TXdbwrP
         MhfOl0UaudsiRRL13/FRX8mG880KxNiJXSbRJ6uuOihEYk/vv63nZtpu7PJGhV0snJJ+
         fqyw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1785141826; x=1785746626; darn=vger.kernel.org;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=aC0OmtiCKoTlc/uLaZgba/Jwdxxjf3ffy2kkrft60vA=;
        b=WATBBvWKhod75Z82RtshMiQAAu2G3CZKiT6l044glxJ5Iwmd5qK0I4+H75qQ/7a5MG
         hhQS7XrDUUi2eBwHLmu392hMgidFW9m3QQ/hioJmuRcZtqXOEiKxylRUL3YseYLGhfPT
         4fjVW1dPNFsyCw90muqYoWMpLWfivhv8KxkdBQ2/SfQH2v3TNbmwsdGvNdu4MgXCbfYw
         XuhgAfWIS4ZPa29C9DEoXOtbqfPLTBZ5yG76y3FYbjaqd4QhSp0ajUfwMaXscyWYPTNH
         MXgEVt2PK2gkTol18yU9qK5dvyoDKdWFdPx+hJqtGQ53PR+ENGpTsZuULgRwgmmzyyB6
         eoRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785141826; x=1785746626;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=aC0OmtiCKoTlc/uLaZgba/Jwdxxjf3ffy2kkrft60vA=;
        b=MhGNgpsoOwamJEBBG/Rmxn4uoexvb39PFtT0be2iFpDP7oXAQuo3Lpt9fRYysarmXe
         SCDXBKvPYmNXUCcGIMa4D52QO5RaRpYw9fq0hBOK+mz1lzt0QbQXCZgopC/9gIDiDEqs
         LHytIZNoZ0rbl8pDoksjsn9wm3IxPYAE6bJG1BOKIwjlpk3idrpDe0yPuyXrWbxTezTS
         SkeR9gZBO3qhw/W+WKlOKOtd0CpMKUDDS3iMVFMK4Ga+mfaK53fcV7UP9KqKGO1uNO51
         960XKn5qPmLXyIT4LzgJ+FnYlwGngCqC7OVm0Lqfj/Q6o51XiynCMJQNXa0RWwmJXXkd
         /Baw==
X-Gm-Message-State: AOJu0YwfWD+/7x2TAItiPgaixqaVPD55EpKmP+mmcEAyODiMeaGMQ1Nr
	BbFtkKwWm6TWRgcanw05iRufR0Cac39tjWqNwws8L67X+NANkB1ILh8P2Ms2PMRF7HM2ErPBUoy
	S9QeB8AIH6/Pa+PQOL8hcMrKN/K5XfIbJivqPVIsi+g==
X-Gm-Gg: AR+sD12CVEfDTHf13wuahroBBvp4NgcTYzqUd+GK/FZKGteKkaAcOqLgUQGoF6aTd/5
	m2JhRZy/mFLHefoW4sKcSW3oGZ6kyg96NiDrdMzFbw2YFDFmy+HxZXAktqNIorUDo2lNnQ2Xeko
	YXtHrxN0gCtGIi5FzoYIWyL/tLtlTqpiyubOLxl6T/1wxgzKSCIM7l6zo/ihACUVY64YegNZzaH
	0wyDy4SsrDsD+WWUAWYXSy30mvOv7h9UwL7v1jxbLz7kXbMV9kjlOSgsXSqgvf59UVYYvi60aEW
	7qpMoaE3QcxJZ7ghHOGz1N9avuGh4eUn7gTDbNrrnptoa/NqT02vo1xNJfFm3BFvZnZT2y1Fu/T
	XyMhn
X-Received: by 2002:a05:600c:e548:10b0:495:71e9:d92b with SMTP id
 5b1f17b1804b1-496b4f1e284mr66017815e9.10.1785141826287; Mon, 27 Jul 2026
 01:43:46 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <36ca71a749dbd364736747bc23c3ca8c44ef6cbc.1785107778.git.wqu@suse.com>
In-Reply-To: <36ca71a749dbd364736747bc23c3ca8c44ef6cbc.1785107778.git.wqu@suse.com>
From: Daniel Vacek <neelx@suse.com>
Date: Mon, 27 Jul 2026 10:43:35 +0200
X-Gm-Features: AUfX_mzo3hMLpl5Sfd2ko52FOL4N__zOFd579N5ckYBYZPWh4roIZV5Jv7xF_kU
Message-ID: <CAPjX3Fdk=XRpOnOr6RnwjGUcoaVk7O=qvst68eH3DE8QnC-fUg@mail.gmail.com>
Subject: Re: [PATCH] btrfs: convert reflink.c to use btrfs_inode as parameters
To: Qu Wenruo <wqu@suse.com>
Cc: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

On Mon, 27 Jul 2026 at 01:20, Qu Wenruo <wqu@suse.com> wrote:
> Inside reflink.c we still have a lot of functions passing vanilla inode
> pointers, then internally convert them into btrfs_inode pointers.
>
> For example, inside btrfs_clone(), we have 12 BTRFS_I() call sites,
> meanwhile only 3 callsites that really require a vanilla inode pointer.
>
> This patch do the cleanup to convert the following functions to pass a
> btrfs_inode pointer instead of a vanilla inode pointer:
>
> - btrfs_clone()
> - btrfs_extent_same_range()
> - clone_finish_inode_update().
>
> Which covers all ad-hoc BTRFS_I() call sites inside reflink.c.
>
> Signed-off-by: Qu Wenruo <wqu@suse.com>

Looks good to me.
Reviewed-by: Daniel Vacek <neelx@suse.com>

Just one small nit below..

> ---
>  fs/btrfs/reflink.c | 96 +++++++++++++++++++++++-----------------------
>  1 file changed, 48 insertions(+), 48 deletions(-)
>
> diff --git a/fs/btrfs/reflink.c b/fs/btrfs/reflink.c
> index 28bb05a92106..a3b71d2067b7 100644
> --- a/fs/btrfs/reflink.c
> +++ b/fs/btrfs/reflink.c
> @@ -20,17 +20,18 @@
>  #define BTRFS_MAX_DEDUPE_LEN   SZ_16M
>
>  static int clone_finish_inode_update(struct btrfs_trans_handle *trans,
> -                                    struct inode *inode,
> +                                    struct btrfs_inode *inode,
>                                      u64 endoff,
>                                      const u64 destoff,
>                                      const u64 olen,
>                                      bool no_time_update)
>  {
> +       struct inode *vfs_inode = &inode->vfs_inode;
>         int ret;
>
> -       inode_inc_iversion(inode);
> +       inode_inc_iversion(vfs_inode);
>         if (!no_time_update) {
> -               inode_set_mtime_to_ts(inode, inode_set_ctime_current(inode));
> +               inode_set_mtime_to_ts(vfs_inode, inode_set_ctime_current(vfs_inode));
>         }
>         /*
>          * We round up to the block size at eof when determining which
> @@ -38,12 +39,12 @@ static int clone_finish_inode_update(struct btrfs_trans_handle *trans,
>          */
>         if (endoff > destoff + olen)
>                 endoff = destoff + olen;
> -       if (endoff > inode->i_size) {
> -               i_size_write(inode, endoff);
> -               btrfs_inode_safe_disk_i_size_write(BTRFS_I(inode), 0);
> +       if (endoff > vfs_inode->i_size) {
> +               i_size_write(vfs_inode, endoff);
> +               btrfs_inode_safe_disk_i_size_write(inode, 0);
>         }
>
> -       ret = btrfs_update_inode(trans, BTRFS_I(inode));
> +       ret = btrfs_update_inode(trans, inode);
>         if (unlikely(ret)) {
>                 btrfs_abort_transaction(trans, ret);
>                 btrfs_end_transaction(trans);
> @@ -392,11 +393,11 @@ static int clone_copy_inline_extent(struct btrfs_inode *inode,
>   * @destoff:         Offset within @inode to start clone
>   * @no_time_update:  Whether to update mtime/ctime on the target inode
>   */
> -static int btrfs_clone(struct inode *src, struct inode *inode,
> +static int btrfs_clone(struct btrfs_inode *src, struct btrfs_inode *inode,
>                        const u64 off, const u64 olen, const u64 olen_aligned,
>                        const u64 destoff, bool no_time_update)
>  {
> -       struct btrfs_fs_info *fs_info = inode_to_fs_info(inode);
> +       struct btrfs_fs_info *fs_info = inode->root->fs_info;
>         BTRFS_PATH_AUTO_FREE(path);
>         struct extent_buffer *leaf;
>         struct btrfs_trans_handle *trans;
> @@ -420,7 +421,7 @@ static int btrfs_clone(struct inode *src, struct inode *inode,
>
>         path->reada = READA_FORWARD;
>         /* Clone data */
> -       key.objectid = btrfs_ino(BTRFS_I(src));
> +       key.objectid = btrfs_ino(src);
>         key.type = BTRFS_EXTENT_DATA_KEY;
>         key.offset = off;
>
> @@ -436,8 +437,7 @@ static int btrfs_clone(struct inode *src, struct inode *inode,
>                 u64 drop_start;
>
>                 /* Note the key will change type as we walk through the tree */
> -               ret = btrfs_search_slot(NULL, BTRFS_I(src)->root, &key, path,
> -                               0, 0);
> +               ret = btrfs_search_slot(NULL, src->root, &key, path, 0, 0);
>                 if (ret < 0)
>                         goto out;
>                 /*
> @@ -455,7 +455,7 @@ static int btrfs_clone(struct inode *src, struct inode *inode,
>                 nritems = btrfs_header_nritems(path->nodes[0]);
>  process_slot:
>                 if (path->slots[0] >= nritems) {
> -                       ret = btrfs_next_leaf(BTRFS_I(src)->root, path);
> +                       ret = btrfs_next_leaf(src->root, path);
>                         if (ret < 0)
>                                 goto out;
>                         if (ret > 0)
> @@ -467,7 +467,7 @@ static int btrfs_clone(struct inode *src, struct inode *inode,
>
>                 btrfs_item_key_to_cpu(leaf, &key, slot);
>                 if (key.type > BTRFS_EXTENT_DATA_KEY ||
> -                   key.objectid != btrfs_ino(BTRFS_I(src)))
> +                   key.objectid != btrfs_ino(src))
>                         break;
>
>                 ASSERT(key.type == BTRFS_EXTENT_DATA_KEY, "key.type=%u", key.type);
> @@ -514,7 +514,7 @@ static int btrfs_clone(struct inode *src, struct inode *inode,
>                 btrfs_release_path(path);
>
>                 memcpy(&new_key, &key, sizeof(new_key));
> -               new_key.objectid = btrfs_ino(BTRFS_I(inode));
> +               new_key.objectid = btrfs_ino(inode);
>                 if (off <= key.offset)
>                         new_key.offset = key.offset + destoff - off;
>                 else
> @@ -558,7 +558,7 @@ static int btrfs_clone(struct inode *src, struct inode *inode,
>                         clone_info.extent_buf = buf;
>                         clone_info.is_new_extent = false;
>                         clone_info.update_times = !no_time_update;
> -                       ret = btrfs_replace_file_extents(BTRFS_I(inode), path,
> +                       ret = btrfs_replace_file_extents(inode, path,
>                                         drop_start, new_key.offset + datal - 1,
>                                         &clone_info, &trans);
>                         if (ret)
> @@ -582,7 +582,7 @@ static int btrfs_clone(struct inode *src, struct inode *inode,
>                                 goto out;
>                         }
>
> -                       ret = clone_copy_inline_extent(BTRFS_I(inode), path, &new_key,
> +                       ret = clone_copy_inline_extent(inode, path, &new_key,
>                                                        drop_start, datal, size,
>                                                        comp, buf, &trans);
>                         if (ret)
> @@ -605,9 +605,9 @@ static int btrfs_clone(struct inode *src, struct inode *inode,
>                  * the checksums problem on fsync.
>                  */
>                 if (extent_gen == trans->transid && disko > 0)
> -                       BTRFS_I(src)->last_reflink_trans = trans->transid;
> +                       src->last_reflink_trans = trans->transid;
>
> -               BTRFS_I(inode)->last_reflink_trans = trans->transid;
> +               inode->last_reflink_trans = trans->transid;
>
>                 last_dest_end = ALIGN(new_key.offset + datal,
>                                       fs_info->sectorsize);
> @@ -653,10 +653,10 @@ static int btrfs_clone(struct inode *src, struct inode *inode,
>                  * set by previous calls to btrfs_replace_file_extents() that
>                  * replaced file extent items.
>                  */
> -               if (last_dest_end >= i_size_read(inode))
> -                       btrfs_set_inode_full_sync(BTRFS_I(inode));
> +               if (last_dest_end >= i_size_read(&inode->vfs_inode))
> +                       btrfs_set_inode_full_sync(inode);
>
> -               ret = btrfs_replace_file_extents(BTRFS_I(inode), path,
> +               ret = btrfs_replace_file_extents(inode, path,
>                                 last_dest_end, destoff + len - 1, NULL, &trans);
>                 if (ret)
>                         goto out;
> @@ -666,7 +666,7 @@ static int btrfs_clone(struct inode *src, struct inode *inode,
>         }
>
>  out:
> -       clear_bit(BTRFS_INODE_NO_DELALLOC_FLUSH, &BTRFS_I(inode)->runtime_flags);
> +       clear_bit(BTRFS_INODE_NO_DELALLOC_FLUSH, &inode->runtime_flags);
>
>         return ret;
>  }
> @@ -701,8 +701,7 @@ static int btrfs_extent_same_range(struct btrfs_inode *src, u64 loff, u64 len,
>          * mode.
>          */
>         btrfs_lock_extent(&dst->io_tree, dst_loff, end, &cached_state);
> -       ret = btrfs_clone(&src->vfs_inode, &dst->vfs_inode, loff, len,
> -                         ALIGN(len, bs), dst_loff, true);
> +       ret = btrfs_clone(src, dst, loff, len, ALIGN(len, bs), dst_loff, true);
>         btrfs_unlock_extent(&dst->io_tree, dst_loff, end, &cached_state);
>
>         btrfs_btree_balance_dirty(fs_info);
> @@ -710,12 +709,12 @@ static int btrfs_extent_same_range(struct btrfs_inode *src, u64 loff, u64 len,
>         return ret;
>  }
>
> -static int btrfs_extent_same(struct inode *src, u64 loff, u64 olen,
> -                            struct inode *dst, u64 dst_loff)
> +static int btrfs_extent_same(struct btrfs_inode *src, u64 loff, u64 olen,
> +                            struct btrfs_inode *dst, u64 dst_loff)
>  {
>         int ret = 0;
>         u64 i, tail_len, chunk_count;
> -       struct btrfs_root *root_dst = BTRFS_I(dst)->root;
> +       struct btrfs_root *root_dst = dst->root;
>
>         spin_lock(&root_dst->root_item_lock);
>         if (root_dst->send_in_progress) {
> @@ -733,8 +732,8 @@ static int btrfs_extent_same(struct inode *src, u64 loff, u64 olen,
>         chunk_count = div_u64(olen, BTRFS_MAX_DEDUPE_LEN);
>
>         for (i = 0; i < chunk_count; i++) {
> -               ret = btrfs_extent_same_range(BTRFS_I(src), loff, BTRFS_MAX_DEDUPE_LEN,
> -                                             BTRFS_I(dst), dst_loff);
> +               ret = btrfs_extent_same_range(src, loff, BTRFS_MAX_DEDUPE_LEN,
> +                                             dst, dst_loff);
>                 if (ret)
>                         goto out;
>
> @@ -743,8 +742,8 @@ static int btrfs_extent_same(struct inode *src, u64 loff, u64 olen,
>         }
>
>         if (tail_len > 0)
> -               ret = btrfs_extent_same_range(BTRFS_I(src), loff, tail_len,
> -                                             BTRFS_I(dst), dst_loff);
> +               ret = btrfs_extent_same_range(src, loff, tail_len,
> +                                             dst, dst_loff);
>  out:
>         spin_lock(&root_dst->root_item_lock);
>         root_dst->dedupe_in_progress--;
> @@ -757,9 +756,11 @@ static noinline int btrfs_clone_files(struct file *file, struct file *file_src,
>                                         u64 off, u64 olen, u64 destoff)
>  {
>         struct extent_state *cached_state = NULL;
> -       struct inode *inode = file_inode(file);
> -       struct inode *src = file_inode(file_src);
> -       struct btrfs_fs_info *fs_info = inode_to_fs_info(inode);
> +       struct btrfs_inode *inode = BTRFS_I(file_inode(file));
> +       struct btrfs_inode *src = BTRFS_I(file_inode(file_src));
> +       struct btrfs_fs_info *fs_info = inode->root->fs_info;
> +       const u64 src_isize = src->vfs_inode.i_size;
> +       const u64 inode_isize = inode->vfs_inode.i_size;
>         int ret;
>         u64 len = olen;
>         const u32 bs = fs_info->sectorsize;
> @@ -771,13 +772,13 @@ static noinline int btrfs_clone_files(struct file *file, struct file *file_src,
>          * if the file size is not blocksize aligned. So we don't need to check
>          * for that case here.
>          */
> -       if (off + len == src->i_size)
> -               len = ALIGN(src->i_size, bs) - off;
> +       if (off + len == src_isize)
> +               len = ALIGN(src_isize, bs) - off;
>
> -       if (destoff > inode->i_size) {
> -               const u64 wb_start = ALIGN_DOWN(inode->i_size, bs);
> +       if (destoff > inode_isize) {
> +               const u64 wb_start = ALIGN_DOWN(inode_isize, bs);
>
> -               ret = btrfs_cont_expand(BTRFS_I(inode), inode->i_size, destoff);
> +               ret = btrfs_cont_expand(inode, inode_isize, destoff);
>                 if (ret)
>                         return ret;
>                 /*
> @@ -789,7 +790,7 @@ static noinline int btrfs_clone_files(struct file *file, struct file *file_src,
>                  * we found the previous extent covering eof and before we
>                  * attempted to increment its reference count).
>                  */
> -               ret = btrfs_wait_ordered_range(BTRFS_I(inode), wb_start,
> +               ret = btrfs_wait_ordered_range(inode, wb_start,
>                                                destoff - wb_start);

This could have been a single line.

--nX

>                 if (ret)
>                         return ret;
> @@ -802,9 +803,9 @@ static noinline int btrfs_clone_files(struct file *file, struct file *file_src,
>          * mode.
>          */
>         end = destoff + len - 1;
> -       btrfs_lock_extent(&BTRFS_I(inode)->io_tree, destoff, end, &cached_state);
> +       btrfs_lock_extent(&inode->io_tree, destoff, end, &cached_state);
>         ret = btrfs_clone(src, inode, off, olen, len, destoff, false);
> -       btrfs_unlock_extent(&BTRFS_I(inode)->io_tree, destoff, end, &cached_state);
> +       btrfs_unlock_extent(&inode->io_tree, destoff, end, &cached_state);
>         if (ret < 0)
>                 return ret;
>
> @@ -818,7 +819,7 @@ static noinline int btrfs_clone_files(struct file *file, struct file *file_src,
>          * could come from some range other than the copied inline extent's
>          * destination range and we have no way to know that.
>          */
> -       ret = btrfs_wait_ordered_range(BTRFS_I(inode), destoff, len);
> +       ret = btrfs_wait_ordered_range(inode, destoff, len);
>         if (ret < 0)
>                 return ret;
>
> @@ -826,7 +827,7 @@ static noinline int btrfs_clone_files(struct file *file, struct file *file_src,
>          * Invalidate page cache so that future reads will see the cloned data
>          * immediately and not the previous data.
>          */
> -       ret = filemap_invalidate_inode(inode, false, destoff, end);
> +       ret = filemap_invalidate_inode(&inode->vfs_inode, false, destoff, end);
>         if (ret < 0)
>                 return ret;
>
> @@ -934,7 +935,7 @@ loff_t btrfs_remap_file_range(struct file *src_file, loff_t off,
>         bool same_inode = dst_inode == src_inode;
>         int ret;
>
> -       if (btrfs_is_shutdown(inode_to_fs_info(file_inode(src_file))))
> +       if (btrfs_is_shutdown(src_inode->root->fs_info))
>                 return -EIO;
>
>         if (remap_flags & ~(REMAP_FILE_DEDUP | REMAP_FILE_ADVISORY))
> @@ -953,8 +954,7 @@ loff_t btrfs_remap_file_range(struct file *src_file, loff_t off,
>                 goto out_unlock;
>
>         if (remap_flags & REMAP_FILE_DEDUP)
> -               ret = btrfs_extent_same(&src_inode->vfs_inode, off, len,
> -                                       &dst_inode->vfs_inode, destoff);
> +               ret = btrfs_extent_same(src_inode, off, len, dst_inode, destoff);
>         else
>                 ret = btrfs_clone_files(dst_file, src_file, off, len, destoff);
>
> --
> 2.54.0
>
>
