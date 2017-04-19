Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:44314 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1765893AbdDSPl2 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 19 Apr 2017 11:41:28 -0400
Date: Wed, 19 Apr 2017 17:41:24 +0200
From: David Sterba <dsterba@suse.cz>
To: Lu Fengqi <lufq.fnst@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 1/2] btrfs-progs: dump-super: check array_size in
 print_sys_chunk_array
Message-ID: <20170419154124.GC22319@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20170405085915.21791-1-lufq.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20170405085915.21791-1-lufq.fnst@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Apr 05, 2017 at 04:59:14PM +0800, Lu Fengqi wrote:
> Without validation of array_size, the dump-super may lead to a bad
> memory access.
> 
> Signed-off-by: Lu Fengqi <lufq.fnst@cn.fujitsu.com>
> ---
>  cmds-inspect-dump-super.c | 15 +++++++++++----
>  1 file changed, 11 insertions(+), 4 deletions(-)
> 
> diff --git a/cmds-inspect-dump-super.c b/cmds-inspect-dump-super.c
> index ee2c8e3a..48b5219c 100644
> --- a/cmds-inspect-dump-super.c
> +++ b/cmds-inspect-dump-super.c
> @@ -62,16 +62,23 @@ static void print_sys_chunk_array(struct btrfs_super_block *sb)
>  	struct btrfs_key key;
>  	int item;
>  
> -	buf = malloc(sizeof(*buf) + sizeof(*sb));
> +	buf = malloc(sizeof(*buf) + BTRFS_SUPER_INFO_SIZE);

This seems to be unnecessary, the super block structure should contain
entier sys_array.

>  	if (!buf) {
>  		error("not enough memory");
> -		goto out;
> +		return;
>  	}
> -	write_extent_buffer(buf, sb, 0, sizeof(*sb));
> +	write_extent_buffer(buf, sb, 0, BTRFS_SUPER_INFO_SIZE);
>  	array_size = btrfs_super_sys_array_size(sb);
>  
>  	array_ptr = sb->sys_chunk_array;
>  	sb_array_offset = offsetof(struct btrfs_super_block, sys_chunk_array);
> +
> +	if (array_size > BTRFS_SYSTEM_CHUNK_ARRAY_SIZE) {
> +		error("sys_array_size %u shouldn't exceed %u bytes",
> +				array_size, BTRFS_SYSTEM_CHUNK_ARRAY_SIZE);
> +		goto out;
> +	}
> +
>  	cur_offset = 0;
>  	item = 0;
>  
> @@ -124,8 +131,8 @@ static void print_sys_chunk_array(struct btrfs_super_block *sb)
>  		item++;
>  	}
>  
> -	free(buf);
>  out:
> +	free(buf);
>  	return;
>  
>  out_short_read:
> -- 
> 2.12.1
> 
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
