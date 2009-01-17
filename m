From: Jan Engelhardt <jengelh@medozas.de>
Subject: btrfs: readdir problem workaround for 32-bit off_t
Date: Sat, 17 Jan 2009 20:39:17 +0100 (CET)
Message-ID: <alpine.LSU.2.00.0901172026180.14987@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: bug-glibc@gnu.org,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hi,



I am seeing abnormal kernel<->userland interaction for range-exceeding 
offsets during readdir.
A suggested patch for btrfs is below, but I think there could also
be involvement of (read: a bug in) Glibc.
Would the copied parties please have a look, as it may spans both glibc 
and btrfs.


Thanks,
Jan

parent 81841fa96da5597a411f5f274a664f186b2d2549 (v2.6.29-rc2-21-g81841fa)
commit fa8ea6611fedecba8e5fdf2a5dfd82affa5a982e
Author: Jan Engelhardt <jengelh@medozas.de>
Date:   Sat Jan 17 20:26:25 2009 +0100

btrfs: readdir problem workaround for 32-bit off_t

Kernel is i586, as is the userland.

btrfs sets filp->f_pos == (2^63-1) when it has reached the
end of a directory. This is problematic.

In obtuse 32-bit mode (no _FILE_OFFSET_BITS), readdir(3) will not return 
the last entry.

However, when compiled with -D_FILE_OFFSET_BITS=64, it will return the 
last entry. But telldir() will return (uint32_t)-1, which does not quite 
match up with the 2^63-1.

	$ cat test.c
	#include <dirent.h>
	#include <stdio.h>

	int main(int argc, const char **argv)
	{
		DIR *r = opendir(argv[1]);
		struct dirent *de;

		while ((de = readdir(r)) != NULL)
			printf("%lld %s\n", (long long)telldir(r), de->d_name);
		return 0;
	}
	$ gcc test.c -o test -ggdb3
	$ ./test /tmp/z
	2 .
	2 ..
	3 a
	4 b
	5 lib

	$ gcc test.c -o test -ggdb3 -D_FILE_OFFSET_BITS=64
	$ ./test /tmp/z
	2 .
	2 ..
	3 a
	4 b
	5 lib
	4294967295 strace.log

This has deep effects and my boot hangs. (Got btrfs as the root fs.)

I have no idea who exactly of Glibc and btrfs is at fault with what,
but this change makes btrfs usable for the moment.

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 fs/btrfs/inode.c |    5 +----
 1 files changed, 1 insertions(+), 4 deletions(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 8adfe05..901be02 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -3264,10 +3264,7 @@ skip:
 	}
 
 	/* Reached end of directory/root. Bump pos past the last item. */
-	if (key_type == BTRFS_DIR_INDEX_KEY)
-		filp->f_pos = INT_LIMIT(typeof(filp->f_pos));
-	else
-		filp->f_pos++;
+	filp->f_pos++;
 nopos:
 	ret = 0;
 err:
-- 
# Created with git-export-patch

