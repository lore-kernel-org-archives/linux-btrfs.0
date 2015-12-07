Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from ipmail04.adl6.internode.on.net ([150.101.137.141]:1037 "EHLO
	ipmail04.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755840AbbLGWMK (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 7 Dec 2015 17:12:10 -0500
Date: Tue, 8 Dec 2015 09:12:07 +1100
From: Dave Chinner <david@fromorbit.com>
To: Zhaolei <zhaolei@cn.fujitsu.com>
Cc: fstests@vger.kernel.org, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] fstests: Fix generic/102 fail for btrfs
Message-ID: <20151207221207.GF26718@dastard>
References: <56d7fca5e2f5dadceb4a3ec3d4589fec54da8d3b.1449137276.git.zhaolei@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <56d7fca5e2f5dadceb4a3ec3d4589fec54da8d3b.1449137276.git.zhaolei@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Dec 03, 2015 at 06:08:36PM +0800, Zhaolei wrote:
> From: Zhao Lei <zhaolei@cn.fujitsu.com>
> 
> generic/102 sometimes fails in newest btrfs toolchain,
> because it use non-mixed mode in default, which request more space
> for metadata, and no space for data writing.
> 
> This patch force mixed mode for btrfs in generic/102.
> 
> Signed-off-by: Zhao Lei <zhaolei@cn.fujitsu.com>
> ---
>  tests/generic/102 | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/tests/generic/102 b/tests/generic/102
> index abc3994..8c01fb5 100755
> --- a/tests/generic/102
> +++ b/tests/generic/102
> @@ -48,6 +48,8 @@ _require_scratch
>  
>  rm -f $seqres.full
>  
> +[[ "$FSTYP" = "btrfs" ]] && MKFS_OPTIONS+=" --mixed"
> +
>  dev_size=$((512 * 1024 * 1024))     # 512MB filesystem
>  _scratch_mkfs_sized $dev_size >>$seqres.full 2>&1

This sort of filesystem size specific mkfs requirement belongs in
the filesystem specific section of _scratch_mkfs_sized().

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
