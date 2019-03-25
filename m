Return-Path: <SRS0=58CB=R4=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 72ED6C43381
	for <linux-btrfs@archiver.kernel.org>; Mon, 25 Mar 2019 14:52:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3BF6D20811
	for <linux-btrfs@archiver.kernel.org>; Mon, 25 Mar 2019 14:52:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728907AbfCYOwn (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 25 Mar 2019 10:52:43 -0400
Received: from mx2.suse.de ([195.135.220.15]:52842 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726203AbfCYOwn (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 25 Mar 2019 10:52:43 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 8803AAF2D;
        Mon, 25 Mar 2019 14:52:42 +0000 (UTC)
From:   Nikolay Borisov <nborisov@suse.com>
To:     guaneryu@gmail.com
Cc:     linux-btrfs@vger.kernel.org, fdmanana@suse.com,
        Nikolay Borisov <nborisov@suse.com>
Subject: [PATCH] fstests: Add missing call to _scratch_dev_pool_put
Date:   Mon, 25 Mar 2019 16:52:21 +0200
Message-Id: <20190325145221.12328-1-nborisov@suse.com>
X-Mailer: git-send-email 2.17.1
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Every call to _scratch_dev_pool_get must be paired with call to
_scratch_dev_pool_put otherwise the SCRATCH_POOL variable will have
less devices than it actually must.

Signed-off-by: Nikolay Borisov <nborisov@suse.com>
---
 tests/btrfs/148 | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/tests/btrfs/148 b/tests/btrfs/148
index 3fd8616f4b4a..55f76bc8af7e 100755
--- a/tests/btrfs/148
+++ b/tests/btrfs/148
@@ -66,5 +66,7 @@ test_direct_io_write "-m raid5 -d raid5"
 echo "Testing RAID6..."
 test_direct_io_write "-m raid6 -d raid6"
 
+_scratch_dev_pool_put
+
 status=0
 exit
-- 
2.7.4

