Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:59989 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756712AbbEUQG5 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 21 May 2015 12:06:57 -0400
Date: Thu, 21 May 2015 18:06:55 +0200
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 1/2] btrfs-progs: Fix a bug in __btrfs_map_block() always
 maps wrong stripe for DUP/RAID1
Message-ID: <20150521160655.GZ23255@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1431305148-18953-1-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1431305148-18953-1-git-send-email-quwenruo@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, May 11, 2015 at 08:45:47AM +0800, Qu Wenruo wrote:
> In __btrfs_map_block(), stripe_index is always wrong if mirror_num is
> given.
> 
> For DUP/RAID1 case, if mirror_num is given, e.g. 1, it should return the
> second stripe.
> But codes consider the mirror_num is start from 1 and always minus 1,
> causing even mirror number is given as 1, __btrfs_map_block() will still
> map the first stripe not the second.
> 
> Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
> ---
>  volumes.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/volumes.c b/volumes.c
> index 16dbf64..c66c02a 100644
> --- a/volumes.c
> +++ b/volumes.c
> @@ -1397,7 +1397,7 @@ again:
> -			stripe_index = mirror_num - 1;
> +			stripe_index = mirror_num;
> @@ -1416,7 +1416,7 @@ again:
> -			stripe_index = mirror_num - 1;
> +			stripe_index = mirror_num;

The original code is same in kernel, is the logic different in the
userspace code? If yes I don't see it.
