Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.fusionio.com ([66.114.96.30]:45389 "EHLO mx1.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754610Ab2F0VQx (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 27 Jun 2012 17:16:53 -0400
Date: Wed, 27 Jun 2012 17:16:50 -0400
From: Josef Bacik <jbacik@fusionio.com>
To: "Nathan A. Mourey II" <nmoureyii@ne.rr.com>
CC: Josef Bacik <JBacik@fusionio.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: btrfs oops with kernel 3.5-rc4
Message-ID: <20120627211649.GA17383@localhost.localdomain>
References: <1340741359.2226.5.camel@athena>
 <20120626201950.GB24953@localhost.localdomain>
 <1340823472.2269.31.camel@athena>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <1340823472.2269.31.camel@athena>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Jun 27, 2012 at 12:57:52PM -0600, Nathan A. Mourey II wrote:
> On Tue, 2012-06-26 at 16:19 -0400, Josef Bacik wrote:
> > list *(btrfs_finish_ordered_io+0x22)
> 
> Reading symbols from /home/nmoureyii/kernel/linux-3.5-rc4/vmlinux...done.
> (gdb) list *(btrfs_finish_ordered_io+0x22)
> 0xc1237552 is in btrfs_finish_ordered_io (fs/btrfs/inode.c:1864).
> 1859	 * fully written.
> 1860	 */
> 1861	static int btrfs_finish_ordered_io(struct btrfs_ordered_extent *ordered_extent)
> 1862	{
> 1863		struct inode *inode = ordered_extent->inode;
> 1864		struct btrfs_root *root = BTRFS_I(inode)->root;
> 1865		struct btrfs_trans_handle *trans = NULL;
> 1866		struct extent_io_tree *io_tree = &BTRFS_I(inode)->io_tree;
> 1867		struct extent_state *cached_state = NULL;
> 1868		int compress_type = 0;
> (gdb) 
> 
> 

Just sent a patch to the list, please test it and verify it works, the subject
is

Btrfs: hold a ref on the inode during writepages

Thanks,

Josef
