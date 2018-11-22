Return-Path: <SRS0=krA0=OB=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_MUTT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2771FC43441
	for <linux-btrfs@archiver.kernel.org>; Thu, 22 Nov 2018 08:56:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9B1A620820
	for <linux-btrfs@archiver.kernel.org>; Thu, 22 Nov 2018 08:56:51 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 9B1A620820
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=cn.fujitsu.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732237AbeKVTfV (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 22 Nov 2018 14:35:21 -0500
Received: from mail.cn.fujitsu.com ([183.91.158.132]:12976 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1731714AbeKVTfV (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 22 Nov 2018 14:35:21 -0500
X-IronPort-AV: E=Sophos;i="5.43,368,1503331200"; 
   d="scan'208";a="48553250"
Received: from unknown (HELO cn.fujitsu.com) ([10.167.33.5])
  by heian.cn.fujitsu.com with ESMTP; 22 Nov 2018 16:56:41 +0800
Received: from G08CNEXCHPEKD01.g08.fujitsu.local (unknown [10.167.33.80])
        by cn.fujitsu.com (Postfix) with ESMTP id 787A44B7348C;
        Thu, 22 Nov 2018 16:56:42 +0800 (CST)
Received: from fnst.localdomain (10.167.226.155) by
 G08CNEXCHPEKD01.g08.fujitsu.local (10.167.33.89) with Microsoft SMTP Server
 (TLS) id 14.3.408.0; Thu, 22 Nov 2018 16:56:48 +0800
Date:   Thu, 22 Nov 2018 16:56:38 +0800
From:   Lu Fengqi <lufq.fnst@cn.fujitsu.com>
To:     Josef Bacik <josef@toxicpanda.com>
CC:     <linux-btrfs@vger.kernel.org>, <kernel-team@fb.com>,
        Josef Bacik <jbacik@fb.com>
Subject: Re: [PATCH 3/6] btrfs: cleanup extent_op handling
Message-ID: <20181122085638.GA3002@fnst.localdomain>
References: <20181121185912.24288-1-josef@toxicpanda.com>
 <20181121185912.24288-4-josef@toxicpanda.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20181121185912.24288-4-josef@toxicpanda.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Originating-IP: [10.167.226.155]
X-yoursite-MailScanner-ID: 787A44B7348C.AB567
X-yoursite-MailScanner: Found to be clean
X-yoursite-MailScanner-From: lufq.fnst@cn.fujitsu.com
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Wed, Nov 21, 2018 at 01:59:09PM -0500, Josef Bacik wrote:
>From: Josef Bacik <jbacik@fb.com>
>
>The cleanup_extent_op function actually would run the extent_op if it
>needed running, which made the name sort of a misnomer.  Change it to
>run_and_cleanup_extent_op, and move the actual cleanup work to
>cleanup_extent_op so it can be used by check_ref_cleanup() in order to
>unify the extent op handling.
>
>Signed-off-by: Josef Bacik <jbacik@fb.com>

One nitpick below.

Reviewed-by: Lu Fengqi <lufq.fnst@cn.fujitsu.com>

>---
> fs/btrfs/extent-tree.c | 36 +++++++++++++++++++++++-------------
> 1 file changed, 23 insertions(+), 13 deletions(-)
>
>diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
>index e3ed3507018d..8a776dc9cb38 100644
>--- a/fs/btrfs/extent-tree.c
>+++ b/fs/btrfs/extent-tree.c
>@@ -2424,19 +2424,33 @@ static void unselect_delayed_ref_head(struct btrfs_delayed_ref_root *delayed_ref
> 	btrfs_delayed_ref_unlock(head);
> }
> 
>-static int cleanup_extent_op(struct btrfs_trans_handle *trans,
>-			     struct btrfs_delayed_ref_head *head)
>+static struct btrfs_delayed_extent_op *
>+cleanup_extent_op(struct btrfs_trans_handle *trans,

The trans parameter seems useless.

-- 
Thanks,
Lu

>+		  struct btrfs_delayed_ref_head *head)
> {
> 	struct btrfs_delayed_extent_op *extent_op = head->extent_op;
>-	int ret;
> 
> 	if (!extent_op)
>-		return 0;
>-	head->extent_op = NULL;
>+		return NULL;
>+
> 	if (head->must_insert_reserved) {
>+		head->extent_op = NULL;
> 		btrfs_free_delayed_extent_op(extent_op);
>-		return 0;
>+		return NULL;
> 	}
>+	return extent_op;
>+}
>+
>+static int run_and_cleanup_extent_op(struct btrfs_trans_handle *trans,
>+				     struct btrfs_delayed_ref_head *head)
>+{
>+	struct btrfs_delayed_extent_op *extent_op =
>+		cleanup_extent_op(trans, head);
>+	int ret;
>+
>+	if (!extent_op)
>+		return 0;
>+	head->extent_op = NULL;
> 	spin_unlock(&head->lock);
> 	ret = run_delayed_extent_op(trans, head, extent_op);
> 	btrfs_free_delayed_extent_op(extent_op);
>@@ -2488,7 +2502,7 @@ static int cleanup_ref_head(struct btrfs_trans_handle *trans,
> 
> 	delayed_refs = &trans->transaction->delayed_refs;
> 
>-	ret = cleanup_extent_op(trans, head);
>+	ret = run_and_cleanup_extent_op(trans, head);
> 	if (ret < 0) {
> 		unselect_delayed_ref_head(delayed_refs, head);
> 		btrfs_debug(fs_info, "run_delayed_extent_op returned %d", ret);
>@@ -6977,12 +6991,8 @@ static noinline int check_ref_cleanup(struct btrfs_trans_handle *trans,
> 	if (!RB_EMPTY_ROOT(&head->ref_tree.rb_root))
> 		goto out;
> 
>-	if (head->extent_op) {
>-		if (!head->must_insert_reserved)
>-			goto out;
>-		btrfs_free_delayed_extent_op(head->extent_op);
>-		head->extent_op = NULL;
>-	}
>+	if (cleanup_extent_op(trans, head) != NULL)
>+		goto out;
> 
> 	/*
> 	 * waiting for the lock here would deadlock.  If someone else has it
>-- 
>2.14.3
>
>
>


