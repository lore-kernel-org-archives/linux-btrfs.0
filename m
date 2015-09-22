Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wi0-f172.google.com ([209.85.212.172]:34415 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933532AbbIVNfu (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 22 Sep 2015 09:35:50 -0400
Date: Tue, 22 Sep 2015 16:33:07 +0300
From: Alexandru Moise <00moses.alexander00@gmail.com>
To: David Sterba <dsterba@suse.cz>
Cc: clm@fb.com, jbacik@fb.com, linux-btrfs@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] btrfs: avoid passing int param to start_transaction
 which takes u64
Message-ID: <20150922133307.GA2369@gmail.com>
References: <20150913184720.GA25846@gmail.com>
 <20150922130933.GD12815@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20150922130933.GD12815@twin.jikos.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Sep 22, 2015 at 03:09:33PM +0200, David Sterba wrote:
> On Sun, Sep 13, 2015 at 06:47:20PM +0000, Alexandru Moise wrote:
> > Signed-off-by: Alexandru Moise <00moses.alexander00@gmail.com>
> > ---
> > v2: Forgot to add transaction.h when I made the commit, many thanks
> > Holger for pointing it out.
> > 
> >  fs/btrfs/transaction.c | 2 +-
> >  fs/btrfs/transaction.h | 2 +-
> >  2 files changed, 2 insertions(+), 2 deletions(-)
> > 
> > diff --git a/fs/btrfs/transaction.c b/fs/btrfs/transaction.c
> > index 8f259b3..8a83acd 100644
> > --- a/fs/btrfs/transaction.c
> > +++ b/fs/btrfs/transaction.c
> > @@ -570,7 +570,7 @@ reserve_fail:
> >  }
> >  
> >  struct btrfs_trans_handle *btrfs_start_transaction(struct btrfs_root *root,
> > -						   int num_items)
> > +						   u64 num_items)
> 
> I think it's better to do it the other way around, ie. let all the
> equivalents of 'num_items' be an int. We know that this is a small
> number, using u64 for that is an overkill. As the number is always
> positive, please make it 'unsigned'.

So you'd want it to be "unsigned int" or "u32"?
