Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from ipmail05.adl6.internode.on.net ([150.101.137.143]:55054 "EHLO
	ipmail05.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751672Ab3B0XEr (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 27 Feb 2013 18:04:47 -0500
Date: Thu, 28 Feb 2013 10:04:43 +1100
From: Dave Chinner <david@fromorbit.com>
To: Wang Sheng-Hui <shhuiw@gmail.com>
Cc: xfstests <xfs@oss.sgi.com>, linux-btrfs@vger.kernel.org,
        list.btrfs@jan-o-sch.net
Subject: Re: [PATCH] xfstests 276: fix error 'FIBMAP: Invalid argument'
Message-ID: <20130227230443.GB5551@dastard>
References: <512DB284.1090806@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <512DB284.1090806@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Feb 27, 2013 at 03:15:16PM +0800, Wang Sheng-Hui wrote:
> Btrfs doesn't support FIEMAP_FLAG_XATTR, which is enabled by
> -x option of filefrag, and will fail with
> 	'FIBMAP: Invalid argument'
> for 'filefrag -vx'. 'filefrag -vx' fails on btrfs with
>     'FIEMAP failed with unsupported flags 2'
> Remove the '-x' option.
> 
> Signed-off-by: Wang Sheng-Hui <shhuiw@gmail.com>

I can see that this changes what gets dumped into the $seq.full
file, but it seems to me that also changes the extent list returned
to the checking functions. So either the test previously worked and
now it fails with this change, or the test never worked and now it
does, or perhaps something else?

IOWs, I can't tell why you want to change this from the patch
description, hence I don't know if the original behaviour was
intentional or not.  Can you say describe what the overall effect of
the change is in the commit description?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
