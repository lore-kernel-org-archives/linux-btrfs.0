Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:43924 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752179AbbKZNxn (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 26 Nov 2015 08:53:43 -0500
Date: Thu, 26 Nov 2015 14:51:57 +0100
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs-progs: mkfs: Fix a wrong extent buffer size
 causing wrong superblock csum
Message-ID: <20151126135157.GQ31035@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1448525755-1192-1-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1448525755-1192-1-git-send-email-quwenruo@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Nov 26, 2015 at 04:15:55PM +0800, Qu Wenruo wrote:
> For make_btrfs(), it's setting wrong buf size for last super block write
> out.
> The superblock size is always BTRFS_SUPER_INFO_SIZE, not
> cfg->sectorsize.
> 
> And this makes mkfs.btrfs -f -s 8K fails.
> 
> Fix it to BTRFS_SUPER_INFO_SIZE.
> 
> Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>

Already fixed in current devel (bf1ac8305ab3f191d9).

> --- a/utils.c
> +++ b/utils.c
> @@ -554,7 +554,7 @@ int make_btrfs(int fd, struct btrfs_mkfs_config *cfg)
>  	BUG_ON(sizeof(super) > cfg->sectorsize);
>  	memset(buf->data, 0, cfg->sectorsize);
>  	memcpy(buf->data, &super, sizeof(super));
> -	buf->len = cfg->sectorsize;
> +	buf->len = BTRFS_SUPER_INFO_SIZE;
>  	csum_tree_block_size(buf, BTRFS_CRC32_SIZE, 0);
>  	ret = pwrite(fd, buf->data, cfg->sectorsize, cfg->blocks[0]);

Also, this overwrites more bytes than necessary so my fix uses
BTRFS_SUPER_INFO_SIZE everywhere.

>  	if (ret != cfg->sectorsize) {
