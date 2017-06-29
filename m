Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-vk0-f68.google.com ([209.85.213.68]:36762 "EHLO
        mail-vk0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751636AbdF2Eie (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 29 Jun 2017 00:38:34 -0400
Received: by mail-vk0-f68.google.com with SMTP id y70so4927499vky.3
        for <linux-btrfs@vger.kernel.org>; Wed, 28 Jun 2017 21:38:33 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20170628212949.25403-1-bo.li.liu@oracle.com>
References: <20170628212949.25403-1-bo.li.liu@oracle.com>
From: "Lakshmipathi.G" <lakshmipathi.g@gmail.com>
Date: Thu, 29 Jun 2017 10:07:52 +0530
Message-ID: <CAKuJGC_VBpnqtEX-9DK371gi4-zCgpibK4E04mUBBnrg7NKxXA@mail.gmail.com>
Subject: Re: [PATCH] Btrfs-progs: convert: do not clear nodatasum flag in
 inode item
To: Liu Bo <bo.li.liu@oracle.com>
Cc: btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Could you please add also a test-script for this interesting issue
under tests/convert-tests
(If its not already there)?. thanks.

----
Cheers,
Lakshmipathi.G
http://www.giis.co.in http://www.webminal.org


On Thu, Jun 29, 2017 at 2:59 AM, Liu Bo <bo.li.liu@oracle.com> wrote:
> With the current btrfs-convert, if we convert a ext4 without data checksum,
> it'd not set nodatasum flag in inode item, nor create csum item, reading
> file ends up with checksum errors.
>
> Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
> ---
>  convert/source-ext2.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/convert/source-ext2.c b/convert/source-ext2.c
> index 1b0576b..64b95c5 100644
> --- a/convert/source-ext2.c
> +++ b/convert/source-ext2.c
> @@ -742,7 +742,7 @@ static int ext2_check_state(struct btrfs_convert_context *cctx)
>  static void ext2_convert_inode_flags(struct btrfs_inode_item *dst,
>                                      struct ext2_inode *src)
>  {
> -       u64 flags = 0;
> +       u64 flags = btrfs_stack_inode_flags(dst);
>
>         COPY_ONE_EXT2_FLAG(flags, src, APPEND);
>         COPY_ONE_EXT2_FLAG(flags, src, SYNC);
> --
> 2.5.0
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
