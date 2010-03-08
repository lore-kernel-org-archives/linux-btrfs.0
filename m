From: Chris Ball <cjb@laptop.org>
Subject: Re: Cross-subvolume link causes kernel BUG
Date: Mon, 08 Mar 2010 12:39:38 -0500
Message-ID: <m3hboqsof9.fsf@pullcord.laptop.org>
References: <20100308172438.GA5506@untroubled.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-btrfs@vger.kernel.org
To: Bruce Guenter <bruce@untroubled.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20100308172438.GA5506@untroubled.org> (Bruce Guenter's message
	of "Mon, 8 Mar 2010 11:24:38 -0600")
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

   > ln segfaults, and the bug above is found in dmesg.  Subsequent
   > accesses to the subvolume result in a D state hung process.  Full
   > dmesg follows.  I first observed this on a Gentoo system and
   > reproduced it on Ubuntu.  Both were running unpatched 2.6.32.9
   > kernels.

I think this is fixed in 2.6.33, as a result of the patch below.
Let us know if you see a segfault on 2.6.33, or after applying this
patch to your current kernel.

Thanks,

- Chris.

commit 4a8be425a8fb8fbb5d881eb55fa6634c3463b9c9
Author: TARUISI Hiroaki <taruishi.hiroak@jp.fujitsu.com>
Date:   Thu Nov 12 07:14:26 2009 +0000

    Btrfs: deny sys_link across subvolumes.
    
    I rebased Christian Parpart's patch to deny hard link across
    subvolumes. Original patch modifies also btrfs_rename, but
    I excluded it because we can move across subvolumes now and
    it make no problem.
    -----------------
    
    Hard link across subvolumes should not allowed in Btrfs.
    btrfs_link checks root of 'to' directory is same as root
    of 'from' file. If not same, btrfs_link returns -EPERM.
    
    Signed-off-by: TARUISI Hiroaki <taruishi.hiroak@jp.fujitsu.com>
    Signed-off-by: Chris Mason <chris.mason@oracle.com>

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 168e8c0..da76cad 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -4462,6 +4462,10 @@ static int btrfs_link(struct dentry *old_dentry, struct inode *dir,
 	if (inode->i_nlink == 0)
 		return -ENOENT;
 
+	/* do not allow sys_link's with other subvols of the same device */
+	if (root->objectid != BTRFS_I(inode)->root->objectid)
+		return -EPERM;
+
 	/*
 	 * 1 item for inode ref
 	 * 2 items for dir items

-- 
Chris Ball   <cjb@laptop.org>
One Laptop Per Child
