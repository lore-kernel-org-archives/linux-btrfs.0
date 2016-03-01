Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:53990 "EHLO
	mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754572AbcCAQIE (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 1 Mar 2016 11:08:04 -0500
Date: Tue, 1 Mar 2016 11:06:50 -0500
From: Chris Mason <clm@fb.com>
To: <dsterba@suse.cz>, <fdmanana@kernel.org>, <linux-btrfs@vger.kernel.org>
Subject: Re: [GIT PULL] Btrfs fixes for 4.6
Message-ID: <20160301160650.fjyyrnf6qfcekgr6@floor.thefacebook.com>
References: <1456492920-18169-1-git-send-email-fdmanana@kernel.org>
 <20160301092026.GX23746@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <20160301092026.GX23746@twin.jikos.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Mar 01, 2016 at 10:20:26AM +0100, David Sterba wrote:
> Hi Chris,
> 
> On Fri, Feb 26, 2016 at 01:22:00PM +0000, fdmanana@kernel.org wrote:
> > The following changes since commit 0fcb760afa6103419800674e22fb7f4de1f9670b:
> > 
> >   Merge branch 'for-next' of git://git.kernel.org/pub/scm/linux/kernel/git/kdave/linux into for-linus-4.6 (2016-02-24 10:21:44 -0800)
> > 
> > are available in the git repository at:
> > 
> >   git://git.kernel.org/pub/scm/linux/kernel/git/fdmanana/linux.git integration-4.6
> > 
> > for you to fetch changes up to 97c86c11a5cb9839609a9df195e998c3312e68b0:
> > 
> >   Btrfs: do not collect ordered extents when logging that inode exists (2016-02-26 04:28:15 +0000)
> 
> Filipe's branch is based on some integration snapshot that contains the
> 'delete device by id' patchset that was removed from the 4.6 queue.
> 
> Your branch 'next' merges it back again through Filipe's tree, besides
> that the merge commits of the topic branches in my for-next appear
> twice. While the duplicated commits are only an esthetic issue, the
> extra branch bothers me.
> 
> I don't see a nice way how to avoid rebases in this cases. My suggestion
> is that Filipe rebases the branch on my for-chris that could have been
> an integration at some point.
> 
> As we're merging our branches that way for the first time I'd like to
> find the workflow also for the next dev cycles so I'm open to other
> suggestions.

Ugh, thanks Dave I missed this.  I'll rebase Filipe on top of your
branch.  The easiest way to avoid it in general is to only base trees on
top of things already in Linus' tree.  If there are specific
dependencies we can work it out on a case by case basis, but the merge
conflicts are almost always trivial.

-chris
