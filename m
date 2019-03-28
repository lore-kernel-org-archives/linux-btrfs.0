Return-Path: <SRS0=ig1K=R7=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D8643C43381
	for <linux-btrfs@archiver.kernel.org>; Thu, 28 Mar 2019 10:24:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B34F6206C0
	for <linux-btrfs@archiver.kernel.org>; Thu, 28 Mar 2019 10:24:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726811AbfC1KYk (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 28 Mar 2019 06:24:40 -0400
Received: from tartarus.angband.pl ([54.37.238.230]:48486 "EHLO
        tartarus.angband.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725948AbfC1KYk (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 28 Mar 2019 06:24:40 -0400
Received: from [2a02:a31c:853f:a300::6] (helo=umbar.angband.pl)
        by tartarus.angband.pl with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <kilobyte@angband.pl>)
        id 1h9SD5-0005pN-Ua; Thu, 28 Mar 2019 11:24:35 +0100
Received: from kilobyte by umbar.angband.pl with local (Exim 4.92)
        (envelope-from <kilobyte@umbar.angband.pl>)
        id 1h9SD5-0001Qx-16; Thu, 28 Mar 2019 11:24:35 +0100
From:   Adam Borowski <kilobyte@angband.pl>
To:     Goldwyn Rodrigues <rgoldwyn@suse.de>, linux-btrfs@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, marcin.slusarz@intel.com
Cc:     Adam Borowski <kilobyte@angband.pl>
Subject: [PATCH] btrfs: allow MAP_SYNC mmap
Date:   Thu, 28 Mar 2019 11:24:18 +0100
Message-Id: <20190328102418.5466-1-kilobyte@angband.pl>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190327232635.zw4edleqwowxfzej@merlin>
References: <20190327232635.zw4edleqwowxfzej@merlin>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Used by userspace to detect DAX.

Signed-off-by: Adam Borowski <kilobyte@angband.pl>
---
 fs/btrfs/file.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
index 196c8f37ff9d..8efdb040bc1d 100644
--- a/fs/btrfs/file.c
+++ b/fs/btrfs/file.c
@@ -16,6 +16,7 @@
 #include <linux/btrfs.h>
 #include <linux/uio.h>
 #include <linux/iversion.h>
+#include <linux/mman.h>
 #include "ctree.h"
 #include "disk-io.h"
 #include "transaction.h"
@@ -3320,6 +3321,7 @@ const struct file_operations btrfs_file_operations = {
 	.splice_read	= generic_file_splice_read,
 	.write_iter	= btrfs_file_write_iter,
 	.mmap		= btrfs_file_mmap,
+	.mmap_supported_flags = MAP_SYNC,
 	.open		= btrfs_file_open,
 	.release	= btrfs_release_file,
 	.fsync		= btrfs_sync_file,
-- 
2.20.1

