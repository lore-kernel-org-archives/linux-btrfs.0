Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:46266 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752844AbbJATbl (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 1 Oct 2015 15:31:41 -0400
Date: Thu, 1 Oct 2015 12:31:39 -0700
From: Mark Fasheh <mfasheh@suse.de>
To: Dave Chinner <david@fromorbit.com>
Cc: fstests@vger.kernel.org, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] fstests: btrfs: add test for quota groups and drop
 snapshot
Message-ID: <20151001193139.GA1044@wotan.suse.de>
Reply-To: Mark Fasheh <mfasheh@suse.de>
References: <20150922221649.GB17854@wotan.suse.de>
 <20150923024708.GK3902@dastard>
 <20150923210516.GC17854@wotan.suse.de>
 <20150928232858.GA27164@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20150928232858.GA27164@dastard>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Sep 29, 2015 at 09:28:58AM +1000, Dave Chinner wrote:
> On Wed, Sep 23, 2015 at 02:05:16PM -0700, Mark Fasheh wrote:
> > Since the last time I sent this test, drop snapshot was broken again with
> > respect to qgroups. What practical step could I take to get a test for that
> > in here which I can beat the btrfs developers over the head with the next
> > time someone handwaves this problem away ;)
> 
> I'll merge tests that break a filesystem as a reminder to developers
> that there is a problem that needs fixing. We do that from time to
> time for XFS issues that are either really hard to fix or not urgent
> but require significant amounts of work to correct...

That sounds like a good policy, thank you.


> > From: Mark Fasheh <mfasheh@suse.de>
> > 
> > [PATCH] btrfs: add test for quota groups and drop snapshot
> ....
> > +# NOTE: The ability to vary tree height for this test is very useful
> > +# for debugging problems with drop_snapshot(). As a result we retain
> > +# that parameter even though the test below always does level 2 trees.
> > +_explode_fs_tree () {
> > +	local level=$1;
> > +	local loc="$2";
> > +	local n;
> > +
> > +	if [ -z $loc ]; then
> > +	    echo "specify location for fileset"
> > +	    exit 1;
> > +	fi
> > +
> > +	case $level in
> > +	    1)# this always reproduces level 1 trees
> > +		n=10;
> > +		;;
> > +	    2)# this always reproduces level 2 trees
> > +		n=1500
> 
> Still some minor whitespace issues, but I can fix that on commit
> as everything else looks fine.

Erf, my bad I tried copying the style in some of the common/ dir but
obviously failed :(  Thanks for the review and help Dave, it is greatly
appreciated.
	--Mark

--
Mark Fasheh
