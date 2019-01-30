Return-Path: <SRS0=cBAG=QG=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A0106C282D9
	for <linux-btrfs@archiver.kernel.org>; Wed, 30 Jan 2019 14:51:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 78A5220882
	for <linux-btrfs@archiver.kernel.org>; Wed, 30 Jan 2019 14:51:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731447AbfA3OvJ (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 30 Jan 2019 09:51:09 -0500
Received: from mx2.suse.de ([195.135.220.15]:38136 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1731424AbfA3OvI (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 30 Jan 2019 09:51:08 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 8BD63B079
        for <linux-btrfs@vger.kernel.org>; Wed, 30 Jan 2019 14:51:06 +0000 (UTC)
From:   Nikolay Borisov <nborisov@suse.com>
To:     linux-btrfs@vger.kernel.org
Cc:     jeffm@suse.com, Nikolay Borisov <nborisov@suse.com>
Subject: [PATCH 08/15] btrfs: Introduce new bits for device allocation tree
Date:   Wed, 30 Jan 2019 16:50:55 +0200
Message-Id: <20190130145102.4708-9-nborisov@suse.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190130145102.4708-1-nborisov@suse.com>
References: <20190130145102.4708-1-nborisov@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Rather than hijacking the existing defines let's just define new bits,
with more descriptive names. Instead of using yet more (currently at 18)
bits for the new flags, use the fact those flags will be specific to
the device allocation tree so define them using existing EXTENT_* flags.

Signed-off-by: Nikolay Borisov <nborisov@suse.com>
---
 fs/btrfs/extent_io.h | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/fs/btrfs/extent_io.h b/fs/btrfs/extent_io.h
index d7beb2b3bc7d..af7e00a3678c 100644
--- a/fs/btrfs/extent_io.h
+++ b/fs/btrfs/extent_io.h
@@ -29,6 +29,10 @@
 				 EXTENT_CLEAR_DATA_RESV)
 #define EXTENT_CTLBITS		(EXTENT_DO_ACCOUNTING)
 
+
+/* Redefined bits above which are used only in the device allocation tree */
+#define CHUNK_ALLOCATED EXTENT_DIRTY
+
 /*
  * flags for bio submission. The high bits indicate the compression
  * type for this bio
-- 
2.17.1

