Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:54347 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751871AbaENCDD (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 13 May 2014 22:03:03 -0400
Received: from int-mx01.intmail.prod.int.phx2.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id s4E233OT006116
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Tue, 13 May 2014 22:03:03 -0400
Received: from liberator.sandeen.net (ovpn01.gateway.prod.ext.phx2.redhat.com [10.5.9.1])
	by int-mx01.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP id s4E232Sx007399
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES128-SHA bits=128 verify=NO)
	for <linux-btrfs@vger.kernel.org>; Tue, 13 May 2014 22:03:02 -0400
Message-ID: <5372CED8.7030404@redhat.com>
Date: Tue, 13 May 2014 21:03:04 -0500
From: Eric Sandeen <sandeen@redhat.com>
MIME-Version: 1.0
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: [PATCH] btrfs-show-super: don't try to print not-superblocks
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

If we point btrfs-show-super at a not-btrfs-device and
try to print all superblocks, bad things are apt to happen:

superblock: bytenr=274877906944, device=/dev/sdc2
---------------------------------------------------------
btrfs-show-super: ctree.h:1984: btrfs_super_csum_size: Assertion `!(t >= (sizeof(btrfs_csum_sizes) / sizeof((btrfs_csum_sizes)[0])))' failed.
csum			0xAborted

Don't try to print superblocks that don't look like superblocks,
and add an "-f" (force) option to try anyway, if the user
really wants to give it a shot.

Fix some spelling & capitalization while we're at it.

The manpage says that if any problem happens, 1 will
be returned, but that's already not true today LOL, so
I didn't bother to make it true when we detect bad
sb magic, either...

I figure it's worth continuing and trying all superblocks
in case just one has a corrupt magic.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

diff --git a/btrfs-show-super.c b/btrfs-show-super.c
index d4df0ac..023f099 100644
--- a/btrfs-show-super.c
+++ b/btrfs-show-super.c
@@ -40,16 +40,17 @@
 static void print_usage(void);
 static void dump_superblock(struct btrfs_super_block *sb);
 int main(int argc, char **argv);
-static int load_and_dump_sb(char *, int fd, u64 sb_bytenr);
+static int load_and_dump_sb(char *, int fd, u64 sb_bytenr, int force);
 
 
 static void print_usage(void)
 {
 	fprintf(stderr,
-		"usage: btrfs-show-super [-i super_mirror|-a] dev [dev..]\n");
+		"usage: btrfs-show-super [-i super_mirror|-a] [-f] dev [dev..]\n");
 	fprintf(stderr, "\tThe super_mirror number is between 0 and %d.\n",
 		BTRFS_SUPER_MIRROR_MAX - 1);
-	fprintf(stderr, "\tIf -a is passed all the superblocks are showed.\n");
+	fprintf(stderr, "\tIf -a is passed all the superblocks are shown.\n");
+	fprintf(stderr, "\tPass -f to attempt to dump superblocks with bad magic.\n");
 	fprintf(stderr, "%s\n", BTRFS_BUILD_VERSION);
 }
 
@@ -60,10 +61,11 @@ int main(int argc, char **argv)
 	char *filename;
 	int fd = -1;
 	int i;
+	int force = 0;
 	u64 arg;
 	u64 sb_bytenr = btrfs_sb_offset(0);
 
-	while ((opt = getopt(argc, argv, "ai:")) != -1) {
+	while ((opt = getopt(argc, argv, "afi:")) != -1) {
 		switch (opt) {
 		case 'i':
 			arg = arg_strtou64(optarg);
@@ -81,6 +83,10 @@ int main(int argc, char **argv)
 			all = 1;
 			break;
 
+		case 'f':
+			force = 1;
+			break;
+
 		default:
 			print_usage();
 			exit(1);
@@ -104,7 +110,8 @@ int main(int argc, char **argv)
 			int idx;
 			for (idx = 0; idx < BTRFS_SUPER_MIRROR_MAX; idx++) {
 				sb_bytenr = btrfs_sb_offset(idx);
-				if (load_and_dump_sb(filename, fd, sb_bytenr)) {
+				if (load_and_dump_sb(filename, fd,
+						     sb_bytenr, force)) {
 					close(fd);
 					exit(1);
 				}
@@ -112,7 +119,7 @@ int main(int argc, char **argv)
 				putchar('\n');
 			}
 		} else {
-			load_and_dump_sb(filename, fd, sb_bytenr);
+			load_and_dump_sb(filename, fd, sb_bytenr, force);
 			putchar('\n');
 		}
 		close(fd);
@@ -121,7 +128,7 @@ int main(int argc, char **argv)
 	exit(0);
 }
 
-static int load_and_dump_sb(char *filename, int fd, u64 sb_bytenr)
+static int load_and_dump_sb(char *filename, int fd, u64 sb_bytenr, int force)
 {
 	u8 super_block_data[BTRFS_SUPER_INFO_SIZE];
 	struct btrfs_super_block *sb;
@@ -146,7 +153,12 @@ static int load_and_dump_sb(char *filename, int fd, u64 sb_bytenr)
 	}
 	printf("superblock: bytenr=%llu, device=%s\n", sb_bytenr, filename);
 	printf("---------------------------------------------------------\n");
-	dump_superblock(sb);
+	if (btrfs_super_magic(sb) != BTRFS_MAGIC && !force) {
+		fprintf(stderr,
+		    "ERROR: bad magic on superblock on %s at %llu\n",
+		    filename, (unsigned long long)sb_bytenr);
+	} else
+		dump_superblock(sb);
 	return 0;
 }
 
diff --git a/man/btrfs-show-super.8.in b/man/btrfs-show-super.8.in
index 3fe8bde..582649a 100644
--- a/man/btrfs-show-super.8.in
+++ b/man/btrfs-show-super.8.in
@@ -10,9 +10,11 @@ first superblock will be printed out.
 
 \fIOptions\fP
 .IP "\fB-a\fP" 5
-print all the superblock information, if this option is given, '\fB-i\fP' option will be ignored.
+Print all the superblock information, if this option is given, '\fB-i\fP' option will be ignored.
+.IP "\fB-f\fP" 5
+Attempt to print the superblock even if no superblock magic is found.  May end badly.
 .IP "\fB-i \fI<super_mirror>\fP" 5
-specify which mirror to print out. \fI<super_mirror>\fP is between 0 and 2. if several '\fB-i \fI<super_mirror>\fP'\fR are given, only the last one is valid.
+Specify which mirror to print out. \fI<super_mirror>\fP is between 0 and 2.  If several '\fB-i \fI<super_mirror>\fP'\fR are given, only the last one is valid.
 
 .SH EXIT CODE
 \fBbtrfs-show-super\fR will return 0 exit code if no error happened.

