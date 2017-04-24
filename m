Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:39632 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1169234AbdDXL1g (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 24 Apr 2017 07:27:36 -0400
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.20/8.16.0.20) with SMTP id v3OBOE3U103658
        for <linux-btrfs@vger.kernel.org>; Mon, 24 Apr 2017 07:27:35 -0400
Received: from e13.ny.us.ibm.com (e13.ny.us.ibm.com [129.33.205.203])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2a02g36h99-1
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NOT)
        for <linux-btrfs@vger.kernel.org>; Mon, 24 Apr 2017 07:27:35 -0400
Received: from localhost
        by e13.ny.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-btrfs@vger.kernel.org> from <praveen@linux.vnet.ibm.com>;
        Mon, 24 Apr 2017 07:27:34 -0400
From: Praveen K Pandey <praveen@linux.vnet.ibm.com>
To: linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz, Praveen K Pandey <praveen@linux.vnet.ibm.com>
Subject: [PATCH] Btrfs-progs: run_next_block: Return error code when extent buffer read fails
Date: Mon, 24 Apr 2017 16:57:17 +0530
Message-Id: <1493033237-12979-1-git-send-email-praveen@linux.vnet.ibm.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

run_next_block() ignores the return value of read_tree_block() and
always returns success status. This might cause deal_root_from_list()
to loop infinitely when reading metadata block fails. This bug fixes
the issue by extracting and returning the error code from the return
value of read_tree_block().

Bug ID : https://bugzilla.kernel.org/show_bug.cgi?id=155551

Signed-off-by: Praveen K Pandey <praveen@linux.vnet.ibm.com>
---
 cmds-check.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/cmds-check.c b/cmds-check.c
index 17b7efb..40e3c99 100644
--- a/cmds-check.c
+++ b/cmds-check.c
@@ -7625,6 +7625,7 @@ static int run_next_block(struct btrfs_root *root,
 	if (!extent_buffer_uptodate(buf)) {
 		record_bad_block_io(root->fs_info,
 				    extent_cache, bytenr, size);
+		ret = PTR_ERR(buf);
 		goto out;
 	}
 
-- 
2.5.5

