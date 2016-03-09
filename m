Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qg0-f66.google.com ([209.85.192.66]:33932 "EHLO
	mail-qg0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750766AbcCICdJ (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 8 Mar 2016 21:33:09 -0500
Received: by mail-qg0-f66.google.com with SMTP id t4so2267063qge.1
        for <linux-btrfs@vger.kernel.org>; Tue, 08 Mar 2016 18:33:08 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <56DCF015.9060703@jp.fujitsu.com>
References: <56DCF015.9060703@jp.fujitsu.com>
From: Naohiro Aota <naota@elisp.net>
Date: Wed, 9 Mar 2016 11:32:48 +0900
Message-ID: <CAEe67=_Me0s=VFTY5VuR2tRVPVFy+SnoXy+=mxvwQbFy31LJAw@mail.gmail.com>
Subject: Re: [PATCH v2] Btrfs: Show a warning message if one of objectid
 reaches its highest value
To: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

2016-03-07 12:05 GMT+09:00 Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>:
> - It's better to show a warning message for the exceptional case
>   that one of objectid (in most case, inode number) reaches its
>   highest value. Show this message only once to avoid filling
>   dmesg with it.
> - EOVERFLOW is more proper return value for this case.
>   ENOSPC is for "No space left on device" case and objectid isn't
>   related to any device.

I have concern about EOVERFLOW. The value returned here will
go through to the user space via btrfs_find_free_ino() and btrfs_create().
It means that "creat" and "mkdir" can now return EOVERFLOW when it
failed to assign new inode number. Such behavior would disagree with
other file systems, which result in user space programs to be
confused.

Also, I don't think EOVERFLOW described in "creat(2)" (or open(2))
suits for this case. As far as I read the following man page from
creat(2),
giving ENOSPC is better option here.

> ENOSPC: pathname was to be created but the device containing pathname has  no  room  for  the  new file.
> EOVERFLOW:
>              pathname refers to a regular file that is too large to be opened.
> (snip)

> Signed-off-by: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>
> ---
> This patch can be applied to 4.5-rc7
> ---
>  fs/btrfs/inode-map.c | 10 +++++++++-
>  1 file changed, 9 insertions(+), 1 deletion(-)
>
> diff --git a/fs/btrfs/inode-map.c b/fs/btrfs/inode-map.c
> index e50316c..f5e3228 100644
> --- a/fs/btrfs/inode-map.c
> +++ b/fs/btrfs/inode-map.c
> @@ -556,7 +556,15 @@ int btrfs_find_free_objectid(struct btrfs_root *root, u64 *objectid)
>         mutex_lock(&root->objectid_mutex);
>
>         if (unlikely(root->highest_objectid >= BTRFS_LAST_FREE_OBJECTID)) {
> -               ret = -ENOSPC;
> +               static bool __warned = false;
> +
> +               if (unlikely(!__warned)) {
> +                       btrfs_warn(root->fs_info,
> +                                  "The objectid of root %llu reaches its highest value.\n",
> +                                  root->root_key.objectid);
> +                       __warned = true;
> +               }
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
