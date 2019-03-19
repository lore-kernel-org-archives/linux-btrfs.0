Return-Path: <SRS0=+tZ8=RW=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B63E5C43381
	for <linux-btrfs@archiver.kernel.org>; Tue, 19 Mar 2019 11:35:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7A2BF2085A
	for <linux-btrfs@archiver.kernel.org>; Tue, 19 Mar 2019 11:35:23 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="2sutFfg+"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726935AbfCSLfW (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 19 Mar 2019 07:35:22 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:33070 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726763AbfCSLfW (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 19 Mar 2019 07:35:22 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x2JBYCct076551
        for <linux-btrfs@vger.kernel.org>; Tue, 19 Mar 2019 11:35:20 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id; s=corp-2018-07-02;
 bh=B+2Drs1U69lwK0/a9ScW8qQBfvl/UVDs8uOrXe1P76Y=;
 b=2sutFfg+ESa8HxPFcmhXzv7hQOnfhiPO3dukIM5/rZ8Vi0KQCtaT2zLey3C0bmEBW3Pz
 lLMeTB0F1DnhtC0p0RVgCRVw8uTMhbkmLV792hIC36ovCAW6z8Q7tf/kjDZiWFxaodVV
 V9QVlper8pv3/vo/zPfiygRaRZldm4bS2rdhr16bAmyKhBWzXEPbu0n0XAnsDBGI3YtM
 caTas8sDq5jGt4i+53EsUef5z+zz+d37NAw4qugnJMqY7EalaKEfCy6q5xmOqSVCsxsK
 OOrtUKqspuGNZ199j4eacliGmeuxszMs23JCBPffdlvHDA51bsgs7DzPnb3o9BjLw87Z lw== 
Received: from userv0022.oracle.com (userv0022.oracle.com [156.151.31.74])
        by userp2120.oracle.com with ESMTP id 2r8ssrbx99-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Tue, 19 Mar 2019 11:35:20 +0000
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userv0022.oracle.com (8.14.4/8.14.4) with ESMTP id x2JBZEDK030639
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Tue, 19 Mar 2019 11:35:15 GMT
Received: from abhmp0008.oracle.com (abhmp0008.oracle.com [141.146.116.14])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x2JBZE4Q011618
        for <linux-btrfs@vger.kernel.org>; Tue, 19 Mar 2019 11:35:14 GMT
Received: from tpasj.wifi.oracle.com (/192.188.170.109)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 19 Mar 2019 04:35:14 -0700
From:   Anand Jain <anand.jain@oracle.com>
To:     linux-btrfs@vger.kernel.org
Subject: [PATCH RFC] btrfs: fix read corrpution from disks of different generation
Date:   Tue, 19 Mar 2019 19:35:29 +0800
Message-Id: <1552995330-28927-1-git-send-email-anand.jain@oracle.com>
X-Mailer: git-send-email 1.8.3.1
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9199 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=3 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1903190087
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

   In case of file regular extent (non inline), the metadata and data are 
 read from two different IO operations. When we read the metadata using 
 the btree each extent block gets verified with the expected  transid as 
 per its parent. So suppose if any of the block is stale it gets reported 
 and corrected by reading from the mirror (consider raid1).
 
   This also means the data extent is not yet read or verified and this 
 happens when application tries to read the file.
 When application tries to read the file btrfs_readpage(), it shall first 
 read file extent map as provided by the metadata in the above operation 
 (which is assured to be consistent).
 And when file data has to be read using the above filemap as it again 
 has the choice of using either of the mirrors, suppose if the IO is 
 routed to the disk on which we haven't verified the metadata on it and 
 if there is write hole on that disk, then we shall be reading the junk 
 data without being reported anywhere.

   This is reproducible with the test case [1] in this email thread.
     [1]
     fstests: btrfs test read from disks of different generation

   As we have data csum most of these get caught and reported as csum 
 error. But csum verification is a point in verification and its not a 
 tree based transid verification. Which means if there is a stale data 
 with matching csum we may return a junk data silently. This problem is 
 easily reproducible when csum is disabled but not impossible to achieve 
 when csum is not disabled as well. A tree based integrity verification 
 is important for all data, which is missing.
 
 Fix:
   In this RFC patch it proposes to use same disk from with the metadata 
 is read to read the data. Which means the feature such as readmirror is 
 less effective (which is fine). But if the good data fails (media error) 
 as usual we shall read the mirrored data without being aware that this 
 data may be stale. To fix that, we have to invalidate the corresponding 
 metadata and re-read the metadata from other disk (this part is not 
 implemented in this patch).
 
    The other better solution is - a tree based verification, which means 
 we have to verify the data-extent's metadata in the extent tree when its 
 read - but there is a problem we don't update the generation number in 
 the extent tree for all types of write, for example consider overwrite 
 with notrunc option on a filesystem mounted with nodatacow option [1], 
 which I wonder if its a bug or if its like that for a reason? as because 
 there is no cow?
 
 [1] The EXTENT_DATA generation is same before and after dd with notrunc
 
   mkfs.btrfs -fq /dev/sdb && mount -o notreelog,nodatacow /dev/sdb /btrfs
   dd if=/dev/urandom of=/btrfs/tf1 bs=4096 count=1 conv=fsync,notrunc && 
 sync
   btrfs in dump-tree /dev/sdb | grep -A4 "257 EXTENT_DATA 0"
   btrfs in dump-tree /dev/sdb | egrep -A7 "257 INODE_ITEM 0\) itemoff"
   dd if=/dev/urandom of=/btrfs/tf1 bs=4096 count=1 conv=fsync,notrunc && 
 sync
   btrfs in dump-tree /dev/sdb | grep -A4 "257 EXTENT_DATA 0"
   btrfs in dump-tree /dev/sdb | egrep -A7 "257 INODE_ITEM 0\) itemoff"
 
 ---------
      item 6 key (257 EXTENT_DATA 0) itemoff 15819 itemsize 53
          generation 6 type 1 (regular)
          extent data disk byte 13631488 nr 4096
          extent data offset 0 nr 4096 ram 4096
          extent compression 0 (none)
      item 4 key (257 INODE_ITEM 0) itemoff 15885 itemsize 160
          generation 6 transid 6 size 4096 nbytes 4096
          block group 0 mode 100644 links 1 uid 0 gid 0 rdev 0
          sequence 66785 flags 0x3(NODATASUM|NODATACOW)
          atime 1552993569.276079763 (2019-03-19 19:06:09)
          ctime 1552993569.276079763 (2019-03-19 19:06:09)
          mtime 1552993569.276079763 (2019-03-19 19:06:09)
          otime 1552993569.276079763 (2019-03-19 19:06:09)
 1+0 records in
 1+0 records out
 4096 bytes (4.1 kB) copied, 0.00302717 s, 1.4 MB/s
      item 6 key (257 EXTENT_DATA 0) itemoff 15819 itemsize 53
          generation 6 type 1 (regular)
          extent data disk byte 13631488 nr 4096
          extent data offset 0 nr 4096 ram 4096
          extent compression 0 (none)
      item 4 key (257 INODE_ITEM 0) itemoff 15885 itemsize 160
          generation 6 transid 7 size 4096 nbytes 4096
          block group 0 mode 100644 links 1 uid 0 gid 0 rdev 0
          sequence 66786 flags 0x3(NODATASUM|NODATACOW)
          atime 1552993569.276079763 (2019-03-19 19:06:09)
          ctime 1552993569.302079763 (2019-03-19 19:06:09)
          mtime 1552993569.302079763 (2019-03-19 19:06:09)
          otime 1552993569.276079763 (2019-03-19 19:06:09)
 -------
 
   Comments appreciated.


Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
 fs/btrfs/extent_io.c | 41 ++++++++++++++++++++++++++++++++++-------
 1 file changed, 34 insertions(+), 7 deletions(-)

diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index 31892052a24f..f1cc21e8dff7 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -3079,7 +3079,7 @@ static inline void __do_contiguous_readpages(struct extent_io_tree *tree,
 					     struct extent_map **em_cached,
 					     struct bio **bio,
 					     unsigned long *bio_flags,
-					     u64 *prev_em_start)
+					     u64 *prev_em_start, int mirror)
 {
 	struct inode *inode;
 	struct btrfs_ordered_extent *ordered;
@@ -3099,7 +3099,7 @@ static inline void __do_contiguous_readpages(struct extent_io_tree *tree,
 
 	for (index = 0; index < nr_pages; index++) {
 		__do_readpage(tree, pages[index], btrfs_get_extent, em_cached,
-				bio, 0, bio_flags, REQ_RAHEAD, prev_em_start);
+				bio, mirror, bio_flags, REQ_RAHEAD, prev_em_start);
 		put_page(pages[index]);
 	}
 }
@@ -3109,7 +3109,7 @@ static void __extent_readpages(struct extent_io_tree *tree,
 			       int nr_pages,
 			       struct extent_map **em_cached,
 			       struct bio **bio, unsigned long *bio_flags,
-			       u64 *prev_em_start)
+			       u64 *prev_em_start, int mirror)
 {
 	u64 start = 0;
 	u64 end = 0;
@@ -3130,7 +3130,7 @@ static void __extent_readpages(struct extent_io_tree *tree,
 						  index - first_index, start,
 						  end, em_cached,
 						  bio, bio_flags,
-						  prev_em_start);
+						  prev_em_start, mirror);
 			start = page_start;
 			end = start + PAGE_SIZE - 1;
 			first_index = index;
@@ -3141,7 +3141,7 @@ static void __extent_readpages(struct extent_io_tree *tree,
 		__do_contiguous_readpages(tree, &pages[first_index],
 					  index - first_index, start,
 					  end, em_cached, bio,
-					  bio_flags, prev_em_start);
+					  bio_flags, prev_em_start, mirror);
 }
 
 static int __extent_read_full_page(struct extent_io_tree *tree,
@@ -4093,6 +4093,27 @@ int extent_writepages(struct address_space *mapping,
 	return ret;
 }
 
+static int btrfs_get_read_mirror(struct inode *inode)
+{
+	int ret;
+	struct btrfs_path *path;
+
+	path = btrfs_alloc_path();
+	if (!path)
+		return -ENOMEM;
+
+	ret = btrfs_lookup_file_extent(NULL, BTRFS_I(inode)->root, path,
+				       btrfs_ino(BTRFS_I(inode)), 0, 0);
+	if (!ret) {
+		struct extent_buffer *eb = path->nodes[0];
+
+		ret = eb->read_mirror;
+	}
+
+	btrfs_free_path(path);
+	return ret;
+}
+
 int extent_readpages(struct address_space *mapping, struct list_head *pages,
 		     unsigned nr_pages)
 {
@@ -4103,6 +4124,11 @@ int extent_readpages(struct address_space *mapping, struct list_head *pages,
 	struct extent_io_tree *tree = &BTRFS_I(mapping->host)->io_tree;
 	int nr = 0;
 	u64 prev_em_start = (u64)-1;
+	int mirror;
+
+	mirror = btrfs_get_read_mirror(mapping->host);
+	if (mirror < 0)
+		return mirror;
 
 	while (!list_empty(pages)) {
 		for (nr = 0; nr < ARRAY_SIZE(pagepool) && !list_empty(pages);) {
@@ -4120,14 +4146,15 @@ int extent_readpages(struct address_space *mapping, struct list_head *pages,
 		}
 
 		__extent_readpages(tree, pagepool, nr, &em_cached, &bio,
-				   &bio_flags, &prev_em_start);
+				   &bio_flags, &prev_em_start, mirror);
+
 	}
 
 	if (em_cached)
 		free_extent_map(em_cached);
 
 	if (bio)
-		return submit_one_bio(bio, 0, bio_flags);
+		return submit_one_bio(bio, mirror, bio_flags);
 	return 0;
 }
 
-- 
1.8.3.1

