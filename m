Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-oi0-f66.google.com ([209.85.218.66]:34392 "EHLO
        mail-oi0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S938455AbcJXPGZ (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 24 Oct 2016 11:06:25 -0400
Received: by mail-oi0-f66.google.com with SMTP id p136so2375130oic.1
        for <linux-btrfs@vger.kernel.org>; Mon, 24 Oct 2016 08:06:25 -0700 (PDT)
MIME-Version: 1.0
Reply-To: fdmanana@gmail.com
In-Reply-To: <20161024145754.7165-1-rgoldwyn@suse.de>
References: <20161024145754.7165-1-rgoldwyn@suse.de>
From: Filipe Manana <fdmanana@gmail.com>
Date: Mon, 24 Oct 2016 16:06:24 +0100
Message-ID: <CAL3q7H65=CeS9P3BabDwSi69nJRVUfwf=+apY=x1mBWj1j=Nkg@mail.gmail.com>
Subject: Re: [PATCH] btrfs-progs: Initialize btrfs_path before use
To: Goldwyn Rodrigues <rgoldwyn@suse.de>
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
        Goldwyn Rodrigues <rgoldwyn@suse.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Oct 24, 2016 at 3:57 PM, Goldwyn Rodrigues <rgoldwyn@suse.de> wrote:
> From: Goldwyn Rodrigues <rgoldwyn@suse.com>
>
> While performing an fsck, an assertion failure occurs because of reusing path in a loop.
> ctree.c:1112: btrfs_search_slot: Warning: assertion `p->nodes[0] != NULL` failed, value 0
>
> Signed-off-by: Goldwyn Rodrigues <rgoldwyn@suse.com>
>
> diff --git a/cmds-check.c b/cmds-check.c
> index 670ccd1..a6f281c 100644
> --- a/cmds-check.c
> +++ b/cmds-check.c
> @@ -7541,6 +7541,7 @@ static int record_orphan_data_extents(struct btrfs_fs_info *fs_info,
>                 key.objectid = dback->owner;
>                 key.type = BTRFS_EXTENT_DATA_KEY;
>                 key.offset = dback->offset;
> +               btrfs_init_path(path);

Hi Goldwyn,

You want to call btrfs_release_path(), otherwise you leak memory. And
it would be better placed before the 'continue' statement.

thanks

>
>                 ret = btrfs_search_slot(NULL, dest_root, &key, path, 0, 0);
>                 /*
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



-- 
Filipe David Manana,

"People will forget what you said,
 people will forget what you did,
 but people will never forget how you made them feel."
