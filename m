Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:57759 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752234AbaJaSCZ (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 31 Oct 2014 14:02:25 -0400
From: Josef Bacik <jbacik@fb.com>
To: <dsterba@suse.cz>, <linux-btrfs@vger.kernel.org>
Subject: [PATCH 07/11] Btrfs-progs: add a message to know zero log ran successfully
Date: Fri, 31 Oct 2014 14:01:25 -0400
Message-ID: <1414778489-4049-8-git-send-email-jbacik@fb.com>
In-Reply-To: <1414778489-4049-1-git-send-email-jbacik@fb.com>
References: <1414778489-4049-1-git-send-email-jbacik@fb.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

If there are errors when opening the fs because of PARTIAL we could think that
the zero-log didn't actually work.  Add a printf so we know that it was
successfull.  Thanks,

Signed-off-by: Josef Bacik <jbacik@fb.com>
---
 btrfs-zero-log.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/btrfs-zero-log.c b/btrfs-zero-log.c
index 46c705c..4154175 100644
--- a/btrfs-zero-log.c
+++ b/btrfs-zero-log.c
@@ -71,6 +71,7 @@ int main(int ac, char **av)
 	btrfs_set_super_log_root_level(root->fs_info->super_copy, 0);
 	btrfs_commit_transaction(trans, root);
 	close_ctree(root);
+	printf("Log root zero'ed\n");
 out:
 	return !!ret;
 }
-- 
1.8.3.1

