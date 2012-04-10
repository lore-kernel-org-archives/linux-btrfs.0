From: Ilya Dryomov <idryomov@gmail.com>
Subject: Re: btrfs 3.2.2 -> 3.3.1 upgrade finally ate babies, some advice?
Date: Tue, 10 Apr 2012 12:07:18 +0300
Message-ID: <20120410090718.GA2345@zambezi.lan>
References: <CAMVG2stk4skvQHCyKUzjV-WLJc8Emt0GjRBZBOK-_EJj4q-JYA@mail.gmail.com>
 <4F82F5BA.3080504@kraav.com>
 <CAMVG2styuLG9ai0rb20jf=pwnAA3XU3zZsL5PfmxoMXYajG9BQ@mail.gmail.com>
 <4F834D75.5060703@kraav.com>
 <4F835550.6090106@kraav.com>
 <20120409231954.GC11041@twin.jikos.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: Leho Kraav <leho@kraav.com>, Daniel J Blueman <daniel@quora.org>,
	Linux BTRFS <linux-btrfs@vger.kernel.org>,
	Liu Bo <liubo2009@cn.fujitsu.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20120409231954.GC11041@twin.jikos.cz>
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Apr 10, 2012 at 01:19:54AM +0200, David Sterba wrote:
> On Tue, Apr 10, 2012 at 12:32:00AM +0300, Leho Kraav wrote:
> > It is also BUG time WITH the patch. Mount succeeds, but "btrfs fi balance
> > HOME" gives us:
> > 
> > Apr 10 00:24:18 server sudo: pam_unix(sudo:session): session opened for user > root by (uid=1000)
> > Apr 10 00:24:18 server kernel: [  363.839105] ------------[ cut here > ]------------
> > Apr 10 00:24:18 server kernel: [  363.839163] kernel BUG at > fs/btrfs/volumes.c:2733!
> 
> that's
> 
> 2732         if (!(bctl->flags & BTRFS_BALANCE_RESUME)) {
> 2733                 BUG_ON(ret == -EEXIST);
> ^^^^
> 2734                 set_balance_control(bctl);
> 2735         } else {
> 2736                 BUG_ON(ret != -EEXIST);
> 2737                 spin_lock(&fs_info->balance_lock);
> 2738                 update_balance_args(bctl);
> 2739                 spin_unlock(&fs_info->balance_lock);
> 2740         }
> 
> IIRC somebody reported similar problem recently. It basically means
> there's an inconsistent balance state. Adding Ilya to CC.

Leho, so you just mount with discard patch and run 'btrfs fi balance
<mnt>', correct ?

The problem is that you have balance state on disk (from trying to run
balance earlier w/o discard patch) but we are failing to pick it up on
mount.

Could you please post the entire dmesg and the output of
'btrfs-debug-tree -d <dev>' somewhere ?

Could you also apply the debug patch below, mount your fs and send me
dmesg output (no need to run balance, just mount) ?

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
