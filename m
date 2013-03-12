Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from dkim1.fusionio.com ([66.114.96.53]:50755 "EHLO
	dkim1.fusionio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933112Ab3CLRbL (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 12 Mar 2013 13:31:11 -0400
Received: from mx1.fusionio.com (unknown [10.101.1.160])
	by dkim1.fusionio.com (Postfix) with ESMTP id DDE947C04E9
	for <linux-btrfs@vger.kernel.org>; Tue, 12 Mar 2013 11:31:10 -0600 (MDT)
Received: from mail1.int.fusionio.com (mail1.int.fusionio.com [10.101.1.21]) by mx1.fusionio.com with ESMTP id aWTwMy4WQ5a4TNCJ (version=TLSv1 cipher=AES128-SHA bits=128 verify=NO) for <linux-btrfs@vger.kernel.org>; Tue, 12 Mar 2013 11:31:10 -0600 (MDT)
From: Josef Bacik <jbacik@fusionio.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH 03/10] Btrfs-progs: try other mirrors on read failure
Date: Tue, 12 Mar 2013 13:38:10 -0400
Message-ID: <1363109897-7931-4-git-send-email-jbacik@fusionio.com>
In-Reply-To: <1363109897-7931-1-git-send-email-jbacik@fusionio.com>
References: <1363109897-7931-1-git-send-email-jbacik@fusionio.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Josef Bacik <josef@redhat.com>

If we hit a bad disk and the read doesn't work, try other mirrors in case we
have other disks with good copies.  Thanks,

Signed-off-by: Josef Bacik <josef@redhat.com>
---
 cmds-restore.c |   13 ++++++++++---
 1 files changed, 10 insertions(+), 3 deletions(-)

diff --git a/cmds-restore.c b/cmds-restore.c
index 1d24691..617f507 100644
--- a/cmds-restore.c
+++ b/cmds-restore.c
@@ -245,9 +245,16 @@ again:
 
 	done = pread(dev_fd, inbuf+count, length, dev_bytenr);
 	if (done < length) {
-		ret = -1;
-		fprintf(stderr, "Short read %d\n", errno);
-		goto out;
+		num_copies = btrfs_num_copies(&root->fs_info->mapping_tree,
+					      bytenr, length);
+		mirror_num++;
+		if (mirror_num >= num_copies) {
+			ret = -1;
+			fprintf(stderr, "Exhausted mirrors trying to read\n");
+			goto out;
+		}
+		fprintf(stderr, "Trying another mirror\n");
+		goto again;
 	}
 
 	count += length;
-- 
1.7.7.6

