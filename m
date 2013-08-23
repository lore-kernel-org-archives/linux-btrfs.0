Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from xp-ob.rzone.de ([81.169.146.137]:18153 "EHLO xp-ob.rzone.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755260Ab3HWNHO (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 23 Aug 2013 09:07:14 -0400
From: Stefan Behrens <sbehrens@giantdisaster.de>
To: xfs@oss.sgi.com
Cc: linux-btrfs@vger.kernel.org
Subject: [PATCH] xfstests: update _filter_size() for Btrfs
Date: Fri, 23 Aug 2013 15:07:12 +0200
Message-Id: <1377263233-8903-3-git-send-email-sbehrens@giantdisaster.de>
In-Reply-To: <1377263233-8903-1-git-send-email-sbehrens@giantdisaster.de>
References: <1377263233-8903-1-git-send-email-sbehrens@giantdisaster.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: root <root@qvarne.iata>

The btrfs-progs tools changed the output:
- 100GiB instead of 100GB

xfstest btrfs/006 is one that failed due to this change.

Signed-off-by: Stefan Behrens <sbehrens@giantdisaster.de>
---
 common/filter | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/common/filter b/common/filter
index dbb1674..ee738ca 100644
--- a/common/filter
+++ b/common/filter
@@ -262,7 +262,7 @@ _filter_uuid()
 # Filter out sizes like 6.14MB etc
 _filter_size()
 {
-	sed -e "s/[0-9\.]\+\s\?[b|k|m|g|t][b]\?/<SIZE>/ig"
+	sed -e "s/[0-9\.]\+\s\?[b|k|m|g|t][i]\?[b]\?/<SIZE>/ig"
 }
 
 # Convert string read from stdin like 128K to bytes and print it to stdout
-- 
1.8.3.4

