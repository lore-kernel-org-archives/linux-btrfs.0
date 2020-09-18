Return-Path: <SRS0=R6Ud=C3=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D97FDC43466
	for <linux-btrfs@archiver.kernel.org>; Fri, 18 Sep 2020 02:11:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8FD4F21582
	for <linux-btrfs@archiver.kernel.org>; Fri, 18 Sep 2020 02:11:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1600395109;
	bh=2CYtoLE6tkaOuCZ9bu0qmOv22maS6zu8dykYr2rF6Eg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=Zk1DxpVkQSVqCHxb76NRb4GdoNHrvsWPTOT0JZYhEQk/VVU9lnLcPtLKE3LaQUK5Z
	 ZKs5YXy8PLdx2YRk8F008SuYIDgltRq/EkSueS2CjLYTk44IfrxqayKQ9iOT9a6W7V
	 ZyR/HEm4XfulGGLAb5Bsh1DgtNbpdBaMRXM0HREc=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728677AbgIRCLs (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 17 Sep 2020 22:11:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:37338 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728657AbgIRCLk (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 17 Sep 2020 22:11:40 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AA91F23787;
        Fri, 18 Sep 2020 02:11:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600395095;
        bh=2CYtoLE6tkaOuCZ9bu0qmOv22maS6zu8dykYr2rF6Eg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UjsgG+LQtzX0p8VQYTAAV4RcvKApuojaIJmBm2/trxXXnhELhjB9u94YKg6E9BxNR
         QxAxQEs02+o15d+vQmGYCSFJWZ9u9vbJTX2zYPjnrijkz4r5aQbcFNtUZvagVo4tCm
         WYQNgzlUDBvk5H0Al9Viv8WVmrDV5SY6BlQ3WVU0=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     David Sterba <dsterba@suse.com>, Sasha Levin <sashal@kernel.org>,
        linux-btrfs@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 176/206] btrfs: don't force read-only after error in drop snapshot
Date:   Thu, 17 Sep 2020 22:07:32 -0400
Message-Id: <20200918020802.2065198-176-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200918020802.2065198-1-sashal@kernel.org>
References: <20200918020802.2065198-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

From: David Sterba <dsterba@suse.com>

[ Upstream commit 7c09c03091ac562ddca2b393e5d65c1d37da79f1 ]

Deleting a subvolume on a full filesystem leads to ENOSPC followed by a
forced read-only. This is not a transaction abort and the filesystem is
otherwise ok, so the error should be just propagated to the callers.

This is caused by unnecessary call to btrfs_handle_fs_error for all
errors, except EAGAIN. This does not make sense as the standard
transaction abort mechanism is in btrfs_drop_snapshot so all relevant
failures are handled.

Originally in commit cb1b69f4508a ("Btrfs: forced readonly when
btrfs_drop_snapshot() fails") there was no return value at all, so the
btrfs_std_error made some sense but once the error handling and
propagation has been implemented we don't need it anymore.

Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/extent-tree.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index ec3aa76d19b7f..be0776eba7a08 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -9099,8 +9099,6 @@ out:
 	 */
 	if (!for_reloc && !root_dropped)
 		btrfs_add_dead_root(root);
-	if (err && err != -EAGAIN)
-		btrfs_handle_fs_error(fs_info, err, NULL);
 	return err;
 }
 
-- 
2.25.1

