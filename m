Return-Path: <SRS0=cN6C=MQ=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5C87EC64EBC
	for <linux-btrfs@archiver.kernel.org>; Thu,  4 Oct 2018 06:02:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 171EF20877
	for <linux-btrfs@archiver.kernel.org>; Thu,  4 Oct 2018 06:02:20 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 171EF20877
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=suse.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726899AbeJDMxz (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 4 Oct 2018 08:53:55 -0400
Received: from mx2.suse.de ([195.135.220.15]:54802 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726808AbeJDMxz (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 4 Oct 2018 08:53:55 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 23027B076
        for <linux-btrfs@vger.kernel.org>; Thu,  4 Oct 2018 06:02:17 +0000 (UTC)
From:   Qu Wenruo <wqu@suse.com>
To:     linux-btrfs@vger.kernel.org
Subject: [PATCH] btrfs-progs: image: Warn about log tree generation mismatch when restore
Date:   Thu,  4 Oct 2018 14:02:13 +0800
Message-Id: <20181004060213.13022-1-wqu@suse.com>
X-Mailer: git-send-email 2.19.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

At restore time, btrfs-image will try to fixup dev extents, this will
trigger a transaction.

It's normally OK to start a new transaction, but for image with log
tree, a new transaction will bump up generation, and log tree generation
will not match with super block generation + 1.

There is no good way to solve it yet. Just output a warning for now.

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 image/main.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/image/main.c b/image/main.c
index 351c5a256938..40fe406d8a33 100644
--- a/image/main.c
+++ b/image/main.c
@@ -2093,6 +2093,10 @@ static int fixup_devices(struct btrfs_fs_info *fs_info,
 	u64 devid, cur_devid;
 	int ret;
 
+	if (btrfs_super_log_root(fs_info->super_copy)) {
+		warning(
+		"log tree detected, log tree generation will be suspicious");
+	}
 	trans = btrfs_start_transaction(fs_info->tree_root, 1);
 	if (IS_ERR(trans)) {
 		error("cannot starting transaction %ld", PTR_ERR(trans));
-- 
2.19.0

