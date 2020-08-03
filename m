Return-Path: <SRS0=qeAP=BN=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.0 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EAD36C433E0
	for <linux-btrfs@archiver.kernel.org>; Mon,  3 Aug 2020 20:29:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F27392086A
	for <linux-btrfs@archiver.kernel.org>; Mon,  3 Aug 2020 20:29:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727995AbgHCU3b (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 3 Aug 2020 16:29:31 -0400
Received: from mx2.suse.de ([195.135.220.15]:50448 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727831AbgHCU3a (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 3 Aug 2020 16:29:30 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 39649ADE0;
        Mon,  3 Aug 2020 20:29:44 +0000 (UTC)
From:   Goldwyn Rodrigues <rgoldwyn@suse.de>
To:     linux-btrfs@vger.kernel.org
Cc:     Goldwyn Rodrigues <rgoldwyn@suse.com>
Subject: [PATCH 3/3] btrfs: add more information for balance
Date:   Mon,  3 Aug 2020 15:29:12 -0500
Message-Id: <20200803202913.15913-4-rgoldwyn@suse.de>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200803202913.15913-1-rgoldwyn@suse.de>
References: <20200803202913.15913-1-rgoldwyn@suse.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

From: Goldwyn Rodrigues <rgoldwyn@suse.com>

Include information about the state of the balance and expected,
considered and completed statistics.

Q: I am not sure of the cancelled state, and stopping seemed more
appropriate since it was a transient state to cancelling the operation.
Would you prefer to call it cancelled?

This information is not used by user space as of now. We could use it
for "btrfs balance status" or ignore this patch for inclusion at all.

Signed-off-by: Goldwyn Rodrigues <rgoldwyn@suse.com>
---
 fs/btrfs/sysfs.c | 29 ++++++++++++++++++++++++++++-
 1 file changed, 28 insertions(+), 1 deletion(-)

diff --git a/fs/btrfs/sysfs.c b/fs/btrfs/sysfs.c
index 71950c121588..001a7ae375d0 100644
--- a/fs/btrfs/sysfs.c
+++ b/fs/btrfs/sysfs.c
@@ -808,6 +808,33 @@ static ssize_t btrfs_checksum_show(struct kobject *kobj,
 
 BTRFS_ATTR(, checksum, btrfs_checksum_show);
 
+static ssize_t btrfs_balance_show(struct btrfs_fs_info *fs_info, char *buf)
+{
+	ssize_t ret = 0;
+	struct btrfs_balance_control *bctl;
+
+	ret += scnprintf(buf, PAGE_SIZE, "balance\n");
+	spin_lock(&fs_info->balance_lock);
+	bctl = fs_info->balance_ctl;
+	if (!bctl) {
+		ret += scnprintf(buf + ret, PAGE_SIZE - ret,
+				"State: stopping\n");
+		goto out;
+	}
+	if (test_bit(BTRFS_FS_BALANCE_RUNNING, &fs_info->flags))
+		ret += scnprintf(buf + ret, PAGE_SIZE - ret,
+				"State: running\n");
+	else
+		ret += scnprintf(buf + ret, PAGE_SIZE - ret,
+				"State: paused\n");
+	ret += scnprintf(buf + ret, PAGE_SIZE - ret, "%llu %llu %llu\n",
+			bctl->stat.expected, bctl->stat.considered,
+			bctl->stat.completed);
+out:
+	spin_unlock(&fs_info->balance_lock);
+	return ret;
+}
+
 static ssize_t btrfs_exclusive_operation_show(struct kobject *kobj,
 		struct kobj_attribute *a, char *buf)
 {
@@ -816,7 +843,7 @@ static ssize_t btrfs_exclusive_operation_show(struct kobject *kobj,
 		case  BTRFS_EXCLOP_NONE:
 			return scnprintf(buf, PAGE_SIZE, "none\n");
 		case BTRFS_EXCLOP_BALANCE:
-			return scnprintf(buf, PAGE_SIZE, "balance\n");
+			return btrfs_balance_show(fs_info, buf);
 		case BTRFS_EXCLOP_DEV_ADD:
 			return scnprintf(buf, PAGE_SIZE, "device add\n");
 		case BTRFS_EXCLOP_DEV_REPLACE:
-- 
2.26.2

