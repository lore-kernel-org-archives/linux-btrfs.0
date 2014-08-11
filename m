Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:59914 "EHLO
	mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751173AbaHKAiv convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 10 Aug 2014 20:38:51 -0400
From: Josef Bacik <jbacik@fb.com>
To: Filipe Manana <fdmanana@suse.com>
CC: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
        "lists@colorremedies.com" <lists@colorremedies.com>
Subject: Re: [PATCH v2] Btrfs: send, lower mem requirements for processing
 xattrs
Date: Mon, 11 Aug 2014 00:38:42 +0000
Message-ID: <r4wqc0ynasixmpd33qh3tyk2.1407717520499@email.android.com>
References: <1407716706-5115-1-git-send-email-fdmanana@suse.com>,<1407720176-15766-1-git-send-email-fdmanana@suse.com>
In-Reply-To: <1407720176-15766-1-git-send-email-fdmanana@suse.com>
Content-Type: text/plain; charset=US-ASCII
MIME-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Sorry one more thing, just do krealloc instead of the kfrww+kmalloc.  Thanks,

Josef

Filipe Manana <fdmanana@suse.com> wrote:


Maximum xattr size can be up to nearly the leaf size. For an fs with a
leaf size larger than the page size, using kmalloc requires allocating
multiple pages that are contiguous, which might not be possible if
there's heavy memory fragmentation. Therefore fallback to vmalloc if
we fail to allocate with kmalloc. Also start with a smaller buffer size,
since xattr values typically are smaller than a page.

Reported-by: Chris Murphy <lists@colorremedies.com>
Signed-off-by: Filipe Manana <fdmanana@suse.com>
---

V2: Use is_vmalloc_addr() instead of keeping a boolean variable around.

 fs/btrfs/send.c | 39 +++++++++++++++++++++++++++++++--------
 1 file changed, 31 insertions(+), 8 deletions(-)

diff --git a/fs/btrfs/send.c b/fs/btrfs/send.c
index 3c63b29..a7ce318 100644
--- a/fs/btrfs/send.c
+++ b/fs/btrfs/send.c
@@ -1006,11 +1006,13 @@ static int iterate_dir_item(struct btrfs_root *root, struct btrfs_path *path,
        int num;
        u8 type;

-       if (found_key->type == BTRFS_XATTR_ITEM_KEY)
-               buf_len = BTRFS_MAX_XATTR_SIZE(root);
-       else
-               buf_len = PATH_MAX;
-
+       /*
+        * Start with a small buffer (1 page). If later we end up needing more
+        * space, which can happen for xattrs on a fs with a leaf size greater
+        * then the page size, attempt to increase the buffer. Typically xattr
+        * values are small.
+        */
+       buf_len = PATH_MAX;
        buf = kmalloc(buf_len, GFP_NOFS);
        if (!buf) {
                ret = -ENOMEM;
@@ -1037,7 +1039,7 @@ static int iterate_dir_item(struct btrfs_root *root, struct btrfs_path *path,
                                ret = -ENAMETOOLONG;
                                goto out;
                        }
-                       if (name_len + data_len > buf_len) {
+                       if (name_len + data_len > BTRFS_MAX_XATTR_SIZE(root)) {
                                ret = -E2BIG;
                                goto out;
                        }
@@ -1045,12 +1047,30 @@ static int iterate_dir_item(struct btrfs_root *root, struct btrfs_path *path,
                        /*
                         * Path too long
                         */
-                       if (name_len + data_len > buf_len) {
+                       if (name_len + data_len > PATH_MAX) {
                                ret = -ENAMETOOLONG;
                                goto out;
                        }
                }

+               if (name_len + data_len > buf_len) {
+                       buf_len = name_len + data_len;
+                       if (is_vmalloc_addr(buf)) {
+                               vfree(buf);
+                               buf = NULL;
+                       } else {
+                               kfree(buf);
+                               buf = kmalloc(buf_len, GFP_NOFS);
+                       }
+                       if (!buf) {
+                               buf = vmalloc(buf_len);
+                               if (!buf) {
+                                       ret = -ENOMEM;
+                                       goto out;
+                               }
+                       }
+               }
+
                read_extent_buffer(eb, buf, (unsigned long)(di + 1),
                                name_len + data_len);

@@ -1071,7 +1091,10 @@ static int iterate_dir_item(struct btrfs_root *root, struct btrfs_path *path,
        }

 out:
-       kfree(buf);
+       if (is_vmalloc_addr(buf))
+               vfree(buf);
+       else
+               kfree(buf);
        return ret;
 }

--
1.9.1

