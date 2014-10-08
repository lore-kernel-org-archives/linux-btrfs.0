Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from ipmail04.adl6.internode.on.net ([150.101.137.141]:30320 "EHLO
	ipmail04.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750735AbaJHEUt (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 8 Oct 2014 00:20:49 -0400
Date: Wed, 8 Oct 2014 15:20:43 +1100
From: Dave Chinner <david@fromorbit.com>
To: Wang Shilong <wangshilong1991@gmail.com>
Cc: fstests@vger.kernel.org, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 2/2] xfstests,btrfs/004: use FILEFRAG_PROG macro
Message-ID: <20141008042043.GG12693@dastard>
References: <1412764522-15754-1-git-send-email-wangshilong1991@gmail.com>
 <1412764522-15754-2-git-send-email-wangshilong1991@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1412764522-15754-2-git-send-email-wangshilong1991@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Oct 08, 2014 at 06:35:22AM -0400, Wang Shilong wrote:
> Signed-off-by: Wang Shilong <wangshilong1991@gmail.com>
> ---
> i didn't find a way to remove filefrag here, but let us
> use macro firstly...

YOu shoul dbe able to use fiemap to calculate the same output.
i.e. _check_file_extents() outputs a strings of the format 
#physical#length#logical#flags and this is then cut up later
later by the test. fiemap outputs the same information,
it just requires slightly different processing via the
_filter_extents function to munge it into the same format...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
