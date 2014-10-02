Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:40592 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751906AbaJBRPl (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 2 Oct 2014 13:15:41 -0400
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
	by mx2.suse.de (Postfix) with ESMTP id E4F61AAF3
	for <linux-btrfs@vger.kernel.org>; Thu,  2 Oct 2014 17:15:39 +0000 (UTC)
From: David Sterba <dsterba@suse.cz>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.cz>
Subject: [PATCH] btrfs-progs: scrub, detect stale information in the status file
Date: Thu,  2 Oct 2014 19:15:38 +0200
Message-Id: <1412270138-24112-1-git-send-email-dsterba@suse.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

If scrub is not cancelled nor finished, the recorded status will prevent
scrub to start again though it's not running. There's a force option to
run it anyway, but this is just a bandaid and the true status of scrub
should be detected automatically. The force option should not be
necessary anymore.

The test introduced in 9681f82853360aac1ff2 checks only the status file,
not kernel status of scrub.

Signed-off-by: David Sterba <dsterba@suse.cz>
---
 cmds-scrub.c | 40 +++++++++++++++++++++++++++++++++++++++-
 1 file changed, 39 insertions(+), 1 deletion(-)

diff --git a/cmds-scrub.c b/cmds-scrub.c
index 731c5c94e6cc..eb50d8a65708 100644
--- a/cmds-scrub.c
+++ b/cmds-scrub.c
@@ -59,6 +59,7 @@ struct scrub_stats {
 	u64 duration;
 	u64 finished;
 	u64 canceled;
+	int in_progress;
 };
 
 /* TBD: replace with #include "linux/ioprio.h" in some years */
@@ -251,7 +252,11 @@ static void _print_scrub_ss(struct scrub_stats *ss)
 		printf(" and was aborted after %llu seconds\n",
 		       ss->duration);
 	} else {
-		printf(", running for %llu seconds\n", ss->duration);
+		if (ss->in_progress)
+			printf(", running for %llu seconds\n", ss->duration);
+		else
+			printf(", interrupted after %llu seconds, not running\n",
+					ss->duration);
 	}
 }
 
@@ -1057,6 +1062,28 @@ static int is_scrub_running_on_fs(struct btrfs_ioctl_fs_info_args *fi_args,
 	return 0;
 }
 
+static int is_scrub_running_in_kernel(int fd,
+		struct btrfs_ioctl_dev_info_args *di_args, u64 max_devices)
+{
+	struct scrub_progress sp;
+	int i;
+	int ret;
+
+	for (i = 0; i < max_devices; i++) {
+		memset(&sp, 0, sizeof(sp));
+		sp.scrub_args.devid = di_args[i].devid;
+		ret = ioctl(fd, BTRFS_IOC_SCRUB_PROGRESS, &sp.scrub_args);
+		if (ret < 0 && errno == ENODEV)
+			continue;
+		if (ret < 0 && errno == ENOTCONN)
+			return 0;
+		if (!ret)
+			return 1;
+	}
+
+	return 1;
+}
+
 static const char * const cmd_scrub_start_usage[];
 static const char * const cmd_scrub_resume_usage[];
 
@@ -1206,6 +1233,13 @@ static int scrub_start(int argc, char **argv, int resume)
 	}
 
 	/*
+	 * Check for stale information in the status file, ie. if it's
+	 * canceled=0, finished=0 but no scrub is running.
+	 */
+	if (!is_scrub_running_in_kernel(fdmnt, di_args, fi_args.num_devices))
+		force = 1;
+
+	/*
 	 * check whether any involved device is already busy running a
 	 * scrub. This would cause damaged status messages and the state
 	 * "aborted" without the explanation that a scrub was already
@@ -1636,6 +1670,7 @@ static int cmd_scrub_status(int argc, char **argv)
 	struct sockaddr_un addr = {
 		.sun_family = AF_UNIX,
 	};
+	int in_progress;
 	int ret;
 	int i;
 	int fdmnt;
@@ -1725,6 +1760,7 @@ static int cmd_scrub_status(int argc, char **argv)
 			fprintf(stderr, "WARNING: failed to read status: %s\n",
 				strerror(-PTR_ERR(past_scrubs)));
 	}
+	in_progress = is_scrub_running_in_kernel(fdmnt, di_args, fi_args.num_devices);
 
 	printf("scrub status for %s\n", fsid);
 
@@ -1737,6 +1773,7 @@ static int cmd_scrub_status(int argc, char **argv)
 						NULL, NULL);
 				continue;
 			}
+			last_scrub->stats.in_progress = in_progress;
 			print_scrub_dev(&di_args[i], &last_scrub->p, print_raw,
 					last_scrub->stats.finished ?
 							"history" : "status",
@@ -1744,6 +1781,7 @@ static int cmd_scrub_status(int argc, char **argv)
 		}
 	} else {
 		init_fs_stat(&fs_stat);
+		fs_stat.s.in_progress = in_progress;
 		for (i = 0; i < fi_args.num_devices; ++i) {
 			last_scrub = last_dev_scrub(past_scrubs,
 							di_args[i].devid);
-- 
2.1.1

