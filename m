Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from ipmail07.adl2.internode.on.net ([150.101.137.131]:52533 "EHLO
	ipmail07.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751404AbaIHKJN (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 8 Sep 2014 06:09:13 -0400
Date: Mon, 8 Sep 2014 20:08:59 +1000
From: Dave Chinner <david@fromorbit.com>
To: Eryu Guan <eguan@redhat.com>
Cc: fstests@vger.kernel.org, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 04/15 v2] btrfs: new case to run btrfs balance and
 remount with different compress algorithms
Message-ID: <20140908100859.GH30012@dastard>
References: <1409233676-22787-1-git-send-email-eguan@redhat.com>
 <1409233676-22787-5-git-send-email-eguan@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1409233676-22787-5-git-send-email-eguan@redhat.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Aug 28, 2014 at 09:47:45PM +0800, Eryu Guan wrote:
> Run btrfs balance and remount with different compress algorithms
> simultaneously, with fsstress running in background.
> 
> Signed-off-by: Eryu Guan <eguan@redhat.com>
> ---
>  common/rc           |  10 ++++
>  tests/btrfs/062     | 128 ++++++++++++++++++++++++++++++++++++++++++++++++++++
>  tests/btrfs/062.out |   2 +
>  tests/btrfs/group   |   1 +
>  4 files changed, 141 insertions(+)
>  create mode 100755 tests/btrfs/062
>  create mode 100644 tests/btrfs/062.out
> 
> diff --git a/common/rc b/common/rc
> index b0f5064..b5fc1c8 100644
> --- a/common/rc
> +++ b/common/rc
> @@ -2424,6 +2424,16 @@ _btrfs_stress_defrag()
>  	done
>  }
>  
> +_btrfs_stress_remount()
> +{
> +	local btrfs_mnt=$1
> +	while true; do
> +		for algo in no zlib lzo; do
> +			$MOUNT_PROG -o remount,compress=$algo $btrfs_mnt
> +		done
> +	done
> +}

This has nothing to do with "stress" - it tries 3
different compression algorithms. What is the purpose of
this (comments, please!), and can you us a more descriptive name?

> +# test case array
> +tcs=(
> +	"-m single -d single"
> +	"-m dup -d single"
> +	"-m raid0 -d raid0"
> +	"-m raid1 -d raid0"
> +	"-m raid1 -d raid1"
> +	"-m raid10 -d raid10"
> +	"-m raid5 -d raid5"
> +	"-m raid6 -d raid6"
> +)

This is pretty common, right? Perhaps this should be a config
variable that can be overridden by the config file configuration?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
