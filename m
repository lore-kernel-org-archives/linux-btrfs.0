From: TARUISI Hiroaki <taruishi.hiroak@jp.fujitsu.com>
Subject: Re: [PATCH] Btrfs: fix various things with the listing ioctl
Date: Tue, 15 Dec 2009 11:48:41 +0900
Message-ID: <4B26F909.2040101@jp.fujitsu.com>
References: <20091214191722.GB2165@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-btrfs@vger.kernel.org, chris.mason@oracle.com
To: josef@redhat.com
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20091214191722.GB2165@localhost.localdomain>
List-ID: <linux-btrfs.vger.kernel.org>

(2009/12/15 4:17), Josef Bacik wrote:
> With slab poisoning on you could panic the box simply by running btrfsctl -l
> multiple times in a row on the same volume.  This patch fixes up the ioctl stuff
> to be a bit cleaner, makes sure we always call btrfs_free_path() instead of
> kfree(path) and make sure we do not kfree() our work names before we are done
> using them.  There were several memory leaks and use after free problems
> previously, they appear to be gone now, and as an added bonus doing btrfsctl -l
> no longer panic's the box.  Thanks,
> 
> Signed-off-by: Josef Bacik <josef@redhat.com>
> ---

Thank you for your patch. I've tested this patch and
I found it works. And I'd like to add one line to
prevent from another tiny leak.

Signed-off-by: TARUISI Hiroaki <taruishi.hiroak@jp.fujitsu.com>
---
 fs/btrfs/ioctl.c |    1 +
 1 file changed, 1 insertion(+)

Index: b/fs/btrfs/ioctl.c
===================================================================
--- a/fs/btrfs/ioctl.c	2009-12-15 11:31:18.000000000 +0900
+++ b/fs/btrfs/ioctl.c	2009-12-15 11:33:28.000000000 +0900
@@ -989,6 +989,7 @@ static noinline int btrfs_ioctl_snap_lis
 		if (rest < sizeof(struct btrfs_ioctl_subvol_items) +
 			name_len + strlen(work_path) + 1) {
 			svol->next_len = name_len + strlen(work_path);
+			kfree(name);
 			if (copy_to_user(arg, svol, sizeof(*svol))) {
 				ret = -EFAULT;
 				goto out;

