Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:17369 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750704AbaEHELg (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 8 May 2014 00:11:36 -0400
Date: Thu, 8 May 2014 12:11:24 +0800
From: Liu Bo <bo.li.liu@oracle.com>
To: David Disseldorp <ddiss@suse.de>
Cc: xfs@oss.sgi.com, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs/035: update clone test to expect EOPNOTSUPP
Message-ID: <20140508041123.GB3407@localhost.localdomain>
Reply-To: bo.li.liu@oracle.com
References: <1399465998-26545-1-git-send-email-ddiss@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1399465998-26545-1-git-send-email-ddiss@suse.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, May 07, 2014 at 02:33:18PM +0200, David Disseldorp wrote:
> With kernel commit 00fdf13a2e9f313a044288aa59d3b8ec29ff904a, the first
> clone-range overwrite attempt now fails with EOPNOTSUPP, rather than
> tripping a Btrfs BUG_ON().
> 
> This test now trips a new Btrfs bug, in which EIO is returned for
> subsequent reads following the second clone range ioctl.
> 

Hi David,

Something different here, I didn't get EI on 3.15.0-rc4.

thanks,
-liubo

> Signed-off-by: David Disseldorp <ddiss@suse.de>
> ---
>  tests/btrfs/035     | 11 +++++++++++
>  tests/btrfs/035.out |  5 +++++
>  2 files changed, 16 insertions(+)
> 
> diff --git a/tests/btrfs/035 b/tests/btrfs/035
> index 6808179..c9530f6 100755
> --- a/tests/btrfs/035
> +++ b/tests/btrfs/035
> @@ -57,21 +57,32 @@ src_str="aaaaaaaaaa"
>  echo -n "$src_str" > $SCRATCH_MNT/src
>  
>  $CLONER_PROG $SCRATCH_MNT/src  $SCRATCH_MNT/src.clone1
> +cat $SCRATCH_MNT/src.clone1
> +echo
>  
>  src_str="bbbbbbbbbbcccccccccc"
>  
>  echo -n "$src_str" > $SCRATCH_MNT/src
>  
>  $CLONER_PROG $SCRATCH_MNT/src $SCRATCH_MNT/src.clone2
> +cat $SCRATCH_MNT/src.clone2
> +echo
>  
> +# Prior to kernel commit 00fdf13a2e9f313a044288aa59d3b8ec29ff904a, this clone
> +# resulted in a BUG_ON in __btrfs_drop_extents(). The kernel now returns
> +# EOPNOTSUPP up to userspace.
>  snap_src_sz=`ls -lah $SCRATCH_MNT/src.clone1 | awk '{print $5}'`
>  echo "attempting ioctl (src.clone1 src)"
>  $CLONER_PROG -s 0 -d 0 -l ${snap_src_sz} \
>  	$SCRATCH_MNT/src.clone1 $SCRATCH_MNT/src
> +cat $SCRATCH_MNT/src
> +echo
>  
>  snap_src_sz=`ls -lah $SCRATCH_MNT/src.clone2 | awk '{print $5}'`
>  echo "attempting ioctl (src.clone2 src)"
>  $CLONER_PROG -s 0 -d 0 -l ${snap_src_sz} \
>  	$SCRATCH_MNT/src.clone2 $SCRATCH_MNT/src
> +# BUG: subsequent access attempts currently result in EIO...
> +cat $SCRATCH_MNT/src
>  
>  status=0 ; exit
> diff --git a/tests/btrfs/035.out b/tests/btrfs/035.out
> index f86cadf..0ea2c4f 100644
> --- a/tests/btrfs/035.out
> +++ b/tests/btrfs/035.out
> @@ -1,3 +1,8 @@
>  QA output created by 035
> +aaaaaaaaaa
> +bbbbbbbbbbcccccccccc
>  attempting ioctl (src.clone1 src)
> +clone failed: Operation not supported
> +bbbbbbbbbbcccccccccc
>  attempting ioctl (src.clone2 src)
> +bbbbbbbbbbcccccccccc
> -- 
> 1.8.4.5
> 
