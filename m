Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:38162 "EHLO
	mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752903AbaJaSCa (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 31 Oct 2014 14:02:30 -0400
From: Josef Bacik <jbacik@fb.com>
To: <dsterba@suse.cz>, <linux-btrfs@vger.kernel.org>
Subject: [PATCH 06/11] Btrfs-progs: make zero-log use partial open
Date: Fri, 31 Oct 2014 14:01:24 -0400
Message-ID: <1414778489-4049-7-git-send-email-jbacik@fb.com>
In-Reply-To: <1414778489-4049-1-git-send-email-jbacik@fb.com>
References: <1414778489-4049-1-git-send-email-jbacik@fb.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Because seriously, we only want to kill the tree log.  Thanks,

Signed-off-by: Josef Bacik <jbacik@fb.com>
---
 btrfs-zero-log.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/btrfs-zero-log.c b/btrfs-zero-log.c
index 88998e9..46c705c 100644
--- a/btrfs-zero-log.c
+++ b/btrfs-zero-log.c
@@ -61,7 +61,7 @@ int main(int ac, char **av)
 		goto out;
 	}
 
-	root = open_ctree(av[1], 0, OPEN_CTREE_WRITES);
+	root = open_ctree(av[1], 0, OPEN_CTREE_WRITES | OPEN_CTREE_PARTIAL);
 
 	if (root == NULL)
 		return 1;
-- 
1.8.3.1

