Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from ipmail04.adl6.internode.on.net ([150.101.137.141]:2393 "EHLO
	ipmail04.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751450AbcELBUJ (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 11 May 2016 21:20:09 -0400
Date: Thu, 12 May 2016 11:19:55 +1000
From: Dave Chinner <david@fromorbit.com>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: "Darrick J. Wong" <darrick.wong@oracle.com>, fdmanana@gmail.com,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
        fstests@vger.kernel.org
Subject: Re: [PATCH] fstests: btrfs: Test fiemap ioctl on completely deduped
 file
Message-ID: <20160512011955.GM26977@dastard>
References: <1462869581-19227-1-git-send-email-quwenruo@cn.fujitsu.com>
 <CAL3q7H5Mn2561cxK49vis3+XW1eTzx_j9h-iQpUJQ6qEGMczvQ@mail.gmail.com>
 <55ce1c42-fda3-520f-ebb1-11048df8799f@cn.fujitsu.com>
 <20160512002318.GA6621@birch.djwong.org>
 <622d94a3-307f-0a3d-a38f-a2127c3bc8cb@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <622d94a3-307f-0a3d-a38f-a2127c3bc8cb@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, May 12, 2016 at 08:46:41AM +0800, Qu Wenruo wrote:
> >Filesystem type is: 58465342
> >File size of a is 262144 (64 blocks of 4096 bytes)
> > ext:     logical_offset:        physical_offset: length:   expected: flags:
> >   0:        0..      31:         24..        55:     32:             shared
> >   1:       32..      63:         24..        55:     32:         56: last,shared,eof
> 
> Also the "shared" flag is different from btrfs, where btrfs is
> wrong, and the btrfs routine to check shared extent caused the soft
> lockup.
> 
> I originally planned to check "shared" flag, but the soft lockup is
> more important, and 8000+ output seems not suitable as golden
> output.

If that's what the test produces for correct behaviour, then there
isn't any problem with having golden output that large. e.g.
tests/xfs/136.out has 7800 lines in its golden output file. There
are quite a few tests with large amounts of output:

$ find . -name *.out -exec ls -s {} \; |sort -nr |head -5
144 ./tests/xfs/136.out
124 ./tests/generic/324.out
120 ./tests/xfs/165.out
116 ./tests/xfs/107.out
92 ./tests/btrfs/034.out
$

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
