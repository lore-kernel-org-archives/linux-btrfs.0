Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:23466 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753057AbcEZDRB (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 25 May 2016 23:17:01 -0400
Date: Wed, 25 May 2016 20:16:53 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
To: dsterba@suse.cz, Josef Bacik <jbacik@fb.com>, linux-btrfs@vger.kernel.org,
        kernel-team@fb.com
Subject: Re: [PATCH] Btrfs: change how we calculate the global block rsv
Message-ID: <20160526031653.GA4585@birch.djwong.org>
References: <1464187894-16902-1-git-send-email-jbacik@fb.com>
 <20160525213359.GR29147@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20160525213359.GR29147@twin.jikos.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, May 25, 2016 at 11:33:59PM +0200, David Sterba wrote:
> On Wed, May 25, 2016 at 10:51:34AM -0400, Josef Bacik wrote:
> > Traditionally we've calculated the global block rsv by guessing how much of the
> > metadata used amount was the extent tree, and then taking the data size and
> > figuring out how large the csum tree would have to be to hold that much data.
> > 
> > This is imprecise and falls down on MIXED file systems as we can't trust the
> > data used amount.  This resulted in failures for xfstests generic/333 because it
> > creates lots of clones, which explodes out the extent tree.  Our global reserve
> > calculations were woefully inaccurate in this case which meant we got into a
> > situation where we did not have enough reserved to do our work.
> > 
> > We know we only use the global block rsv for the extent, csum, and root trees,
> > so just get the bytes used for these trees and use that as the basis of our
> > global reserve.  Since these are not reference counted trees the bytes_used
> > value will be accurate.  This fixed the transaction aborts seen with
> > generic/333.  Thanks,
> 
> The abort is gone, the fstest fails with
> 
> generic/333              - output mismatch (see results//generic/333.out.bad)
>     --- tests/generic/333.out   2016-04-08 11:50:13.000000000 +0200
>     +++ results//generic/333.out.bad  2016-05-25 23:30:50.965956265 +0200
>     @@ -2,3 +2,4 @@
>      Format and mount
>      Initialize file
>      Snapshot a file undergoing directio rewrite
>     +touch: cannot touch '/mnt/scratch/test-333/finished': No space left on device

Yeah, the finished flag file should be in $TEST_DIR, not $SCRATCH_MNT.

Patches coming...

--D

> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
