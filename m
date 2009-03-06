From: Josef Bacik <jbacik@redhat.com>
Subject: [PATCH] btrfs-progs: fix show-blocks
Date: Fri,  6 Mar 2009 15:53:41 -0500
Message-ID: <1236372821-19621-1-git-send-email-jbacik@redhat.com>
Cc: Josef Bacik <jbacik@redhat.com>
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <>
List-ID: <linux-btrfs.vger.kernel.org>

Show-blocks was using debug-tree, which has has been renamed to
btrfs-debug-tree.  This fixes it so show-blocks will work now.

Signed-off-by: Josef Bacik <jbacik@redhat.com>
---
 show-blocks |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/show-blocks b/show-blocks
index 8db4c0b..b47199c 100755
--- a/show-blocks
+++ b/show-blocks
@@ -99,7 +99,7 @@ def loaddata(fh,delimiter=None, converters=None):
     return X
 
 def run_debug_tree(device):
-    p = os.popen('debug-tree -e ' + device)
+    p = os.popen('btrfs-debug-tree -e ' + device)
     data = loaddata(p)
     return data
 
-- 
1.5.4.3

