Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:43419 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751134AbcEZIYu (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 26 May 2016 04:24:50 -0400
Date: Thu, 26 May 2016 01:24:49 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: david@fromorbit.com, fstests@vger.kernel.org, linux-btrfs@vger.kernel.org,
        xfs@oss.sgi.com
Subject: Re: [PATCH 7/7] reflink: test changing sharers of a block while
 keeping refcount the same
Message-ID: <20160526082449.GD10683@infradead.org>
References: <146424222237.6278.4174636124436241002.stgit@birch.djwong.org>
 <146424226985.6278.9226931712470818344.stgit@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <146424226985.6278.9226931712470818344.stgit@birch.djwong.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Looks fine,

Reviewed-by: Christoph Hellwig <hch@lst.de>
