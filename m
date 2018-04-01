Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:53727 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753283AbeDAKKz (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 1 Apr 2018 06:10:55 -0400
Subject: Re: [PATCH] Btrfs: bail out on error during replay_dir_deletes
To: Liu Bo <bo.liu@linux.alibaba.com>, linux-btrfs@vger.kernel.org
References: <1522447918-19147-4-git-send-email-bo.liu@linux.alibaba.com>
From: Nikolay Borisov <nborisov@suse.com>
Message-ID: <06cfb7b5-4f72-3767-70c2-9b7fbd657602@suse.com>
Date: Sun, 1 Apr 2018 13:10:52 +0300
MIME-Version: 1.0
In-Reply-To: <1522447918-19147-4-git-send-email-bo.liu@linux.alibaba.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 31.03.2018 01:11, Liu Bo wrote:
> If errors were returned by btrfs_next_leaf(), replay_dir_deletes needs
> to bail out, otherwise @ret would be forced to be 0 after 'break;' and
> the caller won't be aware of it.
> 
> Signed-off-by: Liu Bo <bo.liu@linux.alibaba.com>

Reviewed-by: Nikolay Borisov <nborisov@suse.com>

This is also a long-standing bug and needs stable@
> ---
>  fs/btrfs/tree-log.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/btrfs/tree-log.c b/fs/btrfs/tree-log.c
> index 4ee9431..11e2c26 100644
> --- a/fs/btrfs/tree-log.c
> +++ b/fs/btrfs/tree-log.c
> @@ -2356,8 +2356,10 @@ static noinline int replay_dir_deletes(struct btrfs_trans_handle *trans,
>  			nritems = btrfs_header_nritems(path->nodes[0]);
>  			if (path->slots[0] >= nritems) {
>  				ret = btrfs_next_leaf(root, path);
> -				if (ret)
> +				if (ret == 1)
>  					break;
> +				else if (ret < 0)
> +					goto out;
>  			}
>  			btrfs_item_key_to_cpu(path->nodes[0], &found_key,
>  					      path->slots[0]);
> 
