Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:34154 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752025AbcADTrY (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 4 Jan 2016 14:47:24 -0500
Date: Mon, 4 Jan 2016 11:47:08 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
To: Dave Chinner <david@fromorbit.com>
Cc: linux-ext4@vger.kernel.org, linux-btrfs@vger.kernel.org,
        fstests@vger.kernel.org, xfs@oss.sgi.com
Subject: Re: [PATCH 06/11] reflink: more tests
Message-ID: <20160104194708.GA28357@birch.djwong.org>
References: <20151219091052.15320.94973.stgit@birch.djwong.org>
 <20151219091131.15320.12391.stgit@birch.djwong.org>
 <20151221063111.GO19802@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20151221063111.GO19802@dastard>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Dec 21, 2015 at 05:31:11PM +1100, Dave Chinner wrote:
> On Sat, Dec 19, 2015 at 01:11:31AM -0800, Darrick J. Wong wrote:
> > Add more tests for unaligned copy-on-write things, and explicitly
> > test the ability to pass "len == 0" to mean reflink/dedupe all
> > the way to the end of the file".
> > 
> > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> .....
> > +_cleanup()
> > +{
> > +    cd /
> > +    rm -rf "$tmp".* "$TESTDIR"
> > +}
> .....
> > +
> > +TESTDIR="$TEST_DIR/test-$seq"
> > +rm -rf "$TESTDIR"
> > +mkdir "$TESTDIR"
> 
> This use of TESTDIR is highly confusing. When I see TESTDIR I think
> that it's the mount point of the test device, not potentially some
> directory on the scratch device.
> 
> I see that this occurs through lots of tests, not just these new
> ones. Can you do a pass across the tests with, say, sed and rename
> all these to something less confusing? e.g. "testdir", in lower
> case, makes it clear that it's a local variable, not the global test
> device mount point.... (i.e. test local variables are lower case,
> exported test harnes variables are upper case ;)
> 
> Separate patch/pull req is fine.

No problem.  Will give it a spin on the test harness before sending.

(Yikes, it's a 272K patch...)

--D

> 
> Cheers,
> 
> dave.
> -- 
> Dave Chinner
> david@fromorbit.com
