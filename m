Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from ipmail04.adl6.internode.on.net ([150.101.137.141]:46589 "EHLO
	ipmail04.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755554AbbIUA3q (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 20 Sep 2015 20:29:46 -0400
Date: Mon, 21 Sep 2015 10:29:44 +1000
From: Dave Chinner <david@fromorbit.com>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: fstests@vger.kernel.org, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v6] fstests: btrfs: Add reserved space leak check for
 rewrite  dirty page
Message-ID: <20150921002944.GJ26895@dastard>
References: <1440574257-1544-1-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1440574257-1544-1-git-send-email-quwenruo@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Aug 26, 2015 at 03:30:57PM +0800, Qu Wenruo wrote:
> +# Use big blocksize to ensure there is still enough space left for metadata
> +# space reserve.
> +BLOCKSIZE=$(( 2 * 1024 * 1024 )) # 2M block size
> +FILESIZE=$(( 128 * 1024 * 1024 )) # 128M file size

Little thing in terms of style here: global variables that come from
the test harness use upper case, local test variabled should use
lowercase. It just makes it easy to see what variables have come
from the environment/test harness versus those that are used only by
the test.

I'll change this when I commit the patch....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
