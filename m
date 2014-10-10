Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:34723 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755112AbaJJU5n (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 10 Oct 2014 16:57:43 -0400
Received: from pps.filterd (m0004003 [127.0.0.1])
	by mx0b-00082601.pphosted.com (8.14.5/8.14.5) with SMTP id s9AKsFoM012653
	for <linux-btrfs@vger.kernel.org>; Fri, 10 Oct 2014 13:57:42 -0700
Received: from mail.thefacebook.com (mailwest.thefacebook.com [173.252.71.148])
	by mx0b-00082601.pphosted.com with ESMTP id 1pxmbv8mwc-2
	(version=TLSv1/SSLv3 cipher=AES128-SHA bits=128 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Fri, 10 Oct 2014 13:57:42 -0700
From: Josef Bacik <jbacik@fb.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH 09/12] Btrfs-progs: add a dummy backref if our location is wrong
Date: Fri, 10 Oct 2014 16:57:14 -0400
Message-ID: <1412974637-31334-10-git-send-email-jbacik@fb.com>
In-Reply-To: <1412974637-31334-1-git-send-email-jbacik@fb.com>
References: <1412974637-31334-1-git-send-email-jbacik@fb.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

If our location is bogus in our dir item we were just skipping the thing.
However in this case we want to just delete the dir index, so create a dummy
inode rec using BTRFS_MULTIPLE_OBJECTIDS and just add every backref we find to
the list so we know to straight up delete all of these items.  Thanks,

Signed-off-by: Josef Bacik <jbacik@fb.com>
---
 cmds-check.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/cmds-check.c b/cmds-check.c
index 8fdc542..ca890cc 100644
--- a/cmds-check.c
+++ b/cmds-check.c
@@ -551,6 +551,8 @@ static struct inode_backref *get_inode_backref(struct inode_record *rec,
 	struct inode_backref *backref;
 
 	list_for_each_entry(backref, &rec->backrefs, list) {
+		if (rec->ino == BTRFS_MULTIPLE_OBJECTIDS)
+			break;
 		if (backref->dir != dir || backref->namelen != namelen)
 			continue;
 		if (memcmp(name, backref->name, namelen))
@@ -990,7 +992,11 @@ static int process_dir_item(struct btrfs_root *root,
 					  namebuf, len, filetype,
 					  key->type, error);
 		} else {
-			fprintf(stderr, "warning line %d\n", __LINE__);
+			fprintf(stderr, "invalid location in dir item %u\n",
+				location.type);
+			add_inode_backref(inode_cache, BTRFS_MULTIPLE_OBJECTIDS,
+					  key->objectid, key->offset, namebuf,
+					  len, filetype, key->type, error);
 		}
 
 		len = sizeof(*di) + name_len + data_len;
-- 
1.8.3.1

