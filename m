Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wi0-f172.google.com ([209.85.212.172]:33453 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751184AbbIGNrF (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 7 Sep 2015 09:47:05 -0400
Date: Mon, 7 Sep 2015 16:44:16 +0300
From: Alexandru Moise <00moses.alexander00@gmail.com>
To: David Sterba <dsterba@suse.cz>
Cc: clm@fb.com, jbacik@fb.com, linux-btrfs@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] btrfs: memset cur_trans->delayed_refs to zero
Message-ID: <20150907134416.GA19489@gmail.com>
References: <20150906122527.GA21685@gmail.com>
 <20150907122419.GT11834@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20150907122419.GT11834@suse.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Sep 07, 2015 at 02:24:20PM +0200, David Sterba wrote:
> On Sun, Sep 06, 2015 at 12:25:27PM +0000, Alexandru Moise wrote:
> > Use memset() to null out the btrfs_delayed_ref_root of
> > btrfs_transaction instead of setting all the members to 0 by hand.
> > 
> > Signed-off-by: Alexandru Moise <00moses.alexander00@gmail.com>
> > ---
> >  fs/btrfs/transaction.c | 10 +---------
> >  1 file changed, 1 insertion(+), 9 deletions(-)
> > 
> > diff --git a/fs/btrfs/transaction.c b/fs/btrfs/transaction.c
> > index 8f259b3..faccc1b 100644
> > --- a/fs/btrfs/transaction.c
> > +++ b/fs/btrfs/transaction.c
> > @@ -224,15 +224,7 @@ loop:
> >  	cur_trans->start_time = get_seconds();
> >  	cur_trans->dirty_bg_run = 0;
> >  
> > -	cur_trans->delayed_refs.href_root = RB_ROOT;
> > -	cur_trans->delayed_refs.dirty_extent_root = RB_ROOT;
> > -	atomic_set(&cur_trans->delayed_refs.num_entries, 0);
> 
> Please keep these. Even if it means duplicated setting to 0, it's using
> the correct constructor, should it ever change (RB_ROOT) or does some
> extra work (atomic_set).

Sure, I'll send off another patch right away.
