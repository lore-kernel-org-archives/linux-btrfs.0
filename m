Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qk1-f193.google.com ([209.85.222.193]:41584 "EHLO
        mail-qk1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727404AbeHaSNU (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 31 Aug 2018 14:13:20 -0400
Received: by mail-qk1-f193.google.com with SMTP id h138-v6so1447280qke.8
        for <linux-btrfs@vger.kernel.org>; Fri, 31 Aug 2018 07:05:41 -0700 (PDT)
Date: Fri, 31 Aug 2018 10:05:38 -0400
From: Josef Bacik <josef@toxicpanda.com>
To: Nikolay Borisov <nborisov@suse.com>
Cc: Josef Bacik <josef@toxicpanda.com>, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 29/35] btrfs: just delete pending bgs if we are aborted
Message-ID: <20180831140537.iwlf6oaapqit6kmf@destiny>
References: <20180830174225.2200-1-josef@toxicpanda.com>
 <20180830174225.2200-30-josef@toxicpanda.com>
 <8d7a8f25-285d-e98e-9094-fe16ed62ab78@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <8d7a8f25-285d-e98e-9094-fe16ed62ab78@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Aug 31, 2018 at 10:46:36AM +0300, Nikolay Borisov wrote:
> 
> 
> On 30.08.2018 20:42, Josef Bacik wrote:
> > We still need to do all of the accounting cleanup for pending block
> > groups if we abort.  So set the ret to trans->aborted so if we aborted
> > the cleanup happens and everybody is happy.
> > 
> > Signed-off-by: Josef Bacik <josef@toxicpanda.com>
> > ---
> >  fs/btrfs/extent-tree.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> > 
> > diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
> > index 90f267f4dd0f..132a1157982c 100644
> > --- a/fs/btrfs/extent-tree.c
> > +++ b/fs/btrfs/extent-tree.c
> > @@ -10333,7 +10333,7 @@ void btrfs_create_pending_block_groups(struct btrfs_trans_handle *trans)
> >  	struct btrfs_root *extent_root = fs_info->extent_root;
> >  	struct btrfs_block_group_item item;
> >  	struct btrfs_key key;
> > -	int ret = 0;
> > +	int ret = trans->aborted;
> 
> This is really subtle and magical and not obvious from the context of
> the patch, but if the transaction is aborted this will change the loop
> to actually just delete all block groups in ->new_bgs. I'd rather have
> an explicit loop for that honestly.

We need it this way in case creating the bg's errors out anyway, there's no
sense in adding a bunch of code to do something we have to handle already
anyway.  Thanks,

Josef
