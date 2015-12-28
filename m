Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.21]:61646 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752469AbbL1UQn (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 28 Dec 2015 15:16:43 -0500
Subject: Trouble with broken RAID5/6 System after trying to solve a problem,
 want to recover contained Data
References: <567323AA.70203@GMX.net>
To: linux-btrfs@vger.kernel.org
From: Christian <Kamiekatze@GMX.net>
Reply-To: Christian <Kamiekatze@GMX.net>
Message-ID: <568198A6.10806@GMX.net>
Date: Mon, 28 Dec 2015 21:16:38 +0100
MIME-Version: 1.0
In-Reply-To: <567323AA.70203@GMX.net>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I found out, that i can also show more Information about Files and Diretories contained in the Filesystem.

btrfs-debug-tree show me the following Infos:

parent transid verify failed on 2234958286848 wanted 35674 found 35675
parent transid verify failed on 2234958286848 wanted 35674 found 35675
parent transid verify failed on 2234958286848 wanted 35674 found 35675
Ignoring transid failure
root tree
node 2234958307328 level 1 items 20 free 101 generation 35675 owner 1
fs uuid a405d8a3-64f5-4b70-88fa-29df558262b0
chunk uuid 167d74cd-1bd1-4c1c-9acd-3fcb1ef4f483
	key (EXTENT_TREE ROOT_ITEM 0) block 2234958311424 (545644119) gen 35674
	key (1374 INODE_ITEM 0) block 2235090616320 (545676420) gen 35673
	key (1381 INODE_ITEM 0) block 2235090214912 (545676322) gen 35673
	key (1396 INODE_ITEM 0) block 2235090239488 (545676328) gen 35673
	key (1411 INODE_ITEM 0) block 2235090538496 (545676401) gen 35673
	key (1425 EXTENT_DATA 0) block 2235187728384 (545700129) gen 35637
	key (1440 EXTENT_DATA 0) block 2235890171904 (545871624) gen 34929
	key (1449 INODE_ITEM 0) block 2513856499712 (613734497) gen 35102
	key (1464 INODE_ITEM 0) block 2235132993536 (545686766) gen 35636
	key (1479 INODE_ITEM 0) block 2235090554880 (545676405) gen 35673
	key (1494 INODE_ITEM 0) block 2235830722560 (545857110) gen 29339
	key (1509 INODE_ITEM 0) block 2234985762816 (545650821) gen 34043
	key (1524 INODE_ITEM 0) block 2236064706560 (545914235) gen 35321
	key (1539 INODE_ITEM 0) block 2235081564160 (545674210) gen 35572
	key (1547 INODE_ITEM 0) block 2235090591744 (545676414) gen 35673
	key (1562 INODE_ITEM 0) block 2235090604032 (545676417) gen 35673
	key (FREE_SPACE UNTYPED 2268378497024) block 2235090870272 (545676482) gen 35673
	key (FREE_SPACE UNTYPED 2365015261184) block 2235090853888 (545676478) gen 35673
	key (FREE_SPACE UNTYPED 2556174860288) block 2235833815040 (545857865) gen 29340
	key (FREE_SPACE UNTYPED 2633484271616) block 2234958319616 (545644121) gen 35675
leaf 2234958311424 items 9 free space 1349 generation 35674 owner 1
fs uuid a405d8a3-64f5-4b70-88fa-29df558262b0
chunk uuid 167d74cd-1bd1-4c1c-9acd-3fcb1ef4f483
...
leaf 2235411533824 items 50 free space 9 generation 25816 owner 5
fs uuid a405d8a3-64f5-4b70-88fa-29df558262b0
chunk uuid 167d74cd-1bd1-4c1c-9acd-3fcb1ef4f483
...
	item 2 key (259 DIR_ITEM 714625598) itemoff 3831 itemsize 51
		location key (380075 INODE_ITEM 0) type FILE
		namelen 21 datalen 0 name: Pixar - Gasplanet.mpg
...


Does someone know how to recover the files from the Filesystem?

Kind regards,
	Christian

