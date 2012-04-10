From: Ilya Dryomov <idryomov@gmail.com>
Subject: Re: kernel BUG at fs/btrfs/volumes.c:2733
Date: Tue, 10 Apr 2012 19:06:43 +0300
Message-ID: <20120410160643.GA3056@zambezi.lan>
References: <20120329105235.GA1198@panda>
 <20120329135324.GA1899@zambezi.lan>
 <20120329151422.GC29741@panda>
 <20120329154154.GA3891@zambezi.lan>
 <20120330174956.GA770@panda>
 <20120330195251.GA1928@zambezi.lan>
 <20120330204405.GA2632@panda>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-btrfs@vger.kernel.org
To: Sander <sander@humilis.net>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20120330204405.GA2632@panda>
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Mar 30, 2012 at 10:44:05PM +0200, Sander wrote:
> Ilya Dryomov wrote (ao):
> > On Fri, Mar 30, 2012 at 07:49:56PM +0200, Sander wrote:
> > Thanks. btrfs-debug-tree confirms that you've got a balance item on
> > media.
> 
> > > > > > After that mount it back and see if there is "btrfs: continuing
> > > > > > balance" line in dmesg (and if btrfs-balance kthread shows up)?
> > > 
> > > There is no such line in dmesg, and currently no btrfs-balance kthread
> > > is running. I've pulled Chris Masons for-linus and booted with the
> > > resulting kernel.
> > 
> > And given the above it's weird. We are failing to locate the item
> > during mount for some reason and I would like to find out why. So if
> > you are up for running debugging patches (really just compiling btrfs
> > module and sending me dmesg output) I would appreciate that.
> 
> Sure, please send me patches.

I'm sorry this took a week, I was backed up.  If you still have that fs
around in that state, could you please apply the patch below, mount it
and send me dmesg output ?  (no need to run balance or anything, just
mount)

Thanks,

		Ilya



diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 20196f4..86fa082 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -1867,6 +1867,7 @@ int open_ctree(struct super_block *sb,
 	csum_root = fs_info->csum_root = btrfs_alloc_root(fs_info);
 	chunk_root = fs_info->chunk_root = btrfs_alloc_root(fs_info);
 	dev_root = fs_info->dev_root = btrfs_alloc_root(fs_info);
+printk("open_ctree\n");
 
 	if (!tree_root || !extent_root || !csum_root ||
 	    !chunk_root || !dev_root) {
diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index a872b48..2e39348 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -2834,6 +2834,7 @@ static int balance_kthread(void *data)
 	mutex_lock(&fs_info->balance_mutex);
 
 	set_balance_control(bctl);
+printk("balance_kthread: flags %llu\n", (unsigned long long)bctl->flags);
 
 	if (btrfs_test_opt(fs_info->tree_root, SKIP_BALANCE)) {
 		printk(KERN_INFO "btrfs: force skipping balance\n");
@@ -2858,6 +2859,7 @@ int btrfs_recover_balance(struct btrfs_root *tree_root)
 	struct btrfs_key key;
 	int ret;
 
+printk("recover_balance\n");
 	path = btrfs_alloc_path();
 	if (!path)
 		return -ENOMEM;
@@ -2872,7 +2874,11 @@ int btrfs_recover_balance(struct btrfs_root *tree_root)
 	key.type = BTRFS_BALANCE_ITEM_KEY;
 	key.offset = 0;
 
+printk("key.obj %llu\n", (unsigned long long)key.objectid);
+printk("key.type %d\n", key.type);
+printk("key.off %llu\n", (unsigned long long)key.offset);
 	ret = btrfs_search_slot(NULL, tree_root, &key, path, 0, 0);
+printk("search ret %d\n", ret);
 	if (ret < 0)
 		goto out_bctl;
 	if (ret > 0) { /* ret = -ENOENT; */
