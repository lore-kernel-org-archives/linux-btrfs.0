Return-Path: <SRS0=M5aM=SM=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E734DC282CE
	for <linux-btrfs@archiver.kernel.org>; Wed, 10 Apr 2019 08:35:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B77EE2075B
	for <linux-btrfs@archiver.kernel.org>; Wed, 10 Apr 2019 08:35:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729605AbfDJIfO (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 10 Apr 2019 04:35:14 -0400
Received: from mx2.suse.de ([195.135.220.15]:54008 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726630AbfDJIfO (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 10 Apr 2019 04:35:14 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 18CF7AE64;
        Wed, 10 Apr 2019 08:35:13 +0000 (UTC)
From:   Qu Wenruo <wqu@suse.com>
To:     linux-btrfs@vger.kernel.org, linux-block@vger.kernel.org,
        linux-fsdevel@vger.kernel.org
Subject: [PATCH RFC 1/2] errno.h: Export EFSCORRUPTED error number
Date:   Wed, 10 Apr 2019 16:35:07 +0800
Message-Id: <20190410083508.21091-1-wqu@suse.com>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Xfs and Ext* uses EFSCORRUPTED to indicate filesystem corruption.
They both map EFSCORRUPTED to EUCLEAN.

Btrfs/Ubifs/fscrypto all use EUCLEAN directly to indicate filesystem
corruption.

And block layer is going to distinguish filesystem corruption with
oridinary EIO error, it's a good idea to export the initial EFSCORRUPTED
declaration to <linux/errno.h> so all filesystems and block layer can
take advantage of this easier-to-read error number.

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 fs/ext2/ext2.h                   | 1 -
 fs/ext4/ext4.h                   | 1 -
 fs/xfs/xfs_linux.h               | 1 -
 include/uapi/asm-generic/errno.h | 3 +++
 4 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/ext2/ext2.h b/fs/ext2/ext2.h
index 10ab238de9a6..03d0ca8fae42 100644
--- a/fs/ext2/ext2.h
+++ b/fs/ext2/ext2.h
@@ -369,7 +369,6 @@ struct ext2_inode {
  */
 #define	EXT2_VALID_FS			0x0001	/* Unmounted cleanly */
 #define	EXT2_ERROR_FS			0x0002	/* Errors detected */
-#define	EFSCORRUPTED			EUCLEAN	/* Filesystem is corrupted */
 
 /*
  * Mount flags
diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index 82ffdacdc7fa..f906b5cbf96d 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -3248,6 +3248,5 @@ extern const struct iomap_ops ext4_iomap_ops;
 #endif	/* __KERNEL__ */
 
 #define EFSBADCRC	EBADMSG		/* Bad CRC detected */
-#define EFSCORRUPTED	EUCLEAN		/* Filesystem is corrupted */
 
 #endif	/* _EXT4_H */
diff --git a/fs/xfs/xfs_linux.h b/fs/xfs/xfs_linux.h
index edbd5a210df2..36e5c6549f15 100644
--- a/fs/xfs/xfs_linux.h
+++ b/fs/xfs/xfs_linux.h
@@ -125,7 +125,6 @@ typedef __u32			xfs_nlink_t;
 
 #define ENOATTR		ENODATA		/* Attribute not found */
 #define EWRONGFS	EINVAL		/* Mount with wrong filesystem type */
-#define EFSCORRUPTED	EUCLEAN		/* Filesystem is corrupted */
 #define EFSBADCRC	EBADMSG		/* Bad CRC detected */
 
 #define SYNCHRONIZE()	barrier()
diff --git a/include/uapi/asm-generic/errno.h b/include/uapi/asm-generic/errno.h
index cf9c51ac49f9..ebd6e7e76a98 100644
--- a/include/uapi/asm-generic/errno.h
+++ b/include/uapi/asm-generic/errno.h
@@ -98,6 +98,9 @@
 #define	EINPROGRESS	115	/* Operation now in progress */
 #define	ESTALE		116	/* Stale file handle */
 #define	EUCLEAN		117	/* Structure needs cleaning */
+
+#define EFSCORRUPTED	EUCLEAN	/* Filesystem is corrupted */
+
 #define	ENOTNAM		118	/* Not a XENIX named type file */
 #define	ENAVAIL		119	/* No XENIX semaphores available */
 #define	EISNAM		120	/* Is a named type file */
-- 
2.21.0

