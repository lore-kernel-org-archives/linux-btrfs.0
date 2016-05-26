Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:43414 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751134AbcEZIYZ (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 26 May 2016 04:24:25 -0400
Date: Thu, 26 May 2016 01:24:23 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: david@fromorbit.com, fstests@vger.kernel.org,
        Christoph Hellwig <hch@lst.de>, linux-btrfs@vger.kernel.org,
        xfs@oss.sgi.com
Subject: Re: [PATCH 5/7] reflink: test interaction with swap files
Message-ID: <20160526082423.GC10683@infradead.org>
References: <146424222237.6278.4174636124436241002.stgit@birch.djwong.org>
 <146424225618.6278.13884344251723851779.stgit@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <146424225618.6278.13884344251723851779.stgit@birch.djwong.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, May 25, 2016 at 10:57:36PM -0700, Darrick J. Wong wrote:
> Since none of the current filesystems support reflinked swap files,
> make sure that we prohibit reflinking of swapfiles and swapon of
> reflinked files.

Ah, thanks.  I've actually prepared a patch to fix swapon in the kernel
and was about to start writing test cases for it.  I hope you haven't
also done the kernel work already :)

Reviewed-by: Christoph Hellwig <hch@lst.de>
