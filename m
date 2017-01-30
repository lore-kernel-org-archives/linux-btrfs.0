Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-it0-f65.google.com ([209.85.214.65]:34236 "EHLO
        mail-it0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752518AbdA3UFu (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 30 Jan 2017 15:05:50 -0500
Received: by mail-it0-f65.google.com with SMTP id o185so16676392itb.1
        for <linux-btrfs@vger.kernel.org>; Mon, 30 Jan 2017 12:04:26 -0800 (PST)
MIME-Version: 1.0
Reply-To: fdmanana@gmail.com
In-Reply-To: <1476176474-15900-1-git-send-email-robbieko@synology.com>
References: <1476176474-15900-1-git-send-email-robbieko@synology.com>
From: Filipe Manana <fdmanana@gmail.com>
Date: Mon, 30 Jan 2017 20:04:25 +0000
Message-ID: <CAL3q7H4kRh32wDOqX9DuzEb6RkuJeCpVrMUoCO3UADr1Rs8+jQ@mail.gmail.com>
Subject: Re: [PATCH] Btrfs: fix -EINVEL in tree log recovering
To: robbieko <robbieko@synology.com>
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Oct 11, 2016 at 10:01 AM, robbieko <robbieko@synology.com> wrote:
> From: Robbie Ko <robbieko@synology.com>
>
> when tree log recovery, space_cache rebuild or dirty maybe save the cache.
> and then replay extent with disk_bytenr and disk_num_bytes,
> but disk_bytenr and disk_num_bytes maybe had been use for free space inode,
> will lead to -EINVEL.

-EINVEL -> -EINVAL

More importantly, and sorry to say, but I can't parse nor make sense
of your change log.
It kind of seems you're saying that replaying an extent from the log
tree can collide somehow with the space reserved for a free space
cache, or the other way around, writing a space cache attempts to use
an extent that overlaps an extent that was replayed during log
recovery (presumably during the transaction commit done at the end of
the log recovery).

Now honestly, think of how you would explain the problem in your
native tongue. Do you think a single short sentence like that is
enough to explain such a non-trivial problem? I doubt it, no matter
what language we pick... Or think that in a few months or maybe years
(or whatever time frame) even you forgot what was the problem and
you're trying to remember the details by reading the change log - do
you think this change log would help at all?

At least tell us what (function) is returning -EINVAL, make a function
call graph, give a sample scenario, or better yet, send a test case
(fstests) to reproduce this, since it seems to be a fully
deterministic and 100% reproducible case.

Thanks.

>
> BTRFS: error in btrfs_replay_log:2446: errno=-22 unknown (Failed to recover log tree)
>
> therefore, we not save cache when tree log recovering.
>
> Signed-off-by: Robbie Ko <robbieko@synology.com>
> ---
>  fs/btrfs/extent-tree.c | 1 +
>  1 file changed, 1 insertion(+)
>
> diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
> index 665da8f..38b932c 100644
> --- a/fs/btrfs/extent-tree.c
> +++ b/fs/btrfs/extent-tree.c
> @@ -3434,6 +3434,7 @@ again:
>
>         spin_lock(&block_group->lock);
>         if (block_group->cached != BTRFS_CACHE_FINISHED ||
> +               block_group->fs_info->log_root_recovering ||
>             !btrfs_test_opt(root->fs_info, SPACE_CACHE)) {
>                 /*
>                  * don't bother trying to write stuff out _if_
> --
> 1.9.1
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



-- 
Filipe David Manana,

"People will forget what you said,
 people will forget what you did,
 but people will never forget how you made them feel."
