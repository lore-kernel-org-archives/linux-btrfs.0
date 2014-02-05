Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from ipmail05.adl6.internode.on.net ([150.101.137.143]:39958 "EHLO
	ipmail05.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751387AbaBEXP3 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 5 Feb 2014 18:15:29 -0500
Date: Thu, 6 Feb 2014 10:15:26 +1100
From: Dave Chinner <david@fromorbit.com>
To: David Disseldorp <ddiss@suse.de>
Cc: xfs@oss.sgi.com, dsterba@suse.cz, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 2/2] btrfs/035: add new clone overwrite regression test
Message-ID: <20140205231526.GJ13997@dastard>
References: <1391599009-2402-1-git-send-email-ddiss@suse.de>
 <1391599009-2402-3-git-send-email-ddiss@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1391599009-2402-3-git-send-email-ddiss@suse.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Feb 05, 2014 at 12:16:49PM +0100, David Disseldorp wrote:
> This test uses the newly added cloner binary to dispatch full file and
> range specific clone (reflink) requests.

A couple of small nits:

> +CLONER_PROG=$here/src/cloner

Need to test that the binary was build and is present.

> +
> +src_str="aaaaaaaaaa"
> +
> +echo -n "$src_str" > $SCRATCH_MNT/src || _fail "failed to create src"

No need for the "|| _fail ..." in any part of this test. Failures
will be caught in the output and hence cause golden output
mismatches.

Letting the test run even after a failure exercises the filesystem
in interesting ways, so it's worthwhile ignoring failures in the
test and letting the harness pick up the failures through error
messages.

> +$CLONER_PROG $SCRATCH_MNT/src  $SCRATCH_MNT/src.clone1
> +
> +src_str="bbbbbbbbbbcccccccccc"
> +
> +echo -n "$src_str" > $SCRATCH_MNT/src || _fail "failed to create src"
> +
> +$CLONER_PROG $SCRATCH_MNT/src $SCRATCH_MNT/src.clone2
> +
> +snap_src_sz=`ls -lah $SCRATCH_MNT/src.clone1 | awk '{print $5}'`
> +echo "attempting ioctl (src.clone1 src)"
> +$CLONER_PROG -s 0 -d 0 -l ${snap_src_sz} \
> +	$SCRATCH_MNT/src.clone1 $SCRATCH_MNT/src || _fail "ioctl failed"

And to do that here, you probably need to add perror() output to
the cloner program when it detects an error. i.e. let it give you
the exact error that was detected, rather than lumping them all into
a catchall here...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
