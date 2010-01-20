From: "Aneesh Kumar K. V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: Re: btrfs fallocate woes
Date: Wed, 20 Jan 2010 12:58:54 +0530
Message-ID: <87vdexdykp.fsf@linux.vnet.ibm.com>
References: <715ea5c11001140328g6198447axce1ba884a6e6fb96@mail.gmail.com>
	<aday6k0lhpx.fsf@roland-alpha.cisco.com>
	<20100114192035.GC23810@think>
	<715ea5c11001141233i78410267qc4d0767f5b7b8250@mail.gmail.com>
	<715ea5c11001190718u396f41cua51ccf74c498482a@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: Paul Komkoff <i@stingr.net>, Chris Mason <chris.mason@oracle.com>,
	Roland Dreier <rdreier@cisco.com>, Paul Komkoff <i@stingr.net>,
	linux-btrfs <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <715ea5c11001190718u396f41cua51ccf74c498482a@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, 19 Jan 2010 15:18:26 +0000, Paul Komkoff <i@stingr.net> wrote:
> On Thu, Jan 14, 2010 at 8:33 PM, Paul Komkoff <i@stingr.net> wrote:
> > If it's fixed in latest tree it's fine, I guess that fix isn't in
> > fedora's 2.6.32.3
> 
> Sorry for popping up again, but did anyone fix this/verified there's
> no problem in recent kernels? For some reasons I cannot run latest git
> so I'm stuck with fedora kernels, and every one I have around me (with
> btrfs) has this problem.
> 

the below change fixes this for me on btrfs

commit f2bc9dd07e3424c4ec5f3949961fe053d47bc825
Author: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
Date:   Wed Jan 20 12:57:53 2010 +0530

    btrfs: Use correct values when updating inode i_size on fallocate
    
    Even though we allocate more, we should be updating inode i_size
    as per the arguments passed
    
    Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 5440bab..db406a4 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -5789,7 +5789,7 @@ out_fail:
 }
 
 static int prealloc_file_range(struct inode *inode, u64 start, u64 end,
-			       u64 alloc_hint, int mode)
+			u64 alloc_hint, int mode, loff_t actual_len)
 {
 	struct btrfs_trans_handle *trans;
 	struct btrfs_root *root = BTRFS_I(inode)->root;
@@ -5798,6 +5798,7 @@ static int prealloc_file_range(struct inode *inode, u64 start, u64 end,
 	u64 cur_offset = start;
 	u64 num_bytes = end - start;
 	int ret = 0;
+	u64 i_size;
 
 	while (num_bytes > 0) {
 		alloc_size = min(num_bytes, root->fs_info->max_extent);
@@ -5836,8 +5837,12 @@ static int prealloc_file_range(struct inode *inode, u64 start, u64 end,
 		BTRFS_I(inode)->flags |= BTRFS_INODE_PREALLOC;
 		if (!(mode & FALLOC_FL_KEEP_SIZE) &&
 		    cur_offset > inode->i_size) {
-			i_size_write(inode, cur_offset);
-			btrfs_ordered_update_i_size(inode, cur_offset, NULL);
+			if (cur_offset > actual_len)
+				i_size  = actual_len;
+			else
+				i_size = cur_offset;
+			i_size_write(inode, i_size);
+			btrfs_ordered_update_i_size(inode, i_size, NULL);
 		}
 
 		ret = btrfs_update_inode(trans, root, inode);
@@ -5930,7 +5935,7 @@ static long btrfs_fallocate(struct inode *inode, int mode,
 		     !test_bit(EXTENT_FLAG_PREALLOC, &em->flags))) {
 			ret = prealloc_file_range(inode,
 						  cur_offset, last_byte,
-						  alloc_hint, mode);
+						alloc_hint, mode, offset+len);
 			if (ret < 0) {
 				free_extent_map(em);
 				break;
