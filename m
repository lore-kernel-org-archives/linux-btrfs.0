Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtp207.alice.it ([82.57.200.103]:54556 "EHLO smtp207.alice.it"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755326Ab2FHTMw (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 8 Jun 2012 15:12:52 -0400
From: Goffredo Baroncelli <kreijack@inwind.it>
To: linux-btrfs@vger.kernel.org
Cc: Stefan Behrens <sbehrens@giantdisaster.de>,
        Goffredo Baroncelli <kreijack@inwind.it>
Subject: [PATCH 2/3] Add btrfs filesystem info command.
Date: Fri,  8 Jun 2012 21:12:45 +0200
Message-Id: <1339182766-15292-3-git-send-email-kreijack@inwind.it>
In-Reply-To: <1339182766-15292-1-git-send-email-kreijack@inwind.it>
References: <1339182766-15292-1-git-send-email-kreijack@inwind.it>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Add btrfs filesystem info command, which is capable to show some
btrfs filesystem information.
---
 cmds-filesystem.c |   59 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 59 insertions(+)

diff --git a/cmds-filesystem.c b/cmds-filesystem.c
index 1f53d1c..9acc715 100644
--- a/cmds-filesystem.c
+++ b/cmds-filesystem.c
@@ -519,6 +519,64 @@ static int cmd_label(int argc, char **argv)
 		return get_label(argv[1]);
 }
 
+static const char * const cmd_info_usage[] = {
+	"btrfs filesystem info <path>",
+	"Get filesystem information",
+	NULL
+};
+
+static int cmd_info(int argc, char **argv){
+
+	struct btrfs_ioctl_fs_info_args 	fi_args;
+	struct btrfs_ioctl_dev_info_args 	*di_ret=NULL;
+	int    					ret,i;
+	char					uuidbuf[37];
+	int					fd;
+
+	if( argc != 2){
+		fprintf(stderr, "ERROR: missing argument\n");
+		return 102;
+	}
+
+	fd = open_file_or_dir(argv[1]);
+	if( fd < 0 ){
+		fprintf(stderr, "ERROR: cannot open '%s'\n", argv[1]);
+		return 103;
+	}
+
+	ret = get_fs_info(fd, argv[1], &fi_args, &di_ret);
+	if( ret ){
+		int e = errno;
+		fprintf(stderr, "ERROR: cannot get information about '%s'\n",
+			argv[1]);
+		fprintf(stderr, "ERROR: errno=%d, error=%s\n",
+			e, strerror(e) );
+		close(fd);
+		if(di_ret != NULL )
+			free(di_ret);
+		return 104;
+	}
+
+	printf("Path: %s\n",argv[1]);
+	printf("Max ID: %llu\n", fi_args.max_id);
+	uuid_unparse(fi_args.fsid, uuidbuf);
+	printf("UUID: %s\n", uuidbuf);
+
+	printf("\nNum devices: %llu\n", fi_args.num_devices);
+	for( i = 0 ; i < fi_args.num_devices ; i++ ){
+		printf("  Dev ID: %llu\n", di_ret[i].devid);
+		uuid_unparse(di_ret[i].uuid, uuidbuf);
+		printf("  UUID: %s\n", uuidbuf);
+		printf("  Bytes used: %llu\n", di_ret[i].bytes_used );
+		printf("  Total bytes: %llu\n", di_ret[i].total_bytes );
+		printf("  Path: %s\n", di_ret[i].path);
+	}
+
+	close(fd);
+	free(di_ret);
+	return 0;
+}
+
 const struct cmd_group filesystem_cmd_group = {
 	filesystem_cmd_group_usage, NULL, {
 		{ "df", cmd_df, cmd_df_usage, NULL, 0 },
@@ -528,6 +586,7 @@ const struct cmd_group filesystem_cmd_group = {
 		{ "balance", cmd_balance, NULL, &balance_cmd_group, 1 },
 		{ "resize", cmd_resize, cmd_resize_usage, NULL, 0 },
 		{ "label", cmd_label, cmd_label_usage, NULL, 0 },
+		{ "info", cmd_info, cmd_info_usage, NULL, 0 },
 		{ 0, 0, 0, 0, 0 },
 	}
 };
-- 
1.7.10

