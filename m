Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:50007 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758788Ab3CDWfn (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 4 Mar 2013 17:35:43 -0500
Received: from int-mx11.intmail.prod.int.phx2.redhat.com (int-mx11.intmail.prod.int.phx2.redhat.com [10.5.11.24])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id r24MZhHC029801
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Mon, 4 Mar 2013 17:35:43 -0500
Message-ID: <513521BE.1030101@redhat.com>
Date: Mon, 04 Mar 2013 16:35:42 -0600
From: Eric Sandeen <sandeen@redhat.com>
MIME-Version: 1.0
To: Eric Sandeen <sandeen@redhat.com>
CC: linux-btrfs@vger.kernel.org
Subject: [PATCH 12/14 V2] btrfs-progs: Issue warnings if ioctls fail in sigint
 handlers
References: <1362436804-16766-1-git-send-email-sandeen@redhat.com> <1362436804-16766-13-git-send-email-sandeen@redhat.com>
In-Reply-To: <1362436804-16766-13-git-send-email-sandeen@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
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
+		perror("Scrub cancel failed");
 }
 
 static int scrub_handle_sigint_parent(void)

