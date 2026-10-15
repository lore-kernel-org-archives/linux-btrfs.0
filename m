Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8F285335B6
	for <linux-btrfs@vger.kernel.org>; Thu, 15 Oct 2026 15:15:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792077307; cv=none; b=sCnPbdw2lWwK+bn9+yn21yXQz3rF2QpMyC/DJZNsBsvbGfaKe+EH8Zj9WFtN7qZV2rzLZLca+uSAVhUeEFk3i1ZVlQaAx99s2jdkoLliD0Q1EKssm7NyeUYjrwDx1MDT/BwdiDyflcxgIVpnMtpOiSGaf8UJL9z7FQOheuB9Aww=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792077307; c=relaxed/simple;
	bh=HqStQV2lmHZLX6BW9K5/oZWjCzeaXkP//TWX7b13bwE=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=Fd3switwz4BUW8Ge4MgaX+2fOBWthSEjzmjq04p2GW9jbjQ2RXuHA12cX5xdTqDS6A9lUj6ZFgECS4JxWRFhFPb7F2rbS5tgvG5fPxsmjWEtYJUcMWokKsDLJIDAQo7BnnwAZWXdKq1gMkkVDMjGimDQlFbYwnLr3YH+PF2TVqE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=J10q34Ek; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="J10q34Ek"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC0841F000C4
	for <linux-btrfs@vger.kernel.org>; Thu, 15 Oct 2026 15:15:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792077305;
	bh=ElUY2WE5q9tM5ykAfi/OESdMyowUyjJs2p2Zala5r0I=;
	h=From:To:Subject:Date;
	b=J10q34EkckO+5GieivlONnjEHhb8BYnsKwpJ+7BOBrXWuoy1knETGj2ObUY6eChh/
	 bE3aIqSLEz4d1ikvevSJIXn6HKurg3UiJw2cViImiP6tLFhaD3RXHhhySwV6GlznGd
	 nrunju0/3NYzkGzqIdKPmfiudalc/te/iD3XnbMDO3/ByOoLta9BuUSjGVvFex8UXM
	 4ZG2ymktqOk8ac6FZXGxtC3ONdl9VtD91bvyjPtve0IGyg0ecCOGcGTwDdvWa2geUj
	 8KW1GKfFyOMU7qYWjys813pqc3yp58KtN3LcTo0RfcmjUMx8UxPg/3pywJuFouanIB
	 vOGdahJrT6EwQ==
From: fdmanana@kernel.org
To: linux-btrfs@vger.kernel.org
Subject: [PATCH] btrfs: fix fiemap merging compressed extents
Date: Thu, 15 Oct 2026 16:15:02 +0100
Message-ID: <79aa555b1433ac7bdfd9dd17e30a306a066ac762.1792077285.git.fdmanana@suse.com>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Filipe Manana <fdmanana@suse.com>

Compressed extents are never supposed to be merged by the fiemap code and
reported as a single extent, as each extent's content comes from a
different compression stream and has its own header and context.

We currently rely on checking the logical and physical address adjacency
to prevent merging compressed extents but that is broken. Consider the
following reproducer which explains why the merging happens:

  $ cat test.sh
  #!/bin/bash

  DEV=/dev/sdi
  MNT=/mnt/sdi

  mkfs.btrfs -s 4K -f $DEV
  mount -o compress $DEV $MNT

  # Do a write that compresses to a single 4K extent and represents the
  # maximum compressed chunk size (128K).
  xfs_io -f -c "pwrite 0 128K" $MNT/foo

  # Sync to flush delalloc and allocate the 4K extent.
  sync -f $MNT

  # Now allocate a 124K extent in some other file, which will be adjacent
  # (to the right) of the 4K extent previously allocated.
  xfs_io -f -c "falloc 0 124K" $MNT/filler

  # Do another write to the main file at its current EOF that is
  # compressible and fits in a 4K extent.
  xfs_io -c "pwrite 128K 128K" $MNT/foo
  # Sync to flush delalloc and allocate the 4K extent.
  sync -f $MNT

  # Run fiemap which should report 2 encoded extents, each with a
  # logical size of 128K.
  xfs_io -c "fiemap -v" $MNT/foo

  umount $MNT

Running this, fiemap will report a single extent:

  $ ./test.sh
  (...)
  /mnt/sdi/foo:
   EXT: FILE-OFFSET      BLOCK-RANGE      TOTAL FLAGS
     0: [0..511]:        26624..27135       512   0x9

Fix this by never attempting to merge extents if the flags contain
FIEMAP_EXTENT_ENCODED.

Fixes: 4751832da990 ("btrfs: fiemap: Cache and merge fiemap extent before submit it to user")
Signed-off-by: Filipe Manana <fdmanana@suse.com>
---
 fs/btrfs/fiemap.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/btrfs/fiemap.c b/fs/btrfs/fiemap.c
index 7a2a97180099..817171028413 100644
--- a/fs/btrfs/fiemap.c
+++ b/fs/btrfs/fiemap.c
@@ -228,7 +228,8 @@ static int emit_fiemap_extent(struct fiemap_extent_info *fieinfo,
 	 *
 	 * 3) Share same flags
 	 */
-	if (cache->offset + cache->len  == offset &&
+	if (!(flags & FIEMAP_EXTENT_ENCODED) &&
+	    cache->offset + cache->len == offset &&
 	    cache->phys + cache->len == phys  &&
 	    cache->flags == flags) {
 		cache->len += len;
-- 
2.53.0

