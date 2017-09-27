Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:53422 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751907AbdI0PFT (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 27 Sep 2017 11:05:19 -0400
Date: Wed, 27 Sep 2017 17:03:45 +0200
From: David Sterba <dsterba@suse.cz>
To: "Misono, Tomohiro" <misono.tomohiro@jp.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v2 5/5] btrfs-progs: subvol: fix subvol del --commit-after
Message-ID: <20170927150345.GK31640@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <7610069d-bd81-2239-0be8-6635478c2dda@jp.fujitsu.com>
 <7490b4c4-411a-d328-d516-5372a5fef9df@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <7490b4c4-411a-d328-d516-5372a5fef9df@jp.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Sep 27, 2017 at 11:03:48AM +0900, Misono, Tomohiro wrote:
> Fix subvol del --commit-after to work properly:
>  - SYNC ioctl will be issued even when last delete is failed
>  - SYNC ioctl will be issued on each file system only once in the end
> 
> To achieve this, get_fsid() and add_seen_fsid() is called after each delete
> to keep only one fd for each fs.
> 
> In the end, seen_fsid_hash will be traversed and SYNC is issued on each fs.
> 
> Signed-off-by: Tomohiro Misono <misono.tomohiro@jp.fujitsu.com>
> Reviewed-by: Qu Wenruo <quwenruo.btrfs@gmx.com>

Review comments from me in a form of diff, coding style issues:

diff --git a/cmds-subvolume.c b/cmds-subvolume.c
index 00931a55807e..69c50387a984 100644
--- a/cmds-subvolume.c
+++ b/cmds-subvolume.c
@@ -265,7 +265,7 @@ static int cmd_subvol_delete(int argc, char **argv)
 	int commit_mode = 0;
 	u8 fsid[BTRFS_FSID_SIZE];
 	char uuidbuf[BTRFS_UUID_UNPARSED_SIZE];
-	struct seen_fsid *seen_fsid_hash[SEEN_FSID_HASH_SIZE] = {NULL,};
+	struct seen_fsid *seen_fsid_hash[SEEN_FSID_HASH_SIZE] = { NULL, };
 	enum { COMMIT_AFTER = 1, COMMIT_EACH = 2 };
 
 	while (1) {
@@ -364,8 +364,10 @@ static int cmd_subvol_delete(int argc, char **argv)
 	} else if (commit_mode == COMMIT_AFTER) {
 		res = get_fsid(dname, fsid, 0);
 		if (res < 0) {
-			error("unable to get fsid for '%s': %s", path, strerror(-res));
-			error("delete suceeded but commit may not be done in the end");
+			error("unable to get fsid for '%s': %s",
+				path, strerror(-res));
+			error(
+			"delete suceeded but commit may not be done in the end");
 			ret = 1;
 			goto out;
 		}
@@ -373,10 +375,14 @@ static int cmd_subvol_delete(int argc, char **argv)
 		if (add_seen_fsid(fsid, seen_fsid_hash, fd, dirstream) == 0) {
 			if (verbose > 0) {
 				uuid_unparse(fsid, uuidbuf);
-				printf("  new fs is found for '%s', fsid: %s\n", path, uuidbuf);
+				printf("  new fs is found for '%s', fsid: %s\n",
+						path, uuidbuf);
 			}
-			// this is the first time a subvolume on this filesystem is deleted
-			// keep fd in order to issue SYNC ioctl in the end
+			/*
+			 * This is the first time a subvolume on this
+			 * filesystem is deleted, keep fd in order to issue
+			 * SYNC ioctl in the end
+			 */
 			goto keep_fd;
 		}
 	}
@@ -395,27 +401,32 @@ static int cmd_subvol_delete(int argc, char **argv)
 		goto again;
 
 	if (commit_mode == COMMIT_AFTER) {
-		// traverse seen_fsid_hash and issue SYNC ioctl on each filesystem
 		int slot;
-		struct seen_fsid *seen;
 
+		/*
+		 * Traverse seen_fsid_hash and issue SYNC ioctl on each
+		 * filesystem
+		 */
 		for (slot = 0; slot < SEEN_FSID_HASH_SIZE; slot++) {
-			seen = seen_fsid_hash[slot];
+			struct seen_fsid *seen = seen_fsid_hash[slot];
+
 			while (seen) {
 				res = wait_for_commit(seen->fd);
 				if (res < 0) {
 					uuid_unparse(seen->fsid, uuidbuf);
-					error("unable to do final sync after deletion: %s, fsid: %s",
+					error(
+			"unable to do final sync after deletion: %s, fsid: %s",
 						strerror(errno), uuidbuf);
 					ret = 1;
 				} else if (verbose > 0) {
 					uuid_unparse(seen->fsid, uuidbuf);
-					printf("final sync is done for fsid: %s\n", uuidbuf);
+					printf("final sync is done for fsid: %s\n",
+						uuidbuf);
 				}
 				seen = seen->next;
 			}
 		}
-		// fd will also be closed in free_seen_fsid
+		/* fd will also be closed in free_seen_fsid */
 		free_seen_fsid(seen_fsid_hash);
 	}
