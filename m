From: Josef Bacik <josef@redhat.com>
Subject: [PATCH] Btrfs-progs: make btrfs filesystem show <uuid> actually work
Date: Wed, 25 Apr 2012 14:22:32 -0400
Message-ID: <1335378152-19215-1-git-send-email-josef@redhat.com>
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

The btrfs filesystem show command is only actually searching for labels,
it's not searching for UUID's at all.  This patch fixes that problem.
Thanks,

Signed-off-by: Josef Bacik <josef@redhat.com>
---
 cmds-filesystem.c |    7 +++++++
 1 files changed, 7 insertions(+), 0 deletions(-)

diff --git a/cmds-filesystem.c b/cmds-filesystem.c
index 1f53d1c..ff98a77 100644
--- a/cmds-filesystem.c
+++ b/cmds-filesystem.c
@@ -155,8 +155,15 @@ static int cmd_df(int argc, char **argv)
 
 static int uuid_search(struct btrfs_fs_devices *fs_devices, char *search)
 {
+	char uuidbuf[37];
 	struct list_head *cur;
 	struct btrfs_device *device;
+	int search_len = strlen(search);
+
+	search_len = min(search_len, 37);
+	uuid_unparse(fs_devices->fsid, uuidbuf);
+	if (!strncmp(uuidbuf, search, search_len))
+		return 1;
 
 	list_for_each(cur, &fs_devices->devices) {
 		device = list_entry(cur, struct btrfs_device, dev_list);
-- 
1.7.7.6

