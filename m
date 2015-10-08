Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f175.google.com ([209.85.223.175]:34688 "EHLO
	mail-io0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755167AbbJHJZO (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 8 Oct 2015 05:25:14 -0400
Received: by iow1 with SMTP id 1so51598675iow.1
        for <linux-btrfs@vger.kernel.org>; Thu, 08 Oct 2015 02:25:14 -0700 (PDT)
MIME-Version: 1.0
Reply-To: fdmanana@gmail.com
In-Reply-To: <1441242317-16547-1-git-send-email-jmaggard@netgear.com>
References: <1441242317-16547-1-git-send-email-jmaggard@netgear.com>
Date: Thu, 8 Oct 2015 10:25:13 +0100
Message-ID: <CAL3q7H6QCVt0=bR_mOFiFzz5uengnbYGbvYch3MW3AZUto8PqQ@mail.gmail.com>
Subject: Re: [PATCH v2] btrfs: qgroup: exit the rescan worker during umount
From: Filipe Manana <fdmanana@gmail.com>
To: Justin Maggard <jmaggard10@gmail.com>
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
        Justin Maggard <jmaggard@netgear.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Sep 3, 2015 at 2:05 AM, Justin Maggard <jmaggard10@gmail.com> wrote:
> v2: Fix stupid error while making formatting changes...
>
> I was hitting a consistent NULL pointer dereference during shutdown that
> showed the trace running through end_workqueue_bio().  I traced it back to
> the endio_meta_workers workqueue being poked after it had already been
> destroyed.
>
> Eventually I found that the root cause was a qgroup rescan that was still
> in progress while we were stopping all the btrfs workers.
>
> Currently we explicitly pause balance and scrub operations in
> close_ctree(), but we do nothing to stop the qgroup rescan.  We should
> probably be doing the same for qgroup rescan, but that's a much larger
> change.  This small change is good enough to allow me to unmount without
> crashing.
>
> Signed-off-by: Justin Maggard <jmaggard@netgear.com>
> ---
>  fs/btrfs/qgroup.c | 9 ++++++---
>  1 file changed, 6 insertions(+), 3 deletions(-)
>
> diff --git a/fs/btrfs/qgroup.c b/fs/btrfs/qgroup.c
> index d904ee1..5bfcee9 100644
> --- a/fs/btrfs/qgroup.c
> +++ b/fs/btrfs/qgroup.c
> @@ -2278,7 +2278,7 @@ static void btrfs_qgroup_rescan_worker(struct btrfs_work *work)
>                 goto out;
>
>         err = 0;
> -       while (!err) {
> +       while (!err && !btrfs_fs_closing(fs_info)) {
>                 trans = btrfs_start_transaction(fs_info->fs_root, 0);
>                 if (IS_ERR(trans)) {
>                         err = PTR_ERR(trans);
> @@ -2301,7 +2301,8 @@ out:
>         btrfs_free_path(path);
>
>         mutex_lock(&fs_info->qgroup_rescan_lock);
> -       fs_info->qgroup_flags &= ~BTRFS_QGROUP_STATUS_FLAG_RESCAN;
> +       if (!btrfs_fs_closing(fs_info))
> +               fs_info->qgroup_flags &= ~BTRFS_QGROUP_STATUS_FLAG_RESCAN;
>
>         if (err > 0 &&
>             fs_info->qgroup_flags & BTRFS_QGROUP_STATUS_FLAG_INCONSISTENT) {
> @@ -2330,7 +2331,9 @@ out:
>         }
>         btrfs_end_transaction(trans, fs_info->quota_root);
>
> -       if (err >= 0) {
> +       if (btrfs_fs_closing(fs_info)) {
> +               btrfs_info(fs_info, "qgroup scan paused");
> +       } else if (err >= 0) {
>                 btrfs_info(fs_info, "qgroup scan completed%s",
>                         err > 0 ? " (inconsistency flag cleared)" : "");
>         } else {

Justin, this is still racy (however much less racy than before).

Once we leave the loop because of the condition
btrfs_fs_closing(fs_info), we start a transaction and do some write
operation on the quota btree. While or before we do such write
operation, close_ctree() might have completed or be at a point where
such write operation will result in another null pointer dereference,
or accessing some dangling pointer, or leak a transaction that never
gets committed (because close_ctree() already stopped the transaction
kthread), etc, etc.

So in addition to what you did, you need to call
btrfs_qgroup_wait_for_completion(fs_info) at disk-io.c:close_ctree()
right after setting fs_info->closing to 1.

Otherwise it looks good.
Thanks.


> --
> 2.5.1
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
