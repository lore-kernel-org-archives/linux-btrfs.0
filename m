Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from ipmail07.adl2.internode.on.net ([150.101.137.131]:18155 "EHLO
	ipmail07.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752721AbaBQB6D (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 16 Feb 2014 20:58:03 -0500
Date: Mon, 17 Feb 2014 12:57:57 +1100
From: Dave Chinner <david@fromorbit.com>
To: Koen De Wit <koen.de.wit@oracle.com>
Cc: xfs@oss.sgi.com, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v3] xfstests: Btrfs: add test for large metadata blocks
Message-ID: <20140217015757.GC13997@dastard>
References: <1392068362-14049-1-git-send-email-koen.de.wit@oracle.com>
 <20140210220400.GV13647@dastard>
 <52FA7374.2000209@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <52FA7374.2000209@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Feb 11, 2014 at 08:01:08PM +0100, Koen De Wit wrote:
> On 02/10/2014 11:04 PM, Dave Chinner wrote:
> >On Mon, Feb 10, 2014 at 10:39:22PM +0100, Koen De Wit wrote:
> >>+
> >>+_test_illegal_leafsize() {
> >>+        _scratch_mkfs -l $1 >>$seqres.full 2>&1
> >>+        [ $? -ne 0 ] || _fail "'$1' is an illegal value for the" \
> >>+                "leafsize option, mkfs should have failed."
> >>+}
> >You just re-implemented run_check....
> 
> I believe I didn't :
> 
>    run_check()
>    {
>             echo "# $@" >> $seqres.full 2>&1
>             "$@" >> $seqres.full 2>&1 || _fail "failed: '$@'"
>    }
> 
> run_check() takes an arbitrary command and executes it,
> _test_illegal_leafsize() takes a leafsize as parameter and tries
> mkfs.btrfs with that leafsize. run_check() makes the test fail if
> the return code is not zero, _test_illegal_leafsize() does the
> opposite.

Which points out the madness of trying to determine pass/fail by
return codes. See how easy it is to get wrong when reading the
test code?

So, this tends to point towards writing a proper mkfs filter for
btrfs that anonymizes the output so that the golden output can do
the checking without having to care about return values. That's what
we do for XFS (see _filter_mkfs), and i'd suggest that this is the
correct thing to do for btrfs as well. Then you can stop having to
check the return value of mkfs.btrfs....

i.e. factor _filter_mkfs into _filter_mkfs_xfs() and
_filter_mkfs_btrfs() and implement the necessary filtering in
_filter_mkfs_btrfs.

Yes, it's a bit of a pain to do in the first place, but once the
filter is in place it will capture any future unintended
modifications to mkfs output and make people modifying mkfs.btrfs
think about what they are actually doing when they break the filter.
Indeed, we've been modifying the output of mkfs.xfs for years (every
new feature changes the mkfs output) and we've been able to do in a
way that doesn't break the filtering.....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
