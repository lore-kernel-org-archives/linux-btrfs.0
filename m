From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 2/2] xfstests: meet btrfs fs size requirement in
 _scratch_mkfs_sized()
Date: Fri, 4 Nov 2011 01:39:08 -0400
Message-ID: <20111104053908.GB16720@infradead.org>
References: <1320374284-1534-1-git-send-email-guaneryu@gmail.com>
 <1320374284-1534-2-git-send-email-guaneryu@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: xfs@oss.sgi.com, linux-btrfs@vger.kernel.org
To: Eryu Guan <guaneryu@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1320374284-1534-2-git-send-email-guaneryu@gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Nov 04, 2011 at 10:38:04AM +0800, Eryu Guan wrote:
> btrfs requires at least 256M file system size, so check 'fssize' in
> _scratch_mkfs_sized first and give it a proper value. Otherwise
> mkfs.btrfs will complain something like
> 
> "File system size 267386880 bytes is too small, 256M is required at least"
> 
> This makes 015 077 and 083 run on btrfs.

But it's not really going to test the ENOSPC conditions it was designed
to exercise.  It would be better to either find a way to make btrfs run on
smaller filesystem, or call _notrun for too small filesystems on btrfs
from _scratch_mkfs_sized.

> 
> Signed-off-by: Eryu Guan <guaneryu@gmail.com>
> ---
>  common.rc |    5 +++++
>  1 files changed, 5 insertions(+), 0 deletions(-)
> 
> diff --git a/common.rc b/common.rc
> index e948169..ab61786 100644
> --- a/common.rc
> +++ b/common.rc
> @@ -356,6 +356,11 @@ _scratch_mkfs_sized()
>  	/sbin/mkfs.$FSTYP $MKFS_OPTIONS -b $blocksize $SCRATCH_DEV $blocks
>  	;;
>      btrfs)
> +    # btrfs needs at least 256M file system size
> +	if [ $fssize -lt $((256*1024*1024)) ]
> +	then
> +		fssize=$((256*1024*1024))
> +	fi
>  	$MKFS_BTRFS_PROG $MKFS_OPTIONS -b $fssize $SCRATCH_DEV
>  	;;
>      *)
> -- 
> 1.7.7.1
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs
---end quoted text---
