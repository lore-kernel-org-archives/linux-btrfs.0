Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mo-p05-ob.rzone.de ([81.169.146.181]:64226 "EHLO
	mo-p05-ob.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755415Ab3DBMT6 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 2 Apr 2013 08:19:58 -0400
Message-ID: <515ACCE4.5030800@jan-o-sch.net>
Date: Tue, 02 Apr 2013 14:19:48 +0200
From: Jan Schmidt <list.btrfs@jan-o-sch.net>
MIME-Version: 1.0
To: Wang Shilong <wangshilong1991@gmail.com>
CC: linux-btrfs@vger.kernel.org, sensille@gmx.net, miaox@cn.fujitsu.com,
        wangsl-fnst@cn.fujitsu.com
Subject: Re: [PATCH V2 1/6] Btrfs: introduce a mutex lock for btrfs quota
 operations
References: <1364468024-1636-1-git-send-email-wangshilong1991@gmail.com>
In-Reply-To: <1364468024-1636-1-git-send-email-wangshilong1991@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Wang,

On Thu, March 28, 2013 at 11:53 (+0100), Wang Shilong wrote:
> From: Wang Shilong <wangsl-fnst@cn.fujitsu.com>
> 
> This patch introduces mutex lock 'quota_lock', and makes
> all the user change for quota protected by quota_lock.

Can you please add a few lines why this lock is needed? I.e., which ioctls fail
without that kind of synchronization?

> Signed-off-by: Wang Shilong <wangsl-fnst@cn.fujitsu.com>
> Reviewed-by: Miao Xie <miaox@cn.fujitsu.com>
> ---
>  fs/btrfs/ctree.h   |    3 +++
>  fs/btrfs/disk-io.c |    1 +
>  fs/btrfs/ioctl.c   |   16 ++++++++++++----
>  3 files changed, 16 insertions(+), 4 deletions(-)
> 
> diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
> index 6e81860..a11a8ed 100644
> --- a/fs/btrfs/ctree.h
> +++ b/fs/btrfs/ctree.h
> @@ -1584,6 +1584,9 @@ struct btrfs_fs_info {
>  	struct rb_root qgroup_tree;
>  	spinlock_t qgroup_lock;
>  
> +	/* protect user change operations for quota */
> +	struct mutex quota_lock;

Having fs_info->qgroup_lock and fs_info->quota_lock going to be a major source
of confusion. I'd call the new one qgroup_ioctl_lock or ioctl_qgroup_lock instead.

Furthermore, the term "quota" was intentionally left unused to leave room for
other quota implementations later (user quota).

And, please, use --thread with git send-email for related patches to get correct
headers.

Thanks,
-Jan

> [snip]
