Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from ipmail06.adl2.internode.on.net ([150.101.137.129]:60374 "EHLO
	ipmail06.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755048AbcB1W32 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 28 Feb 2016 17:29:28 -0500
Date: Mon, 29 Feb 2016 09:29:25 +1100
From: Dave Chinner <david@fromorbit.com>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: fstests@vger.kernel.org, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v2 RESEND 3/5] fstests: btrfs: Add testcase for btrfs
 dedup enable disable race test
Message-ID: <20160228222925.GB29057@dastard>
References: <1456301196-15874-1-git-send-email-quwenruo@cn.fujitsu.com>
 <1456301196-15874-4-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1456301196-15874-4-git-send-email-quwenruo@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Feb 24, 2016 at 04:06:34PM +0800, Qu Wenruo wrote:
> +
> +fsstress_work &
> +fsstress_pid=$!
> +
> +trigger_work &
> +trigger_pid=$!
> +
> +wait $fsstress_pid
> +kill $trigger_pid
> +wait

Maximum bound runtime based on $TIME_FACTOR would be better, rather
than having to wait for fsstress to complete.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
