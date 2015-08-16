Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from ipmail05.adl6.internode.on.net ([150.101.137.143]:60209 "EHLO
	ipmail05.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751348AbbHPX1X (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 16 Aug 2015 19:27:23 -0400
Date: Mon, 17 Aug 2015 09:27:06 +1000
From: Dave Chinner <david@fromorbit.com>
To: Eric Sandeen <sandeen@sandeen.net>
Cc: Liu Bo <bo.li.liu@oracle.com>, fstests@vger.kernel.org,
        linux-btrfs@vger.kernel.org, fdmanana@gmail.com
Subject: Re: [PATCH v2] fstests: generic/018: expand "write backwards sync
 but contiguous" to test regression in btrfs
Message-ID: <20150816232706.GC20596@dastard>
References: <1439455474-20128-1-git-send-email-bo.li.liu@oracle.com>
 <1439455670-21822-1-git-send-email-bo.li.liu@oracle.com>
 <55CE06F4.4000208@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <55CE06F4.4000208@sandeen.net>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Aug 14, 2015 at 10:19:16AM -0500, Eric Sandeen wrote:
> On 8/13/15 3:47 AM, Liu Bo wrote:
> > Btrfs has a problem when defraging a file which has a large fragment'ed range,
> > it'd leave the tail extent as a seperate extent instead of merging it with
> > previous extents.
> > 
> > This makes generic/018 recognize the above regression.
> 
> Sorry for the late review, but here it is ;)
....
> 3) You stop redirecting xfs_io to /dev/null, and save it to the golden output
> file instead.
> 
> Honestly, I find hundreds of extra xfs_io output lines to be rather unhelpful,
> because the old output file used to be quite easy to read, to see what's going on.

Yup, it should remain redirected to /dev/null. If writing a few
small IOs to an otherwise empty filesystem fails, then you've got
bigger problems. besides, we actually test that the writes worked by
the count of extents before defrag. If any of the writes fail, we'll
fail because the "before" extent count will be wrong.

Besides, if the pwrite() fails, then all the paths in xfs_io that
call do_pwrite() end up doing perror("pwrite64") and so it should
output errors to stderr just fine.

> Today it only redirects stdout:
> 
> $XFS_IO_PROG -f -c "pwrite -b $((4 * bsize)) 0 $((4 * bsize))" $fragfile \
> 					> /dev/null
> 
> so if a write fails, I *think* stderr will get output, and the test *should*
> fail as a result.[1]  You could add a || _fail "xfs_io failed" for good measure...

_fail calls do not belong here - catch the error message, and if
there isn't one on stderr then xfs_io need fixing...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
