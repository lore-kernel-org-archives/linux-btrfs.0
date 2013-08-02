Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-bk0-f45.google.com ([209.85.214.45]:49051 "EHLO
	mail-bk0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750742Ab3HBOyE (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Fri, 2 Aug 2013 10:54:04 -0400
Received: by mail-bk0-f45.google.com with SMTP id je2so235453bkc.18
        for <linux-btrfs@vger.kernel.org>; Fri, 02 Aug 2013 07:54:02 -0700 (PDT)
MIME-Version: 1.0
Reply-To: fdmanana@gmail.com
In-Reply-To: <1375280638-1961-1-git-send-email-jbacik@fusionio.com>
References: <1375280638-1961-1-git-send-email-jbacik@fusionio.com>
Date: Fri, 2 Aug 2013 15:54:02 +0100
Message-ID: <CAL3q7H7FsNbR8nJy2ntvuR=xs+o=XU3gogFZ7jOaJwGpYDhPQg@mail.gmail.com>
Subject: Re: [PATCH] Btrfs-progs: sanitize xattrs when we specify sanitization
From: Filipe David Manana <fdmanana@gmail.com>
To: Josef Bacik <jbacik@fusionio.com>
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Jul 31, 2013 at 3:23 PM, Josef Bacik <jbacik@fusionio.com> wrote:
> Alexandre pointed out that his xattrs have sensitive information in them as
> well, so fix btrfs-image to zero out the data part of xattrs that we find.
> Thanks,
>
> Signed-off-by: Josef Bacik <jbacik@fusionio.com>
> ---
>  btrfs-image.c |   19 +++++++++++++++++++
>  1 files changed, 19 insertions(+), 0 deletions(-)
>
> diff --git a/btrfs-image.c b/btrfs-image.c
> index 82aa4f3..025facf 100644
> --- a/btrfs-image.c
> +++ b/btrfs-image.c
> @@ -162,6 +162,7 @@ static int has_name(struct btrfs_key *key)
>         case BTRFS_DIR_INDEX_KEY:
>         case BTRFS_INODE_REF_KEY:
>         case BTRFS_INODE_EXTREF_KEY:
> +       case BTRFS_XATTR_ITEM_KEY:
>                 return 1;
>         default:
>                 break;
> @@ -446,6 +447,21 @@ static void sanitize_inode_ref(struct metadump_struct *md,
>         }
>  }
>
> +static void sanitize_xattr(struct metadump_struct *md,
> +                          struct extent_buffer *eb, int slot)
> +{
> +       struct btrfs_dir_item *dir_item;
> +       unsigned long data_ptr;
> +       u32 data_len;
> +
> +       dir_item = btrfs_item_ptr(eb, slot, struct btrfs_dir_item);
> +       data_len = btrfs_dir_data_len(eb, dir_item);
> +
> +       data_ptr = (unsigned long)((char *)(dir_item + 1) +
> +                                  btrfs_dir_name_len(eb, dir_item));
> +       memset_extent_buffer(eb, 0, data_ptr, data_len);
> +}
> +
>  static void sanitize_name(struct metadump_struct *md, u8 *dst,
>                           struct extent_buffer *src, struct btrfs_key *key,
>                           int slot)
> @@ -471,6 +487,9 @@ static void sanitize_name(struct metadump_struct *md, u8 *dst,
>         case BTRFS_INODE_EXTREF_KEY:
>                 sanitize_inode_ref(md, eb, slot, 1);
>                 break;
> +       case BTRFS_XATTR_ITEM_KEY:
> +               sanitize_xattr(md, eb, slot);
> +               break;
>         default:
>                 break;
>         }
> --
> 1.7.7.6
>
> --

Reviewed-by: Filipe Manana <fdmanana@gmail.com>


> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



-- 
Filipe David Manana,

"Reasonable men adapt themselves to the world.
 Unreasonable men adapt the world to themselves.
 That's why all progress depends on unreasonable men."
