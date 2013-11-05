Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:38745 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750732Ab3KEDTV (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 4 Nov 2013 22:19:21 -0500
Date: Tue, 5 Nov 2013 11:19:09 +0800
From: Liu Bo <bo.li.liu@oracle.com>
To: Miao Xie <miaox@cn.fujitsu.com>, majianpeng <majianpeng@gmail.com>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: [BUG]:bad unlock balance detected!
Message-ID: <20131105031908.GB15974@localhost.localdomain>
Reply-To: bo.li.liu@oracle.com
References: <201311050933582618320@gmail.com>
 <20131105021216.GA15974@localhost.localdomain>
 <52785873.6050106@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <52785873.6050106@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Nov 05, 2013 at 10:31:15AM +0800, Miao Xie wrote:
> On 	tue, 5 Nov 2013 10:12:17 +0800, Liu Bo wrote:
> > Hi,
> > 
> > Would you please try the following patch?
> > 
> > -liubo
> > 
> > From: Liu Bo <bo.li.liu@oracle.com>
> > Subject: [PATCH] Btrfs: fix to use the right trans for async commit
> > 
> > @trans has been freed and is undefined, and we should use the trans
> > handle created for async commit instead.
> > 
> > Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
> > ---
> >  fs/btrfs/transaction.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> > 
> > diff --git a/fs/btrfs/transaction.c b/fs/btrfs/transaction.c
> > index 8c81bdc..648d839 100644
> > --- a/fs/btrfs/transaction.c
> > +++ b/fs/btrfs/transaction.c
> > @@ -1494,7 +1494,7 @@ int btrfs_commit_transaction_async(struct
> > btrfs_trans_handle *trans,
> >  	 * Tell lockdep we've released the freeze rwsem, since the
> >  	 * async commit thread will be the one to unlock it.
> >  	 */
> > -	if (trans->type < TRANS_JOIN_NOLOCK)
> > +	if (ac->newtrans->type < TRANS_JOIN_NOLOCK)
> 
> It should be:
> 
> if (trans->type & __TRANS_FREEZABLE)
> 
> The same for
> 
> do_async_commit()

Make sense, I missed that we've grabbed a reference on trans.

Ma,

Sorry for the previous noise, but could you please try the following one instead?

-liubo

diff --git a/fs/btrfs/transaction.c b/fs/btrfs/transaction.c
index 8c81bdc..c094f08 100644
--- a/fs/btrfs/transaction.c
+++ b/fs/btrfs/transaction.c
@@ -1453,7 +1453,7 @@ static void do_async_commit(struct work_struct
*work)
 	 * We've got freeze protection passed with the transaction.
 	 * Tell lockdep about it.
 	 */
-	if (ac->newtrans->type < TRANS_JOIN_NOLOCK)
+	if (ac->newtrans->type & __TRANS_FREEZABLE)
 		rwsem_acquire_read(
 		     &ac->root->fs_info->sb->s_writers.lock_map[SB_FREEZE_FS-1],
 		     0, 1, _THIS_IP_);
@@ -1494,7 +1494,7 @@ int btrfs_commit_transaction_async(struct
btrfs_trans_handle *trans,
 	 * Tell lockdep we've released the freeze rwsem, since the
 	 * async commit thread will be the one to unlock it.
 	 */
-	if (trans->type < TRANS_JOIN_NOLOCK)
+	if (ac->newtrans->type & __TRANS_FREEZABLE)
 		rwsem_release(
 			&root->fs_info->sb->s_writers.lock_map[SB_FREEZE_FS-1],
 			1, _THIS_IP_);


