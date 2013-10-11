Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:34529 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751902Ab3JKBQW (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 10 Oct 2013 21:16:22 -0400
Message-ID: <525750B4.4090009@cn.fujitsu.com>
Date: Fri, 11 Oct 2013 09:13:24 +0800
From: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
MIME-Version: 1.0
To: Ilya Dryomov <idryomov@gmail.com>
CC: linux-btrfs@vger.kernel.org, Chris Mason <chris.mason@fusionio.com>,
        Stefan Behrens <sbehrens@giantdisaster.de>
Subject: Re: [PATCH] Btrfs: disallow 'btrfs {balance,replace} cancel' on ro
 mounts
References: <1381426821-31981-1-git-send-email-idryomov@gmail.com>
In-Reply-To: <1381426821-31981-1-git-send-email-idryomov@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 10/11/2013 01:40 AM, Ilya Dryomov wrote:

I have a question in my mind.

Can we reach a state that there is operation in progress when filesystem
has been readonly?If we do cancel operations on a ro filesystem, we should
get "No operations in progress" .

Thanks,
Wang
> For both balance and replace, cancelling involves changing the on-disk
> state and committing a transaction, which is not a good thing to do on
> read-only filesystems.
>
> Cc: Stefan Behrens <sbehrens@giantdisaster.de>
> Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
> ---
>   fs/btrfs/dev-replace.c |    3 +++
>   fs/btrfs/volumes.c     |    3 +++
>   2 files changed, 6 insertions(+)
>
> diff --git a/fs/btrfs/dev-replace.c b/fs/btrfs/dev-replace.c
> index 9efb94e..98df261 100644
> --- a/fs/btrfs/dev-replace.c
> +++ b/fs/btrfs/dev-replace.c
> @@ -650,6 +650,9 @@ static u64 __btrfs_dev_replace_cancel(struct btrfs_fs_info *fs_info)
>   	u64 result;
>   	int ret;
>   
> +	if (fs_info->sb->s_flags & MS_RDONLY)
> +		return -EROFS;
> +
>   	mutex_lock(&dev_replace->lock_finishing_cancel_unmount);
>   	btrfs_dev_replace_lock(dev_replace);
>   	switch (dev_replace->replace_state) {
> diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
> index a306db9..2630f38 100644
> --- a/fs/btrfs/volumes.c
> +++ b/fs/btrfs/volumes.c
> @@ -3424,6 +3424,9 @@ int btrfs_pause_balance(struct btrfs_fs_info *fs_info)
>   
>   int btrfs_cancel_balance(struct btrfs_fs_info *fs_info)
>   {
> +	if (fs_info->sb->s_flags & MS_RDONLY)
> +		return -EROFS;
> +
>   	mutex_lock(&fs_info->balance_mutex);
>   	if (!fs_info->balance_ctl) {
>   		mutex_unlock(&fs_info->balance_mutex);

