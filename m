Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from ipmail04.adl6.internode.on.net ([150.101.137.141]:44967 "EHLO
	ipmail04.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751561AbbEEXMx (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 5 May 2015 19:12:53 -0400
Date: Wed, 6 May 2015 09:11:30 +1000
From: Dave Chinner <david@fromorbit.com>
To: Anand Jain <anand.jain@oracle.com>
Cc: fstests@vger.kernel.org, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 2/3] xfstests: btrfs: test device replace, with EIO on
 the src dev
Message-ID: <20150505231130.GM15810@dastard>
References: <1430388527-16700-1-git-send-email-anand.jain@oracle.com>
 <1430388527-16700-3-git-send-email-anand.jain@oracle.com>
 <20150505001412.GJ15810@dastard>
 <5548DE28.6070209@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <5548DE28.6070209@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, May 05, 2015 at 11:13:44PM +0800, Anand Jain wrote:
> 
> Dave,
> 
>  Thanks for comments. I am rewriting it.
> 
>  But any idea why should _scratch_mkfs_dmerror (below) should
>  fail with one of the device in SCRATCH_DEV_POOL being busy.?
>  (when I start the script non of the device provided is actually
>  busy).

$SCRATCH_DEV is the first device in $SCRATCH_DEV_POOL, right?

> +SCRATCH_DEV_POOL_DEV1="`echo $SCRATCH_DEV_POOL | $AWK_PROG '{print $1}'`"
> +SCRATCH_DEV_POOL_DEV2="`echo $SCRATCH_DEV_POOL | $AWK_PROG '{print $2}'`"

BTW, don't shout so much in your code: dev1 and dev2 are perfectly
good local variable names. In general, local variables are in lower
case, global/exported variables are in upper case.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
