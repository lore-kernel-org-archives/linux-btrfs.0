Return-Path: <SRS0=Lj+K=TK=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.9 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 94656C04A6B
	for <linux-btrfs@archiver.kernel.org>; Fri, 10 May 2019 15:33:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6F42A2070D
	for <linux-btrfs@archiver.kernel.org>; Fri, 10 May 2019 15:33:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727551AbfEJPdS (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 10 May 2019 11:33:18 -0400
Received: from tartarus.angband.pl ([54.37.238.230]:34954 "EHLO
        tartarus.angband.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727459AbfEJPdS (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 10 May 2019 11:33:18 -0400
Received: from [2a02:a31c:853f:a300::4] (helo=valinor.angband.pl)
        by tartarus.angband.pl with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <kilobyte@angband.pl>)
        id 1hP7WH-0000MM-Hp; Fri, 10 May 2019 17:33:11 +0200
Received: from kilobyte by valinor.angband.pl with local (Exim 4.92)
        (envelope-from <kilobyte@valinor.angband.pl>)
        id 1hP7Vh-0006Qk-Qj; Fri, 10 May 2019 17:32:33 +0200
From:   Adam Borowski <kilobyte@angband.pl>
To:     linux-btrfs@vger.kernel.org, Goldwyn Rodrigues <rgoldwyn@suse.de>,
        linux-fsdevel@vger.kernel.org, jack@suse.cz, david@fromorbit.com,
        willy@infradead.org, hch@lst.de, darrick.wong@oracle.com,
        dsterba@suse.cz, nborisov@suse.com, linux-nvdimm@lists.01.org
Cc:     Adam Borowski <kilobyte@angband.pl>
Date:   Fri, 10 May 2019 17:32:22 +0200
Message-Id: <20190510153222.24665-1-kilobyte@angband.pl>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190429172649.8288-13-rgoldwyn@suse.de>
References: <20190429172649.8288-13-rgoldwyn@suse.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2a02:a31c:853f:a300::4
X-SA-Exim-Mail-From: kilobyte@angband.pl
Subject: [PATCH for-goldwyn] btrfs: disallow MAP_SYNC outside of DAX mounts
X-SA-Exim-Version: 4.2.1 (built Tue, 02 Aug 2016 21:08:31 +0000)
X-SA-Exim-Scanned: Yes (on tartarus.angband.pl)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Even if allocation is done synchronously, data would be lost except on
actual pmem.  Explicit msync()s don't need MAP_SYNC, and don't require
a sync per page.

Signed-off-by: Adam Borowski <kilobyte@angband.pl>
---
MAP_SYNC can't be allowed unconditionally, as cacheline flushes don't help
guarantee persistency in page cache.  This fixes an error in my earlier
patch "btrfs: allow MAP_SYNC mmap" -- you'd probably want to amend that.


 fs/btrfs/file.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
index 362a9cf9dcb2..0bc5428037ba 100644
--- a/fs/btrfs/file.c
+++ b/fs/btrfs/file.c
@@ -2233,6 +2233,13 @@ static int btrfs_file_mmap(struct file	*filp, struct vm_area_struct *vma)
 	if (!IS_DAX(inode) && !mapping->a_ops->readpage)
 		return -ENOEXEC;
 
+	/*
+	 * Normal operation of btrfs is pretty much an antithesis of MAP_SYNC;
+	 * supporting it outside DAX is pointless.
+	 */
+	if (!IS_DAX(inode) && (vma->vm_flags & VM_SYNC))
+		return -EOPNOTSUPP;
+
 	file_accessed(filp);
 	if (IS_DAX(inode))
 		vma->vm_ops = &btrfs_dax_vm_ops;
-- 
2.20.1

