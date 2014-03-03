Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from blu0-omc1-s23.blu0.hotmail.com ([65.55.116.34]:57171 "EHLO
	blu0-omc1-s23.blu0.hotmail.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753940AbaCCN7g convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 3 Mar 2014 08:59:36 -0500
Message-ID: <BLU0-SMTP2745244EE7D59BA5FBAB7A38B8F0@phx.gbl>
Date: Mon, 3 Mar 2014 21:53:45 +0800
From: gHcAgree <agree.ms@hotmail.com>
MIME-Version: 1.0
To: Liu Bo <bo.li.liu@oracle.com>, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 1/2] Btrfs: remove unused code in full_send_tree
References: <1393853463-26215-1-git-send-email-bo.li.liu@oracle.com>
In-Reply-To: <1393853463-26215-1-git-send-email-bo.li.liu@oracle.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


On 2014年03月03日 21:31, Liu Bo wrote:
> It's unnecessary to update key's value, and remove it to keep code clean.
>
> Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
> ---
>   fs/btrfs/send.c | 4 ----
>   1 file changed, 4 deletions(-)
>
> diff --git a/fs/btrfs/send.c b/fs/btrfs/send.c
> index 3fe4d6e..a5f9626 100644
> --- a/fs/btrfs/send.c
> +++ b/fs/btrfs/send.c
> @@ -5180,10 +5180,6 @@ static int full_send_tree(struct send_ctx *sctx)
>   		if (ret < 0)
>   			goto out;
>   
> -		key.objectid = found_key.objectid;
> -		key.type = found_key.type;
> -		key.offset = found_key.offset + 1;
> -
>   		ret = btrfs_next_item(send_root, path);
>   		if (ret < 0)
>   			goto out;
Hi Liu and all,
I think the statements may better be reserved. I noticed that there is 
an "goto join_trans" above. I think we may hit it in the next round and 
exec from the "join_trans" down, then these 3 assignments effect.

Sorry, I am not very sure whether this situation could happen, please 
ignore me if I am making noise.

-H.A.
