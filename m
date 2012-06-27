Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:6940 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752038Ab2F0S56 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 27 Jun 2012 14:57:58 -0400
Message-ID: <1340823472.2269.31.camel@athena>
Subject: Re: btrfs oops with kernel 3.5-rc4
From: "Nathan A. Mourey II" <nmoureyii@ne.rr.com>
To: Josef Bacik <jbacik@fusionio.com>
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Date: Wed, 27 Jun 2012 14:57:52 -0400
In-Reply-To: <20120626201950.GB24953@localhost.localdomain>
References: <1340741359.2226.5.camel@athena>
	 <20120626201950.GB24953@localhost.localdomain>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, 2012-06-26 at 16:19 -0400, Josef Bacik wrote:
> list *(btrfs_finish_ordered_io+0x22)

Reading symbols from /home/nmoureyii/kernel/linux-3.5-rc4/vmlinux...done.
(gdb) list *(btrfs_finish_ordered_io+0x22)
0xc1237552 is in btrfs_finish_ordered_io (fs/btrfs/inode.c:1864).
1859	 * fully written.
1860	 */
1861	static int btrfs_finish_ordered_io(struct btrfs_ordered_extent *ordered_extent)
1862	{
1863		struct inode *inode = ordered_extent->inode;
1864		struct btrfs_root *root = BTRFS_I(inode)->root;
1865		struct btrfs_trans_handle *trans = NULL;
1866		struct extent_io_tree *io_tree = &BTRFS_I(inode)->io_tree;
1867		struct extent_state *cached_state = NULL;
1868		int compress_type = 0;
(gdb) 


And no compression.



