Return-Path: <linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 378EDC433EF
	for <linux-btrfs@archiver.kernel.org>; Tue, 24 May 2022 07:19:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235074AbiEXHTA (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 24 May 2022 03:19:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52814 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235072AbiEXHS5 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 24 May 2022 03:18:57 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A551E6A02C;
        Tue, 24 May 2022 00:18:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=n+wo9xrNibche57KhrvTj7WL7MFCKfCq0IHrcn1xQKQ=; b=3E9LfsmytJv818PcQZcvDjH3wR
        uGp9P7zwg6JuKF5eIeXPjWsDMCgC5fb3zJSnqNyw0SdBxEzGhzyyYUcp6Q/Te0UDapkWglkR2B+ME
        Op0kT0mlSe9znP1p9AYZa3HKvPZ6oJIqLgWOm+sUoV7dgqKJAtc97zQoWQP21Uds6aXeV/bdCwnaB
        iVcdc4U6LC5uIVBiPZ9fuDMLBD27/cyRLQjDNMpdxBh37TIQNDqrydb5j9PYi3JH5zEeTxHd3WYFL
        3JPgNM7lXCGVg2vmVFLcrTk0LofIBZl4BO3m3DjJeIl4ttBQQxYbMk+XQSeJt312uraN2mmKwEFmD
        GRJmXA3g==;
Received: from [2001:4bb8:18c:7298:31fd:9579:b449:3c3a] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1ntOoh-0073He-PR; Tue, 24 May 2022 07:18:56 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     fstests@vger.kernel.org
Cc:     linux-btrfs@vger.kernel.org
Subject: [PATCH 4/9] btrfs/142: use common read repair helpers
Date:   Tue, 24 May 2022 09:18:33 +0200
Message-Id: <20220524071838.715013-5-hch@lst.de>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220524071838.715013-1-hch@lst.de>
References: <20220524071838.715013-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Use the common helpers to find the btrfs logical address and to read from
a specific mirror.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 tests/btrfs/142 | 10 +++-------
 1 file changed, 3 insertions(+), 7 deletions(-)

diff --git a/tests/btrfs/142 b/tests/btrfs/142
index 58d01add..7a63fb83 100755
--- a/tests/btrfs/142
+++ b/tests/btrfs/142
@@ -27,7 +27,6 @@ _require_scratch_dev_pool 2
 _require_dm_target dust
 
 _require_btrfs_command inspect-internal dump-tree
-_require_command "$FILEFRAG_PROG" filefrag
 
 _scratch_dev_pool_get 2
 # step 1, create a raid1 btrfs which contains one 128k file.
@@ -46,8 +45,7 @@ $XFS_IO_PROG -f -d -c "pwrite -S 0xaa -b 128K 0 128K" "$SCRATCH_MNT/foobar" |\
 # step 2, corrupt the first 64k of stripe #1
 echo "step 2......corrupt file extent" >>$seqres.full
 
-${FILEFRAG_PROG} -v $SCRATCH_MNT/foobar >> $seqres.full
-logical_in_btrfs=`${FILEFRAG_PROG} -v $SCRATCH_MNT/foobar | _filter_filefrag | cut -d '#' -f 1`
+logical_in_btrfs=$(_btrfs_get_first_logical $SCRATCH_MNT/foobar)
 echo "Logical offset is $logical_in_btrfs" >>$seqres.full
 _scratch_unmount
 
@@ -67,10 +65,8 @@ echo "step 3......repair the bad copy" >>$seqres.full
 
 $DMSETUP_PROG message dust-test 0 addbadblock $((physical / 512))
 $DMSETUP_PROG message dust-test 0 enable
-while [[ -z $( (( BASHPID % 2 == stripe )) &&
-	       exec $XFS_IO_PROG -d -c "pread -b 128K 0 128K" "$SCRATCH_MNT/foobar") ]]; do
-	:
-done
+
+_btrfs_direct_read_on_mirror $stripe 2 "$SCRATCH_MNT/foobar" 0 128K
 
 _cleanup_dust
 
-- 
2.30.2

