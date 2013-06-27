Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:42473 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751522Ab3F0DSz (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 26 Jun 2013 23:18:55 -0400
Message-ID: <51CBB022.7010703@oracle.com>
Date: Thu, 27 Jun 2013 11:23:14 +0800
From: Anand Jain <Anand.Jain@oracle.com>
MIME-Version: 1.0
To: Josef Bacik <jbacik@fusionio.com>
CC: xfs@oss.sgi.com, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] xfstests: fix btrfs/264 to not use the scratch dev pool
References: <1372261976-11426-1-git-send-email-jbacik@fusionio.com>
In-Reply-To: <1372261976-11426-1-git-send-email-jbacik@fusionio.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>




  Reviewed-by: Anand Jain <anand.jain@oracle.com>


On 06/26/2013 11:52 PM, Josef Bacik wrote:
> This test doesn't need the scratch dev pool and it also doesn't call
> _require_scratch_dev_pool, so just kick out the scratch dev pool part of the
> test.  Thanks,
>
> Signed-off-by: Josef Bacik <jbacik@fusionio.com>
> ---
>   tests/btrfs/264 |    2 +-
>   1 files changed, 1 insertions(+), 1 deletions(-)
>
> diff --git a/tests/btrfs/264 b/tests/btrfs/264
> index b08667a..8eef43b 100755
> --- a/tests/btrfs/264
> +++ b/tests/btrfs/264
> @@ -46,7 +46,7 @@ _supported_fs btrfs
>   _supported_os Linux
>   _require_scratch
>
> -_scratch_mkfs $SCRATCH_DEV_POOL > /dev/null 2>&1 || _fail "mkfs failed"
> +_scratch_mkfs > /dev/null 2>&1 || _fail "mkfs failed"
>   _scratch_mount
>
>   # Create and save sha256sum
>
