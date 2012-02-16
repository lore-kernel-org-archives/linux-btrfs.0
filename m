From: Danny Kukawka <danny.kukawka@bisect.de>
Subject: [PATCH] btrfs/check-integrity.c: included disk-io.h twice
Date: Thu, 16 Feb 2012 14:55:29 +0100
Message-ID: <1329400529-31793-1-git-send-email-danny.kukawka@bisect.de>
Cc: Danny Kukawka <dkukawka@suse.de>, linux-btrfs@vger.kernel.org,
	linux-kernel@vger.kernel.org
To: Chris Mason <chris.mason@oracle.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

fs/btrfs/check-integrity.c included disk-io.h twice, remove the
duplicate.

Signed-off-by: Danny Kukawka <danny.kukawka@bisect.de>
---
 fs/btrfs/check-integrity.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/fs/btrfs/check-integrity.c b/fs/btrfs/check-integrity.c
index b669a7d..064b29b 100644
--- a/fs/btrfs/check-integrity.c
+++ b/fs/btrfs/check-integrity.c
@@ -89,7 +89,6 @@
 #include "disk-io.h"
 #include "transaction.h"
 #include "extent_io.h"
-#include "disk-io.h"
 #include "volumes.h"
 #include "print-tree.h"
 #include "locking.h"
-- 
1.7.8.3
