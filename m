Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:52201 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751847AbbKLMvV (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 12 Nov 2015 07:51:21 -0500
Date: Thu, 12 Nov 2015 04:51:15 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: david@fromorbit.com, fstests@vger.kernel.org, xfs@oss.sgi.com,
        tao.peng@primarydata.com, linux-ext4@vger.kernel.org,
        Anna.Schumaker@netapp.com, linux-btrfs@vger.kernel.org
Subject: Re: [RFCv3.1 00/11] xfstests: test the nfs/cifs/btrfs/xfs
 reflink/dedupe ioctls
Message-ID: <20151112125115.GA28822@infradead.org>
References: <20151111192628.15056.6451.stgit@birch.djwong.org>
 <20151112090756.GA25685@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20151112090756.GA25685@infradead.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Nov 12, 2015 at 01:07:56AM -0800, Christoph Hellwig wrote:
> Looks fine:
> 
> Acked-by: Christoph Hellwig <hch@lst.de>

Actually I take this back.  I had though this was the existing series
with my fixes, but this one still incorrectly assumes that if reflink
works dedup works as well, leading to lots of false failures on nfs.
