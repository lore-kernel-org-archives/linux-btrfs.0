Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pf0-f174.google.com ([209.85.192.174]:34065 "EHLO
	mail-pf0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755652AbcASTnD (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 19 Jan 2016 14:43:03 -0500
Received: by mail-pf0-f174.google.com with SMTP id q63so185819324pfb.1
        for <linux-btrfs@vger.kernel.org>; Tue, 19 Jan 2016 11:43:03 -0800 (PST)
From: "Lakshmipathi.G" <lakshmipathi.g@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: "Lakshmipathi.G" <Lakshmipathi.G@giis.co.in>
Subject: [PATCH][btrfs-progs] Add dump-csums for btrfs inspect-internal
Date: Wed, 20 Jan 2016 01:12:39 +0530
Message-Id: <1453232559-27125-1-git-send-email-Lakshmipathi.G@giis.co.in>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: "Lakshmipathi.G" <Lakshmipathi.G@giis.co.in>

Example usage:
btrfs inspect-internal dump-csums /btrfs/50gbfile /dev/sda4
csum for /btrfs/50gbfile dumped to /btrfs/50gbfile.csumdump

Signed-off-by: Lakshmipathi.G <Lakshmipathi.G@giis.co.in>
---
 cmds-inspect.c | 221 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 221 insertions(+)

diff --git a/cmds-inspect.c b/cmds-inspect.c
index 7fa4881..fbe9130 100644
--- a/cmds-inspect.c
+++ b/cmds-inspect.c
@@ -31,6 +31,7 @@
 #include "disk-io.h"
 #include "commands.h"
 #include "btrfs-list.h"
+#include "volumes.h"
 
 static const char * const inspect_cmd_group_usage[] = {
 	"btrfs inspect-internal <command> <args>",
@@ -618,6 +619,224 @@ static int cmd_inspect_min_dev_size(int argc, char **argv)
 out:
 	return !!ret;
 }
+static const char* const cmd_inspect_dump_csums_usage[] = {
+	"btrfs inspect-internal dump-csums <path> <device>",
+	"Get csums for the given file.",
+	NULL
+};
+
+
+int btrfs_lookup_csums(struct btrfs_trans_handle *trans, struct btrfs_root *root,
+		  struct btrfs_path *path, u64 bytenr, int cow, int total_csums, FILE *fp)
+{
+	int ret;
+	int i;
+	int start_pos = 0;
+	struct btrfs_key file_key;
+	struct btrfs_key found_key;
+	struct btrfs_csum_item *item;
+	struct extent_buffer *leaf;
+	u64 csum_offset = 0;
+	u16 csum_size =
+		btrfs_super_csum_size(root->fs_info->super_copy);
+	int csums_in_item = 0;
+	unsigned int tree_csum = NULL;
+	int pending_csums = total_csums;
+	static int cnt=1;
+
+	file_key.objectid = BTRFS_EXTENT_CSUM_OBJECTID;
+	file_key.offset = bytenr;
+	btrfs_set_key_type(&file_key, BTRFS_EXTENT_CSUM_KEY);
+	ret = btrfs_search_slot(trans, root, &file_key, path, 0, cow);
+	if (ret < 0)
+		goto fail;
+	while(1){
+		leaf = path->nodes[0];
+		if (ret > 0) {
+			ret = 1;
+			if (path->slots[0] == 0)
+				goto fail; 
+			path->slots[0]--;
+			btrfs_item_key_to_cpu(leaf, &found_key, path->slots[0]);
+			if (btrfs_key_type(&found_key) != BTRFS_EXTENT_CSUM_KEY){
+				fprintf(stderr, "\nInvalid key found.");
+				goto fail;
+			}
+
+			csum_offset = ((bytenr - found_key.offset) / root->sectorsize) * csum_size;
+			csums_in_item = btrfs_item_size_nr(leaf, path->slots[0]);
+			csums_in_item /= csum_size;
+			csums_in_item -= ( bytenr - found_key.offset ) / root->sectorsize;
+			start_pos=csum_offset;
+		}
+		if (path->slots[0] >= btrfs_header_nritems(leaf)) {
+			if (pending_csums > 0){
+				ret = btrfs_next_leaf(root, path);
+				if (ret == 0)
+				      continue;
+			}
+		}
+		item = btrfs_item_ptr(leaf, path->slots[0], struct btrfs_csum_item);
+		btrfs_item_key_to_cpu(leaf, &found_key, path->slots[0]);
+		if (!ret){
+			start_pos=0;
+			csum_offset = ( bytenr - found_key.offset ) / root->sectorsize;
+			csums_in_item = btrfs_item_size_nr(leaf, path->slots[0]);
+			csums_in_item /= csum_size;
+		}
+		if (csums_in_item > pending_csums){
+			//possibly,some other csums on this item.
+			for(i = 0; i < pending_csums; i++, cnt++){
+			read_extent_buffer(leaf, &tree_csum, 
+					(unsigned long)item + ((i*4)+start_pos) , csum_size);
+			fprintf(fp, "%x ", tree_csum);
+			if (cnt % 8 == 0)
+				fprintf(fp, "\n");
+			}
+			pending_csums = 0;
+			return 0;
+		}else{
+			for(i = 0; i < csums_in_item; i++, cnt++){
+			read_extent_buffer(leaf, &tree_csum, 
+					(unsigned long)item+((i*4)+start_pos), csum_size);
+			fprintf(fp, "%x ", tree_csum);
+			if (cnt % 8 == 0)
+				fprintf(fp, "\n");
+			}
+		}
+		pending_csums -= csums_in_item;
+		ret = 0;
+		if (pending_csums > 0){
+			path->slots[0]++;
+
+		}else
+			return 0; 
+	
+	}
+fail:
+	fprintf(stderr, "btrfs_lookup_csums search failed.");
+	if (ret > 0)
+		ret = -ENOENT;
+	return ret;
+}
+
+int btrfs_lookup_extent(struct btrfs_fs_info *info, struct btrfs_path *path,
+		u64 ino, int cow, FILE *fp){
+	struct btrfs_key key;
+	struct btrfs_key found_key;
+	struct btrfs_file_extent_item *fi;
+	struct extent_buffer *leaf;
+	struct btrfs_root *fs_root;
+	int ret = -1;
+	int slot;
+	int total_csums = 0;
+	u64 bytenr;
+	u64 itemnum = 0;
+	struct btrfs_path *path1 = NULL;
+
+	fs_root = info->fs_root;
+	key.objectid = ino;
+	key.type = BTRFS_EXTENT_DATA_KEY;
+	key.offset = 0;
+	ret = btrfs_search_slot(NULL,fs_root,&key,path,0,0);
+
+	if(ret < 0)
+		goto error;
+
+	if (ret > 1){
+		fprintf(stderr, "Unable to find the entry");
+		return ret;
+	}
+
+	while(1){
+		leaf = path->nodes[0];
+		slot = path->slots[0];
+		if (slot >=  btrfs_header_nritems(leaf)){
+		       ret = btrfs_next_leaf(fs_root, path);
+			       if (ret == 0)
+				      continue;
+			       if (ret < 0)
+				      goto error;
+		}
+		btrfs_item_key_to_cpu(leaf, &found_key, slot);
+		if (found_key.type != BTRFS_EXTENT_DATA_KEY){
+			btrfs_release_path(path);
+			return -EINVAL;
+		}
+
+		fi = btrfs_item_ptr(leaf, slot, struct btrfs_file_extent_item);
+		bytenr = btrfs_file_extent_disk_bytenr(leaf, fi);
+		total_csums=(btrfs_file_extent_num_bytes(leaf, fi) / 1024) / 4;
+		path->slots[0]++; //move to next item/slot
+		itemnum++;
+		path1 = btrfs_alloc_path();
+	 	ret = btrfs_lookup_csums(NULL,info->csum_root, path1, bytenr, 0,
+			       	total_csums, fp);
+		btrfs_release_path(path1);
+		if (ret) {
+			fprintf(stderr, "\n Error: btrfs_lookup_csum");
+			return 1;
+		}
+	}
+
+error:
+	btrfs_release_path(path);
+	return ret;
+}
+
+static int cmd_inspect_dump_csums(int argc, char **argv)
+{
+	struct btrfs_fs_info *info;
+	int ret;
+	struct btrfs_path path;
+	FILE *fp;
+	struct stat st;
+	char *filename;
+	char *outfile;
+
+	if (check_argc_exact(argc, 3))
+		usage(cmd_inspect_dump_csums_usage);
+
+	filename = argv[1];
+	info = open_ctree_fs_info(argv[2], 0, 0, OPEN_CTREE_PARTIAL);
+	if (!info) {
+		fprintf(stderr, "unable to open %s\n", argv[2]);
+	        exit(1);
+	}
+
+	ret = stat(filename, &st);
+	if (ret < 0)	{
+		fprintf(stderr, "unable to open %s\n", filename);
+		exit(1);
+	}
+
+	if(st.st_size < 1024){
+		fprintf(stderr, "file less than 1KB.abort%lu", (st.st_size ));
+		exit(1);
+	}
+
+	btrfs_init_path(&path);
+	ret = asprintf(&outfile, "%s.csumdump", filename);
+	if (ret == -1){
+		fprintf(stderr, "memory allocation failed.");
+		return -1;
+	}
+	fp = fopen(outfile, "w+");
+	if (NULL == fp) {
+		fprintf(stderr, "Unable to open %s file", outfile);
+		free(outfile);
+		return -1;
+	}
+	ret = btrfs_lookup_extent(info, &path, st.st_ino, 0, fp);
+	fclose(fp);
+	ret = close_ctree(info->fs_root);
+	btrfs_close_all_devices();
+
+	fprintf(stdout, "csum for %s dumped to %s\n ", filename, outfile);
+	free(outfile);
+	return ret;
+
+}
 
 static const char inspect_cmd_group_info[] =
 "query various internal information";
@@ -634,6 +853,8 @@ const struct cmd_group inspect_cmd_group = {
 			0 },
 		{ "min-dev-size", cmd_inspect_min_dev_size,
 			cmd_inspect_min_dev_size_usage, NULL, 0 },
+		{ "dump-csums", cmd_inspect_dump_csums,
+			cmd_inspect_dump_csums_usage, NULL, 0 },
 		NULL_CMD_STRUCT
 	}
 };
-- 
1.8.3.1

