Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mo-p00-ob.rzone.de ([81.169.146.160]:10444 "EHLO
	mo-p00-ob.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752155Ab3GQJJs (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 17 Jul 2013 05:09:48 -0400
Message-ID: <51E65F5A.6050501@giantdisaster.de>
Date: Wed, 17 Jul 2013 11:09:46 +0200
From: Stefan Behrens <sbehrens@giantdisaster.de>
MIME-Version: 1.0
To: Anand Jain <Anand.Jain@oracle.com>
CC: linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: [bug] label cli hangs until balance is completed
References: <51E655D1.5020309@oracle.com>
In-Reply-To: <51E655D1.5020309@oracle.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, 17 Jul 2013 16:29:05 +0800, Anand Jain wrote:
>  'btrfs fi label /btrfs' will hang until balance is completed.
>  (and probably even set label would hang). This is because we
>  are trying to hold volume_mutex lock which balance will hold
>  during its tenure.
> 
> -------
> static int btrfs_ioctl_get_fslabel(struct file *file, void __user *arg)
> ::
>         mutex_lock(&root->fs_info->volume_mutex);
>         ret = copy_to_user(arg, label, len);
>         mutex_unlock(&root->fs_info->volume_mutex);
> --------
> 
>  I doubt if get label would need such a heavy weight lock?
>  Do we have any other lock which could fit better here ?
>  Any comments ?

Just use the uuid_mutex instead of the volume_mutex.

In addition to the btrfs_ioctl_get_fslabel() and
btrfs_ioctl_set_fslabel() functions, only btrfs_scan_one_device()
accesses the label. And btrfs_scan_one_device() holds the uuid_mutex,
not the volume_mutex. You can do the same.

And since cwillu's commit 1332a002b, the uuid_mutex is not hold for a
long time anymore.

And while you change it, please move the mutex_lock() so that it
includes also the strnlen() access to the label, like this:

diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index 2177bea..30a8126 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -4043,15 +4043,16 @@ static int btrfs_ioctl_get_fslabel(struct file
*file, vo
 {
        struct btrfs_root *root = BTRFS_I(fdentry(file)->d_inode)->root;
        const char *label = root->fs_info->super_copy->label;
-       size_t len = strnlen(label, BTRFS_LABEL_SIZE);
+       size_t len;
        int ret;

+       mutex_lock(&root->fs_info->volume_mutex);
+       len = strnlen(label, BTRFS_LABEL_SIZE);
        if (len == BTRFS_LABEL_SIZE) {
                pr_warn("btrfs: label is too long, return the first %zu
bytes\n"
                        --len);
        }

-       mutex_lock(&root->fs_info->volume_mutex);
        ret = copy_to_user(arg, label, len);
        mutex_unlock(&root->fs_info->volume_mutex);

