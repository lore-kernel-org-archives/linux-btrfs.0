Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:27943 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755099AbbBJK1q (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 10 Feb 2015 05:27:46 -0500
Received: from G08CNEXCHPEKD02.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id t1AAR0wl000958
	for <linux-btrfs@vger.kernel.org>; Tue, 10 Feb 2015 18:27:00 +0800
From: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: Fan Chengniang <fancn.fnst@cn.fujitsu.com>,
        Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
Subject: [PATCH 3/4] btrfs-progs:specify qgroup type when creating qgroup
Date: Tue, 10 Feb 2015 18:24:16 +0800
Message-ID: <1423563862-9151-6-git-send-email-yangds.fnst@cn.fujitsu.com>
In-Reply-To: <1423563862-9151-1-git-send-email-yangds.fnst@cn.fujitsu.com>
References: <1423563862-9151-1-git-send-email-yangds.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Fan Chengniang <fancn.fnst@cn.fujitsu.com>

add --qgroup-type option to specify qgroup type. Type
can be metadata, data or mixed.

Signed-off-by: Fan Chengniang <fancn.fnst@cn.fujitsu.com>
Signed-off-by: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
---
 Documentation/btrfs-qgroup.txt |  5 +++++
 cmds-qgroup.c                  | 37 ++++++++++++++++++++++++++++++++++---
 2 files changed, 39 insertions(+), 3 deletions(-)

diff --git a/Documentation/btrfs-qgroup.txt b/Documentation/btrfs-qgroup.txt
index eadfe1c..7b07e97 100644
--- a/Documentation/btrfs-qgroup.txt
+++ b/Documentation/btrfs-qgroup.txt
@@ -45,6 +45,11 @@ Create a subvolume quota group.
 +
 For the '0/<subvolume id>' qgroup, a qgroup can be created even before the
 subvolume created.
++
+--qgroup-type=<type>::::
+specify the <type> of qgroup to set qgroup limit.
++
+<attr> can be one of metadata, data, mixed.
 
 *destroy* <qgroupid> <path>::
 Destroy a qgroup.
diff --git a/cmds-qgroup.c b/cmds-qgroup.c
index 30f0851..23accdf 100644
--- a/cmds-qgroup.c
+++ b/cmds-qgroup.c
@@ -78,16 +78,45 @@ static int qgroup_create(int create, int argc, char **argv)
 	int ret = 0;
 	int fd;
 	int e;
-	char *path = argv[2];
+	char *path = argv[argc - 1];
 	struct btrfs_ioctl_qgroup_create_args args;
 	DIR *dirstream = NULL;
+	__u8 qgroup_type = 0;
+	__u64 create_type;
 
-	if (check_argc_exact(argc, 3))
+	optind = 1;
+	while (1) {
+		int c;
+		static const struct option long_options[] = {
+			{"qgroup-type", required_argument, NULL, 'q'},
+			{NULL, 0, NULL, 0}
+		};
+
+		c = getopt_long(argc, argv, "", long_options, NULL);
+		if (c < 0)
+			break;
+
+		switch (c) {
+		case 'q':
+			ret = btrfs_qgroup_set_qgroup_type(&qgroup_type, optarg);
+			if (ret)
+				return -1;
+			break;
+		default:
+			return -1;
+		}
+	}
+
+	if (check_argc_exact(argc - optind, 2))
 		return -1;
 
 	memset(&args, 0, sizeof(args));
 	args.create = create;
-	args.qgroupid = parse_qgroupid(argv[1]);
+	if (create && qgroup_type) {
+		create_type = qgroup_type;
+		args.create |= (create_type << BTRFS_QGROUP_TYPE_SHIFT);
+	}
+	args.qgroupid = parse_qgroupid(argv[argc - 2]);
 
 	fd = open_file_or_dir(path, &dirstream);
 	if (fd < 0) {
@@ -137,6 +166,8 @@ static int cmd_qgroup_remove(int argc, char **argv)
 static const char * const cmd_qgroup_create_usage[] = {
 	"btrfs qgroup create <qgroupid> <path>",
 	"Create a subvolume quota group.",
+	"--qgroup-type=metadata,data,mixed",
+	"               specify which qgroup type to set qgroup limit",
 	NULL
 };
 
-- 
1.8.4.2

