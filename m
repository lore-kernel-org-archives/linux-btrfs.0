Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:44383 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752481AbeDQRkq (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 17 Apr 2018 13:40:46 -0400
Date: Tue, 17 Apr 2018 19:38:14 +0200
From: David Sterba <dsterba@suse.cz>
To: Anand Jain <anand.jain@oracle.com>
Cc: David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 08/16] btrfs: add sanity check when resuming balance
 after mount
Message-ID: <20180417173814.GI21272@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <cover.1522780026.git.dsterba@suse.com>
 <a5729260c2f8b50912bf975b30081ab1dbd8c8fd.1522780026.git.dsterba@suse.com>
 <a73c5c71-d64d-8399-cc42-a587a4700253@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <a73c5c71-d64d-8399-cc42-a587a4700253@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Apr 16, 2018 at 02:10:08PM +0800, Anand Jain wrote:
> 
> 
> On 04/04/2018 02:34 AM, David Sterba wrote:
> > Replace a WARN_ON with a proper check and message in case something goes
> > really wrong and resumed balance cannot set up its exclusive status.
> 
> > The check is a user friendly assertion, I don't expect to ever happen
> > under normal circumstances.
> > 
> > Also document that the paused balance starts here and owns the exclusive
> > op status.
> 
> 
> > Signed-off-by: David Sterba <dsterba@suse.com>
> > ---
> >   fs/btrfs/volumes.c | 16 ++++++++++++++--
> >   1 file changed, 14 insertions(+), 2 deletions(-)
> > 
> > diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
> > index eb78c1d0ce2b..843982a2cbdb 100644
> > --- a/fs/btrfs/volumes.c
> > +++ b/fs/btrfs/volumes.c
> > @@ -3982,6 +3982,20 @@ int btrfs_recover_balance(struct btrfs_fs_info *fs_info)
> >   	struct btrfs_key key;
> >   	int ret;
> >   
> > +	/*
> > +	 * This should never happen, as the paused balance state is recovered
> > +	 * during mount without any chance of other exclusive ops to collide.
> > +	 * Let it fail early and do not continue mount.
> > +	 *
> > +	 * Otherwise, this gives the exclusive op status to balance and keeps
> > +	 * in paused state until user intervention (cancel or umount).
> > +	 */
> > +	if (test_and_set_bit(BTRFS_FS_EXCL_OP, &fs_info->flags)) {
> > +		btrfs_err(fs_info,
> > +			"cannot set exclusive op status to resume balance");
> > +		return -EINVAL;
> > +	}
> >
> 
>   We need the test_and_set_bit(BTRFS_FS_EXCL_OP) only if we confirm that
>   there is a pending balance. Its better to test and set at the same
>   place as WARN_ON before.

Right.  And the patch is wrong, because we need to set up
fs_info::balance_ctl in all cases, otherwise unpausing balance would not
work as expected. The only change should be a better message and maybe
not even that, as it's just preparing the state but the exclusive op is
claimed later in btrfs_resume_balance_async.

I'll revisit how the error handling is done after resuming balance or
dev-replace, this is considered a hard failure (mount, rw remount) but I
don't think it's necessary.
