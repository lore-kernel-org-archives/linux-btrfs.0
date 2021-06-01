Return-Path: <linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 11D81C47080
	for <linux-btrfs@archiver.kernel.org>; Tue,  1 Jun 2021 06:08:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E394261376
	for <linux-btrfs@archiver.kernel.org>; Tue,  1 Jun 2021 06:08:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233002AbhFAGKJ (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 1 Jun 2021 02:10:09 -0400
Received: from smtp-out2.suse.de ([195.135.220.29]:51762 "EHLO
        smtp-out2.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232997AbhFAGKE (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Tue, 1 Jun 2021 02:10:04 -0400
Received: from imap.suse.de (imap-alt.suse-dmz.suse.de [192.168.254.47])
        (using TLSv1.2 with cipher ECDHE-ECDSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 3A8DF1FD2E;
        Tue,  1 Jun 2021 06:08:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1622527697; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
        bh=ZIb0+bnwl42+wgcTu9mk1WluAdBOJ9z/7tQgRJD2GLI=;
        b=eFOtWyP1+sAG6YbvCr7AsrGSlJuTuHlc2AyNn5pYMhnMzobwquQpEQqztsUmzGgBFxMSt4
        K3Cw9gDMS4tEowlGqXIQPlh4YMrU3WvdMOKsa8Hd1cIB9z3lE9xyxOlB7pM94outKTfmhr
        3Pe32ILwbbwAs5DJcuBQxAQPMBlfvOM=
Received: from imap3-int (imap-alt.suse-dmz.suse.de [192.168.254.47])
        by imap.suse.de (Postfix) with ESMTP id A0247118DD;
        Tue,  1 Jun 2021 06:08:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1622527696; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
        bh=ZIb0+bnwl42+wgcTu9mk1WluAdBOJ9z/7tQgRJD2GLI=;
        b=dB4XNA3oMiJeUSGtSLlXoWsFTlt87G6Qez7cdd96rE/TXRkgiBp08glziPdBpH2Y+c+FBz
        dr0WRjPKHyevnygiYY10uYZQlOaGiakPz2ZURiqlv3vLPYr6AXbIsEwSfHE0INpplke++W
        ofrtIITSskzpj6YNaiQKFlFrNMmt/jM=
Received: from director2.suse.de ([192.168.254.72])
        by imap3-int with ESMTPSA
        id dzlyJNDOtWAvegAALh3uQQ
        (envelope-from <nborisov@suse.com>); Tue, 01 Jun 2021 06:08:16 +0000
From:   Nikolay Borisov <nborisov@suse.com>
To:     linux-btrfs@vger.kernel.org
Cc:     Nikolay Borisov <nborisov@suse.com>, David Sterba <dsterba@suse.cz>
Subject: [PATCH] btrfs: Eliminate insert label in add_falloc_range
Date:   Tue,  1 Jun 2021 09:08:15 +0300
Message-Id: <20210601060815.148705-1-nborisov@suse.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Authentication-Results: imap.suse.de;
        none
X-Spamd-Result: default: False [4.00 / 100.00];
         ARC_NA(0.00)[];
         RCVD_VIA_SMTP_AUTH(0.00)[];
         FROM_HAS_DN(0.00)[];
         RCPT_COUNT_THREE(0.00)[3];
         TO_DN_SOME(0.00)[];
         TO_MATCH_ENVRCPT_ALL(0.00)[];
         MIME_GOOD(-0.10)[text/plain];
         R_MISSING_CHARSET(2.50)[];
         BROKEN_CONTENT_TYPE(1.50)[];
         DKIM_SIGNED(0.00)[suse.com:s=susede1];
         NEURAL_HAM_SHORT(-1.00)[-1.000];
         MID_CONTAINS_FROM(1.00)[];
         RCVD_NO_TLS_LAST(0.10)[];
         FROM_EQ_ENVFROM(0.00)[];
         MIME_TRACE(0.00)[0:+];
         RCVD_COUNT_TWO(0.00)[2]
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

By way of inverting the list_empty conditional the insert label can be
eliminated, making the function's flow entirely linear.

Signed-off-by: Nikolay Borisov <nborisov@suse.com>
Suggested-by: David Sterba <dsterba@suse.cz>
---
 fs/btrfs/file.c | 23 +++++++++++------------
 1 file changed, 11 insertions(+), 12 deletions(-)

diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
index 2b28a3daa5a9..dcd3fd64dde7 100644
--- a/fs/btrfs/file.c
+++ b/fs/btrfs/file.c
@@ -3036,19 +3036,18 @@ static int add_falloc_range(struct list_head *head, u64 start, u64 len)
 {
 	struct falloc_range *range = NULL;

-	if (list_empty(head))
-		goto insert;
-
-	/*
-	 * As fallocate iterate by bytenr order, we only need to check
-	 * the last range.
-	 */
-	range = list_last_entry(head, struct falloc_range, list);
-	if (range->start + range->len == start) {
-		range->len += len;
-		return 0;
+	if (!list_empty(head)) {
+		/*
+		 * As fallocate iterate by bytenr order, we only need to check
+		 * the last range.
+		 */
+		range = list_last_entry(head, struct falloc_range, list);
+		if (range->start + range->len == start) {
+			range->len += len;
+			return 0;
+		}
 	}
-insert:
+
 	range = kmalloc(sizeof(*range), GFP_KERNEL);
 	if (!range)
 		return -ENOMEM;
--
2.25.1

