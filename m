Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from dkim1.fusionio.com ([66.114.96.53]:34670 "EHLO
	dkim1.fusionio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756812Ab3H3Siw (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 30 Aug 2013 14:38:52 -0400
Received: from mx2.fusionio.com (unknown [10.101.1.160])
	by dkim1.fusionio.com (Postfix) with ESMTP id DD7A87C041B
	for <linux-btrfs@vger.kernel.org>; Fri, 30 Aug 2013 12:38:51 -0600 (MDT)
Received: from CAS2.int.fusionio.com (cas2.int.fusionio.com [10.101.1.41]) by mx2.fusionio.com with ESMTP id jdgQWNli6QroFN66 (version=TLSv1 cipher=AES128-SHA bits=128 verify=NO) for <linux-btrfs@vger.kernel.org>; Fri, 30 Aug 2013 12:38:51 -0600 (MDT)
From: Josef Bacik <jbacik@fusionio.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH] Btrfs: actually limit the size of delalloc range
Date: Fri, 30 Aug 2013 14:38:49 -0400
Message-ID: <1377887929-3768-1-git-send-email-jbacik@fusionio.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

So forever we have had this thing to limit the amount of delalloc pages we'll
setup to be written out to 128mb.  This is because we have to lock all the pages
in this range, so anything above this gets a bit unweildly, and also without a
limit we'll happily allocate gigantic chunks of disk space.  Turns out our check
for this wasn't quite right, we wouldn't actually limit the chunk we wanted to
write out, we'd just stop looking for more space after we went over the limit.
So if you do a giant 20gb dd on my box with lots of ram I could get 2gig
extents.  This is fine normally, except when you go to relocate these extents
and we can't find enough space to relocate these moster extents, since we have
to be able to allocate exactly the same sized extent to move it around.  So fix
this by actually enforcing the limit.  With this patch I'm no longer seeing
giant 1.5gb extents.  Thanks,

Signed-off-by: Josef Bacik <jbacik@fusionio.com>
---
 fs/btrfs/extent_io.c |    8 +++++---
 1 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index 4068d40..bf6e526 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -1481,10 +1481,12 @@ static noinline u64 find_delalloc_range(struct extent_io_tree *tree,
 		*end = state->end;
 		cur_start = state->end + 1;
 		node = rb_next(node);
-		if (!node)
-			break;
 		total_bytes += state->end - state->start + 1;
-		if (total_bytes >= max_bytes)
+		if (total_bytes >= max_bytes) {
+			*end = *start + max_bytes - 1;
+			break;
+		}
+		if (!node)
 			break;
 	}
 out:
-- 
1.7.7.6

