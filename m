Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wi0-f176.google.com ([209.85.212.176]:35616 "EHLO
	mail-wi0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752666AbbIMPe4 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 13 Sep 2015 11:34:56 -0400
Date: Sun, 13 Sep 2015 18:34:37 +0000
From: Alexandru Moise <00moses.alexander00@gmail.com>
To: Holger =?iso-8859-1?Q?Hoffst=E4tte?=
	<holger.hoffstaette@googlemail.com>
Cc: clm@fb.com, jbacik@fb.com, dsterba@suse.com, linux-btrfs@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] btrfs: avoid passing int param to start_transaction
 which takes u64
Message-ID: <20150913183437.GA24975@gmail.com>
References: <20150913142941.GA7154@gmail.com>
 <pan.2015.09.13.14.53.14@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
In-Reply-To: <pan.2015.09.13.14.53.14@googlemail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, Sep 13, 2015 at 02:53:14PM +0000, Holger Hoffstätte wrote:
> On Sun, 13 Sep 2015 14:29:41 +0000, Alexandru Moise wrote:
> 
> > Signed-off-by: Alexandru Moise <00moses.alexander00@gmail.com>
> > ---
> >  fs/btrfs/transaction.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
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
> >  {
> >  	return start_transaction(root, num_items, TRANS_START,
> >  				 BTRFS_RESERVE_FLUSH_ALL);
> 
> So I tried to build this..you won't believe what happened next:
> 
>   CC [M]  fs/btrfs/transaction.o
> fs/btrfs/transaction.c:570:28: error: conflicting types for 'btrfs_start_transaction'
>  struct btrfs_trans_handle *btrfs_start_transaction(struct btrfs_root *root,
>                             ^
> In file included from fs/btrfs/transaction.c:28:0:
> fs/btrfs/transaction.h:186:28: note: previous declaration of 'btrfs_start_transaction' was here
>  struct btrfs_trans_handle *btrfs_start_transaction(struct btrfs_root *root,
>                             ^
> scripts/Makefile.build:258: recipe for target 'fs/btrfs/transaction.o' failed
> 
> You need to update transaction.h as well.

The heck? I pulled from linus' tree earlier today and it built, I'll check again.
Thanks for telling me.
