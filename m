Return-Path: <SRS0=+rOy=PS=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C50A5C43387
	for <linux-btrfs@archiver.kernel.org>; Thu, 10 Jan 2019 06:14:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A18A620879
	for <linux-btrfs@archiver.kernel.org>; Thu, 10 Jan 2019 06:14:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727214AbfAJGO3 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 10 Jan 2019 01:14:29 -0500
Received: from mx2.suse.de ([195.135.220.15]:59786 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725536AbfAJGO2 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 10 Jan 2019 01:14:28 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 783E9AC4E;
        Thu, 10 Jan 2019 06:14:27 +0000 (UTC)
From:   Qu Wenruo <wqu@suse.com>
To:     linux-btrfs@vger.kernel.org, fstests@vger.kernel.org
Subject: [PATCH 1/2] fstests: btrfs: Make seed device test cases into their own group
Date:   Thu, 10 Jan 2019 14:14:14 +0800
Message-Id: <20190110061415.32045-1-wqu@suse.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

btrfs/16[123] are all seed device related test cases, make them into
'seed' group.

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 tests/btrfs/group | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/tests/btrfs/group b/tests/btrfs/group
index b78ed37fd9f1..04c0254aa4bf 100644
--- a/tests/btrfs/group
+++ b/tests/btrfs/group
@@ -163,9 +163,9 @@
 158 auto quick raid scrub
 159 auto quick punch log
 160 auto quick
-161 auto quick volume
-162 auto quick volume
-163 auto quick volume
+161 auto quick volume seed
+162 auto quick volume seed
+163 auto quick volume seed
 164 auto quick volume
 165 auto quick subvol
 166 auto quick qgroup
-- 
2.20.1

