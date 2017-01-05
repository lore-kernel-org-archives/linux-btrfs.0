Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtpq1.tb.mail.iss.as9143.net ([212.54.42.164]:34029 "EHLO
        smtpq1.tb.mail.iss.as9143.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S936943AbdAENMU (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 5 Jan 2017 08:12:20 -0500
Date: Thu, 5 Jan 2017 11:08:32 +0100
From: "Lakshmipathi.G" <Lakshmipathi.G@giis.co.in>
To: linux-btrfs@vger.kernel.org, dsterba@suse.cz
Subject: [PATCH] btrfs-progs: Corruption-framework: Include inode nlink field
Message-ID: <20170105100832.GA1116@fedori>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Patch with fix for David Sterba review comment.

Signed-off-by: Lakshmipathi.G <Lakshmipathi.G@giis.co.in>
---
 btrfs-corrupt-block.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/btrfs-corrupt-block.c b/btrfs-corrupt-block.c
index 16680df..a2f35ab 100644
--- a/btrfs-corrupt-block.c
+++ b/btrfs-corrupt-block.c
@@ -308,6 +308,7 @@ static void btrfs_corrupt_extent_tree(struct btrfs_trans_handle *trans,
 enum btrfs_inode_field {
 	BTRFS_INODE_FIELD_ISIZE,
 	BTRFS_INODE_FIELD_NBYTES,
+	BTRFS_INODE_FIELD_NLINK,
 	BTRFS_INODE_FIELD_BAD,
 };
 
@@ -346,6 +347,8 @@ static enum btrfs_inode_field convert_inode_field(char *field)
 		return BTRFS_INODE_FIELD_ISIZE;
 	if (!strncmp(field, "nbytes", FIELD_BUF_LEN))
 		return BTRFS_INODE_FIELD_NBYTES;
+	if (!strncmp(field, "nlink", FIELD_BUF_LEN))
+		return BTRFS_INODE_FIELD_NLINK;
 	return BTRFS_INODE_FIELD_BAD;
 }
 
@@ -603,6 +606,11 @@ static int corrupt_inode(struct btrfs_trans_handle *trans,
 		bogus = generate_u64(orig);
 		btrfs_set_inode_nbytes(path->nodes[0], ei, bogus);
 		break;
+	case BTRFS_INODE_FIELD_NLINK:
+		orig = btrfs_inode_nlink(path->nodes[0], ei);
+		bogus = generate_u32(orig);
+		btrfs_set_inode_nlink(path->nodes[0], ei, bogus);
+		break;
 	default:
 		ret = -EINVAL;
 		break;
-- 
2.7.4

