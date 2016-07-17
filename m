Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:40309 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751174AbcGQUvF (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 17 Jul 2016 16:51:05 -0400
Subject: Re: [PATCH next] Btrfs: fix comparison in __btrfs_map_block()
To: =?UTF-8?Q?Vincent_Stehl=c3=a9?= <vincent.stehle@intel.com>,
        linux-btrfs@vger.kernel.org
References: <1465155145-10812-14-git-send-email-mchristi@redhat.com>
 <1468595001-4270-1-git-send-email-vincent.stehle@intel.com>
Cc: linux-block@vger.kernel.org, dm-devel@redhat.com,
        Jens Axboe <axboe@fb.com>
From: Mike Christie <mchristi@redhat.com>
Message-ID: <578BEFB7.6060209@redhat.com>
Date: Sun, 17 Jul 2016 15:51:03 -0500
MIME-Version: 1.0
In-Reply-To: <1468595001-4270-1-git-send-email-vincent.stehle@intel.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 07/15/2016 10:03 AM, Vincent Stehlé wrote:
> Add missing comparison to op in expression, which was forgotten when doing
> the REQ_OP transition.
> 
> Fixes: b3d3fa519905 ("btrfs: update __btrfs_map_block for REQ_OP transition")
> Signed-off-by: Vincent Stehlé <vincent.stehle@intel.com>
> Cc: Mike Christie <mchristi@redhat.com>
> Cc: Jens Axboe <axboe@fb.com>
> ---
> 
> 
> Hi,
> 
> I saw that issue in linux next.
> 
> Not sure if it is too late to squash the fix with commit b3d3fa519905 or
> not...
> 
> Best regards,
> 
> Vincent.
> 
> 
>  fs/btrfs/volumes.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
> index a69203a..6ee1e36 100644
> --- a/fs/btrfs/volumes.c
> +++ b/fs/btrfs/volumes.c
> @@ -5533,7 +5533,7 @@ static int __btrfs_map_block(struct btrfs_fs_info *fs_info, int op,
>  		}
>  
>  	} else if (map->type & BTRFS_BLOCK_GROUP_DUP) {
> -		if (op == REQ_OP_WRITE || REQ_OP_DISCARD ||
> +		if (op == REQ_OP_WRITE || op == REQ_OP_DISCARD ||
>  		    op == REQ_GET_READ_MIRRORS) {
>  			num_stripes = map->num_stripes;
>  		} else if (mirror_num) {
> 


Shoot. Dumb mistake by me. It is of course correct.

Reviewed-by: Mike Christie <mchristi@redhat.com>
