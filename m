Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mo-p00-ob.rzone.de ([81.169.146.162]:36689 "EHLO
	mo-p00-ob.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752748Ab3JJKmM (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 10 Oct 2013 06:42:12 -0400
Message-ID: <52568477.3080008@giantdisaster.de>
Date: Thu, 10 Oct 2013 12:41:59 +0200
From: Stefan Behrens <sbehrens@giantdisaster.de>
MIME-Version: 1.0
To: "Geyslan G. Bem" <geyslan@gmail.com>, chris.mason@fusionio.com
CC: linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org,
        jbacik@fusionio.com, joe@perches.com, kernel-br@googlegroups.com
Subject: Re: [PATCH v4] btrfs: Fix memory leakage in the tree-log.c
References: <1381370495-13702-1-git-send-email-geyslan@gmail.com>
In-Reply-To: <1381370495-13702-1-git-send-email-geyslan@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed,  9 Oct 2013 23:01:35 -0300, Geyslan G. Bem wrote:
> When 'dir' is NULL, after calling extref_get_fields(), add_inode_ref()
> can be returning without freeing the 'name' pointer.
> 
> Added kfree when necessary.
> 
> Signed-off-by: Geyslan G. Bem <geyslan@gmail.com>
> ---
>  fs/btrfs/tree-log.c | 5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/btrfs/tree-log.c b/fs/btrfs/tree-log.c
> index 79f057c..63c0b72 100644
> --- a/fs/btrfs/tree-log.c
> +++ b/fs/btrfs/tree-log.c
> @@ -1169,8 +1169,11 @@ static noinline int add_inode_ref(struct btrfs_trans_handle *trans,
>  			 */
>  			if (!dir)
>  				dir = read_one_inode(root, parent_objectid);
> -			if (!dir)
> +			if (!dir) {
> +				if (!ret)
> +					kfree(name);
>  				return -ENOENT;
> +			}
>  		} else {
>  			ret = ref_get_fields(eb, ref_ptr, &namelen, &name,
>  					     &ref_index);
> 

There are many more places to fix up in this function. We lose up to two inodes ("if (!ret) return ret;" without the iput(dir), iput(inode)) and we can lose the memory for name ("if ... goto out;" and the out path does not contain the kfree(name)).

I would prefer the approach with a label at the end of the function that handles all cleanup work and which is called from everywhere where a return is coded now.

Like this (the code is completely untested since this is just a review comment):

diff --git a/fs/btrfs/tree-log.c b/fs/btrfs/tree-log.c
index 964c583..40035db 100644
--- a/fs/btrfs/tree-log.c
+++ b/fs/btrfs/tree-log.c
@@ -1113,11 +1113,11 @@ static noinline int add_inode_ref(struct btrfs_trans_handle *trans,
                                  struct extent_buffer *eb, int slot,
                                  struct btrfs_key *key)
 {
-       struct inode *dir;
-       struct inode *inode;
+       struct inode *dir = NULL;
+       struct inode *inode = NULL;
        unsigned long ref_ptr;
        unsigned long ref_end;
-       char *name;
+       char *name = NULL;
        int namelen;
        int ret;
        int search_done = 0;
@@ -1150,13 +1150,15 @@ static noinline int add_inode_ref(struct btrfs_trans_handle *trans,
         * care of the rest
         */
        dir = read_one_inode(root, parent_objectid);
-       if (!dir)
-               return -ENOENT;
+       if (!dir) {
+               ret = -ENOENT;
+               goto out;
+       }

        inode = read_one_inode(root, inode_objectid);
        if (!inode) {
-               iput(dir);
-               return -EIO;
+               ret = -EIO;
+               goto out;
        }

        while (ref_ptr < ref_end) {
@@ -1169,14 +1171,16 @@ static noinline int add_inode_ref(struct btrfs_trans_handle *trans,
                         */
                        if (!dir)
                                dir = read_one_inode(root, parent_objectid);
-                       if (!dir)
-                               return -ENOENT;
+                       if (!dir) {
+                               ret = -ENOENT;
+                               goto out;
+                       }
                } else {
                        ret = ref_get_fields(eb, ref_ptr, &namelen, &name,
                                             &ref_index);
                }
                if (ret)
-                       return ret;
+                       goto out;

                /* if we already have a perfect match, we're done */
                if (!inode_in_dir(root, path, btrfs_ino(dir), btrfs_ino(inode),
@@ -1215,6 +1219,7 @@ static noinline int add_inode_ref(struct btrfs_trans_handle *trans,

                ref_ptr = (unsigned long)(ref_ptr + ref_struct_size) + namelen;
                kfree(name);
+               name = NULL;
                if (log_ref_ver) {
                        iput(dir);
                        dir = NULL;
@@ -1225,6 +1230,7 @@ static noinline int add_inode_ref(struct btrfs_trans_handle *trans,
        ret = overwrite_item(trans, root, path, eb, slot, key);
 out:
        btrfs_release_path(path);
+       kfree(name);
        iput(dir);
        iput(inode);
        return ret;


Could you rework your patch to do something similar to the code above?

This approach is also documented in the file Documentation/CodingStyle in the kernel source tree in the section "Chapter 7: Centralized exiting of functions".


