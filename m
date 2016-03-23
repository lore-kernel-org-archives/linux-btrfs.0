Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from ipmail04.adl6.internode.on.net ([150.101.137.141]:21025 "EHLO
	ipmail04.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753790AbcCWDlG (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 22 Mar 2016 23:41:06 -0400
Date: Wed, 23 Mar 2016 14:40:40 +1100
From: Dave Chinner <david@fromorbit.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: "Darrick J. Wong" <darrick.wong@oracle.com>, linux-ext4@vger.kernel.org,
        fstests@vger.kernel.org, linux-btrfs@vger.kernel.org, xfs@oss.sgi.com
Subject: Re: [PATCH 06/12] xfs/030: fix output on newer filesystems
Message-ID: <20160323034040.GA11812@dastard>
References: <20160305003717.28738.98818.stgit@birch.djwong.org>
 <20160305003756.28738.26362.stgit@birch.djwong.org>
 <20160305202050.GF10245@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20160305202050.GF10245@infradead.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, Mar 05, 2016 at 12:20:50PM -0800, Christoph Hellwig wrote:
> Still fails for me:
> 
> --- tests/xfs/030.out	2016-03-03 07:55:58.556427678 +0000
> +++ /root/xfstests/results//xfs/030.out.bad	2016-03-05 20:20:17.561433837 +0000
> @@ -231,8 +231,6 @@
>  bad agbno AGBNO in agfl, agno 0
>  bad agbno AGBNO in agfl, agno 0
>  bad agbno AGBNO in agfl, agno 0
> -bad agbno AGBNO in agfl, agno 0
> -bad agbno AGBNO in agfl, agno 0

That's because the free lists are of different lengths on the
different fs configs. Not sure how best to handle it - maybe just
filter then entire bad agbno in agfl line out?

I'm going to commit the change anyway, as this is a separate issue
that needs to be solved.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
