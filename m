Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:59176 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1731200AbeHOBnJ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 14 Aug 2018 21:43:09 -0400
Date: Wed, 15 Aug 2018 00:53:37 +0200
From: David Sterba <dsterba@suse.cz>
To: Omar Sandoval <osandov@osandov.com>
Cc: David Sterba <dsterba@suse.cz>, Filipe Manana <fdmanana@kernel.org>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH 2/2] Btrfs: sync log after logging new name
Message-ID: <20180814225337.GG24025@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20180611182428.18102-1-fdmanana@kernel.org>
 <20180615155428.GG24375@twin.jikos.cz>
 <CAL3q7H641LmbUYgg_0n+1rS6KRScgZh9UjMSauCVCMNLJPnVdw@mail.gmail.com>
 <20180618110616.GI24375@twin.jikos.cz>
 <20180814190405.GA10954@vader>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20180814190405.GA10954@vader>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Aug 14, 2018 at 12:04:05PM -0700, Omar Sandoval wrote:
> On Mon, Jun 18, 2018 at 01:06:16PM +0200, David Sterba wrote:
> > On Fri, Jun 15, 2018 at 05:19:07PM +0100, Filipe Manana wrote:
> > > On Fri, Jun 15, 2018 at 4:54 PM, David Sterba <dsterba@suse.cz> wrote:
> > > > On Mon, Jun 11, 2018 at 07:24:28PM +0100, fdmanana@kernel.org wrote:
> > > >> From: Filipe Manana <fdmanana@suse.com>
> > > >> Fixes: 12fcfd22fe5b ("Btrfs: tree logging unlink/rename fixes")
> > > >> Reported-by: Vijay Chidambaram <vvijay03@gmail.com>
> > > >> Signed-off-by: Filipe Manana <fdmanana@suse.com>
> > > >
> > > > There are some warnings and possible lock up caused by this patch, the
> > > > 1/2 alone is ok but 1/2 + 2/2 leads to the following warnings. I checked
> > > > twice, the patch base was the pull request ie. without any other 4.18
> > > > stuff.
> > > 
> > > Are you sure it's this patch?
> > > On top of for-4.18 it didn't cause any problems here, plus the trace
> > > below has nothing to do with renames, hard links or fsync at all -
> > > everything seems stuck on waiting for IO from dev replace.
> > 
> > It was a false alert, sorry. Strange that the warnings appeared only in
> > the VM running both patches and not otherwise.
> > 
> > Though the test did not directly use rename, the possible error scenario
> > I had in mind was some leftover from locking, error handling or state
> > that blocked umount of 011.
> 
> Dave, are you sending this in for 4.19? I don't see it in your first
> pull request.

Will send it in 2nd pull for 4.19. The patch is 2 months old and I don't
remember where it was lost on the way. I had some suspicions but turned
out to be false. Thanks for the reminder.
