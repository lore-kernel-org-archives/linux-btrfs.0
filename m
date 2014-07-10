Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail3-relais-sop.national.inria.fr ([192.134.164.104]:14583
	"EHLO mail3-relais-sop.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751128AbaGJF4v (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 10 Jul 2014 01:56:51 -0400
Date: Thu, 10 Jul 2014 07:56:47 +0200 (CEST)
From: Julia Lawall <julia.lawall@lip6.fr>
To: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>
cc: Himangi Saraogi <himangi774@gmail.com>, Chris Mason <clm@fb.com>,
        Josef Bacik <jbacik@fb.com>, linux-btrfs@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Btrfs: use BUG_ON
In-Reply-To: <53BDD8B5.2040609@jp.fujitsu.com>
Message-ID: <alpine.DEB.2.02.1407100747350.2187@localhost6.localdomain6>
References: <20140708222141.GA11854@himangi-Dell> <53BDD8B5.2040609@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On Thu, 10 Jul 2014, Satoru Takeuchi wrote:

> Hi Himangi,
> 
> (2014/07/09 7:21), Himangi Saraogi wrote:
> > Use BUG_ON(x) rather than if(x) BUG();
> > 
> > The semantic patch that fixes this problem is as follows:
> > 
> > // <smpl>
> > @@ identifier x; @@
> > -if (x) BUG();
> > +BUG_ON(x);
> > // </smpl>
> 
> Strictly speaking, BUG_ON() is "if (unlikely(x)) BUG".
> Anyway, I consider that put this condition in unlikely()
> in this case is good.
> 
> BTW, there are many "if BUG()" case under fs/btrfs.
> How about fix all of them?
> 
> ===============================================================================
> $ grep -rnH -B 1 "BUG()" fs/btrfs | grep -A 1 'if.*('
> fs/btrfs/inode.c-6318-		} else if (create && PageUptodate(page)) {

In the past, BUG_ON (and BUG) could have a definition that would just do 
nothing.  In that case, the call to PageUptodate would go away.  The 
function may do a read barrier, so that could be undesirable.

But now I don't see any definition of BUG_ON that discards the condition.  
So Himangi, you can discard the requirement that the tested expression be 
an identifier in the semantic patch, and just allow any expression:

-if(e) BUG();
+BUG_ON(e);

julia

> fs/btrfs/inode.c:6319:			BUG();
> --
> fs/btrfs/volumes.c-2626-			else if (ret)
> fs/btrfs/volumes.c:2627:				BUG(); # <- your patch
> fixes it.
> --
> fs/btrfs/volumes.c-3092-		if (ret == 0)
> fs/btrfs/volumes.c:3093:			BUG(); /* FIXME break ? */
> --
> fs/btrfs/raid56.c-2048-	if (rbio->faila == -1) {
> fs/btrfs/raid56.c:2049:		BUG();
> ===============================================================================
> 
> Thanks,
> Satoru
> 
> > 
> > Signed-off-by: Himangi Saraogi <himangi774@gmail.com>
> > Acked-by: Julia Lawall <julia.lawall@lip6.fr>
> > ---
> >   fs/btrfs/volumes.c | 4 ++--
> >   1 file changed, 2 insertions(+), 2 deletions(-)
> > 
> > diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
> > index 6104676..63e746e 100644
> > --- a/fs/btrfs/volumes.c
> > +++ b/fs/btrfs/volumes.c
> > @@ -2623,8 +2623,8 @@ again:
> >   						   found_key.offset);
> >   			if (ret == -ENOSPC)
> >   				failed++;
> > -			else if (ret)
> > -				BUG();
> > +			else
> > +				BUG_ON(ret);
> >   		}
> > 
> >   		if (found_key.offset == 0)
> > 
> 
> 
