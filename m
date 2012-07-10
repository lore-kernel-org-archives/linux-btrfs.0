Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.fusionio.com ([66.114.96.30]:39274 "EHLO mx1.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751398Ab2GJTwT (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 10 Jul 2012 15:52:19 -0400
Date: Tue, 10 Jul 2012 15:52:16 -0400
From: Josef Bacik <jbacik@fusionio.com>
To: Arne Jansen <sensille@gmx.net>
CC: Josef Bacik <JBacik@fusionio.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
        "daniel@quora.org" <daniel@quora.org>,
        "Chris L. Mason" <clmason@fusionio.com>,
        "list.btrfs@jan-o-sch.net" <list.btrfs@jan-o-sch.net>
Subject: Re: [PATCH] Btrfs: allow delayed refs to be merged
Message-ID: <20120710195216.GG7529@localhost.localdomain>
References: <1341946331-18058-1-git-send-email-jbacik@fusionio.com>
 <4FFC84FE.7000302@gmx.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <4FFC84FE.7000302@gmx.net>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Jul 10, 2012 at 01:39:42PM -0600, Arne Jansen wrote:
> On 07/10/2012 08:52 PM, Josef Bacik wrote:
> > Daniel Blueman reported a bug with fio+balance on a ramdisk setup.
> > Basically what happens is the balance relocates a tree block which will drop
> > the implicit refs for all of its children and adds a full backref.  Once the
> > block is relocated we have to add the implicit refs back, so when we cow the
> > block again we add the implicit refs for its children back.  The problem
> > comes when the original drop ref doesn't get run before we add the implicit
> > refs back.  The delayed ref stuff will specifically prefer ADD operations
> > over DROP to keep us from freeing up an extent that will have references to
> > it, so we try to add the implicit ref before it is actually removed and we
> > panic.  This worked fine before because the add would have just canceled the
> > drop out and we would have been fine.  But the backref walking work needs to
> > be able to freeze the delayed ref stuff in time so we have this ever
> > increasing sequence number that gets attached to all new delayed ref updates
> > which makes us not merge refs and we run into this issue.
> >
> > So since the backref walking stuff doesn't get run all that often we just
> > ignore the sequence updates until somebody actually tries to do the freeze.
> > Then if we try to run the delayed refs we go back and try to merge them in
> > case we get a sequence like this again so we do not panic.
> 
> Subvolume quota will also use it, so it might get used _very_ often.
> Please give me some time to understand the problem deeper. This patch
> adds a lot of complexity, and I'd prefer to find a solution that adds
> none :)
> 

If you've got a better idea then go for it, but I'm coming up short.  One way or
another we need these operations to cancel out of they are both on the same ref
head at the same time.  We may be able to do something like make sure the full
backrefs are added first, then let implicit ref deletes happen, and then let
implicit ref adds happen, but then you are adding even more weird logic to what
can be run when.

The other option is to make relocate not do this dance at all, and I'm not
entirely sure how you would go about this.  I think we are ok leaving the
implicit ref because frankly the children all still belong to the original root,
but I don't understand the relocate code enough to decide if thats ok.  Thanks,

Josef
