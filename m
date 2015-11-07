Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ig0-f173.google.com ([209.85.213.173]:36051 "EHLO
	mail-ig0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750856AbbKGPB1 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sat, 7 Nov 2015 10:01:27 -0500
Received: by igcph11 with SMTP id ph11so1800261igc.1
        for <linux-btrfs@vger.kernel.org>; Sat, 07 Nov 2015 07:01:26 -0800 (PST)
MIME-Version: 1.0
Reply-To: fdmanana@gmail.com
In-Reply-To: <1446835002-11751-1-git-send-email-jmaggard@netgear.com>
References: <1446835002-11751-1-git-send-email-jmaggard@netgear.com>
Date: Sat, 7 Nov 2015 15:01:26 +0000
Message-ID: <CAL3q7H719jBS279iUyRuZSoVfb8j+LKJUNSmT6snoRN7YRcaSw@mail.gmail.com>
Subject: Re: [PATCH] btrfs: qgroup: fix quota disable during rescan
From: Filipe Manana <fdmanana@gmail.com>
To: Justin Maggard <jmaggard10@gmail.com>
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
        Justin Maggard <jmaggard@netgear.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Nov 6, 2015 at 6:36 PM, Justin Maggard <jmaggard10@gmail.com> wrote:
> There's a race condition that leads to a NULL pointer dereference if you
> disable quotas while a quota rescan is running.  To fix this, we just need
> to wait for the quota rescan worker to actually exit before tearing down
> the quota structures.
>
> Signed-off-by: Justin Maggard <jmaggard@netgear.com>

Justin, it looks good and it's a very good find.

But can you please give a more detailed change log? You mention a NULL
pointer dereference, but you don't say where, which variable nor why.
Pasting a trace of the crash you get in syslog/dmesg would also be
nice.

My guess is the null pointer dereference is in fs_info->quota_root,
but running the corresponding xfstest once I hit the
BUG_ON(!fs_info->quota_root) at btrfs_qgroup_account_extent(), called
by the rescan worker through qgroup_rescan_leaf().

Once you add that, you can add as well:  Reviewed-by: Filipe Manana
<fdmanana@suse.com>

Thanks for this and the test.


> ---
>  fs/btrfs/qgroup.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
>
> diff --git a/fs/btrfs/qgroup.c b/fs/btrfs/qgroup.c
> index 75c0249..a7cf504 100644
> --- a/fs/btrfs/qgroup.c
> +++ b/fs/btrfs/qgroup.c
> @@ -993,9 +993,10 @@ int btrfs_quota_disable(struct btrfs_trans_handle *trans,
>         mutex_lock(&fs_info->qgroup_ioctl_lock);
>         if (!fs_info->quota_root)
>                 goto out;
> -       spin_lock(&fs_info->qgroup_lock);
>         fs_info->quota_enabled = 0;
>         fs_info->pending_quota_state = 0;
> +       btrfs_qgroup_wait_for_completion(fs_info);
> +       spin_lock(&fs_info->qgroup_lock);
>         quota_root = fs_info->quota_root;
>         fs_info->quota_root = NULL;
>         fs_info->qgroup_flags &= ~BTRFS_QGROUP_STATUS_FLAG_ON;
> --
> 2.6.3
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
