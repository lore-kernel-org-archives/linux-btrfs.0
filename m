Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:39290 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750724AbaLXBa5 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 23 Dec 2014 20:30:57 -0500
Message-ID: <1419384536.20397.3.camel@localhost.localdomain>
Subject: Re: [PATCH] btrfs-progs: Fix btrfs fi show by uuid and label
From: Gui Hecheng <guihc.fnst@cn.fujitsu.com>
To: Justin Maggard <jmaggard10@gmail.com>
CC: <linux-btrfs@vger.kernel.org>
Date: Wed, 24 Dec 2014 09:28:56 +0800
In-Reply-To: <1419363292-12271-1-git-send-email-jmaggard10@gmail.com>
References: <1419363292-12271-1-git-send-email-jmaggard10@gmail.com>
Content-Type: text/plain; charset="UTF-8"
MIME-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, 2014-12-23 at 11:34 -0800, Justin Maggard wrote:
> Commit 8be2fff (btrfs-progs: apply realpath for btrfs fi
> show when mount point is given) changed the behavior of
> btrfs fi show to return an error if the call to realpath()
> failed.  This broke the ability to specify a filesystem by
> uuid or label.

Oh, that's my fault, thanks for correcting this.

> So let's not consider a failed call to realpath() as an
> error.  If the user really specified a bad device, just
> return nothing like we did before.
> ---
>  cmds-filesystem.c |    9 ++-------
>  1 file changed, 2 insertions(+), 7 deletions(-)
> 
> diff --git a/cmds-filesystem.c b/cmds-filesystem.c
> index 8f037dd..a654e6f 100644
> --- a/cmds-filesystem.c
> +++ b/cmds-filesystem.c
> @@ -901,13 +901,8 @@ static int cmd_show(int argc, char **argv)
>  		 *     realpath do  /mnt/btrfs/  => /mnt/btrfs
>  		 *     which shall be recognized by btrfs_scan_kernel()
>  		 */
> -		if (!realpath(search, path)) {
> -			fprintf(stderr, "ERROR: Could not show %s: %s\n",
> -					search, strerror(errno));
> -			return 1;
> -		}
> -
> -		search = path;
> +		if (realpath(search, path))
> +			search = path;

This looks nice and stay consistent with the behavior before my faulty
commit.

Reviewed-by: Gui Hecheng <guihc.fnst@cn.fujitsu.com>

Thanks,
Gui

>  		/*
>  		 * Needs special handling if input arg is block dev And if


