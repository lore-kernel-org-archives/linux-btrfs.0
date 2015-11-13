Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:20719 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753158AbbKMJI4 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 13 Nov 2015 04:08:56 -0500
Date: Fri, 13 Nov 2015 01:08:22 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: david@fromorbit.com, fstests@vger.kernel.org, xfs@oss.sgi.com,
        tao.peng@primarydata.com, linux-ext4@vger.kernel.org,
        Anna.Schumaker@netapp.com, linux-btrfs@vger.kernel.org
Subject: Re: [RFCv3.1 00/11] xfstests: test the nfs/cifs/btrfs/xfs
 reflink/dedupe ioctls
Message-ID: <20151113090822.GB2214@birch.djwong.org>
References: <20151111192628.15056.6451.stgit@birch.djwong.org>
 <20151112090756.GA25685@infradead.org>
 <20151112125115.GA28822@infradead.org>
 <20151112173427.GC2217@birch.djwong.org>
 <20151112173635.GA9247@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20151112173635.GA9247@infradead.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Nov 12, 2015 at 09:36:35AM -0800, Christoph Hellwig wrote:
> On Thu, Nov 12, 2015 at 09:34:27AM -0800, Darrick J. Wong wrote:
> > Bleargh, _require_*_dedupe forgot to check for ENOTTY output, so all the dedupe
> > tests should have _notrun.
> > 
> > Also, generic/806 was calling the wrong _require.
> > 
> > I'll start renumbering tests; Christoph, did you see anything else?
> 
> Looks fine so far otherwise.

I think I got all the tests renumbered correctly and fixed all the other bugs.
I'd like to send the updated patchpile to Dave tomorrow, but if you have a few
spare cycles would you mind giving this a quick test to make sure I fixed
everything?

https://github.com/djwong/xfstests/tree/for-dave

--D

> --
> To unsubscribe from this list: send the line "unsubscribe fstests" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
