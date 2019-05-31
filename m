Return-Path: <SRS0=YdAF=T7=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F08D9C04AB6
	for <linux-btrfs@archiver.kernel.org>; Fri, 31 May 2019 17:00:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D4A3C26CA5
	for <linux-btrfs@archiver.kernel.org>; Fri, 31 May 2019 17:00:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726853AbfEaRAi (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 31 May 2019 13:00:38 -0400
Received: from mx2.suse.de ([195.135.220.15]:60024 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726037AbfEaRAh (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 31 May 2019 13:00:37 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id BF9AAAD6F
        for <linux-btrfs@vger.kernel.org>; Fri, 31 May 2019 17:00:36 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 7470DDA85E; Fri, 31 May 2019 19:01:30 +0200 (CEST)
From:   David Sterba <dsterba@suse.com>
To:     linux-btrfs@vger.kernel.org
Cc:     David Sterba <dsterba@suse.com>
Subject: [PATCH 5/5] btrfs: assert bio list lock in merge_rbio
Date:   Fri, 31 May 2019 19:01:30 +0200
Message-Id: <5beec629c35c15acafe50c537491eb50f52b4348.1559321947.git.dsterba@suse.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <cover.1559321947.git.dsterba@suse.com>
References: <cover.1559321947.git.dsterba@suse.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Turn the comment about required lock into an assertion.

Signed-off-by: David Sterba <dsterba@suse.com>
---
 fs/btrfs/raid56.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/raid56.c b/fs/btrfs/raid56.c
index 67a6f7d47402..505979d867e0 100644
--- a/fs/btrfs/raid56.c
+++ b/fs/btrfs/raid56.c
@@ -310,12 +310,12 @@ static void steal_rbio(struct btrfs_raid_bio *src, struct btrfs_raid_bio *dest)
  * merging means we take the bio_list from the victim and
  * splice it into the destination.  The victim should
  * be discarded afterwards.
- *
- * must be called with dest->rbio_list_lock held
  */
 static void merge_rbio(struct btrfs_raid_bio *dest,
 		       struct btrfs_raid_bio *victim)
 {
+	lockdep_assert_held(&dest->bio_list_lock);
+
 	bio_list_merge(&dest->bio_list, &victim->bio_list);
 	dest->bio_list_bytes += victim->bio_list_bytes;
 	dest->generic_bio_cnt += victim->generic_bio_cnt;
-- 
2.21.0

