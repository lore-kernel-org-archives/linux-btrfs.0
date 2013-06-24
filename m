Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from dkim2.fusionio.com ([66.114.96.54]:46684 "EHLO
	dkim2.fusionio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750902Ab3FXQYE (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 24 Jun 2013 12:24:04 -0400
Received: from mx1.fusionio.com (unknown [10.101.1.160])
	by dkim2.fusionio.com (Postfix) with ESMTP id 4F9509A03ED
	for <linux-btrfs@vger.kernel.org>; Mon, 24 Jun 2013 10:24:04 -0600 (MDT)
Date: Mon, 24 Jun 2013 12:24:01 -0400
From: Josef Bacik <jbacik@fusionio.com>
To: Alex Lyakas <alex.btrfs@zadarastorage.com>
CC: Josef Bacik <jbacik@fusionio.com>, <bo.li.liu@oracle.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: question about transaction-abort-related commits
Message-ID: <20130624162401.GJ4288@localhost.localdomain>
References: <CAOcd+r1=aZ-jBcTxgmxU5BiFGCG_10c_vouK6OE=wmG6o8++3g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <CAOcd+r1=aZ-jBcTxgmxU5BiFGCG_10c_vouK6OE=wmG6o8++3g@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, Jun 23, 2013 at 09:52:14PM +0300, Alex Lyakas wrote:
> Hello Josef, Liu,
> I am reviewing commits in the mainline tree:
> 
> e4a2bcaca9643e7430207810653222fc5187f2be Btrfs: if we aren't
> committing just end the transaction if we error out
> (call end_transaction() instead of goto cleanup_transaction) - Josef
> 
> f094ac32aba3a51c00e970a2ea029339af2ca048 Btrfs: fix NULL pointer after
> aborting a transaction
> (wait until all writers detach, before setting running_transaction to
> NULL) - Liu
> 
> 66b6135b7cf741f6f44ba938b27583ea3b83bd12 Btrfs: avoid deadlock on
> transaction waiting list
> (check if transaction was already removed from the transactions list) - Liu
> 
> Josef, according to your fix, if the committer encounters a problem
> early, it just doesn't commit. Instead it aborts the transaction
> (possibly setting FS to read-only) and detaches from the transaction.
> So if this was the only committer (e.g., the transaction_kthread),
> then transaction commit will not happen at all. Is this what you
> intended? So then the user will notice that FS went read-only, and she
> will unmount the FS, and transaction will be cleaned up in
> btrfs_error_commit_super()=>btrfs_cleanup_transaction(), and not in
> cleanup_transaction() via btrfs_commit_transaction(). Is my
> understanding correct?
> 
> Liu, it looks like after having Josef's fix, the above two commits of
> yours are not strictly needed, right? Because Josef's fix ensures that
> only the "real" committer will call cleanup_transaction(), so at this
> point there is only one writer attached to the transaction, which is
> the committer itself (your fixes doesn't hurt though). Is that
> correct?
> 

I've looked at the patches and I'm going to say yes with the caveat that I
stopped thinking about it when my head started hurting :).  Thanks,

Josef
