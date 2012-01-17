From: Li Zefan <lizf@cn.fujitsu.com>
Subject: Re: [PATCH] Btrfs: do not defrag a file partially
Date: Tue, 17 Jan 2012 10:43:06 +0800
Message-ID: <4F14E03A.3040703@cn.fujitsu.com>
References: <1326709273-30384-1-git-send-email-liubo2009@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: linux-btrfs@vger.kernel.org
To: Liu Bo <liubo2009@cn.fujitsu.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1326709273-30384-1-git-send-email-liubo2009@cn.fujitsu.com>
List-ID: <linux-btrfs.vger.kernel.org>

Liu Bo wrote:
> xfstests 218 complains that btrfs defrags a file partially:
>  After: 1
>  Write backwards sync, but contiguous - should defrag to 1 extent
>  Before: 10
> -After: 1
> +After: 2
> 
> To fix this, we need to set max_to_defrag count properly.
> 
> Signed-off-by: Liu Bo <liubo2009@cn.fujitsu.com>

Reviewed-by: Li Zefan <lizf@cn.fujitsu.com>

> ---
>  fs/btrfs/ioctl.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
