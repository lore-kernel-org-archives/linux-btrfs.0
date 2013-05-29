Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pb0-f44.google.com ([209.85.160.44]:63361 "EHLO
	mail-pb0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966715Ab3E2OCO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 29 May 2013 10:02:14 -0400
Received: by mail-pb0-f44.google.com with SMTP id wz12so9259718pbc.17
        for <linux-btrfs@vger.kernel.org>; Wed, 29 May 2013 07:02:14 -0700 (PDT)
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 6.2 \(1499\))
Subject: Re: [PATCH 1/3] Btrfs: fix memory patcher through fs_info->qgroup_ulist
From: Wang Shilong <wangshilong1991@gmail.com>
In-Reply-To: <1369756044-17194-2-git-send-email-list.btrfs@jan-o-sch.net>
Date: Wed, 29 May 2013 22:02:08 +0800
Cc: linux-btrfs@vger.kernel.org
Message-Id: <AD828A94-D400-465D-BB54-4AA700917C5F@gmail.com>
References: <1369756044-17194-1-git-send-email-list.btrfs@jan-o-sch.net> <1369756044-17194-2-git-send-email-list.btrfs@jan-o-sch.net>
To: Jan Schmidt <list.btrfs@jan-o-sch.net>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello Jan

> Commit 5b7c665e introduced fs_info->qgroup_ulist, that is allocated during
> btrfs_read_qgroup_config and meant to be used later by the qgroup accounting
> code. However, it is always freed before btrfs_read_qgroup_config returns,
> becuase the commit mentioned above adds a check for (ret), where a check
> for (ret < 0) would have been the right choice. This commit fixes the check.
> 
> Cc: Wang Shilong <wangsl-fnst@cn.fujitsu.com>
> Signed-off-by: Jan Schmidt <list.btrfs@jan-o-sch.net>
> ---
> fs/btrfs/qgroup.c |    2 +-
> 1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/fs/btrfs/qgroup.c b/fs/btrfs/qgroup.c
> index d059d86..74b432d 100644
> --- a/fs/btrfs/qgroup.c
> +++ b/fs/btrfs/qgroup.c
> @@ -430,7 +430,7 @@ out:
> 	}
> 	btrfs_free_path(path);
> 
> -	if (ret)
> +	if (ret < 0)
> 		ulist_free(fs_info->qgroup_ulist);
> 

Looks good to me ,thanks very much for fixing this issue!

Thanks,
Wang

> 	return ret < 0 ? ret : 0;
> -- 
> 1.7.1
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

