Return-Path: <linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 62DEAC433F5
	for <linux-btrfs@archiver.kernel.org>; Tue, 24 May 2022 07:19:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235093AbiEXHTE (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 24 May 2022 03:19:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52888 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235076AbiEXHTD (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 24 May 2022 03:19:03 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 375BB85ED2;
        Tue, 24 May 2022 00:19:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=dKRNlY+k596MFrV9bidGswiQpMPScn+2KCofeMuUMQE=; b=DQm/rr5dpW0uNzPYFfca7iNut3
        2R+NA6X3Lj5S4gFRoO0KznLSivO3q0cGKtXDaT5cxRcTtQWIp+FxQCFkXf52OeAuSJVVL6luMtX6P
        uFNIrMWOk2dohBc4GaIVXh6SCm3ePDlmTCS1GudaL639TNbrpM6n22L+ts0vBAPyrZNp5woHt5CDB
        sPx8zfrNUwGTkWav+lzrrIzkb3iaPvR+jEKhWCCJOADvRONLegxTvcNlVyia/WnSZChcLUiIewoUa
        uJDOS/ZGgLy34xaU1X8xwFOdg2bAyRp6VrMz3j58aYf/8UxN+9eZ5gnCVAB1sWFzHmon7jFCqFZCe
        gLugqYlA==;
Received: from [2001:4bb8:18c:7298:31fd:9579:b449:3c3a] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1ntOoo-0073Is-Dp; Tue, 24 May 2022 07:19:02 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     fstests@vger.kernel.org
Cc:     linux-btrfs@vger.kernel.org
Subject: [PATCH 6/9] btrfs/157: use _btrfs_get_first_logical
Date:   Tue, 24 May 2022 09:18:35 +0200
Message-Id: <20220524071838.715013-7-hch@lst.de>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220524071838.715013-1-hch@lst.de>
References: <20220524071838.715013-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Use the _btrfs_get_first_logical helper instead of open coding it.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 tests/btrfs/157 | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tests/btrfs/157 b/tests/btrfs/157
index 343178b7..022db511 100755
--- a/tests/btrfs/157
+++ b/tests/btrfs/157
@@ -71,7 +71,7 @@ _scratch_mount $(_btrfs_no_v1_cache_opt)
 $XFS_IO_PROG -f -d -c "pwrite -S 0xaa 0 128K" -c "fsync" \
 	"$SCRATCH_MNT/foobar" | _filter_xfs_io
 
-logical=`${FILEFRAG_PROG} -v $SCRATCH_MNT/foobar | _filter_filefrag | cut -d '#' -f 1`
+logical=$(_btrfs_get_first_logical $SCRATCH_MNT/foobar)
 _scratch_unmount
 
 phy0=$(get_physical 0)
-- 
2.30.2

