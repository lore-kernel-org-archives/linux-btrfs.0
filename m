Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ua0-f193.google.com ([209.85.217.193]:36044 "EHLO
        mail-ua0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728175AbeHILlG (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Thu, 9 Aug 2018 07:41:06 -0400
Received: by mail-ua0-f193.google.com with SMTP id c12-v6so5533778uan.3
        for <linux-btrfs@vger.kernel.org>; Thu, 09 Aug 2018 02:17:09 -0700 (PDT)
MIME-Version: 1.0
Reply-To: fdmanana@gmail.com
In-Reply-To: <20180809070857.7456-1-wqu@suse.com>
References: <20180809070857.7456-1-wqu@suse.com>
From: Filipe Manana <fdmanana@gmail.com>
Date: Thu, 9 Aug 2018 10:17:08 +0100
Message-ID: <CAL3q7H4P3h-hT_rtXQnLMePu2GrmRMa=M7nqbJ9FUxhCfvF89A@mail.gmail.com>
Subject: Re: [PATCH v2] btrfs: qgroup: Dirty all qgroups before rescan
To: Qu Wenruo <wqu@suse.com>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Aug 9, 2018 at 8:08 AM, Qu Wenruo <wqu@suse.com> wrote:
> [BUG]
> In the following case, rescan won't zero out the number of qgroup 1/0:
> ------
> $ mkfs.btrfs -fq $DEV
> $ mount $DEV /mnt
>
> $ btrfs quota enable /mnt
> $ btrfs qgroup create 1/0 /mnt
> $ btrfs sub create /mnt/sub
> $ btrfs qgroup assign 0/257 1/0 /mnt
>
> $ dd if=/dev/urandom of=/mnt/sub/file bs=1k count=1000
> $ btrfs sub snap /mnt/sub /mnt/snap
> $ btrfs quota rescan -w /mnt
> $ btrfs qgroup show -pcre /mnt
> qgroupid         rfer         excl     max_rfer     max_excl parent  child
> --------         ----         ----     --------     -------- ------  -----
> 0/5          16.00KiB     16.00KiB         none         none ---     ---
> 0/257      1016.00KiB     16.00KiB         none         none 1/0     ---
> 0/258      1016.00KiB     16.00KiB         none         none ---     ---
> 1/0        1016.00KiB     16.00KiB         none         none ---     0/257
>
> so far so good, but:
>
> $ btrfs qgroup remove 0/257 1/0 /mnt
> WARNING: quotas may be inconsistent, rescan needed
> $ btrfs quota rescan -w /mnt
> $ btrfs qgroup show -pcre  /mnt
> qgoupid         rfer         excl     max_rfer     max_excl parent  child
> --------         ----         ----     --------     -------- ------  -----
> 0/5          16.00KiB     16.00KiB         none         none ---     ---
> 0/257      1016.00KiB     16.00KiB         none         none ---     ---
> 0/258      1016.00KiB     16.00KiB         none         none ---     ---
> 1/0        1016.00KiB     16.00KiB         none         none ---     ---
>            ^^^^^^^^^^     ^^^^^^^^ not cleared
> ------
>
> [CAUSE]
> Before rescan we call qgroup_rescan_zero_tracking() to zero out all
> qgroups' accounting numbers.
>
> However we don't mark all qgroups dirty, but rely on rescan to mark
> qgroups dirty.
>
> If we have any high level qgroup but without any child (orphan group),

That sentence is confusing. An orphan, by definition [1], is someone
(or something in this case) without parents.
But you mention a group without children, so that should be named
"childless" or simply say "without children".
So one part of the sentence is wrong, either what is in parenthesis or
what comes before them.

[1] https://www.thefreedictionary.com/orphan

> it
> won't be marked dirty during rescan, since we can not reach that qgroup.
>
> This will cause QGROUP_INFO items of orphan qgroups never get updated in
> quota tree, thus their numbers will stay the same in "btrfs qgroup show"
> output.
>
> [FIX]
> Just mark all qgroups dirty in qgroup_rescan_zero_tracking(), so even we
> have orphan qgroups their QGROUP_INFO items will still get updated during
> rescan.
>
> Reported-by: Misono Tomohiro <misono.tomohiro@jp.fujitsu.com>
> Signed-off-by: Qu Wenruo <wqu@suse.com>
> ---
> changelog:
> v2:
>   Fix some grammar errors in commit message.
> ---
>  fs/btrfs/qgroup.c | 1 +
>  1 file changed, 1 insertion(+)
>
> diff --git a/fs/btrfs/qgroup.c b/fs/btrfs/qgroup.c
> index 48c1c3e7baf3..5a5372b33d96 100644
> --- a/fs/btrfs/qgroup.c
> +++ b/fs/btrfs/qgroup.c
> @@ -2864,6 +2864,7 @@ qgroup_rescan_zero_tracking(struct btrfs_fs_info *fs_info)
>                 qgroup->rfer_cmpr = 0;
>                 qgroup->excl = 0;
>                 qgroup->excl_cmpr = 0;
> +               qgroup_dirty(fs_info, qgroup);
>         }
>         spin_unlock(&fs_info->qgroup_lock);
>  }
> --
> 2.18.0
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



-- 
Filipe David Manana,

“Whether you think you can, or you think you can't — you're right.”
