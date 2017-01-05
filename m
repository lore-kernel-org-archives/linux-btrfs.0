Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtpq2.tb.mail.iss.as9143.net ([212.54.42.165]:52116 "EHLO
        smtpq2.tb.mail.iss.as9143.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S938891AbdAEVYG (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 5 Jan 2017 16:24:06 -0500
Received: from [212.54.42.117] (helo=lsmtp3.tb.mail.iss.as9143.net)
        by smtpq2.tb.mail.iss.as9143.net with esmtp (Exim 4.86_2)
        (envelope-from <laks@webminal.org>)
        id 1cPFW0-0002gv-AY
        for linux-btrfs@vger.kernel.org; Thu, 05 Jan 2017 22:24:04 +0100
Received: from dhcp-077-251-197-105.chello.nl ([77.251.197.105] helo=webminal.org)
        by lsmtp3.tb.mail.iss.as9143.net with esmtp (Exim 4.86_2)
        (envelope-from <laks@webminal.org>)
        id 1cPFW0-00024z-6r
        for linux-btrfs@vger.kernel.org; Thu, 05 Jan 2017 22:24:04 +0100
Received: from localhost.localdomain (fedori [127.0.0.1])
        by webminal.org (8.14.4/8.14.4) with ESMTP id v05H48jc017453
        for <linux-btrfs@vger.kernel.org>; Thu, 5 Jan 2017 18:04:19 +0100
Received: (from laks@localhost)
        by localhost.localdomain (8.14.4/8.14.4/Submit) id v05H3wUO017376
        for linux-btrfs@vger.kernel.org; Thu, 5 Jan 2017 18:03:58 +0100
Date: Thu, 5 Jan 2017 18:03:58 +0100
From: "Lakshmipathi.G" <Lakshmipathi.G@giis.co.in>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH] btrfs-progs: Corruption-framework: Include inode fields
Message-ID: <20170105170357.GA16173@fedori>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Signed-off-by: Lakshmipathi.G <Lakshmipathi.G@giis.co.in>
---
 btrfs-corrupt-block.c | 48 ++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 48 insertions(+)

diff --git a/btrfs-corrupt-block.c b/btrfs-corrupt-block.c
index a2f35ab..0e1eb52 100644
--- a/btrfs-corrupt-block.c
+++ b/btrfs-corrupt-block.c
@@ -309,6 +309,12 @@ enum btrfs_inode_field {
 	BTRFS_INODE_FIELD_ISIZE,
 	BTRFS_INODE_FIELD_NBYTES,
 	BTRFS_INODE_FIELD_NLINK,
+	BTRFS_INODE_FIELD_GENERATION,
+	BTRFS_INODE_FIELD_TRANSID,
+	BTRFS_INODE_FIELD_BLOCK_GROUP,
+	BTRFS_INODE_FIELD_MODE,
+	BTRFS_INODE_FIELD_UID,
+	BTRFS_INODE_FIELD_GID,
 	BTRFS_INODE_FIELD_BAD,
 };
 
@@ -349,6 +355,18 @@ static enum btrfs_inode_field convert_inode_field(char *field)
 		return BTRFS_INODE_FIELD_NBYTES;
 	if (!strncmp(field, "nlink", FIELD_BUF_LEN))
 		return BTRFS_INODE_FIELD_NLINK;
+	if (!strncmp(field, "generation", FIELD_BUF_LEN))
+		return BTRFS_INODE_FIELD_GENERATION;
+	if (!strncmp(field, "transid", FIELD_BUF_LEN))
+		return BTRFS_INODE_FIELD_TRANSID;
+	if (!strncmp(field, "block_group", FIELD_BUF_LEN))
+		return BTRFS_INODE_FIELD_BLOCK_GROUP;
+	if (!strncmp(field, "mode", FIELD_BUF_LEN))
+		return BTRFS_INODE_FIELD_MODE;
+	if (!strncmp(field, "uid", FIELD_BUF_LEN))
+		return BTRFS_INODE_FIELD_UID;
+	if (!strncmp(field, "gid", FIELD_BUF_LEN))
+		return BTRFS_INODE_FIELD_GID;
 	return BTRFS_INODE_FIELD_BAD;
 }
 
@@ -611,6 +629,36 @@ static int corrupt_inode(struct btrfs_trans_handle *trans,
 		bogus = generate_u32(orig);
 		btrfs_set_inode_nlink(path->nodes[0], ei, bogus);
 		break;
+	case BTRFS_INODE_FIELD_GENERATION:
+		orig = btrfs_inode_generation(path->nodes[0], ei);
+		bogus = generate_u64(orig);
+		btrfs_set_inode_generation(path->nodes[0], ei, bogus);
+		break;
+	case BTRFS_INODE_FIELD_TRANSID:
+		orig = btrfs_inode_transid(path->nodes[0], ei);
+		bogus = generate_u64(orig);
+		btrfs_set_inode_transid(path->nodes[0], ei, bogus);
+		break;
+	case BTRFS_INODE_FIELD_BLOCK_GROUP:
+		orig = btrfs_inode_block_group(path->nodes[0], ei);
+		bogus = generate_u64(orig);
+		btrfs_set_inode_block_group(path->nodes[0], ei, bogus);
+		break;
+	case BTRFS_INODE_FIELD_MODE:
+		orig = btrfs_inode_mode(path->nodes[0], ei);
+		bogus = generate_u32(orig);
+		btrfs_set_inode_mode(path->nodes[0], ei, bogus);
+		break;
+	case BTRFS_INODE_FIELD_UID:
+		orig = btrfs_inode_uid(path->nodes[0], ei);
+		bogus = generate_u32(orig);
+		btrfs_set_inode_uid(path->nodes[0], ei, bogus);
+		break;
+	case BTRFS_INODE_FIELD_GID:
+		orig = btrfs_inode_gid(path->nodes[0], ei);
+		bogus = generate_u32(orig);
+		btrfs_set_inode_gid(path->nodes[0], ei, bogus);
+		break;
 	default:
 		ret = -EINVAL;
 		break;
-- 
2.7.4

