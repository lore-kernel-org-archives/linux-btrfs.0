Return-Path: <SRS0=/x7k=OG=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 23635C43441
	for <linux-btrfs@archiver.kernel.org>; Tue, 27 Nov 2018 19:54:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E8E1A20663
	for <linux-btrfs@archiver.kernel.org>; Tue, 27 Nov 2018 19:54:13 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org E8E1A20663
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=suse.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726456AbeK1GxL (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 28 Nov 2018 01:53:11 -0500
Received: from mx2.suse.de ([195.135.220.15]:35296 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725764AbeK1GxL (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 28 Nov 2018 01:53:11 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 3ED1EAC3E
        for <linux-btrfs@vger.kernel.org>; Tue, 27 Nov 2018 19:54:11 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 20C10DAC3A; Tue, 27 Nov 2018 20:53:55 +0100 (CET)
From:   David Sterba <dsterba@suse.com>
To:     linux-btrfs@vger.kernel.org
Cc:     David Sterba <dsterba@suse.com>
Subject: [PATCH 7/9] btrfs: switch BTRFS_*_LOCK to enums
Date:   Tue, 27 Nov 2018 20:53:55 +0100
Message-Id: <5293feb9eb97fdaaa34db024ead13c5ec19234e3.1543348078.git.dsterba@suse.com>
X-Mailer: git-send-email 2.19.1
In-Reply-To: <cover.1543348078.git.dsterba@suse.com>
References: <cover.1543348078.git.dsterba@suse.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

We can use simple enum for values that are not part of on-disk format:
tree lock types.

Signed-off-by: David Sterba <dsterba@suse.com>
---
 fs/btrfs/locking.h | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/fs/btrfs/locking.h b/fs/btrfs/locking.h
index 29135def468e..684d0ef4faa4 100644
--- a/fs/btrfs/locking.h
+++ b/fs/btrfs/locking.h
@@ -6,10 +6,12 @@
 #ifndef BTRFS_LOCKING_H
 #define BTRFS_LOCKING_H
 
-#define BTRFS_WRITE_LOCK 1
-#define BTRFS_READ_LOCK 2
-#define BTRFS_WRITE_LOCK_BLOCKING 3
-#define BTRFS_READ_LOCK_BLOCKING 4
+enum {
+	BTRFS_WRITE_LOCK,
+	BTRFS_READ_LOCK,
+	BTRFS_WRITE_LOCK_BLOCKING,
+	BTRFS_READ_LOCK_BLOCKING,
+};
 
 void btrfs_tree_lock(struct extent_buffer *eb);
 void btrfs_tree_unlock(struct extent_buffer *eb);
-- 
2.19.1

