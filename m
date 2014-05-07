Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from ipmail05.adl6.internode.on.net ([150.101.137.143]:56533 "EHLO
	ipmail05.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750884AbaEGWoR (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 7 May 2014 18:44:17 -0400
Date: Thu, 8 May 2014 08:44:13 +1000
From: Dave Chinner <david@fromorbit.com>
To: Josef Bacik <jbacik@fb.com>
Cc: linux-btrfs@vger.kernel.org, xfs@oss.sgi.com
Subject: Re: [PATCH] xfstests: fix flink test
Message-ID: <20140507224413.GQ5421@dastard>
References: <1399496087-20431-1-git-send-email-jbacik@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1399496087-20431-1-git-send-email-jbacik@fb.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, May 07, 2014 at 04:54:47PM -0400, Josef Bacik wrote:
> I don't have flink support in my xfsprogs, but it doesn't fail with "command not
> found" or whatever, it fails because I don't have the -T option.  So fix
> _require_xfs_io_command to check for an invalid option and not run.  This way I
> get notrun instead of a failure.  Thanks,
> 
> Signed-off-by: Josef Bacik <jbacik@fb.com>
> ---
>  common/rc | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/common/rc b/common/rc
> index 5c13db5..4fa7e63 100644
> --- a/common/rc
> +++ b/common/rc
> @@ -1258,6 +1258,8 @@ _require_xfs_io_command()
>  		_notrun "xfs_io $command support is missing"
>  	echo $testio | grep -q "Operation not supported" && \
>  		_notrun "xfs_io $command failed (old kernel/wrong fs?)"
> +	echo $testio | grep -q "invalid option" && \
> +		_notrun "xfs_io $command support is missing"
>  }

Yeah, looks like it throws a different error - it treats -T as an
option, not a command. Rather than multiple checks that result in
the same error, why not just:

-	echo $testio | grep -q "not found" && \
+	echo $testio | egrep -q 'not found|invalid option' && \
                _notrun "xfs_io $command support is missing"

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
