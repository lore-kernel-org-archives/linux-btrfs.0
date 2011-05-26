From: liubo <liubo2009@cn.fujitsu.com>
Subject: Re: [PATCH 1/9] Btrfs: introduce sub transaction stuff
Date: Wed, 25 May 2011 22:48:24 -0400
Message-ID: <4DDDBF78.5020600@cn.fujitsu.com>
References: <1305792692-10635-1-git-send-email-liubo2009@cn.fujitsu.com> <1305792692-10635-2-git-send-email-liubo2009@cn.fujitsu.com> <1305850961-sup-454@shiny> <1306161195-sup-8189@shiny> <4DDC7E08.4020207@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>, josef <josef@redhat.com>
To: Chris Mason <chris.mason@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4DDC7E08.4020207@cn.fujitsu.com>
List-ID: <linux-btrfs.vger.kernel.org>

On 05/24/2011 11:56 PM, liubo wrote:
>> > 
>> > Second, we use the generation number of the super to read in the log
>> > tree root after a crash.  This doesn't always match the sub trans id and
>> > so it doesn't always match the transid stored in the btree blocks.
>> > 
>> > There are a few solutions to this, we can use some of the reserved
>> > fields in the super for the generation numbers of the roots the super
>> > points to, and use whichever one is bigger when we read things in.
>> > 
> 
> All right, I'm going to dig it more.
> 

I've got this resolved via 'log_root_transid' of 'struct btrfs_super_block',
and it looks nice on both syntactic and functional side. :)

diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index ac8d2ac..1006898 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -2103,6 +2103,7 @@ struct btrfs_root *open_ctree(struct super_block *sb,
 	if (btrfs_super_log_root(disk_super) != 0 &&
 	    !(fs_info->fs_state & BTRFS_SUPER_FLAG_ERROR)) {
 		u64 bytenr = btrfs_super_log_root(disk_super);
+		u64 log_root_transid = btrfs_super_log_root_transid(disk_super);
 
 		if (fs_devices->rw_devices == 0) {
 			printk(KERN_WARNING "Btrfs log replay required "
@@ -2125,7 +2126,7 @@ struct btrfs_root *open_ctree(struct super_block *sb,
 
 		log_tree_root->node = read_tree_block(tree_root, bytenr,
 						      blocksize,
-						      generation + 1);
+						      log_root_transid);
 		ret = btrfs_recover_log_trees(log_tree_root);
 		BUG_ON(ret);
 
diff --git a/fs/btrfs/tree-log.c b/fs/btrfs/tree-log.c
index 912397c..b304ec1 100644
--- a/fs/btrfs/tree-log.c
+++ b/fs/btrfs/tree-log.c
@@ -2089,6 +2089,8 @@ int btrfs_sync_log(struct btrfs_trans_handle *trans,
 				log_root_tree->node->start);
 	btrfs_set_super_log_root_level(&root->fs_info->super_for_commit,
 				btrfs_header_level(log_root_tree->node));
+	btrfs_set_super_log_root_transid(&root->fs_info->super_for_commit,
+					 trans->transid);
 
 	log_root_tree->log_batch = 0;
 	log_root_tree->log_transid++;

thanks,
liubo
