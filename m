Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:59059 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751151Ab3CAWsS (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 1 Mar 2013 17:48:18 -0500
Received: from int-mx10.intmail.prod.int.phx2.redhat.com (int-mx10.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id r21MmIFD000505
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Fri, 1 Mar 2013 17:48:18 -0500
Received: from localhost (ovpn01.gateway.prod.ext.phx2.redhat.com [10.5.9.1])
	by int-mx10.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP id r21MmHbq010611
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES128-SHA bits=128 verify=NO)
	for <linux-btrfs@vger.kernel.org>; Fri, 1 Mar 2013 17:48:18 -0500
Date: Fri, 1 Mar 2013 14:48:17 -0800
From: Zach Brown <zab@redhat.com>
To: linux-btrfs@vger.kernel.org
Subject: unremovable dirs from failed unlink
Message-ID: <20130301224817.GY1658@lenny.home.zabbo.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


A while ago someone on IRC had a directory with no entries but with a
non-zero i_size.  rmdir fails because i_size isn't zero but there are no
items left to remove and decrease i_size.

At the time casual code inspection implied that this would be possible
in unlucky error cases.  I finally got around to really reading up and
reproducing it.

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index ecd9c4c..11fc4b1 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -3592,8 +3592,11 @@ static int __btrfs_unlink_inode(struct btrfs_trans_handle *trans,
                goto err;
        }
 
-       ret = btrfs_del_dir_entries_in_log(trans, root, name, name_len,
-                                          dir, index);
+       if (!strncmp(name, "fail-please", min(name_len, 11)))
+               ret = -ENOMEM;
+       else
+               ret = btrfs_del_dir_entries_in_log(trans, root, name, name_len,
+                                                  dir, index);
        if (ret == -ENOENT)
                ret = 0;
 err:


[root@f18 dir]# stat .
  File: ‘.’
  Size: 22        	Blocks: 0          IO Block: 4096   directory
Device: 20h/32d	Inode: 257         Links: 1

[root@f18 dir]# rm fail-please 
rm: cannot remove ‘fail-please’: Cannot allocate memory

[root@f18 dir]# ls -la
total 4
drwxr-xr-x. 1 root root 22 Mar  1 17:33 .
drwxr-xr-x. 1 root root  6 Mar  1 17:33 ..

(only 257 items in debug-tree)
        item 4 key (257 INODE_ITEM 0) itemoff 3597 itemsize 160
                inode generation 5 transid 5 size 22 block group 0 mode 40755 links 1
        item 5 key (257 INODE_REF 256) itemoff 3584 itemsize 13
                inode ref index 2 namelen 3 name: dir
        item 6 key (257 XATTR_ITEM 3817753667) itemoff 3506 itemsize 78
                location key (0 UNKNOWN.0 0) type 8
                namelen 16 datalen 32 name: security.selinux
                data unconfined_u:object_r:file_t:s0

[root@f18 dir]# stat .
  File: ‘.’
  Size: 22        	Blocks: 0          IO Block: 4096   directory

[root@f18 dir]# cd ..
[root@f18 btrfs]# rmdir dir/
rmdir: failed to remove ‘dir/’: Directory not empty

So what's the intended error handling fix here?  Should it abort the
transaction on any failures after it's partially deleted the data?  Try
to reconstruct the deleted data after failure part-way through and only
abort the transaction if *that* fails?

I'll happily implement whatever the intended design is here.

- z
