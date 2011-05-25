From: Arne Jansen <sensille@gmx.net>
Subject: [PATCH] btrfs scrub: don't coalesce pages that are logically discontiguous
Date: Wed, 25 May 2011 14:22:50 +0200
Message-ID: <1306326170-28208-1-git-send-email-sensille@gmx.net>
To: chris.mason@oracle.com, linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

scrub_page collects several pages into one bio as long as they are physically
contiguous. As we only save one logical address for the whole bio, don't
collect pages that are physically contiguous but logically discontiguous.

Signed-off-by: Arne Jansen <sensille@gmx.net>
---
 fs/btrfs/scrub.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/fs/btrfs/scrub.c b/fs/btrfs/scrub.c
index a31f2a9..21ee93c 100644
--- a/fs/btrfs/scrub.c
+++ b/fs/btrfs/scrub.c
@@ -631,7 +631,8 @@ again:
 	if (sbio->count == 0) {
 		sbio->physical = physical;
 		sbio->logical = logical;
-	} else if (sbio->physical + sbio->count * PAGE_SIZE != physical) {
+	} else if (sbio->physical + sbio->count * PAGE_SIZE != physical ||
+		   sbio->logical + sbio->count * PAGE_SIZE != logical) {
 		scrub_submit(sdev);
 		goto again;
 	}
-- 
1.7.3.4

