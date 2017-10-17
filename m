Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from prv3-mh.provo.novell.com ([137.65.250.26]:50723 "EHLO
        prv3-mh.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934666AbdJQJNV (ORCPT
        <rfc822;groupwise-linux-btrfs@vger.kernel.org:0:0>);
        Tue, 17 Oct 2017 05:13:21 -0400
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz
Subject: [PATCH v2 3/6] btrfs-progs: rescue: Introduce fix-device-size
Date: Tue, 17 Oct 2017 17:13:09 +0800
Message-Id: <20171017091312.31045-4-wqu@suse.com>
In-Reply-To: <20171017091312.31045-1-wqu@suse.com>
References: <20171017091312.31045-1-wqu@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Introduce fix-device-size rescue subcommand to fix device size
alignment related problems.

Especially for people unable to mount their fs with super total bytes
mismatch, this tool should make their fs live again.

Reported-by: Asif Youssuff <yoasif@gmail.com>
Reported-by: Rich Rauenzahn <rrauenza@gmail.com>
Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 Documentation/btrfs-rescue.asciidoc | 29 +++++++++++++++++++
 cmds-rescue.c                       | 48 ++++++++++++++++++++++++++++++++
 volumes.c                           | 55 +++++++++++++++++++++++++++++++++++++
 volumes.h                           |  1 +
 4 files changed, 133 insertions(+)

diff --git a/Documentation/btrfs-rescue.asciidoc b/Documentation/btrfs-rescue.asciidoc
index 24b619c67c30..815abe3c2926 100644
--- a/Documentation/btrfs-rescue.asciidoc
+++ b/Documentation/btrfs-rescue.asciidoc
@@ -73,6 +73,35 @@ the log and the filesystem may be mounted normally again. The keywords to look
 for are 'open_ctree' which says that it's during mount and function names
 that contain 'replay', 'recover' or 'log_tree'.
 
+*fix-device-size* <device>::
+fix device size and super block total bytes
++
+This command will fix the following problems, by re-aligning all devices' total
+bytes and re-calculating super block total bytes.
++
+1. Newer kernel refuse to mount btrfs caused by mismatch super block total bytes
++
+----
+BTRFS error (device sdb): super_total_bytes 92017859088384 mismatch with fs_devices total_rw_bytes 92017859094528
+----
++
+2. Noisy kernel warning for newer kernels
++
+----
+WARNING: CPU: 3 PID: 439 at fs/btrfs/ctree.h:1559 btrfs_update_device+0x1c5/0x1d0 [btrfs]
+----
++
+And the corresponding line is the `WARN_ON()` line below:
++
+----
+{
+	BUILD_BUG_ON(sizeof(u64) !=
+		     sizeof(((struct btrfs_dev_item *)0))->total_bytes);
+	WARN_ON(!IS_ALIGNED(val, eb->fs_info->sectorsize));
+	btrfs_set_64(eb, s, offsetof(struct btrfs_dev_item, total_bytes), val);
+}
+----
+
 EXIT STATUS
 -----------
 *btrfs rescue* returns a zero exit status if it succeeds. Non zero is
diff --git a/cmds-rescue.c b/cmds-rescue.c
index d1bec0218e68..5b51952cdc10 100644
--- a/cmds-rescue.c
+++ b/cmds-rescue.c
@@ -20,6 +20,7 @@
 
 #include <getopt.h>
 #include "ctree.h"
+#include "volumes.h"
 #include "transaction.h"
 #include "disk-io.h"
 #include "commands.h"
@@ -201,6 +202,51 @@ out:
 	return !!ret;
 }
 
+static const char * const cmd_rescue_fix_device_size_usage[] = {
+	"btrfs rescue fix-device-size <device>",
+	"Re-align device and super block sizes. Usable if newer kernel refuse to mount it due to mismatch super size",
+	"",
+	NULL
+};
+
+static int cmd_rescue_fix_device_size(int argc, char **argv)
+{
+	struct btrfs_fs_info *fs_info;
+	char *devname;
+	int ret;
+
+	clean_args_no_options(argc, argv, cmd_rescue_fix_device_size_usage);
+
+	if (check_argc_exact(argc, 2))
+		usage(cmd_rescue_fix_device_size_usage);
+
+	devname = argv[optind];
+	ret = check_mounted(devname);
+	if (ret < 0) {
+		error("could not check mount status: %s", strerror(-ret));
+		goto out;
+	} else if (ret) {
+		error("%s is currently mounted", devname);
+		ret = -EBUSY;
+		goto out;
+	}
+
+	fs_info = open_ctree_fs_info(devname, 0, 0, 0, OPEN_CTREE_WRITES |
+				     OPEN_CTREE_PARTIAL);
+	if (!fs_info) {
+		error("could not open btrfs");
+		ret = -EIO;
+		goto out;
+	}
+
+	ret = btrfs_fix_device_and_super_size(fs_info);
+	if (ret > 0)
+		ret = 0;
+	close_ctree(fs_info->tree_root);
+out:
+	return !!ret;
+}
+
 static const char rescue_cmd_group_info[] =
 "toolbox for specific rescue operations";
 
@@ -211,6 +257,8 @@ const struct cmd_group rescue_cmd_group = {
 		{ "super-recover", cmd_rescue_super_recover,
 			cmd_rescue_super_recover_usage, NULL, 0},
 		{ "zero-log", cmd_rescue_zero_log, cmd_rescue_zero_log_usage, NULL, 0},
+		{ "fix-device-size", cmd_rescue_fix_device_size,
+			cmd_rescue_fix_device_size_usage, NULL, 0},
 		NULL_CMD_STRUCT
 	}
 };
diff --git a/volumes.c b/volumes.c
index c86f8a931742..2235d84784b0 100644
--- a/volumes.c
+++ b/volumes.c
@@ -2455,3 +2455,58 @@ int btrfs_fix_super_size(struct btrfs_fs_info *fs_info)
 		old_bytes, total_bytes);
 	return 1;
 }
+
+/*
+ * Return 0 if all devices and super block size is good
+ * Return >0 if any device/super size problem found, but fixed
+ * Return <0 if something wrong happened during fixing
+ */
+int btrfs_fix_device_and_super_size(struct btrfs_fs_info *fs_info)
+{
+	struct btrfs_device *device;
+	struct list_head *dev_list = &fs_info->fs_devices->devices;
+	bool have_bad_value = false;
+	int ret;
+
+	/* Seed device is not support yet */
+	if (fs_info->fs_devices->seed) {
+		error("fixing device size with seed device is not supported yet");
+		return -ENOTTY;
+	}
+
+	/* All devices must be on-line before repairing */
+	if (list_empty(dev_list)) {
+		error("no device found");
+		return -ENODEV;
+	}
+	list_for_each_entry(device, dev_list, dev_list) {
+		if (device->fd == -1 || !device->writeable) {
+			error("devid %llu is missing or not writeable",
+			      device->devid);
+			error("fixing device size needs all device(s) present and writeable");
+			return -ENODEV;
+		}
+	}
+
+	/* Repair total_bytes of each device */
+	list_for_each_entry(device, dev_list, dev_list) {
+		ret = btrfs_fix_device_size(fs_info, device);
+		if (ret < 0)
+			return ret;
+		if (ret > 0)
+			have_bad_value = true;
+	}
+
+	/* Repair super total_byte */
+	ret = btrfs_fix_super_size(fs_info);
+	if (ret > 0)
+		have_bad_value = true;
+	if (have_bad_value) {
+		printf("Fixed unaligned/mismatch total_bytes for super block and device item\n");
+		ret = 1;
+	} else {
+		printf("No device size related problem found\n");
+		ret = 0;
+	}
+	return ret;
+}
diff --git a/volumes.h b/volumes.h
index d5bb5f8663a3..11572e78c04f 100644
--- a/volumes.h
+++ b/volumes.h
@@ -248,4 +248,5 @@ u64 btrfs_stripe_length(struct btrfs_fs_info *fs_info,
 int btrfs_fix_device_size(struct btrfs_fs_info *fs_info,
 			  struct btrfs_device *device);
 int btrfs_fix_super_size(struct btrfs_fs_info *fs_info);
+int btrfs_fix_device_and_super_size(struct btrfs_fs_info *fs_info);
 #endif
-- 
2.14.2

