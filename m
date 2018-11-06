Return-Path: <SRS0=BJi/=NR=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.0 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 53FDEC32789
	for <linux-btrfs@archiver.kernel.org>; Tue,  6 Nov 2018 15:34:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1BDD52081D
	for <linux-btrfs@archiver.kernel.org>; Tue,  6 Nov 2018 15:34:47 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="ojzK8PIs"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 1BDD52081D
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388554AbeKGBAa (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 6 Nov 2018 20:00:30 -0500
Received: from mail.kernel.org ([198.145.29.99]:57286 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387480AbeKGBAa (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 6 Nov 2018 20:00:30 -0500
Received: from localhost.localdomain (bl8-197-74.dsl.telepac.pt [85.241.197.74])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0517A2081D;
        Tue,  6 Nov 2018 15:34:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1541518484;
        bh=Wx9HZyxWQp2WtHlKfcLEk58YP+MgaeG5aZHEN741srY=;
        h=From:To:Cc:Subject:Date:From;
        b=ojzK8PIsCE/gkPytBpBVKy6BafENMaKRLHX07yP+JgCM+01JIohxEw4ctESRsCba/
         s3sUy0u5I3vU7eUKHDkUVdADGC1zQO/2h3hth5xtihLdfQceN5GG0O/a47q25eeHmo
         JavAvw3XhwrhemxBm3hhyR6Gw7v0IpHqPn64YELY=
From:   fdmanana@kernel.org
To:     fstests@vger.kernel.org
Cc:     linux-btrfs@vger.kernel.org, Filipe Manana <fdmanana@suse.com>
Subject: [PATCH] btrfs: fix computation of max fs size for multiple device fs tests
Date:   Tue,  6 Nov 2018 15:34:37 +0000
Message-Id: <20181106153437.26870-1-fdmanana@kernel.org>
X-Mailer: git-send-email 2.11.0
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

From: Filipe Manana <fdmanana@suse.com>

We were sorting numerical values with the 'sort' tool without telling it
that we are sorting numbers, giving us unexpected ordering. So just pass
the '-n' option to the 'sort' tool.

Example:

$ echo -e "11\n9\n20" | sort
11
20
9

$ echo -e "11\n9\n20" | sort -n
9
11
20

Signed-off-by: Filipe Manana <fdmanana@suse.com>
---
 tests/btrfs/124 | 2 +-
 tests/btrfs/125 | 2 +-
 tests/btrfs/154 | 2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/tests/btrfs/124 b/tests/btrfs/124
index ce3ad6aa..a52c65f6 100755
--- a/tests/btrfs/124
+++ b/tests/btrfs/124
@@ -61,7 +61,7 @@ dev2=`echo $SCRATCH_DEV_POOL | awk '{print $2}'`
 dev1_sz=`blockdev --getsize64 $dev1`
 dev2_sz=`blockdev --getsize64 $dev2`
 # get min of both
-max_fs_sz=`echo -e "$dev1_sz\n$dev2_sz" | sort | head -1`
+max_fs_sz=`echo -e "$dev1_sz\n$dev2_sz" | sort -n | head -1`
 # Need disks with more than 2G.
 if [ $max_fs_sz -lt 2000000000 ]; then
 	_scratch_dev_pool_put
diff --git a/tests/btrfs/125 b/tests/btrfs/125
index e38de264..5ac68b67 100755
--- a/tests/btrfs/125
+++ b/tests/btrfs/125
@@ -68,7 +68,7 @@ dev2_sz=`blockdev --getsize64 $dev2`
 dev3_sz=`blockdev --getsize64 $dev3`
 
 # get min of both.
-max_fs_sz=`echo -e "$dev1_sz\n$dev2_sz\n$dev3_sz" | sort | head -1`
+max_fs_sz=`echo -e "$dev1_sz\n$dev2_sz\n$dev3_sz" | sort -n | head -1`
 # Need disks with more than 2G
 if [ $max_fs_sz -lt 2000000000 ]; then
 	_scratch_dev_pool_put
diff --git a/tests/btrfs/154 b/tests/btrfs/154
index 99ea232a..cd6c688f 100755
--- a/tests/btrfs/154
+++ b/tests/btrfs/154
@@ -51,7 +51,7 @@ DEV1_SZ=`blockdev --getsize64 $DEV1`
 DEV2_SZ=`blockdev --getsize64 $DEV2`
 
 # get min
-MAX_FS_SZ=`echo -e "$DEV1_SZ\n$DEV2_SZ" | sort | head -1`
+MAX_FS_SZ=`echo -e "$DEV1_SZ\n$DEV2_SZ" | sort -n | head -1`
 # Need disks with more than 2G
 if [ $MAX_FS_SZ -lt 2000000000 ]; then
 	_scratch_dev_pool_put
-- 
2.11.0

