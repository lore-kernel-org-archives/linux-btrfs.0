Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:45198 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750717AbcCESZK (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sat, 5 Mar 2016 13:25:10 -0500
Date: Sat, 5 Mar 2016 10:25:08 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: david@fromorbit.com, linux-ext4@vger.kernel.org,
        linux-btrfs@vger.kernel.org, fstests@vger.kernel.org, xfs@oss.sgi.com
Subject: Re: [PATCH 12/12] block: test fallocate for block devices
Message-ID: <20160305182508.GA25528@infradead.org>
References: <20160305003717.28738.98818.stgit@birch.djwong.org>
 <20160305003837.28738.49794.stgit@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20160305003837.28738.49794.stgit@birch.djwong.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I'm not sure xfstests is the right fit, as it does not test a file
system, but rather block devices.

If people think it should go into xfstests we should at least not
add it to the default group, but just to a new bdev group.
