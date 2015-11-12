Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:49538 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752818AbbKLRgl (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 12 Nov 2015 12:36:41 -0500
Date: Thu, 12 Nov 2015 09:36:35 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: Christoph Hellwig <hch@infradead.org>, david@fromorbit.com,
        fstests@vger.kernel.org, xfs@oss.sgi.com, tao.peng@primarydata.com,
        linux-ext4@vger.kernel.org, Anna.Schumaker@netapp.com,
        linux-btrfs@vger.kernel.org
Subject: Re: [RFCv3.1 00/11] xfstests: test the nfs/cifs/btrfs/xfs
 reflink/dedupe ioctls
Message-ID: <20151112173635.GA9247@infradead.org>
References: <20151111192628.15056.6451.stgit@birch.djwong.org>
 <20151112090756.GA25685@infradead.org>
 <20151112125115.GA28822@infradead.org>
 <20151112173427.GC2217@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20151112173427.GC2217@birch.djwong.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Nov 12, 2015 at 09:34:27AM -0800, Darrick J. Wong wrote:
> Bleargh, _require_*_dedupe forgot to check for ENOTTY output, so all the dedupe
> tests should have _notrun.
> 
> Also, generic/806 was calling the wrong _require.
> 
> I'll start renumbering tests; Christoph, did you see anything else?

Looks fine so far otherwise.
