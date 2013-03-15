Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from ipmail04.adl6.internode.on.net ([150.101.137.141]:42336 "EHLO
	ipmail04.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753282Ab3COKQ3 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 15 Mar 2013 06:16:29 -0400
Date: Fri, 15 Mar 2013 21:16:25 +1100
From: Dave Chinner <david@fromorbit.com>
To: Eric Sandeen <sandeen@sandeen.net>
Cc: Eric Sandeen <sandeen@redhat.com>, linux-btrfs@vger.kernel.org,
        xfs@oss.sgi.com
Subject: Re: [PATCH 3/3 V4] xfstests: btrfs tests for basic informational
 commands
Message-ID: <20130315101625.GE6369@dastard>
References: <1363186623-1378-1-git-send-email-sandeen@redhat.com>
 <1363186623-1378-4-git-send-email-sandeen@redhat.com>
 <5140AB9D.2070001@redhat.com>
 <5140CB3F.5010704@redhat.com>
 <5140CD26.7050201@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <5140CD26.7050201@sandeen.net>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Mar 13, 2013 at 02:01:58PM -0500, Eric Sandeen wrote:
> Run basic btrfs information commands in various ways, performing
> sanity tests of: filesystem show, label, sync, and device stats
> (sync is included just because it's simple).  These are mostly
> just smoke tests, although for example show by label & UUID
> should verify that the correct fs was shown.
> 
> This also adds quite a few new filters to accommodate the output
> of the new commands.
> 
> Cc: linux-btrfs@vger.kernel.org
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> ---
> 
> V2: sort & uniq device stats output to account for variable
> nrs. of devices.  Optionally check that the proper nr. of
> devices was returned, as well.
> 
> V3: _filter_uuid needs to pay attention to $1, not hope
> that the caller has set $UUID.  Oops.
> 
> V4: fix stats filter to set UNIQ_OPT in both cases, ugh.

Something I just noticed in this commit:

> +# get standard environment, filters and checks
> +. ./common.rc
> +. ./btrfs.filter

That should probably have been named "common.filter.btrfs".
I found this updating my patchset that moves all the common.* files
into a common/ directory....

I'll rename it to common/filter.btrfs....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
