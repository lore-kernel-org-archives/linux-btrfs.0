Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from linux-libre.fsfla.org ([208.118.235.54]:39942 "EHLO
	linux-libre.fsfla.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753054Ab3BVBQH (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 21 Feb 2013 20:16:07 -0500
Received: from freie (home.lxoliva.fsfla.org [172.31.160.22])
	by linux-libre.fsfla.org (8.14.3/8.14.3/Debian-9.1ubuntu1) with ESMTP id r1M1G3mK006372
	for <linux-btrfs@vger.kernel.org>; Fri, 22 Feb 2013 01:16:04 GMT
From: Alexandre Oliva <oliva@gnu.org>
To: linux-btrfs@vger.kernel.org
Subject: collapse concurrent forced allocations (was: Re: clear chunk_alloc flag on retryable failure)
References: <orvc9lqsgt.fsf@livre.home>
Date: Thu, 21 Feb 2013 22:15:49 -0300
In-Reply-To: <orvc9lqsgt.fsf@livre.home> (Alexandre Oliva's message of "Thu,
	21 Feb 2013 18:15:14 -0300")
Message-ID: <orobfdqhbu.fsf@livre.home>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="=-=-="
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

--=-=-=

On Feb 21, 2013, Alexandre Oliva <oliva@gnu.org> wrote:

> What I saw in that function also happens to explain why in some cases I
> see filesystems allocate a huge number of chunks that remain unused
> (leading to the scenario above, of not having more chunks to allocate).
> It happens for data and metadata, but not necessarily both.  I'm
> guessing some thread sets the force_alloc flag on the corresponding
> space_info, and then several threads trying to get disk space end up
> attempting to allocate a new chunk concurrently.  All of them will see
> the force_alloc flag and bump their local copy of force up to the level
> they see first, and they won't clear it even if another thread succeeds
> in allocating a chunk, thus clearing the force flag.  Then each thread
> that observed the force flag will, on its turn, force the allocation of
> a new chunk.  And any threads that come in while it does that will see
> the force flag still set and pick it up, and so on.  This sounds like a
> problem to me, but...  what should the correct behavior be?  Clear
> force_flag once we copy it to a local force?  Reset force to the
> incoming value on every loop?

I think a slight variant of the following makes the most sense, so I
implemented it in the patch below.

> Set the flag to our incoming force if we have it at first, clear our
> local flag, and move it from the space_info when we determined that we
> are the thread that's going to perform the allocation?



--=-=-=
Content-Type: text/x-diff
Content-Disposition: inline; filename=force-alloc-only-once.patch

From: Alexandre Oliva <oliva@gnu.org>

btrfs: consume force_alloc in the first thread to chunk_alloc

Even if multiple threads in do_chunk_alloc look at force_alloc and see
a force flag, it suffices that one of them consumes the flag.  Arrange
for an incoming force argument to make to force_alloc in case of
concurrent calls, so that it is used only by the first thread to get
to allocation after the initial request.

Signed-off-by: Alexandre Oliva <oliva@gnu.org>
---
 fs/btrfs/extent-tree.c |    8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 6ee89d5..66283f7 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -3574,8 +3574,12 @@ static int do_chunk_alloc(struct btrfs_trans_handle *trans,
 
 again:
 	spin_lock(&space_info->lock);
+
+	/* Bring force_alloc to force and tentatively consume it.  */
 	if (force < space_info->force_alloc)
 		force = space_info->force_alloc;
+	space_info->force_alloc = CHUNK_ALLOC_NO_FORCE;
+
 	if (space_info->full) {
 		spin_unlock(&space_info->lock);
 		return 0;
@@ -3586,6 +3590,10 @@ again:
 		return 0;
 	} else if (space_info->chunk_alloc) {
 		wait_for_alloc = 1;
+		/* Reset force_alloc so that it's consumed by the
+		   first thread that completes the allocation.  */
+		space_info->force_alloc = force;
+		force = CHUNK_ALLOC_NO_FORCE;
 	} else {
 		space_info->chunk_alloc = 1;
 	}

--=-=-=


-- 
Alexandre Oliva, freedom fighter    http://FSFLA.org/~lxoliva/
You must be the change you wish to see in the world. -- Gandhi
Be Free! -- http://FSFLA.org/   FSF Latin America board member
Free Software Evangelist      Red Hat Brazil Compiler Engineer

--=-=-=--
