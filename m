Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:48786 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754558AbbHLPQY (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 12 Aug 2015 11:16:24 -0400
Message-ID: <55CB631B.2080404@fb.com>
Date: Wed, 12 Aug 2015 11:15:39 -0400
From: Josef Bacik <jbacik@fb.com>
MIME-Version: 1.0
To: Marc MERLIN <marc@merlins.org>
CC: <dsterba@suse.com>, <clm@fb.com>, <linux-btrfs@vger.kernel.org>
Subject: Re: kernel BUG at fs/btrfs/extent-tree.c:8113! (4.1.3 kernel)
References: <20150706212156.GY17274@merlins.org> <20150710134348.GB15535@suse.cz> <20150712010229.GA5284@merlins.org> <20150723115558.GQ6306@suse.cz> <20150724162446.GH30815@merlins.org> <20150803035130.GL24824@merlins.org> <20150811050758.GF29259@merlins.org> <55CA177D.1050004@fb.com> <20150812144749.GY24824@merlins.org>
In-Reply-To: <20150812144749.GY24824@merlins.org>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 08/12/2015 10:47 AM, Marc MERLIN wrote:
> On Tue, Aug 11, 2015 at 11:40:45AM -0400, Josef Bacik wrote:
>>  From a48cf7a9ae44a17d927df5542c8b0be287aee9ed Mon Sep 17 00:00:00 2001
>> From: Josef Bacik <jbacik@fb.com>
>> Date: Tue, 11 Aug 2015 11:39:37 -0400
>> Subject: [PATCH] Btrfs: kill BUG_ON() in btrfs_lookup_extent_info()
>>
>> Replace it with an ASSERT(0) for the developers and an error for not the
>> developers.
>
> Thanks. We knocked one down and now another BUG has been triggered :)
>
> 	if (unlikely(wc->refs[level - 1] == 0)) {
> 		btrfs_err(root->fs_info, "Missing references.");
> 		BUG();
> 	}
>

This is why you got your own branch, it's never just one.  Here's the 
next bit


 From 07214b5294d2772682aba893de15ef8020994598 Mon Sep 17 00:00:00 2001
From: Josef Bacik <jbacik@fb.com>
Date: Wed, 12 Aug 2015 11:06:42 -0400
Subject: [PATCH] Btrfs: don't BUG() during drop snapshot

Really there's lots of things that can go wrong here, kill all the 
BUG_ON()'s
and replace the logic ones with ASSERT()'s and return EIO instead.  Also 
fix the
leak of next in one of the error conditions while we're at it.  Thanks,

Signed-off-by: Josef Bacik <jbacik@fb.com>
---
  fs/btrfs/extent-tree.c | 27 +++++++++++++++++++++++----
  1 file changed, 23 insertions(+), 4 deletions(-)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index f7fb120..6671faf 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -8196,12 +8196,15 @@ static noinline int do_walk_down(struct 
btrfs_trans_handle *trans,
  				       &wc->flags[level - 1]);
  	if (ret < 0) {
  		btrfs_tree_unlock(next);
+		free_extent_buffer(next);
  		return ret;
  	}

  	if (unlikely(wc->refs[level - 1] == 0)) {
  		btrfs_err(root->fs_info, "Missing references.");
-		BUG();
+		btrfs_tree_unlock(next);
+		free_extent_buffer(next);
+		return -EIO;
  	}
  	*lookup_info = 0;

@@ -8253,7 +8256,13 @@ static noinline int do_walk_down(struct 
btrfs_trans_handle *trans,
  	}

  	level--;
-	BUG_ON(level != btrfs_header_level(next));
+	ASSERT(level == btrfs_header_level(next));
+	if (level != btrfs_header_level(next)) {
+		printk(KERN_ERR "Mismatched level\n");
+		btrfs_tree_unlock(next);
+		free_extent_buffer(next);
+		return -EIO;
+	}
  	path->nodes[level] = next;
  	path->slots[level] = 0;
  	path->locks[level] = BTRFS_WRITE_LOCK_BLOCKING;
@@ -8268,8 +8277,14 @@ skip:
  		if (wc->flags[level] & BTRFS_BLOCK_FLAG_FULL_BACKREF) {
  			parent = path->nodes[level]->start;
  		} else {
-			BUG_ON(root->root_key.objectid !=
+			ASSERT(root->root_key.objectid ==
  			       btrfs_header_owner(path->nodes[level]));
+			if (root->root_key.objectid !=
+			    btrfs_header_owner(path->nodes[level])) {
+				printk(KERN_ERR "Mismatched block owner\n");
+				btrfs_tree_unlock(next);
+				free_extent_buffer(next);
+			}
  			parent = 0;
  		}

@@ -8285,7 +8300,11 @@ skip:
  		}
  		ret = btrfs_free_extent(trans, root, bytenr, blocksize, parent,
  				root->root_key.objectid, level - 1, 0, 0);
-		BUG_ON(ret); /* -ENOMEM */
+		if (ret) {
+			btrfs_tree_unlock(next);
+			free_extent_buffer(next);
+			return ret;
+		}
  	}
  	btrfs_tree_unlock(next);
  	free_extent_buffer(next);
-- 
2.1.0

