Return-Path: <SRS0=6jfg=QB=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.2 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E59BEC282C0
	for <linux-btrfs@archiver.kernel.org>; Fri, 25 Jan 2019 11:46:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A6CF7218E2
	for <linux-btrfs@archiver.kernel.org>; Fri, 25 Jan 2019 11:46:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1548416779;
	bh=WVISnRyPSf4/WjTzoCWRwHHPNhb2ygaN9avb4Q/gSl0=;
	h=From:To:Cc:Subject:Date:List-ID:From;
	b=Rz54/B00p0hjeSlIabmedDeFh7vEwVMNwLqrUQB+mSP1MvqIjAZSQ/a4lTfJsMRgm
	 2WeQFGne7MZh/BplyHVJ/9fDS9vHx/liRcNux42mLcwqVN9vFLlWqfz/dpwXOOant1
	 1SA7fp/JDULvm7fLpq82VXEyQS2mvM4jaNuwKCgs=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726885AbfAYLqT (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 25 Jan 2019 06:46:19 -0500
Received: from mail.kernel.org ([198.145.29.99]:53858 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726026AbfAYLqS (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 25 Jan 2019 06:46:18 -0500
Received: from localhost.localdomain (bl8-197-74.dsl.telepac.pt [85.241.197.74])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 72780218CD;
        Fri, 25 Jan 2019 11:46:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1548416778;
        bh=WVISnRyPSf4/WjTzoCWRwHHPNhb2ygaN9avb4Q/gSl0=;
        h=From:To:Cc:Subject:Date:From;
        b=sG6T7HJwQ6ucITM5/VbcY3tLrmepf8fCA4PXDoCEn+HQ/4m9UQZy7vYauCsOCLyiZ
         Kud3cfcFmmsTpTNcGbnHzyQH0XqIa9/Z0w17y/cWvzlDvX+7pFSYnJfVRmxwbqxkkZ
         4q/at7Du/FRx0J0/SuBrVc2py0LWjP+AgG/NTIeA=
From:   fdmanana@kernel.org
To:     fstests@vger.kernel.org
Cc:     linux-btrfs@vger.kernel.org, Filipe Manana <fdmanana@suse.com>
Subject: [PATCH 1/2] fstests: btrfs/081 declare local variables as local
Date:   Fri, 25 Jan 2019 11:46:11 +0000
Message-Id: <20190125114611.3954-1-fdmanana@kernel.org>
X-Mailer: git-send-email 2.11.0
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

From: Filipe Manana <fdmanana@suse.com>

Some variables inside the test's functions were used as local but were not
being declared as such. Add the local declaration for them.

Signed-off-by: Filipe Manana <fdmanana@suse.com>
---
 tests/btrfs/081 | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/tests/btrfs/081 b/tests/btrfs/081
index dc357e53..7e83525f 100755
--- a/tests/btrfs/081
+++ b/tests/btrfs/081
@@ -45,7 +45,7 @@ extent_size=8192
 
 create_source_file()
 {
-	name=$1
+	local name=$1
 
 	# Create a file with $num_extents extents, each with a size of
 	# $extent_size bytes.
@@ -60,8 +60,8 @@ create_source_file()
 
 create_target_file()
 {
-	name=$1
-	file_size=$(($num_extents * $extent_size))
+	local name=$1
+	local file_size=$(($num_extents * $extent_size))
 
 	$XFS_IO_PROG -f -c "pwrite -S 0xff 0 $file_size" \
 		-c "fsync" $SCRATCH_MNT/$name | _filter_xfs_io
@@ -69,7 +69,7 @@ create_target_file()
 
 reader_loop()
 {
-	name=$1
+	local name=$1
 
 	while true; do
 		cat $SCRATCH_MNT/$name > /dev/null
-- 
2.11.0

