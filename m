Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:43577 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751821AbcCFWKV (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sun, 6 Mar 2016 17:10:21 -0500
Date: Sun, 6 Mar 2016 14:09:35 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: david@fromorbit.com, linux-ext4@vger.kernel.org, fstests@vger.kernel.org,
        linux-btrfs@vger.kernel.org, xfs@oss.sgi.com
Subject: Re: [PATCH 13/12] xfs/209: filter scratch dir properly
Message-ID: <20160306220935.GB27960@birch.djwong.org>
References: <20160305003717.28738.98818.stgit@birch.djwong.org>
 <20160305202502.GI10245@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20160305202502.GI10245@infradead.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Good catch,
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

On Sat, Mar 05, 2016 at 12:25:02PM -0800, Christoph Hellwig wrote:
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> 
> diff --git a/tests/xfs/209 b/tests/xfs/209
> index cecd9c7..9bf1f12 100755
> --- a/tests/xfs/209
> +++ b/tests/xfs/209
> @@ -73,7 +73,7 @@ echo "Check cowextsize settings"
>  seq 1 2 | while read nr; do
>  	seq 1 4 | while read nnr; do
>  		file="$testdir/dir-$nr/file-$nnr"
> -		$XFS_IO_PROG -c "cowextsize" $file
> +		$XFS_IO_PROG -c "cowextsize" $file | _filter_scratch
>  	done
>  done
>  
> diff --git a/tests/xfs/209.out b/tests/xfs/209.out
> index 109af34..b97fa96 100644
> --- a/tests/xfs/209.out
> +++ b/tests/xfs/209.out
> @@ -3,11 +3,11 @@ Format and mount
>  Set extsz and cowextsz on directory
>  Create a fake tree structure
>  Check cowextsize settings
> -[1048576] /opt/test-209/dir-1/file-1
> -[1048576] /opt/test-209/dir-1/file-2
> -[1048576] /opt/test-209/dir-1/file-3
> -[1048576] /opt/test-209/dir-1/file-4
> -[1048576] /opt/test-209/dir-2/file-1
> -[1048576] /opt/test-209/dir-2/file-2
> -[1048576] /opt/test-209/dir-2/file-3
> -[1048576] /opt/test-209/dir-2/file-4
> +[1048576] SCRATCH_MNT/test-209/dir-1/file-1
> +[1048576] SCRATCH_MNT/test-209/dir-1/file-2
> +[1048576] SCRATCH_MNT/test-209/dir-1/file-3
> +[1048576] SCRATCH_MNT/test-209/dir-1/file-4
> +[1048576] SCRATCH_MNT/test-209/dir-2/file-1
> +[1048576] SCRATCH_MNT/test-209/dir-2/file-2
> +[1048576] SCRATCH_MNT/test-209/dir-2/file-3
> +[1048576] SCRATCH_MNT/test-209/dir-2/file-4
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
