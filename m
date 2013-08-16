Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from xp-ob.rzone.de ([81.169.146.141]:22585 "EHLO xp-ob.rzone.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752824Ab3HPRo4 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 16 Aug 2013 13:44:56 -0400
From: Stefan Behrens <sbehrens@giantdisaster.de>
To: xfs@oss.sgi.com
Cc: linux-btrfs@vger.kernel.org
Subject: [PATCH] xfstests: btrfs/009 never shrinked or removed $seqres.full
Date: Fri, 16 Aug 2013 19:44:54 +0200
Message-Id: <1376675094-21522-1-git-send-email-sbehrens@giantdisaster.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Signed-off-by: Stefan Behrens <sbehrens@giantdisaster.de>
---
 tests/btrfs/009 | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/tests/btrfs/009 b/tests/btrfs/009
index d46744c..08aa508 100755
--- a/tests/btrfs/009
+++ b/tests/btrfs/009
@@ -47,6 +47,8 @@ _supported_fs btrfs
 _supported_os Linux
 _require_scratch
 
+rm -f $seqres.full
+
 _scratch_mkfs > /dev/null 2>&1
 _scratch_mount
 
-- 
1.8.3.4

