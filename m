From: Surbhi Palande <surbhi.palande@canonical.com>
Subject: [PATCH][btrfs-progs] Prevent a SIGSEGV by returning -1 from btrfs_search_slot()
Date: Thu, 19 Aug 2010 12:28:56 +0300
Message-ID: <1282210136-3625-1-git-send-email-surbhi.palande@canonical.com>
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

https://launchpad.net/bugs/601877

btrfs_search_slot() returns
* -1 when some error is encountered
* +1 when the item to be searched is not found
* 0 when the item is found successfully.

Now, read_node_slot() fails due to an  I/O error or due to a malloc failure.
When read_node_slot() cannot read the item to be searched, then
btrfs_search_slot() should return a -1 and not +1 as it was originally
returning. The caller of btrfs_search_slot() expects that on +1, the path[] is
appropriately populated. But due to the error in read_node_slot(), path[] is
not getting populated. Accessing the unpopulated path[] leads to a segfault.

Signed-off-by: Surbhi Palande <surbhi.palande@canonical.com>
---
 ctree.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/ctree.c b/ctree.c
index f70e10c..8ec7bf8 100644
--- a/ctree.c
+++ b/ctree.c
@@ -1264,6 +1264,9 @@ again:
 						 key->objectid);
 
 			b = read_node_slot(root, b, slot);
+			if (!b) {
+				return -1;	
+			}
 		} else {
 			p->slots[level] = slot;
 			if (ins_len > 0 &&
-- 
1.7.0.4

