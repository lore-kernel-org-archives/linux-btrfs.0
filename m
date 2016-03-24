Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:45806 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757210AbcCXLHb (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 24 Mar 2016 07:07:31 -0400
Date: Thu, 24 Mar 2016 19:07:18 +0800
From: Eryu Guan <eguan@redhat.com>
To: Anand Jain <anand.jain@oracle.com>
Cc: fstests@vger.kernel.org, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] fstest: btrfs: remove _need_to_be_root fix btrfs/118
Message-ID: <20160324110718.GS11419@eguan.usersys.redhat.com>
References: <1458814439-6418-1-git-send-email-anand.jain@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1458814439-6418-1-git-send-email-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Mar 24, 2016 at 06:13:59PM +0800, Anand Jain wrote:
> commit 56ff01f471c9b72de0a447b37cdb1051adcede6a
>     xfstests: remove _need_to_be_root
> 
> Removed _need_to_be_root(), and so btrfs/118 needs an update

It has been fixed by
3a92426 btrfs/118: remove call to _need_to_be_root

Perhaps you need to update your repository :)

Thanks,
Eryu

> 
> Signed-off-by: Anand Jain <anand.jain@oracle.com>
> ---
>  tests/btrfs/118 | 1 -
>  1 file changed, 1 deletion(-)
> 
> diff --git a/tests/btrfs/118 b/tests/btrfs/118
> index 3ed1cbef1068..740cb92b0669 100755
> --- a/tests/btrfs/118
> +++ b/tests/btrfs/118
> @@ -45,7 +45,6 @@ _cleanup()
>  . ./common/dmflakey
>  
>  # real QA test starts here
> -_need_to_be_root
>  _supported_fs btrfs
>  _supported_os Linux
>  _require_scratch
> -- 
> 2.7.0
> 
> --
> To unsubscribe from this list: send the line "unsubscribe fstests" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
