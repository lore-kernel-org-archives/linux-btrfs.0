Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from ipmail06.adl6.internode.on.net ([150.101.137.145]:33640 "EHLO
	ipmail06.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751524Ab3K0EPQ (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 26 Nov 2013 23:15:16 -0500
Date: Wed, 27 Nov 2013 15:14:49 +1100
From: Dave Chinner <david@fromorbit.com>
To: Miao Xie <miaox@cn.fujitsu.com>
Cc: xfs@oss.sgi.com, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v3] xfstests,btrfs: add wrong compress type regression
 test
Message-ID: <20131127041449.GG10988@dastard>
References: <20131126064107.GN8803@dastard>
 <1385449223-28748-1-git-send-email-miaox@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1385449223-28748-1-git-send-email-miaox@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Nov 26, 2013 at 03:00:23PM +0800, Miao Xie wrote:
> Btrfs would crash when the users wrote some data into a file with compress
> flag but the compression of the fs was disabled. This test case is to check
> this bug still happen or not.
> 
> Signed-off-by: Miao Xie <miaox@cn.fujitsu.com>

Looks good now.

Reviewed-by: Dave Chinner <dchinner@redhat.com>
-- 
Dave Chinner
david@fromorbit.com
