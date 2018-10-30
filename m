Return-Path: <SRS0=iJ2R=NK=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5D614C6786F
	for <linux-btrfs@archiver.kernel.org>; Tue, 30 Oct 2018 10:18:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 12AEA20827
	for <linux-btrfs@archiver.kernel.org>; Tue, 30 Oct 2018 10:18:29 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 12AEA20827
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=suse.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727545AbeJ3TLR (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 30 Oct 2018 15:11:17 -0400
Received: from mx2.suse.de ([195.135.220.15]:54476 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726840AbeJ3TLR (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 30 Oct 2018 15:11:17 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay1.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 61651AF71;
        Tue, 30 Oct 2018 10:18:25 +0000 (UTC)
From:   Qu Wenruo <wqu@suse.com>
To:     fstests@vger.kernel.org, linux-btrfs@vger.kernel.org
Subject: [PATCH v3] fstests: btrfs/057: Fix false alerts due to orphan files
Date:   Tue, 30 Oct 2018 18:18:19 +0800
Message-Id: <20181030101819.19510-1-wqu@suse.com>
X-Mailer: git-send-email 2.19.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

For any recent kernel, there is a chance that btrfs/057 reports false
errors.

The false error would look like:
  btrfs/057 4s ... - output mismatch (see /home/adam/xfstests-dev/results//btrfs/057.out.bad)
      --- tests/btrfs/057.out	2017-08-21 09:25:33.166666666 +0800
      +++ /home/adam/xfstests-dev/results//btrfs/057.out.bad	2018-10-29 14:07:28.443651293 +0800
      @@ -1,3 +1,3 @@
       QA output created by 057
       4096 4096
      -4096 4096
      +28672 28672

This is related to the fact that "btrfs subvolume sync" (or
vanilla sync) will not ensure orphan (unlinked but still exist) files to
be removed.

In fact, for that false error case, if inspecting the fs after umount,
its qgroup number is correct and btrfs check won't report qgroup error.

To fix the false alerts, just skip any manual qgroup number comparison,
and let fsck done after the test case to detect problem.

This also elimiate the necessary of using specified mount and mkfs
option, allowing us to improve coverage.

Reported-by: Nikolay Borisov <nborisov@suse.com>
Signed-off-by: Qu Wenruo <wqu@suse.com>
Reviewed-by: Filipe Manana <fdmanana@suse.com>
---
Changelog:
v2:
  Update commit message to show this is a long existing bug.
v3:
  Remove an old comment since now we don't need to specify the leaf
  size.
  Added Reviewed-by tags.
---
 tests/btrfs/057     | 18 ++++--------------
 tests/btrfs/057.out |  3 +--
 2 files changed, 5 insertions(+), 16 deletions(-)

diff --git a/tests/btrfs/057 b/tests/btrfs/057
index b019f4e1e054..82e3162ebfeb 100755
--- a/tests/btrfs/057
+++ b/tests/btrfs/057
@@ -32,13 +32,9 @@ _require_scratch
 
 rm -f $seqres.full
 
-# use small leaf size to get higher btree height.
-run_check _scratch_mkfs "-b 1g --nodesize 4096"
+run_check _scratch_mkfs "-b 1g"
 
-# inode cache is saved in the FS tree itself for every
-# individual FS tree,that affects the sizes reported by qgroup show
-# so we need to explicitly turn it off to get consistent values.
-_scratch_mount "-o noinode_cache"
+_scratch_mount
 
 # -w ensures that the only ops are ones which cause write I/O
 run_check $FSSTRESS_PROG -d $SCRATCH_MNT -w -p 5 -n 1000 \
@@ -53,14 +49,8 @@ run_check $FSSTRESS_PROG -d $SCRATCH_MNT/snap1 -w -p 5 -n 1000 \
 _run_btrfs_util_prog quota enable $SCRATCH_MNT
 _run_btrfs_util_prog quota rescan -w $SCRATCH_MNT
 
-# remove all file/dir other than subvolume
-rm -rf $SCRATCH_MNT/snap1/* >& /dev/null
-rm -rf $SCRATCH_MNT/p* >& /dev/null
-
-_run_btrfs_util_prog filesystem sync $SCRATCH_MNT
-units=`_btrfs_qgroup_units`
-$BTRFS_UTIL_PROG qgroup show $units $SCRATCH_MNT | $SED_PROG -n '/[0-9]/p' \
-	| $AWK_PROG '{print $2" "$3}'
+echo "Silence is golden"
+# btrfs check will detect any qgroup number mismatch.
 
 status=0
 exit
diff --git a/tests/btrfs/057.out b/tests/btrfs/057.out
index 60cb92d0926c..185023c79961 100644
--- a/tests/btrfs/057.out
+++ b/tests/btrfs/057.out
@@ -1,3 +1,2 @@
 QA output created by 057
-4096 4096
-4096 4096
+Silence is golden
-- 
2.19.1

