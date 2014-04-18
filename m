Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from nbl-ex10-fe02.nebula.fi ([188.117.32.122]:50673 "EHLO
	ex10.nebula.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751947AbaDRXN7 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 18 Apr 2014 19:13:59 -0400
Date: Sat, 19 Apr 2014 02:13:55 +0300
From: Rakesh Pandit <rakesh@tuxera.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH 1/2] Btrfs-progs: fsck: while checking root refs print
 readable errors
Message-ID: <20140418231354.GA1874@hercules.tuxera.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Lets use "errors" instead of "error" because more then one ref errors
are possible. Also print error messages for unresolved refs in
check_root_refs.

Signed-off-by: Rakesh Pandit <rakesh@tuxera.com>
---
 cmds-check.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/cmds-check.c b/cmds-check.c
index 93f9ae6..6ea8c68 100644
--- a/cmds-check.c
+++ b/cmds-check.c
@@ -1610,7 +1610,7 @@ static int check_inode_recs(struct btrfs_root *root,
 			if (!backref->found_inode_ref)
 				backref->errors |= REF_ERR_NO_INODE_REF;
 			fprintf(stderr, "\tunresolved ref dir %llu index %llu"
-				" namelen %u name %s filetype %d error %x",
+				" namelen %u name %s filetype %d errors %x",
 				(unsigned long long)backref->dir,
 				(unsigned long long)backref->index,
 				backref->namelen, backref->name,
@@ -1886,12 +1886,13 @@ static int check_root_refs(struct btrfs_root *root,
 			if (!backref->errors && rec->found_root_item)
 				continue;
 			fprintf(stderr, "\tunresolved ref root %llu dir %llu"
-				" index %llu namelen %u name %s error %x\n",
+				" index %llu namelen %u name %s errors %x\n",
 				(unsigned long long)backref->ref_root,
 				(unsigned long long)backref->dir,
 				(unsigned long long)backref->index,
 				backref->namelen, backref->name,
 				backref->errors);
+			print_ref_error(backref->errors);
 		}
 	}
 	return errors > 0 ? 1 : 0;
-- 
1.8.5.3

