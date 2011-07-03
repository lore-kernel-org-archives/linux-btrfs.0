From: Andreas Philipp <philipp.andreas@gmail.com>
Subject: [PATCH] remove unused include "version.h"
Date: Sun,  3 Jul 2011 21:34:20 +0200
Message-ID: <1309721660-23401-1-git-send-email-philipp.andreas@gmail.com>
Cc: Andreas Philipp <philipp.andreas@gmail.com>,
	Hugo Mills <hugo@carfax.org.uk>
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

In the file btrfs-list.c version.h was included but not used. So just
drop it.

Signed-off-by: Andreas Philipp <philipp.andreas@gmail.com>
---
 btrfs-list.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/btrfs-list.c b/btrfs-list.c
index f804dfc..1495dae 100644
--- a/btrfs-list.c
+++ b/btrfs-list.c
@@ -34,7 +34,6 @@
 #include "ctree.h"
 #include "transaction.h"
 #include "utils.h"
-#include "version.h"
 
 /* we store all the roots we find in an rbtree so that we can
  * search for them later.
-- 
1.7.3.4

