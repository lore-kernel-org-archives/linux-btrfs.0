Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qt0-f195.google.com ([209.85.216.195]:35798 "EHLO
        mail-qt0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727404AbeHaSOw (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 31 Aug 2018 14:14:52 -0400
Received: by mail-qt0-f195.google.com with SMTP id j7-v6so14651142qtp.2
        for <linux-btrfs@vger.kernel.org>; Fri, 31 Aug 2018 07:07:12 -0700 (PDT)
Date: Fri, 31 Aug 2018 10:07:10 -0400
From: Josef Bacik <josef@toxicpanda.com>
To: Nikolay Borisov <nborisov@suse.com>
Cc: Josef Bacik <josef@toxicpanda.com>, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 30/35] btrfs: cleanup pending bgs on transaction abort
Message-ID: <20180831140709.x34o45kag22xlioy@destiny>
References: <20180830174225.2200-1-josef@toxicpanda.com>
 <20180830174225.2200-31-josef@toxicpanda.com>
 <265df94d-e5e9-5476-1e7b-f4058b6180e6@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <265df94d-e5e9-5476-1e7b-f4058b6180e6@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Aug 31, 2018 at 10:48:58AM +0300, Nikolay Borisov wrote:
> 
> 
> On 30.08.2018 20:42, Josef Bacik wrote:
> > We may abort the transaction during a commit and not have a chance to
> > run the pending bgs stuff, which will leave block groups on our list and
> > cause us accounting issues and leaked memory.  Fix this by running the
> > pending bgs when we cleanup a transaction.
> > 
> > Signed-off-by: Josef Bacik <josef@toxicpanda.com>
> > ---
> >  fs/btrfs/transaction.c | 1 +
> >  1 file changed, 1 insertion(+)
> > 
> > diff --git a/fs/btrfs/transaction.c b/fs/btrfs/transaction.c
> > index 89d14f135837..0f39a0d302d3 100644
> > --- a/fs/btrfs/transaction.c
> > +++ b/fs/btrfs/transaction.c
> > @@ -2273,6 +2273,7 @@ int btrfs_commit_transaction(struct btrfs_trans_handle *trans)
> >  	btrfs_scrub_continue(fs_info);
> >  cleanup_transaction:
> >  	btrfs_trans_release_metadata(trans);
> > +	btrfs_create_pending_block_groups(trans);
> 
> And now you've basically hi-jacked btrfs_create_pending_block_groups to
> just act as "delete all bg" in case transaction is aborted. Considering
> this and the previous patch I'd rather you replace them with a single
> one which introduces a new function delete_pending_bgs or whatever and
> use that. This will be more explicit and self-documenting.
> 

I haven't hi-jacked it and I'm not adding another helper when we already have
code that does the right thing.  Remember if we abort a transaction in a path
that doesn't commit we still end up calling btrfs_create_pending_block_groups()
in btrfs_end_transaction which does the cleanup there, I'm not adding a bunch of
new code for a case that's easily handled with the previous fix and works the
same way in other paths.  Thanks,

Josef
