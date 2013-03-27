Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from ipmail06.adl6.internode.on.net ([150.101.137.145]:11745 "EHLO
	ipmail06.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753023Ab3C0VLE (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 27 Mar 2013 17:11:04 -0400
Date: Thu, 28 Mar 2013 08:02:36 +1100
From: Dave Chinner <david@fromorbit.com>
To: "Theodore Ts'o" <tytso@mit.edu>
Cc: Rich Johnston <rjohnston@sgi.com>, xfs-oss <xfs@oss.sgi.com>,
        linux-ext4@vger.kernel.org, linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: Announce re-factor all current xfstests patches request
Message-ID: <20130327210236.GV6369@dastard>
References: <5152F2BB.4000709@sgi.com>
 <20130327134606.GJ5861@thunk.org>
 <5153217B.5070909@sgi.com>
 <20130327190512.GA22889@thunk.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20130327190512.GA22889@thunk.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Mar 27, 2013 at 03:05:12PM -0400, Theodore Ts'o wrote:
> What do you think about renaming the existing tests from NNN to
> NNN-descriptive-name?  That way it will be easier for people who are
> trying to track regressions, since they can easily map from the new
> more descriptive name to the old test number for comparison purposes
> (i.e., to see whether a failure is a regression or not, etc.)

When named test support is done, then we could do this.

> Would you be open to changes which did this?  I'd suggest sending the
> changes as a shell script to minimize the chances of patch conflicts.
> It will cause people to need to regenerate their patches, but that
> means now would be the time to do this, when everyone will need to be
> fixing up their outstanding changes anyway.  :-)

There's more than just the rename of the file. group files have to
change, there's the possibility that the group list and test list
handling will need to be completely rewritten, the way test names
are output will need work, the result summaries will need to be
reformatted to be legible, etc.

So it's not just a case of renaming a file - there's still quite a
lot of infrastructure work needed before we can start using names
rather then sequence numbers for tests.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
