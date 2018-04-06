Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:57701 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752848AbeDFNSp (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 6 Apr 2018 09:18:45 -0400
Date: Fri, 6 Apr 2018 15:16:15 +0200
From: David Sterba <dsterba@suse.cz>
To: Liu Bo <obuil.liubo@gmail.com>
Cc: David Sterba <dsterba@suse.cz>, Liu Bo <bo.liu@linux.alibaba.com>,
        linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] Btrfs: clean up resources during umount after trans is
 aborted
Message-ID: <20180406131615.GC8557@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1522447918-19147-2-git-send-email-bo.liu@linux.alibaba.com>
 <20180405161106.GH2635@twin.jikos.cz>
 <CANQeFDD1GVHB-epwAnA8wRHbiZt4BOT+eSPRk762xw5vbfj5MQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CANQeFDD1GVHB-epwAnA8wRHbiZt4BOT+eSPRk762xw5vbfj5MQ@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Apr 05, 2018 at 11:45:55AM -0700, Liu Bo wrote:
> On Thu, Apr 5, 2018 at 9:11 AM, David Sterba <dsterba@suse.cz> wrote:
> > On Sat, Mar 31, 2018 at 06:11:56AM +0800, Liu Bo wrote:
> >> Currently if some fatal errors occur, like all IO get -EIO, resources
> >> would be cleaned up when
> >> a) transaction is being committed or
> >> b) BTRFS_FS_STATE_ERROR is set
> >>
> >> However, in some rare cases, resources may be left alone after transaction
> >> gets aborted and umount may run into some ASSERT(), e.g.
> >> ASSERT(list_empty(&block_group->dirty_list));
> >>
> >> For case a), in btrfs_commit_transaciton(), there're several places at the
> >> beginning where we just call btrfs_end_transaction() without cleaning up
> >> resources.  For case b), it is possible that the trans handle doesn't have
> >> any dirty stuff, then only trans hanlde is marked as aborted while
> >> BTRFS_FS_STATE_ERROR is not set, so resources remain in memory.
> >>
> >> This makes btrfs also check BTRFS_FS_STATE_TRANS_ABORTED to make sure that
> >> all resources won't stay in memory after umount.
> >>
> >> Signed-off-by: Liu Bo <bo.liu@linux.alibaba.com>
> >
> > Is it possible that the following stactrace could be caused by the
> > missing check? It roughly matches what you describe (ie. close_ctree and
> > unreleased resources). This is from generic/475, that does some error
> > injection:
> >
> > [16991.455178] WARNING: CPU: 6 PID: 23518 at fs/btrfs/extent-tree.c:9896 btrfs_free_block_groups+0x2c8/0x420 [btrfs]
> >
> 
> Hmm...I don't think so, while running 475, the one I got pretty stable is
> ASSERT(list_empty(&block_group->dirty_list));

There's a number of things that 475 catches so this might depend on
timing, memory, disks etc.

> And I did see this warning a few times, but I thought that was due to
> the new flag (ZERO) of fallocate for which we had fixes from Filipe,
> not sure if they've been merged?

Merged to 4.15:

* f27451f22996687 Btrfs: add support for fallocate's zero range operation
* 9f13ce743b1bd4e Btrfs: fix missing inode i_size update after zero range operation
