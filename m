Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:12818 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751407Ab2G0HfJ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 27 Jul 2012 03:35:09 -0400
Message-ID: <5012446D.90302@cn.fujitsu.com>
Date: Fri, 27 Jul 2012 15:34:05 +0800
From: Liu Bo <liubo2009@cn.fujitsu.com>
MIME-Version: 1.0
To: Guenther Rasch <Guenther.Rasch@FernUni-Hagen.de>
CC: linux-btrfs@vger.kernel.org
Subject: Re: Question about btrfs metadata structure
References: <web-48902846@mailstore.fernuni-hagen.de>
In-Reply-To: <web-48902846@mailstore.fernuni-hagen.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 07/25/2012 06:41 PM, Guenther Rasch wrote:

> Hi!
> 
> I'm writing my bsc thesis about btrfs and I'm analyzing the
> btrfs metadata structure at the moment.
> 
> I'm using fedora 17 with kernel 3.4 and btrfs-prog from your
> git-repository. For an overview I use "btrfs-debug-tree" and
> here are my questions:
> 
> The root tree contains some inode_items, but I don't understand
> the meaning of them:
> item 4 key (ROOT_TREE_DIR INODE_ITEM 0) itemoff 3101 itemsize 160
> inode generation 3 size 0 block group 0 mode 40555 links 1
> 
> item 5 key (ROOT_TREE_DIR INODE_REF 6) itemoff 3089 itemsize 12
> inode ref index 0 namelen 2 name: ..
> 
> The key for an inode_item is objectid=ROOT_TREE_DIR. ROOT-TREE-DIR is
> the inode-Nr.?
> What does offset=6 regarding INODE_REF mean? --> item 5
> 


I think you can find the answer by doing grep ROOT_TREE_DIR in btrfs-progs source code. ;)

> Also placed in the root tree, I've found entries of
> (FREE_SPACE UNTYPED ....)
> What does UNTYPED mean in this context and the offset is
> the logical address of a block group (I guess...)? This
> item has a pointer to an inode_item, is that right?
> 


It's free space cache, which refers to free-space-cache.c in upstream's code.

> And last question about this entries:
> item 2 key (FS_TREE INODE_REF 6) itemoff 3500 itemsize 17
>  inode ref index 0 namelen 7 name: default
> ...
> item 6 key (ROOT_TREE_DIR DIR_ITEM 2378154706) itemoff 3052 itemsize 37
>  location key (FS_TREE ROOT_ITEM 18446744073709551615) type 2
>  namelen 7 datalen 0 name: default
> 
> There is an INODE_REF (again, offset 6...?) pointing to
> which inode? I cannot find some...
> What's about that offset in location key (FS_TREE....)
> 
> Thx in advance for your patience and answers!
> 
> Regards
> Guenther
> -- 
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 


