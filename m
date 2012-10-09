Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:56907 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750954Ab2JISZF (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 9 Oct 2012 14:25:05 -0400
Date: Tue, 9 Oct 2012 11:25:03 -0700
From: Mark Fasheh <mfasheh@suse.de>
To: Jan Schmidt <list.btrfs@jan-o-sch.net>
Cc: Chris Mason <chris.mason@fusionio.com>, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v4 3/4] btrfs: extended inode refs
Message-ID: <20121009182503.GW8097@wotan.suse.de>
Reply-To: Mark Fasheh <mfasheh@suse.de>
References: <1345494561-28758-1-git-send-email-mfasheh@suse.de> <1345494561-28758-4-git-send-email-mfasheh@suse.de> <50741E0D.30505@jan-o-sch.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <50741E0D.30505@jan-o-sch.net>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Oct 09, 2012 at 02:52:29PM +0200, Jan Schmidt wrote:
> Hi Chris, Hi Mark,
> 
> I'm currently working on extended inode refs for btrfs send, reading the version
> of fs/btrfs/backref.c in Chris' next branch. Concerning commit
> f8728be56e48e4a64ed49a71c66b3e6436869838 ...
> 
> On Mon, August 20, 2012 at 22:29 (+0200), Mark Fasheh wrote:
> > Teach tree-log.c about extended inode refs. In particular, we have to adjust
> > the behavior of inode ref replay as well as log tree recovery to account for
> > the existence of extended refs.
> > 
> > Signed-off-by: Mark Fasheh <mfasheh@suse.de>
> > ---
> >  fs/btrfs/backref.c  |   68 +++++++++++
> >  fs/btrfs/backref.h  |    5 +
> >  fs/btrfs/tree-log.c |  316 ++++++++++++++++++++++++++++++++++++++++++---------
> >  3 files changed, 337 insertions(+), 52 deletions(-)
> 
> I had made comments on v3 of this one, which were obviously ignored for v4. I
> did not reply to v4, which is the version in "next". Despite that, this commit
> has got a
> 
>     Reviewed-by: Jan Schmidt <list.btrfs@jan-o-sch.net
> 
> Chris, can you please remove that tag from the commit mentioned?

Yes, this was clearly a mistake - pretty much neither of us could completely
figure out that code ;)

I think what happened is the Reviewed-by: from what *used* to be patch 3 got
accidentally applied to this one:

http://marc.info/?l=linux-btrfs&m=134502070513822&w=4

They are very obviously different patches though.
	--Mark

--
Mark Fasheh
