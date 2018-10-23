Return-Path: <SRS0=XNjG=ND=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9BA6DC67863
	for <linux-btrfs@archiver.kernel.org>; Tue, 23 Oct 2018 09:34:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7356320665
	for <linux-btrfs@archiver.kernel.org>; Tue, 23 Oct 2018 09:34:41 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 7356320665
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=cn.fujitsu.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728592AbeJWR5P (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 23 Oct 2018 13:57:15 -0400
Received: from mail.cn.fujitsu.com ([183.91.158.132]:2023 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728020AbeJWR5P (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 23 Oct 2018 13:57:15 -0400
X-IronPort-AV: E=Sophos;i="5.43,368,1503331200"; 
   d="scan'208";a="46602826"
Received: from unknown (HELO cn.fujitsu.com) ([10.167.33.5])
  by heian.cn.fujitsu.com with ESMTP; 23 Oct 2018 17:34:36 +0800
Received: from G08CNEXCHPEKD01.g08.fujitsu.local (unknown [10.167.33.80])
        by cn.fujitsu.com (Postfix) with ESMTP id 992164B710FF
        for <linux-btrfs@vger.kernel.org>; Tue, 23 Oct 2018 17:34:37 +0800 (CST)
Received: from archlinux.g08.fujitsu.local (10.167.226.24) by
 G08CNEXCHPEKD01.g08.fujitsu.local (10.167.33.89) with Microsoft SMTP Server
 (TLS) id 14.3.408.0; Tue, 23 Oct 2018 17:34:43 +0800
From:   Su Yue <suy.fnst@cn.fujitsu.com>
To:     <linux-btrfs@vger.kernel.org>
CC:     <suy.fnst@cn.fujitsu.com>, Lu Fengqi <lufq.fnst@cn.fujitsu.com>
Subject: [PATCH 04/13] btrfs-progs: lowmem: fix false alert about the existence of gaps in the check_file_extent
Date:   Tue, 23 Oct 2018 17:41:38 +0800
Message-ID: <20181023094147.7906-5-suy.fnst@cn.fujitsu.com>
X-Mailer: git-send-email 2.19.1
In-Reply-To: <20181023094147.7906-1-suy.fnst@cn.fujitsu.com>
References: <20181023094147.7906-1-suy.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.167.226.24]
X-yoursite-MailScanner-ID: 992164B710FF.A8CCF
X-yoursite-MailScanner: Found to be clean
X-yoursite-MailScanner-From: suy.fnst@cn.fujitsu.com
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

From: Lu Fengqi <lufq.fnst@cn.fujitsu.com>

The 'end' parameter of check_file_extent tracks the ending offset of the
last checked extent. This is used to detect gaps between adjacent extents.

Currently such gaps are wrongly detected since for regular extents only
the size of the extent is added to the 'end' parameter. This results in
wrongly considering all extents of a file as having gaps between them
when only 2 of them really have a gap as seen in the example below.

Solution:
The extent_end variable should set to the sum of the offset and the
extent_num_bytes of the file extent.

Example:
Suppose that lowmem check the following file extent of inode 257.

        item 6 key (257 EXTENT_DATA 0) itemoff 15813 itemsize 53
                generation 6 type 1 (regular)
                extent data disk byte 13631488 nr 4096
                extent data offset 0 nr 4096 ram 4096
                extent compression 0 (none)
        item 7 key (257 EXTENT_DATA 8192) itemoff 15760 itemsize 53
                generation 6 type 1 (regular)
                extent data disk byte 13631488 nr 4096
                extent data offset 0 nr 4096 ram 4096
                extent compression 0 (none)
        item 8 key (257 EXTENT_DATA 12288) itemoff 15707 itemsize 53
                generation 6 type 1 (regular)
                extent data disk byte 13631488 nr 4096
                extent data offset 0 nr 4096 ram 4096
                extent compression 0 (none)

For inode 257, check_inode_item set extent_end to 0, then call
check_file_extent to check item {6,7,8}.
item 6)
	offset(0) == extent_end(0)
	extent_end = extent_end(0) + extent_num_bytes(4096)
item 7)
	offset(8192) != extent_end(4096)
	extent_end = extent_end(4096) + extent_num_bytes(4096)
			^^^
	The old extent_end should replace by offset(8192).
item 8)
	offset(12288) != extent_end(8192)
		^^^
	But there is no gap between item {7,8}.

Fixes: d88da10ddd42 ("btrfs-progs: check: introduce function to check file extent")
Signed-off-by: Lu Fengqi <lufq.fnst@cn.fujitsu.com>
---
 check/mode-lowmem.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/check/mode-lowmem.c b/check/mode-lowmem.c
index 769b3141de8b..35fe1adf58e6 100644
--- a/check/mode-lowmem.c
+++ b/check/mode-lowmem.c
@@ -1985,7 +1985,7 @@ static int check_file_extent(struct btrfs_root *root, struct btrfs_path *path,
 		}
 	}
 
-	*end += extent_num_bytes;
+	*end = fkey.offset + extent_num_bytes;
 	if (!is_hole)
 		*size += extent_num_bytes;
 
-- 
2.19.1



