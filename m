Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:48400 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1752381AbeGDPbe (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 4 Jul 2018 11:31:34 -0400
Date: Wed, 4 Jul 2018 17:31:32 +0200
From: David Sterba <dsterba@suse.cz>
To: Su Yue <suy.fnst@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs: fix a typo in comment of btrfs_balance
Message-ID: <20180704153132.GW3126@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20180703081629.9895-1-suy.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20180703081629.9895-1-suy.fnst@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Jul 03, 2018 at 04:16:29PM +0800, Su Yue wrote:
> The typo 'mutexe' should be 'mutex'.
> 
> Signed-off-by: Su Yue <suy.fnst@cn.fujitsu.com>
> ---
>  fs/btrfs/volumes.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
> index e034ad9e23b4..d9d87deb1160 100644
> --- a/fs/btrfs/volumes.c
> +++ b/fs/btrfs/volumes.c
> @@ -3771,7 +3771,7 @@ static inline int validate_convert_profile(struct btrfs_balance_args *bctl_arg,
>  }
>  
>  /*
> - * Should be called with balance mutexe held
> + * Should be called with balance mutex held

Well, fixing typos makes most sense for things that one would grep for
and does not want to miss. Otherwise it's better to fix them at once,
like commit 0132761017e012ab4dc8584d679503f2ba26ca86 .
