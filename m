Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from nat-pool-rdu.redhat.com ([66.187.233.202]:46012 "EHLO
	bp-05.lab.msp.redhat.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S932572Ab3CDVkd (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 4 Mar 2013 16:40:33 -0500
From: Eric Sandeen <sandeen@redhat.com>
To: linux-btrfs@vger.kernel.org
Cc: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH 12/14] btrfs-progs: Issue warnings if ioctls fail in sigint handlers
Date: Mon,  4 Mar 2013 16:40:02 -0600
Message-Id: <1362436804-16766-13-git-send-email-sandeen@redhat.com>
In-Reply-To: <1362436804-16766-1-git-send-email-sandeen@redhat.com>
References: <1362436804-16766-1-git-send-email-sandeen@redhat.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The two sigint handlers issue ioctls to clean up, but if
they fail, noone would know.  I'm not sure there is
any other error handling to be done at this point, but a
notification seems wise.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---
 cmds-replace.c |    5 ++++-
 cmds-scrub.c   |    6 +++++-
 2 files changed, 9 insertions(+), 2 deletions(-)

diff --git a/cmds-replace.c b/cmds-replace.c
index 4cc32df..10030f6 100644
--- a/cmds-replace.c
+++ b/cmds-replace.c
@@ -77,10 +77,13 @@ static int is_numerical(const char *str)
 static int dev_replace_cancel_fd = -1;
 static void dev_replace_sigint_handler(int signal)
 {
+	int ret;
 	struct btrfs_ioctl_dev_replace_args args = {0};
 
 	args.cmd = BTRFS_IOCTL_DEV_REPLACE_CMD_CANCEL;
-	ioctl(dev_replace_cancel_fd, BTRFS_IOC_DEV_REPLACE, &args);
+	ret = ioctl(dev_replace_cancel_fd, BTRFS_IOC_DEV_REPLACE, &args);
+	if (ret < 0)
+		perror("Device replace cancel failed");
 }
 
 static int dev_replace_handle_sigint(int fd)
diff --git a/cmds-scrub.c b/cmds-scrub.c
index da4120f..f73b3c6 100644
--- a/cmds-scrub.c
+++ b/cmds-scrub.c
@@ -287,7 +287,11 @@ static void free_history(struct scrub_file_record **last_scrubs)
 static int cancel_fd = -1;
 static void scrub_sigint_record_progress(int signal)
 {
-	ioctl(cancel_fd, BTRFS_IOC_SCRUB_CANCEL, NULL);
+	int ret;
+
+	ret = ioctl(cancel_fd, BTRFS_IOC_SCRUB_CANCEL, NULL);
+	if (ret < 0)
+		perror("Scrub cancel failed\n");
 }
 
 static int scrub_handle_sigint_parent(void)
-- 
1.7.1

