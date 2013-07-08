Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:58888 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751484Ab3GHNY5 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 8 Jul 2013 09:24:57 -0400
Date: Mon, 8 Jul 2013 15:24:55 +0200
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs: Cleanup for using BTRFS_SETGET_STACK instead of
 raw convert
Message-ID: <20130708132455.GA18204@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1372989690-4880-1-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1372989690-4880-1-git-send-email-quwenruo@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Jul 05, 2013 at 10:01:30AM +0800, Qu Wenruo wrote:
> --- a/fs/btrfs/ctree.h
> +++ b/fs/btrfs/ctree.h
> @@ -2807,6 +2846,14 @@ static inline unsigned long btrfs_leaf_data(struct extent_buffer *l)
>  
>  /* struct btrfs_file_extent_item */
>  BTRFS_SETGET_FUNCS(file_extent_type, struct btrfs_file_extent_item, type, 8);
> +BTRFS_SETGET_STACK_FUNCS(stack_file_extent_bytenr,
> +			 struct btrfs_file_extent_item, disk_bytenr, 64);

Please use the struct member name in the macro name, ie.
stack_file_extent_disk_bytenr

otherwise ok,
Reviewed-by: David Sterba <dsterba@suse.cz>
