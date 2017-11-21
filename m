Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:33763 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751115AbdKULqu (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 21 Nov 2017 06:46:50 -0500
Subject: Re: [PATCH 1/3] btrfs-progs: check: report more specific info about
 invalid location
To: Su Yue <suy.fnst@cn.fujitsu.com>, linux-btrfs@vger.kernel.org
References: <20171121101524.2014-1-suy.fnst@cn.fujitsu.com>
From: Nikolay Borisov <nborisov@suse.com>
Message-ID: <9fd908df-187d-67a1-266f-e885075d81e8@suse.com>
Date: Tue, 21 Nov 2017 13:46:48 +0200
MIME-Version: 1.0
In-Reply-To: <20171121101524.2014-1-suy.fnst@cn.fujitsu.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 21.11.2017 12:15, Su Yue wrote:
> Previously, it was so useless to print message like
> "invalid location %d".
> 
> Let it print objectid and offset of dir_item.
> Debug is easier now.
> 
> Signed-off-by: Su Yue <suy.fnst@cn.fujitsu.com>
> ---
>  cmds-check.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/cmds-check.c b/cmds-check.c
> index a93ac2c88a38..5c15dfb60b9a 100644
> --- a/cmds-check.c
> +++ b/cmds-check.c
> @@ -1635,8 +1635,8 @@ static int process_dir_item(struct extent_buffer *eb,
>  					  namebuf, len, filetype,
>  					  key->type, error);
>  		} else {
> -			fprintf(stderr, "invalid location in dir item %u\n",
> -				location.type);
> +			fprintf(stderr, "invalid location in dir item[%llu %llu]\n",
> +				key->objectid, key->offset);

I think it will be good if in addition to the dir item's key you also
print the invalid type value. I.e. this check is triggered if
location.type is unrecognizable. So the error message could be something
like :

fprintf(stderr, "Unrecognised location.type (%u) in DIR_ITEM[%llu
%llu]", key->objectid, key->offset);

Let's not force the user to go and read the code to understand why this
error happened.


>  			add_inode_backref(inode_cache, BTRFS_MULTIPLE_OBJECTIDS,
>  					  key->objectid, key->offset, namebuf,
>  					  len, filetype, key->type, error);
> 
