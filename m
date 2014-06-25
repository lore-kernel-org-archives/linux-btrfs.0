Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:63437 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752565AbaFYCRe (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 24 Jun 2014 22:17:34 -0400
Message-ID: <53AA313C.9010802@redhat.com>
Date: Tue, 24 Jun 2014 21:17:32 -0500
From: Eric Sandeen <sandeen@redhat.com>
MIME-Version: 1.0
To: Gui Hecheng <guihc.fnst@cn.fujitsu.com>, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 2/3] btrfs-progs: fix max mirror number error for chunk-recover
References: <1402539901-22779-1-git-send-email-guihc.fnst@cn.fujitsu.com> <1402539901-22779-2-git-send-email-guihc.fnst@cn.fujitsu.com>
In-Reply-To: <1402539901-22779-2-git-send-email-guihc.fnst@cn.fujitsu.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 6/11/14, 9:25 PM, Gui Hecheng wrote:
> When run chunk-recover on a health btrfs(data profile raid0, with
> plenty of data), the program has a chance to abort on the number
> of mirrors of an extent.
> 
> According to the kernel code, the max mirror number of an extent
> is 3 not 2:
> 	ctree.h: 		BTRFS_MAX_MIRRORS	3
> 	chunk-recover.c :	BTRFS_NUM_MIRRORS	2
> just change BTRFS_NUM_MIRRORS to 3, and everything goes well.

Wouldn't it make a lot more sense, then, to change the userspace
macro to be called BTRFS_MAX_MIRRORS as well?

-Eric

> Signed-off-by: Gui Hecheng <guihc.fnst@cn.fujitsu.com>
> ---
>  chunk-recover.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/chunk-recover.c b/chunk-recover.c
> index 9b46b0b..d5a688e 100644
> --- a/chunk-recover.c
> +++ b/chunk-recover.c
> @@ -42,7 +42,7 @@
>  #include "btrfsck.h"
>  #include "commands.h"
>  
> -#define BTRFS_NUM_MIRRORS			2
> +#define BTRFS_NUM_MIRRORS			3
>  
>  struct recover_control {
>  	int verbose;
> 

