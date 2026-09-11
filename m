Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40D1822D7A9
	for <linux-btrfs@vger.kernel.org>; Fri, 11 Sep 2026 01:33:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789090385; cv=none; b=Hdwc0ohwnrOgbH0CV1YaDPF5hIIuslcjUmMDpk/CyGHQCRns/gInFLSxI1rLNOhbZbwfmGW5G5VX4XYOE+bju8lC4bcefEPpbzfjS53y8Mq98/mRFr/S8xPjUPiOAG9PYmP3v3AraE7qlmqTcin2UkEeVuZ/Mu7mpbw8CTzRFdw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789090385; c=relaxed/simple;
	bh=Rw3m1sLoxL9c2klFUmm6ukEJGTJ4qXh15R3Ucf21hJo=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=T9CbCneOPtRMK2PTw5pg9kS+CqN16F/e3Od5shPOJbkbVhTX6qUahZyY9gow1bUOS/pD6hnx5b9hs94LnEAVdVFOo9+3CbJMepTgjPkAEIPGiCEEHzn6zlxgDhBwggZqprPjofswFgRYtrFB13NpKH09XKuRpuqilDeJE2kWQp4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=RIqBfWoz; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=vIK1/CbM; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="RIqBfWoz";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="vIK1/CbM"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 259722127F
	for <linux-btrfs@vger.kernel.org>; Fri, 11 Sep 2026 01:32:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1789090378; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=DliiMQVfmKhqCMneKgJ0rG+LAqjWynWGhuQXSc1DJco=;
	b=RIqBfWozr7DTuLbpMr9tVdmshsJsWyrugDCJzLBoya4iYA83eqOcAe/Jo6ZTSQZIppbaVb
	NrjXuPr54JHnwPb9ObSs7GMDsStgB4P4KYhvy+Y0e5WI2/s7kWWD37P8XlJeqvS43VzMBI
	zTEEsAb0NaAVSH7xcdBgtnUkbmo1nIE=
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1789090374; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=DliiMQVfmKhqCMneKgJ0rG+LAqjWynWGhuQXSc1DJco=;
	b=vIK1/CbMe3sJ6UMV00PcE6WR52PCXfQHR4bwnkTSJw/LtJli6f6TGGAqpSPeZac+Hj1OjT
	Jk81AxpXDE11gw2ce+xX29JEIFxy6riCOt1eZRdGxPUWnmaPhfLbI3VP0sJo5eOP0dvd4j
	yGpTnqRoH/rVCJj93JgsAjGrDdZxuhI=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 0A039136ED
	for <linux-btrfs@vger.kernel.org>; Fri, 11 Sep 2026 01:32:52 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id Ipq9KkRao2rXbAAAD6G6ig
	(envelope-from <wqu@suse.com>)
	for <linux-btrfs@vger.kernel.org>; Fri, 11 Sep 2026 01:32:52 +0000
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH] btrfs-progs: add "-r|--rename" option to "btrfs device scan"
Date: Fri, 11 Sep 2026 11:02:34 +0930
Message-ID: <9ce9c4b244e0224439a0fe675e1e39eb7509ad3c.1789090350.git.wqu@suse.com>
X-Mailer: git-send-email 2.55.0
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Score: 0.20
X-Spam-Level: 
X-Spamd-Result: default: False [0.20 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	SEM_URIBL_FRESH15(3.00)[args.name:url];
	MID_CONTAINS_FROM(1.00)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_MISSING_CHARSET(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-0.993];
	MIME_GOOD(-0.10)[text/plain];
	RCPT_COUNT_ONE(0.00)[1];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	ARC_NA(0.00)[];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:mid,suse.com:email,args.name:url,imap1.dmz-prg2.suse.org:helo];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	TO_DN_NONE(0.00)[];
	PREVIOUSLY_DELIVERED(0.00)[linux-btrfs@vger.kernel.org];
	RCVD_TLS_ALL(0.00)[]
X-Spam-Flag: NO

This option allows end users to force update a device path, so that all
responsibility to maintain a sane device path is pushed to end users.

This is to co-operate with the kernel patch "btrfs: introduce a new ioctl
to force updating the device name".

Signed-off-by: Qu Wenruo <wqu@suse.com>
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
index 7144f3ba07b9..036e44ceeb4c 100644
--- a/kernel-shared/uapi/btrfs.h
+++ b/kernel-shared/uapi/btrfs.h
@@ -1306,6 +1306,8 @@ enum btrfs_err_code {
 #define BTRFS_IOC_QUOTA_RESCAN_STATUS _IOR(BTRFS_IOCTL_MAGIC, 45, \
 			       struct btrfs_ioctl_quota_rescan_args)
 #define BTRFS_IOC_QUOTA_RESCAN_WAIT _IO(BTRFS_IOCTL_MAGIC, 46)
+#define BTRFS_IOC_RENAME_DEV _IOR(BTRFS_IOCTL_MAGIC, 47, \
+                                  struct btrfs_ioctl_vol_args)
 #ifndef FS_IOC_GETFSLABEL
 #define BTRFS_IOC_GET_FSLABEL _IOR(BTRFS_IOCTL_MAGIC, 49, \
 				   char[BTRFS_LABEL_SIZE])
-- 
2.55.0

