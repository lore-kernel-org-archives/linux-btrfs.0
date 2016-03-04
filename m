Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ig0-f171.google.com ([209.85.213.171]:38851 "EHLO
	mail-ig0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759311AbcCDJ2f (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Fri, 4 Mar 2016 04:28:35 -0500
Received: by mail-ig0-f171.google.com with SMTP id y8so13103139igp.1
        for <linux-btrfs@vger.kernel.org>; Fri, 04 Mar 2016 01:28:35 -0800 (PST)
MIME-Version: 1.0
Reply-To: fdmanana@gmail.com
In-Reply-To: <56D8F4CF.20604@jp.fujitsu.com>
References: <56D8F4CF.20604@jp.fujitsu.com>
Date: Fri, 4 Mar 2016 09:28:34 +0000
Message-ID: <CAL3q7H6UvnB1K3ys3YLK0YCBwuSRMhv+Y8artx7HJ7VawHqZGg@mail.gmail.com>
Subject: Re: [PATCH] Show a warning message if one of highest objectid reaches
 its max value
From: Filipe Manana <fdmanana@gmail.com>
To: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Mar 4, 2016 at 2:37 AM, Satoru Takeuchi
<takeuchi_satoru@jp.fujitsu.com> wrote:
> - It's better to show a warning message for the exceptional case
>   that one of highest objectid (in most case, inode number)
>   reaches its max value, BTRFS_LAST_FREE_OBJECTID. Show this
>   message only once to avoid filling dmesg with it.
> - EOVERFLOW is more proper return value for this case.
>   ENOSPC is for "No space left on device" case and objectid isn't
>   related to any device.
>
> Signed-off-by: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>
> ---
> This patch can be applied to v4.5-rc6
> ---
>  fs/btrfs/inode-map.c | 6 ++++--
>  1 file changed, 4 insertions(+), 2 deletions(-)
>
> diff --git a/fs/btrfs/inode-map.c b/fs/btrfs/inode-map.c
> index e50316c..a4860fd 100644
> --- a/fs/btrfs/inode-map.c
> +++ b/fs/btrfs/inode-map.c
> @@ -555,8 +555,10 @@ int btrfs_find_free_objectid(struct btrfs_root *root, u64 *objectid)
>         int ret;
>         mutex_lock(&root->objectid_mutex);
>
> -       if (unlikely(root->highest_objectid >= BTRFS_LAST_FREE_OBJECTID)) {
> -               ret = -ENOSPC;
> +       if (WARN_ONCE(root->highest_objectid >= BTRFS_LAST_FREE_OBJECTID,
> +                     "BTRFS: The highest objectid reaches its max value %llu.\n",
> +                     BTRFS_LAST_FREE_OBJECTID)) {

Please, use btrfs_warn() to print messages... It avoids hardcoding
prefixes and having to copy the style of the
btrfs_[info|warn|error|...) functions.
Also include the id of the tree (root->root_key.objectid), it's much
more useful than printing root->highes_objectid....

Also add the prefix "Btrfs: " to the subject.

> +               ret = -EOVERFLOW;
>                 goto out;
>         }
>
> --
> 2.5.0
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



-- 
Filipe David Manana,

"Reasonable men adapt themselves to the world.
 Unreasonable men adapt the world to themselves.
 That's why all progress depends on unreasonable men."
