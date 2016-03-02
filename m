Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:54728 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753108AbcCBBfA (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 1 Mar 2016 20:35:00 -0500
Date: Tue, 1 Mar 2016 20:34:41 -0500
From: Chris Mason <clm@fb.com>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
CC: <dsterba@suse.cz>, <fdmanana@kernel.org>, <linux-btrfs@vger.kernel.org>
Subject: Re: [GIT PULL] Btrfs fixes for 4.6
Message-ID: <20160302013441.vsr46nw6j5ldb2er@floor.thefacebook.com>
References: <1456492920-18169-1-git-send-email-fdmanana@kernel.org>
 <20160301092026.GX23746@twin.jikos.cz>
 <20160301160650.fjyyrnf6qfcekgr6@floor.thefacebook.com>
 <56D63846.7090204@cn.fujitsu.com>
 <20160302011147.rqgpvdebcas22j5g@floor.thefacebook.com>
 <56D640DE.7090006@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <56D640DE.7090006@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Mar 02, 2016 at 09:24:46AM +0800, Qu Wenruo wrote:
> 
> 
> Chris Mason wrote on 2016/03/01 20:11 -0500:
> >On Wed, Mar 02, 2016 at 08:48:06AM +0800, Qu Wenruo wrote:
> >>
> >>
> >>Chris Mason wrote on 2016/03/01 11:06 -0500:
> >>>On Tue, Mar 01, 2016 at 10:20:26AM +0100, David Sterba wrote:
> >>>>Hi Chris,
> >>>>
> >>>>On Fri, Feb 26, 2016 at 01:22:00PM +0000, fdmanana@kernel.org wrote:
> >>>>>The following changes since commit 0fcb760afa6103419800674e22fb7f4de1f9670b:
> >>>>>
> >>>>>   Merge branch 'for-next' of git://git.kernel.org/pub/scm/linux/kernel/git/kdave/linux into for-linus-4.6 (2016-02-24 10:21:44 -0800)
> >>>>>
> >>>>>are available in the git repository at:
> >>>>>
> >>>>>   git://git.kernel.org/pub/scm/linux/kernel/git/fdmanana/linux.git integration-4.6
> >>>>>
> >>>>>for you to fetch changes up to 97c86c11a5cb9839609a9df195e998c3312e68b0:
> >>>>>
> >>>>>   Btrfs: do not collect ordered extents when logging that inode exists (2016-02-26 04:28:15 +0000)
> >>>>
> >>>>Filipe's branch is based on some integration snapshot that contains the
> >>>>'delete device by id' patchset that was removed from the 4.6 queue.
> >>>>
> >>>>Your branch 'next' merges it back again through Filipe's tree, besides
> >>>>that the merge commits of the topic branches in my for-next appear
> >>>>twice. While the duplicated commits are only an esthetic issue, the
> >>>>extra branch bothers me.
> >>>>
> >>>>I don't see a nice way how to avoid rebases in this cases. My suggestion
> >>>>is that Filipe rebases the branch on my for-chris that could have been
> >>>>an integration at some point.
> >>>>
> >>>>As we're merging our branches that way for the first time I'd like to
> >>>>find the workflow also for the next dev cycles so I'm open to other
> >>>>suggestions.
> >>>
> >>>Ugh, thanks Dave I missed this.  I'll rebase Filipe on top of your
> >>>branch.  The easiest way to avoid it in general is to only base trees on
> >>>top of things already in Linus' tree.  If there are specific
> >>>dependencies we can work it out on a case by case basis, but the merge
> >>>conflicts are almost always trivial.
> >>>
> >>>-chris
> >>
> >>Although off-topic, but do we need to rebase all sent pull to the new
> >>integration-4.6?
> >
> >Unless there are huge conflicts, it's actually much easier to base
> >against a recent v4.5-rcN.  That way if we do have to rebase the
> >integration branch, it doesn't mess up your pull request.
> >
> >If there are small conflicts, I can just deal with them when I pull.
> >For bigger conflicts, I'll either rebase on top of integration as
> >individual patches, or ask for help ;)
> 
> Thanks for the tip.
> Seems git can handle them well. (yeah, no more patch bombing )

Please keep patch bombing ;)  It's the best way to get things reviewed.
Besides, if people didn't like email, they would have found different
jobs long ago ;)

-chris
