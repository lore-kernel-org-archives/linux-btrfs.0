Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from ipmail06.adl2.internode.on.net ([150.101.137.129]:1652 "EHLO
	ipmail06.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751036Ab2GTAYj (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 19 Jul 2012 20:24:39 -0400
Date: Fri, 20 Jul 2012 10:24:33 +1000
From: Dave Chinner <david@fromorbit.com>
To: Liu Bo <liubo2009@cn.fujitsu.com>
Cc: xfs-oss <xfs@oss.sgi.com>, Linux Btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH] Xfstests/254: add more cases for testing btrfs snapshot
 in 254
Message-ID: <20120720002433.GH23387@dastard>
References: <5007E0FB.9040208@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <5007E0FB.9040208@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Jul 19, 2012 at 06:27:07PM +0800, Liu Bo wrote:
> From: Zhou Bo <zhoub-fnst@cn.fujitsu.com>
> 
> This patch adds more cases in 254 for testing btrfs snapshot.
> 
> Signed-off-by: Zhou Bo <zhoub-fnst@cn.fujitsu.com>

I think it is better to create a new test than modify the old one.
That way it is easy to tell the difference between a new failure and
regression.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
