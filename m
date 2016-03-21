Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:1793 "EHLO
	mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755715AbcCUPAW (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 21 Mar 2016 11:00:22 -0400
Date: Mon, 21 Mar 2016 11:00:14 -0400
From: Chris Mason <clm@fb.com>
To: linux-btrfs <linux-btrfs@vger.kernel.org>,
        Chandan Rajendra <chandan@linux.vnet.ibm.com>
Subject: [PATCH] btrfs: make sure we stay inside the bvec during
 __btrfs_lookup_bio_sums
Message-ID: <20160321150014.hod3ktlnpaxbx2u7@floor.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi everyone,

I realized last week that CONFIG_DEBUG_PAGEALLOC had dropped out of my
config, and hit a crash inside __btrfs_lookup_bio_sums once I enabled it
again.  It's hard for this bug to cause problems because Chandan's inner
loop is always done at the same time the outer loop is done.  Without my
goto, it's just exiting normally, but only after reading bvec->bv_len
(which isn't valid).

I have this on top of my integration-4.6.  Once things pass I'll
send a pull later today or Tuesday morning:

Commit c40a3d38aff4e1c (Btrfs: Compute and look up csums based on
sectorsized blocks) changes around how we walk the bios while looking up
crcs.  There's an inner loop that is jumping to the next bvec based on
sectors and before it derefs the next bvec, it needs to make sure we're
still in the bio.

In this case, the outer loop would have decided to stop moving forward
too, and the bvec deref is never actually used for anything.  But
CONFIG_DEBUG_PAGEALLOC catches it because we're outside our bio.

Signed-off-by: Chris Mason <clm@fb.com>
Reviewed-by: David Sterba <dsterba@suse.com>
---
 fs/btrfs/file-item.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/fs/btrfs/file-item.c b/fs/btrfs/file-item.c
index 763fd17..b5baf5b 100644
--- a/fs/btrfs/file-item.c
+++ b/fs/btrfs/file-item.c
@@ -292,12 +292,22 @@ found:
 			page_bytes_left -= root->sectorsize;
 			if (!page_bytes_left) {
 				bio_index++;
+				/*
+				 * make sure we're still inside the
+				 * bio before we update page_bytes_left
+				 */
+				if (bio_index >= bio->bi_vcnt) {
+					WARN_ON_ONCE(count);
+					goto done;
+				}
 				bvec++;
 				page_bytes_left = bvec->bv_len;
 			}
 
 		}
 	}
+
+done:
 	btrfs_free_path(path);
 	return 0;
 }
-- 
2.8.0.rc2

