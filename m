Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from nat-pool-rdu.redhat.com ([66.187.233.202]:32826 "EHLO
	bp-05.lab.msp.redhat.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754763Ab3CKWN3 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 11 Mar 2013 18:13:29 -0400
From: Eric Sandeen <sandeen@redhat.com>
To: linux-btrfs@vger.kernel.org
Cc: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH 1/4] btrfs-progs: close fd on return from label get/set functions
Date: Mon, 11 Mar 2013 18:12:58 -0500
Message-Id: <1363043581-15812-2-git-send-email-sandeen@redhat.com>
In-Reply-To: <1363043581-15812-1-git-send-email-sandeen@redhat.com>
References: <1363043581-15812-1-git-send-email-sandeen@redhat.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Somehow missed these 2 in the last round.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---
 utils.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/utils.c b/utils.c
index f68436d..1c73d67 100644
--- a/utils.c
+++ b/utils.c
@@ -1217,6 +1217,7 @@ static int set_label_mounted(const char *mount_path, const char *label)
 		return -1;
 	}
 
+	close(fd);
 	return 0;
 }
 
@@ -1274,6 +1275,7 @@ static int get_label_mounted(const char *mount_path)
 	}
 
 	fprintf(stdout, "%s\n", label);
+	close(fd);
 	return 0;
 }
 
-- 
1.7.1

