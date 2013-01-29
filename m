Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:50135 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751958Ab3A2Cak (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 28 Jan 2013 21:30:40 -0500
Date: Tue, 29 Jan 2013 10:27:54 +0800
From: Liu Bo <bo.li.liu@oracle.com>
To: Mitch Harder <mitch.harder@sabayonlinux.org>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] Btrfs: fix race between snapshot deletion and getting
 inode
Message-ID: <20130129022753.GA15654@liubo.jp.oracle.com>
Reply-To: bo.li.liu@oracle.com
References: <1359371042-5553-1-git-send-email-bo.li.liu@oracle.com>
 <CAKcLGm8KLvJK-QjKowAq64Z=9g6B=_KkUpVKUWsRd_XdmLPfNQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CAKcLGm8KLvJK-QjKowAq64Z=9g6B=_KkUpVKUWsRd_XdmLPfNQ@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Jan 28, 2013 at 06:48:24PM -0600, Mitch Harder wrote:
> On Mon, Jan 28, 2013 at 5:04 AM, Liu Bo <bo.li.liu@oracle.com> wrote:
> > While running snapshot testscript created by Mitch and David,
> > the race between autodefrag and snapshot deletion can lead to
> > corruption of dead_root list so that we can get crash on
> > btrfs_clean_old_snapshots().
> >
> > And besides autodefrag, scrub also do the same thing, ie. read
> > root first and get inode.
> >
> > Here is the story(take autodefrag as an example):
> > (1) when we delete a snapshot or subvolume, it will set its root's
> > refs to zero and do a iput() on its own inode, and if this inode happens
> > to be the only active in-meory one in root's inode rbtree, it will add
> > itself to the global dead_roots list for later cleanup.
> >
> > (2) after (1), the autodefrag thread may read another inode for defrag
> > and the inode is just in the deleted snapshot/subvolume, but all of these
> > are without checking if the root is still valid(refs > 0).  So the end up
> > result is adding the deleted snapshot/subvolume's root to the global
> > dead_roots list AGAIN.
> >
> > Fortunately, we already have a srcu lock to avoid the race, ie. subvol_srcu.
> >
> > So all we need to do is to take the lock to protect 'read root and get inode',
> > since we synchronize to wait for the rcu grace period before adding something
> > to the global dead_roots list.
> >
> > Reported-by: Mitch Harder <mitch.harder@sabayonlinux.org>
> > Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
> 
> I'm still seeing seeing issues with duplications in the dead_roots list.

Hah, don't worry, surely this will happen, since I don't yet send you and
the ML the updated snapshot-aware defrag patch with srcu protection, it'll
be a V6 version ;)

Thanks for debugging and testing it, Mitch!

thanks,
liubo

> 
> I'm using a 3.7.4 kernel merged with the for-linus branch with the
> following four patches:
> [PATCH V5] Btrfs: snapshot-aware defrag
> [PATCH] Btrfs: List Debugging for cleaning deleted
>      Non-functional patch to issue some trace_printk debugging.
> [PATCH] [RFC] Btrfs: Check for duplicate dead root list
>      This is the patch discussed in the snapshot-aware defrag thread.
>      It checks for duplicate list entries, and dumps a backtrace
>      if it finds one.
> Btrfs: fix race between snapshot deletion and getting inode
> 
> I've run into several backtraces similar to the following:
> 
> [ 3129.368196] btrfs: Duplicate dead root entry.
> [ 3129.368199] ------------[ cut here ]------------
> [ 3129.368220] WARNING: at fs/btrfs/transaction.c:893
> btrfs_add_dead_root+0x73/0xbc [btrfs]()
> [ 3129.368223] Hardware name: OptiPlex 745
> [ 3129.368224] Modules linked in: ipv6 snd_hda_codec_analog
> snd_hda_intel snd_hda_codec snd_hwdep snd_pcm snd_page_alloc iTCO_wdt
> ppdev iTCO_vendor_support i2c_i801 parport_pc floppy tg3 sr_mod
> microcode snd_timer snd lpc_ich serio_raw pcspkr parport ablk_helper
> cryptd lrw xts gf128mul aes_x86_64 sha256_generic fuse xfs nfs lockd
> sunrpc reiserfs btrfs zlib_deflate ext4 jbd2 ext3 jbd ext2 mbcache
> sl811_hcd hid_generic xhci_hcd ohci_hcd uhci_hcd ehci_hcd
> [ 3129.368268] Pid: 4309, comm: btrfs-endio-wri Tainted: G        W
> 3.7.4-sad-v2+ #1
> [ 3129.368271] Call Trace:
> [ 3129.368278]  [<ffffffff81030586>] warn_slowpath_common+0x83/0x9b
> [ 3129.368282]  [<ffffffff810305b8>] warn_slowpath_null+0x1a/0x1c
> [ 3129.368297]  [<ffffffffa0179e0b>] btrfs_add_dead_root+0x73/0xbc [btrfs]
> [ 3129.368313]  [<ffffffffa0187bef>] btrfs_destroy_inode+0x227/0x25b [btrfs]
> [ 3129.368319]  [<ffffffff8111393a>] destroy_inode+0x3b/0x54
> [ 3129.368322]  [<ffffffff81113a9c>] evict+0x149/0x151
> [ 3129.368327]  [<ffffffff81114322>] iput+0x12c/0x135
> [ 3129.368342]  [<ffffffffa01845e7>] relink_extent_backref+0x669/0x6af [btrfs]
> [ 3129.368346]  [<ffffffff815e9849>] ? __slab_free+0x17c/0x21b
> [ 3129.368362]  [<ffffffffa017c33d>] ? record_extent_backrefs+0xa3/0xa3 [btrfs]
> [ 3129.368377]  [<ffffffffa0184d9d>] ?
> btrfs_finish_ordered_io+0x770/0x827 [btrfs]
> [ 3129.368393]  [<ffffffffa0184d6d>] btrfs_finish_ordered_io+0x740/0x827 [btrfs]
> [ 3129.368409]  [<ffffffffa0184e69>] finish_ordered_fn+0x15/0x17 [btrfs]
> [ 3129.368424]  [<ffffffffa019e7fd>] worker_loop+0x14c/0x493 [btrfs]
> [ 3129.368439]  [<ffffffffa019e6b1>] ? btrfs_queue_worker+0x258/0x258 [btrfs]
> [ 3129.368443]  [<ffffffff8104c750>] kthread+0xba/0xc2
> [ 3129.368447]  [<ffffffff8104c696>] ? kthread_freezable_should_stop+0x52/0x52
> [ 3129.368451]  [<ffffffff815f301c>] ret_from_fork+0x7c/0xb0
> [ 3129.368455]  [<ffffffff8104c696>] ? kthread_freezable_should_stop+0x52/0x52
> [ 3129.368458] ---[ end trace 46705ba72c45db88 ]---
