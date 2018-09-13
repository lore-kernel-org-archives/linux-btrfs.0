Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.cn.fujitsu.com ([183.91.158.132]:23355 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726308AbeIMNuy (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 13 Sep 2018 09:50:54 -0400
Date: Thu, 13 Sep 2018 16:42:22 +0800
From: Lu Fengqi <lufq.fnst@cn.fujitsu.com>
To: Nikolay Borisov <nborisov@suse.com>
CC: <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH] btrfs: Remove logically dead code from
 btrfs_orphan_cleanup
Message-ID: <20180913084222.GA10664@fnst.localdomain>
References: <1536827700-20477-1-git-send-email-nborisov@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <1536827700-20477-1-git-send-email-nborisov@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Sep 13, 2018 at 11:35:00AM +0300, Nikolay Borisov wrote:
>In btrfs_orphan_cleanup the final 'if (ret) goto out' cannot ever be
>executed. This is due to the last assignment to 'ret' depending on
>the return value of btrfs_iget. If an error other than -ENOENT is
>returned then the loop is prematurely terminated by 'goto out'.
>On the other hand, if the error value is ENOENT then a subsequent
>if branch is executed that always re-assigns 'ret' and in case it's
>an error just terminates the loop. No functional changes.
>
>CID: 1437392
>Signed-off-by: Nikolay Borisov <nborisov@suse.com>

Reviewed-by: Lu Fengqi <lufq.fnst@cn.fujitsu.com>

>---
> fs/btrfs/inode.c | 2 --
> 1 file changed, 2 deletions(-)
>
>diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
>index 3f03fec06a3a..64df0378a22f 100644
>--- a/fs/btrfs/inode.c
>+++ b/fs/btrfs/inode.c
>@@ -3471,8 +3471,6 @@ int btrfs_orphan_cleanup(struct btrfs_root *root)
> 
> 		/* this will do delete_inode and everything for us */
> 		iput(inode);
>-		if (ret)
>-			goto out;
> 	}
> 	/* release the path since we're done with it */
> 	btrfs_release_path(path);
>-- 
>2.7.4
>
>
>

-- 
Thanks,
Lu
