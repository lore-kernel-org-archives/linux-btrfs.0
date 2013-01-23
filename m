Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wi0-f178.google.com ([209.85.212.178]:46710 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754741Ab3AWL4I (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 23 Jan 2013 06:56:08 -0500
Received: by mail-wi0-f178.google.com with SMTP id hn3so625538wib.5
        for <linux-btrfs@vger.kernel.org>; Wed, 23 Jan 2013 03:56:05 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <50FFC3C6.7040305@cn.fujitsu.com>
References: <50FF58BC.7090604@cn.fujitsu.com>
	<50FFC3C6.7040305@cn.fujitsu.com>
Date: Wed, 23 Jan 2013 13:56:05 +0200
Message-ID: <CAOcd+r0cNNaVFJdTVW_2f6u90u-km02mDtwk3H4Vt-YEcHNzzQ@mail.gmail.com>
Subject: Re: [PATCH] Btrfs/send: sparse and pre-allocated file support for,
 btrfs-send mechanism
From: Alex Lyakas <alex.btrfs@zadarastorage.com>
To: Chen Yang <chenyang.fnst@cn.fujitsu.com>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

On Wed, Jan 23, 2013 at 1:04 PM, Chen Yang <chenyang.fnst@cn.fujitsu.com> wrote:
> From: Chen Yang <chenyang.fnst@cn.fujitsu.com>
> Date: Wed, 23 Jan 2013 11:21:51 +0800
> Subject: [PATCH] Btrfs/send: sparse and pre-allocated file support for
>  btrfs-send mechanism
>
> When sending a file with sparse or pre-allocated part,
> these parts will be sent as ZERO streams, and it's unnecessary.
>
> There are two ways to improve this, one is just skip the EMPTY parts,
> and the other one is to add a punch command to send, when an EMPTY parts
> was detected. But considering a case of incremental sends, if we choose
> the first one, when a hole got punched into the file after the initial
> send, the data will be unchanged on the receiving side when received
> incrementally. So the second choice is right.
>
> Signed-off-by: Cheng Yang <chenyang.fnst@cn.fujitsu.com>
> ---
>  fs/btrfs/send.c |   60 ++++++++++++++++++++++++++++++++++++++++++++++++++++++-
>  fs/btrfs/send.h |    3 +-
>  2 files changed, 61 insertions(+), 2 deletions(-)
>
> diff --git a/fs/btrfs/send.c b/fs/btrfs/send.c
> index 5445454..31e9aef 100644
> --- a/fs/btrfs/send.c
> +++ b/fs/btrfs/send.c
> @@ -3585,6 +3585,52 @@ out:
>         return ret;
>  }
>
> +static int send_punch(struct send_ctx *sctx, u64 offset, u32 len)
> +{
> +       int ret = 0;
> +       struct fs_path *p;
> +       mm_segment_t old_fs;
> +
> +       p = fs_path_alloc(sctx);
> +       if (!p)
> +               return -ENOMEM;
> +
> +       /*
> +        * vfs normally only accepts user space buffers for security reasons.
> +        * we only read from the file and also only provide the read_buf buffer
> +        * to vfs. As this buffer does not come from a user space call, it's
> +        * ok to temporary allow kernel space buffers.
> +        */
> +       old_fs = get_fs();
> +       set_fs(KERNEL_DS);
> +
> +verbose_printk("btrfs: send_fallocate offset=%llu, len=%d\n", offset, len);
> +
> +       ret = open_cur_inode_file(sctx);
> +       if (ret < 0)
> +               goto out;
> +
> +       ret = begin_cmd(sctx, BTRFS_SEND_C_PUNCH);
> +       if (ret < 0)
> +               goto out;
> +
> +       ret = get_cur_path(sctx, sctx->cur_ino, sctx->cur_inode_gen, p);
> +       if (ret < 0)
> +               goto out;
> +
> +       TLV_PUT_PATH(sctx, BTRFS_SEND_A_PATH, p);
> +       TLV_PUT_U64(sctx, BTRFS_SEND_A_FILE_OFFSET, offset);
> +       TLV_PUT_U64(sctx, BTRFS_SEND_A_SIZE, len);
> +
> +       ret = send_cmd(sctx);
> +
> +tlv_put_failure:
> +out:
> +       fs_path_free(sctx, p);
> +       set_fs(old_fs);
> +       return ret;
> +}
> +
>  /*
>   * Read some bytes from the current inode/file and send a write command to
>   * user space.
> @@ -3718,6 +3764,7 @@ static int send_write_or_clone(struct send_ctx *sctx,
>         u64 pos = 0;
>         u64 len;
>         u32 l;
> +       u64 bytenr;
>         u8 type;
>
>         ei = btrfs_item_ptr(path->nodes[0], path->slots[0],
> @@ -3731,8 +3778,19 @@ static int send_write_or_clone(struct send_ctx *sctx,
>                  * sure to send the whole thing
>                  */
>                 len = PAGE_CACHE_ALIGN(len);
> -       } else {
> +       } else if (type == BTRFS_FILE_EXTENT_REG) {
>                 len = btrfs_file_extent_num_bytes(path->nodes[0], ei);
> +               bytenr = btrfs_file_extent_disk_bytenr(path->nodes[0], ei);
> +               if (bytenr == 0) {
> +                       ret = send_punch(sctx, offset, len);
> +                       goto out;
> +               }
> +       } else if (type == BTRFS_FILE_EXTENT_PREALLOC) {
> +               len = btrfs_file_extent_num_bytes(path->nodes[0], ei);
> +               ret = send_punch(sctx, offset, len);
> +               goto out;
> +       } else {
> +               BUG();
>         }

Are these two cases really the same? In the bytenr == 0 we want to
deallocate the range. While in the prealloc case, we want to ensure
disk space allocation. Or am I mistaken?
Looking at the receive side, you use the same command for both:
ret = fallocate(r->write_fd,
               FALLOC_FL_PUNCH_HOLE | FALLOC_FL_KEEP_SIZE,
               offset, len);

Looking at btrfs_fallocate code, in that case it will always punch the hole:
static long btrfs_fallocate(struct file *file, int mode,
			    loff_t offset, loff_t len)
...
	if (mode & FALLOC_FL_PUNCH_HOLE)
		return btrfs_punch_hole(inode, offset, len);

So maybe you should have two different commands, or add a flag to
distinguish between the two cases?

Thanks,
Alex.



>
>         if (offset + len > sctx->cur_inode_size)
> diff --git a/fs/btrfs/send.h b/fs/btrfs/send.h
> index 1bf4f32..659ac8f 100644
> --- a/fs/btrfs/send.h
> +++ b/fs/btrfs/send.h
> @@ -20,7 +20,7 @@
>  #include "ctree.h"
>
>  #define BTRFS_SEND_STREAM_MAGIC "btrfs-stream"
> -#define BTRFS_SEND_STREAM_VERSION 1
> +#define BTRFS_SEND_STREAM_VERSION 2
>
>  #define BTRFS_SEND_BUF_SIZE (1024 * 64)
>  #define BTRFS_SEND_READ_SIZE (1024 * 48)
> @@ -80,6 +80,7 @@ enum btrfs_send_cmd {
>         BTRFS_SEND_C_WRITE,
>         BTRFS_SEND_C_CLONE,
>
> +       BTRFS_SEND_C_PUNCH,
>         BTRFS_SEND_C_TRUNCATE,
>         BTRFS_SEND_C_CHMOD,
>         BTRFS_SEND_C_CHOWN,
> --
> 1.7.7.6
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
