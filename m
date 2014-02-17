Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from ipmail07.adl2.internode.on.net ([150.101.137.131]:32140 "EHLO
	ipmail07.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753857AbaBQBoY (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 16 Feb 2014 20:44:24 -0500
Date: Mon, 17 Feb 2014 12:44:16 +1100
From: Dave Chinner <david@fromorbit.com>
To: Filipe David Manana <fdmanana@gmail.com>
Cc: "xfs@oss.sgi.com" <xfs@oss.sgi.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH] xfstests: add regression test for btrfs incremental send
Message-ID: <20140217014416.GB13997@dastard>
References: <1392408522-764-1-git-send-email-fdmanana@gmail.com>
 <1392596438-6509-1-git-send-email-fdmanana@gmail.com>
 <20140217011929.GA13997@dastard>
 <CAL3q7H4JLbMS+JL4h4du60S1vKFtvceP-Mx-e=0v4nTBwjkATA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CAL3q7H4JLbMS+JL4h4du60S1vKFtvceP-Mx-e=0v4nTBwjkATA@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Feb 17, 2014 at 01:36:02AM +0000, Filipe David Manana wrote:
> On Monday, February 17, 2014, Dave Chinner <david@fromorbit.com> wrote:
> 
> > On Mon, Feb 17, 2014 at 12:20:38AM +0000, Filipe David Borba Manana wrote:
> > > Test for a btrfs incremental send issue where we end up sending a
> > > wrong section of data from a file extent if the corresponding file
> > > extent is compressed and the respective file extent item has a non
> > > zero data offset.
> > >
> > > Fixed by the following linux kernel btrfs patch:
> > >
> > >    Btrfs: use right clone root offset for compressed extents
> > >
> > > Signed-off-by: Filipe David Borba Manana <fdmanana@gmail.com<javascript:;>
> > >
> > > ---
> > >
> > > V2: Made the test more reliable. Now it doesn't depend anymore of btrfs'
> > >     hole punch implementation leaving hole file extent items when we
> > punch
> > >     beyond the file's current size.
> > > V3: Filter xfs_io output and make less use of the run_check function, as
> > >     suggested by Dave Chinner.
> >
> > Awesome. Thanks for the quick turn around.
> >
> > >  common/rc           |    5 +++
> > >  tests/btrfs/040     |  119
> > +++++++++++++++++++++++++++++++++++++++++++++++++++
> > >  tests/btrfs/040.out |    9 ++++
> > >  tests/btrfs/group   |    1 +
> > >  4 files changed, 134 insertions(+)
> > >  create mode 100755 tests/btrfs/040
> > >  create mode 100644 tests/btrfs/040.out
> > >
> > > diff --git a/common/rc b/common/rc
> > > index e91568b..27be009 100644
> > > --- a/common/rc
> > > +++ b/common/rc
> > > @@ -2207,6 +2207,11 @@ run_check()
> > >       "$@" >> $seqres.full 2>&1 || _fail "failed: '$@'"
> > >  }
> > >
> > > +_run_btrfs_util_prog()
> > > +{
> > > +     run_check $BTRFS_UTIL_PROG $*
> > > +}
> >
> > Can you do a cleanup of all the other btrfs tests that can use this?
> 
> 
> Ok. I just did that for all the test cases not yet merged, as you probably
> noticed already.

Yes, I did ;)

> For the ones already in the repository, I'll see if I can do it soon this
> coming week.

Great! Thanks for doing this.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
