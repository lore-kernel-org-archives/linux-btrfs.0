From: Sergei Trofimovich <slyfox@gentoo.org>
Subject: [PATCH 3/9] mkfs.btrfs: fail on scandir error (-r mode)
Date: Tue, 31 May 2011 00:19:02 +0300
Message-ID: <1306790348-9553-4-git-send-email-slyfox@gentoo.org>
References: <1306790348-9553-1-git-send-email-slyfox@gentoo.org>
Cc: linux-btrfs@vger.kernel.org, Sergei Trofimovich <slyfox@gentoo.org>
To: Chris Mason <chris.mason@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1306790348-9553-1-git-send-email-slyfox@gentoo.org>
List-ID: <linux-btrfs.vger.kernel.org>

mkfs.btrfs does not handle relative pathnames for now. When
they are passed to it it creates empty image. So first time
I thought it does not work at all.

This patch adds error handling for scandir(). With patch it behaves
this way:

    $ mkfs.btrfs -r ./root
    ...
    fs created label (null) on output.img
            nodesize 4096 leafsize 4096 sectorsize 4096 size 256.00MB
    Btrfs v0.19-52-g438c5ff-dirty
    scandir for ./root failed: No such file or directory
    unable to traverse_directory
    Making image is aborted.
    mkfs.btrfs: mkfs.c:1402: main: Assertion `!(ret)' failed.

Signed-off-by: Sergei Trofimovich <slyfox@gentoo.org>
---
 mkfs.c |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/mkfs.c b/mkfs.c
index 57c88f9..9d7b792 100644
--- a/mkfs.c
+++ b/mkfs.c
@@ -895,6 +895,12 @@ static int traverse_directory(struct btrfs_trans_handle *trans,
 
 		count = scandir(parent_dir_entry->path, &files,
 				directory_select, NULL);
+		if (count == -1)
+		{
+			fprintf(stderr, "scandir for %s failed: %s\n",
+				parent_dir_name, strerror (errno));
+			goto fail;
+		}
 
 		for (i = 0; i < count; i++) {
 			cur_file = files[i];
-- 
1.7.3.4

