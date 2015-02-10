Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lb0-f170.google.com ([209.85.217.170]:42889 "EHLO
	mail-lb0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750801AbbBJLYe (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 10 Feb 2015 06:24:34 -0500
Received: by mail-lb0-f170.google.com with SMTP id u14so11297483lbd.1
        for <linux-btrfs@vger.kernel.org>; Tue, 10 Feb 2015 03:24:33 -0800 (PST)
MIME-Version: 1.0
Reply-To: fdmanana@gmail.com
In-Reply-To: <1423563845-9103-4-git-send-email-yangds.fnst@cn.fujitsu.com>
References: <1423563845-9103-1-git-send-email-yangds.fnst@cn.fujitsu.com>
	<1423563845-9103-4-git-send-email-yangds.fnst@cn.fujitsu.com>
Date: Tue, 10 Feb 2015 11:24:33 +0000
Message-ID: <CAL3q7H7yBTBeTkOY8rGKRRbjmKPzRdVsARNs6DjkAThcqBGatg@mail.gmail.com>
Subject: Re: [PATCH 3/3] btrfs: qgroup: fix a wrong parameter of no_quota.
From: Filipe David Manana <fdmanana@gmail.com>
To: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Feb 10, 2015 at 10:24 AM, Dongsheng Yang
<yangds.fnst@cn.fujitsu.com> wrote:
> In function of __btrfs_mod_ref(), we are passing the no_quota=1
> to process_func() anyway. It will make the numbers in qgroup be
> wrong when deleting a subvolume. The data size in a deleted subvolume
> will never be decressed from all related qgroups.

How about getting a test case for xfstests for this?

thanks

>
> Signed-off-by: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
> ---
>  fs/btrfs/extent-tree.c | 8 ++++++--
>  1 file changed, 6 insertions(+), 2 deletions(-)
>
> diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
> index 652be74..f59809c 100644
> --- a/fs/btrfs/extent-tree.c
> +++ b/fs/btrfs/extent-tree.c
> @@ -3056,6 +3056,7 @@ static int __btrfs_mod_ref(struct btrfs_trans_handle *trans,
>         int i;
>         int level;
>         int ret = 0;
> +       int no_quota = 0;
>         int (*process_func)(struct btrfs_trans_handle *, struct btrfs_root *,
>                             u64, u64, u64, u64, u64, u64, int);
>
> @@ -3080,6 +3081,9 @@ static int __btrfs_mod_ref(struct btrfs_trans_handle *trans,
>         else
>                 parent = 0;
>
> +       if (!root->fs_info->quota_enabled || !is_fstree(ref_root))
> +               no_quota = 1;
> +
>         for (i = 0; i < nritems; i++) {
>                 if (level == 0) {
>                         btrfs_item_key_to_cpu(buf, &key, i);
> @@ -3098,7 +3102,7 @@ static int __btrfs_mod_ref(struct btrfs_trans_handle *trans,
>                         key.offset -= btrfs_file_extent_offset(buf, fi);
>                         ret = process_func(trans, root, bytenr, num_bytes,
>                                            parent, ref_root, key.objectid,
> -                                          key.offset, 1);
> +                                          key.offset, no_quota);
>                         if (ret)
>                                 goto fail;
>                 } else {
> @@ -3106,7 +3110,7 @@ static int __btrfs_mod_ref(struct btrfs_trans_handle *trans,
>                         num_bytes = root->nodesize;
>                         ret = process_func(trans, root, bytenr, num_bytes,
>                                            parent, ref_root, level - 1, 0,
> -                                          1);
> +                                          no_quota);
>                         if (ret)
>                                 goto fail;
>                 }
> --
> 1.8.4.2
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
