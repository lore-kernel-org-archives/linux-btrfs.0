Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ie0-f177.google.com ([209.85.223.177]:44087 "EHLO
	mail-ie0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750973Ab3CUGNh (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 21 Mar 2013 02:13:37 -0400
Received: by mail-ie0-f177.google.com with SMTP id 16so3110928iea.22
        for <linux-btrfs@vger.kernel.org>; Wed, 20 Mar 2013 23:13:37 -0700 (PDT)
Message-ID: <514AA503.4060101@gmail.com>
Date: Thu, 21 Mar 2013 14:13:23 +0800
From: Wang Sheng-Hui <shhuiw@gmail.com>
MIME-Version: 1.0
To: Dave Chinner <david@fromorbit.com>, xfstests <xfs@oss.sgi.com>,
        linux-btrfs@vger.kernel.org
Subject: [PATCH] xfstests 276: use _require_no_large_scratch_dev instead of
 the removed _require_nobigloopfs
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

_require_nobigloopfs has been removed.
We should use _require_no_large_scratch_dev in the test script.

Signed-off-by: Wang Sheng-Hui <shhuiw@gmail.com>
---
  276 |    3 +--
  1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/276 b/276
index 40b30cf..87363ca 100755
--- a/276
+++ b/276
@@ -58,8 +58,7 @@ _need_to_be_root
  _supported_fs btrfs
  _supported_os Linux
  _require_scratch
-
-_require_nobigloopfs
+_require_no_large_scratch_dev
  _require_btrfs inspect-internal
  _require_command "/usr/sbin/filefrag"

-- 
1.7.10.4
