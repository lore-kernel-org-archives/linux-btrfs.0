Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:34387 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752502AbbJOJTv (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 15 Oct 2015 05:19:51 -0400
Date: Thu, 15 Oct 2015 02:19:44 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: david@fromorbit.com, fstests@vger.kernel.org, linux-ext4@vger.kernel.org,
        Anna.Schumaker@netapp.com, linux-btrfs@vger.kernel.org,
        xfs@oss.sgi.com
Subject: Re: [PATCH 03/12] generic/80[0-2]: support xfs in addition to btrfs
Message-ID: <20151015091944.GA13683@infradead.org>
References: <20151007051257.3260.73072.stgit@birch.djwong.org>
 <20151007051323.3260.60421.stgit@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20151007051323.3260.60421.stgit@birch.djwong.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

> +# this test requires the test fs support reflink...
> +#
> +_require_test_reflink()
> +{
> +    case $FSTYP in
> +    xfs)
> +	xfs_info "${TEST_DIR}" | grep reflink=1 -c -q || _notrun "Reflink not supported by this filesystem type: $FSTYP"
> +	;;
> +    btrfs)
> +        true
> +        ;;
> +    *)
> +        _notrun "Reflink not supported by this filesystem type: $FSTYP"
> +        ;;
> +    esac

I don't think that's a good test - we need to check if it's supported by
trying it.  That'll automatically get us coverage for other file systems
like xfs.

Note that dedup should get it's own feature check, as currently hacking
nfs into this check will also run dedup tests that can't really be
supported.
