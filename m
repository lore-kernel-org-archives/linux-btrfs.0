Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtpq5.tb.mail.iss.as9143.net ([212.54.42.168]:43177 "EHLO
        smtpq5.tb.mail.iss.as9143.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752594AbdACXCg (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 3 Jan 2017 18:02:36 -0500
Received: from [212.54.42.118] (helo=lsmtp4.tb.mail.iss.as9143.net)
        by smtpq5.tb.mail.iss.as9143.net with esmtp (Exim 4.86_2)
        (envelope-from <laks@webminal.org>)
        id 1cOXh4-00006P-UR
        for linux-btrfs@vger.kernel.org; Tue, 03 Jan 2017 23:36:34 +0100
Received: from dhcp-077-251-197-105.chello.nl ([77.251.197.105] helo=webminal.org)
        by lsmtp4.tb.mail.iss.as9143.net with esmtp (Exim 4.86_2)
        (envelope-from <laks@webminal.org>)
        id 1cOXh4-0002fI-Rq
        for linux-btrfs@vger.kernel.org; Tue, 03 Jan 2017 23:36:34 +0100
Received: from localhost.localdomain (fedori [127.0.0.1])
        by webminal.org (8.14.4/8.14.4) with ESMTP id v03CDx39026018
        for <linux-btrfs@vger.kernel.org>; Tue, 3 Jan 2017 13:14:09 +0100
Received: (from laks@localhost)
        by localhost.localdomain (8.14.4/8.14.4/Submit) id v03CDmfw025771
        for linux-btrfs@vger.kernel.org; Tue, 3 Jan 2017 13:13:48 +0100
Date: Tue, 3 Jan 2017 13:13:48 +0100
From: "Lakshmipathi.G" <Lakshmipathi.G@giis.co.in>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH] btrfs-progs: Corruption-framework: Include inode nlink field
Message-ID: <20170103121348.GA23094@fedori>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Will include other fields, if this gets accepted.


Signed-off-by: Lakshmipathi.G <Lakshmipathi.G@giis.co.in>
---
 btrfs-corrupt-block.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/btrfs-corrupt-block.c b/btrfs-corrupt-block.c
index 16680df..64376ca 100644
--- a/btrfs-corrupt-block.c
+++ b/btrfs-corrupt-block.c
@@ -309,6 +309,7 @@ enum btrfs_inode_field {
 	BTRFS_INODE_FIELD_ISIZE,
 	BTRFS_INODE_FIELD_NBYTES,
 	BTRFS_INODE_FIELD_BAD,
+	BTRFS_INODE_FIELD_NLINK,
 };
 
 enum btrfs_file_extent_field {
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

