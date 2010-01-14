From: Josef Bacik <josef@redhat.com>
Subject: Re: Bug in btrfs_rename (kernel BUG at fs/btrfs/inode.c:5595!)
Date: Thu, 14 Jan 2010 12:03:23 -0500
Message-ID: <20100114170323.GA2190@localhost.localdomain>
References: <4B4E1A5D.1070203@gmail.com> <20100113201317.GC2774@dhcp231-156.rdu.redhat.com> <4B4E290F.9010100@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Josef Bacik <josef@redhat.com>, linux-btrfs@vger.kernel.org
To: Tomas Carnecky <tomas.carnecky@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4B4E290F.9010100@gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Jan 13, 2010 at 09:11:59PM +0100, Tomas Carnecky wrote:
>  On 1/13/10 9:13 PM, Josef Bacik wrote:
>> On Wed, Jan 13, 2010 at 08:09:17PM +0100, Tomas Carnecky wrote:
>>>   I was running v2.6.33-rc2-187-g08d869a and everything was ok. Today I
>>> decided to update the kernel (to v2.6.33-rc4) and a minute or two after
>>> logging into the gnome desktop this kernel bug appeared in dmesg. I then
>>> went back to the old kernel but the bug didn't disappear, not even after
>>> running btrfsck on the filesystem.
>>>
>> Ok will you please run with this patch?  It shouldn't panic your box, since it
>> seems ret is -EEXIST.  Just watch your logs for
>>
>> OH NO, ORPHAN ENTRY ALREADY EXISTS FOR<number>
>>
>> and then look up and find all occurances of
>>
>> Btrfs: orphan add<number>
>>
>> with the stack trace and send it back to me so I can verify that nothing heinous
>> is happening.  I assume we're just racing with unlink/rename so all that needs
>> to be done is to take that BUG_ON out, but it would be nice to know for sure.
>

Ok will you try this patch?  I've not built it, so sorry if it doesn't compile
:).  Look for the "OH NO" messages again.  If they show up then the problem is
still there, if they go away the problem is fixed.  I tried to reproduce this
locally but I can't seem to do it, so you are my only hope :).  

By the way, this replaces the last patch I sent you, so unapply the previous
patch and apply this one instead.  Thanks,

Josef


diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 5440bab..c255dcb 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -2096,6 +2096,13 @@ int btrfs_orphan_add(struct btrfs_trans_handle *trans, struct inode *inode)
 	 */
 	ret = btrfs_insert_orphan_item(trans, root, inode->i_ino);
 
+	printk(KERN_ERR "Btrfs: orphan add %llu\n", (unsigned long long)inode->i_ino);
+	dump_stack();
+	if (ret) {
+		printk(KERN_ERR "OH NO, ORPHAN ENTRY ALREADY EXISTS FOR %llu\n",
+		       (unsigned long long)inode->i_ino);
+	}
+
 	return ret;
 }
 
@@ -3293,10 +3300,10 @@ static int btrfs_setattr_size(struct inode *inode, struct iattr *attr)
 	unsigned long nr;
 	int ret;
 
-	if (attr->ia_size == inode->i_size)
+	if (attr->ia_size == i_size_read(inode))
 		return 0;
 
-	if (attr->ia_size > inode->i_size) {
+	if (attr->ia_size > i_size_read(inode)) {
 		unsigned long limit;
 		limit = current->signal->rlim[RLIMIT_FSIZE].rlim_cur;
 		if (attr->ia_size > inode->i_sb->s_maxbytes)
@@ -3305,24 +3312,7 @@ static int btrfs_setattr_size(struct inode *inode, struct iattr *attr)
 			send_sig(SIGXFSZ, current, 0);
 			return -EFBIG;
 		}
-	}
-
-	ret = btrfs_reserve_metadata_space(root, 1);
-	if (ret)
-		return ret;
-
-	trans = btrfs_start_transaction(root, 1);
-	btrfs_set_trans_block_group(trans, inode);
-
-	ret = btrfs_orphan_add(trans, inode);
-	BUG_ON(ret);
-
-	nr = trans->blocks_used;
-	btrfs_end_transaction(trans, root);
-	btrfs_unreserve_metadata_space(root, 1);
-	btrfs_btree_balance_dirty(root, nr);
 
-	if (attr->ia_size > inode->i_size) {
 		ret = btrfs_cont_expand(inode, attr->ia_size);
 		if (ret) {
 			btrfs_truncate(inode);
@@ -3345,6 +3335,21 @@ static int btrfs_setattr_size(struct inode *inode, struct iattr *attr)
 		btrfs_end_transaction(trans, root);
 		btrfs_btree_balance_dirty(root, nr);
 		return 0;
+	} else if (attr->ia_size < i_size_read(inode)) {
+		ret = btrfs_reserve_metadata_space(root, 1);
+		if (ret)
+			return ret;
+
+		trans = btrfs_start_transaction(root, 1);
+		btrfs_set_trans_block_group(trans, inode);
+
+		ret = btrfs_orphan_add(trans, inode);
+		BUG_ON(ret);
+
+		nr = trans->blocks_used;
+		btrfs_end_transaction(trans, root);
+		btrfs_unreserve_metadata_space(root, 1);
+		btrfs_btree_balance_dirty(root, nr);
 	}
 
 	/*
@@ -3355,10 +3360,6 @@ static int btrfs_setattr_size(struct inode *inode, struct iattr *attr)
 	if (attr->ia_size == 0)
 		BTRFS_I(inode)->ordered_data_close = 1;
 
-	/* we don't support swapfiles, so vmtruncate shouldn't fail */
-	ret = vmtruncate(inode, attr->ia_size);
-	BUG_ON(ret);
-
 	return 0;
 }
 
@@ -3376,7 +3377,6 @@ static int btrfs_setattr(struct dentry *dentry, struct iattr *attr)
 		if (err)
 			return err;
 	}
-	attr->ia_valid &= ~ATTR_SIZE;
 
 	if (attr->ia_valid)
 		err = inode_setattr(inode, attr);
@@ -5592,7 +5592,7 @@ static int btrfs_rename(struct inode *old_dir, struct dentry *old_dentry,
 		BUG_ON(ret);
 		if (new_inode->i_nlink == 0) {
 			ret = btrfs_orphan_add(trans, new_dentry->d_inode);
-			BUG_ON(ret);
+			BUG_ON(ret && ret != -EEXIST);
 		}
 	}
 
