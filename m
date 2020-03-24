Return-Path: <SRS0=Vq+E=5J=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 57E9CC4332B
	for <linux-btrfs@archiver.kernel.org>; Tue, 24 Mar 2020 10:53:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2B8B120786
	for <linux-btrfs@archiver.kernel.org>; Tue, 24 Mar 2020 10:53:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727416AbgCXKxY (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 24 Mar 2020 06:53:24 -0400
Received: from mx2.suse.de ([195.135.220.15]:33708 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727314AbgCXKxX (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 24 Mar 2020 06:53:23 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id DC312AF39
        for <linux-btrfs@vger.kernel.org>; Tue, 24 Mar 2020 10:53:22 +0000 (UTC)
From:   Qu Wenruo <wqu@suse.com>
To:     linux-btrfs@vger.kernel.org
Subject: [PATCH 2/6] btrfs-progs: check/original: Fix uninitialized stack memory access for deal_root_from_list()
Date:   Tue, 24 Mar 2020 18:53:11 +0800
Message-Id: <20200324105315.136569-3-wqu@suse.com>
X-Mailer: git-send-email 2.25.2
In-Reply-To: <20200324105315.136569-1-wqu@suse.com>
References: <20200324105315.136569-1-wqu@suse.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

[BUG]
With valgrind, fsck/002 test with original mode would report the
following valgrind error:
  ==90600== Conditional jump or move depends on uninitialised value(s)
  ==90600==    at 0x15C280: pick_next_pending (main.c:4949)
  ==90600==    by 0x15F3CF: run_next_block (main.c:6175)
  ==90600==    by 0x1655CC: deal_root_from_list (main.c:8486)
  ==90600==    by 0x1660C7: check_chunks_and_extents (main.c:8762)
  ==90600==    by 0x166439: do_check_chunks_and_extents (main.c:8842)
  ==90600==    by 0x169D0B: cmd_check (main.c:10324)
  ==90600==    by 0x11CDC6: cmd_execute (commands.h:125)
  ==90600==    by 0x11D712: main (btrfs.c:386)

[CAUSE]
The problem happens like this:
deal_root_from_list(@list is empty)
|- stack @last is not initialized
|- while(!list_empty(list)) {} is skipped
|- run_next_block(&last);
   |- pick_next_pending(*last);
      |- node_start = last;

Since the stack @last is not initialized in deal_root_from_list(), the
final node_start = last assignment would just fetch the garbage from
stack.

[FIX]
Fix the problem by initializing @last to 0, as that's exactly what the
first while loop did.

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 check/main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/check/main.c b/check/main.c
index b56255bc10a8..d8181249e394 100644
--- a/check/main.c
+++ b/check/main.c
@@ -8442,7 +8442,7 @@ static int deal_root_from_list(struct list_head *list,
 			       struct device_extent_tree *dev_extent_cache)
 {
 	int ret = 0;
-	u64 last;
+	u64 last = 0;
 
 	while (!list_empty(list)) {
 		struct root_item_record *rec;
-- 
2.25.2

