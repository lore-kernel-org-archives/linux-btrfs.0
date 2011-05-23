From: Elric Milon <whirm@gmx.com>
Subject: Re: kernel BUG at fs/btrfs/inode.c:149!
Date: Mon, 23 May 2011 13:57:41 +0200
Message-ID: <201105231357.41588.whirm@gmx.com>
References: <201105051954.48405.whirm@gmx.com> <201105161701.11645.truewhirm@yahoo.es> <4DD150C1.2090505@redhat.com>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
To: "linux-btrfs" <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4DD150C1.2090505@redhat.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Monday 16 May 2011 18:28:49 you wrote:
> On 05/16/2011 11:01 AM, Whirm wrote:
> > On Monday 16 May 2011 16:11:19 Josef Bacik wrote:

> > 
> > Sorry yes, I meant this is how I managed to get the corrupted filesystem.
> > 
> > Ill try to break it again.
> 
> Oh ok perfect, yeah I will try and do the same sort of things and see if
> I can get it to happen as well.  Thanks,

Great, btw, I tried to see if I can mount the corrupted filesystem with 
the patch you told me about applied, and it fails, here's the log:

http://pastebin.com/raw.php?i=4Kfv927B

That happens using 2.6.39-rc7+ from git with the following patch applied (its 
the debug patch and the possible fix you told me about):

diff --git a/fs/btrfs/free-space-cache.c b/fs/btrfs/free-space-cache.c
index 63731a1..419f91f 100644
--- a/fs/btrfs/free-space-cache.c
+++ b/fs/btrfs/free-space-cache.c
@@ -417,10 +417,19 @@ int load_free_space_cache(struct btrfs_fs_info *fs_info,
                        }
 
                        if (entry->type == BTRFS_FREE_SPACE_EXTENT) {
+                               printk(KERN_ERR "adding extent [%llu-%llu]\n",
+                                      e->offset, e->bytes);
                                spin_lock(&block_group->tree_lock);
                                ret = link_free_space(block_group, e);
                                spin_unlock(&block_group->tree_lock);
-                               BUG_ON(ret);
+                               if (ret) {
+                                       printk(KERN_ERR "Duplicate entries in 
"
+                                               "free space cache, 
dumping\n");
+                                       kunmap(page);
+                                       unlock_page(page);
+                                       page_cache_release(page);
+                                       goto free_cache;
+                               }
                        } else {
                                e->bitmap = kzalloc(PAGE_CACHE_SIZE, 
GFP_NOFS);
                                if (!e->bitmap) {
@@ -430,7 +439,17 @@ int load_free_space_cache(struct btrfs_fs_info *fs_info,
                                        unlock_page(page);
                                        page_cache_release(page);
                                        goto free_cache;
+                               if (ret) {
+                                       printk(KERN_ERR "Duplicate entries in 
"
+                                              "free space cache, dumping\n");
+                                       kunmap(page);
+                                       unlock_page(page);
+                                       page_cache_release(page);
+                                       goto free_cache;
+                               }
                                }
+                               printk(KERN_ERR "adding bitmap [%llu-%llu]\n",
+                                      e->offset, e->bytes);
                                spin_lock(&block_group->tree_lock);
                                ret = link_free_space(block_group, e);
                                block_group->total_bitmaps++;
@@ -909,10 +928,16 @@ static int tree_insert_offset(struct rb_root *root, u64 
offset,
                         * logically.
                         */
                        if (bitmap) {
-                               WARN_ON(info->bitmap);
+                               if (info->bitmap) {
+                                       WARN_ON_ONCE(1);
+                                       return -EEXIST;
+                               }
                                p = &(*p)->rb_right;
                        } else {
-                               WARN_ON(!info->bitmap);
+                               if (!info->bitmap) {
+                                       WARN_ON_ONCE(1);
+                                       return -EEXIST;
+                               }
                                p = &(*p)->rb_left;
                        }
                }


Do you want me to try some other patch before I destroy the filesystem to make 
the other tests?

Thanks,

-- 

Elric Milon
