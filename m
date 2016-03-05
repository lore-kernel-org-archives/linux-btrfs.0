Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:55181 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750755AbcCEUQ2 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sat, 5 Mar 2016 15:16:28 -0500
Date: Sat, 5 Mar 2016 12:16:27 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: david@fromorbit.com, linux-ext4@vger.kernel.org, fstests@vger.kernel.org,
        linux-btrfs@vger.kernel.org, xfs@oss.sgi.com
Subject: Re: [PATCH 01/12] xfs/207: fix golden output to match
 FS_IOC_FSSETXATTR hoist
Message-ID: <20160305201627.GA10245@infradead.org>
References: <20160305003717.28738.98818.stgit@birch.djwong.org>
 <20160305003724.28738.94718.stgit@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20160305003724.28738.94718.stgit@birch.djwong.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
