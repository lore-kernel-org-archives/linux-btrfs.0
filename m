Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:16443 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751690AbbHMDWX (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 12 Aug 2015 23:22:23 -0400
Date: Thu, 13 Aug 2015 11:22:04 +0800
From: Liu Bo <bo.li.liu@oracle.com>
To: Dave Chinner <david@fromorbit.com>
Cc: fstests@vger.kernel.org, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] fstests: btrfs regression test for defrag tail extents
Message-ID: <20150813032203.GB920@localhost.localdomain>
Reply-To: bo.li.liu@oracle.com
References: <1439194379-29290-1-git-send-email-bo.li.liu@oracle.com>
 <20150811023201.GL3902@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20150811023201.GL3902@dastard>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Aug 11, 2015 at 12:32:01PM +1000, Dave Chinner wrote:
> On Mon, Aug 10, 2015 at 04:12:59PM +0800, Liu Bo wrote:
> > Regression test for btrfs defragment tool, it's aimed to verify
> > that tail extents won't be skipped as a separate extent while the previous
> > extents have been defrag'ed into a whole extent.
> > 
> > Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
> 
> I don't see anything btrfs specific in this test, so it belongs in
> tests/generic/
> 
> Also, how is this different to generic/018 testing fragmented files
> defrag back to one extent?

Thanks for reminding me of this, it's in fact quite similar to one of
the cases in generic/018, and the difference is that btrfs has an extent
length thresh (256K) for deciding if the extent is big enough (no need to defrag).

That said, I'd like to add this into generic/018 to keep it simple.

Thanks,

-liubo
