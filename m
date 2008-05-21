From: Mingming <cmm@us.ibm.com>
Subject: btrfs_put_inode
Date: Wed, 21 May 2008 10:19:00 -0700
Message-ID: <1211390340.5571.19.camel@BVR-FS.beaverton.ibm.com>
References: <Pine.LNX.4.64.0804241352130.23551@cobra.newdream.net>
	 <Pine.LNX.4.64.0805022255370.15314@cobra.newdream.net>
	 <3d0408630805030025s2c9006c1qad3c29011caf3013@mail.gmail.com>
	 <200805050627.46919.chris.mason@oracle.com>
	 <Pine.LNX.4.64.0805050855250.15314@cobra.newdream.net>
Mime-Version: 1.0
Content-Type: text/plain
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
To: Chris Mason <chris.mason@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.64.0805050855250.15314@cobra.newdream.net>
List-ID: <linux-btrfs.vger.kernel.org>

Hi Chris,

btrfs failed to compile on 2.6.26-rc2 since the put_inode callback
function is removed from super_operations. 

I noticed btrfs_put_inode() seems being actively used, to drop the inode
from the tree for ordered mode transaction. Any idea where to relocate
this function? Do we need to call btrfs_del_ordered_inode() for every
iput()?

Thanks,
Mingming

