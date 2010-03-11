From: Andy Lutomirski <luto@MIT.EDU>
Subject: [PATCH] Add .gitignore
Date: Thu, 11 Mar 2010 16:05:52 -0500
Message-ID: <1268341552-7546-1-git-send-email-luto@mit.edu>
Cc: Andy Lutomirski <luto@mit.edu>
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Signed-off-by: Andy Lutomirski <luto@mit.edu>
---
 .gitignore |   13 +++++++++++++
 1 files changed, 13 insertions(+), 0 deletions(-)
 create mode 100644 .gitignore

diff --git a/.gitignore b/.gitignore
new file mode 100644
index 0000000..4d2ab6f
--- /dev/null
+++ b/.gitignore
@@ -0,0 +1,13 @@
+*.o
+*.o.d
+man/*.gz
+/btrfs
+/btrfs-debug-tree
+/btrfs-map-logical
+/btrfs-show
+/btrfs-vol
+/btrfsck
+/btrfsctl
+/mkfs.btrfs
+/version.h
+*~
-- 
1.6.6.1

