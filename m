Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from eastrmfepo101.cox.net ([68.230.241.213]:37394 "EHLO
	eastrmfepo101.cox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752463Ab3AVV4z (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 22 Jan 2013 16:56:55 -0500
Received: from eastrmimpo305 ([68.230.241.237]) by eastrmfepo101.cox.net
          (InterMail vM.8.01.04.00 201-2260-137-20101110) with ESMTP
          id <20130122215655.VTKT2891.eastrmfepo101.cox.net@eastrmimpo305>
          for <linux-btrfs@vger.kernel.org>;
          Tue, 22 Jan 2013 16:56:55 -0500
Message-ID: <50FF0B26.6060508@czarc.net>
Date: Tue, 22 Jan 2013 16:56:54 -0500
From: Gene Czarcinski <gene@czarc.net>
MIME-Version: 1.0
To: linux-btrfs <linux-btrfs@vger.kernel.org>
CC: chris.mason@fusionio.com, jbacik@fusionio.com
Subject: Re: [PATCH 1/6] Fedora 18 - btrfs-init-dev-list.patch
References: <1358618781-26629-1-git-send-email-gene@czarc.net> <1358618781-26629-2-git-send-email-gene@czarc.net>
In-Reply-To: <1358618781-26629-2-git-send-email-gene@czarc.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I could not find a source for this patch on the mailing list

On 01/19/2013 01:06 PM, Gene Czarcinski wrote:
> Signed-off-by: Gene Czarcinski <gene@czarc.net>
> ---
>   utils.c | 3 ++-
>   1 file changed, 2 insertions(+), 1 deletion(-)
>
> diff --git a/utils.c b/utils.c
> index 938f9a5..51b78d5 100644
> --- a/utils.c
> +++ b/utils.c
> @@ -477,7 +477,7 @@ int btrfs_add_to_fsid(struct btrfs_trans_handle *trans,
>   	u64 num_devs;
>   	int ret;
>   
> -	device = kmalloc(sizeof(*device), GFP_NOFS);
> +	device = kzalloc(sizeof(*device), GFP_NOFS);
>   	if (!device)
>   		return -ENOMEM;
>   	buf = kmalloc(sectorsize, GFP_NOFS);
> @@ -503,6 +503,7 @@ int btrfs_add_to_fsid(struct btrfs_trans_handle *trans,
>   	device->bytes_used = 0;
>   	device->total_ios = 0;
>   	device->dev_root = root->fs_info->dev_root;
> +	INIT_LIST_HEAD(&device->dev_list);
>   
>   	ret = btrfs_add_device(trans, root, device);
>   	BUG_ON(ret);

--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-
