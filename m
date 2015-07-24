Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:57867 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752432AbbGXDBO (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 23 Jul 2015 23:01:14 -0400
Date: Fri, 24 Jul 2015 11:01:12 +0800
From: Eryu Guan <eguan@redhat.com>
To: Omar Sandoval <osandov@fb.com>
Cc: fstests@vger.kernel.org, linux-btrfs@vger.kernel.org,
        Wang Yanfeng <wangyf-fnst@cn.fujitsu.com>
Subject: Re: [PATCH 1/3] btrfs/011: test replace on RAID 5/6 now that it's
 supported
Message-ID: <20150724030112.GM3945@dhcp-13-216.nay.redhat.com>
References: <cover.1437683940.git.osandov@fb.com>
 <769c314845bd9341f93062204cbe435586674b1f.1437683940.git.osandov@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <769c314845bd9341f93062204cbe435586674b1f.1437683940.git.osandov@fb.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Jul 23, 2015 at 01:51:49PM -0700, Omar Sandoval wrote:
> btrfs replace has been supported on RAID 5/6 since Linux 3.19.
> 
> Signed-off-by: Omar Sandoval <osandov@fb.com>

Reviewed-by: Eryu Guan <eguan@redhat.com>

> ---
>  tests/btrfs/011 | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/tests/btrfs/011 b/tests/btrfs/011
> index f4f2fbed68d8..c7d35fa46062 100755
> --- a/tests/btrfs/011
> +++ b/tests/btrfs/011
> @@ -282,8 +282,8 @@ workout "-m dup -d single" 1 cancel quick
>  workout "-m dup -d dup -M" 1 no quick
>  workout "-m raid0 -d raid0" 2 no quick
>  workout "-m raid1 -d raid1" 2 no thorough
> -#workout "-m raid5 -d raid5" 2 no quick # not yet supported for btrfs replace
> -#workout "-m raid6 -d raid6" 3 no quick # not yet supported for btrfs replace
> +workout "-m raid5 -d raid5" 2 no quick
> +workout "-m raid6 -d raid6" 3 no quick
>  workout "-m raid10 -d raid10" 4 no quick
>  
>  echo "*** done"
> -- 
> 2.4.6
> 
> --
> To unsubscribe from this list: send the line "unsubscribe fstests" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
