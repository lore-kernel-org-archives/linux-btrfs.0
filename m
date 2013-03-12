Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from dkim1.fusionio.com ([66.114.96.53]:50763 "EHLO
	dkim1.fusionio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933155Ab3CLRbV (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 12 Mar 2013 13:31:21 -0400
Received: from mx2.fusionio.com (unknown [10.101.1.160])
	by dkim1.fusionio.com (Postfix) with ESMTP id 23B137C04E9
	for <linux-btrfs@vger.kernel.org>; Tue, 12 Mar 2013 11:31:21 -0600 (MDT)
Received: from mail1.int.fusionio.com (mail1.int.fusionio.com [10.101.1.21]) by mx2.fusionio.com with ESMTP id T5AfAGcuWpBMpBBC (version=TLSv1 cipher=AES128-SHA bits=128 verify=NO) for <linux-btrfs@vger.kernel.org>; Tue, 12 Mar 2013 11:31:20 -0600 (MDT)
From: Josef Bacik <jbacik@fusionio.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH 08/10] btrfs-progs: fix regexec to only work if we actually have a regexec
Date: Tue, 12 Mar 2013 13:38:15 -0400
Message-ID: <1363109897-7931-9-git-send-email-jbacik@fusionio.com>
In-Reply-To: <1363109897-7931-1-git-send-email-jbacik@fusionio.com>
References: <1363109897-7931-1-git-send-email-jbacik@fusionio.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Josef Bacik <josef@redhat.com>

We were unconditionally executing our regular expression, even though we may not
have one, so check to make sure mreg is not null before calling regexec.
Thanks,

Signed-off-by: Josef Bacik <josef@redhat.com>
---
 cmds-restore.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/cmds-restore.c b/cmds-restore.c
index 3e0ada2..7e99970 100644
--- a/cmds-restore.c
+++ b/cmds-restore.c
@@ -642,7 +642,7 @@ static int search_dir(struct btrfs_root *root, struct btrfs_key *key,
 		/* full path from root of btrfs being restored */
 		snprintf(fs_name, 4096, "%s/%s", dir, filename);
 
-		if (REG_NOMATCH == regexec(mreg, fs_name, 0, NULL, 0))
+		if (mreg && REG_NOMATCH == regexec(mreg, fs_name, 0, NULL, 0))
 			goto next;
 
 		/* full path from system root */
-- 
1.7.7.6

