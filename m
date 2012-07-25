Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mailhost.fernuni-hagen.de ([132.176.114.94]:62206 "EHLO
	mailhost.FernUni-Hagen.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756498Ab2GYKy0 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 25 Jul 2012 06:54:26 -0400
Received: from mailstore.fernuni-hagen.de ([132.176.114.185])
	by mailhost.FernUni-Hagen.de with esmtp (Exim 4.69)
	(envelope-from <q6753817@mailstore.FernUni-Hagen.de>)
	id 1Stz1o-0000cV-JV
	for linux-btrfs@vger.kernel.org; Wed, 25 Jul 2012 12:41:16 +0200
Received: from [85.158.138.21] (account q6753817@mailstore.fernuni-hagen.de)
  by mailstore.fernuni-hagen.de (CommuniGate Pro WebUser 5.0.2)
  with HTTP id 48902846 for linux-btrfs@vger.kernel.org; Wed, 25 Jul 2012 12:41:15 +0200
From: "Guenther Rasch" <Guenther.Rasch@FernUni-Hagen.de>
Subject: Question about btrfs metadata structure
To: linux-btrfs@vger.kernel.org
Date: Wed, 25 Jul 2012 12:41:15 +0200
Message-ID: <web-48902846@mailstore.fernuni-hagen.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
	format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi!

I'm writing my bsc thesis about btrfs and I'm analyzing 
the
btrfs metadata structure at the moment.

I'm using fedora 17 with kernel 3.4 and btrfs-prog from 
your
git-repository. For an overview I use "btrfs-debug-tree" 
and
here are my questions:

The root tree contains some inode_items, but I don't 
understand
the meaning of them:
item 4 key (ROOT_TREE_DIR INODE_ITEM 0) itemoff 3101 
itemsize 160
inode generation 3 size 0 block group 0 mode 40555 links 1

item 5 key (ROOT_TREE_DIR INODE_REF 6) itemoff 3089 
itemsize 12
inode ref index 0 namelen 2 name: ..

The key for an inode_item is objectid=ROOT_TREE_DIR. 
ROOT-TREE-DIR is the inode-Nr.?
What does offset=6 regarding INODE_REF mean? --> item 5

Also placed in the root tree, I've found entries of
(FREE_SPACE UNTYPED ....)
What does UNTYPED mean in this context and the offset is
the logical address of a block group (I guess...)? This
item has a pointer to an inode_item, is that right?

And last question about this entries:
item 2 key (FS_TREE INODE_REF 6) itemoff 3500 itemsize 17
  inode ref index 0 namelen 7 name: default
...
item 6 key (ROOT_TREE_DIR DIR_ITEM 2378154706) itemoff 
3052 itemsize 37
  location key (FS_TREE ROOT_ITEM 18446744073709551615) 
type 2
  namelen 7 datalen 0 name: default

There is an INODE_REF (again, offset 6...?) pointing to
which inode? I cannot find some...
What's about that offset in location key (FS_TREE....)

Thx in advance for your patience and answers!

Regards
Guenther
