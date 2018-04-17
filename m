Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from out30-131.freemail.mail.aliyun.com ([115.124.30.131]:50613 "EHLO
        out30-131.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751863AbeDQRO4 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 17 Apr 2018 13:14:56 -0400
Date: Tue, 17 Apr 2018 10:14:41 -0700
From: Liu Bo <bo.liu@linux.alibaba.com>
To: dsterba@suse.cz, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] Btrfs: clean up resources during umount after trans is
 aborted
Message-ID: <20180417171440.skamknycotzydnib@US-160370MP2.local>
Reply-To: bo.liu@linux.alibaba.com
References: <1522447918-19147-2-git-send-email-bo.liu@linux.alibaba.com>
 <20180417133404.GD21272@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20180417133404.GD21272@twin.jikos.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Apr 17, 2018 at 03:34:04PM +0200, David Sterba wrote:
> On Sat, Mar 31, 2018 at 06:11:56AM +0800, Liu Bo wrote:
> > Currently if some fatal errors occur, like all IO get -EIO, resources
> > would be cleaned up when
> > a) transaction is being committed or
> > b) BTRFS_FS_STATE_ERROR is set
> > 
> > However, in some rare cases, resources may be left alone after transaction
> > gets aborted and umount may run into some ASSERT(), e.g.
> > ASSERT(list_empty(&block_group->dirty_list));
> > 
> > For case a), in btrfs_commit_transaciton(), there're several places at the
> > beginning where we just call btrfs_end_transaction() without cleaning up
> > resources.  For case b), it is possible that the trans handle doesn't have
> > any dirty stuff, then only trans hanlde is marked as aborted while
> > BTRFS_FS_STATE_ERROR is not set, so resources remain in memory.
> 
> I have some doubts here. The flag BTRFS_FS_STATE_TRANS_ABORTED was added
> to avoid duplicate warnings when the transaction is aborted for the
> first time. And nothing else.
> 
> BTRFS_FS_STATE_ERROR should track the overall state and is checked in
> several places if a post-error cleanup is necessary.
> 
> Calling abort should set BTRFS_FS_STATE_ERROR immediatelly so any caller
> up the callchaing can potentially cleanup.
> 
> > This makes btrfs also check BTRFS_FS_STATE_TRANS_ABORTED to make sure that
> > all resources won't stay in memory after umount.
> 
> The question is why BTRFS_FS_STATE_ERROR is not set but we still got
> here and the filesystem is in an error state.
> 
> You're not specific about the rare cases where the resources are left
> after abort and the umount is about to start. I think the rare cases
> need to be identified and understood otherwise this seems like papering
> over the problem.

Yes, that makes sense.

btrfs_commit_transaction()
   -> btrfs_run_delayed_refs() # the very 1st one
      -> __btrfs_run_delayed_refs() # bail out with errors e.g. -EIO, -ENOSPC
      -> btrfs_abort_transaction()
         -> # set BTRFS_FS_STATE_TRANS_ABORTED
	 -> __btrfs_abort_transaction() # !trans->dirty and no new_bgs,
	                                   then return without setting
					   BTRFS_FS_STATA_ERROR

While trans handle is aborted, cur_trans is not aborted, so that other
threads would join this @cur_trans and it's likely that they would go
thru the same process.  Eventually umount is called,

close_ctree()
   -> btrfs_commit_super()
       -> join_transaction()
       -> btrfs_commit_transaction() # bail out due to the same reason
   -> ...  # btrfs_error_commit_super is not called due to STATE_ERROR not being set.


So as we can see, if btrfs_commit_transaction() enters COMMIT phrase,
then cleanup_transaction would handle the rest well, otherwise we'd
get this.

thanks,
-liubo
