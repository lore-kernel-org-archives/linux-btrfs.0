Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.fusionio.com ([66.114.96.31]:40165 "EHLO mx2.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754322Ab2H0W3Z (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 27 Aug 2012 18:29:25 -0400
Date: Mon, 27 Aug 2012 18:29:22 -0400
From: Josef Bacik <jbacik@fusionio.com>
To: Sage Weil <sage@inktank.com>
CC: Josef Bacik <JBacik@fusionio.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH] Btrfs: pass lockdep rwsem metadata to async commit
 transaction
Message-ID: <20120827222922.GA3310@localhost.localdomain>
References: <alpine.DEB.2.00.1208241439490.26910@cobra.newdream.net>
 <alpine.DEB.2.00.1208241545040.26910@cobra.newdream.net>
 <20120826211349.GA2305@localhost.localdomain>
 <alpine.DEB.2.00.1208271446580.26910@cobra.newdream.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <alpine.DEB.2.00.1208271446580.26910@cobra.newdream.net>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Aug 27, 2012 at 04:05:37PM -0600, Sage Weil wrote:
> On Sun, 26 Aug 2012, Josef Bacik wrote:
> > On Fri, Aug 24, 2012 at 04:47:56PM -0600, Sage Weil wrote:
> > > Sadly, now I hit another one:
> > >
> > 
> > Oh haha you need to set current->journal_info to the trans you have before you
> > call commit_transaction in do_async_commit.  Thanks,
> 
> Ah, makes sense.  But now...
>

Um so I don't think we need to be holding cleanup_work_sem() in
run_delayed_iputs(), it's meant to protect the running of the orphan cleanup.
So just remove it in btrfs_run_delayed_iputs() and see how that goes?  Thanks,

Josef
