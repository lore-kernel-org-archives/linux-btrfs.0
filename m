From: "Chris Samuel" <chris@csamuel.org>
Subject: [PATCH] Add supported kernel version check to mkfs.btrfs
Date: Thu, 23 Jul 2009 12:09:59 +1000
Message-ID: <20090723023411.23E8A8C03F@csamuel.org>
Cc: Chris Mason <chris.mason@oracle.com>
To: "linux-btrfs" <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

As the on disk format for btrfs is evolving it makes sense
for mkfs.btrfs to check that the running kernel on the system
supports the version of the filesystem that we are creating
and warn the user if that is not the case.

This patch adds a check_kernel_version() function which is
passed a string of the earliest kernel that supports this
version of btrfs and returns 0 if the running system supports
it or -1 if it doesn't (or on error).

It also adds a check to main() after the current warning about
btrfs being experimental to print a further warning if the
kernel is too old and exit.

This also adds a -f/--force flag to mkfs.btrfs. Initially this
is to suppress the exit if the kernel is too old so the user
can choose to make the filesystem anyway, but others may wish
to (ab)use it later. :-)

Finally it adds a #define for MINIMUM_KERNEL as "2.6.31".

I was considering moving the definition of MINIMUM_KERNEL outside
of mkfs.c but I can't think where else it might be useful.

Signed-off-by: Chris Samuel <chris@csamuel.org>
---
 mkfs.c |   76 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++-
 1 files changed, 75 insertions(+), 1 deletions(-)

diff --git a/mkfs.c b/mkfs.c
index 2e99b95..84c40b3 100644
--- a/mkfs.c
+++ b/mkfs.c
@@ -19,6 +19,8 @@
 #define _XOPEN_SOURCE 500
 #define _GNU_SOURCE
 
+#define MINIMUM_KERNEL "2.6.31"
+
 #ifndef __CHECKER__
 #include <sys/ioctl.h>
 #include <sys/mount.h>
@@ -42,6 +44,55 @@
 #include "transaction.h"
 #include "utils.h"
 #include "version.h"
+#include <sys/utsname.h>
+
+/*
+ * check_kernel_version() takes a string of the minimum
+ * kernel version supported ( say "2.6.31" ) and returns
+ * 0 if the running kernel is greater or equal to it and
+ * -1 if the running kernel is older.
+ *
+ * It also returns -1 if it fails to parse either running
+ * or minimum kernel versions, or fails to retrieve the
+ * uname(2) information.
+ */
+
+int check_kernel_version( char *minimum_version )
+{
+	struct utsname uname_info;
+	unsigned int kern_major=0, kern_medium=0, kern_minor=0;
+	unsigned int min_major=0, min_medium=0, min_minor=0;
+
+	if ( uname( &uname_info ) != 0 )
+	{
+		perror( "uname failed, assuming bad!" );
+		return( -1 );
+	}
+	
+	if ( sscanf ( uname_info.release, "%u.%u.%u", &kern_major, &kern_medium, &kern_minor ) != 3 )
+	{
+		fprintf( stderr, "Failed to parse running kernel version %s, assuming bad!\n", uname_info.release);
+		return( -1 );
+	}
+	if ( sscanf ( minimum_version, "%u.%u.%u", &min_major, &min_medium, &min_minor ) != 3 )
+	{
+		fprintf( stderr, "Failed to parse minimum kernel version %s, assuming bad!\n", minimum_version);
+		return( -1 );
+	}
+
+	if ( kern_major > min_major )
+		return( 0 );
+	if ( kern_major < min_major )
+		return( -1 );
+	if ( kern_medium > min_medium )
+		return( 0 );
+	if ( kern_medium < min_medium )
+		return( -1 );
+	if ( kern_minor < min_minor )
+		return( -1 );
+
+	return( 0 );
+}
 
 static u64 parse_size(char *s)
 {
@@ -271,6 +322,7 @@ static void print_usage(void)
 	fprintf(stderr, "\t -A --alloc-start the offset to start the FS\n");
 	fprintf(stderr, "\t -b --byte-count total number of bytes in the FS\n");
 	fprintf(stderr, "\t -d --data data profile, raid0, raid1, raid10 or single\n");
+	fprintf(stderr, "\t -f --force force mkfs.btrfs to continue in the face of warnings\n");
 	fprintf(stderr, "\t -l --leafsize size of btree leaves\n");
 	fprintf(stderr, "\t -L --label set a label\n");
 	fprintf(stderr, "\t -m --metadata metadata profile, values like data profile\n");
@@ -325,6 +377,7 @@ static char *parse_label(char *input)
 static struct option long_options[] = {
 	{ "alloc-start", 1, NULL, 'A'},
 	{ "byte-count", 1, NULL, 'b' },
+	{ "force", 0, NULL, 'f' },
 	{ "leafsize", 1, NULL, 'l' },
 	{ "label", 1, NULL, 'L'},
 	{ "metadata", 1, NULL, 'm' },
@@ -358,10 +411,11 @@ int main(int ac, char **av)
 	int first_fd;
 	int ret;
 	int i;
+	int force=0;
 
 	while(1) {
 		int c;
-		c = getopt_long(ac, av, "A:b:l:n:s:m:d:L:V", long_options,
+		c = getopt_long(ac, av, "A:b:fl:n:s:m:d:L:V", long_options,
 				&option_index);
 		if (c < 0)
 			break;
@@ -372,6 +426,9 @@ int main(int ac, char **av)
 			case 'd':
 				data_profile = parse_profile(optarg);
 				break;
+			case 'f':
+				force=1;
+				break;
 			case 'l':
 				leafsize = parse_size(optarg);
 				break;
@@ -421,6 +478,23 @@ int main(int ac, char **av)
 	printf("\nWARNING! - %s IS EXPERIMENTAL\n", BTRFS_BUILD_VERSION);
 	printf("WARNING! - see http://btrfs.wiki.kernel.org before using\n\n");
 
+	/* Check minimum kernel version for this version of btrfs */
+	if ( check_kernel_version( MINIMUM_KERNEL ) )
+	{
+		fprintf( stderr, "WARNING! - Your kernel is too old to support this btrfs filesystem.\n" );
+		fprintf( stderr, "WARNING! - You need at least kernel %s to be able to mount it.\n", MINIMUM_KERNEL );
+		if ( !force )
+		{
+			fprintf( stderr, "WARNING! - Specify --force or -f to make this filesystem anyway\n\n" );
+			exit( 1 );
+		}
+		else
+		{
+			/* Newline to space the warning out from messages about making the filesystem */
+			fprintf( stderr, "\n" );
+		}
+	}
+
 	file = av[optind++];
 	ret = check_mounted(file);
 	if (ret < 0) {
-- 
1.6.0.4

