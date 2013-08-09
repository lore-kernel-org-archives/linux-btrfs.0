Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.19]:56619 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964961Ab3HIJgN (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 9 Aug 2013 05:36:13 -0400
Received: from [172.24.1.182] ([192.166.201.94]) by mail.gmx.com (mrgmx103)
 with ESMTPSA (Nemesis) id 0M6SE3-1W5rDb1xb1-00yOBv for
 <linux-btrfs@vger.kernel.org>; Fri, 09 Aug 2013 11:36:12 +0200
Message-ID: <5204B80B.9010907@gmx.net>
Date: Fri, 09 Aug 2013 11:36:11 +0200
From: Arne Jansen <sensille@gmx.net>
MIME-Version: 1.0
To: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
CC: linux-btrfs@vger.kernel.org, miaox@cn.fujitsu.com
Subject: Re: [PATCH 3/3] Btrfs: remove reduplicate check when disabling quota
References: <1375852351-11919-1-git-send-email-wangsl.fnst@cn.fujitsu.com> <1375852351-11919-3-git-send-email-wangsl.fnst@cn.fujitsu.com>
In-Reply-To: <1375852351-11919-3-git-send-email-wangsl.fnst@cn.fujitsu.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 07.08.2013 07:12, Wang Shilong wrote:
> We have checked 'quota_root' with qgroup_ioctl_lock held before,So
> here the check is reduplicate, remove it.
> 
> Signed-off-by: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
> Reviewed-by: Miao Xie <miaox@cn.fujitsu.com>
> ---
>  fs/btrfs/qgroup.c | 5 -----
>  1 file changed, 5 deletions(-)
> 
> diff --git a/fs/btrfs/qgroup.c b/fs/btrfs/qgroup.c
> index b809616..df2841d 100644
> --- a/fs/btrfs/qgroup.c
> +++ b/fs/btrfs/qgroup.c
> @@ -943,11 +943,6 @@ int btrfs_quota_disable(struct btrfs_trans_handle *trans,
>  
>  	btrfs_free_qgroup_config(fs_info);
>  
> -	if (!quota_root) {
> -		ret = -EINVAL;
> -		goto out;
> -	}
> -
>  	ret = btrfs_clean_quota_tree(trans, quota_root);
>  	if (ret)
>  		goto out;

Reviewed-by: Arne Jansen <sensille@gmx.net>
