Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3594B42377F
	for <linux-btrfs@vger.kernel.org>; Fri, 11 Sep 2026 07:43:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789112635; cv=none; b=Yc4Xnjnq3lPRfjP+RC+GhE0YnUc4yPJpCYvq+jdW/pfVhbsfh0J/qVmbWVo0vW/hfJV3wnVkXhP6NvfCtBmPmiT9Nz7b/X+bwv4O/wz94yptUtX330+RtqxnfMUzLxeYVFfDWCoqDUTt/xoROF6v8Y47aTHX3A/XL//F9GnSXeQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789112635; c=relaxed/simple;
	bh=IakCVt8GqB0preAZ1Slod2BYzdzgfMXAh52rpas233E=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=OpFZ6Y7n3ihV590XUU+qBCRA6H5l7Xu+1vNlUDvF7L+jgb8oEyyRemXS9hfQJNhvR784yyYt3AEaJufr0nubBIKBITkbqBkVVfnHJ76ig6xDzsjR2eyPxaFVucREm1y1TGvXCd75pey1gzFl6fXyzOMardiUD6yxsgfBlRLZGF4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=BGRKzM+2; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=hCx2BqzZ; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="BGRKzM+2";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="hCx2BqzZ"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 0BF4A2196E
	for <linux-btrfs@vger.kernel.org>; Fri, 11 Sep 2026 07:43:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1789112628; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=2aD4t5NwQ1aqi0/V31VFV/lpF2aLByGfQn0GpYbXrBg=;
	b=BGRKzM+2ptnEd9GnC6HzrOQusJbygaYBTP1i4F+zwt+7T2PCbSNO4mpg9hJyZk40KC4YFM
	koUd+VH2aP56K4obf1tWrL/7X7Xrhs1/QMgqSnjknpkM1Au9zIzESvBJxCuSfUMKuyIxLo
	O+Fao+qOrRo3ddGAQOHsB+iU+d+F+TU=
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.com header.s=susede1 header.b=hCx2BqzZ
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1789112624; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=2aD4t5NwQ1aqi0/V31VFV/lpF2aLByGfQn0GpYbXrBg=;
	b=hCx2BqzZ+0u3GHtJdceBnhmgsvRAFxhR60DKFJsMIAoT5LVDhQroda4GGYaUBddDX/w/zQ
	BDnIuAQS/n3Bo6H29izCOpH4Ok1jR1CTwvB3UN+UjtD/SACi0e0OTjOFCL+6QxoordvogZ
	xBakxFBDkFiWew5/zzT9LUtC8hO7BXI=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id E4D62137DE
	for <linux-btrfs@vger.kernel.org>; Fri, 11 Sep 2026 07:43:42 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id zIWzJC6xo2rkVgAAD6G6ig
	(envelope-from <wqu@suse.com>)
	for <linux-btrfs@vger.kernel.org>; Fri, 11 Sep 2026 07:43:42 +0000
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH v2] btrfs-progs: add "-r|--rename" option to "btrfs device scan"
Date: Fri, 11 Sep 2026 17:13:20 +0930
Message-ID: <b782dc6af50ea76a60cef13d4e7197bc928c689b.1789112501.git.wqu@suse.com>
X-Mailer: git-send-email 2.55.0
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Level: 
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Rspamd-Queue-Id: 0BF4A2196E
X-Rspamd-Action: no action
X-Spamd-Bar: /
X-Spamd-Result: default: False [0.29 / 50.00];
	SEM_URIBL_FRESH15(3.00)[args.name:url];
	BAYES_HAM(-3.00)[100.00%];
	MID_CONTAINS_FROM(1.00)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_MISSING_CHARSET(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-0.995];
	MIME_GOOD(-0.10)[text/plain];
	BAD_REP_POLICIES(0.10)[];
	MX_GOOD(-0.01)[];
	R_DKIM_ALLOW(0.00)[suse.com:s=susede1];
	TO_DN_NONE(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	ARC_NA(0.00)[];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	RCPT_COUNT_ONE(0.00)[1];
	PREVIOUSLY_DELIVERED(0.00)[linux-btrfs@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	FROM_EQ_ENVFROM(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	DKIM_TRACE(0.00)[suse.com:+];
	MIME_TRACE(0.00)[0:+];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:rdns,imap1.dmz-prg2.suse.org:helo,suse.com:dkim,suse.com:email,suse.com:mid]
X-Spam-Flag: NO
X-Spam-Score: 0.29

This option allows end users to force update a device path, so that all
responsibility to maintain a sane device path is pushed to end users.

This is to co-operate with the kernel patch "btrfs: introduce a new ioctl
to force updating the device name".

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
Changelog:
v2:
- Update the ioctl number to reflect the kernel change
---
 Documentation/btrfs-device.rst | 12 ++++++++++
 cmds/device.c                  | 42 ++++++++++++++++++++++++++++++++--
 kernel-shared/uapi/btrfs.h     |  2 ++
 3 files changed, 54 insertions(+), 2 deletions(-)

diff --git a/Documentation/btrfs-device.rst b/Documentation/btrfs-device.rst
index 8ade55c6dc51..e04ca8539b23 100644
--- a/Documentation/btrfs-device.rst
+++ b/Documentation/btrfs-device.rst
@@ -123,6 +123,18 @@ scan [options] [<device> [<device>...]]
         -u|--forget
                 Unregister a given device or all stale devices if no path is given, the device
                 must be unmounted otherwise it's an error.
+	-r|--rename
+		Force a device name update for a device. Btrfs internally saves the device
+		name at mount/scan time, and won't update them unless the underlying device
+		numer changes.
+
+		This can lead to some weird device path and not all user space tools are
+		using device numbers to locate a device.
+
+		This option can be utilized to force a device name update to replace
+		those weird paths.
+
+		This options must has dedicated device path(s) passed in.
 
 stats [options] <path>|<device>|<file>
         Read and print the device IO error statistics for all devices of the given
diff --git a/cmds/device.c b/cmds/device.c
index 8d33569816f4..db90b91229bb 100644
--- a/cmds/device.c
+++ b/cmds/device.c
@@ -403,6 +403,26 @@ static int btrfs_forget_devices(const char *path)
 	return ret;
 }
 
+static int btrfs_rename_device(const char *path)
+{
+	struct btrfs_ioctl_vol_args args;
+	int ret;
+	int fd;
+
+	fd = open("/dev/btrfs-control", O_RDWR);
+	if (fd < 0)
+		return -errno;
+
+	memset(&args, 0, sizeof(args));
+	if (path)
+		strncpy_null(args.name, path, sizeof(args.name));
+	ret = ioctl(fd, BTRFS_IOC_RENAME_DEV, &args);
+	if (ret)
+		ret = -errno;
+	close(fd);
+	return ret;
+}
+
 static const char * const cmd_device_scan_usage[] = {
 	"btrfs device scan [-d|--all-devices] <device> [<device>...]\n"
 	"btrfs device scan -u|--forget [<device>...]",
@@ -417,6 +437,7 @@ static const char * const cmd_device_scan_usage[] = {
 	"",
 	OPTLINE("-d, --all-devices", "enumerate and register all devices, use as a fallback if blkid is not available"),
 	OPTLINE("-u, --forget [<device>...]", "unregister a given device or all stale devices if no path"),
+	OPTLINE("-r, --rename <device>...", "update the device path for a mounted btrfs device"),
 	HELPINFO_INSERT_GLOBALS,
 	HELPINFO_INSERT_VERBOSE,
 	HELPINFO_INSERT_QUIET,
@@ -428,7 +449,8 @@ static int cmd_device_scan(const struct cmd_struct *cmd, int argc, char **argv)
 	int i;
 	int devstart;
 	bool all = false;
-	bool forget = 0;
+	bool forget = false;
+	bool rename = false;
 	int ret = 0;
 
 	optind = 0;
@@ -437,10 +459,11 @@ static int cmd_device_scan(const struct cmd_struct *cmd, int argc, char **argv)
 		static const struct option long_options[] = {
 			{ "all-devices", no_argument, NULL, 'd'},
 			{ "forget", no_argument, NULL, 'u'},
+			{ "rename", no_argument, NULL, 'r'},
 			{ NULL, 0, NULL, 0}
 		};
 
-		c = getopt_long(argc, argv, "du", long_options, NULL);
+		c = getopt_long(argc, argv, "dur", long_options, NULL);
 		if (c < 0)
 			break;
 		switch (c) {
@@ -450,6 +473,9 @@ static int cmd_device_scan(const struct cmd_struct *cmd, int argc, char **argv)
 		case 'u':
 			forget = true;
 			break;
+		case 'r':
+			rename = true;
+			break;
 		default:
 			usage_unknown_option(cmd, argv);
 		}
@@ -458,11 +484,16 @@ static int cmd_device_scan(const struct cmd_struct *cmd, int argc, char **argv)
 
 	if (all && forget)
 		usage(cmd, 1);
+	if (all && rename)
+		usage(cmd, 1);
 
 	if (all && check_argc_max(argc - optind, 1))
 		usage(cmd, 1);
 
 	if (all || argc - optind == 0) {
+		if (rename)
+			usage(cmd, 1);
+
 		if (forget) {
 			ret = btrfs_forget_devices(NULL);
 			if (ret < 0) {
@@ -501,6 +532,13 @@ static int cmd_device_scan(const struct cmd_struct *cmd, int argc, char **argv)
 				errno = -ret;
 				error("cannot unregister device '%s': %m", path);
 			}
+		} else if (rename) {
+			ret = btrfs_rename_device(path);
+			if (ret < 0) {
+				errno = -ret;
+				error("failed to update the device path for '%s': %m",
+				      path);
+			}
 		} else {
 			pr_default("Scanning for btrfs filesystems on '%s'\n", path);
 			if (btrfs_register_one_device(path) != 0) {
diff --git a/kernel-shared/uapi/btrfs.h b/kernel-shared/uapi/btrfs.h
index 7144f3ba07b9..201145c21528 100644
--- a/kernel-shared/uapi/btrfs.h
+++ b/kernel-shared/uapi/btrfs.h
@@ -1306,6 +1306,8 @@ enum btrfs_err_code {
 #define BTRFS_IOC_QUOTA_RESCAN_STATUS _IOR(BTRFS_IOCTL_MAGIC, 45, \
 			       struct btrfs_ioctl_quota_rescan_args)
 #define BTRFS_IOC_QUOTA_RESCAN_WAIT _IO(BTRFS_IOCTL_MAGIC, 46)
+#define BTRFS_IOC_RENAME_DEV _IOW(BTRFS_IOCTL_MAGIC, 47, \
+                                  struct btrfs_ioctl_vol_args)
 #ifndef FS_IOC_GETFSLABEL
 #define BTRFS_IOC_GET_FSLABEL _IOR(BTRFS_IOCTL_MAGIC, 49, \
 				   char[BTRFS_LABEL_SIZE])
-- 
2.55.0

