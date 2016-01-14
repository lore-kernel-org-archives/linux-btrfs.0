Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ig0-f194.google.com ([209.85.213.194]:34708 "EHLO
	mail-ig0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752740AbcANJ4N (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 14 Jan 2016 04:56:13 -0500
Received: by mail-ig0-f194.google.com with SMTP id ik10so19653152igb.1
        for <linux-btrfs@vger.kernel.org>; Thu, 14 Jan 2016 01:56:13 -0800 (PST)
MIME-Version: 1.0
Reply-To: fdmanana@gmail.com
In-Reply-To: <1452751054-2365-18-git-send-email-quwenruo@cn.fujitsu.com>
References: <1452751054-2365-1-git-send-email-quwenruo@cn.fujitsu.com>
	<1452751054-2365-18-git-send-email-quwenruo@cn.fujitsu.com>
Date: Thu, 14 Jan 2016 09:56:12 +0000
Message-ID: <CAL3q7H4-Ztmx9Z4=jNT3610Y6eZbL5GqZXXOajYg3FoP_uyxYA@mail.gmail.com>
Subject: Re: [PATCH v4 17/18] btrfs: dedup: add a property handler for online dedup
From: Filipe Manana <fdmanana@gmail.com>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
        Wang Xiaoguang <wangxg.fnst@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Jan 14, 2016 at 5:57 AM, Qu Wenruo <quwenruo@cn.fujitsu.com> wrote:
> From: Wang Xiaoguang <wangxg.fnst@cn.fujitsu.com>
>
> We use btrfs extended attribute "btrfs.dedup" to record per-file online
> dedup status, so add a dedup property handler.
>
> Signed-off-by: Wang Xiaoguang <wangxg.fnst@cn.fujitsu.com>
> ---
>  fs/btrfs/props.c | 40 ++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 40 insertions(+)
>
> diff --git a/fs/btrfs/props.c b/fs/btrfs/props.c
> index f9e6023..ae8b76d 100644
> --- a/fs/btrfs/props.c
> +++ b/fs/btrfs/props.c
> @@ -41,6 +41,10 @@ static int prop_compression_apply(struct inode *inode,
>                                   size_t len);
>  static const char *prop_compression_extract(struct inode *inode);
>
> +static int prop_dedup_validate(const char *value, size_t len);
> +static int prop_dedup_apply(struct inode *inode, const char *value, size_t len);
> +static const char *prop_dedup_extract(struct inode *inode);
> +
>  static struct prop_handler prop_handlers[] = {
>         {
>                 .xattr_name = XATTR_BTRFS_PREFIX "compression",
> @@ -49,6 +53,13 @@ static struct prop_handler prop_handlers[] = {
>                 .extract = prop_compression_extract,
>                 .inheritable = 1
>         },
> +       {
> +               .xattr_name = XATTR_BTRFS_PREFIX "dedup",
> +               .validate = prop_dedup_validate,
> +               .apply = prop_dedup_apply,
> +               .extract = prop_dedup_extract,
> +               .inheritable = 1
> +       },
>  };
>
>  void __init btrfs_props_init(void)
> @@ -425,4 +436,33 @@ static const char *prop_compression_extract(struct inode *inode)
>         return NULL;
>  }
>
> +static int prop_dedup_validate(const char *value, size_t len)
> +{
> +       if (!strncmp("disable", value, len))
> +               return 0;
> +
> +       return -EINVAL;
> +}
> +
> +static int prop_dedup_apply(struct inode *inode, const char *value, size_t len)
> +{
> +       if (len == 0) {
> +               BTRFS_I(inode)->flags &= ~BTRFS_INODE_NODEDUP;
> +               return 0;
> +       }
> +
> +       if (!strncmp("disable", value, len)) {
> +               BTRFS_I(inode)->flags |= BTRFS_INODE_NODEDUP;
> +               return 0;
> +       }
> +
> +       return -EINVAL;
> +}
> +
> +static const char *prop_dedup_extract(struct inode *inode)
> +{
> +       if (BTRFS_I(inode)->flags | BTRFS_INODE_NODEDUP)
> +               return "disable";

| -> &

How about writing test cases (for xfstests)? Not only for the property
but for the whole dedup feature, it would avoid such simple
mistakes...
Take a look at the good example of xfs development. For example when
all the recent patches for their reflink implementation was posted
(and before getting merged), a comprehensive set of test cases for
xfstests was also posted...

>
> +       return NULL;
> +}
> --
> 2.7.0
>
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



-- 
Filipe David Manana,

"Reasonable men adapt themselves to the world.
 Unreasonable men adapt the world to themselves.
 That's why all progress depends on unreasonable men."
