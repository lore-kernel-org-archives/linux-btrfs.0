Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:47445 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753239AbeDQNgh (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 17 Apr 2018 09:36:37 -0400
Date: Tue, 17 Apr 2018 15:34:04 +0200
From: David Sterba <dsterba@suse.cz>
To: Liu Bo <bo.liu@linux.alibaba.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] Btrfs: clean up resources during umount after trans is
 aborted
Message-ID: <20180417133404.GD21272@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1522447918-19147-2-git-send-email-bo.liu@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1522447918-19147-2-git-send-email-bo.liu@linux.alibaba.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, Mar 31, 2018 at 06:11:56AM +0800, Liu Bo wrote:
> Currently if some fatal errors occur, like all IO get -EIO, resources
> would be cleaned up when
> a) transaction is being committed or
> b) BTRFS_FS_STATE_ERROR is set
> 
> However, in some rare cases, resources may be left alone after transaction
> gets aborted and umount may run into some ASSERT(), e.g.
> ASSERT(list_empty(&block_group->dirty_list));
> 
> For case a), in btrfs_commit_transaciton(), there're several places at the
> beginning where we just call btrfs_end_transaction() without cleaning up
> resources.  For case b), it is possible that the trans handle doesn't have
> any dirty stuff, then only trans hanlde is marked as aborted while
> BTRFS_FS_STATE_ERROR is not set, so resources remain in memory.

I have some doubts here. The flag BTRFS_FS_STATE_TRANS_ABORTED was added
to avoid duplicate warnings when the transaction is aborted for the
first time. And nothing else.

BTRFS_FS_STATE_ERROR should track the overall state and is checked in
several places if a post-error cleanup is necessary.

Calling abort should set BTRFS_FS_STATE_ERROR immediatelly so any caller
up the callchaing can potentially cleanup.

> This makes btrfs also check BTRFS_FS_STATE_TRANS_ABORTED to make sure that
> all resources won't stay in memory after umount.

The question is why BTRFS_FS_STATE_ERROR is not set but we still got
here and the filesystem is in an error state.

You're not specific about the rare cases where the resources are left
after abort and the umount is about to start. I think the rare cases
need to be identified and understood otherwise this seems like papering
over the problem.
