Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from linux-libre.fsfla.org ([208.118.235.54]:39676 "EHLO
	linux-libre.fsfla.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754756Ab3BUVX2 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 21 Feb 2013 16:23:28 -0500
Received: from freie (home.lxoliva.fsfla.org [172.31.160.22])
	by linux-libre.fsfla.org (8.14.3/8.14.3/Debian-9.1ubuntu1) with ESMTP id r1LLFJWI018510
	for <linux-btrfs@vger.kernel.org>; Thu, 21 Feb 2013 21:15:20 GMT
From: Alexandre Oliva <oliva@gnu.org>
To: linux-btrfs@vger.kernel.org
Subject: clear chunk_alloc flag on retryable failure
Date: Thu, 21 Feb 2013 18:15:14 -0300
Message-ID: <orvc9lqsgt.fsf@livre.home>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="=-=-="
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

--=-=-=

I've experienced filesystem freezes with permanent spikes in the active
process count for quite a while, particularly on filesystems whose
available raw space has already been fully allocated to chunks.

While looking into this, I found a pretty obvious error in
do_chunk_alloc: it sets space_info->chunk_alloc, but if
btrfs_alloc_chunk returns an error other than ENOSPC, it returns leaving
that flag set, which causes any other threads waiting for
space_info->chunk_alloc to become zero to spin indefinitely.

I haven't double-checked that this patch fixes the failure I've observed
fully (it's not exactly trivial to trigger), but it surely is a bug and
the fix is trivial, so...  Please put it in :-)


What I saw in that function also happens to explain why in some cases I
see filesystems allocate a huge number of chunks that remain unused
(leading to the scenario above, of not having more chunks to allocate).
It happens for data and metadata, but not necessarily both.  I'm
guessing some thread sets the force_alloc flag on the corresponding
space_info, and then several threads trying to get disk space end up
attempting to allocate a new chunk concurrently.  All of them will see
the force_alloc flag and bump their local copy of force up to the level
they see first, and they won't clear it even if another thread succeeds
in allocating a chunk, thus clearing the force flag.  Then each thread
that observed the force flag will, on its turn, force the allocation of
a new chunk.  And any threads that come in while it does that will see
the force flag still set and pick it up, and so on.  This sounds like a
problem to me, but...  what should the correct behavior be?  Clear
force_flag once we copy it to a local force?  Reset force to the
incoming value on every loop?  Set the flag to our incoming force if we
have it at first, clear our local flag, and move it from the space_info
when we determined that we are the thread that's going to perform the
allocation?



--=-=-=
Content-Type: text/x-diff
Content-Disposition: inline; filename=clear-chunk-alloc-on-failure.patch

btrfs: clear chunk_alloc flag on retryable failure

From: Alexandre Oliva <oliva@gnu.org>

If btrfs_alloc_chunk fails with e.g. ENOMEM, we exit do_chunk_alloc
without clearing chunk_alloc in space_info.  As a result, any further
calls to do_chunk_alloc on that filesystem will start busy-waiting for
chunk_alloc to be cleared, but it never will be.  This patch adjusts
do_chunk_alloc so that it clears this flag in case of an error.

Signed-off-by: Alexandre Oliva <oliva@gnu.org>
---
 fs/btrfs/extent-tree.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 5a3327b..b597cdf 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -3632,19 +3632,21 @@ again:
 	check_system_chunk(trans, extent_root, flags);
 
 	ret = btrfs_alloc_chunk(trans, extent_root, flags);
+
+	spin_lock(&space_info->lock);
+
 	if (ret < 0 && ret != -ENOSPC)
 		goto out;
 
-	spin_lock(&space_info->lock);
 	if (ret)
 		space_info->full = 1;
 	else
 		ret = 1;
 
 	space_info->force_alloc = CHUNK_ALLOC_NO_FORCE;
+out:
 	space_info->chunk_alloc = 0;
 	spin_unlock(&space_info->lock);
-out:
 	mutex_unlock(&fs_info->chunk_mutex);
 	return ret;
 }

--=-=-=


-- 
Alexandre Oliva, freedom fighter    http://FSFLA.org/~lxoliva/
You must be the change you wish to see in the world. -- Gandhi
Be Free! -- http://FSFLA.org/   FSF Latin America board member
Free Software Evangelist      Red Hat Brazil Compiler Engineer

--=-=-=--
