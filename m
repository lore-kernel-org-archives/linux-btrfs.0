Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from ipmail06.adl6.internode.on.net ([150.101.137.145]:11865 "EHLO
	ipmail06.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932670AbbHKCdK (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 10 Aug 2015 22:33:10 -0400
Date: Tue, 11 Aug 2015 12:32:01 +1000
From: Dave Chinner <david@fromorbit.com>
To: Liu Bo <bo.li.liu@oracle.com>
Cc: fstests@vger.kernel.org, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] fstests: btrfs regression test for defrag tail extents
Message-ID: <20150811023201.GL3902@dastard>
References: <1439194379-29290-1-git-send-email-bo.li.liu@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1439194379-29290-1-git-send-email-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Aug 10, 2015 at 04:12:59PM +0800, Liu Bo wrote:
> Regression test for btrfs defragment tool, it's aimed to verify
> that tail extents won't be skipped as a separate extent while the previous
> extents have been defrag'ed into a whole extent.
> 
> Signed-off-by: Liu Bo <bo.li.liu@oracle.com>

I don't see anything btrfs specific in this test, so it belongs in
tests/generic/

Also, how is this different to generic/018 testing fragmented files
defrag back to one extent?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
