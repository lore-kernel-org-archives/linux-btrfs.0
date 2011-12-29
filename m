From: Li Zefan <lizf@cn.fujitsu.com>
Subject: Re: fstrim on BTRFS
Date: Thu, 29 Dec 2011 12:02:48 +0800
Message-ID: <4EFBE668.7030800@cn.fujitsu.com>
References: <201112281757.16019.Martin@lichtvoll.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-btrfs@vger.kernel.org
To: Martin Steigerwald <Martin@lichtvoll.de>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <201112281757.16019.Martin@lichtvoll.de>
List-ID: <linux-btrfs.vger.kernel.org>

Martin Steigerwald wrote:
> Hi!
> 
> With 3.2-rc4 (probably earlier), Ext4 seems to remember what areas it 
> trimmed:
> 
> merkaba:~> fstrim -v /boot
> /boot: 224657408 bytes were trimmed
> merkaba:~> fstrim -v /boot
> /boot: 0 bytes were trimmed
> 
> 
> But BTRFS does not:
> 
> merkaba:~> fstrim -v /
> /: 4431613952 bytes were trimmed
> merkaba:~> fstrim -v /    
> /: 4341846016 bytes were trimmed
> 
> 
> Is it planned to add this feature to BTRFS as well?
> 

There's no such plan, but it's do-able, and I can take care of it.
There's an issue though.

Whether we want to store TRIMMED information on disk? ext4 doesn't
do this, so the first fstrim will be slow though you've done fstrim
in previous mount.

For btrfs this issue can't be solved without disk format change that
will break older kernels, but only 3.2-rcX kernels will be affected if
we push the following change into mainline before 3.2 release.

---
 ctree.h            |    4 ++--
 free-space-cache.c |    5 +++--
 2 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index 6738503..919e055 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -278,8 +278,8 @@ struct btrfs_chunk {
 	/* additional stripes go here */
 } __attribute__ ((__packed__));
 
-#define BTRFS_FREE_SPACE_EXTENT	1
-#define BTRFS_FREE_SPACE_BITMAP	2
+#define BTRFS_FREE_SPACE_EXTENT	0
+#define BTRFS_FREE_SPACE_BITMAP	1
 
 struct btrfs_free_space_entry {
 	__le64 offset;
diff --git a/fs/btrfs/free-space-cache.c b/fs/btrfs/free-space-cache.c
index ec23d43..8a7c0e0 100644
--- a/fs/btrfs/free-space-cache.c
+++ b/fs/btrfs/free-space-cache.c
@@ -481,6 +481,7 @@ static int io_ctl_add_entry(struct io_ctl *io_ctl, u64 offset, u64 bytes,
 	entry->bytes = cpu_to_le64(bytes);
 	entry->type = (bitmap) ? BTRFS_FREE_SPACE_BITMAP :
 		BTRFS_FREE_SPACE_EXTENT;
+	entry->type =  1 << entry->type;
 	io_ctl->cur += sizeof(struct btrfs_free_space_entry);
 	io_ctl->size -= sizeof(struct btrfs_free_space_entry);
 
@@ -669,7 +670,7 @@ int __load_free_space_cache(struct btrfs_root *root, struct inode *inode,
 			goto free_cache;
 		}
 
-		if (type == BTRFS_FREE_SPACE_EXTENT) {
+		if (type & BTRFS_FREE_SPACE_EXTENT) {
 			spin_lock(&ctl->tree_lock);
 			ret = link_free_space(ctl, e);
 			spin_unlock(&ctl->tree_lock);
@@ -679,7 +680,7 @@ int __load_free_space_cache(struct btrfs_root *root, struct inode *inode,
 				kmem_cache_free(btrfs_free_space_cachep, e);
 				goto free_cache;
 			}
-		} else {
+		} else if (type & BTRFS_FREE_SPACE_BITMAP) {
 			BUG_ON(!num_bitmaps);
 			num_bitmaps--;
 			e->bitmap = kzalloc(PAGE_CACHE_SIZE, GFP_NOFS);
