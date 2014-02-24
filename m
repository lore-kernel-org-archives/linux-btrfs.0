Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from ipmail07.adl2.internode.on.net ([150.101.137.131]:29655 "EHLO
	ipmail07.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752142AbaBXMis (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 24 Feb 2014 07:38:48 -0500
Date: Mon, 24 Feb 2014 23:23:10 +1100
From: Dave Chinner <david@fromorbit.com>
To: Filipe David Borba Manana <fdmanana@gmail.com>
Cc: xfs@oss.sgi.com, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] xfstests: add function _require_fssum()
Message-ID: <20140224122310.GO4317@dastard>
References: <1393242983-16149-1-git-send-email-fdmanana@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1393242983-16149-1-git-send-email-fdmanana@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Feb 24, 2014 at 11:56:23AM +0000, Filipe David Borba Manana wrote:
> To avoid repeating detection of fssum presence in many btrfs tests, as
> suggested by Dave Chinner.
> 
> Signed-off-by: Filipe David Borba Manana <fdmanana@gmail.com>
> ---
>  common/rc       |    7 +++++++
>  tests/btrfs/007 |    5 +----
>  tests/btrfs/016 |    5 +----
>  tests/btrfs/030 |    5 +----
>  tests/btrfs/038 |    5 +----
>  tests/btrfs/039 |    5 +----
>  tests/btrfs/040 |    5 +----
>  tests/btrfs/041 |    5 +----
>  tests/btrfs/042 |    5 +----
>  9 files changed, 15 insertions(+), 32 deletions(-)
>  mode change 100644 => 100755 tests/btrfs/016
> 
> diff --git a/common/rc b/common/rc
> index 5df504c..cce05cc 100644
> --- a/common/rc
> +++ b/common/rc
> @@ -2144,6 +2144,13 @@ _require_cp_reflink()
>                 _notrun "This test requires a cp with --reflink support."
>  }
>  
> +_require_fssum()
> +{
> +	HERE=`pwd`
> +	FSSUM_PROG=$HERE/src/fssum
> +	[ -x $FSSUM_PROG ] || _notrun "fssum not built"
> +}

$here is defined by check to be the root of the xfstests instance
that is running. There's 60+ tests that already us it. Hence:

_require_fssum()
{
	FSSUM_PROG=$here/src/fssum
	[ -x $FSSUM_PROG ] || _notrun "fssum not built"
}

Is all you need here.

> +
>  # Given 2 files, verify that they have the same mapping but different
>  # inodes - i.e. an undisturbed reflink
>  # Silent if so, make noise if not
> diff --git a/tests/btrfs/007 b/tests/btrfs/007
> index 5df9ccb..5430613 100755
> --- a/tests/btrfs/007
> +++ b/tests/btrfs/007
> @@ -31,7 +31,6 @@ seq=`basename $0`
>  seqres=$RESULT_DIR/$seq
>  echo "QA output created by $seq"
>  
> -here=`pwd`
>  tmp=`mktemp -d`
>  status=1

Yeah, redefining $here is a bad thing to do :/

And I'd missed that this was being done in all the new btrfs tests,
otherwise I would have pulled it up earlier.

It also points out that the btrfs tests are using a non-standard
$tmp directory - one that is in the xfstests source directory.
That's a bad thing, too - tests should be using:

tmp=/tmp/$$

to store small temporary files.

If /tmp is too small for what a test needs, then the test should be
using $TEST_DIR as the store for the temporary files to exercise
the filesystem under test as much as possible.  e.g. send image
files build form snapshots of SCRATCH_DEV should be stored on TEST_DIR,
not in $tmp; filesystem image files that are mounted by loopback
should be stored on TEST_DIR or SCRATCH_MNT, not $tmp. And so on.

i.e. the idea is that you direct as much of the IO to the test_DIR
and SCRATCH_MNT as possible, not to the filesystem that is hosting
$tmp or the xfstests source directory....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
