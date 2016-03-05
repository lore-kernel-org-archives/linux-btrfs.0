Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:55381 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750848AbcCEUSA (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sat, 5 Mar 2016 15:18:00 -0500
Date: Sat, 5 Mar 2016 12:17:58 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: david@fromorbit.com, linux-ext4@vger.kernel.org, fstests@vger.kernel.org,
        linux-btrfs@vger.kernel.org, xfs@oss.sgi.com
Subject: Re: [PATCH 03/12] reflink: fix fragmentation tests to work on >4k
 block size filesystems
Message-ID: <20160305201758.GC10245@infradead.org>
References: <20160305003717.28738.98818.stgit@birch.djwong.org>
 <20160305003737.28738.35234.stgit@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20160305003737.28738.35234.stgit@birch.djwong.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Looks fine,

Reviewed-by: Christoph Hellwig <hch@lst.de>
