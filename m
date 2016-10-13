Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:40796 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S934254AbcJMRhR (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 13 Oct 2016 13:37:17 -0400
Received: from int-mx10.intmail.prod.int.phx2.redhat.com (int-mx10.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 4522980086
        for <linux-btrfs@vger.kernel.org>; Thu, 13 Oct 2016 17:36:15 +0000 (UTC)
Received: from [IPv6:::1] (ovpn03.gateway.prod.ext.phx2.redhat.com [10.5.9.3])
        by int-mx10.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP id u9DHaC09023909
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
        for <linux-btrfs@vger.kernel.org>; Thu, 13 Oct 2016 13:36:14 -0400
To: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
From: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH] btrfs-progs: fix build for programs including ioctl.h
Message-ID: <343f2d64-948b-9653-18eb-76ae2e852b88@redhat.com>
Date: Thu, 13 Oct 2016 12:36:12 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This was reported when docker failed to build against
btrfs-progs v4.8.1.

It includes ioctl.h which now calls BUILD_ASSERT(), which
is defined in kerncompat.h, which was not included in the
ioctl.h header file.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

diff --git a/ioctl.h b/ioctl.h
index a7235c0..abea7ed 100644
--- a/ioctl.h
+++ b/ioctl.h
@@ -26,6 +26,12 @@ extern "C" {
 #include <asm/types.h>
 #include <linux/ioctl.h>
 
+#if BTRFS_FLAT_INCLUDES
+#include "kerncompat.h"
+#else
+#include <btrfs/kerncompat.h>
+#endif /* BTRFS_FLAT_INCLUDES */
+
 #ifndef __user
 #define __user
 #endif

