Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:43423 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933384AbcBQJ4s (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 17 Feb 2016 04:56:48 -0500
Date: Wed, 17 Feb 2016 01:56:46 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: david@fromorbit.com, linux-btrfs@vger.kernel.org, fstests@vger.kernel.org,
        xfs@oss.sgi.com
Subject: Re: [PATCH 1/3] generic/304: fix high offset
Message-ID: <20160217095646.GA21482@infradead.org>
References: <20160215204608.7977.2802.stgit@birch.djwong.org>
 <20160215204614.7977.2848.stgit@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20160215204614.7977.2848.stgit@birch.djwong.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Feb 15, 2016 at 12:46:14PM -0800, Darrick J. Wong wrote:
> "Invalid argument" is a better response to an impossibly high offset
> dedupe request than "extents don't match", so change the test.

What does btrfs return here?
