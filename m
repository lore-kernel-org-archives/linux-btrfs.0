Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from linux-libre.fsfla.org ([208.118.235.54]:39978 "EHLO
	linux-libre.fsfla.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751677AbaH3S1K (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 30 Aug 2014 14:27:10 -0400
Received: from freie.home (home.lxoliva.fsfla.org [172.31.160.22])
	by linux-libre.fsfla.org (8.14.4/8.14.4/Debian-2ubuntu2.1) with ESMTP id s7UIR6ip021393
	for <linux-btrfs@vger.kernel.org>; Sat, 30 Aug 2014 18:27:06 GMT
From: Alexandre Oliva <oliva@gnu.org>
To: linux-btrfs@vger.kernel.org
Subject: btrfs: add -k option to filesystem df
Date: Sat, 30 Aug 2014 15:27:00 -0300
Message-ID: <or61h94yvf.fsf@free.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Introduce support for df to print sizes in KiB, easy to extend to other
bases.

The man page is also updated and fixed in that it made it seem like
multiple paths were accepted.

Signed-off-by: Alexandre Oliva <oliva@gnu.org>
---
 Documentation/btrfs-filesystem.txt |    4 +++-
 cmds-filesystem.c                  |   26 +++++++++++++++++++++++---
 utils.c                            |   29 +++++++++++++++++++++++++++--
 utils.h                            |    1 +
 4 files changed, 54 insertions(+), 6 deletions(-)

diff --git a/Documentation/btrfs-filesystem.txt b/Documentation/btrfs-filesystem.txt
index c9c0b00..70ba4b8 100644
--- a/Documentation/btrfs-filesystem.txt
+++ b/Documentation/btrfs-filesystem.txt
@@ -17,8 +17,10 @@ resizing, defragment.
 
 SUBCOMMAND
 ----------
-*df* <path> [<path>...]::
+*df* [--kbytes] <path>::
 Show space usage information for a mount point.
++
+If '-k' or '--kbytes' is passed, sizes will be printed in KiB.
 
 *show* [--mounted|--all-devices|<path>|<uuid>|<device>|<label>]::
 Show the btrfs filesystem with some additional info.
diff --git a/cmds-filesystem.c b/cmds-filesystem.c
index 7e8ca95..737fcf3 100644
--- a/cmds-filesystem.c
+++ b/cmds-filesystem.c
@@ -113,8 +113,9 @@ static const char * const filesystem_cmd_group_usage[] = {
 };
 
 static const char * const cmd_df_usage[] = {
-	"btrfs filesystem df <path>",
+	"btrfs filesystem df [-k] <path>",
 	"Show space usage information for a mount point",
+	"-k|--kbytes        show disk spaces in KB",
 	NULL
 };
 
@@ -226,10 +227,29 @@ static int cmd_df(int argc, char **argv)
 	char *path;
 	DIR  *dirstream = NULL;
 
-	if (check_argc_exact(argc, 2))
+	while (1) {
+		int long_index;
+		static struct option long_options[] = {
+			{ "kbytes", no_argument, NULL, 'k'},
+			{ NULL, no_argument, NULL, 0 },
+		};
+		int c = getopt_long(argc, argv, "k", long_options,
+					&long_index);
+		if (c < 0)
+			break;
+		switch (c) {
+		case 'k':
+			pretty_size_force_base (1024);
+			break;
+		default:
+			usage(cmd_df_usage);
+		}
+	}
+
+	if (check_argc_max(argc, optind + 1))
 		usage(cmd_df_usage);
 
-	path = argv[1];
+	path = argv[optind];
 
 	fd = open_file_or_dir(path, &dirstream);
 	if (fd < 0) {
diff --git a/utils.c b/utils.c
index 6c09366..f760d1b 100644
--- a/utils.c
+++ b/utils.c
@@ -1377,19 +1377,43 @@ out:
 }
 
 static char *size_strs[] = { "", "KiB", "MiB", "GiB", "TiB", "PiB", "EiB"};
+u64 forced_base = 0;
+int pretty_size_force_base(u64 base)
+{
+	u64 check = 1;
+	while (check < base)
+		check *= 1024;
+	if (check != base && base)
+		return -1;
+	forced_base = base;
+	return 0;
+}
 int pretty_size_snprintf(u64 size, char *str, size_t str_bytes)
 {
 	int num_divs = 0;
+	u64 last_size = size;
 	float fraction;
 
 	if (str_bytes == 0)
 		return 0;
 
-	if( size < 1024 ){
+	if( forced_base ){
+		u64 base = forced_base;
+		while (base > 1) {
+			base /= 1024;
+			last_size = size;
+			size /= 1024;
+			num_divs++;
+		}
+		if (num_divs < 2)
+			return snprintf(str, str_bytes, "%llu%s",
+					(unsigned long long)size,
+					size_strs[num_divs]);
+		goto check;
+	} else if( size < 1024 ){
 		fraction = size;
 		num_divs = 0;
 	} else {
-		u64 last_size = size;
 		num_divs = 0;
 		while(size >= 1024){
 			last_size = size;
@@ -1397,6 +1421,7 @@ int pretty_size_snprintf(u64 size, char *str, size_t str_bytes)
 			num_divs ++;
 		}
 
+	check:
 		if (num_divs >= ARRAY_SIZE(size_strs)) {
 			str[0] = '\0';
 			return -1;
diff --git a/utils.h b/utils.h
index fd25126..bbcb042 100644
--- a/utils.h
+++ b/utils.h
@@ -71,6 +71,7 @@ int check_mounted_where(int fd, const char *file, char *where, int size,
 int btrfs_device_already_in_root(struct btrfs_root *root, int fd,
 				 int super_offset);
 
+int pretty_size_force_base(u64 base);
 int pretty_size_snprintf(u64 size, char *str, size_t str_bytes);
 #define pretty_size(size) 						\
 	({								\


-- 
Alexandre Oliva, freedom fighter    http://FSFLA.org/~lxoliva/
You must be the change you wish to see in the world. -- Gandhi
Be Free! -- http://FSFLA.org/   FSF Latin America board member
Free Software Evangelist|Red Hat Brasil GNU Toolchain Engineer
