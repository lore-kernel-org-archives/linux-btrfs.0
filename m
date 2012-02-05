From: Jesper Juhl <jj@chaosbits.net>
Subject: [PATCH] BTRFS: Don't include disk-io.h twice in check-integrity.c
Date: Sun, 5 Feb 2012 01:29:47 +0100 (CET)
Message-ID: <alpine.LNX.2.00.1202050128450.30244@swampdragon.chaosbits.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: trivial@kernel.org, linux-kernel@vger.kernel.org,
	Chris Mason <chris.mason@oracle.com>
To: linux-btrfs@vger.kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Once should be enough.

Signed-off-by: Jesper Juhl <jj@chaosbits.net>
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
1.7.9


-- 
Jesper Juhl <jj@chaosbits.net>       http://www.chaosbits.net/
Don't top-post http://www.catb.org/jargon/html/T/top-post.html
Plain text mails only, please.
