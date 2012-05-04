From: Alexander Block <ablock84@googlemail.com>
Subject: [PATCH 1/3] btrfs: Fix missed backrefs in backref walking code
Date: Fri,  4 May 2012 20:54:23 +0200
Message-ID: <1336157665-17328-1-git-send-email-ablock84@googlemail.com>
Cc: linux-btrfs@vger.kernel.org,
	Alexander Block <ablock84@googlemail.com>
To: chris.mason@oracle.com
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

__merge_refs was deleting unresolved prelim refs resulting in missed
backrefs in the backref walking code. Thanks to Arne and Jan for finding
this.

Signed-off-by: Alexander Block <ablock84@googlemail.com>
---
 fs/btrfs/backref.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/fs/btrfs/backref.c b/fs/btrfs/backref.c
index b4b940e..f28ecba 100644
--- a/fs/btrfs/backref.c
+++ b/fs/btrfs/backref.c
@@ -265,6 +265,8 @@ static int __merge_refs(struct list_head *head, int mode)
 
 		if (mode == 1 && ref1->key.type == 0)
 			continue;
+		if (ref1->parent)
+			continue;
 		for (pos2 = pos1->next, n2 = pos2->next; pos2 != head;
 		     pos2 = n2, n2 = pos2->next) {
 			struct __prelim_ref *ref2;
-- 
1.7.3.4

