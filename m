Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from [198.137.202.9] ([198.137.202.9]:42506 "EHLO
	bombadil.infradead.org" rhost-flags-FAIL-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S932842AbcCOIf1 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 15 Mar 2016 04:35:27 -0400
Date: Tue, 15 Mar 2016 01:34:37 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Dave Chinner <david@fromorbit.com>
Cc: Christoph Hellwig <hch@infradead.org>,
        "Darrick J. Wong" <darrick.wong@oracle.com>,
        linux-ext4@vger.kernel.org, linux-btrfs@vger.kernel.org,
        fstests@vger.kernel.org, xfs@oss.sgi.com
Subject: Re: [PATCH 12/12] block: test fallocate for block devices
Message-ID: <20160315083437.GB8802@infradead.org>
References: <20160305003717.28738.98818.stgit@birch.djwong.org>
 <20160305003837.28738.49794.stgit@birch.djwong.org>
 <20160305182508.GA25528@infradead.org>
 <20160315034148.GF30721@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20160315034148.GF30721@dastard>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Mar 15, 2016 at 02:41:48PM +1100, Dave Chinner wrote:
> I think it's the right place to test it - we have all the
> infrastructure available to do it (i.e. xfs_io and various block
> devices) and we really need to make sure this stuff works,
> especially if we start to write filesystem code that depends on
> correct behaviour...

Ok.  But let's keep it outside of the auto group so we don't run purely
block device specific tests every time we do an xfstests run.
