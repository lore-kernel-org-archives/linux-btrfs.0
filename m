Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.cn.fujitsu.com ([183.91.158.132]:12648 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726832AbeIMN6V (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 13 Sep 2018 09:58:21 -0400
Date: Thu, 13 Sep 2018 16:49:48 +0800
From: Lu Fengqi <lufq.fnst@cn.fujitsu.com>
To: Nikolay Borisov <nborisov@suse.com>
CC: <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH] btrfs: Handle error of get_old_root
Message-ID: <20180913084948.GE2790@fnst.localdomain>
References: <1536827710-20534-1-git-send-email-nborisov@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <1536827710-20534-1-git-send-email-nborisov@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Sep 13, 2018 at 11:35:10AM +0300, Nikolay Borisov wrote:
>In btrfs_search_old_slot get_old_root is always used with the
>assumption it cannot fail. However, this is not true in rare
>circumstance it can fail and return null. This will lead to null
>point dereference when the header is read. Fix this by checking the
>return value and properly handling NULL by setting ret to -EIO and
>returning gracefully.
>
>CID: 1087503
>Signed-off-by: Nikolay Borisov <nborisov@suse.com>

Reviewed-by: Lu Fengqi <lufq.fnst@cn.fujitsu.com>

-- 
Thanks,
Lu

>---
> fs/btrfs/ctree.c | 4 ++++
> 1 file changed, 4 insertions(+)
>
>diff --git a/fs/btrfs/ctree.c b/fs/btrfs/ctree.c
>index 1124d236291d..a5399fd49c17 100644
>--- a/fs/btrfs/ctree.c
>+++ b/fs/btrfs/ctree.c
>@@ -2961,6 +2961,10 @@ int btrfs_search_old_slot(struct btrfs_root *root, const struct btrfs_key *key,
> 
> again:
> 	b = get_old_root(root, time_seq);
>+	if (!b) {
>+		ret = -EIO;
>+		goto done;
>+	}
> 	level = btrfs_header_level(b);
> 	p->locks[level] = BTRFS_READ_LOCK;
> 
>-- 
>2.7.4
>
>
>
