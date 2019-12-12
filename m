Return-Path: <SRS0=2F5/=2C=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 43B72C2D0C9
	for <linux-btrfs@archiver.kernel.org>; Thu, 12 Dec 2019 07:45:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 25AAE2173E
	for <linux-btrfs@archiver.kernel.org>; Thu, 12 Dec 2019 07:45:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728122AbfLLHpr (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 12 Dec 2019 02:45:47 -0500
Received: from mx2.suse.de ([195.135.220.15]:36494 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728095AbfLLHpr (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 12 Dec 2019 02:45:47 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 1BB85AB9B;
        Thu, 12 Dec 2019 07:45:46 +0000 (UTC)
From:   Johannes Thumshirn <jthumshirn@suse.de>
To:     fstests@vger.kernel.org
Cc:     Linux BTRFS Mailinglist <linux-btrfs@vger.kernel.org>,
        jth@kernel.org, Johannes Thumshirn <jthumshirn@suse.de>,
        Filipe Manana <fdmanana@suse.com>
Subject: [PATCH fstests] btrfs/187: require 8GB scratch dev
Date:   Thu, 12 Dec 2019 08:45:43 +0100
Message-Id: <20191212074543.30628-1-jthumshirn@suse.de>
X-Mailer: git-send-email 2.16.4
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

In my testing on 1GB zram devices btrfs/187 usually fails with ENOSPC.

Add a requirement for 8GB scratch devices (empirically measured).

Cc: Filipe Manana <fdmanana@suse.com>
Signed-off-by: Johannes Thumshirn <jthumshirn@suse.de>
---
 tests/btrfs/187 | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/tests/btrfs/187 b/tests/btrfs/187
index 0744797ecc33..a604690a41b2 100755
--- a/tests/btrfs/187
+++ b/tests/btrfs/187
@@ -39,6 +39,9 @@ _require_attrs
 
 rm -f $seqres.full
 
+# We at least need 8GB of free space on $SCRATCH_DEV
+_require_scratch_size $((8 * 1024 * 1024))
+
 _scratch_mkfs >>$seqres.full 2>&1
 _scratch_mount
 
-- 
2.16.4

