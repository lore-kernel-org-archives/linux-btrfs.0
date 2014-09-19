Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pd0-f173.google.com ([209.85.192.173]:61930 "EHLO
	mail-pd0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751008AbaISGhw (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 19 Sep 2014 02:37:52 -0400
Received: by mail-pd0-f173.google.com with SMTP id ft15so2984304pdb.32
        for <linux-btrfs@vger.kernel.org>; Thu, 18 Sep 2014 23:37:52 -0700 (PDT)
Date: Fri, 19 Sep 2014 14:37:48 +0800
From: Eryu Guan <guaneryu@gmail.com>
To: Liu Bo <bo.li.liu@oracle.com>
Cc: xfs@oss.sgi.com, linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH] xfstests: remove check_scratch_fs in btrfs/012
Message-ID: <20140919063748.GA13950@dhcp-13-216.nay.redhat.com>
References: <1409714759-9805-1-git-send-email-bo.li.liu@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1409714759-9805-1-git-send-email-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Sep 03, 2014 at 11:25:59AM +0800, Liu Bo wrote:
> From: Liu Bo <liub.liubo@gmail.com>
> 
> btrfs/012 is a case to verify btrfs-convert feature, it converts an ext4 to
> btrfs firstly and do something, then rolls back to ext4.
> 
> So at last we have a ext4 on the scratch device, but setting _require_scratch
> will force a btrfsck on a ext4 fs because $FSTYP here is btrfs, and it ends up
> with a failure report of _check_btrfs_filesystem.
> 
> Now that we have deliberately check the final ext4 fs in btrfs/012, just do not
> set _require_scratch in this case.
> 
> Signed-off-by: Liu Bo <liub.liubo@gmail.com>
> ---
>  tests/btrfs/012 | 1 -
>  1 file changed, 1 deletion(-)
> 
> diff --git a/tests/btrfs/012 b/tests/btrfs/012
> index f7e5da5..12f6462 100755
> --- a/tests/btrfs/012
> +++ b/tests/btrfs/012
> @@ -52,7 +52,6 @@ _cleanup()
>  # Modify as appropriate.
>  _supported_fs btrfs
>  _supported_os Linux
> -_require_scratch

The test still requires a scratch device, so we cannot simply remove
this line. Now we can use _require_scratch_nocheck helper, and it
works fine based on my test.

Thanks,
Eryu

>  
>  BTRFS_CONVERT_PROG="`set_prog_path btrfs-convert`"
>  MKFS_EXT4_PROG="`set_prog_path mkfs.ext4`"
> -- 
> 1.8.1.4
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs
