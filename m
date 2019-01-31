Return-Path: <SRS0=M3t6=QH=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 57A32C4151A
	for <linux-btrfs@archiver.kernel.org>; Thu, 31 Jan 2019 16:32:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 29DBE218F0
	for <linux-btrfs@archiver.kernel.org>; Thu, 31 Jan 2019 16:32:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1548952324;
	bh=uFPmqV/5OLf7fIoLbqvIIf3JTPUt88UeZ8wR6JLGYnM=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:List-ID:From;
	b=N8688eTasw5OdsjJaqn8yFtfV0v6asErDkVnGsOKhckTks7lSjlbNVUmQCeQjamd0
	 oXy1IXYlN60/9n3YOYv8//VZ2bY5KxMQjP1P8JhEUUpDPvOBTMiUT7qrXgdSOkNl79
	 59rqRCSLVYbe3X5minRHqvYKhKNascYdvE6VUUNk=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388489AbfAaQcD (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 31 Jan 2019 11:32:03 -0500
Received: from mail.kernel.org ([198.145.29.99]:44672 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727189AbfAaQcC (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 31 Jan 2019 11:32:02 -0500
Received: from mail-ua1-f45.google.com (mail-ua1-f45.google.com [209.85.222.45])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E9C53218F0
        for <linux-btrfs@vger.kernel.org>; Thu, 31 Jan 2019 16:32:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1548952322;
        bh=uFPmqV/5OLf7fIoLbqvIIf3JTPUt88UeZ8wR6JLGYnM=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=B/THbjvHaa1mpCLtiRBJIJx25s78R0wzBkoZMaic3UdCEXp0ib1lN1TFEs+bWMyTz
         agDJiAzZVqpcFh1ydb8i7OkZ6w5A9/UKaalQcQIZqBxeyUfY+VTYFcg/VYOrHhB7WI
         BZyToAc9+OKu85MyOA4Tc4+EuYkOaspvIh3wEkdg=
Received: by mail-ua1-f45.google.com with SMTP id d21so1236484uap.9
        for <linux-btrfs@vger.kernel.org>; Thu, 31 Jan 2019 08:32:01 -0800 (PST)
X-Gm-Message-State: AJcUukd+ZKvMqnwuQUQ0d+mz+gX3nbgo5N9GNXFB3lzbNHxXH8edWm13
        WmDloxkRk7sWMolAwbF00vR4Su4a3sBobR/ZXBo=
X-Google-Smtp-Source: ALg8bN4H1UQfixPC/zQdFAaWUGhKmOE4Asqj5d9QvZU5opj8sMz+3n1NyQKbBjve7rrP4wo43C9ELR+PhFHNrtognQU=
X-Received: by 2002:ab0:225a:: with SMTP id z26mr15297030uan.100.1548952321102;
 Thu, 31 Jan 2019 08:32:01 -0800 (PST)
MIME-Version: 1.0
References: <20181212180559.15249-1-fdmanana@kernel.org> <20181212180559.15249-5-fdmanana@kernel.org>
In-Reply-To: <20181212180559.15249-5-fdmanana@kernel.org>
From:   Filipe Manana <fdmanana@kernel.org>
Date:   Thu, 31 Jan 2019 16:31:49 +0000
X-Gmail-Original-Message-ID: <CAL3q7H55XWqvr2DA_BbqZtva_01iqVD19fkRZFLe14cVTyEY8Q@mail.gmail.com>
Message-ID: <CAL3q7H55XWqvr2DA_BbqZtva_01iqVD19fkRZFLe14cVTyEY8Q@mail.gmail.com>
Subject: Re: [PATCH 4/4] Btrfs: remove no longer needed range length checks
 for deduplication
To:     linux-btrfs <linux-btrfs@vger.kernel.org>
Cc:     David Sterba <dsterba@suse.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Wed, Dec 12, 2018 at 6:07 PM <fdmanana@kernel.org> wrote:
>
> From: Filipe Manana <fdmanana@suse.com>
>
> Comparing the content of the pages in the range to deduplicate is now done
> by the generic helper generic_remap_file_range_prep(), which takes care of
> ensuring we do not compare/deduplicate undefined data beyond a file's eof
> (range from eof to the next block boundary). So remove these checks which
> are now redundant.
>
> Signed-off-by: Filipe Manana <fdmanana@suse.com>

Any reason why this was not yet picked?
Thanks.

> ---
>  fs/btrfs/ioctl.c | 19 ++-----------------
>  1 file changed, 2 insertions(+), 17 deletions(-)
>
> diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
> index 4e9efc93340e..3a27efa2b955 100644
> --- a/fs/btrfs/ioctl.c
> +++ b/fs/btrfs/ioctl.c
> @@ -3206,31 +3206,16 @@ static void btrfs_double_inode_lock(struct inode *inode1, struct inode *inode2)
>         inode_lock_nested(inode2, I_MUTEX_CHILD);
>  }
>
> -static int btrfs_extent_same_range(struct inode *src, u64 loff, u64 olen,
> +static int btrfs_extent_same_range(struct inode *src, u64 loff, u64 len,
>                                    struct inode *dst, u64 dst_loff)
>  {
> -       u64 bs = BTRFS_I(src)->root->fs_info->sb->s_blocksize;
>         int ret;
> -       u64 len = olen;
> -
> -       if (loff + len == src->i_size)
> -               len = ALIGN(src->i_size, bs) - loff;
> -       /*
> -        * For same inode case we don't want our length pushed out past i_size
> -        * as comparing that data range makes no sense.
> -        *
> -        * This effectively means we require aligned extents for the single
> -        * inode case, whereas the other cases allow an unaligned length so long
> -        * as it ends at i_size.
> -        */
> -       if (dst == src && len != olen)
> -               return -EINVAL;
>
>         /*
>          * Lock destination range to serialize with concurrent readpages().
>          */
>         lock_extent(&BTRFS_I(dst)->io_tree, dst_loff, dst_loff + len - 1);
> -       ret = btrfs_clone(src, dst, loff, olen, len, dst_loff, 1);
> +       ret = btrfs_clone(src, dst, loff, len, len, dst_loff, 1);
>         unlock_extent(&BTRFS_I(dst)->io_tree, dst_loff, dst_loff + len - 1);
>
>         return ret;
> --
> 2.11.0
>
