Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:52961 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751371AbdKVHG5 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 22 Nov 2017 02:06:57 -0500
Subject: Re: [PATCH v2 1/3] btrfs-progs: check: report more specific info
 about invalid location
To: Su Yue <suy.fnst@cn.fujitsu.com>, linux-btrfs@vger.kernel.org
References: <20171121101524.2014-1-suy.fnst@cn.fujitsu.com>
 <20171122021716.5957-1-suy.fnst@cn.fujitsu.com>
From: Nikolay Borisov <nborisov@suse.com>
Message-ID: <2cb57ad1-2af7-5222-9d62-5fb78333ece3@suse.com>
Date: Wed, 22 Nov 2017 09:06:55 +0200
MIME-Version: 1.0
In-Reply-To: <20171122021716.5957-1-suy.fnst@cn.fujitsu.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 22.11.2017 04:17, Su Yue wrote:
> Previously, it was so useless to print message like
> "invalid location %d".
> 
> Let it print objectid and offset of dir_item too.
> Debug is easier now.
> 
> Suggested-by: Nikolay Borisov <nborisov@suse.com>
> Signed-off-by: Su Yue <suy.fnst@cn.fujitsu.com>


Reviewed-by: Nikolay Borisov <nborisov@suse.com>

> ---
> changelog:
> v2:
> 	Print unknown location type.
> ---
>  cmds-check.c | 5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)
> 
> diff --git a/cmds-check.c b/cmds-check.c
> index a93ac2c88a38..416a7601bce1 100644
> --- a/cmds-check.c
> +++ b/cmds-check.c
> @@ -1635,8 +1635,9 @@ static int process_dir_item(struct extent_buffer *eb,
>  					  namebuf, len, filetype,
>  					  key->type, error);
>  		} else {
> -			fprintf(stderr, "invalid location in dir item %u\n",
> -				location.type);
> +			fprintf(stderr,
> +				"Unknown location type %d in DIR_ITEM[%llu %llu]\n",
> +				location.type, key->objectid, key->offset);
>  			add_inode_backref(inode_cache, BTRFS_MULTIPLE_OBJECTIDS,
>  					  key->objectid, key->offset, namebuf,
>  					  len, filetype, key->type, error);
> 
