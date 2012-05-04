From: Alexander Block <ablock84@googlemail.com>
Subject: [PATCH 3/3] btrfs: Update comment above ulist_next
Date: Fri,  4 May 2012 20:54:25 +0200
Message-ID: <1336157665-17328-3-git-send-email-ablock84@googlemail.com>
References: <1336157665-17328-1-git-send-email-ablock84@googlemail.com>
Cc: linux-btrfs@vger.kernel.org,
	Alexander Block <ablock84@googlemail.com>
To: chris.mason@oracle.com
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1336157665-17328-1-git-send-email-ablock84@googlemail.com>
List-ID: <linux-btrfs.vger.kernel.org>

The comment above ulist_next stated that it's allowed to call ulist_add
while enumerating. This is actually not allowed as an add may realocate
the nodes buffer und thus make the prev pointer invalid.

Signed-off-by: Alexander Block <ablock84@googlemail.com>
---
 fs/btrfs/ulist.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/ulist.c b/fs/btrfs/ulist.c
index 12f5147..07ea3e5 100644
--- a/fs/btrfs/ulist.c
+++ b/fs/btrfs/ulist.c
@@ -198,8 +198,8 @@ EXPORT_SYMBOL(ulist_add);
  * end is reached. No guarantee is made with respect to the order in which
  * the elements are returned. They might neither be returned in order of
  * addition nor in ascending order.
- * It is allowed to call ulist_add during an enumeration. Newly added items
- * are guaranteed to show up in the running enumeration.
+ * It is not allowed to call ulist_add during an enumeration as this would
+ * cause undefined behavior.
  */
 struct ulist_node *ulist_next(struct ulist *ulist, struct ulist_node *prev)
 {
-- 
1.7.3.4

