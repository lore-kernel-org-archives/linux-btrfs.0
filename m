From: Jim Meyering <jim@meyering.net>
Subject: [PATCHv3 2/4] restore: don't corrupt stack for a zero-length command-line argument
Date: Sat, 21 Apr 2012 09:50:15 +0200
Message-ID: <1334994617-30016-3-git-send-email-jim@meyering.net>
References: <1334994617-30016-1-git-send-email-jim@meyering.net>
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1334994617-30016-1-git-send-email-jim@meyering.net>
List-ID: <linux-btrfs.vger.kernel.org>

From: Jim Meyering <meyering@redhat.com>

Given a zero-length directory name, the trailing-slash removal
code would test dir_name[-1], and if it were found to be a slash,
would set it to '\0'.

Reviewed-by: Josef Bacik <josef@redhat.com>
---
 restore.c |    8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/restore.c b/restore.c
index 250c9d3..2674832 100644
--- a/restore.c
+++ b/restore.c
@@ -849,11 +849,9 @@ int main(int argc, char **argv)
 	strncpy(dir_name, argv[optind + 1], 128);

 	/* Strip the trailing / on the dir name */
-	while (1) {
-		len = strlen(dir_name);
-		if (dir_name[len - 1] != '/')
-			break;
-		dir_name[len - 1] = '\0';
+	len = strlen(dir_name);
+	while (len && dir_name[--len] == '/') {
+		dir_name[len] = '\0';
 	}

 	if (find_dir) {
-- 
1.7.10.228.g81f95

