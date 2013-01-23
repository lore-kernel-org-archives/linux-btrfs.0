Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-we0-f177.google.com ([74.125.82.177]:39938 "EHLO
	mail-we0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754707Ab3AWL6w (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 23 Jan 2013 06:58:52 -0500
Received: by mail-we0-f177.google.com with SMTP id d7so1087020wer.36
        for <linux-btrfs@vger.kernel.org>; Wed, 23 Jan 2013 03:58:51 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <50FFC3C1.7020105@cn.fujitsu.com>
References: <50FF58B6.5020102@cn.fujitsu.com>
	<50FFC3C1.7020105@cn.fujitsu.com>
Date: Wed, 23 Jan 2013 13:58:50 +0200
Message-ID: <CAOcd+r0ACHTYFB_Qyxu18a+YvYjmVS+5o4a1_gMB9KE68SD6ew@mail.gmail.com>
Subject: Re: [PATCH] Btrfs-progs/receive: sparse and pre-allocated file
 support, for btrfs-send mechanism
From: Alex Lyakas <alex.btrfs@zadarastorage.com>
To: Chen Yang <chenyang.fnst@cn.fujitsu.com>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Jan 23, 2013 at 1:04 PM, Chen Yang <chenyang.fnst@cn.fujitsu.com> wrote:
> From: Chen Yang <chenyang.fnst@cn.fujitsu.com>
> Date: Fri, 18 Jan 2013 14:54:31 +0800
> Subject: [PATCH] Btrfs-progs/receive: sparse and pre-allocated file support
>  for btrfs-send mechanism
>
> When sending a file with sparse or pre-allocated part,
> these parts will be sent as ZERO streams, and it's unnecessary.
>
> To improve this, we add a punch command on the sending side, so the
> receiving side changed with it. The main change is adding the punch
> processing to receive command.
>
> Signed-off-by: Cheng Yang <chenyang.fnst@cn.fujitsu.com>
> ---
>  cmds-receive.c |   27 +++++++++++++++++++++++++++
>  send-stream.c  |    6 ++++++
>  send-stream.h  |    1 +
>  send.h         |    3 ++-
>  4 files changed, 36 insertions(+), 1 deletions(-)
>
> diff --git a/cmds-receive.c b/cmds-receive.c
> index a8be6fa..74cbfc4 100644
> --- a/cmds-receive.c
> +++ b/cmds-receive.c
> @@ -37,6 +37,7 @@
>  #include <sys/types.h>
>  #include <sys/xattr.h>
>  #include <uuid/uuid.h>
> +#include <linux/falloc.h>
>
>  #include "ctree.h"
>  #include "ioctl.h"
> @@ -508,6 +509,31 @@ out:
>         return ret;
>  }
>
> +static int process_punch(const char *path, u64 offset, u64 len, void *user)
> +{
> +       int ret = 0;
> +       struct btrfs_receive *r = user;
> +       char *full_path = path_cat(r->full_subvol_path, path);
> +
> +       ret = open_inode_for_write(r, full_path);
> +       if (ret < 0)
> +               goto out;
> +
> +       ret = fallocate(r->write_fd,
> +               FALLOC_FL_PUNCH_HOLE | FALLOC_FL_KEEP_SIZE,
> +               offset, len);
> +       if (ret < 0) {
> +               ret = -errno;
> +               fprintf(stderr, "ERROR: punch %s failed. %s\n",
> +                               path, strerror(-ret));
> +               goto out;
> +       }
> +
> +out:
> +       free(full_path);
> +       return ret;
> +}
> +
>  static int process_write(const char *path, const void *data, u64 offset,
>                          u64 len, void *user)
>  {
> @@ -777,6 +803,7 @@ struct btrfs_send_ops send_ops = {
>         .link = process_link,
>         .unlink = process_unlink,
>         .rmdir = process_rmdir,
> +       .punch = process_punch,
>         .write = process_write,
>         .clone = process_clone,
>         .set_xattr = process_set_xattr,
> diff --git a/send-stream.c b/send-stream.c
> index 55fa728..9f3ede7 100644
> --- a/send-stream.c
> +++ b/send-stream.c
> @@ -362,6 +362,12 @@ static int read_and_process_cmd(struct btrfs_send_stream *s)
>                 TLV_GET_STRING(s, BTRFS_SEND_A_PATH, &path);
>                 ret = s->ops->rmdir(path, s->user);
>                 break;
> +       case BTRFS_SEND_C_PUNCH:
> +               TLV_GET_STRING(s, BTRFS_SEND_A_PATH, &path);
> +               TLV_GET_U64(s, BTRFS_SEND_A_FILE_OFFSET, &offset);
> +               TLV_GET_U64(s, BTRFS_SEND_A_SIZE, &len);
> +               ret = s->ops->punch(path, offset, len, s->user);
> +               break;
>         case BTRFS_SEND_C_WRITE:
>                 TLV_GET_STRING(s, BTRFS_SEND_A_PATH, &path);
>                 TLV_GET_U64(s, BTRFS_SEND_A_FILE_OFFSET, &offset);
> diff --git a/send-stream.h b/send-stream.h
> index b69b7f1..f83f2ac 100644
> --- a/send-stream.h
> +++ b/send-stream.h
> @@ -34,6 +34,7 @@ struct btrfs_send_ops {
>         int (*link)(const char *path, const char *lnk, void *user);
>         int (*unlink)(const char *path, void *user);
>         int (*rmdir)(const char *path, void *user);
> +       int (*punch)(const char *path, u64 offset, u64 len, void *user);
>         int (*write)(const char *path, const void *data, u64 offset, u64 len,
>                      void *user);
>         int (*clone)(const char *path, u64 offset, u64 len,
> diff --git a/send.h b/send.h
> index 9934e94..10a88d2 100644
> --- a/send.h
> +++ b/send.h
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

I think this breaks the current protocol, because it changes the
numbers for existing commands, starting from BTRFS_SEND_C_TRUNCATE. I
don't think this will be acceptable for existing users.
I think the new commands should be added after BTRFS_SEND_C_END
command (unfortunately), like the snapper command that was added
recently.

Thanks,
Alex.


> --
> 1.7.7.6
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
