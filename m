Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:60501 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757535AbcCUT1b (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 21 Mar 2016 15:27:31 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 033CD20328
	for <linux-btrfs@vger.kernel.org>; Mon, 21 Mar 2016 18:50:49 +0000 (UTC)
Received: from mail-io0-f180.google.com (mail-io0-f180.google.com [209.85.223.180])
	(using TLSv1.2 with cipher AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPSA id 2B71A2021B
	for <linux-btrfs@vger.kernel.org>; Mon, 21 Mar 2016 18:50:48 +0000 (UTC)
Received: by mail-io0-f180.google.com with SMTP id m184so220217920iof.1
        for <linux-btrfs@vger.kernel.org>; Mon, 21 Mar 2016 11:50:48 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1457608186-18030-1-git-send-email-alex@zadarastorage.com>
References: <1457608186-18030-1-git-send-email-alex@zadarastorage.com>
Date: Mon, 21 Mar 2016 18:50:47 +0000
Message-ID: <CAL3q7H4kR52K-G6bCtJwJt3aGbwnpjPzHfcvi=oOnWLVJ_d4gA@mail.gmail.com>
Subject: Re: [PATCH 1/2] btrfs: csum_tree_block: return proper errno value
From: Filipe Manana <fdmanana@kernel.org>
To: Alex Lyakas <alex.bolshoy@gmail.com>
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
        Alex Lyakas <alex@zadarastorage.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Mar 10, 2016 at 11:09 AM, Alex Lyakas <alex.bolshoy@gmail.com> wrote:
> Signed-off-by: Alex Lyakas <alex@zadarastorage.com>
Reviewed-by: Filipe Manana <fdmanana@suse.com>

> ---
>  fs/btrfs/disk-io.c | 13 +++++--------
>  1 file changed, 5 insertions(+), 8 deletions(-)
>
> diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
> index 4545e2e..4420ab2 100644
> --- a/fs/btrfs/disk-io.c
> +++ b/fs/btrfs/disk-io.c
> @@ -296,52 +296,52 @@ static int csum_tree_block(struct btrfs_fs_info *fs_info,
>         unsigned long map_len;
>         int err;
>         u32 crc = ~(u32)0;
>         unsigned long inline_result;
>
>         len = buf->len - offset;
>         while (len > 0) {
>                 err = map_private_extent_buffer(buf, offset, 32,
>                                         &kaddr, &map_start, &map_len);
>                 if (err)
> -                       return 1;
> +                       return err;
>                 cur_len = min(len, map_len - (offset - map_start));
>                 crc = btrfs_csum_data(kaddr + offset - map_start,
>                                       crc, cur_len);
>                 len -= cur_len;
>                 offset += cur_len;
>         }
>         if (csum_size > sizeof(inline_result)) {
>                 result = kzalloc(csum_size, GFP_NOFS);
>                 if (!result)
> -                       return 1;
> +                       return -ENOMEM;
>         } else {
>                 result = (char *)&inline_result;
>         }
>
>         btrfs_csum_final(crc, result);
>
>         if (verify) {
>                 if (memcmp_extent_buffer(buf, result, 0, csum_size)) {
>                         u32 val;
>                         u32 found = 0;
>                         memcpy(&found, result, csum_size);
>
>                         read_extent_buffer(buf, &val, 0, csum_size);
>                         btrfs_warn_rl(fs_info,
>                                 "%s checksum verify failed on %llu wanted %X found %X "
>                                 "level %d",
>                                 fs_info->sb->s_id, buf->start,
>                                 val, found, btrfs_header_level(buf));
>                         if (result != (char *)&inline_result)
>                                 kfree(result);
> -                       return 1;
> +                       return -EUCLEAN;
>                 }
>         } else {
>                 write_extent_buffer(buf, result, 0, csum_size);
>         }
>         if (result != (char *)&inline_result)
>                 kfree(result);
>         return 0;
>  }
>
>  /*
> @@ -509,22 +509,21 @@ static int csum_dirty_buffer(struct btrfs_fs_info *fs_info, struct page *page)
>         u64 start = page_offset(page);
>         u64 found_start;
>         struct extent_buffer *eb;
>
>         eb = (struct extent_buffer *)page->private;
>         if (page != eb->pages[0])
>                 return 0;
>         found_start = btrfs_header_bytenr(eb);
>         if (WARN_ON(found_start != start || !PageUptodate(page)))
>                 return 0;
> -       csum_tree_block(fs_info, eb, 0);
> -       return 0;
> +       return csum_tree_block(fs_info, eb, 0);
>  }
>
>  static int check_tree_block_fsid(struct btrfs_fs_info *fs_info,
>                                  struct extent_buffer *eb)
>  {
>         struct btrfs_fs_devices *fs_devices = fs_info->fs_devices;
>         u8 fsid[BTRFS_UUID_SIZE];
>         int ret = 1;
>
>         read_extent_buffer(eb, fsid, btrfs_header_fsid(), BTRFS_FSID_SIZE);
> @@ -653,24 +652,22 @@ static int btree_readpage_end_io_hook(struct btrfs_io_bio *io_bio,
>                 btrfs_err(root->fs_info, "bad tree block level %d",
>                            (int)btrfs_header_level(eb));
>                 ret = -EIO;
>                 goto err;
>         }
>
>         btrfs_set_buffer_lockdep_class(btrfs_header_owner(eb),
>                                        eb, found_level);
>
>         ret = csum_tree_block(root->fs_info, eb, 1);
> -       if (ret) {
> -               ret = -EIO;
> +       if (ret)
>                 goto err;
> -       }
>
>         /*
>          * If this is a leaf block and it is corrupt, set the corrupt bit so
>          * that we don't try and read the other copies of this block, just
>          * return -EIO.
>          */
>         if (found_level == 0 && check_leaf(root, eb)) {
>                 set_bit(EXTENT_BUFFER_CORRUPT, &eb->bflags);
>                 ret = -EIO;
>         }
> --
> 1.9.1
>
