From: Miao Xie <miaox@cn.fujitsu.com>
Subject: [PATCH 2/2] btrfs: fix oops when leafsize is greator than nodesize
Date: Tue, 13 Jul 2010 16:55:55 +0800
Message-ID: <4C3C2A1B.2020608@cn.fujitsu.com>
Reply-To: miaox@cn.fujitsu.com
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Cc: Linux Btrfs <linux-btrfs@vger.kernel.org>
To: Chris Mason <chris.mason@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

oops occured when we ran the following commands on the filesystem whose
leafsize is greater than its nodesize.
  # mkfs.btrfs -l 8192 /dev/sda1
                  ^^^^ 2 * PAGESIZE
  # mount /dev/sda1 /mnt
  # cat /dev/zero > /mnt/tmp_file0
  # umount /mnt
  Oops occured.
(Sometimes we must do the loop of mount/umount several times to hit this bug)

Oops infomation:
------------[ cut here ]------------
WARNING: at fs/btrfs/extent_io.c:3685 copy_extent_buffer+0x48/0x192()
Hardware name: FFFFFFFFFF
Modules linked in: [snip]
Pid: 3743, comm: umount Not tainted 2.6.35-rc4 #22
Call Trace:
  [<ffffffff8103782e>] warn_slowpath_common+0x80/0x98
  [<ffffffff8103785b>] warn_slowpath_null+0x15/0x17
  [<ffffffff811713a3>] copy_extent_buffer+0x48/0x192
  [<ffffffff81140488>] __btrfs_cow_block+0x16f/0x559
  [<ffffffff81140ee7>] btrfs_cow_block+0x189/0x1a6
  [<ffffffff81157cf0>] commit_cowonly_roots+0x54/0x193
  [<ffffffff811587d5>] btrfs_commit_transaction+0x380/0x610
  [<ffffffff81050a67>] ? autoremove_wake_function+0x0/0x34
  [<ffffffff811554bf>] btrfs_commit_super+0xa2/0xc3
  [<ffffffff8115551a>] close_ctree+0x3a/0x330
  [<ffffffff810545e8>] ? up_write+0x1e/0x36
  [<ffffffff810f4818>] ? invalidate_inodes+0x120/0x132
  [<ffffffff8113b233>] btrfs_put_super+0x18/0x27
  [<ffffffff810e395c>] generic_shutdown_super+0x51/0xd2
  [<ffffffff810e3a28>] kill_anon_super+0x11/0x4f
  [<ffffffff810e2af8>] deactivate_locked_super+0x21/0x41
  [<ffffffff810e2cd0>] deactivate_super+0x40/0x44
  [<ffffffff810f7a4b>] mntput_no_expire+0xb8/0xe5
  [<ffffffff810f7fea>] sys_umount+0x2c8/0x2f3
  [<ffffffff8106062a>] ? trace_hardirqs_on_caller+0x10c/0x130
  [<ffffffff81001f2b>] system_call_fastpath+0x16/0x1b
---[ end trace 5f7f4dbc8bcadbc3 ]---

The reason is that:
In order to reuse the extent buffer, the btrfs doesn't release the extent
buffer, When the btrfs releases its device space. So if the btrfs allocates
the device space that has been released just now, the btrfs will get the old
extent buffer mapping to the device space.

But if the length of the new space is greator than the old extent buffer, a
BUG() will be touched.

The patch fixes this problem by change the length of the old extent buffer.

Signed-off-by: Miao Xie <miaox@cn.fujitsu.com>
---
  fs/btrfs/extent_io.c |   90 +++++++++++++++++++++++++++++++++++++++++++++++--
  1 files changed, 86 insertions(+), 4 deletions(-)

diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index 70b7cc5..b4f1c42 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -3130,6 +3130,45 @@ static inline void btrfs_release_extent_buffer(struct extent_buffer *eb)
  	__free_extent_buffer(eb);
  }
  
+/*
+ * we may reuse a extent buffer whose device space has been released, if the len
+ * of the extent buffer is smaller than we expect, we must enlarge the extent
+ * buffer, and before doing that, we must release the extent buffer that
+ * intersects it.
+ *
+ * Don't worry about the state of the extent buffer that is going to be release.
+ * because it is just an image left in the memory, and its device space has been
+ * released, or the btrfs can't allocate its device space for other extent
+ * buffer.
+ *
+ * Note: Must hold io_tree->buffer_lock
+ */
+static int btrfs_enlarge_extent_buffer(struct extent_io_tree *tree,
+					struct extent_buffer *eb,
+					unsigned long newlen)
+{
+	struct rb_node *next;
+	struct extent_buffer *next_eb;
+
+	eb->len = newlen;
+	set_page_extent_head(eb->first_page, newlen);
+
+	next = rb_next(&eb->rb_node);
+	while (next) {
+		next_eb = rb_entry(next, struct extent_buffer, rb_node);
+		if (next_eb->start >= eb->start + eb->len)
+			break;
+
+		if (atomic_read(&next_eb->refs) > 1)
+			return 1;
+
+		next = rb_next(next);
+		rb_erase(&next_eb->rb_node, &tree->buffer);
+		btrfs_release_extent_buffer(next_eb);
+	}
+	return 0;
+}
+
  struct extent_buffer *alloc_extent_buffer(struct extent_io_tree *tree,
  					  u64 start, unsigned long len,
  					  struct page *page0,
@@ -3147,10 +3186,49 @@ struct extent_buffer *alloc_extent_buffer(struct extent_io_tree *tree,
  	spin_lock(&tree->buffer_lock);
  	eb = buffer_search(tree, start);
  	if (eb) {
-		atomic_inc(&eb->refs);
-		spin_unlock(&tree->buffer_lock);
-		mark_page_accessed(eb->first_page);
-		return eb;
+		/*
+		 * If this extent buffer's device space has been released some
+		 * time ago, and is reallocated again to store other metadata,
+		 * but it hasn't been release, we may get the old entent buffer
+		 * and reuse it.
+		 *
+		 * But, we must change it according the new len.
+		 */
+		if (eb->len >= len) {
+			if (eb->len > len) {
+				btrfs_release_extent_buffer_page(eb, num_pages);
+
+				eb->len = len;
+				set_page_extent_head(eb->first_page, len);
+			}
+
+			atomic_inc(&eb->refs);
+			spin_unlock(&tree->buffer_lock);
+			mark_page_accessed(eb->first_page);
+			return eb;
+		} else {
+			int ret;
+
+			/*
+			 * if eb->len != len, it means this extent buffer
+			 * is reused as a new extent buffer.
+			 */
+			BUG_ON(atomic_read(&eb->refs) != 1);
+
+			i = num_extent_pages(eb->start, eb->len);
+			index += i;
+
+			ret = btrfs_enlarge_extent_buffer(tree, eb, len);
+			if (ret) {
+				spin_unlock(&tree->buffer_lock);
+				return NULL;
+			} else {
+				rb_erase(&eb->rb_node, &tree->buffer);
+				spin_unlock(&tree->buffer_lock);
+				mark_page_accessed(eb->first_page);
+				goto eb_alloc_pages;
+			}
+		}
  	}
  	spin_unlock(&tree->buffer_lock);
  
@@ -3170,6 +3248,8 @@ struct extent_buffer *alloc_extent_buffer(struct extent_io_tree *tree,
  	} else {
  		i = 0;
  	}
+
+eb_alloc_pages:
  	for (; i < num_pages; i++, index++) {
  		p = find_or_create_page(mapping, index, mask | __GFP_HIGHMEM);
  		if (!p) {
@@ -3197,6 +3277,8 @@ struct extent_buffer *alloc_extent_buffer(struct extent_io_tree *tree,
  		/* add one reference for the caller */
  		atomic_inc(&exists->refs);
  		spin_unlock(&tree->buffer_lock);
+
+		BUG_ON(exists->len != eb->len);
  		goto free_eb;
  	}
  	/* add one reference for the tree */
-- 
1.7.0.1
