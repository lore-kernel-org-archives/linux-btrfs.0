Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mgwym01.jp.fujitsu.com ([211.128.242.40]:55286 "EHLO
        mgwym01.jp.fujitsu.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731918AbeG0Cai (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 26 Jul 2018 22:30:38 -0400
Received: from g01jpfmpwkw02.exch.g01.fujitsu.local (g01jpfmpwkw02.exch.g01.fujitsu.local [10.0.193.56])
        by yt-mxq.gw.nic.fujitsu.com (Postfix) with ESMTP id 23B40AC02C8
        for <linux-btrfs@vger.kernel.org>; Fri, 27 Jul 2018 10:11:09 +0900 (JST)
Subject: Re: [PATCH] btrfs: qgroup: Init flags with RESCAN bit at quota enable
 time
To: Qu Wenruo <wqu@suse.com>, <linux-btrfs@vger.kernel.org>
References: <20180726091504.5833-1-wqu@suse.com>
From: Misono Tomohiro <misono.tomohiro@jp.fujitsu.com>
Message-ID: <2531cce4-b3d5-88c7-30d5-b7461bd43fc3@jp.fujitsu.com>
Date: Fri, 27 Jul 2018 10:10:54 +0900
MIME-Version: 1.0
In-Reply-To: <20180726091504.5833-1-wqu@suse.com>
Content-Type: text/plain; charset="utf-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2018/07/26 18:15, Qu Wenruo wrote:
> Between btrfs_quota_enable() finished and rescan kicked in, there is a
> small window that quota status has (ON | INCONSISTENT) bits set but
> without RESCAN bits set.
> 
> And transaction is committed inside the window and then power loss
> happens, we will have a quota tree with all qgroup numbers set to 0, and
> not RESCAN bit set.
> 
> At next mount time, qgroup rescan will not kick in due to the missing of
> RESCAN bit, user needs to kick in rescan manually.
> 
> This patch will fix it by setting RESCAN bit at btrfs_quota_enable(),
> so even after power loss we will still kick in rescan automatically.
> 
> Suggested-by: Misono Tomohiro <misono.tomohiro@jp.fujitsu.com>
> Signed-off-by: Qu Wenruo <wqu@suse.com>
> ---
>  fs/btrfs/qgroup.c | 5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/btrfs/qgroup.c b/fs/btrfs/qgroup.c
> index c25dc47210a3..13c1c7dd278d 100644
> --- a/fs/btrfs/qgroup.c
> +++ b/fs/btrfs/qgroup.c
> @@ -930,7 +930,8 @@ int btrfs_quota_enable(struct btrfs_trans_handle *trans,
>  	btrfs_set_qgroup_status_generation(leaf, ptr, trans->transid);
>  	btrfs_set_qgroup_status_version(leaf, ptr, BTRFS_QGROUP_STATUS_VERSION);
>  	fs_info->qgroup_flags = BTRFS_QGROUP_STATUS_FLAG_ON |
> -				BTRFS_QGROUP_STATUS_FLAG_INCONSISTENT;
> +				BTRFS_QGROUP_STATUS_FLAG_INCONSISTENT |
> +				BTRFS_QGROUP_STATUS_FLAG_RESCAN;
>  	btrfs_set_qgroup_status_flags(leaf, ptr, fs_info->qgroup_flags);
>  	btrfs_set_qgroup_status_rescan(leaf, ptr, 0);
>  
> @@ -987,7 +988,7 @@ int btrfs_quota_enable(struct btrfs_trans_handle *trans,
>  	fs_info->quota_root = quota_root;
>  	set_bit(BTRFS_FS_QUOTA_ENABLED, &fs_info->flags);
>  	spin_unlock(&fs_info->qgroup_lock);
> -	ret = qgroup_rescan_init(fs_info, 0, 1);
> +	ret = qgroup_rescan_init(fs_info, 0, 0);
>  	if (!ret) {
>  	        qgroup_rescan_zero_tracking(fs_info);
>  	        btrfs_queue_work(fs_info->qgroup_rescan_workers,
> 

This is what I think at first, but is it ok not holding fs_info->qgroup_ioctl_lock
in brfs_qgroup_rescan() as you concerned in previous thread?

