Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pl0-f65.google.com ([209.85.160.65]:42336 "EHLO
        mail-pl0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S965541AbeE2TRp (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 29 May 2018 15:17:45 -0400
Received: by mail-pl0-f65.google.com with SMTP id u6-v6so9516613pls.9
        for <linux-btrfs@vger.kernel.org>; Tue, 29 May 2018 12:17:45 -0700 (PDT)
Date: Tue, 29 May 2018 12:17:42 -0700
From: Omar Sandoval <osandov@osandov.com>
To: dsterba@suse.cz, Josef Bacik <josef@toxicpanda.com>,
        linux-btrfs@vger.kernel.org, kernel-team@fb.com,
        Josef Bacik <jbacik@fb.com>
Subject: Re: [PATCH 1/2] btrfs: kill btrfs_write_inode
Message-ID: <20180529191742.GC23487@vader>
References: <20180522174723.13620-1-josef@toxicpanda.com>
 <20180528165759.GH6649@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20180528165759.GH6649@twin.jikos.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, May 28, 2018 at 06:57:59PM +0200, David Sterba wrote:
> On Tue, May 22, 2018 at 01:47:22PM -0400, Josef Bacik wrote:
> > From: Josef Bacik <jbacik@fb.com>
> > 
> > We don't actually need this.  It used to be in place for O_SYNC writes,
> > but we've used the normal fsync() path for that for years now.  The
> > other case we hit this is through sync(), which will commit the
> > transaction anyway.  All this does is make us commit the transaction a
> > bunch for no reason, and it could deadlock with delayed iput's.
> 
> In what way does it deadlock with delayed iput?

Here's an example stack trace:

[  +0.005066]  __schedule+0x38e/0x8c0
[  +0.007144]  schedule+0x36/0x80
[  +0.006447]  bit_wait+0x11/0x60
[  +0.006446]  __wait_on_bit+0xbe/0x110
[  +0.007487]  ? bit_wait_io+0x60/0x60
[  +0.007319]  __inode_wait_for_writeback+0x96/0xc0
[  +0.009568]  ? autoremove_wake_function+0x40/0x40
[  +0.009565]  inode_wait_for_writeback+0x21/0x30
[  +0.009224]  evict+0xb0/0x190
[  +0.006099]  iput+0x1a8/0x210
[  +0.006103]  btrfs_run_delayed_iputs+0x73/0xc0
[  +0.009047]  btrfs_commit_transaction+0x799/0x8c0
[  +0.009567]  btrfs_write_inode+0x81/0xb0
[  +0.008008]  __writeback_single_inode+0x267/0x320
[  +0.009569]  writeback_sb_inodes+0x25b/0x4e0
[  +0.008702]  wb_writeback+0x102/0x2d0
[  +0.007487]  wb_workfn+0xa4/0x310
[  +0.006794]  ? wb_workfn+0xa4/0x310
[  +0.007143]  process_one_work+0x150/0x410
[  +0.008179]  worker_thread+0x6d/0x520
[  +0.007490]  kthread+0x12c/0x160
[  +0.006620]  ? put_pwq_unlocked+0x80/0x80
[  +0.008185]  ? kthread_park+0xa0/0xa0
[  +0.007484]  ? do_syscall_64+0x53/0x150
[  +0.007837]  ret_from_fork+0x29/0x40

So writeback calls btrfs_write_inode(), which calls
btrfs_commit_transaction(), which calls btrfs_run_delayed_iputs(), which
calls iput() on the inode currently in btrfs_write_inode(), which calls
evict(), which waits for writeback on that same inode.
