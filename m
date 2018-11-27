Return-Path: <SRS0=/x7k=OG=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,
	UNWANTED_LANGUAGE_BODY,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0E00CC43610
	for <linux-btrfs@archiver.kernel.org>; Tue, 27 Nov 2018 05:31:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CEC23208E4
	for <linux-btrfs@archiver.kernel.org>; Tue, 27 Nov 2018 05:31:37 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org CEC23208E4
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=jp.fujitsu.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728642AbeK0Q2P (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 27 Nov 2018 11:28:15 -0500
Received: from mgwkm02.jp.fujitsu.com ([202.219.69.169]:14838 "EHLO
        mgwkm02.jp.fujitsu.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728624AbeK0Q2P (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 27 Nov 2018 11:28:15 -0500
X-Greylist: delayed 666 seconds by postgrey-1.27 at vger.kernel.org; Tue, 27 Nov 2018 11:28:13 EST
Received: from kw-mxoi2.gw.nic.fujitsu.com (unknown [192.168.231.133]) by mgwkm02.jp.fujitsu.com with smtp
         id 7647_8b25_e2f3972e_611d_4d56_9986_bc484b0beca1;
        Tue, 27 Nov 2018 14:20:23 +0900
Received: from g01jpfmpwyt03.exch.g01.fujitsu.local (g01jpfmpwyt03.exch.g01.fujitsu.local [10.128.193.57])
        by kw-mxoi2.gw.nic.fujitsu.com (Postfix) with ESMTP id A8F6FAC00DD
        for <linux-btrfs@vger.kernel.org>; Tue, 27 Nov 2018 14:20:23 +0900 (JST)
Received: from g01jpexchyt37.g01.fujitsu.local (unknown [10.128.193.4])
        by g01jpfmpwyt03.exch.g01.fujitsu.local (Postfix) with ESMTP id BB7F546E6C3;
        Tue, 27 Nov 2018 14:20:22 +0900 (JST)
Received: from luna3.soft.fujitsu.com (10.124.196.199) by
 g01jpexchyt37.g01.fujitsu.local (10.128.193.67) with Microsoft SMTP Server id
 14.3.352.0; Tue, 27 Nov 2018 14:20:22 +0900
From:   Misono Tomohiro <misono.tomohiro@jp.fujitsu.com>
To:     <linux-btrfs@vger.kernel.org>
CC:     David Sterba <dsterba@suse.com>
Subject: [PATCH 2/8] btrfs-progs: sub list: factor out main part of btrfs_list_subvols
Date:   Tue, 27 Nov 2018 14:24:43 +0900
Message-ID: <6b60008a654c82495140a928747c117d27663243.1543294426.git.misono.tomohiro@jp.fujitsu.com>
X-Mailer: git-send-email 2.19.1
In-Reply-To: <cover.1543294426.git.misono.tomohiro@jp.fujitsu.com>
References: <cover.1543294426.git.misono.tomohiro@jp.fujitsu.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-SecurityPolicyCheck-GC: OK by FENCE-Mail
X-TM-AS-MML: disable
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

No functional changes.
This is a preparation work for reworking "subvolume list".

Signed-off-by: Misono Tomohiro <misono.tomohiro@jp.fujitsu.com>
Signed-off-by: David Sterba <dsterba@suse.com>
---
 cmds-subvolume.c | 50 +++++++++++++++++++++++++++++-------------------
 1 file changed, 30 insertions(+), 20 deletions(-)

diff --git a/cmds-subvolume.c b/cmds-subvolume.c
index 84a03fd8..40cc2687 100644
--- a/cmds-subvolume.c
+++ b/cmds-subvolume.c
@@ -1128,22 +1128,15 @@ out:
 	return subvols;
 }
 
-static struct subvol_list *btrfs_list_subvols(int fd,
-					      struct btrfs_list_filter_set_v2 *filter_set)
+static void get_subvols_info(struct subvol_list **subvols,
+			     struct btrfs_list_filter_set_v2 *filter_set,
+			     int fd,
+			     size_t *capacity)
 {
-	struct subvol_list *subvols;
-	size_t capacity = 0;
 	struct btrfs_util_subvolume_iterator *iter;
 	enum btrfs_util_error err;
 	int ret = -1;
 
-	subvols = malloc(sizeof(*subvols));
-	if (!subvols) {
-		error("out of memory");
-		return NULL;
-	}
-	subvols->num = 0;
-
 	err = btrfs_util_create_subvolume_iterator_fd(fd,
 						      BTRFS_FS_TREE_OBJECTID, 0,
 						      &iter);
@@ -1171,11 +1164,11 @@ static struct subvol_list *btrfs_list_subvols(int fd,
 			continue;
 		}
 
-		if (subvols->num >= capacity) {
+		if ((*subvols)->num >= *capacity) {
 			struct subvol_list *new_subvols;
-			size_t new_capacity = max_t(size_t, 1, capacity * 2);
+			size_t new_capacity = max_t(size_t, 1, *capacity * 2);
 
-			new_subvols = realloc(subvols,
+			new_subvols = realloc(*subvols,
 					      sizeof(*new_subvols) +
 					      new_capacity *
 					      sizeof(new_subvols->subvols[0]));
@@ -1184,12 +1177,12 @@ static struct subvol_list *btrfs_list_subvols(int fd,
 				goto out;
 			}
 
-			subvols = new_subvols;
-			capacity = new_capacity;
+			*subvols = new_subvols;
+			*capacity = new_capacity;
 		}
 
-		subvols->subvols[subvols->num] = subvol;
-		subvols->num++;
+		(*subvols)->subvols[(*subvols)->num] = subvol;
+		(*subvols)->num++;
 	}
 
 	ret = 0;
@@ -1197,9 +1190,26 @@ out:
 	if (iter)
 		btrfs_util_destroy_subvolume_iterator(iter);
 	if (ret) {
-		free_subvol_list(subvols);
-		subvols = NULL;
+		free_subvol_list(*subvols);
+		*subvols = NULL;
+	}
+}
+
+static struct subvol_list *btrfs_list_subvols(int fd,
+					      struct btrfs_list_filter_set_v2 *filter_set)
+{
+	struct subvol_list *subvols;
+	size_t capacity = 0;
+
+	subvols = malloc(sizeof(*subvols));
+	if (!subvols) {
+		error("out of memory");
+		return NULL;
 	}
+	subvols->num = 0;
+
+	get_subvols_info(&subvols, filter_set, fd, &capacity);
+
 	return subvols;
 }
 
-- 
2.19.1


