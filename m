Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:34289 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750829AbbKLRfI (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 12 Nov 2015 12:35:08 -0500
Date: Thu, 12 Nov 2015 09:34:27 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: david@fromorbit.com, fstests@vger.kernel.org, xfs@oss.sgi.com,
        tao.peng@primarydata.com, linux-ext4@vger.kernel.org,
        Anna.Schumaker@netapp.com, linux-btrfs@vger.kernel.org
Subject: Re: [RFCv3.1 00/11] xfstests: test the nfs/cifs/btrfs/xfs
 reflink/dedupe ioctls
Message-ID: <20151112173427.GC2217@birch.djwong.org>
References: <20151111192628.15056.6451.stgit@birch.djwong.org>
 <20151112090756.GA25685@infradead.org>
 <20151112125115.GA28822@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20151112125115.GA28822@infradead.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Nov 12, 2015 at 04:51:15AM -0800, Christoph Hellwig wrote:
> On Thu, Nov 12, 2015 at 01:07:56AM -0800, Christoph Hellwig wrote:
> > Looks fine:
> > 
> > Acked-by: Christoph Hellwig <hch@lst.de>
> 
> Actually I take this back.  I had though this was the existing series
> with my fixes, but this one still incorrectly assumes that if reflink
> works dedup works as well, leading to lots of false failures on nfs.

Bleargh, _require_*_dedupe forgot to check for ENOTTY output, so all the dedupe
tests should have _notrun.

Also, generic/806 was calling the wrong _require.

I'll start renumbering tests; Christoph, did you see anything else?

--D

> --
> To unsubscribe from this list: send the line "unsubscribe fstests" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
