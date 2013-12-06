Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:17566 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750752Ab3LFGEb (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Fri, 6 Dec 2013 01:04:31 -0500
Date: Fri, 6 Dec 2013 14:04:19 +0800
From: Liu Bo <bo.li.liu@oracle.com>
To: =?utf-8?B?U3rFkXRzIMOBa29z?= <szotsaki@gmail.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: btrfs-ino-cache runs on every boot for 6 minutes
Message-ID: <20131206060419.GA20595@localhost.localdomain>
Reply-To: bo.li.liu@oracle.com
References: <1531404.tFNCiHaLVH@linux-suse.hu>
 <20131204021507.GH18095@localhost.localdomain>
 <2467502.UPcdayreHd@linux-suse.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <2467502.UPcdayreHd@linux-suse.hu>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Dec 04, 2013 at 01:41:42PM +0100, Szőts Ákos wrote:
> Thank you for your answer.
> 
> Here are the "blocked states" logs. Since I had a plenty of time, I made 
> multiple of them. The last two are the longest of them.
> 
> - http://paste.opensuse.org/view/raw/51654551
> - http://paste.opensuse.org/view/raw/39005796
> - http://paste.opensuse.org/view/raw/38028651
> - http://paste.opensuse.org/view/raw/21592065
> - http://paste.opensuse.org/view/raw/46655344
> - http://paste.opensuse.org/view/raw/26821272
> 
> Ákos

Could you please try the following and show me the output of dmesg?

thanks,
-liubo


diff --git a/fs/btrfs/free-space-cache.c b/fs/btrfs/free-space-cache.c
index 057be95..8f7711e 100644
--- a/fs/btrfs/free-space-cache.c
+++ b/fs/btrfs/free-space-cache.c
@@ -2950,11 +2950,16 @@ int load_free_ino_cache(struct btrfs_fs_info *fs_info, struct btrfs_root *root)
 		return 0;
 
 	inode = lookup_free_ino_inode(root, path);
-	if (IS_ERR(inode))
+	if (IS_ERR(inode)) {
+		printk("%s: ino cache ino is NOT found\n", __func__);
 		goto out;
+	}
 
-	if (root_gen != BTRFS_I(inode)->generation)
+	if (root_gen != BTRFS_I(inode)->generation) {
+		printk("%s: gen mismatch: root_gen_mem=%llu, root_gen=%llu, ino's gen=%llu\n",
+			__func__, btrfs_root_generation(&root->root_item), root_gen, BTRFS_I(inode)->generation);
 		goto out_put;
+	}
 
 	ret = __load_free_space_cache(root, inode, ctl, path, 0);
 
diff --git a/fs/btrfs/inode-map.c b/fs/btrfs/inode-map.c
index ab485e5..6535139 100644
--- a/fs/btrfs/inode-map.c
+++ b/fs/btrfs/inode-map.c
@@ -473,7 +473,12 @@ again:
 	}
 
 	spin_lock(&root->cache_lock);
-	if (root->cached != BTRFS_CACHE_FINISHED) {
+
+	/* ino cache has 3 state:
+	 * BTRFS_CACHE_NO, BTRFS_CACHE_START, BTRFS_CACHE_FINISHED
+	 */
+	if (root->cached != BTRFS_CACHE_NO && root->cached != BTRFS_CACHE_FINISHED) {
+		printk("%s: bail out because it's not FINISHED, cached=%d\n", __func__, root->cached);
 		ret = -1;
 		spin_unlock(&root->cache_lock);
 		goto out_put;
