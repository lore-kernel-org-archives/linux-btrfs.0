Return-Path: <SRS0=/x7k=OG=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D817EC43441
	for <linux-btrfs@archiver.kernel.org>; Tue, 27 Nov 2018 05:31:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5F975208E4
	for <linux-btrfs@archiver.kernel.org>; Tue, 27 Nov 2018 05:31:35 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 5F975208E4
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=jp.fujitsu.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728635AbeK0Q2O (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 27 Nov 2018 11:28:14 -0500
Received: from mgwkm04.jp.fujitsu.com ([202.219.69.171]:21610 "EHLO
        mgwkm04.jp.fujitsu.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728625AbeK0Q2O (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 27 Nov 2018 11:28:14 -0500
Received: from kw-mxoi2.gw.nic.fujitsu.com (unknown [192.168.231.133]) by mgwkm04.jp.fujitsu.com with smtp
         id 2b29_2613_5eaa3c12_e565_489c_ad52_883efd5fbcea;
        Tue, 27 Nov 2018 14:20:24 +0900
Received: from g01jpfmpwyt03.exch.g01.fujitsu.local (g01jpfmpwyt03.exch.g01.fujitsu.local [10.128.193.57])
        by kw-mxoi2.gw.nic.fujitsu.com (Postfix) with ESMTP id 03700AC00DD
        for <linux-btrfs@vger.kernel.org>; Tue, 27 Nov 2018 14:20:24 +0900 (JST)
Received: from g01jpexchyt37.g01.fujitsu.local (unknown [10.128.193.4])
        by g01jpfmpwyt03.exch.g01.fujitsu.local (Postfix) with ESMTP id 1D01746E6D1;
        Tue, 27 Nov 2018 14:20:23 +0900 (JST)
Received: from luna3.soft.fujitsu.com (10.124.196.199) by
 g01jpexchyt37.g01.fujitsu.local (10.128.193.67) with Microsoft SMTP Server id
 14.3.352.0; Tue, 27 Nov 2018 14:20:23 +0900
From:   Misono Tomohiro <misono.tomohiro@jp.fujitsu.com>
To:     <linux-btrfs@vger.kernel.org>
CC:     David Sterba <dsterba@suse.com>
Subject: [PATCH 4/8] btrfs-progs: sub list: Update -a option and remove meaningless filter
Date:   Tue, 27 Nov 2018 14:24:45 +0900
Message-ID: <708c725e63d16289257ee0a44a925e5a8d2572ac.1543294426.git.misono.tomohiro@jp.fujitsu.com>
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

Currently, -a option add filter and change subvolume path as follows:
  - If a subvolume is a child of the specified path, nothing changes
  - otherwise, adds <FS_TREE> to head

This is rather meaningless, so let's remove this filter.

As a result, the behavior of -a option becomes the same as
default behavior of sub list in progs <= 4.19

[Example]
 $ mkfs.btrfs -f $DEV
 $ mount $DEV /mnt

 $ btrfs subvolume create /mnt/AAA
 $ btrfs subvolume create /mnt/AAA/BBB
 $ btrfs subvolume create /mnt/ZZZ

 $ btrfs subvolume list -a /mnt
 ID 256 gen 9 top level 5 path AAA
 ID 257 gen 9 top level 256 path AAA/BBB
 ID 258 gen 10 top level 5 path ZZZ

 ** output of progs <= 4.19
 $ btrfs subvolume list -a /mnt
 ID 256 gen 9 top level 5 path AAA
 ID 257 gen 9 top level 256 path <FS_TREE>/AAA/BBB
 ID 258 gen 10 top level 5 path ZZZ

Signed-off-by: Misono Tomohiro <misono.tomohiro@jp.fujitsu.com>
Signed-off-by: David Sterba <dsterba@suse.com>
---
 Documentation/btrfs-subvolume.asciidoc |  6 +++--
 cmds-subvolume.c                       | 35 +++-----------------------
 2 files changed, 8 insertions(+), 33 deletions(-)

diff --git a/Documentation/btrfs-subvolume.asciidoc b/Documentation/btrfs-subvolume.asciidoc
index 99fff977..428a2faa 100644
--- a/Documentation/btrfs-subvolume.asciidoc
+++ b/Documentation/btrfs-subvolume.asciidoc
@@ -118,8 +118,10 @@ Path filtering;;
 -o::::
 print only subvolumes below specified <path>.
 -a::::
-print all the subvolumes in the filesystem and distinguish between
-absolute and relative path with respect to the given <path>.
+print all the subvolumes in the filesystem, including subvolumes
+which cannot be accessed from current mount point.
+path to be shown is relative to the top-level subvolume
+(require root privileges).
 
 Field selection;;
 -p::::
diff --git a/cmds-subvolume.c b/cmds-subvolume.c
index ef613662..cd2e4425 100644
--- a/cmds-subvolume.c
+++ b/cmds-subvolume.c
@@ -761,28 +761,6 @@ static int filter_topid_equal(struct listed_subvol *subvol, uint64_t data)
 	return subvol->info.parent_id == data;
 }
 
-static int filter_full_path(struct listed_subvol *subvol, uint64_t data)
-{
-	/*
-	 * This implements the same behavior as before the conversion to
-	 * libbtrfsutil, which is mostly nonsensical.
-	 */
-	if (subvol->info.parent_id != data) {
-		char *tmp;
-		int ret;
-
-		ret = asprintf(&tmp, "<FS_TREE>/%s", subvol->path);
-		if (ret == -1) {
-			error("out of memory");
-			exit(1);
-		}
-
-		free(subvol->path);
-		subvol->path = tmp;
-	}
-	return 1;
-}
-
 static int filter_by_parent(struct listed_subvol *subvol, uint64_t data)
 {
 	return !uuid_compare(subvol->info.parent_uuid,
@@ -800,7 +778,6 @@ static btrfs_list_filter_func_v2 all_filter_funcs[] = {
 	[BTRFS_LIST_FILTER_CGEN_LESS]		= filter_cgen_less,
 	[BTRFS_LIST_FILTER_CGEN_EQUAL]          = filter_cgen_equal,
 	[BTRFS_LIST_FILTER_TOPID_EQUAL]		= filter_topid_equal,
-	[BTRFS_LIST_FILTER_FULL_PATH]		= filter_full_path,
 	[BTRFS_LIST_FILTER_BY_PARENT]		= filter_by_parent,
 };
 
@@ -1411,9 +1388,9 @@ static const char * const cmd_subvol_list_usage[] = {
 	"",
 	"Path filtering:",
 	"-o           print only subvolumes below specified path",
-	"-a           print all the subvolumes in the filesystem and",
-	"             distinguish absolute and relative path with respect",
-	"             to the given <path> (require root privileges)",
+	"-a           print all the subvolumes in the filesystem.",
+	"             path to be shown is relative to the top-level",
+	"             subvolume (require root privileges)",
 	"",
 	"Field selection:",
 	"-p           print parent ID",
@@ -1581,11 +1558,7 @@ static int cmd_subvol_list(int argc, char **argv)
 	if (ret)
 		goto out;
 
-	if (is_list_all)
-		btrfs_list_setup_filter_v2(&filter_set,
-					BTRFS_LIST_FILTER_FULL_PATH,
-					top_id);
-	else if (is_only_in_path)
+	if (is_only_in_path)
 		btrfs_list_setup_filter_v2(&filter_set,
 					BTRFS_LIST_FILTER_TOPID_EQUAL,
 					top_id);
-- 
2.19.1


