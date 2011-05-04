From: Josef Bacik <josef@redhat.com>
Subject: [PATCH] Btrfs: set range_start to the right start in count_range_bits
Date: Wed,  4 May 2011 11:14:31 -0400
Message-ID: <1304522071-18909-1-git-send-email-josef@redhat.com>
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

In count_range_bits we are adjusting total_bytes based on the range we are
searching for, but we don't adjust the range start according to the range we are
searching for, which makes for weird results.  For example, if the range

[0-8192]

is set DELALLOC, but I search for 4096-8192, I will get back 4096 for the number
of bytes found, but the range_start will be 0, which makes it look like the
range is [0-4096].  So instead set range_start = max(cur_start, state->start).
This makes everything come out right.  Thanks,

Signed-off-by: Josef Bacik <josef@redhat.com>
---
 fs/btrfs/extent_io.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index 20ddb28..45a2fe5 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -1472,7 +1472,7 @@ u64 count_range_bits(struct extent_io_tree *tree,
 			if (total_bytes >= max_bytes)
 				break;
 			if (!found) {
-				*start = state->start;
+				*start = max(cur_start, state->start);
 				found = 1;
 			}
 			last = state->end;
-- 
1.7.2.3

