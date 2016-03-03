Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:52026 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754218AbcCCRag (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 3 Mar 2016 12:30:36 -0500
From: fdmanana@kernel.org
To: fstests@vger.kernel.org
Cc: linux-btrfs@vger.kernel.org, Filipe Manana <fdmanana@suse.com>
Subject: [PATCH] fstests: remove call to _need_to_be_root from btrfs/118
Date: Thu,  3 Mar 2016 07:32:57 +0000
Message-Id: <1456990377-2453-1-git-send-email-fdmanana@kernel.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Filipe Manana <fdmanana@suse.com>

The function _need_to_be_root does not exists anymore as of commit
56ff01f471c9 ("xfstests: remove _need_to_be_root").

A v2 of the patch that added test btrfs/118 without calling this
function was sent but not picked [1], instead v1 was picked.

So fix this now.

[1] https://patchwork.kernel.org/patch/8354831/

Signed-off-by: Filipe Manana <fdmanana@suse.com>
---
 tests/btrfs/118 | 1 -
 1 file changed, 1 deletion(-)

diff --git a/tests/btrfs/118 b/tests/btrfs/118
index 3ed1cbe..740cb92 100755
--- a/tests/btrfs/118
+++ b/tests/btrfs/118
@@ -45,7 +45,6 @@ _cleanup()
 . ./common/dmflakey
 
 # real QA test starts here
-_need_to_be_root
 _supported_fs btrfs
 _supported_os Linux
 _require_scratch
-- 
2.7.0.rc3

