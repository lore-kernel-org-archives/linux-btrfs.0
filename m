Return-Path: <SRS0=X8W1=NL=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_MUTT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 36C9DC0044C
	for <linux-btrfs@archiver.kernel.org>; Wed, 31 Oct 2018 07:41:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D4B7720821
	for <linux-btrfs@archiver.kernel.org>; Wed, 31 Oct 2018 07:41:52 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org D4B7720821
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=cn.fujitsu.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726364AbeJaQit (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 31 Oct 2018 12:38:49 -0400
Received: from mail.cn.fujitsu.com ([183.91.158.132]:6577 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725955AbeJaQit (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 31 Oct 2018 12:38:49 -0400
X-IronPort-AV: E=Sophos;i="5.43,368,1503331200"; 
   d="scan'208";a="47045492"
Received: from unknown (HELO cn.fujitsu.com) ([10.167.33.5])
  by heian.cn.fujitsu.com with ESMTP; 31 Oct 2018 15:41:49 +0800
Received: from G08CNEXCHPEKD01.g08.fujitsu.local (unknown [10.167.33.80])
        by cn.fujitsu.com (Postfix) with ESMTP id C5DB54B71EA6;
        Wed, 31 Oct 2018 15:41:49 +0800 (CST)
Received: from fnst.localdomain (10.167.226.155) by
 G08CNEXCHPEKD01.g08.fujitsu.local (10.167.33.89) with Microsoft SMTP Server
 (TLS) id 14.3.408.0; Wed, 31 Oct 2018 15:41:56 +0800
Date:   Wed, 31 Oct 2018 15:41:47 +0800
From:   Lu Fengqi <lufq.fnst@cn.fujitsu.com>
To:     Omar Sandoval <osandov@osandov.com>
CC:     <linux-btrfs@vger.kernel.org>, <kernel-team@fb.com>
Subject: Re: [PATCH] Btrfs: fix missing delayed iputs on unmount
Message-ID: <20181031074147.GB2656@fnst.localdomain>
References: <9b8c7d1ce662d216cf29ffcb756d177b0bf60b64.1540944854.git.osandov@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <9b8c7d1ce662d216cf29ffcb756d177b0bf60b64.1540944854.git.osandov@fb.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Originating-IP: [10.167.226.155]
X-yoursite-MailScanner-ID: C5DB54B71EA6.AD583
X-yoursite-MailScanner: Found to be clean
X-yoursite-MailScanner-From: lufq.fnst@cn.fujitsu.com
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Tue, Oct 30, 2018 at 05:14:42PM -0700, Omar Sandoval wrote:
>From: Omar Sandoval <osandov@fb.com>
>
>There's a race between close_ctree() and cleaner_kthread().
>close_ctree() sets btrfs_fs_closing(), and the cleaner stops when it
>sees it set, but this is racy; the cleaner might have already checked
>the bit and could be cleaning stuff. In particular, if it deletes unused
>block groups, it will create delayed iputs for the free space cache
>inodes. As of "btrfs: don't run delayed_iputs in commit", we're no
>longer running delayed iputs after a commit. Therefore, if the cleaner
>creates more delayed iputs after delayed iputs are run in
>btrfs_commit_super(), we will leak inodes on unmount and get a busy

Since the assert added via commit e187831e1875 ("btrfs: assert on non-empty
delayed iputs") wasn't triggered, it doesn't seem to be the cause of inode
leak.

-- 
Thanks,
Lu

>inode crash from the VFS.
>
>Fix it by parking the cleaner before we actually close anything. Then,
>any remaining delayed iputs will always be handled in
>btrfs_commit_super(). This also ensures that the commit in close_ctree()
>is really the last commit, so we can get rid of the commit in
>cleaner_kthread().
>
>Fixes: 30928e9baac2 ("btrfs: don't run delayed_iputs in commit")
>Signed-off-by: Omar Sandoval <osandov@fb.com>
>---
>We found this with a stress test that our containers team runs. I'm
>wondering if this same race could have caused any other issues other
>than this new iput thing, but I couldn't identify any.
>
> fs/btrfs/disk-io.c | 40 +++++++---------------------------------
> 1 file changed, 7 insertions(+), 33 deletions(-)
>
>diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
>index b0ab41da91d1..7c17284ae3c2 100644
>--- a/fs/btrfs/disk-io.c
>+++ b/fs/btrfs/disk-io.c
>@@ -1664,9 +1664,8 @@ static int cleaner_kthread(void *arg)
> 	struct btrfs_root *root = arg;
> 	struct btrfs_fs_info *fs_info = root->fs_info;
> 	int again;
>-	struct btrfs_trans_handle *trans;
> 
>-	do {
>+	while (1) {
> 		again = 0;
> 
> 		/* Make the cleaner go to sleep early. */
>@@ -1715,42 +1714,16 @@ static int cleaner_kthread(void *arg)
> 		 */
> 		btrfs_delete_unused_bgs(fs_info);
> sleep:
>+		if (kthread_should_park())
>+			kthread_parkme();
>+		if (kthread_should_stop())
>+			return 0;
> 		if (!again) {
> 			set_current_state(TASK_INTERRUPTIBLE);
>-			if (!kthread_should_stop())
>-				schedule();
>+			schedule();
> 			__set_current_state(TASK_RUNNING);
> 		}
>-	} while (!kthread_should_stop());
>-
>-	/*
>-	 * Transaction kthread is stopped before us and wakes us up.
>-	 * However we might have started a new transaction and COWed some
>-	 * tree blocks when deleting unused block groups for example. So
>-	 * make sure we commit the transaction we started to have a clean
>-	 * shutdown when evicting the btree inode - if it has dirty pages
>-	 * when we do the final iput() on it, eviction will trigger a
>-	 * writeback for it which will fail with null pointer dereferences
>-	 * since work queues and other resources were already released and
>-	 * destroyed by the time the iput/eviction/writeback is made.
>-	 */
>-	trans = btrfs_attach_transaction(root);
>-	if (IS_ERR(trans)) {
>-		if (PTR_ERR(trans) != -ENOENT)
>-			btrfs_err(fs_info,
>-				  "cleaner transaction attach returned %ld",
>-				  PTR_ERR(trans));
>-	} else {
>-		int ret;
>-
>-		ret = btrfs_commit_transaction(trans);
>-		if (ret)
>-			btrfs_err(fs_info,
>-				  "cleaner open transaction commit returned %d",
>-				  ret);
> 	}
>-
>-	return 0;
> }
> 
> static int transaction_kthread(void *arg)
>@@ -3931,6 +3904,7 @@ void close_ctree(struct btrfs_fs_info *fs_info)
> 	int ret;
> 
> 	set_bit(BTRFS_FS_CLOSING_START, &fs_info->flags);
>+	kthread_park(fs_info->cleaner_kthread);
> 
> 	/* wait for the qgroup rescan worker to stop */
> 	btrfs_qgroup_wait_for_completion(fs_info, false);
>-- 
>2.19.1
>
>
>
>


