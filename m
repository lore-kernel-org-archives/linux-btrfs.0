Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from ipmail06.adl2.internode.on.net ([150.101.137.129]:12992 "EHLO
	ipmail06.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751049AbbI1X3j (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 28 Sep 2015 19:29:39 -0400
Date: Tue, 29 Sep 2015 09:28:58 +1000
From: Dave Chinner <david@fromorbit.com>
To: Mark Fasheh <mfasheh@suse.de>
Cc: fstests@vger.kernel.org, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] fstests: btrfs: add test for quota groups and drop
 snapshot
Message-ID: <20150928232858.GA27164@dastard>
References: <20150922221649.GB17854@wotan.suse.de>
 <20150923024708.GK3902@dastard>
 <20150923210516.GC17854@wotan.suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20150923210516.GC17854@wotan.suse.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Sep 23, 2015 at 02:05:16PM -0700, Mark Fasheh wrote:
> Since the last time I sent this test, drop snapshot was broken again with
> respect to qgroups. What practical step could I take to get a test for that
> in here which I can beat the btrfs developers over the head with the next
> time someone handwaves this problem away ;)

I'll merge tests that break a filesystem as a reminder to developers
that there is a problem that needs fixing. We do that from time to
time for XFS issues that are either really hard to fix or not urgent
but require significant amounts of work to correct...

> From: Mark Fasheh <mfasheh@suse.de>
> 
> [PATCH] btrfs: add test for quota groups and drop snapshot
....
> +# NOTE: The ability to vary tree height for this test is very useful
> +# for debugging problems with drop_snapshot(). As a result we retain
> +# that parameter even though the test below always does level 2 trees.
> +_explode_fs_tree () {
> +	local level=$1;
> +	local loc="$2";
> +	local n;
> +
> +	if [ -z $loc ]; then
> +	    echo "specify location for fileset"
> +	    exit 1;
> +	fi
> +
> +	case $level in
> +	    1)# this always reproduces level 1 trees
> +		n=10;
> +		;;
> +	    2)# this always reproduces level 2 trees
> +		n=1500

Still some minor whitespace issues, but I can fix that on commit
as everything else looks fine.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
