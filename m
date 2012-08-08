Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.fusionio.com ([66.114.96.31]:58353 "EHLO mx2.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759006Ab2HHRkP (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 8 Aug 2012 13:40:15 -0400
Date: Wed, 8 Aug 2012 13:40:11 -0400
From: Josef Bacik <jbacik@fusionio.com>
To: David Sterba <dave@jikos.cz>
CC: =?iso-8859-1?Q?Llu=EDs?= Batlle i Rossell <viric@viric.name>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: BUG on 3.5.0
Message-ID: <20120808174011.GD2141@localhost.localdomain>
References: <20120808161819.GO25996@vicerveza.homeunix.net>
 <20120808173645.GA17430@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
In-Reply-To: <20120808173645.GA17430@twin.jikos.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Aug 08, 2012 at 11:36:45AM -0600, David Sterba wrote:
> Hi,
> 
> On Wed, Aug 08, 2012 at 06:18:19PM +0200, Lluís Batlle i Rossell wrote:
> > I attach dmesg.txt, and the disasm of insert_inline_extent_backref. That disasm
> > was a bit tricky; my objdump does not seem to understand the btrfs.ko.
> 
> thanks, added a few bits to the picture
> 
> > [ 6095.255745] ------------[ cut here ]------------
> > [ 6095.255757] kernel BUG at fs/btrfs/extent-tree.c:1769!
> > [ 6095.255762] invalid opcode: 0000 [#1] SMP
> > [ 6095.255769] CPU 1
> > [ 6095.255772] Modules linked in:<4>[ 6095.255897]  jbd ext2 mbcache
> > [ 6095.255904]
> > [ 6095.255910] Pid: 30286, comm: btrfs Tainted: P           O 3.5.0 #1 System manufacturer System Product Name/M4A79 Deluxe
> > [ 6095.255920] RIP: 0010:[<ffffffffa0191c9f>]  [<ffffffffa0191c9f>] insert_inline_extent_backref+0xef/0x100 [btrfs]
> > [ 6095.255965] RSP: 0018:ffff880028723788  EFLAGS: 00010293
> > [ 6095.255970] RAX: 0000000000000000 RBX: ffff8801275b3510 RCX: ffff8800287237d0
> > [ 6095.255974] RDX: ffff8801275b3510 RSI: 0000000000000001 RDI: 0000000000000000
> > [ 6095.255978] RBP: ffff880028723808 R08: 0000000000000bf2 R09: ffff880028723698
> > [ 6095.255981] R10: 0000000000000000 R11: 0000000000000000 R12: ffff880126918800
> > [ 6095.255985] R13: ffff88012afdd280 R14: 0000000000000000 R15: 0000000000000001
> 
> 1753 static noinline_for_stack
> 1754 int insert_inline_extent_backref(struct btrfs_trans_handle *trans,
> 1755                                  struct btrfs_root *root,
> 1756                                  struct btrfs_path *path,
> 1757                                  u64 bytenr, u64 num_bytes, u64 parent,
> 1758                                  u64 root_objectid, u64 owner,
> 1759                                  u64 offset, int refs_to_add,
> 1760                                  struct btrfs_delayed_extent_op *extent_op)
> 1761 {
> 1762         struct btrfs_extent_inline_ref *iref;
> 1763         int ret;
> 1764
> 1765         ret = lookup_inline_extent_backref(trans, root, path, &iref,
> 1766                                            bytenr, num_bytes, parent,
> 1767                                            root_objectid, owner, offset, 1);
> 1768         if (ret == 0) {
> 1769                 BUG_ON(owner < BTRFS_FIRST_FREE_OBJECTID);
> 
> >    15c17:    49 81 ff ff 00 00 00     cmp     $0xff,%r15
> >    15c1e:    76 7f                    jbe     0x15c9f
> 
> according to assembly, owner is in R15, BTRFS_FIRST_FREE_OBJECTID is
> 256, so owner == 1

This is fixed already in btrfs-next.  Thanks,

Josef
