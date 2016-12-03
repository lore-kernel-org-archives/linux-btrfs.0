Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pf0-f172.google.com ([209.85.192.172]:35531 "EHLO
        mail-pf0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751072AbcLCSw2 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Sat, 3 Dec 2016 13:52:28 -0500
Received: by mail-pf0-f172.google.com with SMTP id i88so57186236pfk.2
        for <linux-btrfs@vger.kernel.org>; Sat, 03 Dec 2016 10:52:27 -0800 (PST)
Date: Sat, 3 Dec 2016 10:45:21 -0800
From: Omar Sandoval <osandov@osandov.com>
To: Pan Bian <bianpan2016@163.com>
Cc: Chris Mason <clm@fb.com>, Josef Bacik <jbacik@fb.com>,
        David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] btrfs: fix improper return value
Message-ID: <20161203184521.GA8207@mew>
References: <1480762516-5002-1-git-send-email-bianpan2016@163.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1480762516-5002-1-git-send-email-bianpan2016@163.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, Dec 03, 2016 at 06:55:16PM +0800, Pan Bian wrote:
> In function btrfs_uuid_tree_iterate(), errno is assigned to variable
> ret on errors. However, it directly returns 0. It may be better to
> return ret.
> 
> Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=188731
> 
> Signed-off-by: Pan Bian <bianpan2016@163.com>
> ---
>  fs/btrfs/uuid-tree.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/btrfs/uuid-tree.c b/fs/btrfs/uuid-tree.c
> index 7fc89e4..44bcc1f 100644
> --- a/fs/btrfs/uuid-tree.c
> +++ b/fs/btrfs/uuid-tree.c
> @@ -353,5 +353,5 @@ int btrfs_uuid_tree_iterate(struct btrfs_fs_info *fs_info,
>  	btrfs_free_path(path);
>  	if (ret)
>  		btrfs_warn(fs_info, "btrfs_uuid_tree_iterate failed %d", ret);
> -	return 0;
> +	return ret;

This one makes sense, since the caller is checking the return value. The
caller is already printing a warning, can you also get rid of the
btrfs_warn(fs_info, "btrfs_uuid_tree_iterate failed %d", ret)?
