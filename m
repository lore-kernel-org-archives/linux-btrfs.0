From: Josef Bacik <josef@redhat.com>
Subject: Re: Bug in btrfs_rename (kernel BUG at fs/btrfs/inode.c:5595!)
Date: Wed, 13 Jan 2010 15:13:18 -0500
Message-ID: <20100113201317.GC2774@dhcp231-156.rdu.redhat.com>
References: <4B4E1A5D.1070203@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-btrfs@vger.kernel.org
To: Tomas Carnecky <tomas.carnecky@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4B4E1A5D.1070203@gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Jan 13, 2010 at 08:09:17PM +0100, Tomas Carnecky wrote:
>  I was running v2.6.33-rc2-187-g08d869a and everything was ok. Today I  
> decided to update the kernel (to v2.6.33-rc4) and a minute or two after  
> logging into the gnome desktop this kernel bug appeared in dmesg. I then  
> went back to the old kernel but the bug didn't disappear, not even after  
> running btrfsck on the filesystem.
>

Ok will you please run with this patch?  It shouldn't panic your box, since it
seems ret is -EEXIST.  Just watch your logs for

OH NO, ORPHAN ENTRY ALREADY EXISTS FOR <number>

and then look up and find all occurances of

Btrfs: orphan add <number>

with the stack trace and send it back to me so I can verify that nothing heinous
is happening.  I assume we're just racing with unlink/rename so all that needs
to be done is to take that BUG_ON out, but it would be nice to know for sure.
Thanks,

Josef


diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 5440bab..68fc2e0 100644
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
 
@@ -5592,7 +5599,7 @@ static int btrfs_rename(struct inode *old_dir, struct dentry *old_dentry,
 		BUG_ON(ret);
 		if (new_inode->i_nlink == 0) {
 			ret = btrfs_orphan_add(trans, new_dentry->d_inode);
-			BUG_ON(ret);
+			BUG_ON(ret && ret != -EEXIST);
 		}
 	}
 
