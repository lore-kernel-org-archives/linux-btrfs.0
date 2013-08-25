Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:38440 "EHLO sandeen.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755479Ab3HYQyd (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 25 Aug 2013 12:54:33 -0400
Message-ID: <521A36C6.40006@sandeen.net>
Date: Sun, 25 Aug 2013 11:54:30 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
To: chandan <chandan@linux.vnet.ibm.com>
CC: linux-btrfs@vger.kernel.org, xfs@oss.sgi.com, sekharan@linux.vnet.ibm.com
Subject: Re: [PATCH] xfstests: generic/255: Execute only if blocksize <= 4096
References: <2909046.09LYLQvZ6q@localhost.localdomain>
In-Reply-To: <2909046.09LYLQvZ6q@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 8/25/13 10:06 AM, chandan wrote:
> The patch adds the function _require_le_4k_blocksize to perform the
> block size check on $TEST_DEV and $SCRATCH_DEV.
> 
> Signed-off-by: chandan <chandan@linux.vnet.ibm.com>

Can you explain why this is necessary?

What failures do you see, on what filesystems?

That kind of info needs to be in the changelog so reviewers
can understand the need for the change (and to be sure
it's not papering over an actual bug for block sizes
> 4k...)

Thanks,
-Eric

> ---
>  common/rc         | 10 ++++++++++
>  tests/generic/255 |  1 +
>  2 files changed, 11 insertions(+)
> 
> diff --git a/common/rc b/common/rc
> index ae80b12..d8ee132 100644
> --- a/common/rc
> +++ b/common/rc
> @@ -2106,6 +2106,16 @@ _require_dumpe2fs()
>  	fi
>  }
>  
> +_require_le_4k_blocksize()
> +{
> +	test_dev_bs=`stat -f $TEST_DEV | grep "Block size" | cut -d " " -f3`
> +	scratch_dev_bs=`stat -f $SCRATCH_DEV | grep "Block size" | cut -d " " -f3`
> +
> +	if (( $test_dev_bs > 4096 || $scratch_dev_bs > 4096 )); then
> +		_notrun "This test requires a filesystem with a block size less than or equal to 4k."
> +	fi
> +}
> +
>  _create_loop_device()
>  {
>  	file=$1
> diff --git a/tests/generic/255 b/tests/generic/255
> index dd329b4..763e861 100755
> --- a/tests/generic/255
> +++ b/tests/generic/255
> @@ -49,6 +49,7 @@ _supported_os Linux
>  _require_xfs_io_falloc_punch
>  _require_xfs_io_falloc
>  _require_xfs_io_fiemap
> +_require_le_4k_blocksize
>  
>  testfile=$TEST_DIR/255.$$
>  
> 

