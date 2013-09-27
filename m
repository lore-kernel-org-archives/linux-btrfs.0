Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:35760 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752267Ab3I0Qpw (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 27 Sep 2013 12:45:52 -0400
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz
Subject: [PATCH] btrfs-progs: calculate disk space that a subvol could free
Date: Sat, 28 Sep 2013 00:45:29 +0800
Message-Id: <1380300329-9123-1-git-send-email-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

It needs a lot more information about the snapshots if
snapshot's life cycle has to be all auto managed by
scripts _some day_.  this patch is a step towards that.

This patch provides the size which would be freed
if the subvol/snapshot is deleted.
preview:
---------------------
btrfs su show /btrfs/sv1
::
	Unshared space: 	89.09MiB
---------------------

v2: rename to 'unshared space' and edit commit text

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
 cmds-subvolume.c |   5 ++
 utils.c          | 154 +++++++++++++++++++++++++++++++++++++++++++++++++++++++
 utils.h          |   1 +
 3 files changed, 160 insertions(+)

diff --git a/cmds-subvolume.c b/cmds-subvolume.c
index de246ab..0f36cde 100644
--- a/cmds-subvolume.c
+++ b/cmds-subvolume.c
@@ -809,6 +809,7 @@ static int cmd_subvol_show(int argc, char **argv)
 	int fd = -1, mntfd = -1;
 	int ret = 1;
 	DIR *dirstream1 = NULL, *dirstream2 = NULL;
+	u64 freeable_bytes;
 
 	if (check_argc_exact(argc, 2))
 		usage(cmd_subvol_show_usage);
@@ -878,6 +879,8 @@ static int cmd_subvol_show(int argc, char **argv)
 		goto out;
 	}
 
+	freeable_bytes = get_subvol_freeable_bytes(fd);
+
 	ret = 0;
 	/* print the info */
 	printf("%s\n", fullpath);
@@ -915,6 +918,8 @@ static int cmd_subvol_show(int argc, char **argv)
 	else
 		printf("\tFlags: \t\t\t-\n");
 
+	printf("\tUnshared space: \t%s\n",
+		pretty_size(freeable_bytes));
 	/* print the snapshots of the given subvol if any*/
 	printf("\tSnapshot(s):\n");
 	filter_set = btrfs_list_alloc_filter_set();
diff --git a/utils.c b/utils.c
index ccb5199..ca30485 100644
--- a/utils.c
+++ b/utils.c
@@ -2062,3 +2062,157 @@ int lookup_ino_rootid(int fd, u64 *rootid)
 
 	return 0;
 }
+
+/* gets the ref count for given extent
+ * 0 = didn't find the item
+ * n = number of references
+*/
+u64 get_extent_refcnt(int fd, u64 disk_blk)
+{
+	int ret = 0, i, e;
+	struct btrfs_ioctl_search_args args;
+	struct btrfs_ioctl_search_key *sk = &args.key;
+	struct btrfs_ioctl_search_header sh;
+	unsigned long off = 0;
+
+	memset(&args, 0, sizeof(args));
+
+	sk->tree_id = BTRFS_EXTENT_TREE_OBJECTID;
+
+	sk->min_type = BTRFS_EXTENT_ITEM_KEY;
+	sk->max_type = BTRFS_EXTENT_ITEM_KEY;
+
+	sk->min_objectid = disk_blk;
+	sk->max_objectid = disk_blk;
+
+	sk->max_offset = (u64)-1;
+	sk->max_transid = (u64)-1;
+
+	while (1) {
+		sk->nr_items = 4096;
+
+		ret = ioctl(fd, BTRFS_IOC_TREE_SEARCH, &args);
+		e = errno;
+		if (ret < 0) {
+			fprintf(stderr, "ERROR: search failed - %s\n",
+				strerror(e));
+			return 0;
+		}
+		if (sk->nr_items == 0)
+			break;
+
+		off = 0;
+		for (i = 0; i < sk->nr_items; i++) {
+			struct btrfs_extent_item *ei;
+			u64 ref;
+
+			memcpy(&sh, args.buf + off, sizeof(sh));
+			off += sizeof(sh);
+
+			if (sh.type != BTRFS_EXTENT_ITEM_KEY) {
+				off += sh.len;
+				continue;
+			}
+
+			ei = (struct btrfs_extent_item *)(args.buf + off);
+			ref = btrfs_stack_extent_refs(ei);
+			return ref;
+		}
+		sk->min_objectid = sh.objectid;
+		sk->min_offset = sh.offset;
+		sk->min_type = sh.type;
+		if (sk->min_offset < (u64)-1)
+			sk->min_offset++;
+		else if (sk->min_objectid < (u64)-1) {
+			sk->min_objectid++;
+			sk->min_offset = 0;
+			sk->min_type = 0;
+		} else
+			break;
+	}
+	return 0;
+}
+
+u64 get_subvol_freeable_bytes(int fd)
+{
+	int ret = 0, i, e;
+	struct btrfs_ioctl_search_args args;
+	struct btrfs_ioctl_search_key *sk = &args.key;
+	struct btrfs_ioctl_search_header sh;
+	unsigned long off = 0;
+	u64 size_bytes = 0;
+
+	memset(&args, 0, sizeof(args));
+
+	sk->tree_id = 0;
+
+	sk->min_type = BTRFS_EXTENT_DATA_KEY;
+	sk->max_type = BTRFS_EXTENT_DATA_KEY;
+
+	sk->max_objectid = (u64) -1;
+	sk->max_offset = (u64)-1;
+	sk->max_transid = (u64)-1;
+
+	while (1) {
+		sk->nr_items = 4096;
+
+		ret = ioctl(fd, BTRFS_IOC_TREE_SEARCH, &args);
+		e = errno;
+		if (ret < 0) {
+			fprintf(stderr, "ERROR: search failed - %s\n",
+				strerror(e));
+			return 0;
+		}
+		if (sk->nr_items == 0)
+			break;
+
+		off = 0;
+		for (i = 0; i < sk->nr_items; i++) {
+			struct btrfs_file_extent_item *efi;
+			u64 disk_bytenr = 0;
+			u64 num_bytes = 0;
+			u64 refcnt;
+			u8 type;
+
+			memcpy(&sh, args.buf + off, sizeof(sh));
+			off += sizeof(sh);
+
+			if (sh.type != BTRFS_EXTENT_DATA_KEY) {
+				off += sh.len;
+				continue;
+			}
+
+			efi = (struct btrfs_file_extent_item *)(args.buf + off);
+			type = btrfs_stack_file_extent_type(efi);
+
+			if (type == BTRFS_FILE_EXTENT_INLINE) {
+				size_bytes +=
+					btrfs_stack_file_extent_ram_bytes(efi);
+				goto skip_extent_data;
+			}
+			disk_bytenr = btrfs_stack_file_extent_disk_bytenr(efi);
+			num_bytes = btrfs_stack_file_extent_num_bytes(efi);
+
+			if (disk_bytenr) {
+				refcnt = get_extent_refcnt(fd, disk_bytenr);
+				if (refcnt == 1)
+					size_bytes += num_bytes;
+			}
+skip_extent_data:
+			off += sh.len;
+		}
+		sk->min_objectid = sh.objectid;
+		sk->min_offset = sh.offset;
+		sk->min_type = sh.type;
+
+		if (sk->min_offset < (u64)-1)
+			sk->min_offset++;
+		else if (sk->min_objectid < (u64)-1) {
+			sk->min_objectid++;
+			sk->min_offset = 0;
+			sk->min_type = 0;
+		} else
+			break;
+	}
+	return size_bytes;
+}
diff --git a/utils.h b/utils.h
index 0f31db7..4ddcf09 100644
--- a/utils.h
+++ b/utils.h
@@ -91,5 +91,6 @@ int csum_tree_block(struct btrfs_root *root, struct extent_buffer *buf,
 int ask_user(char *question);
 int lookup_ino_rootid(int fd, u64 *rootid);
 int btrfs_scan_lblkid(int update_kernel);
+u64 get_subvol_freeable_bytes(int fd);
 
 #endif
-- 
1.8.4.rc4.1.g0d8beaa

