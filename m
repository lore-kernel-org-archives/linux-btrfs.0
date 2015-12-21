Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from ipmail06.adl2.internode.on.net ([150.101.137.129]:60089 "EHLO
	ipmail06.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750886AbbLUGbP (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 21 Dec 2015 01:31:15 -0500
Date: Mon, 21 Dec 2015 17:31:11 +1100
From: Dave Chinner <david@fromorbit.com>
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-ext4@vger.kernel.org, linux-btrfs@vger.kernel.org,
        fstests@vger.kernel.org, xfs@oss.sgi.com
Subject: Re: [PATCH 06/11] reflink: more tests
Message-ID: <20151221063111.GO19802@dastard>
References: <20151219091052.15320.94973.stgit@birch.djwong.org>
 <20151219091131.15320.12391.stgit@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20151219091131.15320.12391.stgit@birch.djwong.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, Dec 19, 2015 at 01:11:31AM -0800, Darrick J. Wong wrote:
> Add more tests for unaligned copy-on-write things, and explicitly
> test the ability to pass "len == 0" to mean reflink/dedupe all
> the way to the end of the file".
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
.....
> +_cleanup()
> +{
> +    cd /
> +    rm -rf "$tmp".* "$TESTDIR"
> +}
.....
> +
> +TESTDIR="$TEST_DIR/test-$seq"
> +rm -rf "$TESTDIR"
> +mkdir "$TESTDIR"

This use of TESTDIR is highly confusing. When I see TESTDIR I think
that it's the mount point of the test device, not potentially some
directory on the scratch device.

I see that this occurs through lots of tests, not just these new
ones. Can you do a pass across the tests with, say, sed and rename
all these to something less confusing? e.g. "testdir", in lower
case, makes it clear that it's a local variable, not the global test
device mount point.... (i.e. test local variables are lower case,
exported test harnes variables are upper case ;)

Separate patch/pull req is fine.

Cheers,

dave.
-- 
Dave Chinner
david@fromorbit.com
