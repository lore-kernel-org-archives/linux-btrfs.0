From: Josef Bacik <josef@redhat.com>
Subject: Re: kernel BUG at fs/btrfs/extent_io.c:1890!
Date: Wed, 11 Apr 2012 11:01:58 -0400
Message-ID: <20120411150158.GA5820@localhost.localdomain>
References: <CACfQV3hb92zrYUJ8to1mq8s1wzfdEoMBDi9b5VmfZ0AZ=UBkFA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-btrfs@vger.kernel.org
To: Francesco Cepparo <francesco.cepparo@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <CACfQV3hb92zrYUJ8to1mq8s1wzfdEoMBDi9b5VmfZ0AZ=UBkFA@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Apr 11, 2012 at 02:44:26PM +0000, Francesco Cepparo wrote:
> Hi, I've been using btrfs for a while now, and some months ago one of
> my filesystems stopped mounting. I tried to fix it by mounting it with
> the recovery option, by using btrfs-zero-log and by restoring the
> superblock but it didn't work, so I left the filesystem standing there
> waiting for the fsck repairing tool to be released (running the
> version of fsck I had at the time produced the following output:
> http://dl.dropbox.com/u/2565562/btrfsck-old-output while running the
> 2012-03-28 version of btrfsck produces the following output:
> http://dl.dropbox.com/u/2565562/btrfsck-20120328-output.gz ).
> I'm still waiting for the repairing tool and I haven't tried the
> dangerous don't ever use branch, but as I have updated the kernel to
> version 3.4.0-rc2 I tried to mount the filesystem again with the new
> kernel, and instead of failing with this error message:
> http://dl.dropbox.com/u/2565562/btrfs-kernel-3.3 as it did with kernel
> 3.3.1 and the previous kernels, with 3.4.0-rc2 it now hits the
> following kernel BUG:
> http://dl.dropbox.com/u/2565562/btrfs-kernel-3.4-bug
> 
> I hope I can be of any help in improving the already great btrfs.
> Also, is there any hope for me to recover my old filesystem? :)

Sorry, can you try this patch and see if it stops panicing, thanks,

Josef


diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 20196f4..2a3ddd2 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -383,17 +383,17 @@ static int btree_read_extent_buffer_pages(struct btrfs_root *root,
 		if (test_bit(EXTENT_BUFFER_CORRUPT, &eb->bflags))
 			break;
 
+		num_copies = btrfs_num_copies(&root->fs_info->mapping_tree,
+					      eb->start, eb->len);
+		if (num_copies == 1)
+			break;
+
 		if (!failed_mirror) {
 			failed = 1;
 			printk(KERN_ERR "failed mirror was %d\n", eb->failed_mirror);
 			failed_mirror = eb->failed_mirror;
 		}
 
-		num_copies = btrfs_num_copies(&root->fs_info->mapping_tree,
-					      eb->start, eb->len);
-		if (num_copies == 1)
-			break;
-
 		mirror_num++;
 		if (mirror_num == failed_mirror)
 			mirror_num++;
