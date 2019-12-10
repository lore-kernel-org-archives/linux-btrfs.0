Return-Path: <SRS0=ik6r=2A=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 88284C00454
	for <linux-btrfs@archiver.kernel.org>; Tue, 10 Dec 2019 21:35:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 531E52467B
	for <linux-btrfs@archiver.kernel.org>; Tue, 10 Dec 2019 21:35:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1576013734;
	bh=WNhs5eh30x01ZvJF/JCaVXVbrAOKud9wgOP34Dw0jIA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=bpof62FWz4k9Tqb3WOdfV5BjV7N4k5zvxoP2TDkdHYGqfR4Z49UYwjC12pVhDlM5c
	 O1icbyC8z37KEC5iWjOjunAdiAI5Eb1MtFUtxUYJ1VnqGahMVQ5xaGtxPfWUZ0WXni
	 qMeQ5GV519SphoLuZnDWNpqis5IgeM1gOo2SlJPE=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730294AbfLJVfd (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 10 Dec 2019 16:35:33 -0500
Received: from mail.kernel.org ([198.145.29.99]:41338 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730287AbfLJVfc (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 10 Dec 2019 16:35:32 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4016324655;
        Tue, 10 Dec 2019 21:35:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576013732;
        bh=WNhs5eh30x01ZvJF/JCaVXVbrAOKud9wgOP34Dw0jIA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rBjNed3zGu0vSjZ3u8KH29S4qXypZB2evlRpRhb/qYkkX4hOYJvX9IG+OwlgR3X1T
         YQL1u19ahm+o73+NlwwYlHd0A+emYv24iMVBd8hILPuWVQZ3RJmlU1XMrwZyh/b+bc
         JjvlNishw0/K42ERxmCTOLlxuwOHH98Hij11DJ7g=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Omar Sandoval <osandov@fb.com>,
        Johannes Thumshirn <jthumshirn@suse.de>,
        David Sterba <dsterba@suse.com>,
        Sasha Levin <sashal@kernel.org>, linux-btrfs@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 156/177] btrfs: don't prematurely free work in end_workqueue_fn()
Date:   Tue, 10 Dec 2019 16:32:00 -0500
Message-Id: <20191210213221.11921-156-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191210213221.11921-1-sashal@kernel.org>
References: <20191210213221.11921-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

From: Omar Sandoval <osandov@fb.com>

[ Upstream commit 9be490f1e15c34193b1aae17da58e14dd9f55a95 ]

Currently, end_workqueue_fn() frees the end_io_wq entry (which embeds
the work item) and then calls bio_endio(). This is another potential
instance of the bug in "btrfs: don't prematurely free work in
run_ordered_work()".

In particular, the endio call may depend on other work items. For
example, btrfs_end_dio_bio() can call btrfs_subio_endio_read() ->
__btrfs_correct_data_nocsum() -> dio_read_error() ->
submit_dio_repair_bio(), which submits a bio that is also completed
through a end_workqueue_fn() work item. However,
__btrfs_correct_data_nocsum() waits for the newly submitted bio to
complete, thus it depends on another work item.

This example currently usually works because we use different workqueue
helper functions for BTRFS_WQ_ENDIO_DATA and BTRFS_WQ_ENDIO_DIO_REPAIR.
However, it may deadlock with stacked filesystems and is fragile
overall. The proper fix is to free the work item at the very end of the
work function, so let's do that.

Reviewed-by: Johannes Thumshirn <jthumshirn@suse.de>
Signed-off-by: Omar Sandoval <osandov@fb.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/disk-io.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 96296dc7d2ea4..e12c37f457e05 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -1660,8 +1660,8 @@ static void end_workqueue_fn(struct btrfs_work *work)
 	bio->bi_status = end_io_wq->status;
 	bio->bi_private = end_io_wq->private;
 	bio->bi_end_io = end_io_wq->end_io;
-	kmem_cache_free(btrfs_end_io_wq_cache, end_io_wq);
 	bio_endio(bio);
+	kmem_cache_free(btrfs_end_io_wq_cache, end_io_wq);
 }
 
 static int cleaner_kthread(void *arg)
-- 
2.20.1

