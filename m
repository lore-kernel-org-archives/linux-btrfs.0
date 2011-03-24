From: David Sterba <dave@jikos.cz>
Subject: Re: [PATCH V5 1/2] btrfs: use GFP_NOFS instead of GFP_KERNEL
Date: Fri, 25 Mar 2011 00:07:59 +0100
Message-ID: <20110324230759.GK17108@twin.jikos.cz>
References: <4D8B2DE1.2040002@cn.fujitsu.com>
Reply-To: dave@jikos.cz
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Chris Mason <chris.mason@oracle.com>,
	Linux Btrfs <linux-btrfs@vger.kernel.org>,
	Itaru Kitayama <kitayama@cl.bb4u.ne.jp>,
	Ito <t-itoh@jp.fujitsu.com>, David Sterba <dave@jikos.cz>
To: Miao Xie <miaox@cn.fujitsu.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4D8B2DE1.2040002@cn.fujitsu.com>
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

On Thu, Mar 24, 2011 at 07:41:21PM +0800, Miao Xie wrote:
> In the filesystem context, we must allocate memory by GFP_NOFS,
> or we may start another filesystem operation and make kswap thread hang up.

indeed. Did you check for other GFP_KERNEL allocations? I've found 8 more
them and at least these look like candidates for GFP_NOFS too:

diff --git a/fs/btrfs/acl.c b/fs/btrfs/acl.c
index de34bfa..76b9218 100644
--- a/fs/btrfs/acl.c
+++ b/fs/btrfs/acl.c
@@ -289,7 +289,7 @@ int btrfs_acl_chmod(struct inode *inode)
        if (IS_ERR(acl) || !acl)
                return PTR_ERR(acl);

-       clone = posix_acl_clone(acl, GFP_KERNEL);
+       clone = posix_acl_clone(acl, GFP_NOFS);
        posix_acl_release(acl);
        if (!clone)
                return -ENOMEM;
diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
index f447b78..eb5c01d 100644
--- a/fs/btrfs/file.c
+++ b/fs/btrfs/file.c
@@ -998,7 +998,7 @@ static ssize_t btrfs_file_aio_write(struct kiocb *iocb,
        nrptrs = min((iov_iter_count(&i) + PAGE_CACHE_SIZE - 1) /
                     PAGE_CACHE_SIZE, PAGE_CACHE_SIZE /
                     (sizeof(struct page *)));
-       pages = kmalloc(nrptrs * sizeof(struct page *), GFP_KERNEL);
+       pages = kmalloc(nrptrs * sizeof(struct page *), GFP_NOFS);
        if (!pages) {
                ret = -ENOMEM;
                goto out;
diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index d1bace3..e9b9648 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -1644,7 +1644,7 @@ static int btrfs_ioctl_defrag(struct file *file, void __user *argp)
                        goto out;
                }

-               range = kzalloc(sizeof(*range), GFP_KERNEL);
+               range = kzalloc(sizeof(*range), GFP_NOFS);
                if (!range) {
                        ret = -ENOMEM;
                        goto out;
diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
index d39a989..5e0fff7 100644
--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -399,7 +399,7 @@ static int btrfs_parse_early_options(const char *options, fmode_t flags,
         * strsep changes the string, duplicate it because parse_options
         * gets called twice
         */
-       opts = kstrdup(options, GFP_KERNEL);
+       opts = kstrdup(options, GFP_NOFS);
        if (!opts)
                return -ENOMEM;
        orig = opts;
@@ -446,7 +446,7 @@ static int btrfs_parse_early_options(const char *options, fmode_t flags,
         * mount path doesn't care if it's the default volume or another one.
         */
        if (!*subvol_name) {
-               *subvol_name = kstrdup(".", GFP_KERNEL);
+               *subvol_name = kstrdup(".", GFP_NOFS);
                if (!*subvol_name)
                        return -ENOMEM;
        }


dave
