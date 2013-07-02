Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:57030 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752079Ab3GBRgO (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 2 Jul 2013 13:36:14 -0400
Date: Tue, 2 Jul 2013 19:36:12 +0200
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs-progs: Cleanup for using BTRFS_SETGET_STACK
 instead of raw convert
Message-ID: <20130702173612.GN18204@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1372224428-5597-1-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1372224428-5597-1-git-send-email-quwenruo@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Jun 26, 2013 at 01:27:08PM +0800, Qu Wenruo wrote:
> --- a/btrfs-convert.c
> +++ b/btrfs-convert.c
> @@ -1802,7 +1802,7 @@ static int prepare_system_chunk_sb(struct btrfs_super_block *super)
>  	btrfs_set_stack_chunk_num_stripes(chunk, 1);
>  	btrfs_set_stack_chunk_sub_stripes(chunk, 0);
>  	chunk->stripe.devid = super->dev_item.devid;

This should use the btrfs_set_* accessors too, right?

> -	chunk->stripe.offset = cpu_to_le64(0);
> +	btrfs_set_stack_stripe_offset(&chunk->stripe, 0);
>  	memcpy(chunk->stripe.dev_uuid, super->dev_item.uuid, BTRFS_UUID_SIZE);
>  	btrfs_set_super_sys_array_size(super, sizeof(*key) + sizeof(*chunk));
>  	return 0;

> --- a/btrfs-image.c
> +++ b/btrfs-image.c
> @@ -1332,7 +1332,7 @@ static void update_super_old(u8 *buffer)
>  	btrfs_set_stack_chunk_num_stripes(chunk, 1);
>  	btrfs_set_stack_chunk_sub_stripes(chunk, 0);
>  	chunk->stripe.devid = super->dev_item.devid;

same here, and there's one more in update_super().

> -	chunk->stripe.offset = cpu_to_le64(0);
> +	btrfs_set_stack_stripe_offset(&chunk->stripe, 0);
>  	memcpy(chunk->stripe.dev_uuid, super->dev_item.uuid, BTRFS_UUID_SIZE);
>  	btrfs_set_super_sys_array_size(super, sizeof(*key) + sizeof(*chunk));
>  	csum_block(buffer, 4096);
