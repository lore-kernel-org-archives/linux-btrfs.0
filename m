Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pg0-f42.google.com ([74.125.83.42]:35889 "EHLO
        mail-pg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750766AbdFFXpl (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Tue, 6 Jun 2017 19:45:41 -0400
Received: by mail-pg0-f42.google.com with SMTP id a70so32457839pge.3
        for <linux-btrfs@vger.kernel.org>; Tue, 06 Jun 2017 16:45:41 -0700 (PDT)
From: Omar Sandoval <osandov@osandov.com>
To: linux-btrfs@vger.kernel.org
Cc: Josef Bacik <jbacik@fb.com>, Liu Bo <bo.li.liu@oracle.com>,
        kernel-team@fb.com
Subject: [PATCH 0/7] Btrfs: fix total_bytes_pinned counter
Date: Tue,  6 Jun 2017 16:45:25 -0700
Message-Id: <cover.1496792333.git.osandov@fb.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Omar Sandoval <osandov@fb.com>

This series fixes several problems with the total_bytes_pinned counter.
Patches 1 and 2 are cleanups. Patches 3 and 4 are straightforward fixes.
Patch 5 is prep for patch 6. Patch 6 is the most complicated fix.
Patches 5 and 6 are ugly, I'd love any suggestions for a cleaner fix.
Finally, patch 7 adds a warning to catch similar issues in the future.

Tested with this xfstests diff, which exposes a bunch of the issues
without these fixes:

diff --git a/common/rc b/common/rc
index 743df427..95e7517b 100644
--- a/common/rc
+++ b/common/rc
@@ -484,6 +484,12 @@ _scratch_unmount()
 		_overlay_scratch_unmount
 		;;
 	btrfs)
+		if uuid="$(findmnt -n -o UUID "$SCRATCH_MNT")"; then
+			pushd "/sys/fs/btrfs/$uuid/allocation" >/dev/null
+			sync; sync; sync
+			grep -H -v '^0$' */total_bytes_pinned
+			popd >/dev/null
+		fi
 		$UMOUNT_PROG $SCRATCH_MNT
 		;;
 	*)

Omar Sandoval (7):
  Btrfs: make add_pinned_bytes() take an s64 num_bytes instead of u64
  Btrfs: make BUG_ON() in add_pinned_bytes() an ASSERT()
  Btrfs: update total_bytes_pinned when pinning down extents
  Btrfs: always account pinned bytes when dropping a tree block ref
  Btrfs: return old and new total ref mods when adding delayed refs
  Btrfs: rework delayed ref total_bytes_pinned accounting
  Btrfs: warn if total_bytes_pinned is non-zero on unmount

 fs/btrfs/delayed-ref.c |  29 +++++++---
 fs/btrfs/delayed-ref.h |   6 ++-
 fs/btrfs/extent-tree.c | 142 +++++++++++++++++++++++++++++--------------------
 3 files changed, 109 insertions(+), 68 deletions(-)

-- 
2.13.0

