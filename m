From: Josef Bacik <josef@redhat.com>
Subject: Re: kernel BUG at fs/btrfs/extent_io.c:3982!
Date: Wed, 11 Apr 2012 15:09:27 -0400
Message-ID: <20120411190926.GE2506@localhost.localdomain>
References: <4F848C62.6030100@sandia.gov>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-btrfs@vger.kernel.org
To: Jim Schutt <jaschut@sandia.gov>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4F848C62.6030100@sandia.gov>
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Apr 10, 2012 at 01:39:14PM -0600, Jim Schutt wrote:
> Hi,
> 
> I hit this BUG today.
> 
> I'm running 3.3.1 merged with the ceph and btrfs bits for 3.4,
> i.e. 3.3.1 +
>   commit bc3f116fec194 "Btrfs: update the checks for mixed block groups with big metadata blocks"
>   commit c666601a935b9 "rbd: move snap_rwsem to the device, rename to header_rwsem"
> 
> The btrfs filesystem in question is backing a Ceph OSD under
> a heavy write load.
> 
> Here's the bug:
> 

Can you give this a whirl and let me know how it goes?  If I'm right you should
see a warning pop up in your messages.  Thanks,

Josef

diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index 26fbe1c..0d81fd4 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -55,6 +55,7 @@ struct extent_page_data {
 };
 
 static noinline void flush_write_bio(void *data);
+static void check_buffer_tree_ref(struct extent_buffer *eb);
 static inline struct btrfs_fs_info *
 tree_fs_info(struct extent_io_tree *tree)
 {
@@ -3264,6 +3265,12 @@ retry:
 				continue;
 			}
 
+			if (unlikely(!test_bit(EXTENT_BUFFER_TREE_REF,
+					       &eb->bflags))) {
+				WARN_ON(1);
+				check_buffer_tree_ref(eb);
+			}
+
 			prev_eb = eb;
 			ret = lock_extent_buffer_for_io(eb, fs_info, &epd);
 			if (!ret) {
