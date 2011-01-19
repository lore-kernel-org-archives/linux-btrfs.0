From: Liuwenyi <qingshenlwy@gmail.com>
Subject: [PATCH] Avoid a NULL pointer in btrfs
Date: Wed, 19 Jan 2011 22:08:13 +0800
Message-ID: <4D36F04D.70505@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=GB2312
To: strongzgy@gmail.com, onlyflyer@gmail.com,
	linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org,
	ak@linux.intel.com, akpm@linux-foundation.org,
	miaox@cn.fujitsu.com, josef@redhat.
Return-path: <linux-kernel-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

In Yang Ruirui's mail, the btrfs will create a oops. This is caused by a
null pointer in test_range_bit() while lock the spinlock.

So, It is necessary to add a pointer check into test_range_bit()

---
Signed-off-by: Liu Wenyi <qingshenlwy@gmail.com>

---
fs/btrfs/extent_io.c | 3 +++
1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index 5e7a94d..0da42b5 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -1553,6 +1553,9 @@ int test_range_bit(struct extent_io_tree *tree,
u64 start, u64 end,
struct rb_node *node;
int bitset = 0;

+ if (tree == NULL)
+ return bitset;
+
spin_lock(&tree->lock);
if (cached && cached->tree && cached->start == start)
node = &cached->rb_node;
-- 
1.7.3.3



---
Best Regards,
Liu Wenyi
