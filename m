Return-Path: <SRS0=2j5R=MU=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BBEC9C00449
	for <linux-btrfs@archiver.kernel.org>; Mon,  8 Oct 2018 07:00:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8AF5D20878
	for <linux-btrfs@archiver.kernel.org>; Mon,  8 Oct 2018 07:00:37 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 8AF5D20878
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=suse.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726977AbeJHOKt (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 8 Oct 2018 10:10:49 -0400
Received: from mx2.suse.de ([195.135.220.15]:35666 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726874AbeJHOKt (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 8 Oct 2018 10:10:49 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 86CDEAEBA
        for <linux-btrfs@vger.kernel.org>; Mon,  8 Oct 2018 07:00:34 +0000 (UTC)
From:   Qu Wenruo <wqu@suse.com>
To:     linux-btrfs@vger.kernel.org
Subject: [PATCH 3/5] btrfs-progs: lowmem check: Add dev_item check for used bytes and total bytes
Date:   Mon,  8 Oct 2018 15:00:23 +0800
Message-Id: <20181008070025.27035-4-wqu@suse.com>
X-Mailer: git-send-email 2.19.0
In-Reply-To: <20181008070025.27035-1-wqu@suse.com>
References: <20181008070025.27035-1-wqu@suse.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Obviously, used bytes can't be larger than total bytes.

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 check/mode-lowmem.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/check/mode-lowmem.c b/check/mode-lowmem.c
index d387423639e6..c50e34236ac8 100644
--- a/check/mode-lowmem.c
+++ b/check/mode-lowmem.c
@@ -4074,6 +4074,11 @@ static int check_dev_item(struct btrfs_fs_info *fs_info,
 	used = btrfs_device_bytes_used(eb, dev_item);
 	total_bytes = btrfs_device_total_bytes(eb, dev_item);
 
+	if (used > total_bytes) {
+		error("device %llu has incorrect used bytes %llu > total bytes %llu",
+			dev_id, used, total_bytes);
+		return ACCOUNTING_MISMATCH;
+	}
 	key.objectid = dev_id;
 	key.type = BTRFS_DEV_EXTENT_KEY;
 	key.offset = 0;
-- 
2.19.0

