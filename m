Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:46778 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752070Ab3BVHdw (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 22 Feb 2013 02:33:52 -0500
Date: Fri, 22 Feb 2013 15:32:32 +0800
From: Liu Bo <bo.li.liu@oracle.com>
To: Marios Titas <redneb8888@gmail.com>
Cc: btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: bug: per file cow flag is lost when renaming
Message-ID: <20130222073231.GA12835@liubo.cn.oracle.com>
Reply-To: bo.li.liu@oracle.com
References: <CAAdM644AsDFfyj_9PEFthNBbcnNc_jy4dxMZmbrb9dBHeK5xkw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CAAdM644AsDFfyj_9PEFthNBbcnNc_jy4dxMZmbrb9dBHeK5xkw@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Jan 28, 2013 at 10:49:20AM -0500, Marios Titas wrote:
> Try this:
> 
>     touch test
>     chattr +C test
>     lsattr test
>     mv test test2
>     lsattr test2
> 
> The original file (test) will have the C flag but when renamed the
> flag disappears. If the volume is unmounted and then mounted again the
> flag reappears. However, if the file is modified in any way after the
> renaming but before the umount/mount then even weirder things happen,
> eg:
> 
>     touch test
>     chattr +C test
>     head -c1048576 /dev/zero >> test
>     lsattr test
>     # the C flag exists and the file does not COW when modified as expected
>     mv test test2
>     lsattr test2
>     # now the C flag disappeared
>     # if you modify the file it will COW and the flag will not
> reappear after umount/mount
> 
> even worse, if you try to use BTRFS_IOC_CLONE to clone test2 to a
> non-COW file with eg
> 
>     cp --reflink test2 test3
> 
> it will fail with EINVAL as if the file test2 had the COW flag.

Hi Marios,

Seems that we've lost a proper update inode during rename.

Moving to another dir without the C flag will clear the file's C flag, since
we want file to inherit noCow flag from its parent directory.

So after 'mv test test2', test is without C flag now.
But we don't update the new inode flag onto disk so a remount will bring the
C flag back.

Could you please check if the following patch(based on latest cmason/for-linus)
helps?

thanks,
liubo

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index d9984fa..d2e3352 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -7478,8 +7478,6 @@ static int btrfs_rename(struct inode *old_dir, struct
dentry *old_dentry,
 					old_dentry->d_inode,
 					old_dentry->d_name.name,
 					old_dentry->d_name.len);
-		if (!ret)
-			ret = btrfs_update_inode(trans, root, old_inode);
 	}
 	if (ret) {
 		btrfs_abort_transaction(trans, root, ret);
@@ -7514,6 +7512,11 @@ static int btrfs_rename(struct inode *old_dir, struct
dentry *old_dentry,
 	}
 
 	fixup_inode_flags(new_dir, old_inode);
+	ret = btrfs_update_inode(trans, root, old_inode);
+	if (ret) {
+		btrfs_abort_transaction(trans, root, ret);
+		goto out_fail;
+	}
 
 	ret = btrfs_add_link(trans, new_dir, old_inode,
 			     new_dentry->d_name.name,


> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
