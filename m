Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pf0-f194.google.com ([209.85.192.194]:42957 "EHLO
        mail-pf0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751106AbeC2HyF (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 29 Mar 2018 03:54:05 -0400
Received: by mail-pf0-f194.google.com with SMTP id a16so2704942pfn.9
        for <linux-btrfs@vger.kernel.org>; Thu, 29 Mar 2018 00:54:05 -0700 (PDT)
From: Omar Sandoval <osandov@osandov.com>
To: linux-btrfs@vger.kernel.org
Cc: kernel-team@fb.com
Subject: [PATCH 2/5] libbtrfsutil: fix memory leak in deleted_subvolumes()
Date: Thu, 29 Mar 2018 00:53:54 -0700
Message-Id: <831bd21e3be1653930c5d4b1a3c442d4e96a3b68.1522309741.git.osandov@fb.com>
In-Reply-To: <cover.1522309741.git.osandov@fb.com>
References: <cover.1522309741.git.osandov@fb.com>
In-Reply-To: <cover.1522309741.git.osandov@fb.com>
References: <cover.1522309741.git.osandov@fb.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Omar Sandoval <osandov@fb.com>

If we fail to reallocate the ID array, we still need to free it.

Signed-off-by: Omar Sandoval <osandov@fb.com>
---
 libbtrfsutil/subvolume.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/libbtrfsutil/subvolume.c b/libbtrfsutil/subvolume.c
index d6c0ced8..867b3e10 100644
--- a/libbtrfsutil/subvolume.c
+++ b/libbtrfsutil/subvolume.c
@@ -1353,8 +1353,10 @@ PUBLIC enum btrfs_util_error btrfs_util_deleted_subvolumes_fd(int fd,
 				new_capacity = capacity ? capacity * 2 : 1;
 				new_ids = reallocarray(*ids, new_capacity,
 						       sizeof(**ids));
-				if (!new_ids)
-					return BTRFS_UTIL_ERROR_NO_MEMORY;
+				if (!new_ids) {
+					err = BTRFS_UTIL_ERROR_NO_MEMORY;
+					goto out;
+				}
 
 				*ids = new_ids;
 				capacity = new_capacity;
-- 
2.16.3

