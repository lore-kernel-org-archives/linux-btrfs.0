Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:49353 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751089Ab3G3DsE (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 29 Jul 2013 23:48:04 -0400
Message-ID: <51F7377A.9090707@oracle.com>
Date: Tue, 30 Jul 2013 11:48:10 +0800
From: Jeff Liu <jeff.liu@oracle.com>
MIME-Version: 1.0
To: Josef Bacik <jbacik@fusionio.com>
CC: linux-btrfs@vger.kernel.org, xfs@oss.sgi.com, sandeen@redhat.com
Subject: Re: [PATCH] xfstests: generic/315: allow a little tolerance for our
 used check
References: <1375124156-17620-1-git-send-email-jbacik@fusionio.com>
In-Reply-To: <1375124156-17620-1-git-send-email-jbacik@fusionio.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 07/30/2013 02:55 AM, Josef Bacik wrote:

> So df in btrfs is tricky at best, and relying on it for accurate information is
> not great, but it's the best way to verify this test.  To get around btrfs being
> inconsistent sometimes just use _within_tolerance to check our new df value to
> make sure that our truncate did something.  With this patch I no longer see
> transient failures of this test.  Thanks,
> 
> Signed-off-by: Josef Bacik <jbacik@fusionio.com>
> ---
>  tests/generic/315 |    3 ++-
>  1 files changed, 2 insertions(+), 1 deletions(-)
> 
> diff --git a/tests/generic/315 b/tests/generic/315
> index 7cfc40d..9c01b5e 100644
> --- a/tests/generic/315
> +++ b/tests/generic/315
> @@ -73,7 +73,8 @@ sync
>  
>  # Preallocated disk space should be released
>  avail_done=`df -P $TEST_DIR | awk 'END {print $4}'`
> -[ "$avail_done" -eq "$avail_begin" ] || _fail "Available disk space ($avail_done KiB)"
> +_within_tolerance "df" $avail_done $avail_begin 1%
> +[ $? -eq 0 ] || _fail "Available disk space ($avail_done KiB) wanted ($avail_begin KiB)"

Looks good to me.
Reviewed-by: Jie Liu <jeff.liu@oracle.com>

Thanks,
-Jeff
