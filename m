Return-Path: <SRS0=/x7k=OG=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 48FA8C43441
	for <linux-btrfs@archiver.kernel.org>; Tue, 27 Nov 2018 19:54:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0EE5720873
	for <linux-btrfs@archiver.kernel.org>; Tue, 27 Nov 2018 19:54:09 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 0EE5720873
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=suse.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726402AbeK1GxH (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 28 Nov 2018 01:53:07 -0500
Received: from mx2.suse.de ([195.135.220.15]:35258 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725764AbeK1GxG (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 28 Nov 2018 01:53:06 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay1.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 75738AC3E
        for <linux-btrfs@vger.kernel.org>; Tue, 27 Nov 2018 19:54:06 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 669A4DAC3A; Tue, 27 Nov 2018 20:53:50 +0100 (CET)
From:   David Sterba <dsterba@suse.com>
To:     linux-btrfs@vger.kernel.org
Cc:     David Sterba <dsterba@suse.com>
Subject: [PATCH 5/9] btrfs: swtich EXTENT_BUFFER_* to enums
Date:   Tue, 27 Nov 2018 20:53:50 +0100
Message-Id: <132de3b38834a3703cc9cebe56e7de8dcbcec1c9.1543348078.git.dsterba@suse.com>
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
extent buffer flags;

Signed-off-by: David Sterba <dsterba@suse.com>
---
 fs/btrfs/extent_io.h | 28 ++++++++++++++++------------
 1 file changed, 16 insertions(+), 12 deletions(-)

diff --git a/fs/btrfs/extent_io.h b/fs/btrfs/extent_io.h
index a1d3ea5a0d32..fd42492e62e5 100644
--- a/fs/btrfs/extent_io.h
+++ b/fs/btrfs/extent_io.h
@@ -37,18 +37,22 @@
 #define EXTENT_BIO_COMPRESSED 1
 #define EXTENT_BIO_FLAG_SHIFT 16
 
-/* these are bit numbers for test/set bit */
-#define EXTENT_BUFFER_UPTODATE 0
-#define EXTENT_BUFFER_DIRTY 2
-#define EXTENT_BUFFER_CORRUPT 3
-#define EXTENT_BUFFER_READAHEAD 4	/* this got triggered by readahead */
-#define EXTENT_BUFFER_TREE_REF 5
-#define EXTENT_BUFFER_STALE 6
-#define EXTENT_BUFFER_WRITEBACK 7
-#define EXTENT_BUFFER_READ_ERR 8        /* read IO error */
-#define EXTENT_BUFFER_UNMAPPED 9
-#define EXTENT_BUFFER_IN_TREE 10
-#define EXTENT_BUFFER_WRITE_ERR 11    /* write IO error */
+enum {
+	EXTENT_BUFFER_UPTODATE,
+	EXTENT_BUFFER_DIRTY,
+	EXTENT_BUFFER_CORRUPT,
+	/* this got triggered by readahead */
+	EXTENT_BUFFER_READAHEAD,
+	EXTENT_BUFFER_TREE_REF,
+	EXTENT_BUFFER_STALE,
+	EXTENT_BUFFER_WRITEBACK,
+	/* read IO error */
+	EXTENT_BUFFER_READ_ERR,
+	EXTENT_BUFFER_UNMAPPED,
+	EXTENT_BUFFER_IN_TREE,
+	/* write IO error */
+	EXTENT_BUFFER_WRITE_ERR,
+};
 
 /* these are flags for __process_pages_contig */
 #define PAGE_UNLOCK		(1 << 0)
-- 
2.19.1

