Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mailout07.t-online.de ([194.25.134.83]:55876 "EHLO
	mailout07.t-online.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751366Ab2FFMps (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 6 Jun 2012 08:45:48 -0400
Date: 06 Jun 2012 13:48:00 +0200
From: Hullen@t-online.de (Helmut Hullen)
To: linux-btrfs@vger.kernel.org
Message-ID: <CAMlaX89CXB@helmut.hullen.de>
In-Reply-To: <20120605190921.GM15986@carfax.org.uk>
Subject: Re: New btrfs-progs integration branch
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Reply-To: helmut@hullen.de
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hallo, Hugo,

Du meintest am 05.06.12:

>    The branch is fetchable with git from:

> http://git.darksatanic.net/repo/btrfs-progs-unstable.git/
> integration-20120605

There seems to be a bug inside:

[...]

gcc -g -O0 -o btrfsck btrfsck.o ctree.o disk-io.o radix-tree.o extent- 
tree.o print-tree.o root-tree.o dir-item.o file-item.o inode-item.o  
inode-map.o crc32c.o rbtree.o extent-cache.o extent_io.o volumes.o  
utils.o btrfs-list.o btrfslabel.o repair.o  -luuid

gcc -g -O0 -o btrfs-convert ctree.o disk-io.o radix-tree.o extent-tree.o print-tree.o root-tree.o dir-item.o file-item.o inode-item.o inode-map.o crc32c.o rbtree.o extent-cache.o extent_io.o volumes.o utils.o btrfs-list.o btrfslabel.o repair.o convert.o -lext2fs -lcom_err  -luuid

gcc   convert.o   -o convert
convert.o: In function `btrfs_item_key':
/tmp/btrfs-progs-unstable/ctree.h:1404: undefined reference to `read_extent_buffer'
convert.o: In function `btrfs_dir_item_key':
/tmp/btrfs-progs-unstable/ctree.h:1437: undefined reference to `read_extent_buffer'
convert.o: In function `btrfs_del_item':

[...]

Viele Gruesse!
Helmut
