Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 668B0342C88;
	Fri,  5 Jun 2026 04:08:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780632535; cv=none; b=IsStyWdyKxOBb/qYS/txzHGl2RO1Qi7HipemFrV7cqH6fXW7A9ZMm6LKCSeCg0tUd+wKQhXOn18+pRiHMNxxMzE7vZ4Qpb3YxV38HJ+Knu1tUl3EQcZ9AVE26nQc6fMSUH0cXzS4bBIpU10zko5NYyWfC5VY6GbLE1ctUpB13X8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780632535; c=relaxed/simple;
	bh=UjbohM8pA8T0+S3Dku44TnPyWFAP2ylOQ/oznnzQk30=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=a+lsGCRxpbtxD/tjQtm0ayTT3yr5VclbrZcze/1nXlOoocalefXyWoI+3hDTJLY8HL5gRzy1M/STok81Qe5fiMu23HzTCE5/BPpN6G2gyuTSC6ob4FaxNyJub+wiw361VQReKDEIss0TKzcHUpze6b+cmfYXTmzHxjvfWuudQQc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=QWbgUa/U; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="QWbgUa/U"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=5y9lBtoBOuM67qUaoiZvMuxp2Vfx+WGotUsK50zoiO0=; b=QWbgUa/Upthr6Bpj5FxEwteqWS
	vr6hy9FKMoDgk/yZ9NNbr7q5nkSkP9yihlPTgepuHEWBm0PA91IHnUBlLJJNy4io2SjC8X+53OZ64
	8+2IReF0B6+oYsNZbPgtyxfONQAO/dysKQTUJgXUAdljT0ed/H+RpNFAHAelUBxHvSLJFXN43e7wN
	YF5sxpNzDpuTIDQUTlrhjWPueZ1SKTQFmAQ/W81u/A2KU3GSBVzV/psEoZIrKjrztEW3UzqmteKdr
	BOJxf8zCh0yG2cpftXqSVHyhfppk9Km/Sd3prGHFi3Q40coHxAGBuiYxdXi7R5BT3zB6ipDKquqyN
	zOazToTA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wVLrY-00000000485-1kUI;
	Fri, 05 Jun 2026 04:08:52 +0000
Date: Thu, 4 Jun 2026 21:08:52 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Eric Sandeen <sandeen@redhat.com>
Cc: "fstests@vger.kernel.org" <fstests@vger.kernel.org>,
	linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs: use -f by default for mkfs as xfs/extN do
Message-ID: <aiJL1CBTV_N4YAtb@infradead.org>
References: <a31e9841-fd0c-435f-b376-86a7e01ddca7@redhat.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a31e9841-fd0c-435f-b376-86a7e01ddca7@redhat.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Tue, Jun 02, 2026 at 10:47:39PM -0500, Eric Sandeen wrote:
> Recently saw a case where testing ext4, xfs, then btrfs failed all
> btrfs tests because mkfs.btrfs refused to overwrite the left-over
> xfs filesystem on $SCRATCH_DEV.
> 
> This seems well-enough fixed by only making the change to _scratch_mkfs,
> but several other helper functions explicitly use -f / -F for xfs
> and extN, so I've updated them for btrfs as well.

I haven't run into this yet, but it seem like btrfs needs this.
But maybe you should also Cc the btrfs list?

> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> ---
> 
> TBH I'm a little baffled, has nobody really run into this before, or
> am I missing something?
> 
>  common/rc | 10 +++++-----
>  1 file changed, 5 insertions(+), 5 deletions(-)
> 
> diff --git a/common/rc b/common/rc
> index 9632b211..e77edf97 100644
> --- a/common/rc
> +++ b/common/rc
> @@ -871,7 +871,7 @@ _test_mkfs()
>          $MKFS_UDF_PROG $MKFS_OPTIONS $* $TEST_DEV > /dev/null
>  	;;
>      btrfs)
> -        $MKFS_BTRFS_PROG $MKFS_OPTIONS $* $TEST_DEV > /dev/null
> +        $MKFS_BTRFS_PROG -f $MKFS_OPTIONS $* $TEST_DEV > /dev/null
>  	;;
>      ext2|ext3|ext4)
>  	$MKFS_PROG -t $FSTYP -- -F $MKFS_OPTIONS $* $TEST_DEV
> @@ -920,7 +920,7 @@ _try_mkfs_dev()
>          $MKFS_UDF_PROG $MKFS_OPTIONS $*
>  	;;
>      btrfs)
> -        $MKFS_BTRFS_PROG $MKFS_OPTIONS $*
> +        $MKFS_BTRFS_PROG -f $MKFS_OPTIONS $*
>  	;;
>      ext2|ext3|ext4)
>  	$MKFS_PROG -t $FSTYP -- -F $MKFS_OPTIONS $*
> @@ -1010,7 +1010,7 @@ _scratch_mkfs()
>  		mkfs_filter="cat"
>  		;;
>  	btrfs)
> -		mkfs_cmd="$MKFS_BTRFS_PROG"
> +		mkfs_cmd="$MKFS_BTRFS_PROG -f"
>  		mkfs_filter="cat"
>  		;;
>  	ext3)
> @@ -1176,7 +1176,7 @@ _scratch_pool_mkfs()
>  {
>      case $FSTYP in
>      btrfs)
> -        $MKFS_BTRFS_PROG $MKFS_OPTIONS $* $SCRATCH_DEV_POOL > /dev/null
> +        $MKFS_BTRFS_PROG -f $MKFS_OPTIONS $* $SCRATCH_DEV_POOL > /dev/null
>          ;;
>      *)
>          echo "_scratch_pool_mkfs is not implemented for $FSTYP" 1>&2
> @@ -1369,7 +1369,7 @@ _try_scratch_mkfs_sized()
>  		# the device is not zoned. Ref: btrfs-progs: btrfs_min_dev_size()
>  		(( fssize < $((256 * 1024 * 1024)) )) &&
>  			! _scratch_btrfs_is_zoned && mixed_opt='--mixed'
> -		$MKFS_BTRFS_PROG $MKFS_OPTIONS $mixed_opt -b $fssize "$@" $SCRATCH_DEV
> +		$MKFS_BTRFS_PROG -f $MKFS_OPTIONS $mixed_opt -b $fssize "$@" $SCRATCH_DEV
>  		;;
>  	jfs)
>  		${MKFS_PROG} -t $FSTYP $MKFS_OPTIONS "$@" $SCRATCH_DEV $blocks
> -- 
> 2.54.0
> 
> 
---end quoted text---
