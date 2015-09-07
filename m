Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wi0-f178.google.com ([209.85.212.178]:37454 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751157AbbIGO0l (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 7 Sep 2015 10:26:41 -0400
Date: Mon, 7 Sep 2015 17:23:53 +0300
From: Alexandru Moise <00moses.alexander00@gmail.com>
To: David Sterba <dsterba@suse.cz>
Cc: clm@fb.com, jbacik@fb.com, linux-btrfs@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] btrfs: memset cur_trans->delayed_refs to zero
Message-ID: <20150907142352.GA21014@gmail.com>
References: <20150907134502.GA19553@gmail.com>
 <20150907140122.GX11834@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20150907140122.GX11834@suse.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Sep 07, 2015 at 04:01:22PM +0200, David Sterba wrote:
> So, updated patches should mention that in the subject eg:
> 
> [PATCH v2] btrfs: memset cur_trans->delayed_refs to zero
> 
> On Mon, Sep 07, 2015 at 04:45:02PM +0300, Alexandru Moise wrote:
> > Use memset() to null out the btrfs_delayed_ref_root of
> > btrfs_transaction instead of setting all the members to 0 by hand.
> > 
> > Signed-off-by: Alexandru Moise <00moses.alexander00@gmail.com>
> > ---
> 
> And in this section (ie. after the first ---) put a brief description of
> the changes.
Will do.
> 
> >  fs/btrfs/transaction.c | 12 ++++++------
> >  1 file changed, 6 insertions(+), 6 deletions(-)
> > 
> > diff --git a/fs/btrfs/transaction.c b/fs/btrfs/transaction.c
> > index 8f259b3..0581fb4 100644
> > --- a/fs/btrfs/transaction.c
> > +++ b/fs/btrfs/transaction.c
> > @@ -224,15 +224,15 @@ loop:
> >  	cur_trans->start_time = get_seconds();
> >  	cur_trans->dirty_bg_run = 0;
> >  
> > +	memset(&cur_trans->delayed_refs, 0, sizeof(cur_trans->delayed_refs));
> > +
> > +	/*
> > +	 * For now RB_ROOT means set to NULL but this could change in
> > +	 * the future
> > +	 */
> 
> I don't think such comment necessary, the code is clear enough without
> it.
> 
> >  	cur_trans->delayed_refs.href_root = RB_ROOT;
> >  	cur_trans->delayed_refs.dirty_extent_root = RB_ROOT;
> 
> .
Alright I can agree to that, thanks.
