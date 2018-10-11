Return-Path: <SRS0=9zVn=MX=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 360B5C32788
	for <linux-btrfs@archiver.kernel.org>; Thu, 11 Oct 2018 15:04:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id F32CF2075C
	for <linux-btrfs@archiver.kernel.org>; Thu, 11 Oct 2018 15:04:17 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org F32CF2075C
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=suse.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728002AbeJKWbs (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 11 Oct 2018 18:31:48 -0400
Received: from mx2.suse.de ([195.135.220.15]:50048 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727864AbeJKWbo (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 11 Oct 2018 18:31:44 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay1.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 1A9F1B616
        for <linux-btrfs@vger.kernel.org>; Thu, 11 Oct 2018 15:04:08 +0000 (UTC)
From:   Nikolay Borisov <nborisov@suse.com>
To:     linux-btrfs@vger.kernel.org
Cc:     Nikolay Borisov <nborisov@suse.com>
Subject: [PATCH 4/8] btrfstune: Add support for changing the user uuid
Date:   Thu, 11 Oct 2018 18:04:00 +0300
Message-Id: <1539270244-27076-5-git-send-email-nborisov@suse.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1539270244-27076-1-git-send-email-nborisov@suse.com>
References: <1539270244-27076-1-git-send-email-nborisov@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

This allows us to change the use-visible UUID on filesytems from
userspace if desired, by copying the existing UUID to the new location
for metadata comparisons. If this is done, an incompat flag must be
set to prevent older filesystems from mounting the filesystem, but
the original UUID can be restored, and the incompat flag removed.

This introduces the new -m|-M UUID options similar to current
-u|-U UUID ones with the difference that we don't rewrite the fsid but
just copy the old uuid and set a new one. Additionally running with
[-M old-uuid] clears the incompat flag and retains only fsid on-disk.

Additionally it's not allowed to intermix -m/-u/-U/-M options in a
single invocation of btrfstune, nor is it allowed to change the uuid
while there is a uuid rewrite in-progress. Also changing the uuid of a
seed device is not currently allowed (can change in the future).

Example:

btrfstune -m /dev/loop1
btrfs inspect-internal dump-super /dev/loop1

superblock: bytenr=65536, device=/dev/loop1
---------------------------------------------------------
csum_type		0 (crc32c)
csum_size		4
csum			0x4b7ea749 [match]

<ommitted for brevity>

fsid			0efc41d3-4451-49f3-8108-7b8bdbcf5ae8
metadata_uuid		352715e7-62cf-4ae0-92ee-85a574adc318

<ommitted for brevity>

incompat_flags		0x541
			( MIXED_BACKREF |
			  EXTENDED_IREF |
			  SKINNY_METADATA |
			  METADATA_UUID )

<omitted for brevity>

dev_item.uuid		0610deee-dfc3-498b-9449-a06533cdec98
dev_item.fsid		352715e7-62cf-4ae0-92ee-85a574adc318 [match]

<ommitted for brevity>

mount /dev/loop1 btrfs-mnt/
btrfs fi show btrfs-mnt/

Label: none  uuid: 0efc41d3-4451-49f3-8108-7b8bdbcf5ae8
	Total devices 1 FS bytes used 128.00KiB
	devid    1 size 5.00GiB used 536.00MiB path /dev/loop1

In this case a new btrfs filesystem was created and the original uuid
was 352715e7-62cf-4ae0-92ee-85a574adc318, then btrfstune was run which
copied that value over to metadata_uuid field and set the current fsid
to 0efc41d3-4451-49f3-8108-7b8bdbcf5ae8. And as far as userspace is
concerned this is the fsid of the fs.

Signed-off-by: Nikolay Borisov <nborisov@suse.com>
---
 btrfstune.c | 184 +++++++++++++++++++++++++++++++++++++++++++++++++++---------
 ctree.h     |   1 +
 2 files changed, 160 insertions(+), 25 deletions(-)

diff --git a/btrfstune.c b/btrfstune.c
index 62a075b2defc..29610476cd99 100644
--- a/btrfstune.c
+++ b/btrfstune.c
@@ -73,6 +73,117 @@ static int update_seeding_flag(struct btrfs_root *root, int set_flag)
 	return ret;
 }
 
+/*
+ * Return 0 for no unfinished fsid change.
+ * Return >0 for unfinished fsid change, and restore unfinished fsid/
+ * chunk_tree_id into fsid_ret/chunk_id_ret.
+ */
+static int check_unfinished_fsid_change(struct btrfs_fs_info *fs_info,
+					uuid_t fsid_ret, uuid_t chunk_id_ret)
+{
+	struct btrfs_root *tree_root = fs_info->tree_root;
+	u64 flags = btrfs_super_flags(fs_info->super_copy);
+
+	if (flags & (BTRFS_SUPER_FLAG_CHANGING_FSID |
+		     BTRFS_SUPER_FLAG_CHANGING_FSID_V2)) {
+		memcpy(fsid_ret, fs_info->super_copy->fsid, BTRFS_FSID_SIZE);
+		read_extent_buffer(tree_root->node, chunk_id_ret,
+				btrfs_header_chunk_tree_uuid(tree_root->node),
+				BTRFS_UUID_SIZE);
+		return 1;
+	}
+	return 0;
+}
+
+static int set_metadata_uuid(struct btrfs_root *root, const char *uuid_string)
+{
+	struct btrfs_super_block *disk_super;
+	uuid_t new_fsid, unused1, unused2;
+	struct btrfs_trans_handle *trans;
+	bool new_uuid = true;
+	u64 incompat_flags;
+	bool uuid_changed;
+	u64 super_flags;
+	int ret;
+
+	disk_super = root->fs_info->super_copy;
+	super_flags = btrfs_super_flags(disk_super);
+	incompat_flags = btrfs_super_incompat_flags(disk_super);
+	uuid_changed = incompat_flags & BTRFS_FEATURE_INCOMPAT_METADATA_UUID;
+
+	if (super_flags & BTRFS_SUPER_FLAG_SEEDING) {
+		fprintf(stderr, "Cannot set metadata UUID on a seed device\n");
+		return 1;
+	}
+
+	if (check_unfinished_fsid_change(root->fs_info, unused1, unused2)) {
+		fprintf(stderr, "UUID rewrite in progress, cannot change "
+			"fsid\n");
+		return 1;
+	}
+
+	if (uuid_string)
+		uuid_parse(uuid_string, new_fsid);
+	else
+		uuid_generate(new_fsid);
+
+	new_uuid = (memcmp(new_fsid, disk_super->fsid, BTRFS_FSID_SIZE) != 0);
+
+	/* Step 1 sest the in progress flag */
+	trans = btrfs_start_transaction(root, 1);
+	super_flags |= BTRFS_SUPER_FLAG_CHANGING_FSID_V2;
+	btrfs_set_super_flags(disk_super, super_flags);
+	ret = btrfs_commit_transaction(trans, root);
+	if (ret < 0)
+		return ret;
+
+	if (new_uuid && uuid_changed && memcmp(disk_super->metadata_uuid,
+					       new_fsid, BTRFS_FSID_SIZE) == 0) {
+		/*
+		 * Changing fsid to be the same as metadata uuid, so just
+		 * disable the flag
+		 */
+		memcpy(disk_super->fsid, &new_fsid, BTRFS_FSID_SIZE);
+		incompat_flags &= ~BTRFS_FEATURE_INCOMPAT_METADATA_UUID;
+		btrfs_set_super_incompat_flags(disk_super, incompat_flags);
+		memset(disk_super->metadata_uuid, 0, BTRFS_FSID_SIZE);
+	} else if (new_uuid && uuid_changed && memcmp(disk_super->metadata_uuid,
+						new_fsid, BTRFS_FSID_SIZE)) {
+		/*
+		 * Changing fsid on an already changed FS, in this case we
+		 * only change the fsid and don't touch metadata uuid as it
+		 * has already the correct value
+		 */
+		memcpy(disk_super->fsid, &new_fsid, BTRFS_FSID_SIZE);
+	} else if (new_uuid && !uuid_changed) {
+		/*
+		 * First time changing the fsid, copy the fsid to
+		 * metadata_uuid
+		 */
+		incompat_flags |= BTRFS_FEATURE_INCOMPAT_METADATA_UUID;
+		btrfs_set_super_incompat_flags(disk_super, incompat_flags);
+		memcpy(disk_super->metadata_uuid, disk_super->fsid,
+		       BTRFS_FSID_SIZE);
+		memcpy(disk_super->fsid, &new_fsid, BTRFS_FSID_SIZE);
+	} else {
+		/* Setting the same fsid as current NOOP */
+		return 0;
+	}
+
+	trans = btrfs_start_transaction(root, 1);
+
+	/*
+	 * Step 2 is to write the metadata_uuid, set the incompat flag and
+	 * clear the in progress flag
+	 */
+	super_flags &= ~BTRFS_SUPER_FLAG_CHANGING_FSID_V2;
+	btrfs_set_super_flags(disk_super, super_flags);
+
+	/* Then actually copy the metadata uuid and set the incompat bit */
+
+	return btrfs_commit_transaction(trans, root);
+}
+
 static int set_super_incompat_flags(struct btrfs_root *root, u64 flags)
 {
 	struct btrfs_trans_handle *trans;
@@ -268,26 +379,6 @@ static int change_fsid_done(struct btrfs_fs_info *fs_info)
 	return write_all_supers(fs_info);
 }
 
-/*
- * Return 0 for no unfinished fsid change.
- * Return >0 for unfinished fsid change, and restore unfinished fsid/
- * chunk_tree_id into fsid_ret/chunk_id_ret.
- */
-static int check_unfinished_fsid_change(struct btrfs_fs_info *fs_info,
-					uuid_t fsid_ret, uuid_t chunk_id_ret)
-{
-	struct btrfs_root *tree_root = fs_info->tree_root;
-	u64 flags = btrfs_super_flags(fs_info->super_copy);
-
-	if (flags & BTRFS_SUPER_FLAG_CHANGING_FSID) {
-		memcpy(fsid_ret, fs_info->super_copy->fsid, BTRFS_FSID_SIZE);
-		read_extent_buffer(tree_root->node, chunk_id_ret,
-				btrfs_header_chunk_tree_uuid(tree_root->node),
-				BTRFS_UUID_SIZE);
-		return 1;
-	}
-	return 0;
-}
 
 /*
  * Change fsid of a given fs.
@@ -381,8 +472,10 @@ static void print_usage(void)
 	printf("\t-x \t\tenable skinny metadata extent refs\n");
 	printf("\t-n \t\tenable no-holes feature (more efficient sparse file representation)\n");
 	printf("\t-f \t\tforce to do dangerous operation, make sure that you are aware of the dangers\n");
-	printf("\t-u \t\tchange fsid, use a random one\n");
-	printf("\t-U UUID\t\tchange fsid to UUID\n");
+	printf("\t-u \t\trewrite fsid, use a random one\n");
+	printf("\t-U UUID\t\trewrite fsid to UUID\n");
+	printf("\t-m \t\tChange only user-facing uuid (lighterweight than -u|-U\n");
+	printf("\t-M UUID\t\tchange fsid to UUID\n");
 }
 
 int main(int argc, char *argv[])
@@ -394,6 +487,7 @@ int main(int argc, char *argv[])
 	int seeding_flag = 0;
 	u64 seeding_value = 0;
 	int random_fsid = 0;
+	int change_metadata_uuid = 0;
 	char *new_fsid_str = NULL;
 	int ret;
 	u64 super_flags = 0;
@@ -404,7 +498,7 @@ int main(int argc, char *argv[])
 			{ "help", no_argument, NULL, GETOPT_VAL_HELP},
 			{ NULL, 0, NULL, 0 }
 		};
-		int c = getopt_long(argc, argv, "S:rxfuU:n", long_options, NULL);
+		int c = getopt_long(argc, argv, "S:rxfuU:nmM:", long_options, NULL);
 
 		if (c < 0)
 			break;
@@ -433,6 +527,15 @@ int main(int argc, char *argv[])
 			ctree_flags |= OPEN_CTREE_IGNORE_FSID_MISMATCH;
 			random_fsid = 1;
 			break;
+		case 'M':
+			ctree_flags |= OPEN_CTREE_IGNORE_FSID_MISMATCH;
+			change_metadata_uuid = 1;
+			new_fsid_str = optarg;
+			break;
+		case 'm':
+			ctree_flags |= OPEN_CTREE_IGNORE_FSID_MISMATCH;
+			change_metadata_uuid = 1;
+			break;
 		case GETOPT_VAL_HELP:
 		default:
 			print_usage();
@@ -451,7 +554,8 @@ int main(int argc, char *argv[])
 		error("random fsid can't be used with specified fsid");
 		return 1;
 	}
-	if (!super_flags && !seeding_flag && !(random_fsid || new_fsid_str)) {
+	if (!super_flags && !seeding_flag && !(random_fsid || new_fsid_str) &&
+	    !change_metadata_uuid) {
 		error("at least one option should be specified");
 		print_usage();
 		return 1;
@@ -497,6 +601,12 @@ int main(int argc, char *argv[])
 	}
 
 	if (seeding_flag) {
+		if (btrfs_fs_incompat(root->fs_info, METADATA_UUID)) {
+			fprintf(stderr, "SEED flag cannot be changed on a metadata-uuid changed fs\n");
+			ret = 1;
+			goto out;
+		}
+
 		if (!seeding_value && !force) {
 			warning(
 "this is dangerous, clearing the seeding flag may cause the derived device not to be mountable!");
@@ -521,7 +631,31 @@ int main(int argc, char *argv[])
 		total++;
 	}
 
-	if (random_fsid || new_fsid_str) {
+	if (change_metadata_uuid) {
+		if (seeding_flag) {
+			fprintf(stderr, "Not allowed to set both seeding flag and uuid metadata\n");
+			ret = 1;
+			goto out;
+		}
+
+		if (new_fsid_str)
+			ret = set_metadata_uuid(root, new_fsid_str);
+		else
+			ret = set_metadata_uuid(root, NULL);
+
+		if (!ret)
+			success++;
+		total++;
+	}
+
+	if (random_fsid || (new_fsid_str && !change_metadata_uuid)) {
+		if (btrfs_fs_incompat(root->fs_info, METADATA_UUID)) {
+			fprintf(stderr, "Cannot rewrite fsid while METADATA_UUID flag is active."
+				"Ensure fsid and metadata_uuid match before retrying.\n");
+			ret = 1;
+			goto out;
+		}
+
 		if (!force) {
 			warning(
 	"it's highly recommended to run 'btrfs check' before this operation");
diff --git a/ctree.h b/ctree.h
index c22d36b1871b..ff2ae9fecc11 100644
--- a/ctree.h
+++ b/ctree.h
@@ -330,6 +330,7 @@ static inline unsigned long btrfs_chunk_item_size(int num_stripes)
 #define BTRFS_SUPER_FLAG_METADUMP		(1ULL << 33)
 #define BTRFS_SUPER_FLAG_METADUMP_V2		(1ULL << 34)
 #define BTRFS_SUPER_FLAG_CHANGING_FSID		(1ULL << 35)
+#define BTRFS_SUPER_FLAG_CHANGING_FSID_V2	(1ULL << 36)
 
 #define BTRFS_BACKREF_REV_MAX		256
 #define BTRFS_BACKREF_REV_SHIFT		56
-- 
2.7.4

