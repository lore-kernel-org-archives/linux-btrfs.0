Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from [198.137.202.9] ([198.137.202.9]:38354 "EHLO
	bombadil.infradead.org" rhost-flags-FAIL-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1750875AbcBMID5 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 13 Feb 2016 03:03:57 -0500
Date: Sat, 13 Feb 2016 00:03:21 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: Dave Chinner <david@fromorbit.com>, fstests@vger.kernel.org,
        linux-btrfs@vger.kernel.org, xfs@oss.sgi.com
Subject: Re: [PATCH v4.2 00/32] xfstests: test the nfs/cifs/btrfs/xfs
 reflink/dedupe ioctls
Message-ID: <20160213080321.GB2151@infradead.org>
References: <20160211233916.2202.40961.stgit@birch.djwong.org>
 <20160213012659.GA14668@dastard>
 <20160213043834.GC26204@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20160213043834.GC26204@birch.djwong.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Feb 12, 2016 at 08:38:34PM -0800, Darrick J. Wong wrote:
> > Followup patch, anyway, because I'm about to push out everything
> > that was in your second pull req (i.e. with the aiocp fix).
> 
> xfs_io "bmap -c" is a new switch that dumps the CoW fork of a file.
> AFAICT there isn't any way to check that an xfs_io command supports
> a particular switch, though it wouldn't be difficult to add a check.

Just test for it the same way we test for the existance of xfs_io
subcommmand.
