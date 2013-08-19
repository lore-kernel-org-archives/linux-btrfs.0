Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from dkim1.fusionio.com ([66.114.96.53]:34810 "EHLO
	dkim1.fusionio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751263Ab3HSMtz (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 19 Aug 2013 08:49:55 -0400
Received: from mx2.fusionio.com (unknown [10.101.1.160])
	by dkim1.fusionio.com (Postfix) with ESMTP id 122C57C0423
	for <linux-btrfs@vger.kernel.org>; Mon, 19 Aug 2013 06:49:55 -0600 (MDT)
Date: Mon, 19 Aug 2013 08:49:52 -0400
From: Josef Bacik <jbacik@fusionio.com>
To: Miao Xie <miaox@cn.fujitsu.com>
CC: Josef Bacik <jbacik@fusionio.com>, <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH] Btrfs: fix heavy delalloc related deadlock
Message-ID: <20130819124952.GB3990@localhost.localdomain>
References: <1376494860-8864-1-git-send-email-jbacik@fusionio.com>
 <52118373.7050800@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <52118373.7050800@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Aug 19, 2013 at 10:31:15AM +0800, Miao Xie wrote:
> On wed, 14 Aug 2013 11:41:00 -0400, Josef Bacik wrote:
> > I added a patch where we started taking the ordered operations mutex when we
> > waited on ordered extents.  We need this because we splice the list and process
> > it, so if a flusher came in during this scenario it would think the list was
> > empty and we'd usually get an early ENOSPC.  The problem with this is that this
> > lock is used in transaction committing.  So we end up with something like this
> > 
> > Transaction commit
> > 	-> wait on writers
> > 
> > Delalloc flusher
> > 	-> run_ordered_operations (holds mutex)
> > 		->wait for filemap-flush to do its thing
> > 
> > flush task
> > 	-> cow_file_range
> > 		->wait on btrfs_join_transaction because we're commiting
> > 
> > some other task
> > 	-> commit_transaction because we notice trans->transaction->flush is set
> > 		-> run_ordered_operations (hang on mutex)
> 
> Sorry, I can not understand this explanation. As far as I know, if the flush task
> waits on btrfs_join_transaction(), it means the transaction is under commit
> (state = TRANS_STATE_COMMIT_DOING), and all the external writers(TRANS_START/TRANS_ATTACH/
> TRANS_USERSPACE) have quitted the current transaction, so no one would try to call
> run_ordered_operations().
> 
> Could you show us the reproduce steps?
> 

Sorry I wrote the wrong thing for the delalloc flusher, that should be

  ->btrfs_wait_ordered_extents (holds ordered operations mutex)
	-> wait for filemap-flush to do its thing

That should make it clearer.  I reproduced it running xfstests generic/224.
Thanks,

Josef
