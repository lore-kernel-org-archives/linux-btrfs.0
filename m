Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:29153 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753487Ab3JGVnP (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 7 Oct 2013 17:43:15 -0400
Received: from int-mx11.intmail.prod.int.phx2.redhat.com (int-mx11.intmail.prod.int.phx2.redhat.com [10.5.11.24])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id r97LhFFV031178
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Mon, 7 Oct 2013 17:43:15 -0400
From: Zach Brown <zab@redhat.com>
To: linux-btrfs@vger.kernel.org, Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH 02/12] btrfs-progs: check fopen failure in cmds-send
Date: Mon,  7 Oct 2013 14:42:55 -0700
Message-Id: <1381182185-10896-3-git-send-email-zab@redhat.com>
In-Reply-To: <1381182185-10896-1-git-send-email-zab@redhat.com>
References: <1381182185-10896-1-git-send-email-zab@redhat.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Check for fopen() failure.  This shows up in static analysis as a
possible null pointer derference.

Signed-off-by: Zach Brown <zab@redhat.com>
---
 cmds-send.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/cmds-send.c b/cmds-send.c
index 374d040..5f6ff86 100644
--- a/cmds-send.c
+++ b/cmds-send.c
@@ -72,6 +72,11 @@ int find_mount_root(const char *path, char **mount_root)
 	close(fd);
 
 	mnttab = fopen("/proc/mounts", "r");
+	if (!mnttab) {
+		close(fd);
+		return -errno;
+	}
+
 	while ((ent = getmntent(mnttab))) {
 		len = strlen(ent->mnt_dir);
 		if (strncmp(ent->mnt_dir, path, len) == 0) {
-- 
1.7.11.7

