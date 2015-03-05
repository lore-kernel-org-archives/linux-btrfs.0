Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:20418 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754624AbbCEKXp (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 5 Mar 2015 05:23:45 -0500
Date: Thu, 5 Mar 2015 18:23:38 +0800
From: Liu Bo <bo.li.liu@oracle.com>
To: Filipe David Manana <fdmanana@gmail.com>
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH] Btrfs: fix data loss of fsync
Message-ID: <20150305102337.GD4147@localhost.localdomain>
Reply-To: bo.li.liu@oracle.com
References: <1425545307-3721-1-git-send-email-bo.li.liu@oracle.com>
 <CAL3q7H6mx573exkLZF-8yz2EpKucrd2KCgj6Chf_Jd8SH56PfQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CAL3q7H6mx573exkLZF-8yz2EpKucrd2KCgj6Chf_Jd8SH56PfQ@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Mar 05, 2015 at 09:59:09AM +0000, Filipe David Manana wrote:
> On Thu, Mar 5, 2015 at 8:48 AM, Liu Bo <bo.li.liu@oracle.com> wrote:
> > This problem is uncovered by a test case: http://patchwork.ozlabs.org/patch/244297.
> >
> > Fsync() can report success when it actually doesn't.  When we
> > have several threads running fsync() at the same tiem and in one fsync() we
> > get a transaction abortion due to some problems(in the test case it's disk
> > failures), and other fsync()s may return successfully which makes userspace
> > programs think that data is now safely flushed into disk.
> >
> > It's because that after fsyncs() fail btrfs_sync_log() due to disk failures,
> > they get to try btrfs_commit_transaction() where it finds that there is
> > already a transaction being committed, and they'll just call wait_for_commit()
> > and return.  Note that we actually check "trans->aborted" in btrfs_end_transaction,
> > but it's likely that the error message is still not yet throwed out and only after
> > wait_for_commit() we're sure whether the transaction is committed successfully.
> >
> > This add the necessary check and it now passes the test.
> >
> > Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
> 
> The change itself is ok but the title and associating it only with
> fsync are not quite right, since this is much more generic and not
> specific to fsync.

How about "catch errors after waiting for transaction"?

I'm open to any suggestions.

Thanks,

-liubo

> 
> thanks
> 
> > ---
> >  fs/btrfs/transaction.c | 3 +++
> >  1 file changed, 3 insertions(+)
> >
> > diff --git a/fs/btrfs/transaction.c b/fs/btrfs/transaction.c
> > index 7e80f32..bd7ea86 100644
> > --- a/fs/btrfs/transaction.c
> > +++ b/fs/btrfs/transaction.c
> > @@ -1814,6 +1814,9 @@ int btrfs_commit_transaction(struct btrfs_trans_handle *trans,
> >
> >                 wait_for_commit(root, cur_trans);
> >
> > +               if (unlikely(ACCESS_ONCE(cur_trans->aborted)))
> > +                       ret = cur_trans->aborted;
> > +
> >                 btrfs_put_transaction(cur_trans);
> >
> >                 return ret;
> > --
> > 1.8.1.4
> >
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> 
> 
> -- 
> Filipe David Manana,
> 
> "Reasonable men adapt themselves to the world.
>  Unreasonable men adapt the world to themselves.
>  That's why all progress depends on unreasonable men."
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
