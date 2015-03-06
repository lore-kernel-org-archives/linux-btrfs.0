Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:48531 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752766AbbCFLnC (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Fri, 6 Mar 2015 06:43:02 -0500
Date: Fri, 6 Mar 2015 19:42:46 +0800
From: Liu Bo <bo.li.liu@oracle.com>
To: Chris Mason <clm@fb.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH V2] Btrfs: catch transaction abortion after waiting for it
Message-ID: <20150306114245.GA18885@localhost.localdomain>
Reply-To: bo.li.liu@oracle.com
References: <1425545307-3721-1-git-send-email-bo.li.liu@oracle.com>
 <1425551805-7314-1-git-send-email-bo.li.liu@oracle.com>
 <1425563997.740.0@mail.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1425563997.740.0@mail.thefacebook.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Mar 05, 2015 at 08:59:57AM -0500, Chris Mason wrote:
> 
> 
> On Thu, Mar 5, 2015 at 5:36 AM, Liu Bo <bo.li.liu@oracle.com> wrote:
> >This problem is uncovered by a test case:
> >http://patchwork.ozlabs.org/patch/244297.
> >
> >Fsync() can report success when it actually doesn't.  When we
> >have several threads running fsync() at the same tiem and in one
> >fsync() we
> >get a transaction abortion due to some problems(in the test case
> >it's disk
> >failures), and other fsync()s may return successfully which makes
> >userspace
> >programs think that data is now safely flushed into disk.
> >
> >It's because that after fsyncs() fail btrfs_sync_log() due to disk
> >failures,
> >they get to try btrfs_commit_transaction() where it finds that
> >there is
> >already a transaction being committed, and they'll just call
> >wait_for_commit()
> >and return.  Note that we actually check "trans->aborted" in
> >btrfs_end_transaction,
> >but it's likely that the error message is still not yet throwed
> >out and only after
> >wait_for_commit() we're sure whether the transaction is committed
> >successfully.
> >
> >This add the necessary check and it now passes the test.
> >
> >Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
> >---
> >v2: Use a more generic title since it's not only for fsync, but
> >for others.
> >
> > fs/btrfs/transaction.c | 3 +++
> > 1 file changed, 3 insertions(+)
> >
> >diff --git a/fs/btrfs/transaction.c b/fs/btrfs/transaction.c
> >index 7e80f32..bd7ea86 100644
> >--- a/fs/btrfs/transaction.c
> >+++ b/fs/btrfs/transaction.c
> >@@ -1814,6 +1814,9 @@ int btrfs_commit_transaction(struct
> >btrfs_trans_handle *trans,
> >
> > 		wait_for_commit(root, cur_trans);
> >
> >+		if (unlikely(ACCESS_ONCE(cur_trans->aborted)))
> >+			ret = cur_trans->aborted;
> >+
> 
> Thanks Liu, but why are we using ACCESS_ONCE here?

It should be not necessary, I just copied it from the first check in btrfs_commit_transaction(),
not insisting in using it.

Thanks,

-liubo
