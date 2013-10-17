Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wi0-f176.google.com ([209.85.212.176]:34463 "EHLO
	mail-wi0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750863Ab3JQHvm (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 17 Oct 2013 03:51:42 -0400
Received: by mail-wi0-f176.google.com with SMTP id l12so7928896wiv.9
        for <linux-btrfs@vger.kernel.org>; Thu, 17 Oct 2013 00:51:41 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1380201996-17445-2-git-send-email-jbacik@fusionio.com>
References: <1380201996-17445-1-git-send-email-jbacik@fusionio.com>
	<1380201996-17445-2-git-send-email-jbacik@fusionio.com>
Date: Thu, 17 Oct 2013 10:51:41 +0300
Message-ID: <CAOcd+r0ohz-e4UTUAo2smETpnN4Gw_c9cB-bUa+UEfw8PfaePw@mail.gmail.com>
Subject: Re: [PATCH 2/2] Btrfs: stop caching thread if extent_commit_sem is contended
From: Alex Lyakas <alex.btrfs@zadarastorage.com>
To: Josef Bacik <jbacik@fusionio.com>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Thanks for addressing this issue, Josef!

On Thu, Sep 26, 2013 at 4:26 PM, Josef Bacik <jbacik@fusionio.com> wrote:
> We can starve out the transaction commit with a bunch of caching threads all
> running at the same time.  This is because we will only drop the
> extent_commit_sem if we need_resched(), which isn't likely to happen since we
> will be reading a lot from the disk so have already schedule()'ed plenty.  Alex
> observed that he could starve out a transaction commit for up to a minute with
> 32 caching threads all running at once.  This will allow us to drop the
> extent_commit_sem to allow the transaction commit to swap the commit_root out
> and then all the cachers will start back up. Here is an explanation provided by
> Igno
>
> So, just to fill in what happens in this loop:
>
>                                 mutex_unlock(&caching_ctl->mutex);
>                                 cond_resched();
>                                 goto again;
>
> where 'again:' takes caching_ctl->mutex and fs_info->extent_commit_sem
> again:
>
>         again:
>                 mutex_lock(&caching_ctl->mutex);
>                 /* need to make sure the commit_root doesn't disappear */
>                 down_read(&fs_info->extent_commit_sem);
>
> So, if I'm reading the code correct, there can be a fair amount of
> concurrency here: there may be multiple 'caching kthreads' per filesystem
> active, while there's one fs_info->extent_commit_sem per filesystem
> AFAICS.
>
> So, what happens if there are a lot of CPUs all busy holding the
> ->extent_commit_sem rwsem read-locked and a writer arrives? They'd all
> rush to try to release the fs_info->extent_commit_sem, and they'd block in
> the down_read() because there's a writer waiting.
>
> So there's a guarantee of forward progress. This should answer akpm's
> concern I think.
>
> Thanks,
>
> Acked-by: Ingo Molnar <mingo@kernel.org>
> Signed-off-by: Josef Bacik <jbacik@fusionio.com>
> ---
>  fs/btrfs/extent-tree.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
>
> diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
> index cfb3cf7..cc074c34 100644
> --- a/fs/btrfs/extent-tree.c
> +++ b/fs/btrfs/extent-tree.c
> @@ -442,7 +442,8 @@ next:
>                         if (ret)
>                                 break;
>
> -                       if (need_resched()) {
> +                       if (need_resched() ||
> +                           rwsem_is_contended(&fs_info->extent_commit_sem)) {
>                                 caching_ctl->progress = last;
>                                 btrfs_release_path(path);
>                                 up_read(&fs_info->extent_commit_sem);
> --
> 1.8.3.1
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
