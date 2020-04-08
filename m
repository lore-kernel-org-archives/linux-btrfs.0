Return-Path: <SRS0=tPet=5Y=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 67079C2BA1A
	for <linux-btrfs@archiver.kernel.org>; Wed,  8 Apr 2020 10:36:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 339452082F
	for <linux-btrfs@archiver.kernel.org>; Wed,  8 Apr 2020 10:36:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1586342181;
	bh=6FSXzXkB2zdDHEGg/5jNKvB21ddsGbVwCdko3LS1A34=;
	h=From:To:Cc:Subject:Date:List-ID:From;
	b=KILMPVf0LVQaGbmHXzGYuI4n3YQKdrS9c+KM+abD2tefzPb4NRhcNqsXRZ26ZqEpc
	 D0BQcNL7dpqJj8htwdLrhnT+iEJpgzBTYrsOWMSmzbcfgBb+FMIJQ9SeR4zGC0Cf6p
	 hHcSqbDGuO/WQ85Mi76iURb9nfCY3tpwKmgjhCzE=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728214AbgDHKgU (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 8 Apr 2020 06:36:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:40576 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728209AbgDHKgU (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 8 Apr 2020 06:36:20 -0400
Received: from debian6.Home (bl8-197-74.dsl.telepac.pt [85.241.197.74])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5716F20753;
        Wed,  8 Apr 2020 10:36:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1586342180;
        bh=6FSXzXkB2zdDHEGg/5jNKvB21ddsGbVwCdko3LS1A34=;
        h=From:To:Cc:Subject:Date:From;
        b=vZgWRG2C38tZL9zRzxUKZ46RP6fzz8YnSDMAAQ9qwh9gQwUlTQT35s4ZrMAYdD0Jw
         THvzsojLY1Brrl31fVNBAVD6RryAJ9jAhm70NK2iYNpdy41ZzO2FysiQy6A0zg7jRf
         m847j5ItpWOUMin9HY/syad7GPwiS24mjJt0gTZE=
From:   fdmanana@kernel.org
To:     fstests@vger.kernel.org
Cc:     linux-btrfs@vger.kernel.org, Filipe Manana <fdmanana@suse.com>
Subject: [PATCH 3/4] fsx: fix infinite/too long loops when generating ranges for copy_file_range
Date:   Wed,  8 Apr 2020 11:36:16 +0100
Message-Id: <20200408103616.11458-1-fdmanana@kernel.org>
X-Mailer: git-send-email 2.11.0
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

From: Filipe Manana <fdmanana@suse.com>

While running generic/521 I've had fsx taking a lot of CPU time and not
making any progress for several hours. Attaching gdb to the fsx process
revealed that fsx was in the loop that generates the ranges for a
copy_file_range operation, in particular the loop seemed to never end
because the range defined by 'offset2' kept overlapping with the range
defined by 'offset'.
So far this happened one time only in one of my test VMs with generic/521.

Fix this by breaking out of the loop after trying 30 times, like we
currently do for dedupe operations, which results in logging the operation
as skipped.

Signed-off-by: Filipe Manana <fdmanana@suse.com>
---
 ltp/fsx.c | 30 +++++++++++++++++++-----------
 1 file changed, 19 insertions(+), 11 deletions(-)

diff --git a/ltp/fsx.c b/ltp/fsx.c
index 5949ebf0..89a5f60e 100644
--- a/ltp/fsx.c
+++ b/ltp/fsx.c
@@ -2042,17 +2042,25 @@ test(void)
 			break;
 		}
 	case OP_COPY_RANGE:
-		TRIM_OFF_LEN(offset, size, file_size);
-		offset -= offset % readbdy;
-		if (o_direct)
-			size -= size % readbdy;
-		do {
-			offset2 = random();
-			TRIM_OFF(offset2, maxfilelen);
-			offset2 -= offset2 % writebdy;
-		} while (range_overlaps(offset, offset2, size) ||
-			 offset2 + size > maxfilelen);
-		break;
+		{
+			int tries = 0;
+
+			TRIM_OFF_LEN(offset, size, file_size);
+			offset -= offset % readbdy;
+			if (o_direct)
+				size -= size % readbdy;
+			do {
+				if (tries++ >= 30) {
+					size = 0;
+					break;
+				}
+				offset2 = random();
+				TRIM_OFF(offset2, maxfilelen);
+				offset2 -= offset2 % writebdy;
+			} while (range_overlaps(offset, offset2, size) ||
+				 offset2 + size > maxfilelen);
+			break;
+		}
 	}
 
 have_op:
-- 
2.11.0

