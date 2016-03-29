Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:51009 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756368AbcC2O1s (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 29 Mar 2016 10:27:48 -0400
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Cc: clm@fb.com, dsterba@suse.cz
Subject: [PATCH 4/4] btrfs-progs: add global spare device list to filesystem show
Date: Tue, 29 Mar 2016 22:27:21 +0800
Message-Id: <1459261641-32254-4-git-send-email-anand.jain@oracle.com>
In-Reply-To: <1459261641-32254-1-git-send-email-anand.jain@oracle.com>
References: <1459261349-32206-1-git-send-email-anand.jain@oracle.com>
 <1459261641-32254-1-git-send-email-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This patch will add list of spare devices to the filesystem show
output, as show in the example below.

btrfs fi show
Label: none  uuid: 17f7d403-17d7-4f0a-b8ba-de673fdd3f56
	Total devices 2 FS bytes used 15.88MiB
	devid    1 size 2.00GiB used 417.50MiB path /dev/sdc
	devid    2 size 2.00GiB used 417.50MiB path /dev/sdd

Global spare
	device size 3.00GiB path /dev/sde

btrfs-progs v4.2.3-12-gb5f4b68

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
 cmds-filesystem.c | 5 +++++
 utils.h           | 1 +
 2 files changed, 6 insertions(+)

diff --git a/cmds-filesystem.c b/cmds-filesystem.c
index 0901c47e8679..78e5eba624dd 100644
--- a/cmds-filesystem.c
+++ b/cmds-filesystem.c
@@ -903,6 +903,11 @@ devs_only:
 					struct btrfs_fs_devices, list);
 		free_fs_devices(fs_devices);
 	}
+
+	if (where == -1 && search == NULL) {
+		ret = print_spare_device(unit_mode);
+		printf("\n");
+	}
 out:
 	free_seen_fsid();
 	return ret;
diff --git a/utils.h b/utils.h
index ff5966d11913..ea54692aca86 100644
--- a/utils.h
+++ b/utils.h
@@ -280,6 +280,7 @@ const char *get_argv0_buf(void);
 unsigned int get_unit_mode_from_arg(int *argc, char *argv[], int df_mode);
 void clean_args_no_options(int argc, char *argv[], const char * const *usage);
 int string_is_numerical(const char *str);
+int print_spare_device(unsigned unit_mode);
 
 __attribute__ ((format (printf, 1, 2)))
 static inline void warning(const char *fmt, ...)
-- 
2.7.0

