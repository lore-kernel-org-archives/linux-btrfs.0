Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from nat-pool-rdu.redhat.com ([66.187.233.202]:49498 "EHLO
	bp-05.lab.msp.redhat.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S932228Ab3CDVkb (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 4 Mar 2013 16:40:31 -0500
From: Eric Sandeen <sandeen@redhat.com>
To: linux-btrfs@vger.kernel.org
Cc: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH 01/14] btrfs-progs: close fd on cmd_subvol_list return
Date: Mon,  4 Mar 2013 16:39:51 -0600
Message-Id: <1362436804-16766-2-git-send-email-sandeen@redhat.com>
In-Reply-To: <1362436804-16766-1-git-send-email-sandeen@redhat.com>
References: <1362436804-16766-1-git-send-email-sandeen@redhat.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

stops an fd leak that Coverity found.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---
 cmds-subvolume.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/cmds-subvolume.c b/cmds-subvolume.c
index 461eed9..a13a58d 100644
--- a/cmds-subvolume.c
+++ b/cmds-subvolume.c
@@ -464,6 +464,8 @@ static int cmd_subvol_list(int argc, char **argv)
 				!is_list_all && !is_only_in_path, NULL);
 
 out:
+	if (fd != -1)
+		close(fd);
 	if (filter_set)
 		btrfs_list_free_filter_set(filter_set);
 	if (comparer_set)
-- 
1.7.1

