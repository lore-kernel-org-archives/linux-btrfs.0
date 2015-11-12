Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:55485 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753976AbbKLJIC (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 12 Nov 2015 04:08:02 -0500
Date: Thu, 12 Nov 2015 01:07:56 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: hch@infradead.org, david@fromorbit.com, fstests@vger.kernel.org,
        xfs@oss.sgi.com, tao.peng@primarydata.com, linux-ext4@vger.kernel.org,
        Anna.Schumaker@netapp.com, linux-btrfs@vger.kernel.org
Subject: Re: [RFCv3.1 00/11] xfstests: test the nfs/cifs/btrfs/xfs
 reflink/dedupe ioctls
Message-ID: <20151112090756.GA25685@infradead.org>
References: <20151111192628.15056.6451.stgit@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20151111192628.15056.6451.stgit@birch.djwong.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Looks fine:

Acked-by: Christoph Hellwig <hch@lst.de>

some of the free block range stuff might need minor fixups for certain
file systems later, but I'd rather do this once all the patches are
merged.
