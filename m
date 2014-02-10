Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from ipmail06.adl6.internode.on.net ([150.101.137.145]:46284 "EHLO
	ipmail06.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750890AbaBJWEH (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 10 Feb 2014 17:04:07 -0500
Date: Tue, 11 Feb 2014 09:04:00 +1100
From: Dave Chinner <david@fromorbit.com>
To: Koen De Wit <koen.de.wit@oracle.com>
Cc: xfs@oss.sgi.com, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v3] xfstests: Btrfs: add test for large metadata blocks
Message-ID: <20140210220400.GV13647@dastard>
References: <1392068362-14049-1-git-send-email-koen.de.wit@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1392068362-14049-1-git-send-email-koen.de.wit@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Feb 10, 2014 at 10:39:22PM +0100, Koen De Wit wrote:
> Tests Btrfs filesystems with all possible metadata block sizes, by
> setting large extended attributes on files.
> 
> Signed-off-by: Koen De Wit <koen.de.wit@oracle.com>
....
> +
> +_test_illegal_leafsize() {
> +        _scratch_mkfs -l $1 >>$seqres.full 2>&1
> +        [ $? -ne 0 ] || _fail "'$1' is an illegal value for the" \
> +                "leafsize option, mkfs should have failed."
> +}

You just re-implemented run_check....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
